#define TESTAPP_GEN

/* $Id: xdmacentral_polled_example.c,v 1.1.2.3 2009/12/04 18:03:40 juliez Exp $ */
/******************************************************************************
*
* (c) Copyright 2008-2009 Xilinx, Inc. All rights reserved.
*
* This file contains confidential and proprietary information of Xilinx, Inc.
* and is protected under U.S. and international copyright and other
* intellectual property laws.
*
* DISCLAIMER
* This disclaimer is not a license and does not grant any rights to the
* materials distributed herewith. Except as otherwise provided in a valid
* license issued to you by Xilinx, and to the maximum extent permitted by
* applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
* FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
* IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
* MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
* and (2) Xilinx shall not be liable (whether in contract or tort, including
* negligence, or under any other theory of liability) for any loss or damage
* of any kind or nature related to, arising under or in connection with these
* materials, including for any direct, or any indirect, special, incidental,
* or consequential loss or damage (including loss of data, profits, goodwill,
* or any type of loss or damage suffered as a result of any action brought by
* a third party) even if such damage or loss was reasonably foreseeable or
* Xilinx had been advised of the possibility of the same.
*
* CRITICAL APPLICATIONS
* Xilinx products are not designed or intended to be fail-safe, or for use in
* any application requiring fail-safe performance, such as life-support or
* safety devices or systems, Class III medical devices, nuclear facilities,
* applications related to the deployment of airbags, or any other applications
* that could lead to death, personal injury, or severe property or
* environmental damage (individually and collectively, "Critical
* Applications"). Customer assumes the sole risk and liability of any use of
* Xilinx products in Critical Applications, subject only to applicable laws
* and regulations governing limitations on product liability.
*
* THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
* AT ALL TIMES.
*
******************************************************************************/
/*****************************************************************************/
/**
*
* @file xdmacentral_polled_example.c
*
* This file contains a design example using the high-level driver functions
* of the Central DMA driver. The example here shows using the driver/device
* in polled mode.
*
*
* @note		None
*
*
* <pre>
*
* MODIFICATION HISTORY:
*
* Ver   Who    Date     Changes
* ----- ----   -------- -------------------------------------------------------
* 1.00a xd/sv  02/05/08 First release
* 1.12a sdm    03/26/09 Modified to Invalidate the D-Cache for destination
*                       buffer before DMA transaction
* 1.12a ecm    05/13/09 Aligned the buffers to a cacheline to ensure the
*                       flush and invalidate operations occur across the entire
*                       buffer address space to prevent stale data issues.
* 2.00a jz   12/04/09  Hal phase 1 support, changed _m to _ from register API 
* </pre>
*
******************************************************************************/

/***************************** Include Files *********************************/

#include "xparameters.h"
#include "xdmacentral.h"
#include "xil_cache.h"

/************************** Constant Definitions *****************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#ifndef TESTAPP_GEN
#define DMA_DEVICE_ID		XPAR_DMACENTRAL_0_DEVICE_ID
#endif

#define BUFFER_BYTESIZE 80 	/* Length of the buffers for DMA transfer */

/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/

int DmaCentralPolledExample(u16 DeviceId);

/************************** Variable Definitions *****************************/

static XDmaCentral DmaCentral;	/* Instance of the DMA driver */

/*
 * Source and Destination buffers for DMA transfer. These buffers need to be
 * aligned to a cacheline boundary.
 */
static u8 SrcBuffer[BUFFER_BYTESIZE] __attribute__ ((aligned(32)));
static u8 DestBuffer[BUFFER_BYTESIZE] __attribute__ ((aligned(32)));

/*****************************************************************************/
/**
*
* This is main function that invokes the polled example of DMA controller.
* This function is not included if the example is generated from the TestAppGen
* test tool.
*
* @param	None
*
* @return	XST_SUCCESS to indicate success, otherwise XST_FAILURE.
*
* @note		None
*

******************************************************************************/
#ifndef TESTAPP_GEN
int main()
{

	int Status;

	/*
	 * Run the DMA polled example, specify the Device ID generated in
	 * xparameters.h
	 */
	Status = DmaCentralPolledExample(DMA_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;

}
#endif

/*****************************************************************************/
/**
*
* This function runs a test on the Central DMA device using the high-level
* driver functions. This function performs the following tasks:
*
*	- Prepare data pattern in the source buffer and zero the destination
*	buffer
*	- Initialize the DMA device
*	- Reset the DMA device
*	- Run self-test on the DMA device
*	- Setup the Control Register
*	- Disable all interrupts
*	- Start the DMA transfer
*	- Wait until the DMA is done or Bus error occurs by polling DMA
*	Status Register
*	- If dma is done, check the contents of the destination buffer by
*	comparing with the source buffer
*	- If bus error occurs, return error code
*
* @param	DeviceId is device ID of the XDmaCentral Device , typically
*		XPAR_<DMA_CENTRAL_instance>_DEVICE_ID value from xparameters.h
*
* @return	XST_SUCCESS if successful, otherwise XST_FAILURE.
*
* @note		If the hardware system is not built correctly, this function may
*		never return to the caller.
*
******************************************************************************/
int DmaCentralPolledExample(u16 DeviceId)
{
	u8 *SrcPtr;
	u8 *DestPtr;
	u32 Index;
	int Status;
	u32 RegValue;
	XDmaCentral *DmaInstance = &DmaCentral;
	XDmaCentral_Config *ConfigPtr;

	/*
	 * Initialize the XDmaCentral device
	 */
	ConfigPtr = XDmaCentral_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		return XST_FAILURE;
	}

	Status = XDmaCentral_CfgInitialize(DmaInstance,
					ConfigPtr,
					ConfigPtr->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Reset the DMA device
	 */
	XDmaCentral_Reset(DmaInstance);

	/*
	 * Self Test the device
	 */
	Status = XDmaCentral_SelfTest(DmaInstance);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Initialize the source buffer bytes with a pattern and the
	 * the destination buffer bytes to zero
	 */
	SrcPtr = (u8 *)SrcBuffer;
	DestPtr = (u8 *)DestBuffer;
	for (Index = 0; Index < BUFFER_BYTESIZE; Index++) {
		SrcPtr[Index] = Index;
		DestPtr[Index] = 0;
	}

	/*
	 * Setup the DMA Control register to be:
	 *	- Source address incrementing
	 *	- Destination address incrementing
	 */
	XDmaCentral_SetControl(DmaInstance,
				XDMC_DMACR_SOURCE_INCR_MASK |
				XDMC_DMACR_DEST_INCR_MASK);

	/*
	 * Disable all interrupts
	 */
	XDmaCentral_InterruptEnableSet(DmaInstance, 0);


	/*
	 * Flush the SrcBuffer before the DMA transfer, in case the Data Cache
	 * is enabled
	 */
	Xil_DCacheFlushRange((u32)&SrcBuffer, BUFFER_BYTESIZE);

	/*
	 * Invalidate the DestBuffer before receiving the data, in case the Data
	 * Cache is enabled
	 */
	Xil_DCacheInvalidateRange((u32)&DestBuffer, BUFFER_BYTESIZE);

	/*
	 * Start the DMA transfer
	 */
	XDmaCentral_Transfer(DmaInstance, SrcBuffer,
				DestBuffer, BUFFER_BYTESIZE);

	/*
	 * Wait until the DMA transfer is done by checking the Status register
	 */
	do {
		RegValue = XDmaCentral_GetStatus(DmaInstance);
	}
	while ((RegValue & XDMC_DMASR_BUSY_MASK) == XDMC_DMASR_BUSY_MASK);

	/*
	 * If Bus error occurs, return Failure
	 */
	if (RegValue &  (XDMC_DMASR_BUS_ERROR_MASK)) {
		return XST_FAILURE;
	}

	/*
	 * Check the destination buffer
	 */
	for (Index = 0; Index < BUFFER_BYTESIZE; Index++) {
		if ( DestPtr[Index] != SrcPtr[Index]) {
			/*
			 * Destination buffer's content is different from the
			 * source buffer, return Failure
			 */
			return XST_FAILURE;
		}
	}

	/*
	 * Destination buffer's content is the same as the source buffer,
	 * return Success
	 */
	return XST_SUCCESS;
}

