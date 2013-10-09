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
matmult_entire.elf.size \

ELFCHECK += \
matmult_entire.elf.elfcheck \


# All Target
all: matmult_entire.elf secondary-outputs

# Tool invocations
matmult_entire.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo Building target: $@
	@echo Invoking: MicroBlaze gcc linker
	mb-gcc -Wl,-T -Wl,../src/lscript.ld -L../../matmult_entire_bsp/microblaze_0/lib -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.a -mno-xl-soft-mul -mhard-float -o"matmult_entire.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo Finished building target: $@
	@echo ' '

matmult_entire.elf.size: matmult_entire.elf
	@echo Invoking: MicroBlaze Print Size
	mb-size matmult_entire.elf  |tee "matmult_entire.elf.size"
	@echo Finished building: $@
	@echo ' '

matmult_entire.elf.elfcheck: matmult_entire.elf
	@echo Invoking: Xilinx ELF Check
	elfcheck matmult_entire.elf -hw ../../try1_hw_platform/system.xml -pe microblaze_0  |tee "matmult_entire.elf.elfcheck"
	@echo Finished building: $@
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) matmult_entire.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
