
include_guard(GLOBAL)

# Overrides __FILE__ macro to remove file path, leaving filename only
# Ensures that no absolute paths are compiled in by mistake and that builds are repeatable
function(override_file_macro target_name)
  get_target_property(SOURCES ${target_name} SOURCES)
  foreach(source_file ${SOURCES})
    get_filename_component(filename ${source_file} NAME)
    set_source_files_properties(${source_file} PROPERTIES COMPILE_DEFINITIONS "__FILE__=\"${filename}\"")
    set_source_files_properties(${source_file} PROPERTIES COMPILE_FLAGS "-Wno-builtin-macro-redefined")
  endforeach()
endfunction(override_file_macro)

function(convert_elf2hex target_name)
  add_custom_command(TARGET ${target_name}.elf
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "Converting ELF to hex file ${target_name}.hex"
    COMMAND ${CMAKE_OBJCOPY} -I ihex -O ihex ${target_name}.elf ${target_name}.hex
  )
endfunction(convert_elf2hex)

function(flash_jlink target_name input_file device_name pre_command post_command)
  find_program(JLINK_BIN JLink "C:/Program Files (x86)/SEGGER/JLink")
  if(NOT JLINK_BIN)
    message(WARNING "Cannot find JLink executable")
  endif()

  set(JLINK_TMP jlink.tmp)

  add_custom_target(${target_name}
    COMMAND ${CMAKE_COMMAND} -E echo "exitonerror 1" > ${JLINK_TMP}
    COMMAND ${CMAKE_COMMAND} -E echo "usb" >> ${JLINK_TMP}
    COMMAND ${CMAKE_COMMAND} -E echo "device ${device_name}" >> ${JLINK_TMP}
    COMMAND ${CMAKE_COMMAND} -E echo "si 1" >> ${JLINK_TMP}
    COMMAND ${CMAKE_COMMAND} -E echo "speed auto" >> ${JLINK_TMP}
    COMMAND ${CMAKE_COMMAND} -E echo ${pre_command} >> ${JLINK_TMP}
    COMMAND ${CMAKE_COMMAND} -E echo "loadfile ${input_file}" >> ${JLINK_TMP}
    COMMAND ${CMAKE_COMMAND} -E echo ${post_command} >> ${JLINK_TMP}
    COMMAND ${CMAKE_COMMAND} -E echo "exit" >> ${JLINK_TMP}
    COMMAND ${JLINK_BIN} -commanderscript ${JLINK_TMP}
    COMMENT "Flashing file ${input_file}"
  )
endfunction(flash_jlink)

function(flash_stlink target_name input_file target_file pre_command post_command)
  find_program(OPENOCD_BIN openocd "C:/OpenOCD-20210301-0.10.0/bin")
  if(NOT OPENOCD_BIN)
    message(WARNING "Cannot find openocd executable")
  endif()

  list(APPEND OPENOCD_ARGS
    -f interface/stlink.cfg
    -f target/${target_file}
    -c "${pre_command} program ${input_file} ${post_command} exit"
  )

  add_custom_target(${target_name}
    COMMAND ${OPENOCD_BIN} ${OPENOCD_ARGS}
    COMMENT "Flashing file ${input_file}"
  )
endfunction(flash_stlink)

function(flash_olimex target_name input_file target_file pre_command post_command)
  find_program(OPENOCD_BIN openocd "C:/OpenOCD-20210301-0.10.0/bin")
  if(NOT OPENOCD_BIN)
    message(WARNING "Cannot find openocd executable")
  endif()

  list(APPEND OPENOCD_ARGS
    -f interface/ftdi/olimex-arm-usb-ocd-h.cfg
    -f ftdi/olimex-arm-jtag-swd.cfg
    -f target/${target_file}
    -c "${pre_command} program ${input_file} ${post_command} exit"
  )

  add_custom_target(${target_name}
    COMMAND ${OPENOCD_BIN} ${OPENOCD_ARGS}
    COMMENT "Flashing file ${input_file}"
  )
endfunction(flash_olimex)

function(add_embedded_executable target_name)
  add_executable(${target_name}.elf "")
  convert_elf2hex(${target_name})

endfunction(add_embedded_executable)

function(set_default_compile_options target_name)
  set_target_properties(${target_name} PROPERTIES C_STANDARD 11)
  set_target_properties(${target_name} PROPERTIES CXX_STANDARD 11)

  target_compile_options(${target_name} PRIVATE
    -Og
    -fdata-sections
    -ffunction-sections
    -ffreestanding
    -fno-exceptions
    -Wall
    -Wextra
    -Wno-unused-parameter
    -Wno-unused-function
    -Werror=return-type
    -Wno-missing-field-initializers
    -g3
    -specs=nosys.specs
  )
endfunction(set_default_compile_options)

function(set_default_link_options target_name)
  target_link_options(${target_name} PRIVATE
    -specs=nosys.specs
    -Wl,--no-warn-rwx-segments
    -Wl,--gc-sections
    -Wl,-Map,${CMAKE_BINARY_DIR}/${target_name}.map
    -Wl,--cref
    -Wl,--print-memory-usage

  )
endfunction(set_default_link_options)

function(add_linker_file target_name linker_file)
  target_link_options(${target_name} PRIVATE
    -T ${linker_file}
  )
  set_target_properties(${target_name} PROPERTIES LINK_DEPENDS ${linker_file})
endfunction(add_linker_file)
