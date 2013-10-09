##############################################################################
## Filename:          G:\StudyFolder\MTP\MAIN\EDK_work\Design1\matmult_raw/pcores/plb_periph_v1_00_a/devl/bfmsim/bfm_sim_cmd.make
## Description:       Makefile for BFM Simulation through command line
## Date:              Tue Sep 24 15:53:51 2013 (by Create and Import Peripheral Wizard)
##############################################################################


SHELL = CMD 

SYSTEM = bfm_system

MHSFILE = bfm_system.mhs

FPGA_ARCH = virtex6

LANGUAGE = vhdl

SEARCHPATHOPT = -lp ../../../../../

SIMULATOR_OPT = -s mgm

ISELIB_OPT = -X "C:/Xilinx/13.2/ISE_DS/ISE/vhdl/mti_pe/6.6f/nt"

EDKLIB_OPT = 

SIMGEN_OPTIONS = \
	-p $(FPGA_ARCH) \
	-lang $(LANGUAGE) \
	$(SEARCHPATHOPT) \
	$(SIMULATOR_OPT) \
	$(ISELIB_OPT) \
	$(EDKLIB_OPT)

SIM_CMD = vsim

BFC_CMD = xilbfc -s mgm

BFL_SCRIPTS = \
	sample.bfl

BFM_SCRIPTS = \
	scripts/sample.do

DO_SCRIPT = scripts/run.do

BEHAVIORAL_SIM_SCRIPT = simulation/behavioral/$(SYSTEM).do

############################################################
# EXTERNAL TARGETS
############################################################

bfl: $(BFM_SCRIPTS)

sim: $(BEHAVIORAL_SIM_SCRIPT) $(BFM_SCRIPTS)
	@echo "*********************************************"
	@echo "Start BFM simulation ..."
	@echo "*********************************************"
	cd simulation/behavioral & start /B $(SIM_CMD) -do ../../$(DO_SCRIPT) 

simmodel: $(BEHAVIORAL_SIM_SCRIPT)

clean: simclean
	rm -rf $(BFM_SCRIPTS)

simclean:
	rm -rf simulation/behavioral

############################################################
# BEHAVIORAL SIMULATION GENERATION FLOW
############################################################

$(BEHAVIORAL_SIM_SCRIPT): $(MHSFILE)
	@echo "*********************************************"
	@echo "Create behavioral simulation models ..."
	@echo "*********************************************"
	simgen $(MHSFILE) $(SIMGEN_OPTIONS) -m behavioral

$(BFM_SCRIPTS): scripts/$(BFL_SCRIPTS)
	@echo "*********************************************"
	@echo "Compile bfl script(s) for BFM simulation ..."
	@echo "*********************************************"
	cd scripts & $(BFC_CMD) $(BFL_SCRIPTS)


