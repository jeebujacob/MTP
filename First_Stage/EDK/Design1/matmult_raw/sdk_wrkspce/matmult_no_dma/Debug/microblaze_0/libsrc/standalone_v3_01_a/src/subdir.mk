################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../microblaze_0/libsrc/standalone_v3_01_a/src/_exit.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/errno.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/fcntl.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/inbyte.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_exception_handler.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_interrupt_handler.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_interrupts_g.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/outbyte.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/pvr.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/xil_assert.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/xil_cache.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/xil_exception.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/xil_io.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/xil_testcache.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/xil_testio.c \
../microblaze_0/libsrc/standalone_v3_01_a/src/xil_testmem.c 

S_UPPER_SRCS += \
../microblaze_0/libsrc/standalone_v3_01_a/src/hw_exception_handler.S \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_disable_dcache.S \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_flush_dcache.S \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_flush_dcache_range.S \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_init_dcache_range.S \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_init_icache_range.S \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_invalidate_dcache.S \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_invalidate_dcache_range.S \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_invalidate_icache.S \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_invalidate_icache_range.S \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_scrub.S \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_update_dcache.S \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_update_icache.S 

S_SRCS += \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_disable_exceptions.s \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_disable_icache.s \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_disable_interrupts.s \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_enable_dcache.s \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_enable_exceptions.s \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_enable_icache.s \
../microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_enable_interrupts.s 

OBJS += \
./microblaze_0/libsrc/standalone_v3_01_a/src/_exit.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/errno.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/fcntl.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/hw_exception_handler.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/inbyte.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_disable_dcache.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_disable_exceptions.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_disable_icache.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_disable_interrupts.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_enable_dcache.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_enable_exceptions.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_enable_icache.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_enable_interrupts.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_exception_handler.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_flush_dcache.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_flush_dcache_range.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_init_dcache_range.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_init_icache_range.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_interrupt_handler.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_interrupts_g.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_invalidate_dcache.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_invalidate_dcache_range.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_invalidate_icache.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_invalidate_icache_range.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_scrub.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_update_dcache.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_update_icache.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/outbyte.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/pvr.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_assert.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_cache.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_exception.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_io.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_testcache.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_testio.o \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_testmem.o 

C_DEPS += \
./microblaze_0/libsrc/standalone_v3_01_a/src/_exit.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/errno.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/fcntl.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/inbyte.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_exception_handler.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_interrupt_handler.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_interrupts_g.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/outbyte.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/pvr.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_assert.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_cache.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_exception.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_io.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_testcache.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_testio.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/xil_testmem.d 

S_UPPER_DEPS += \
./microblaze_0/libsrc/standalone_v3_01_a/src/hw_exception_handler.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_disable_dcache.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_flush_dcache.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_flush_dcache_range.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_init_dcache_range.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_init_icache_range.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_invalidate_dcache.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_invalidate_dcache_range.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_invalidate_icache.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_invalidate_icache_range.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_scrub.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_update_dcache.d \
./microblaze_0/libsrc/standalone_v3_01_a/src/microblaze_update_icache.d 


# Each subdirectory must supply rules for building sources it contributes
microblaze_0/libsrc/standalone_v3_01_a/src/%.o: ../microblaze_0/libsrc/standalone_v3_01_a/src/%.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../matmult_no_dma_bsp/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.a -mno-xl-soft-mul -mhard-float -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

microblaze_0/libsrc/standalone_v3_01_a/src/%.o: ../microblaze_0/libsrc/standalone_v3_01_a/src/%.S
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../matmult_no_dma_bsp/microblaze_0/include -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.a -mno-xl-soft-mul -mhard-float -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '

microblaze_0/libsrc/standalone_v3_01_a/src/%.o: ../microblaze_0/libsrc/standalone_v3_01_a/src/%.s
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc assembler
	mb-as  -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


