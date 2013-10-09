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
//%% File Name		: matgen.c																				%%
//%% Title 			: 1024*1024 Matrix Generator															%%
//%% Author			: Jeebu Jacob Thomas																	%%
//%% Description	:																						%%
//%% Version		: 00																					%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#include<stdio.h>
#include "xutil.h"
#include"xparameters.h"
#include "xio.h"
#include "defs.h"
int main()
{
int i,j,k,l;
u32	identity_value = 0x80000000;
int ddr_offset = 0;
u32 read_ddrvalue = 0;
xil_printf("Writing the whole Matrix A and Matrix B data into the DDRAM \n\r");

//Test Routine//

// for(k=0;k<32;k++)
		// {
		// if(j==k)
			// {
		//////Print Identity Matrix
			// for(l=0;l<32;l++)
				// {
				// XIo_Out32(DDR_MXIN+ddr_offset,identity_value >> l); 	
				// ddr_offset =  ddr_offset + 4;
				// }
			// }
		// else
			// {
			// for(l=0;l<32;l++)
				// {
				// XIo_Out32(DDR_MXIN+ddr_offset,0x00000000); 	
				// ddr_offset =  ddr_offset + 4;
			
				// }
			// }
		// }



/////////////////
for(i=0;i<32;i++)
	{
	for(j=0;j<32;j++)
		{
		///////write 32 words each of value 09
		XIo_Out32(DDR_MXIN+ddr_offset,9); 	
		ddr_offset = ddr_offset + 4;
		}
	
	for(k=0;k<32;k++)
		{
		if(i==k)
			{
		////////Print Identity Matrix
			for(l=0;l<32;l++)
				{
				XIo_Out32(DDR_MXIN+ddr_offset,identity_value >> l); 	
				ddr_offset =  ddr_offset + 4;
				}
			}
		else
			{
			for(l=0;l<32;l++)
				{
				XIo_Out32(DDR_MXIN+ddr_offset,0x00000000); 	
				ddr_offset =  ddr_offset + 4;
			
				}
			}
		}
	}
	xil_printf("Data written from 93000000 to %08x \n\r",DDR_MXIN+ddr_offset);
	
	int ddr_readoffset = 0;
	for(i=0;i<1184;i++)
	{
		read_ddrvalue = XIo_In32(DDR_MXIN+ddr_readoffset); 
		ddr_readoffset =  ddr_readoffset + 4; 	
		xil_printf("%d the value is %d \n\r",i,read_ddrvalue);
	}
	
return(0);
}
