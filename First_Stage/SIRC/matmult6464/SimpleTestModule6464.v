//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%					High Performance Computing Lab, Indian Institute of Technology, Bombay(IITB)		%%
//%%										Powai, Mumbai,India												%%
//%=========================================================================================================%%
// %%This is the Intellectual Property of High Performance Computing Laboratory,IIT Bombay, and hence 		%%
// %%should not be used for any monetary benefits without the proper consent of the Institute. However		%%	
// %%it can be used as reference related to academic activities. In the event of publication				%%
// %%the following notice is applicable																		%% 
// %%Copyright(c) 2013 HPC Lab,IIT Bombay.																	%%
// %%The entire notice above must be reproduced on all authorized copies.									%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%% Project Name	: Project First Phase "SIRC and EDK Based Matrix Multiplication on GF(2)"						%% 
//%% File Name		: SimpleTestModule6464.v																		%%
//%% Title 		: SIRC Hardware FSM for 1024*1024 bit Matrix Multiplication															%%
//%% Author		: Ken Eguro, Jeebu Jacob Thomas																	%%
//%% Description	:																						%%
//%% Version		: 	1.0																					%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

// Ken Eguro
//		Alpha version - 2/11/09
//		Version 1.0 - 1/4/10
//		Version 1.0.1 - 5/7/10
//		Version 1.1 - 8/1/11
// Modifications: Author: Jeebu Jacob Thomas
				  // Description: Modified the base code to make it work as a matrix multiplier capable of 32*32 GF2 multiplication
				  // Institution: IIT Bombay
				  // Date		 :04-06-2013

`timescale 1ns / 1ps
`default_nettype none

//This module demonstrates how a user can read from the parameter register file,
//	read from the input memory buffer, and write to the output memory buffer.
//We also show the basics of how the user's circuit should interact with
// userRunValue and userRunClear.
module simpleTestModuleOne #(
	//************ Input and output block memory parameters
	//The user's circuit communicates with the input and output memories as N-byte chunks
	//This should be some power of 2 >= 1.
	parameter INMEM_BYTE_WIDTH = 4,
	parameter OUTMEM_BYTE_WIDTH = 4,
	
	//How many N-byte words does the user's circuit use?
	parameter INMEM_ADDRESS_WIDTH = 11,
	parameter OUTMEM_ADDRESS_WIDTH = 11
)(
	input		wire 					clk,
	input		wire 					reset,
																														//A user application can only check the status of the run register and reset it to zero
	input		wire 					userRunValue,																//Read run register value
	output	reg					userRunClear,																//Reset run register
	
	//Parameter register file connections
	output 	reg															register32CmdReq,					//Parameter register handshaking request signal - assert to perform read or write
	input	wire 															register32CmdAck,					//Parameter register handshaking acknowledgment signal - when the req and ack ar both true fore 1 clock cycle, the request has been accepted
	output 	wire 		[31:0]											register32WriteData,				//Parameter register write data
	output 	reg		[7:0]												register32Address,				//Parameter register address
	output	wire 															register32WriteEn,				//When we put in a request command, are we doing a read or write?
	input 	wire 															register32ReadDataValid,		//After a read request is accepted, this line indicates that the read has returned and that the data is ready
	input 	wire 		[31:0]											register32ReadData,				//Parameter register read data

	//Input FIFO connections
	output 	reg															inputMemoryReadReq,				//Input memory handshaking request signal - assert to begin a read request
	input	wire 															inputMemoryReadAck,				//Input memory handshaking acknowledgement signal - when the req and ack are both true for 1 clock cycle, the request has been accepted
	output	reg		[(INMEM_ADDRESS_WIDTH - 1):0] 			inputMemoryReadAdd,				//Input memory read address - can be set the same cycle that the req line is asserted
	input 	wire 															inputMemoryReadDataValid,		//After a read request is accepted, this line indicates that the read has returned and that the data is ready
	input	wire 		[((INMEM_BYTE_WIDTH * 8) - 1):0] 		inputMemoryReadData,				//Input memory read data
	
	//Output memory connections
	output 	reg															outputMemoryWriteReq,			//Output memory handshaking request signal - assert to begin a write request
	input 	wire 															outputMemoryWriteAck,			//Output memory handshaking acknowledgement signal - when the req and ack are both true for 1 clock cycle, the request has been accepted
	output	reg		[(OUTMEM_ADDRESS_WIDTH - 1):0] 			outputMemoryWriteAdd,			//Output memory write address - can be set the same cycle that the req line is asserted
	output	reg		[((OUTMEM_BYTE_WIDTH * 8) - 1):0]		outputMemoryWriteData,			//Output memory write data
	output 	wire 		[(OUTMEM_BYTE_WIDTH - 1):0]				outputMemoryWriteByteMask,		//Allows byte-wise writes when multibyte words are used - each of the OUTMEM_USER_BYTE_WIDTH line can be 0 (do not write byte) or 1 (write byte)

	//8 optional LEDs for visual feedback & debugging
	output	reg 		[7:0]												LED,		
		output reg led1,led2,led3,led4,led5
);
	//FSM states
	localparam  IDLE 					= 	0;							// Waiting
	localparam  READING_IN_PARAMETERS 	= 	1;	// Get values from the reg32 parameters
	localparam  RUN 					= 	2;							// Run (read from input, compute and write to output)
	localparam COMPUTE1 				=	3;
	localparam COMPUTE2 				= 	4;
	localparam COMPUTE3 				=	5;
	localparam FILLOUTPUTFIFO 			= 	6;
	localparam OUTPUTRESULT 			=	7;
	localparam DISPLAYCOUNT 			= 	8;
	//Signal declarations
	//State registers
	reg [3:0] currState;
	// reg [5:0] blocks_computed; // To calculate the blocks calculated.  There should be a total of 32+1= 33 block each of size 32*32
	//Counter
	reg paramCount;
	
	//Message parameters
	reg [31:0] length;
	reg [31:0] multiplier;

	wire [31:0] lengthMinus1;
	assign lengthMinus1 = length - 1;

	// We don't write to the register file and we only write whole bytes to the output memory
	assign register32WriteData = 32'd0;
	assign register32WriteEn = 0;
	assign outputMemoryWriteByteMask = {OUTMEM_BYTE_WIDTH{1'b1}};
	
	//Variables for execution
	reg [12:0] lastPendingReads;//******************** CHANGE THIS ACC TO MAX FIFO SIZE
	wire [12:0] currPendingReads;//******************** CHANGE THIS ACC TO MAX FIFO SIZE
	wire [((INMEM_BYTE_WIDTH * 8) - 1):0] inputFifoDataOut;
	wire [((OUTMEM_BYTE_WIDTH * 8) - 1):0] outputFifoDataOut;
	wire inputFifoEmpty;
	wire outputFifoEmpty;
	wire [12:0] inputFifoCount; //******************** CHANGE THIS ACC TO MAX FIFO SIZE
	wire [12:0] outputFifoCount; //******************** CHANGE THIS ACC TO MAX FIFO SIZE
	wire infifoRead;
	wire outfifoRead;
	wire inFifoReadDataValid;
	
	wire	[(INMEM_ADDRESS_WIDTH - 1):0] nextInputAddress;
	reg inputDone;
	reg [31:0] countNumberOfCycles;
	wire [63:0] dataoutFIFO;
	////////////////////////////////Additions to Matrix Multiplication Unit///////////////////////////////////////////////////////////////////////////////
	

	reg transpose_f,oa1_datainsel,oa2_datainsel;
	reg[6:0]  counter, counter1, counter2,counter3, blocks_computed;
	reg OA1_rstn,OA2_rstn,tran_rstn;  // Active Low Reset Signals for transpose and OA blocks
	wire [63:0] oa1_out32,oa2_out32,transpose_out;
	reg collect_resultOA1,collect_resultOA2;
	reg OAcount,oa1_en_data,oa2_en_data;
	wire WriteOutputFifo;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	// Additions made for the application - GFMT
	// localparam N=32;
	// reg [N-1:0] a_;
	// reg [N-1:0] a;
	// reg [2:0] nn;
 
	// wire [N-1:0] result;
	// reg clk_en;
	// reg collect_result;
	// reg start;
	// wire done;
	// reg [5:0] counter, counter_;
	
	// wire rst_n;
   // reg xyz;
	// end of Additions made for the application - GFMT
	//Additions made for the application - GFMM
	
	// reg [N-1:0] a1_;
	// wire [N-1:0] a1;
	// reg [N-1:0] b1_;
	// wire [N-1:0] b1;
	// reg [2:0] nn1;
 
	// wire [N-1:0] result1;
	// reg clk_en1;
	// reg collect_result1;
	// reg start1;
	// wire done1;
	// reg [5:0] counter1, counter1_;
	// reg xyz1;
	// assign rst_n = ~reset;
	// end of Additions made for the application - GFMM
	initial begin
		LED 	<= 8'h0;
		currState = IDLE;
		length = 0;
		
		userRunClear = 0;
		
		register32Address = 0;
		
		inputMemoryReadReq = 0;
		inputMemoryReadAdd = 0;
	
		outputMemoryWriteReq = 0;
		outputMemoryWriteAdd = 0;
		outputMemoryWriteData = 0;
		
		paramCount = 0;
		lastPendingReads = 0;
		inputDone = 0;
		/// For Matrix Multiplication/////
		countNumberOfCycles = 0;
		OA1_rstn			= 0; // reset active
		OA2_rstn			= 0; // reset active
		tran_rstn			= 0; // reset active
		transpose_f			= 0;
		oa1_datainsel		= 0;
		oa2_datainsel		= 0;
		counter 			= 0;
		counter1 			= 0;
		counter2 			= 0;
		counter3			= 0;
		blocks_computed		= 0;
		collect_resultOA1	= 0;
		collect_resultOA2   = 0;
		OAcount				= 0;
		oa1_en_data			= 0;
		oa2_en_data			= 0;	
		
		
		//Additions made for the application - GFMT
		// nn = 3;
		// counter_ = 0;
		// collect_result = 0;
		// start =0;
		// xyz = 0;
		// end of Additions made for the application - GFMT
		//Additions made for the application - GFMM
		// start1 = 0;
		// clk_en1 = 0;
		// nn1 = 3;
		// counter1_ = 0;
		// collect_result1 = 0;
		// xyz1 =0;
		// countNumberOfCycles = 0;
	 // end of Additions made for the application - GFMM
	end

	always @(posedge clk) 
	begin
		if(reset) begin
			LED 	<= 8'h0;
			currState <= IDLE;
			length <= 0;
			countNumberOfCycles <= 0;
			userRunClear <= 0;
			
			register32Address <= 0;
			
			inputMemoryReadReq <= 0;
			inputMemoryReadAdd <= 0;
			
			outputMemoryWriteReq <= 0;
			outputMemoryWriteAdd <= 0;
			outputMemoryWriteData <= 0;
			
			paramCount <= 0;
			lastPendingReads <= 0;
			inputDone <= 0;
			/// Matrix Multiplication Parameters///
			/////////Matrix Multiplication Paramerters////////////
			countNumberOfCycles <= 0;
			OA1_rstn			<= 0; // reset active
			OA2_rstn			<= 0; // reset active
			tran_rstn			<= 0;// reset active
			transpose_f			<= 0;
			oa1_datainsel		<= 0;
			oa2_datainsel		<= 0;
			counter 			<= 0;
			counter1 			<= 0;
			counter2 			<= 0;
			counter3			<= 0;
			blocks_computed		<= 0;
			collect_resultOA1	<= 0;
			collect_resultOA2   <= 0;
			OAcount				<= 0;
			oa1_en_data			= 0;
			oa2_en_data			= 0;
	/////////////////////////////////////////////////////			
			
	///////////////////////////FSM Begins Here/////////////////////////////////////
		end
		else begin
			case(currState)
				IDLE: 
				begin
			
					//Stop trying to clear the userRunRegister
					userRunClear <= 0;
					inputMemoryReadReq <= 0;
					OA1_rstn			<= 0; // reset active
					OA2_rstn			<= 0; // reset active
					tran_rstn			<= 0;// reset active
					countNumberOfCycles <= 0;
					
					//Wait till the run register goes high
					if(userRunValue == 1 && userRunClear != 1) 
					begin
						//Start reading from the register file
						//countNumberOfCycles <= countNumberOfCycles + 1;
						currState <= READING_IN_PARAMETERS;
						register32Address <= 0;
						register32CmdReq <= 1;
						paramCount <= 0;
					end
				end
				READING_IN_PARAMETERS: 
				begin
					LED[0] <= 1;
					countNumberOfCycles <= countNumberOfCycles + 1;
					//We need to read 2 values from the parameter register file.
					//If the register file accepted the read, increment the address
					if(register32CmdAck == 1 && register32CmdReq == 1) 
					begin
						register32Address <= register32Address + 1;
					end
					
					//If we just accepted a read from address 1, stop requesting reads
					if(register32CmdAck == 1 && register32Address == 8'd1)
					begin
						register32CmdReq <= 0;
					end
	
					//If a read came back, shift in the value from the register file
					if(register32ReadDataValid) 
					begin
							length <= multiplier;
							multiplier <= register32ReadData;
							paramCount <= 1;
							
							//Have we recieved the read for the second register?
							if(paramCount == 1)
							begin
								//Start requesting input data and execution
								currState <= RUN;
								inputMemoryReadReq <= 1;
								inputMemoryReadAdd <= 0;
								outputMemoryWriteAdd <= 0;
								inputDone <= 0;
							end
					end
				end
				RUN: 
				begin
					LED[1] <= 1;					countNumberOfCycles <= countNumberOfCycles + 1;
					//Logic to feed FIFO
					//If there is enough space in the fifo and there are more values to read, try to request a read the
					// next clock cycle
					if((currPendingReads + inputFifoCount < 1088) && inputDone == 0) 
					begin //1088 = 1024+64
						inputMemoryReadReq <= 1;
					end
					else begin
						inputMemoryReadReq <= 0;
					end
					
					//If the input memory accepted the last read, we can increment the address
					if(inputMemoryReadReq == 1 && inputMemoryReadAck == 1 && inputMemoryReadAdd != lengthMinus1[(INMEM_ADDRESS_WIDTH - 1):0])
					begin
						inputMemoryReadAdd <= inputMemoryReadAdd + 1;
					end
					else if(inputMemoryReadReq == 1 && inputMemoryReadAck == 1 && inputMemoryReadAdd == lengthMinus1[(INMEM_ADDRESS_WIDTH - 1):0])
					begin
						inputDone <= 1;
					end
					
					if(inputMemoryReadReq == 0 && inputMemoryReadAdd == lengthMinus1[(INMEM_ADDRESS_WIDTH - 1):0])
					begin
						currState<=COMPUTE1;
						/*outputMemoryWriteReq <= 0;
						outputMemoryWriteAdd <= 0;
						outputMemoryWriteData <= 0;*/
					end
					
					lastPendingReads <= currPendingReads;
				end
				
				COMPUTE1: // Transpose Block Starts here
				begin
					LED[2] <= 1;
					countNumberOfCycles <= countNumberOfCycles + 1;
					
					
					if(counter == 64) 
					begin 
						tran_rstn 			<= 1;
						OA1_rstn 			<= 1;  // Deactivate the reset
						OA2_rstn 			<= 1;  // Deactivate the reset
						oa1_en_data			= 1;
						oa2_en_data			= 1;
						counter 			<= 0;
						currState 			<= COMPUTE2;
						transpose_f 		<= 1;
						collect_resultOA1	<= 0; // From where the Output FIFO needs to filled 
						collect_resultOA2	<= 1; // From where the Output FIFO needs to filled 
						oa1_datainsel 		<= 0; // First OA should compute and the second OA should deliver output 
						oa2_datainsel 		<= 1; // 
						counter1 <= counter1 + 1;
					end
					else begin
					
					transpose_f 	<=0; // Transpose Unit is pushing the elements down
					tran_rstn 		<=1; // Deactivate the reset
					OA1_rstn 		<=0;  // Activate the reset
					OA2_rstn 		<=0;  // Activate the reset
					oa1_en_data		= 0;  // Enable the data for OA Blocks
					oa2_en_data		= 0;
					collect_resultOA1	<= 0; // From where the Output FIFO needs to filled 
					collect_resultOA2	<= 1; // From where the Output FIFO needs to filled 
					oa1_datainsel 		<= 0; // First OA should compute and the second OA should deliver output 
					oa2_datainsel 		<= 1; // 
					counter 		<= counter + 1;
					end 	 
				end
				
				COMPUTE2: // Both the transpose block and OA blocks work here, ie one OA is computing and the other OA block is giving the result
				begin
					LED[3] <= 1;
					countNumberOfCycles <= countNumberOfCycles + 1;
					oa1_en_data	= 1;
					oa2_en_data	= 1;		 
							
							if(counter1 == 64)
							begin
								tran_rstn 			<= 1;
								OA1_rstn 			<= 1;  // Deactivate the reset
								OA2_rstn 			<= 1;  // Deactivate the reset
								oa1_datainsel 		<= 1;  // OA1 block should start giving output	
								oa2_datainsel 		<= 0;  // OA2 block starts doing xoring(accumulation)
								counter1 			<= 0;
								collect_resultOA1	<= 1;  // Get output from OA1	
								collect_resultOA2	<= 0;  
								if(blocks_computed == 15) // Since we are focussed on 1024 matrix calculation no of blocks = 1024
								begin
									currState<=FILLOUTPUTFIFO; // Compuation is done, just that the final 32 outputs in OA1 needs to be copied to FIFO 
									oa1_en_data	= 0;
									oa2_en_data	= 0;
									counter3	<= counter3 + 1; // For the FILL FIFO
									// collect_resultOA1	<= ~collect_resultOA1;  // Get output from OA1	
									// collect_resultOA2	<= ~collect_resultOA2;  
									
								end
								else begin 
									blocks_computed <= blocks_computed + 1;
									currState		<=COMPUTE3;
									counter2 		<= counter2 + 1;
								end 	
							end else // Keep doing the same, and fill the output FIFOS from the correct space
							begin
							
								transpose_f 	<= 1;
								oa1_datainsel 	<= 0;
								oa2_datainsel 	<= 1;
								counter1 		<= counter1 + 1;	
								// if(collect_resultOA1 == 0 && collect_resultOA2 == 1 && OAcount != 0) 
								// begin
								// The logic of OAcount is that, the first set of output from OA1 is just zeros from the reset value, which we dont require to load to FIFO
									// outputfifo 	<= oa2_out32 ;
								// end 
							end	
				end		
				COMPUTE3: // Both the transpose block and OA blocks work here, ie one OA is computing and the other OA block is giving the result
				begin
					LED[4] <= 1;
					countNumberOfCycles <= countNumberOfCycles + 1;
					OAcount 	<= 1;	
					oa1_en_data	= 1;
					oa2_en_data	= 1;
							
					if(counter2 == 64)
					begin
					
						oa1_datainsel 		<= 0;
						oa2_datainsel 		<= 1;
						collect_resultOA1	<= 0;
						collect_resultOA2	<= 1;
						counter2 			<= 0;
						if(blocks_computed == 15) 
						begin // Since we are focussed on 1024 matrix calculation no of blocks = 1024
							currState<=FILLOUTPUTFIFO; // Compuation is done, just that the final 32 outputs in OA2 needs to be copied to FIFO 
							oa1_en_data	= 0;
							oa2_en_data	= 0;
							counter3	<= counter3 + 1; // For the FILL FIFO
							// collect_resultOA1	<= ~collect_resultOA1;  // Get output from OA1	
							// collect_resultOA2	<= ~collect_resultOA2;  
							
						end else 
						begin
							blocks_computed <= blocks_computed + 1;
							currState	<=COMPUTE2;
							counter1 	<= counter1 + 1;
						end 	
					end else // Keep doing the same, and fill the output FIFOS from the correct space
					begin
						transpose_f 	<= 1;
						oa1_datainsel 	<= 1;
						oa2_datainsel 	<= 0;
						counter2 		<= counter2 + 1;	
						// if(collect_resultOA1 == 1 && collect_resultOA2 == 0) 
						// begin
							// outputfifo 	<= oa1_out32 ;
						// end 
					
					end 
				end
				
		
				
				
				FILLOUTPUTFIFO : // This module is to fill the remaining last 32 words of data from OA block into the FIFO
					begin
						LED[5] <= 1;
						countNumberOfCycles <= countNumberOfCycles + 1;
						if(counter3 == 64) 
						begin 
							tran_rstn 			<= 0;
							OA1_rstn 			<= 0;  // activate the reset
							OA2_rstn 			<= 0;  // activate the reset
							counter3			<= 0;
							collect_resultOA1	<= 0;  // Get output from OA1	
							collect_resultOA2	<= 0;  
							currState <= OUTPUTRESULT;
						end else
						begin
							counter3	<= counter3 + 1;
							
						
						end
						///////////////////////////////Testing Zone//////////////////////////////
						
						// currState <= IDLE; // Delete after testing
						// userRunClear <= 1;
						//////////////////////////////Testing Zone ends here/////////////////////
					end	
				
				
				OUTPUTRESULT:
				begin
					LED[6] <= 1;
					countNumberOfCycles <= countNumberOfCycles + 1;
														//Logic on output side of FIFO
														//We should read from the input fifo if 
														// 1) the input fifo is not empty this cycle AND
														// 2) the output data is not currently valid or if we are writing the value this cycle
					if(outfifoRead == 1) 
					begin
														//If we are reading from the fifo this cycle, update the output registers.
						outputMemoryWriteReq <= 1;
						outputMemoryWriteData <= outputFifoDataOut;
														//outputMemoryWriteData <= (inputFifoDataOut * multiplier) % 256;
					end
														//If we are not reading from the fifo this cycle, but we are are writing this cycle, then stop writing
					else if(outputMemoryWriteReq == 1  && outputMemoryWriteAck == 1) 
					begin
						outputMemoryWriteReq <= 0;
														//Are we done with all of the values yet?
														//if(outputMemoryWriteAdd == lengthMinus1[(OUTMEM_ADDRESS_WIDTH - 1):0]) begin
						if(outputMemoryWriteAdd == 11'b01111111111) 
						begin
														//If we just wrote the last output, go back to being idle
							currState <= DISPLAYCOUNT;
							// LED[7] <= 1;
							
							// userRunClear <= 1;							//userRunClear <= 1;
						end
					end

														//If we just wrote a value to the output memory this cycle, increment the address
					if(outputMemoryWriteReq == 1  && outputMemoryWriteAck == 1 && outputMemoryWriteAdd != lengthMinus1[(OUTMEM_ADDRESS_WIDTH - 1):0]) begin
						outputMemoryWriteAdd <= outputMemoryWriteAdd + 1;
					end
					
					
				end
				
				DISPLAYCOUNT : 
				begin
					LED[7] <= 1;
					outputMemoryWriteAdd <= 11'b10000000000;
					outputMemoryWriteReq <= 1;
					outputMemoryWriteData <= countNumberOfCycles;
						if(outputMemoryWriteReq == 1  && outputMemoryWriteAck == 1) 
						begin
							outputMemoryWriteReq <= 0;
							currState <= IDLE;
							userRunClear <= 1;
						end
				
				
				end
			endcase
		end
	end
	
	//The current number of pending reads is:
	//	1) the last number of pending reads +1 if the memory is currently accepting a read request
	// 2) the last number of pending reads -1 if the memory is currently providing valid data
	// 3) the last number of pending reads if neither or both conditions are met.
	assign currPendingReads = ((inputMemoryReadReq == 1 && inputMemoryReadAck == 1) ~^ inputMemoryReadDataValid) ? lastPendingReads:
										((inputMemoryReadReq == 1 && inputMemoryReadAck == 1) ? lastPendingReads + 1 : lastPendingReads - 1);

	//We should read from the input fifo if 
	// 1) the input fifo is not currently empty and
	// 2) the output data is not currently valid or if we are writing the value this cycle
	// assign LED[7:0] =(currState == FILLOUTPUTFIFO)?8'b00001111:((currState == OUTPUTRESULT)?8'b11110000:8'b00000000);
	//assign LED[7:0] = (outfifoRead==1)?8'b00001111:8'b11110000;
	//assign LED[7:0] = outputMemoryWriteAdd[7:0]; 
	// assign LED[7:0] = (currState == FILLOUTPUTFIFO)?8'b01010101:((currState == OUTPUTRESULT)?8'b11110000:8'b00000000);
	

	
	// assign led1 = outputMemoryWriteReq;
	// assign led2 = outputMemoryWriteAck;
	// assign led3 = outfifoRead;
	// assign led4 = outputFifoEmpty;
	// assign led5 = inFifoReadDataValid;
	assign outfifoRead = ((outputMemoryWriteReq == 0) || (outputMemoryWriteReq == 1  && outputMemoryWriteAck == 1)) && (outputFifoEmpty == 0) && (currState == OUTPUTRESULT);
   //assign inFifoReadDataValid = (currState == FILLOUTPUTFIFO);
	//assign infifoRead = (currState == FILLOUTPUTFIFO);
	
	/////////////////Change this to suit to our needs/////////////////////// Jeebu Jacob Thomas
	// assign infifoRead = ((counter_ >= 6'd1)&&(counter_ <= 6'd32)&&(currState == COMPUTE))||((xyz==1)&&(counter1_ <= 6'd32)&&(currState == COMPUTE2));
	// assign WriteOutputFifo = (xyz1==1)&&(currState == FILLOUTPUTFIFO);
	assign infifoRead = (currState == COMPUTE1 || currState == COMPUTE2 || currState == COMPUTE3);
	assign WriteOutputFifo = (currState == COMPUTE2 && OAcount != 0)  || currState == COMPUTE3  || currState == FILLOUTPUTFIFO;
	// assign WriteOutputFifo = (currState == COMPUTE2 || currState == COMPUTE3 || currState == FILLOUTPUTFIFO);
	
	// Addition on Output Muxing// Jeebu Jacob Thomas
	assign dataoutFIFO = (collect_resultOA1 == 1 && collect_resultOA2 == 0 )? oa1_out32<<1 : ((collect_resultOA1 == 0 && collect_resultOA2 == 1)? oa2_out32<<1 : 0);
	
	// assign b1 = inputFifoDataOut; // Commented from main code||Jeebu Jacob 
	// assign a1 = result;
	//We need to be able to buffer up to 4 values from the input memory.
	//Even if we stop requesting new values, pending reads will come back and we need to put them somewhere 
	FIFO #(.WIDTH((INMEM_BYTE_WIDTH * 8)),.LOGDEPTH(11))inFIFO(
			.clk(clk),
			.reset(reset),
			.dataIn(inputMemoryReadData),
			.dataInWrite(inputMemoryReadDataValid),
			.dataOut(inputFifoDataOut),
			.dataOutRead(infifoRead),
			.empty(inputFifoEmpty),
			.currCount(inputFifoCount));
			  
			
	FIFO #(.WIDTH((OUTMEM_BYTE_WIDTH * 8)),.LOGDEPTH(11))outFIFO(
			.clk(clk),
			.reset(reset),
			.dataIn(dataoutFIFO),
			.dataInWrite(WriteOutputFifo),
			.dataOut(outputFifoDataOut),
			.dataOutRead(outfifoRead),
			.empty(outputFifoEmpty),
			.currCount(outputFifoCount));
			
//////////////////////Instantiations of the transpose and Outer Accumulator Blocks//////////////////
	mkOA OA1	(	
				.CLK(clk),
				.RST_N(OA1_rstn),
				.data_in_x(transpose_out),
				.data_in_y(inputFifoDataOut),
				.data_in_sel(oa1_datainsel),
				.EN_data_in(oa1_en_data),
				.o_out(oa1_out32)
				);
	mkOA OA2	(	
				.CLK(clk),
				.RST_N(OA2_rstn),
				.data_in_x(transpose_out),
				.data_in_y(inputFifoDataOut),
				.data_in_sel(oa2_datainsel),
				.EN_data_in(oa2_en_data),
				.o_out(oa2_out32)
				);		
	mkTranspose T(
				.CLK(clk),
				.RST_N(tran_rstn),
				.a_in_m(inputFifoDataOut),
				.o_out(transpose_out),
				.b_in_f(transpose_f)
				 );			
			
endmodule

//We need to be able to buffer up to N values from the input memory.
//Even if we stop requesting new values, pending reads will come back and we need to put them somewhere 
//In this case, we will make N = 4.
module FIFO#(
	parameter WIDTH = 8,
	parameter LOGDEPTH = 2
)(	input 	wire 							clk,
	input 	wire 							reset,
	input 	wire [(WIDTH - 1): 0] 	dataIn,
	input 	wire 							dataInWrite,
	output 	wire [(WIDTH - 1): 0]	dataOut,
	input 	wire 							dataOutRead,
	output	wire 							empty,
	output 	wire [(LOGDEPTH-1):0] 	currCount);
	parameter DEPTH = 1<<LOGDEPTH;
	//Make an array of WIDTH-sized registers
	reg [(WIDTH - 1): 0] mem [0:(DEPTH-1)];
	reg [(LOGDEPTH-1):0] readAdd;
	reg [(LOGDEPTH-1):0] writeAdd;
	
	reg [(LOGDEPTH-1):0] count;
	
	initial begin
		count = 0;
		readAdd = 0;
		writeAdd = 0;
	end
	always@(posedge clk) begin
		if(reset)begin
			count <= 0;
			readAdd <= 0;
			writeAdd <= 0;
		end
		else begin
			if(dataInWrite == 1) begin
				writeAdd <= writeAdd + 1;
				mem[writeAdd] <= dataIn;
			end
			if(dataOutRead == 1) begin
				readAdd <= readAdd + 1;
			end
			count <= currCount;
		end
	end
	
	assign currCount = (dataInWrite == 1 && dataOutRead == 0 && count != (DEPTH-1)) ? (count + 1):
								((dataInWrite == 0 && dataOutRead == 1 && count != 0) ? (count - 1) : count);
	assign empty = (count == 0 && dataInWrite != 1);
	assign dataOut = (count == 0) ? dataIn : (mem[readAdd]);
endmodule
	