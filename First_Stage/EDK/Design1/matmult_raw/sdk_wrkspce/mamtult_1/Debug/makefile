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
mamtult_1.elf.size \

ELFCHECK += \
mamtult_1.elf.elfcheck \


# All Target
all: mamtult_1.elf secondary-outputs

# Tool invocations
mamtult_1.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo Building target: $@
	@echo Invoking: MicroBlaze gcc linker
	mb-gcc -Wl,-T -Wl,../src/lscript.ld -L../../matmult_1_bsp/microblaze_0/lib -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.a -mno-xl-soft-mul -mhard-float -o"mamtult_1.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo Finished building target: $@
	@echo ' '

mamtult_1.elf.size: mamtult_1.elf
	@echo Invoking: MicroBlaze Print Size
	mb-size mamtult_1.elf  |tee "mamtult_1.elf.size"
	@echo Finished building: $@
	@echo ' '

mamtult_1.elf.elfcheck: mamtult_1.elf
	@echo Invoking: Xilinx ELF Check
	elfcheck mamtult_1.elf -hw ../../matmult_raw_hw_platform/system.xml -pe microblaze_0  |tee "mamtult_1.elf.elfcheck"
	@echo Finished building: $@
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) mamtult_1.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
