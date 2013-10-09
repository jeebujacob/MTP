################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../microblaze_0/libsrc/bram_v3_00_a/src/xbram.c \
../microblaze_0/libsrc/bram_v3_00_a/src/xbram_g.c \
../microblaze_0/libsrc/bram_v3_00_a/src/xbram_intr.c \
../microblaze_0/libsrc/bram_v3_00_a/src/xbram_selftest.c \
../microblaze_0/libsrc/bram_v3_00_a/src/xbram_sinit.c 

OBJS += \
./microblaze_0/libsrc/bram_v3_00_a/src/xbram.o \
./microblaze_0/libsrc/bram_v3_00_a/src/xbram_g.o \
./microblaze_0/libsrc/bram_v3_00_a/src/xbram_intr.o \
./microblaze_0/libsrc/bram_v3_00_a/src/xbram_selftest.o \
./microblaze_0/libsrc/bram_v3_00_a/src/xbram_sinit.o 

C_DEPS += \
./microblaze_0/libsrc/bram_v3_00_a/src/xbram.d \
./microblaze_0/libsrc/bram_v3_00_a/src/xbram_g.d \
./microblaze_0/libsrc/bram_v3_00_a/src/xbram_intr.d \
./microblaze_0/libsrc/bram_v3_00_a/src/xbram_selftest.d \
./microblaze_0/libsrc/bram_v3_00_a/src/xbram_sinit.d 


# Each subdirectory must supply rules for building sources it contributes
microblaze_0/libsrc/bram_v3_00_a/src/%.o: ../microblaze_0/libsrc/bram_v3_00_a/src/%.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../matmult_no_dma_bsp/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.a -mno-xl-soft-mul -mhard-float -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


