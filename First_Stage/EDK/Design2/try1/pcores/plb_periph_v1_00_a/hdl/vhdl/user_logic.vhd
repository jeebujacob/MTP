-- //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- //%%			High Performance Computing Lab, Indian Institute of Technology, Bombay(IITB)		%%
-- //%%										Powai, Mumbai,India												%%
-- //%=========================================================================================================%%
-- // %%This is the Intellectual Property of High Performance Computing Laboratory,IIT Bombay, and hence 		%%
-- // %%should not be used for any monetary benefits without the proper consent of the Institute. However		%%	
-- // %%it can be used as reference related to academic activities. In the event of publication				%%
-- // %%the following notice is applicable																		%% 
-- // %%Copyright(c) 2013 HPC Lab,IIT Bombay.																	%%
-- // %%The entire notice above must be reproduced on all authorized copies.									%%
-- //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- 
-- //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- //%% Project Name	: Project First Phase "SIRC and EDK Based Matrix Multiplication on GF(2)"						%% 
-- //%% File Name	: user_logic.vhd																		%%
-- //%% Title 		: Hardware FSM for multiplying 32 rows * 32bits  with a row matrix of size 1024 rows *32 bit														%%
-- //%% Author		: Jeebu Jacob Thomas																	%%
-- //%% Description	:																						%%
-- //%% Version		: 00																					%%
-- //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Fri Sep 27 16:43:16 2013 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- Co Author	: Jeebu Jacob Thomas
-- Institution  : IIT Bombay
-- Date			: 30-09-2013
-- Description 	: This is a peripheral performing Matrix Multiplication on 1021*1024 matrices using a 32*32 multiplier

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_SLV_AWIDTH                 -- Slave interface address bus width
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--   C_NUM_REG                    -- Number of software accessible registers
--   C_NUM_MEM                    -- Number of memory spaces
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Addr                  -- Bus to IP address bus
--   Bus2IP_CS                    -- Bus to IP chip select for user logic memory selection
--   Bus2IP_RNW                   -- Bus to IP read/not write
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   Bus2IP_Burst                 -- Bus to IP burst-mode qualifier
--   Bus2IP_BurstLength           -- Bus to IP burst length
--   Bus2IP_RdReq                 -- Bus to IP read request
--   Bus2IP_WrReq                 -- Bus to IP write request
--   IP2Bus_AddrAck               -- IP to Bus address acknowledgement
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32;
    C_NUM_REG                      : integer              := 4;
    C_NUM_MEM                      : integer              := 2
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Reset                   : in  std_logic;
    Bus2IP_Addr                    : in  std_logic_vector(0 to C_SLV_AWIDTH-1);
    Bus2IP_CS                      : in  std_logic_vector(0 to C_NUM_MEM-1);
    Bus2IP_RNW                     : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(0 to C_SLV_DWIDTH-1);
    Bus2IP_BE                      : in  std_logic_vector(0 to C_SLV_DWIDTH/8-1);
    Bus2IP_RdCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
    Bus2IP_WrCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
    Bus2IP_Burst                   : in  std_logic;
    Bus2IP_BurstLength             : in  std_logic_vector(0 to 8);
    Bus2IP_RdReq                   : in  std_logic;
    Bus2IP_WrReq                   : in  std_logic;
    IP2Bus_AddrAck                 : out std_logic;
    IP2Bus_Data                    : out std_logic_vector(0 to C_SLV_DWIDTH-1);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Reset  : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal slv_reg0                       : std_logic_vector(0 to C_SLV_DWIDTH-1); --This register is for the Application side to let the hardware know about whether the computation should
																				 -- begin or not		
  signal slv_reg1                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg2                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg3                       : std_logic_vector(0 to C_SLV_DWIDTH-1); -- This register is a hardware register marking end of computation
  signal slv_reg_write_sel              : std_logic_vector(0 to 3);
  signal slv_reg_read_sel               : std_logic_vector(0 to 3);
  signal slv_ip2bus_data                : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;

  ------------------------------------------
  -- Signals for user logic memory space example
  ------------------------------------------
  -- type BYTE_RAM_TYPE is array (0 to 255) of std_logic_vector(0 to 7);
  type DO_TYPE is array (0 to C_NUM_MEM-1) of std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal mem_data_out                   : DO_TYPE;
  signal mem_address                    : std_logic_vector(0 to 10);
  signal mem_select                     : std_logic_vector(0 to 1);
  signal mem_read_enable                : std_logic;
  signal mem_ip2bus_data                : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal mem_read_ack_dly1              : std_logic;
  signal mem_read_ack                   : std_logic;
  signal mem_write_ack                  : std_logic;
  
   ---------------------signals for OA block and Transpose block----
  
  type states is (IDLE,TRANSPOSE,COMPUTE1,COMPUTE2,FILLER);
  type ram is array (0 to 2047) of std_logic_vector(0 to 31); -- 1056 because of input memory requirement(1024+32=1056)
  signal present_state 				: states;
  signal mem0							: ram;
  signal mem1   						: ram;
  signal mem0_write						: std_logic;
  signal mem1_write 					: std_logic;
  signal OAout_enable 					: std_logic;
  signal srst_oa1_n,srst_oa2_n			: std_logic;
  signal srst_tran_n 					: std_logic;
  signal sdata1_in_sel					: std_logic;
  signal sdata2_in_sel					: std_logic;
  signal sen_data1_in					: std_logic;
  signal sen_data2_in,s_b_in_f			: std_logic;
  signal s_RDY_o_out 					: std_logic;   
  signal countNumberOfCycles 			: std_logic_vector(0 to 31);
  signal s_o_out 						: std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal matdatain						: std_logic_vector(0 to C_SLV_DWIDTH-1); --32 bit  matrix data inputofcourse
  signal read_address1 					: std_logic_vector(0 to 10);
  signal read_address2 					: std_logic_vector(0 to 10);
  signal matdataout						: std_logic_vector(0 to C_SLV_DWIDTH-1); --32 bit ofcourse
  signal matdataout1,matdataout2		: std_logic_vector(0 to C_SLV_DWIDTH-1);	 
  signal address_value_in 				: std_logic_vector(0 to 10); -- It should write the 1024  matrix results
  signal address_value_out 				: std_logic_vector(0 to 10); -- It should write the 1024  matrix results
 
 
  signal blocks_computed 		: integer;
  signal hw_count1,hw_count2,hw_count3,hw_count4 : integer; -- Counts upto max of 31
  constant blocks_max			: integer := 31; -- Total of 32 block to be computed
 
   
  -------------Instantitations of the Matrix Multiplier Blocks----- 
  
  component mkOA is 
	port(
			o_out         : out std_logic_vector(0 to 31);   
			RDY_o_out     : out std_logic;
			CLK           : in std_logic;
			RST_N         : in std_logic; -- Low Level
			data_in_x     : in std_logic_vector(0 to 31) ; 
			data_in_y     : in std_logic_vector(0 to 31);  
			data_in_sel   : in std_logic;
			EN_data_in    : in std_logic
		);
	end component;	
  
  component mkTranspose is 
	port(
			o_out         : out std_logic_vector(0 to 31);
			RDY_o_out     : out std_logic;
			CLK           : in std_logic;
			RST_N         : in std_logic; -- Low Level
			a_in_m        : in std_logic_vector(0 to 31);
			b_in_f        : in std_logic
		);
	end component;	
   
  
  

begin

  --USER logic implementation added here

  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic,
  -- you are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  --                     "1000"   C_BASEADDR + 0x0
  --                     "0100"   C_BASEADDR + 0x4
  --                     "0010"   C_BASEADDR + 0x8
  --                     "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_sel <= Bus2IP_WrCE(0 to 3);
  slv_reg_read_sel  <= Bus2IP_RdCE(0 to 3);
  -- slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3);
  slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2);
  slv_read_ack      <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3);

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Reset = '1' then
        slv_reg0 <= (others => '0');
        slv_reg1 <= (others => '0');
        slv_reg2 <= (others => '0');
        -- slv_reg3 <= (others => '0');-- This is the hardware register
      else
        case slv_reg_write_sel is
          when "1000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg0(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "0100" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg1(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "0010" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg2(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          -- when "0001" =>
            -- for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              -- if ( Bus2IP_BE(byte_index) = '1' ) then
                -- slv_reg3(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              -- end if;
            -- end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, slv_reg0, slv_reg1, slv_reg2, slv_reg3 ) is
  begin

    case slv_reg_read_sel is
      when "1000" => slv_ip2bus_data <= slv_reg0;
      when "0100" => slv_ip2bus_data <= slv_reg1;
      when "0010" => slv_ip2bus_data <= slv_reg2;
      when "0001" => slv_ip2bus_data <= slv_reg3;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to access user logic memory region
  -- 
  -- Note:
  -- The example code presented here is to show you one way of using
  -- the user logic memory space features. The Bus2IP_Addr, Bus2IP_CS,
  -- and Bus2IP_RNW IPIC signals are dedicated to these user logic
  -- memory spaces. Each user logic memory space has its own address
  -- range and is allocated one bit on the Bus2IP_CS signal to indicated
  -- selection of that memory space. Typically these user logic memory
  -- spaces are used to implement memory controller type cores, but it
  -- can also be used in cores that need to access additional address space
  -- (non C_BASEADDR based), s.t. bridges. This code snippet infers
  -- 2 256x32-bit (byte accessible) single-port Block RAM by XST.
  ------------------------------------------
  mem_select      <= Bus2IP_CS;
  mem_read_enable <= ( Bus2IP_CS(0) or Bus2IP_CS(1) ) and Bus2IP_RdReq;
  mem_read_ack    <= mem_read_ack_dly1;
  -- mem_write_ack   <= ( Bus2IP_CS(0) or Bus2IP_CS(1) ) and Bus2IP_WrReq;
  mem_write_ack   <= Bus2IP_CS(0) and Bus2IP_WrReq;
  -- mem_address     <= Bus2IP_Addr(C_SLV_AWIDTH-10 to C_SLV_AWIDTH-3);
  mem_address     <= Bus2IP_Addr(C_SLV_AWIDTH-13 to C_SLV_AWIDTH-3); -- Changed to 11 Address locations

  -- this process generates the read acknowledge 1 clock after read enable
  -- is presented to the BRAM block. The BRAM block has a 1 clock delay
  -- from read enable to data out.
  BRAM_RD_ACK_PROC : process( Bus2IP_Clk ) is
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Reset = '1' ) then
        mem_read_ack_dly1 <= '0';
      else
        mem_read_ack_dly1 <= mem_read_enable;
      end if;
    end if;

  end process BRAM_RD_ACK_PROC;

  -- implement Block RAM(s)
  ---------------------------First Memory Generation Here... This is a memory to store the 2 input matrices-------
  mem0_write  		<=  not(Bus2IP_RNW) and Bus2IP_CS(0);
  mem1_write		<=  '1' when (present_state = COMPUTE1 or present_state = COMPUTE2 or present_state = FILLER) and (OAout_enable = '1') else 
						'0';
  mem_data_out(0) 	<=  mem0((CONV_INTEGER(read_address1)));
  mem_data_out(1) 	<=  mem1((CONV_INTEGER(read_address2)));
  
  matdatain 		<= 	mem0(CONV_INTEGER(address_value_in)) when (present_state = TRANSPOSE or present_state = COMPUTE1 or present_state = COMPUTE2) else 
						(others=>'0'); 
  matdataout 		<= 	matdataout1  when ((present_state = COMPUTE2 or present_state = FILLER) and  sdata1_in_sel = '1' and sdata2_in_sel = '0') else
						matdataout2  when ((present_state = COMPUTE1 or present_state = FILLER) and  sdata1_in_sel = '0' and sdata2_in_sel = '1'and OAout_enable = '1') else
					    (others=>'0');
		INP_MEM: process(Bus2IP_Clk) is 
		begin
		if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
			if(mem0_write = '1') then
				mem0(CONV_INTEGER(mem_address)) <= Bus2IP_Data;
			end if;
			
			if(present_state = IDLE) then
				address_value_in <= (others => '0');
			else 
					address_value_in <= address_value_in + 1;
			end if;	
			
			read_address1 <= mem_address;
		end if;	
		end process INP_MEM;

	

		OUT_MEM: process(Bus2IP_Clk) is
		begin 
		if( Bus2IP_Clk'event and Bus2IP_Clk = '1') then
			if(mem1_write = '1') then
				mem1(CONV_INTEGER(address_value_out)) <= matdataout;
				-- mem1(CONV_INTEGER(mem_address)) <= Bus2IP_Data;
			end if;	
			if(present_state = IDLE or present_state = TRANSPOSE or OAout_enable = '0') then
				address_value_out <= (others => '0');
			else 
					address_value_out <= address_value_out + 1;
			end if;	
			read_address2 <= mem_address;
		end if;	
		end process OUT_MEM;
		

MATMULT_DATAPATH: process(Bus2IP_Clk,Bus2IP_Reset)
	begin
		if(Bus2IP_Reset = '1') then
			present_state 			<= IDLE;
			OAout_enable 			<= '0';	
			slv_reg3	  			<= x"00000000";-- Default value set to 0
			countNumberOfCycles	  	<= x"00000000";
			hw_count1	  			<= 0;
			hw_count2	 			<= 0;
			hw_count3	  			<= 0;
			hw_count4	  			<= 0;
			blocks_computed			<= 0;

				
		else
			if(Bus2IP_Clk'event and Bus2IP_Clk = '1') then
				
			case present_state is 

				
				when IDLE =>
							
							if(slv_reg0 = x"00000001") then 
								countNumberOfCycles 		<= countNumberOfCycles + 1;
								present_state 		<= TRANSPOSE;
								OAout_enable 		<= '0';	
								blocks_computed		<=  0;
								hw_count1       	<= hw_count1 + 1;
								-------------------------------------------------------------------------------------------------------
								slv_reg3			<= x"00000000"; -- Denoting that the computation is not over, but it has just started
																	-- And to clear past computation finish flag
								-------------------------------------------------------------------------------------------------------
								
								srst_tran_n 		<= '1'; -- Transpose block activated
								s_b_in_f 			<= '0'; -- Select line for Transpose block
								
								srst_oa1_n			<= '0'; -- Still in reset condition
								srst_oa2_n			<= '0'; -- Still in reset condition
								sen_data1_in 		<= '0'; -- Data enable for OA block
								sen_data2_in 		<= '0'; -- Data enable for OA block
								sdata1_in_sel   	<= '0'; --select line for OA
								sdata2_in_sel   	<= '0'; --select line for OA
								
							else 
								present_state <= IDLE;
								
								srst_tran_n 		<= '0'; -- Reset Enabled
								s_b_in_f 			<= '0'; -- Select line for Transpose block
								
								srst_oa1_n			<= '0'; -- Still in reset condition
								srst_oa2_n			<= '0'; -- Still in reset condition
								sen_data1_in 		<= '0'; -- Data enable for OA block
								sen_data2_in 		<= '0'; -- Data enable for OA block
								sdata1_in_sel   	<= '0'; --select line for OA
								sdata2_in_sel   	<= '0'; --select line for OAck
								
									
							end if;	
									
				when TRANSPOSE => -- Here Tranpose of the Input Matrix is done
							if(hw_count1 = 32) then
								countNumberOfCycles <= countNumberOfCycles + 1;
								hw_count1       	<= 0; -- Counting the Transpose Cycles
								
								present_state 		<= COMPUTE1; --OA1 is accumulating and OA2 is giving output
								
								srst_tran_n 		<= '1'; -- transpose block activated
								s_b_in_f 			<= '1'; -- select line of transpose set to shift out the transposed data
								
								srst_oa1_n			<= '1'; -- OA block activated
								srst_oa2_n			<= '1'; -- OA block activated
								sen_data1_in 		<= '1'; -- Data enable for OA block
								sen_data1_in 		<= '1'; -- Data enable for OA block
								sdata1_in_sel   	<= '0';--select line for OA-- This block is Accumulating
								sdata2_in_sel    	<= '1';--select line for OA-- This block is giving output
							else
								countNumberOfCycles <= countNumberOfCycles + 1;
								hw_count1       	<= hw_count1 + 1; -- Counting the Transpose Cycles
								present_state 		<= TRANSPOSE;
								
								srst_tran_n 		<= '1'; -- Reset Disabled
								s_b_in_f 			<= '0';-- Select line for Transpose block
								
								srst_oa1_n			<= '0'; -- Still in reset condition
								srst_oa2_n			<= '0'; -- Still in reset condition
								sen_data1_in 		<= '0';	-- Data enable for OA block
								sen_data2_in 		<= '0';	-- Data enable for OA block
								sdata1_in_sel   	<= '0';--select line for OA
								sdata2_in_sel   	<= '0';--select line for OA
							end if;
				
				when COMPUTE1 => --OA1 is accumulating and OA2 is giving output
							if(hw_count2 = 31) then
								
								if(blocks_computed = blocks_max) then
									present_state 	<= FILLER; -- This state is for getting the output from the last computing OA block
									
									hw_count2		<=  0;
									sdata1_in_sel   <= '1';--select line for OA
									sdata2_in_sel   <= '0';--select line for OA
								
								else	
									blocks_computed <= blocks_computed + 1;
									OAout_enable	<= '1';
									present_state 	<= COMPUTE2;
									countNumberOfCycles <= countNumberOfCycles + 1;
									hw_count2		<= 0;
									
									srst_tran_n 	<= '1'; -- transpose block activated
									s_b_in_f 		<= '1'; -- select line of transpose set to shift out the transposed data
									
									srst_oa1_n		<= '1'; -- OA block activated
									srst_oa2_n		<= '1'; -- OA block activated
									sen_data1_in 	<= '1';
									sen_data2_in 	<= '1';
									sdata1_in_sel   <= '1';--select line for OA
									sdata2_in_sel   <= '0';--select line for OA
									
								end if;	
							else
								countNumberOfCycles <= countNumberOfCycles + 1;
								hw_count2 			<= hw_count2 + 1; 
								present_state 		<= COMPUTE1; --OA1 is accumulating and OA2 is giving output
								
								srst_tran_n 		<= '1'; -- transpose block activated
								s_b_in_f 			<= '1'; -- select line of transpose set to shift out the transposed data
								
								srst_oa1_n			<= '1'; -- OA block activated
								srst_oa2_n			<= '1'; -- OA block activated
								sen_data1_in 		<= '1'; -- Data enable for OA block
								sen_data2_in 		<= '1'; -- Data enable for OA block
								sdata1_in_sel   	<= '0';--select line for OA-- This block is Accumulating
								sdata2_in_sel    	<= '1';--select line for OA-- This block is giving output
				
							end if;
							
				when COMPUTE2 => --OA1 is accumulating and OA2 is giving output
							if(hw_count3 = 31 ) then
								
								if(blocks_computed = blocks_max) then
									present_state 	<= FILLER; -- This state is for getting the output from the last computing OA block
									
									hw_count3		<=  0;
									sdata1_in_sel   <= '0';--select line for OA
									sdata2_in_sel   <= '1';--select line for OA
									
								else 
									blocks_computed <= blocks_computed + 1;
									present_state 	<= COMPUTE1;
									countNumberOfCycles <= countNumberOfCycles + 1;
									hw_count3		<= 0;
									
									srst_tran_n 	<= '1'; -- transpose block activated
									s_b_in_f 		<= '1'; -- select line of transpose set to shift out the transposed data
									
									srst_oa1_n		<= '1'; -- OA block activated
									srst_oa2_n		<= '1'; -- OA block activated
									sen_data1_in 	<= '1';
									sen_data2_in 	<= '1';
									sdata1_in_sel   <= '0';--select line for OA
									sdata2_in_sel   <= '1';--select line for OA
									
								end if;	
							else
								countNumberOfCycles 		<= countNumberOfCycles + 1;
								hw_count3 			<= hw_count3 + 1; 
								present_state 		<= COMPUTE2; --OA1 is accumulating and OA2 is giving output
								
								srst_tran_n 		<= '1'; -- transpose block activated
								s_b_in_f 			<= '1'; -- select line of transpose set to shift out the transposed data
								
								srst_oa1_n			<= '1'; -- OA block activated
								srst_oa2_n			<= '1'; -- OA block activated
								sen_data1_in 		<= '1'; -- Data enable for OA block
								sen_data2_in 		<= '1'; -- Data enable for OA block
								sdata1_in_sel   	<= '1';--select line for OA-- This block is giving the output
								sdata2_in_sel    	<= '0';--select line for OA-- This block is Accumulating
				
							end if;	


				
				
				when FILLER	=>
				
							if(hw_count4 = 31) then
								present_state 		<= IDLE;
								hw_count4 			<=  0;
								
								--- Transpose Block Resetted-------------
								srst_tran_n 		<= '0'; -- Reset Enabled
								s_b_in_f 			<= '0';
								
								-------------OA blocks are resetted------
								srst_oa1_n			<= '0'; -- Still in reset condition
								srst_oa2_n			<= '0'; -- Still in reset condition
								sen_data1_in 		<= '0';	
								sen_data2_in 		<= '0';	
								sdata1_in_sel    	<= '0';--select line for OA
								sdata2_in_sel    	<= '0';--select line for OA
								-------------------------------------------
								slv_reg3			<= x"00000001"; -- Output Flag
								-------------------------------------------
							else
								countNumberOfCycles <= countNumberOfCycles + 1;
								hw_count4 			<= hw_count4 + 1;
								present_state 		<= FILLER;
								srst_tran_n 		<= '1'; -- Reset Disabled
								srst_oa1_n			<= '1'; -- Still in reset condition
								srst_oa2_n			<= '1'; -- Still in reset condition
								
								
							
							end if;
				
				
				when others =>
							null;
			end case;	
				
			end if;
			
		end if;
		
	end process;				
		

  -- implement Block RAM read mux
  MEM_IP2BUS_DATA_PROC : process( mem_data_out, mem_select ) is
  begin

    case mem_select is
      when "10" => mem_ip2bus_data <= mem_data_out(0);
      when "01" => mem_ip2bus_data <= mem_data_out(1);
      when others => mem_ip2bus_data <= (others => '0');
    end case;

  end process MEM_IP2BUS_DATA_PROC;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                  mem_ip2bus_data when mem_read_ack = '1' else
                  (others => '0');

  IP2Bus_AddrAck <= slv_write_ack or slv_read_ack or mem_write_ack or mem_read_enable;
  IP2Bus_WrAck <= slv_write_ack or mem_write_ack;
  IP2Bus_RdAck <= slv_read_ack or mem_read_ack;
  IP2Bus_Error <= '0';
  
  
 OA1: mkOA port map(
						o_out        =>  matdataout1,
						RDY_o_out    =>  open,
						CLK          =>  Bus2IP_Clk,
						RST_N        =>  srst_oa1_n,
						data_in_x    =>  s_o_out,  
						data_in_y    =>  matdatain,   
						data_in_sel  =>  sdata1_in_sel,
						EN_data_in   =>  sen_data1_in
					);
					
OA2: mkOA port map(
						o_out        =>  matdataout2,
						RDY_o_out    =>  open,
						CLK          =>  Bus2IP_Clk,
						RST_N        =>  srst_oa2_n,
						data_in_x    =>  s_o_out,  
						data_in_y    =>  matdatain,   
						data_in_sel  =>  sdata2_in_sel,
						EN_data_in   =>  sen_data2_in
					);					
					
	
Tran1: mkTranspose port map(
			
							o_out        =>  s_o_out,
							RDY_o_out    =>  s_RDY_o_out,
							CLK          =>  Bus2IP_Clk,
							RST_N        =>  srst_tran_n,
							a_in_m       =>  matdatain,
							b_in_f       =>  s_b_in_f
							); 
  

end IMP;
