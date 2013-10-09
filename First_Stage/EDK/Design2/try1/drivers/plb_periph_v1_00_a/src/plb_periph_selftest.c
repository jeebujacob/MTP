/*****************************************************************************
* Filename:          G:\StudyFolder\MTP\MAIN\EDK_work\Design2\matmult3232_raw1K\try1/drivers/plb_periph_v1_00_a/src/plb_periph_selftest.c
* Version:           1.00.a
* Description:       Contains a diagnostic self-test function for the plb_periph driver
* Date:              Fri Sep 27 16:43:28 2013 (by Create and Import Peripheral Wizard)
*****************************************************************************/


/***************************** Include Files *******************************/

#include "plb_periph.h"

/************************** Constant Definitions ***************************/


/************************** Variable Definitions ****************************/

extern Xuint32 LocalBRAM; /* User logic local memory (BRAM) base address */

/************************** Function Definitions ***************************/

/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the PLB_PERIPH instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus PLB_PERIPH_SelfTest(void * baseaddr_p)
{
  int     Index;
  Xuint32 baseaddr;
  Xuint8  Reg8Value;
  Xuint16 Reg16Value;
  Xuint32 Reg32Value;
  Xuint32 Mem32Value;

  /*
   * Check and get the device address
   */
  /*
   * Base Address maybe 0. Up to developer to uncomment line below.
  XASSERT_NONVOID(baseaddr_p != XNULL);
   */
  baseaddr = (Xuint32) baseaddr_p;

  xil_printf("******************************\n\r");
  xil_printf("* User Peripheral Self Test\n\r");
  xil_printf("******************************\n\n\r");

  /*
   * Write to user logic slave module register(s) and read back
   */
  xil_printf("User logic slave module test...\n\r");
  xil_printf("   - write 1 to slave register 0 word 0\n\r");
  PLB_PERIPH_mWriteSlaveReg0(baseaddr, 0, 1);
  Reg32Value = PLB_PERIPH_mReadSlaveReg0(baseaddr, 0);
  xil_printf("   - read %d from register 0 word 0\n\r", Reg32Value);
  if ( Reg32Value != (Xuint32) 1 )
  {
    xil_printf("   - slave register 0 word 0 write/read failed\n\r");
    return XST_FAILURE;
  }
  xil_printf("   - write 2 to slave register 1 word 0\n\r");
  PLB_PERIPH_mWriteSlaveReg1(baseaddr, 0, 2);
  Reg32Value = PLB_PERIPH_mReadSlaveReg1(baseaddr, 0);
  xil_printf("   - read %d from register 1 word 0\n\r", Reg32Value);
  if ( Reg32Value != (Xuint32) 2 )
  {
    xil_printf("   - slave register 1 word 0 write/read failed\n\r");
    return XST_FAILURE;
  }
  xil_printf("   - write 3 to slave register 2 word 0\n\r");
  PLB_PERIPH_mWriteSlaveReg2(baseaddr, 0, 3);
  Reg32Value = PLB_PERIPH_mReadSlaveReg2(baseaddr, 0);
  xil_printf("   - read %d from register 2 word 0\n\r", Reg32Value);
  if ( Reg32Value != (Xuint32) 3 )
  {
    xil_printf("   - slave register 2 word 0 write/read failed\n\r");
    return XST_FAILURE;
  }
  xil_printf("   - write 4 to slave register 3 word 0\n\r");
  PLB_PERIPH_mWriteSlaveReg3(baseaddr, 0, 4);
  Reg32Value = PLB_PERIPH_mReadSlaveReg3(baseaddr, 0);
  xil_printf("   - read %d from register 3 word 0\n\r", Reg32Value);
  if ( Reg32Value != (Xuint32) 4 )
  {
    xil_printf("   - slave register 3 word 0 write/read failed\n\r");
    return XST_FAILURE;
  }
  xil_printf("   - slave register write/read passed\n\n\r");

  /*
   * Write data to user logic BRAMs and read back
   */
  xil_printf("User logic BRAM test...\n\r");
  xil_printf("   - local BRAM address is 0x%08x\n\r", LocalBRAM);
  xil_printf("   - write pattern to local BRAM and read back\n\r");
  for ( Index = 0; Index < 256; Index++ )
  {
    PLB_PERIPH_mWriteMemory(LocalBRAM+4*Index, 0xDEADBEEF);
    Mem32Value = PLB_PERIPH_mReadMemory(LocalBRAM+4*Index);
    if ( Mem32Value != 0xDEADBEEF )
    {
      xil_printf("   - write/read BRAM failed on address 0x%08x\n\r", LocalBRAM+4*Index);
      return XST_FAILURE;
    }
  }
  xil_printf("   - write/read BRAM passed\n\n\r");

  return XST_SUCCESS;
}
