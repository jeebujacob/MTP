################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/inputmemtest.c 

LD_SRCS += \
../src/lscript.ld 

OBJS += \
./src/inputmemtest.o 

C_DEPS += \
./src/inputmemtest.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../inputmemorytest_bsp/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.a -mno-xl-soft-mul -mhard-float -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


