################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite.c \
../microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_g.c \
../microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_intr.c \
../microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_l.c \
../microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_selftest.c \
../microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_sinit.c \
../microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_stats.c 

OBJS += \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite.o \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_g.o \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_intr.o \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_l.o \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_selftest.o \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_sinit.o \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_stats.o 

C_DEPS += \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite.d \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_g.d \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_intr.d \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_l.d \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_selftest.d \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_sinit.d \
./microblaze_0/libsrc/uartlite_v2_00_a/src/xuartlite_stats.d 


# Each subdirectory must supply rules for building sources it contributes
microblaze_0/libsrc/uartlite_v2_00_a/src/%.o: ../microblaze_0/libsrc/uartlite_v2_00_a/src/%.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../matmult_no_dma_bsp/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.a -mno-xl-soft-mul -mhard-float -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


