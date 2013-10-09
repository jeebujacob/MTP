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
//%% Project Name	: Project First Phase "EDK Based Matrix Multiplication on GF(2)"						%% 
//%% File Name		: matmult_row.c																			%%
//%% Title 			: Test Routine for checking Hardware													%%
//%% Author			: Jeebu Jacob Thomas																	%%
//%% Description	:																						%%
//%% Version		: 00																					%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#include "xio.h"
#include "defs.h"
#include<stdio.h>
#include"plb_periph.h"
#include "xutil.h"
#include"xparameters.h"
#include "xmpmc_hw.h" 
#include "xmpmc.h"
#include "xparameters.h"
#include "xdmacentral.h"
#include "xdmacentral_l.h"

XDmaCentral MyDMA;
int count = 0;
Xuint32 readstatusreg;
Xuint32 var,countreg;
Xuint32 i,memreadvalue,regreadvalue,regreadvalue1,readmem0;
XStatus statusDMA;

// Delay function defined Here
void delay()
{
	int x,y;
	for (x = 0; x <2000; x++)
		{
		for (y = 0;y<10; y++)
			{
			} 
		}
}	
/////////////////////////////////////////////////////////////////////////////////////////////
//DMA initialization function defined here
XStatus initialize_setup()
{
	XStatus DMA_Status;
	XDmaCentral_Config* MyDMAConfig;
	MyDMAConfig=XDmaCentral_LookupConfig(XPAR_DMACENTRAL_0_DEVICE_ID);
	DMA_Status=XST_FAILURE;
	DMA_Status=XDmaCentral_CfgInitialize(&MyDMA,MyDMAConfig,MyDMAConfig->BaseAddress);
	if(DMA_Status==XST_FAILURE)    
	{
		return XST_FAILURE;
	}
	else
	{
		return XST_SUCCESS;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////
//DMA transfer function is defined here//////////////////////////////////////////////////
void DMAtransfer(u32 sourceadd, u32 destaddr, int bytes)
{
	
	
	XDmaCentral_Reset(&MyDMA); /////Reset the DMA
	xil_printf("Resetted the DMA \n\r");

	// Now we need to set the Control Register before transfer begins
	XDmaCentral_SetControl(&MyDMA, (XDMC_DMACR_SOURCE_INCR_MASK | XDMC_DMACR_DEST_INCR_MASK) ); // x"C0000000" is loaded into the control register
	countreg = XDmaCentral_GetControl(&MyDMA);
	xil_printf("Conrol Reg Value = %08x \n\r", countreg);
	XDmaCentral_Transfer(&MyDMA, (u32*)(sourceadd), (u32*)(destaddr),bytes);
	xil_printf("Now the transfer has started \n\r"); 
	do
	{ 
		readstatusreg = XDmaCentral_GetStatus(&MyDMA);
		xil_printf("The Status Reg value inside the dowhile loop is %08x \n\r",readstatusreg);
	} while (readstatusreg != 0);
	xil_printf("The DMA Transfer is completed");
	
}



int main() // This is the main part of the program
{	
	Xuint32 ddr_offset = 0;
	Xuint32 identityvalue = 0x80000000;
	Xuint32 readreg ;
	xil_printf("The programs starts here\n\r");
	xil_printf("Writing Data into the DDRSDRAM \n\r"); 
	///////////////////Writing the Matrix A block values////////
	for(i=0;i<32;i++)
	{	
		
		// xil_printf("Data %d written \n\r",i);
		
			XIo_Out32(DDR_MXIN+ddr_offset,5);
			ddr_offset = ddr_offset + 4;;
			////////////////////////// delay();
	}
	///////////////////Writing the Matrix B Row Block////////
	for(i=32; i<1056; i++)
	{
		// xil_printf("Data %d written \n\r",i);
		XIo_Out32(DDR_MXIN+ddr_offset,identityvalue>>(i%32)); 
		ddr_offset = ddr_offset + 4;
			/////// delay();
	}	
	
	
	

	
	// xil_printf("The 96 values read from the DDR2SDRAM are \n\r");
	
	Xuint32 ddr_offset_read = 0;
	// for(i=0;i<512;i++)
	// {
		// memreadvalue = XIo_In32(DDR_MXIN+ddr_offset_read);
		// xil_printf("%dth Memory Location has :%08x \n\r",i,memreadvalue); // Displaying in Hex Format
		// ddr_offset_read = ddr_offset_read + 4;
    // }
	
	//////// Initialization of DMA///////////////////////////////////////

	statusDMA = initialize_setup();
	
	if(statusDMA == XST_SUCCESS)
	{
		xil_printf("DMA Initialization is completed Succesfully \n\r");
	}
	else
	{
		xil_printf("DMA Initialization  failed \n\r");
	}
	/////////////DMA Transfer done here///////////////////////////////
	DMAtransfer(DDR_MXIN,XPAR_PLB_PERIPH_0_MEM0_BASEADDR,4224); //transferring 1056 words
	//////////////////////////////////////////////////////////////////////
	
	
	
	xil_printf("DMA transfer completed\n\r");
	
	
	
	// xil_printf("Lets see the transferred results \n\r");
	
	
	
	// for(i=0;i<1056;i++)
	// {
		// readmem0 =  PLB_PERIPH_mReadMemory(XPAR_PLB_PERIPH_0_MEM0_BASEADDR+i*4); 
		// xil_printf("%d th value is :%08x \n\r",i,readmem0);
	// }
	
	xil_printf("slvreg0 written, now computation begins\n\r");
	
	
	PLB_PERIPH_mWriteSlaveReg0(XPAR_PLB_PERIPH_0_BASEADDR,0,1); // Computations begin here
	
	do
	{
	readreg = PLB_PERIPH_mReadSlaveReg3(XPAR_PLB_PERIPH_0_BASEADDR, 0);
	}while(readreg !=1);
	PLB_PERIPH_mWriteSlaveReg0(XPAR_PLB_PERIPH_0_BASEADDR,0,0);
	
	xil_printf("computation is over now displaying the results \n\r");
	
for(i=0;i<1024;i++)
	{
		readmem0 =  PLB_PERIPH_mReadMemory(XPAR_PLB_PERIPH_0_MEM1_BASEADDR+i*4); 
		xil_printf("%d th value is :%08x \n\r",i,readmem0);
	}
	
	
	
	
	xil_printf("Hooray its done!!!");
return(0);
}
