################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir.mk
-include src/subdir.mk
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
inputmemorytest.elf.size \

ELFCHECK += \
inputmemorytest.elf.elfcheck \


# All Target
all: inputmemorytest.elf secondary-outputs

# Tool invocations
inputmemorytest.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo Building target: $@
	@echo Invoking: MicroBlaze gcc linker
	mb-gcc -Wl,-T -Wl,../src/lscript.ld -L../../inputmemorytest_bsp/microblaze_0/lib -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.a -mno-xl-soft-mul -mhard-float -o"inputmemorytest.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo Finished building target: $@
	@echo ' '

inputmemorytest.elf.size: inputmemorytest.elf
	@echo Invoking: MicroBlaze Print Size
	mb-size inputmemorytest.elf  |tee "inputmemorytest.elf.size"
	@echo Finished building: $@
	@echo ' '

inputmemorytest.elf.elfcheck: inputmemorytest.elf
	@echo Invoking: Xilinx ELF Check
	elfcheck inputmemorytest.elf -hw ../../matmult_raw_hw_platform/system.xml -pe microblaze_0  |tee "inputmemorytest.elf.elfcheck"
	@echo Finished building: $@
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) inputmemorytest.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
