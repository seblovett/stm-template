
cmake_minimum_required(VERSION 3.17 FATAL_ERROR)

project(
  stm-template
  LANGUAGES C ASM
)

include(../apps.cmake)

add_embedded_executable(${CMAKE_PROJECT_NAME})

target_sources(${CMAKE_PROJECT_NAME}.elf PRIVATE
Core/Src/main.c 
Core/Src/stm32f4xx_it.c 
Core/Src/stm32f4xx_hal_msp.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim_ex.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc_ex.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ex.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ramfunc.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma_ex.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr_ex.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c 
Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_exti.c 
Core/Src/system_stm32f4xx.c 
startup_stm32f411xe.s
)

target_include_directories(${CMAKE_PROJECT_NAME}.elf PRIVATE
Core/Inc 
Drivers/STM32F4xx_HAL_Driver/Inc 
Drivers/STM32F4xx_HAL_Driver/Inc/Legacy 
Drivers/CMSIS/Device/ST/STM32F4xx/Include 
Drivers/CMSIS/Include
)

target_compile_definitions(${CMAKE_PROJECT_NAME}.elf PRIVATE
  STM32F411xE
  USE_HAL_DRIVER
 )

set_default_compile_options(${CMAKE_PROJECT_NAME}.elf)
set_default_link_options(${CMAKE_PROJECT_NAME}.elf)

add_linker_file(${CMAKE_PROJECT_NAME}.elf ${CMAKE_SOURCE_DIR}/STM32F411CEUx_FLASH.ld)

# Must be after all target_sources() calls
override_file_macro(${CMAKE_PROJECT_NAME}.elf)

