################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../microblaze_0/libsrc/common_v1_00_a/src/xbasic_types.c \
../microblaze_0/libsrc/common_v1_00_a/src/xutil_memtest.c \
../microblaze_0/libsrc/common_v1_00_a/src/xversion.c 

OBJS += \
./microblaze_0/libsrc/common_v1_00_a/src/xbasic_types.o \
./microblaze_0/libsrc/common_v1_00_a/src/xutil_memtest.o \
./microblaze_0/libsrc/common_v1_00_a/src/xversion.o 

C_DEPS += \
./microblaze_0/libsrc/common_v1_00_a/src/xbasic_types.d \
./microblaze_0/libsrc/common_v1_00_a/src/xutil_memtest.d \
./microblaze_0/libsrc/common_v1_00_a/src/xversion.d 


# Each subdirectory must supply rules for building sources it contributes
microblaze_0/libsrc/common_v1_00_a/src/%.o: ../microblaze_0/libsrc/common_v1_00_a/src/%.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../matmult_no_dma_bsp/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.a -mno-xl-soft-mul -mhard-float -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


