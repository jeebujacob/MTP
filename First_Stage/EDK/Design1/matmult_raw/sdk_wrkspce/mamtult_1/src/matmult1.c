// Author : Jeebu Jacob Thomas
// Description : To verify the working of a cosystem where this source code issues dma transfer of a chunk od data from DDRSDRAM to a peripheral
			  // and the peripheral after computaion, the data is again written back to the DDRSDRAM through DMA
// Institution : IIT Bombay
// Date : 15/09/2013			  
#include<stdio.h>
#include"plb_periph.h"
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
// DMA initialization function defined here
// XStatus initialize_setup()
// {
	// XStatus DMA_Status;
	// XDmaCentral_Config* MyDMAConfig;
	// MyDMAConfig=XDmaCentral_LookupConfig(XPAR_DMACENTRAL_0_DEVICE_ID);
	// DMA_Status=XST_FAILURE;
	// DMA_Status=XDmaCentral_CfgInitialize(&MyDMA,MyDMAConfig,MyDMAConfig->BaseAddress);
	// if(DMA_Status==XST_FAILURE)    
	// {
		// return XST_FAILURE;
	// }
	// else
	// {
		// return XST_SUCCESS;
	// }
// }
///////////////////////////////////////////////////////////////////////////////////////////
// DMA transfer function is defined here//////////////////////////////////////////////////
// void DMAtransfer(u32 sourceadd, u32 destaddr, int bytes)
// {
	
	
	// XDmaCentral_Reset(&MyDMA); /////Reset the DMA
	// xil_printf("Resetted the DMA \n\r");

	//// Now we need to set the Control Register before transfer begins
	// XDmaCentral_SetControl(&MyDMA, (XDMC_DMACR_SOURCE_INCR_MASK | XDMC_DMACR_DEST_INCR_MASK) ); // x"C0000000" is loaded into the control register
	// countreg = XDmaCentral_GetControl(&MyDMA);
	// xil_printf("Conrol Reg Value = %08x \n\r", countreg);
	// XDmaCentral_Transfer(&MyDMA, (u32*)(sourceadd), (u32*)(destaddr),bytes);
	// xil_printf("Now the transfer has started \n\r"); 
	// do
	// { 
		// readstatusreg = XDmaCentral_GetStatus(&MyDMA);
		// xil_printf("The Status Reg value inside the dowhile loop is %08x \n\r",readstatusreg);
	// } while (readstatusreg != 0);
	// xil_printf("The DMA Transfer is completed");
	
//}



int main() // This is the main part of the program
{	Xuint32 identityvalue = 0x80000000;
	Xuint32 readreg ;
	xil_printf("The programs starts here\n\r");
	xil_printf("Writing Data into the mem0 \n\r"); 
	///////////////////Writing the first 32 values////////
	for(i=0;i<64;i++)
	{
		if(i >= 0 && i < 32)
		{
			PLB_PERIPH_mWriteMemory((XPAR_PLB_PERIPH_0_MEM0_BASEADDR+(i*4)), 5); 		
			delay();
		}
		else if((i >= 32 && i < 64))
		{
			PLB_PERIPH_mWriteMemory((XPAR_PLB_PERIPH_0_MEM0_BASEADDR+(i*4)), identityvalue>>(i-32)); 
			delay();
		}
	}	

	
	xil_printf("The values read from the mem0 are \n\r");
	
	
	for(i=0;i<64;i++)
	{
		readmem0 =  PLB_PERIPH_mReadMemory(XPAR_PLB_PERIPH_0_MEM0_BASEADDR+i*4); 
		xil_printf("%d th value is :%08x \n\r",i,readmem0);
	}
	
	xil_printf("Now the slvreg_0 is set to 1 and then computation begins \n\r");
	
	PLB_PERIPH_mWriteSlaveReg0(XPAR_PLB_PERIPH_0_BASEADDR, 0, 1);
	
	xil_printf("waiting for the result in the dowhile loop \n\r");
	
	do
	{
	readreg = PLB_PERIPH_mReadSlaveReg2(XPAR_PLB_PERIPH_0_BASEADDR, 0);
	}while(readreg !=1);
	
	xil_printf("computation is over now displaying the results \n\r");
	
for(i=0;i<32;i++)
	{
		readmem0 =  PLB_PERIPH_mReadMemory(XPAR_PLB_PERIPH_0_MEM1_BASEADDR+i*4); 
		xil_printf("%d th value is :%08x \n\r",i,readmem0);
	}
	
	
	
	
	xil_printf("Hooray its done!!!");
return(0);
}
