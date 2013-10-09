################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../microblaze_0/libsrc/lldma_v2_00_a/src/xlldma.c \
../microblaze_0/libsrc/lldma_v2_00_a/src/xlldma_bdring.c 

OBJS += \
./microblaze_0/libsrc/lldma_v2_00_a/src/xlldma.o \
./microblaze_0/libsrc/lldma_v2_00_a/src/xlldma_bdring.o 

C_DEPS += \
./microblaze_0/libsrc/lldma_v2_00_a/src/xlldma.d \
./microblaze_0/libsrc/lldma_v2_00_a/src/xlldma_bdring.d 


# Each subdirectory must supply rules for building sources it contributes
microblaze_0/libsrc/lldma_v2_00_a/src/%.o: ../microblaze_0/libsrc/lldma_v2_00_a/src/%.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../matmult_no_dma_bsp/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.a -mno-xl-soft-mul -mhard-float -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


