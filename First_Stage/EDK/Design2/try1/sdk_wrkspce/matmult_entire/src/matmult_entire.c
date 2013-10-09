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
//%% File Name		: matmult_entire.c																		%%
//%% Title 			: 1024*1024 Matrix Multiplier															%%
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
int count,i,j,k,l = 0;
u32 readstatusreg;
u32 var,countreg;
u32 memreadvalue,regreadvalue,regreadvalue1,readmem0;
XStatus statusDMA;

// Delay function defined Here
// void delay()
// {
	// int x,y;
	// for (x = 0; x <2000; x++)
		// {
		// for (y = 0;y<10; y++)
			// {
			// } 
		// }
// }	
/////////////////////////////////////////////////////////////////////////////////////////////
////////////DMA initialization function defined here
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

	/////////////Now we need to set the Control Register before transfer begins
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

	u32 ddr_offset = 0;
	// u32 matA[1000]={0};
	//u32 matB[2]={0};
	
	u32 readreg ;
	//xil_printf("The programs starts here\n\r");

	//////// Initialization of DMA///////////////////////////////////////

	// statusDMA = initialize_setup();
	
	// if(statusDMA == XST_SUCCESS)
	// {
		// xil_printf("DMA Initialization is completed Succesfully \n\r");
	// }
	// else
	// {
		// xil_printf("DMA Initialization  failed \n\r");
	// }

	xil_printf("Test Area51 Reached");
	
	///////////////Initializing Matrix A with 0 values/////////
	
		// matA[1023] = 0xDEADBEEF;
	
	
	
	// for(i=0;i<512;i++)
	// {
		// xil_printf(" %08x",	matA[1023]);
	
	// }
	
	
	///////////////Printing Matrix A values/////////
	// for(i=0;i<2;i++)
	// {
		
	// matB[i] = 2;
		
	// }
	
	xil_printf("Fest MI6 Reached \n\r"); 
	
/////////////////////////Actual Computational Work DOne here////////////
	
	// for(i=0;i<32;i++)
	// {
		// for(l=0;l<32;j++)
		// {
			/////DMA Transfer done here///////////////////////////////
			// DMAtransfer(DDR_MXIN+ddr_offset,XPAR_PLB_PERIPH_0_MEM0_BASEADDR,4224); //transferring 1056 words
			////////////////////////////////////////////////////////////
			// xil_printf("Area_1 Cleared_DMA Transfer\n\r");
			// PLB_PERIPH_mWriteSlaveReg0(XPAR_PLB_PERIPH_0_BASEADDR,0,1); // For the computation to begin
			// do
			// {
			 // readreg = PLB_PERIPH_mReadSlaveReg3(XPAR_PLB_PERIPH_0_BASEADDR,0);		// To make sure slv_reg0 is set to 0 once the computation has started
			// }while(readreg!=0);
			
			// xil_printf("Area_2 Cleared: slv_reg0 = 0, process started\n\r");
			
			// PLB_PERIPH_mWriteSlaveReg0(XPAR_PLB_PERIPH_0_BASEADDR,0,0);
			
			// do
			// {
			 // readreg = PLB_PERIPH_mReadSlaveReg3(XPAR_PLB_PERIPH_0_BASEADDR,0);			
			// }while(readreg!=1); // Conputation is finished here
			
			// xil_printf("Area_3 Cleared: slv_reg0 = 0, process ended\n\r");
			
				// for(j=0;j<32;j++)
				// {
					
					// for(k=0;k<32;k++)
					// {
						
						// matA[i*32+k][j] = matA[i*32+k][j] ^ PLB_PERIPH_mReadMemory(XPAR_PLB_PERIPH_0_MEM1_BASEADDR+(j*32+k)*4);
					
					// }
				
				// }
			
		// ddr_offset = ddr_offset + 4224	;
			
		// }

	// }
	

	
	
	
	
	xil_printf("Hooray its done!!!");
return(0);
}
