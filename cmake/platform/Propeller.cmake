################################################################################
# @file
# Propeller CMake
#
# @version @n 1.0
# @date @n 5/24/2014
#
# @author @n Kwabena W. Agyeman
# @copyright @n (c) 2014 Kwabena W. Agyeman
# @n All rights reserved - Please see the end of the file for the terms of use
#
# @par Update History:
# @n v1.0 - Original release - 5/24/2014
################################################################################

# Inspired By: https://github.com/queezythegreat/arduino-cmake #################

cmake_minimum_required(VERSION 2.8)

################################################################################
# Generate Propeller Firmware
#
# TARGET_NAME - Executable Name (do "make" to make, "make upload" to upload)
#
# ${TARGET_NAME}_BOARD - propeller-gcc/propeller-Load/*.cfg File Name
# ${TARGET_NAME}_MM - Memory Model (cmm/lmm/cog/xmmc)
# ${TARGET_NAME}_CF - Clock Freq (propeller-load syntax - optional)
# ${TARGET_NAME}_CM - Clock Mode (propeller-load syntax - optional)
# ${TARGET_NAME}_SIDE - List of *.side files (unused - optional)
# ${TARGET_NAME}_SPIN - List of *.spin files (optional)
# ${TARGET_NAME}_COGC - List of *.cogc files (optional)
# ${TARGET_NAME}_SRCS - List of c/cpp source files (optional)
# ${TARGET_NAME}_HDRS - List of c/cpp header files (optional)
# ${TARGET_NAME}_PORT - propeller-load port (do "make upload" to upload)
################################################################################

macro(GENERATE_PROPELLER_FIRMWARE TARGET_NAME)

    if(DEFINED INPUT_SRCS)
        generate_c_propeller_firmware(${TARGET_NAME})
    elseif(DEFINED INPUT_COGC)
        generate_cogc_propeller_firmware(${TARGET_NAME})
    elseif(DEFINED INPUT_SPIN)
        generate_spin_propeller_firmware(${TARGET_NAME})
    else()
        message(FATAL_ERROR "SRCS and COGC and SPIN not defined!")
    endif()

endmacro()

################################################################################
# Generate C Propeller Firmware
#
# TARGET_NAME - Executable Name (do "make" to make, "make upload" to upload)
#
# ${TARGET_NAME}_BOARD - propeller-gcc/propeller-Load/*.cfg File Name
# ${TARGET_NAME}_MM - Memory Model (cmm/lmm/cog/xmmc)
# ${TARGET_NAME}_CF - Clock Freq (propeller-load syntax - optional)
# ${TARGET_NAME}_CM - Clock Mode (propeller-load syntax - optional)
# ${TARGET_NAME}_SIDE - List of *.side files (unused - optional)
# ${TARGET_NAME}_SPIN - List of *.spin files (optional)
# ${TARGET_NAME}_COGC - List of *.cogc files (optional)
# ${TARGET_NAME}_SRCS - List of c/cpp source files (optional)
# ${TARGET_NAME}_HDRS - List of c/cpp header files (optional)
# ${TARGET_NAME}_PORT - propeller-load port (do "make upload" to upload)
################################################################################

macro(GENERATE_C_PROPELLER_FIRMWARE TARGET_NAME)

    if(DEFINED ${TARGET_NAME}_SRCS)
        list(APPEND TARGET_CODE ${${TARGET_NAME}_SRCS})
    endif()

    if(DEFINED ${TARGET_NAME}_COGC)
        generate_cogc_objects(${TARGET_NAME})
        list(APPEND TARGET_CODE ${${TARGET_NAME}_COGC_OBJECTS})
    endif()

    if(DEFINED ${TARGET_NAME}_SPIN)
        generate_spin_objects(${TARGET_NAME})
        list(APPEND TARGET_CODE ${${TARGET_NAME}_SPIN_OBJECTS})
    endif()

    if(DEFINED ${TARGET_NAME}_HDRS)
        list(APPEND TARGET_CODE ${${TARGET_NAME}_HDRS})
    endif()

    foreach(LIBRARY ${SIMPLE_LIBRARIES})

        include_directories(${${LIBRARY}_INCLUDE})

        add_library(${LIBRARY} STATIC IMPORTED)
        set_target_properties(${LIBRARY} PROPERTIES IMPORTED_LOCATION
        ${${LIBRARY}_INCLUDE}/${${TARGET_NAME}_MM}/${LIBRARY}.a

    endforeach()

    add_executable(${TARGET_NAME} ${TARGET_CODE})
    set_target_properties(${TARGET_NAME} PROPERTIES SUFFIX ".elf")

    set_target_properties(${TARGET_NAME} PROPERTIES
    COMPILE_FLAGS "${PROPELLER_COMPILE_FLAGS} -m${${TARGET_NAME}_MM}"
    LINK_FLAGS "${PROPELLER_LINK_FLAGS}")

    target_link_libraries(${SIMPLE_LIBRARIES})

    generate_upload(${TARGET_NAME})

endmacro()

################################################################################
# Generate C Propeller Firmware
#
# TARGET_NAME - Executable Name (do "make" to make, "make upload" to upload)
#
# ${TARGET_NAME}_BOARD - propeller-gcc/propeller-Load/*.cfg File Name
# ${TARGET_NAME}_MM - Memory Model (cmm/lmm/cog/xmmc)
# ${TARGET_NAME}_CF - Clock Freq (propeller-load syntax - optional)
# ${TARGET_NAME}_CM - Clock Mode (propeller-load syntax - optional)
# ${TARGET_NAME}_SIDE - List of *.side files (unused - optional)
# ${TARGET_NAME}_SPIN - List of *.spin files (optional)
# ${TARGET_NAME}_COGC - List of *.cogc files (optional)
# ${TARGET_NAME}_SRCS - List of c/cpp source files (unused - optional)
# ${TARGET_NAME}_HDRS - List of c/cpp header files (optional)
# ${TARGET_NAME}_PORT - propeller-load port (do "make upload" to upload)
################################################################################

macro(GENERATE_COGC_PROPELLER_FIRMWARE TARGET_NAME)
    message(FATAL_ERROR "COGC only not supported yet...")
endmacro()

################################################################################
# Generate C Propeller Firmware
#
# TARGET_NAME - Executable Name (do "make" to make, "make upload" to upload)
#
# ${TARGET_NAME}_BOARD - propeller-gcc/propeller-Load/*.cfg File Name
# ${TARGET_NAME}_MM - Memory Model (cmm/lmm/cog/xmmc)
# ${TARGET_NAME}_CF - Clock Freq (propeller-load syntax - optional)
# ${TARGET_NAME}_CM - Clock Mode (propeller-load syntax - optional)
# ${TARGET_NAME}_SIDE - List of *.side files (unused - optional)
# ${TARGET_NAME}_SPIN - List of *.spin files (optional)
# ${TARGET_NAME}_COGC - List of *.cogc files (unused - optional)
# ${TARGET_NAME}_SRCS - List of c/cpp source files (unused - optional)
# ${TARGET_NAME}_HDRS - List of c/cpp header files (unused - optional)
# ${TARGET_NAME}_PORT - propeller-load port (do "make upload" to upload)
################################################################################

macro(GENERATE_SPIN_PROPELLER_FIRMWARE TARGET_NAME)
    message(FATAL_ERROR "SPIN only not supported yet...")
endmacro()

################################################################################
# Generate Upload Target
#
# ${TARGET_NAME} make -> ${TARGET_NAME} make upload
################################################################################

macro(GENERATE_UPLOAD TARGET_NAME)

    add_custom_target(upload
    ${CMAKE_PROPELLER_LOAD}
    -b ${${TARGET_NAME}_BOARD} -p ${${TARGET_NAME}_PORT} -e -r
    -D clkfreq=${${TARGET_NAME}_CF} -D clkmode=${${TARGET_NAME}_CM}
    ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.elf
    DEPENDS ${TARGET_NAME})

endmacro()

################################################################################
# Generate Cogc objects
#
# ${TARGET_NAME}_COGC -> ${TARGET_NAME}_COGC_OBJECTS
################################################################################

macro(GENERATE_COGC_OBJECTS TARGET_NAME)

    if(DEFINED ${TARGET_NAME}_COGC)
        foreach(COGC_FILE ${${TARGET_NAME}_COGC})

            get_filename_component(COGC_FILE_EXT ${COGC_FILE} NAME_EXT)

            if(${COGC_FILE_EXT} STREQUAL "cogc")
                set(COG_COMPILIER ${CMAKE_C_COMPILER})
                set(COG_FLAGS ${CMAKE_C_FLAGS})
            elseif(${COGC_FILE_EXT} STREQUAL "cogcpp")
                set(COG_COMPILIER ${CMAKE_CXX_COMPILER})
                set(COG_FLAGS ${CMAKE_CXX_FLAGS})
            else()
                message(FATAL_ERROR "Unsupported COGC ${COGC_FILE_EXT}")
            endif()

            get_filename_component(COGC_FILE_WE ${COGC_FILE} NAME_WE)
            list(APPEND ${TARGET_NAME}_COGC_OBJECTS ${COGC_FILE_WE}.o)

            set_source_files_properties(${COGC_FILE_WE}.o PROPERTIES
            EXTERNAL_OBJECT TRUE GENERATED TRUE)

            add_custom_command(OUTPUT ${COGC_FILE_WE}.o
            COMMAND ${COG_COMPILIER} ARGS -r -mcog ${COG_FLAGS}
            -o ${CMAKE_CURRENT_BINARY_DIR}/${COGC_FILE_WE}.o
            -c ${CMAKE_CURRENT_SOURCE_DIR}/${COGC_FILE}
            COMMAND ${CMAKE_OBJCOPY} ARGS --localize-text --rename-section
            .text=${COGC_FILE_WE}.o
            ${CMAKE_CURRENT_BINARY_DIR}/${COGC_FILE_WE}.o)

        endforeach()
    endif()

endmacro()

################################################################################
# Generate Spin objects
#
# ${TARGET_NAME}_SPIN -> ${TARGET_NAME}_SPIN_OBJECTS
################################################################################

macro(GENERATE_SPIN_OBJECTS TARGET_NAME)

    if(DEFINED ${TARGET_NAME}_SPIN)
        foreach(SPIN_FILE ${${TARGET_NAME}_SPIN})

            get_filename_component(SPIN_FILE_WE ${SPIN_FILE} NAME_WE)
            list(APPEND ${TARGET_NAME}_SPIN_OBJECTS ${SPIN_FILE_WE}.o)

            set_source_files_properties(${SPIN_FILE_WE}.o PROPERTIES
            EXTERNAL_OBJECT TRUE GENERATED TRUE)

            add_custom_command(OUTPUT ${SPIN_FILE_WE}.o
            COMMAND ${CMAKE_SPIN_COMPILER} ARGS
            -o ${CMAKE_CURRENT_BINARY_DIR}/${SPIN_FILE_WE}.o
            -c ${CMAKE_CURRENT_SOURCE_DIR}/${SPIN_FILE}
            COMMAND ${CMAKE_OBJCOPY} ARGS
            -I binary -B propeller -O propeller-elf-gcc
            ${SPIN_FILE_WE}.dat ${SPIN_FILE_WE}.o)

        endforeach()
    endif()

endmacro()

################################################################################
# Register Simple Libraries
################################################################################

macro(REGISTER_SIMPLE_LIBRARIES)

    set(SIMPLE_LIBRARIES_PATH
    "${PROPELLER_SDK_PATH}/Workspace/Learn/Simple Libraries")

    file(GLOB_RECURSE OBJECTS RELATIVE ${SIMPLE_LIBRARIES_PATH} *.side)
    foreach(OBJECT ${OBJECTS})

        get_filename_component(LIBRARY ${OBJECT} NAME_WE)
        string(REGEX REPLACE "^lib" "" LIBRARY ${LIBRARY})
        list(APPEND SIMPLE_LIBRARIES ${LIBRARY})

        get_filename_component(${LIBRARY}_INCLUDE
        ${SIMPLE_LIBRARIES_PATH}/${OBJECT} PATH)

    endforeach()

endmacro()

################################################################################
# Register Spin Libraries
################################################################################

macro(REGISTER_SPIN_LIBRARIES)

    set(SPIN_LIBRARIES_PATH
    "${PROPELLER_SDK_PATH}/propeller-gcc/spin")

endmacro()

################################################################################
# Setup
################################################################################

find_program(CMAKE_SPIN_COMPILER NAMES openspin)
find_program(CMAKE_PROPELLER_LOAD NAMES propeller-load)

find_program(CMAKE_OBJCOPY NAMES propeller-elf-objcopy)
find_program(CMAKE_OBJDUMP NAMES propeller-elf-objdump)

register_simple_libraries()
register_spin_libraries()

# C Flags ######################################################################

if(NOT DEFINED PROPELLER_C_FLAGS)
    set(PROPELLER_C_FLAGS
    "-ffunction-sections -fdata-sections -m32bit-doubles -Wall")
endif()

set(CMAKE_C_FLAGS
"-g -Os ${PROPELLER_C_FLAGS}")

set(CMAKE_C_FLAGS_DEBUG
"-g ${PROPELLER_C_FLAGS}")

set(CMAKE_C_FLAGS_MINSIZEREL
"-Os -DNDEBUG ${PROPELLER_C_FLAGS}")

set(CMAKE_C_FLAGS_RELEASE
"-Os -DNDEBUG -w ${PROPELLER_C_FLAGS}")

set(CMAKE_C_FLAGS_RELWITHDEBINFO
"-Os -g -w ${PROPELLER_C_FLAGS}")

# C++ Flags ####################################################################

if(NOT DEFINED PROPELLER_CXX_FLAGS)
    set(PROPELLER_CXX_FLAGS
    "${PROPELLER_C_FLAGS} -fno-exceptions -fno-rtti")
endif()

set(CMAKE_CXX_FLAGS
"-g -Os ${PROPELLER_CXX_FLAGS}")

set(CMAKE_CXX_FLAGS_DEBUG
"-g ${PROPELLER_CXX_FLAGS}")

set(CMAKE_CXX_FLAGS_MINSIZEREL
"-Os -DNDEBUG ${PROPELLER_CXX_FLAGS}")

set(CMAKE_CXX_FLAGS_RELEASE
"-Os -DNDEBUG ${PROPELLER_CXX_FLAGS}")

set(CMAKE_CXX_FLAGS_RELWITHDEBINFO
"-Os -g ${PROPELLER_CXX_FLAGS}")

# Linker Flags #################################################################

set(PROPELLER_LINKER_FLAGS
"-Wl,--gc-sections -lm")

set(CMAKE_EXE_LINKER_FLAGS
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_EXE_LINKER_FLAGS_DEBUG
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_EXE_LINKER_FLAGS_RELEASE
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_SHARED_LINKER_FLAGS
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_SHARED_LINKER_FLAGS_DEBUG
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_SHARED_LINKER_FLAGS_RELEASE
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_MODULE_LINKER_FLAGS
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_MODULE_LINKER_FLAGS_DEBUG
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_MODULE_LINKER_FLAGS_RELEASE
"${PROPELLER_LINKER_FLAGS}")

set(CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO
"${PROPELLER_LINKER_FLAGS}")

################################################################################
# @file
# @par MIT License - TERMS OF USE:
# @n Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# @n
# @n The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# @n
# @n THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
################################################################################
