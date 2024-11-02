
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)

set(CMAKE_SYSTEM_PROCESSOR arm)

find_program(CMAKE_C_COMPILER arm-none-eabi-gcc)
if(NOT CMAKE_C_COMPILER)
  message(FATAL_ERROR "Cannot find arm-none-eabi-gcc executable")
endif()

find_program(CMAKE_CXX_COMPILER arm-none-eabi-g++)
if(NOT CMAKE_CXX_COMPILER)
  message(FATAL_ERROR "Cannot find arm-none-eabi-g++ executable")
endif()

set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER} CACHE STRING "")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_C_FLAGS_INIT "-mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv5-d16 -mthumb")
set(CMAKE_CXX_FLAGS_INIT "-mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv5-d16 -mthumb")
set(CMAKE_ASM_FLAGS_INIT "-mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv5-d16 -mthumb -x assembler-with-cpp")
