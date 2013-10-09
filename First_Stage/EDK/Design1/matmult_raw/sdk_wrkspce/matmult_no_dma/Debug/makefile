################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir.mk
-include microblaze_0/libsrc/uartlite_v2_00_a/src/subdir.mk
-include microblaze_0/libsrc/standalone_v3_01_a/src/subdir.mk
-include microblaze_0/libsrc/standalone_v3_01_a/src/profile/subdir.mk
-include microblaze_0/libsrc/mpmc_v4_01_a/src/subdir.mk
-include microblaze_0/libsrc/lldma_v2_00_a/src/subdir.mk
-include microblaze_0/libsrc/dmacentral_v2_00_a/src/subdir.mk
-include microblaze_0/libsrc/cpu_v1_13_a/src/subdir.mk
-include microblaze_0/libsrc/common_v1_00_a/src/subdir.mk
-include microblaze_0/libsrc/bram_v3_00_a/src/subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
ELFSIZE += \
matmult_no_dma.elf.size \

ELFCHECK += \
matmult_no_dma.elf.elfcheck \


# All Target
all: matmult_no_dma.elf secondary-outputs

# Tool invocations
matmult_no_dma.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo Building target: $@
	@echo Invoking: MicroBlaze gcc linker
	mb-gcc -Wl,-T -Wl,../src/lscript.ld -L../../matmult_no_dma_bsp/microblaze_0/lib -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.a -mno-xl-soft-mul -mhard-float -o"matmult_no_dma.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo Finished building target: $@
	@echo ' '

matmult_no_dma.elf.size: matmult_no_dma.elf
	@echo Invoking: MicroBlaze Print Size
	mb-size matmult_no_dma.elf  |tee "matmult_no_dma.elf.size"
	@echo Finished building: $@
	@echo ' '

matmult_no_dma.elf.elfcheck: matmult_no_dma.elf
	@echo Invoking: Xilinx ELF Check
	elfcheck matmult_no_dma.elf -hw ../../matmult_raw_hw_platform/system.xml -pe microblaze_0  |tee "matmult_no_dma.elf.elfcheck"
	@echo Finished building: $@
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) matmult_no_dma.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
