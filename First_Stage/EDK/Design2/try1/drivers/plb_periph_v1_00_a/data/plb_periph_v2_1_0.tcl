##############################################################################
## Filename:          G:\StudyFolder\MTP\MAIN\EDK_work\Design2\matmult3232_raw1K\try1/drivers/plb_periph_v1_00_a/data/plb_periph_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Fri Sep 27 16:43:28 2013 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "plb_periph" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" "C_MEM0_BASEADDR" "C_MEM0_HIGHADDR" "C_MEM1_BASEADDR" "C_MEM1_HIGHADDR" 
}
