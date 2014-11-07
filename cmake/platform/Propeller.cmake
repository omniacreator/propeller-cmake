################################################################################
# @file
# Propeller CMake
#
# @version @n 1.0
# @date @n 11/1/2014
#
# @author @n Kwabena W. Agyeman
# @copyright @n (c) 2014 Kwabena W. Agyeman
# @n All rights reserved - Please see the end of the file for the terms of use
#
# @par Update History:
# @n v1.0 - Original release - 11/1/2014
################################################################################

# Inspired By: https://github.com/queezythegreat/arduino-cmake #################

cmake_minimum_required(VERSION "2.8")
cmake_policy(VERSION "2.8")

# C Flags ######################################################################

set(PROPELLER_C_FLAGS
"-ffunction-sections -fdata-sections -m32bit-doubles -Wall -std=c99")

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

set(PROPELLER_CXX_FLAGS
"${PROPELLER_C_FLAGS} -fno-exceptions -fno-rtti -std=gnu++0x")

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

# Executable Paths #############################################################

find_program(CMAKE_OBJCOPY NAMES "propeller-elf-objcopy")
find_program(CMAKE_OBJDUMP NAMES "propeller-elf-objdump")

find_program(CMAKE_OBJLOAD NAMES "propeller-load")
find_program(CMAKE_OBJSPIN NAMES "openspin")

################################################################################
# generate_cogc_object() - Compiles cogc source into a linkable cogc object.
#
# INPUT = COGC_FILE - Full path to input cogc file.
# OUTPUT = COGC_FILE_OBJECT - Full path to output cogc object file.
################################################################################

function(generate_cogc_object COGC_FILE)

    get_filename_component(COGC_FILE_EXT "${COGC_FILE}" EXT)
    string(TOLOWER "${COGC_FILE_EXT}" COGC_FILE_EXT)

    if("${COGC_FILE_EXT}" STREQUAL ".cogc")
        set(COGC_COMPILIER "${CMAKE_C_COMPILER}")
        set(COGC_FLAGS "${CMAKE_C_FLAGS} -xc -mcog -r")
    elseif("${COGC_FILE_EXT}" STREQUAL ".cogcpp")
        set(COGC_COMPILIER "${CMAKE_CXX_COMPILER}")
        set(COGC_FLAGS "${CMAKE_CXX_FLAGS} -xc++ -mcog -r")
    else()
        message(FATAL_ERROR "Unknown file type \"${COGC_FILE_EXT}\"!")
    endif()

    string(REGEX REPLACE "\\\\" "/" COGC_FILE_OBJ "${COGC_FILE}")
    string(REGEX REPLACE "[^0-9A-Za-z./]" "_" COGC_FILE_OBJ "${COGC_FILE_OBJ}")

    set(COGC_FILE_OBJ
    "${CMAKE_BINARY_DIR}/CMakeFiles/cogc.dir/${COGC_FILE_OBJ}.obj")

    set_source_files_properties("${COGC_FILE_OBJ}" PROPERTIES
    EXTERNAL_OBJECT TRUE GENERATED TRUE)

    separate_arguments(COGC_FLAGS)
    get_filename_component(COGC_FILE_OBJ_NAME "${COGC_FILE_OBJ}" NAME)

    add_custom_command(OUTPUT "${COGC_FILE_OBJ}"
    COMMAND "${COGC_COMPILIER}"
    ARGS ${COGC_FLAGS}
    ARGS -o "${COGC_FILE_OBJ}"
    ARGS -c "${COGC_FILE}"
    COMMAND "${CMAKE_OBJCOPY}"
    ARGS --localize-text --rename-section
    ARGS .text="${COGC_FILE_OBJ_NAME}"
    ARGS "${COGC_FILE_OBJ}")

    set(COGC_FILE_OBJECT "${COGC_FILE_OBJ}" PARENT_SCOPE)

endfunction()

################################################################################
# generate_spin_object() - Compiles spin source into a linkable spin object.
#
# INPUT = SPIN_FILE - Full path to input spin file.
# OUTPUT = SPIN_FILE_OBJECT - Full path to output spin object file.
################################################################################

function(generate_spin_object SPIN_FILE)

    get_filename_component(SPIN_FILE_EXT "${SPIN_FILE}" EXT)
    string(TOLOWER "${SPIN_FILE_EXT}" SPIN_FILE_EXT)

    if(NOT "${SPIN_FILE_EXT}" STREQUAL ".spin")
        message(FATAL_ERROR "Unknown file type \"${SPIN_FILE_EXT}\"!")
    endif()

    string(REGEX REPLACE "\\\\" "/" SPIN_FILE_OBJ "${SPIN_FILE}")
    string(REGEX REPLACE "[^0-9A-Za-z./]" "_" SPIN_FILE_OBJ "${SPIN_FILE_OBJ}")

    set(SPIN_FILE_OBJ
    "${CMAKE_BINARY_DIR}/CMakeFiles/spin.dir/${SPIN_FILE_OBJ}.obj")

    set_source_files_properties("${SPIN_FILE_OBJ}" PROPERTIES
    EXTERNAL_OBJECT TRUE GENERATED TRUE)

    add_custom_command(OUTPUT "${SPIN_FILE_OBJ}"
    COMMAND "${CMAKE_OBJSPIN}"
    ARGS -I "${PROPELLER_SDK_PATH}/propeller-gcc/spin"
    ARGS -o "${SPIN_FILE_OBJ}"
    ARGS -c "${SPIN_FILE}"
    COMMAND "${CMAKE_OBJCOPY}"
    ARGS -I binary -B propeller -O propeller-elf-gcc
    ARGS "${SPIN_FILE_OBJ}"
    ARGS "${SPIN_FILE_OBJ}")

    set(SPIN_FILE_OBJECT "${SPIN_FILE_OBJ}" PARENT_SCOPE)

endfunction()

################################################################################
# parse_side_file() - Gets source paths from a side file.
#
# INPUT = SIDE_FILE - Full path to input side file.
# OUTPUT = SIDE_FILE_SOURCES - Source file list.
# OUTPUT = SIDE_FILE_HEADERS - Header file list.
# OUTPUT = SIDE_FILE_FOLDERS - Folder list.
################################################################################

function(parse_side_file SIDE_FILE)

    set(SIDE_FILE_SOURCE_LIST "")
    set(SIDE_FILE_HEADER_LIST "")
    set(SIDE_FILE_FOLDER_LIST "")

    get_filename_component(SIDE_FILE_PATH "${SIDE_FILE}" DIRECTORY)

    file(STRINGS "${SIDE_FILE}" SIDE_FILE_STRINGS)

    foreach(SIDE_FILE_STRING ${SIDE_FILE_STRINGS})
        if("${SIDE_FILE_STRING}" MATCHES "^[^>].*$")

            if("${SIDE_FILE_STRING}" MATCHES "^.+ -> .+$")
                string(REGEX REPLACE "^.+ -> (.+)$" "\\1"
                SIDE_FILE_STRING "${SIDE_FILE_STRING}")
            endif()

            set(SIDE_FILE_SOURCE_FILE "${SIDE_FILE_PATH}/${SIDE_FILE_STRING}")

            get_filename_component(FILE_D "${SIDE_FILE_SOURCE_FILE}" DIRECTORY)
            list(APPEND SIDE_FILE_FOLDER_LIST "${FILE_D}")

            get_filename_component(FILE_TYPE "${SIDE_FILE_SOURCE_FILE}" EXT)
            string(TOLOWER "${FILE_TYPE}" FILE_TYPE)

            if("${FILE_TYPE}" STREQUAL ".side")
                parse_side_file("${SIDE_FILE_SOURCE_FILE}")
                list(APPEND SIDE_FILE_SOURCE_LIST ${SIDE_FILE_SOURCES})
                list(APPEND SIDE_FILE_HEADER_LIST ${SIDE_FILE_HEADERS})
                list(APPEND SIDE_FILE_FOLDER_LIST ${SIDE_FILE_FOLDERS})
            elseif(("${FILE_TYPE}" STREQUAL ".cogc")
            OR ("${FILE_TYPE}" STREQUAL ".cogcpp"))
                generate_cogc_object("${SIDE_FILE_SOURCE_FILE}")
                list(APPEND SIDE_FILE_SOURCE_LIST "${COGC_FILE_OBJECT}")
            elseif("${FILE_TYPE}" STREQUAL ".spin")
                generate_spin_object("${SIDE_FILE_SOURCE_FILE}")
                list(APPEND SIDE_FILE_SOURCE_LIST "${SPIN_FILE_OBJECT}")
            elseif(("${FILE_TYPE}" STREQUAL ".c")
            OR ("${FILE_TYPE}" STREQUAL ".i")
            OR ("${FILE_TYPE}" STREQUAL ".cpp")
            OR ("${FILE_TYPE}" STREQUAL ".ii")
            OR ("${FILE_TYPE}" STREQUAL ".cc")
            OR ("${FILE_TYPE}" STREQUAL ".cp")
            OR ("${FILE_TYPE}" STREQUAL ".cxx")
            OR ("${FILE_TYPE}" STREQUAL ".c++")
            OR ("${FILE_TYPE}" STREQUAL ".s")
            OR ("${FILE_TYPE}" STREQUAL ".sx"))
                list(APPEND SIDE_FILE_SOURCE_LIST "${SIDE_FILE_SOURCE_FILE}")
            elseif(("${FILE_TYPE}" STREQUAL ".h")
            OR ("${FILE_TYPE}" STREQUAL ".hpp")
            OR ("${FILE_TYPE}" STREQUAL ".hh")
            OR ("${FILE_TYPE}" STREQUAL ".hp")
            OR ("${FILE_TYPE}" STREQUAL ".hxx")
            OR ("${FILE_TYPE}" STREQUAL ".h++"))
                list(APPEND SIDE_FILE_HEADER_LIST "${SIDE_FILE_SOURCE_FILE}")
            else()
                message(FATAL_ERROR "Unknown file type \"${FILE_TYPE}\"!")
            endif()

        endif()
    endforeach()

    list(REMOVE_DUPLICATES SIDE_FILE_SOURCE_LIST)
    list(REMOVE_DUPLICATES SIDE_FILE_HEADER_LIST)
    list(REMOVE_DUPLICATES SIDE_FILE_FOLDER_LIST)

    set(SIDE_FILE_SOURCES ${SIDE_FILE_SOURCE_LIST} PARENT_SCOPE)
    set(SIDE_FILE_HEADERS ${SIDE_FILE_HEADER_LIST} PARENT_SCOPE)
    set(SIDE_FILE_FOLDERS ${SIDE_FILE_FOLDER_LIST} PARENT_SCOPE)

endfunction()

################################################################################
# parse_file_or_folder_path() - Gets source paths from a file or folder path.
#
# INPUT = FF_PATH - Full path to input file or folder path.
# OUTPUT = FF_PATH_SOURCES - Source file list.
# OUTPUT = FF_PATH_HEADERS - Header file list.
# OUTPUT = FF_PATH_FOLDERS - Folder list.
################################################################################

function(parse_file_or_folder_path FF_PATH)

    set(FF_PATH_SOURCE_LIST "")
    set(FF_PATH_HEADER_LIST "")
    set(FF_PATH_FOLDER_LIST "")

    if(IS_DIRECTORY "${FF_PATH}")

        list(APPEND FF_PATH_FOLDER_LIST "${FF_PATH}")

        get_filename_component(FF_PATH_NAME "${FF_PATH}" NAME)

        if(EXISTS "${FF_PATH}/${FF_PATH_NAME}.side")

            parse_side_file("${FF_PATH}/${FF_PATH_NAME}.side")
            list(APPEND FF_PATH_SOURCE_LIST ${SIDE_FILE_SOURCES})
            list(APPEND FF_PATH_HEADER_LIST ${SIDE_FILE_HEADERS})
            list(APPEND FF_PATH_FOLDER_LIST ${SIDE_FILE_FOLDERS})

        else()

            file(GLOB_RECURSE SIDE_FILES
            "${FF_PATH}/*.side")

            foreach(SIDE_FILE ${SIDE_FILES})

                get_filename_component(FILE_D "${SIDE_FILE}" DIRECTORY)
                list(APPEND FF_PATH_FOLDER_LIST "${FILE_D}")

                parse_side_file("${SIDE_FILE}")
                list(APPEND FF_PATH_SOURCE_LIST ${SIDE_FILE_SOURCES})
                list(APPEND FF_PATH_HEADER_LIST ${SIDE_FILE_HEADERS})
                list(APPEND FF_PATH_FOLDER_LIST ${SIDE_FILE_FOLDERS})

            endforeach()

            file(GLOB_RECURSE COGC_FILES
            "${FF_PATH}/*.cogc"
            "${FF_PATH}/*.cogcpp")

            foreach(COGC_FILE ${COGC_FILES})

                get_filename_component(FILE_D "${SPIN_FILE}" DIRECTORY)
                list(APPEND FF_PATH_FOLDER_LIST "${FILE_D}")

                generate_cogc_object("${COGC_FILE}")
                list(APPEND FF_PATH_SOURCE_LIST "${COGC_FILE_OBJECT}")

            endforeach()

            file(GLOB_RECURSE SPIN_FILES
            "${LIBRARY_PATH}/*.spin")

            foreach(SPIN_FILE ${SPIN_FILES})

                get_filename_component(FILE_D "${SPIN_FILE}" DIRECTORY)
                list(APPEND FF_PATH_FOLDER_LIST "${FILE_D}")

                generate_spin_object("${SPIN_FILE}")
                list(APPEND FF_PATH_SOURCE_LIST "${SPIN_FILE_OBJECT}")

            endforeach()

            file(GLOB_RECURSE SOURCE_FILES
            "${FF_PATH}/*.c"
            "${FF_PATH}/*.i"
            "${FF_PATH}/*.cpp"
            "${FF_PATH}/*.ii"
            "${FF_PATH}/*.cc"
            "${FF_PATH}/*.cp"
            "${FF_PATH}/*.cxx"
            "${FF_PATH}/*.c++"
            "${FF_PATH}/*.s"
            "${FF_PATH}/*.sx")

            foreach(SOURCE_FILE ${SOURCE_FILES})
                get_filename_component(FILE_D "${SOURCE_FILE}" DIRECTORY)
                list(APPEND FF_PATH_FOLDER_LIST "${FILE_D}")
            endforeach()

            list(APPEND FF_PATH_SOURCE_LIST ${SOURCE_FILES})

            file(GLOB_RECURSE HEADER_FILES
            "${FF_PATH}/*.h"
            "${FF_PATH}/*.hpp"
            "${FF_PATH}/*.hh"
            "${FF_PATH}/*.hp"
            "${FF_PATH}/*.hxx"
            "${FF_PATH}/*.h++")

            foreach(HEADER_FILE ${HEADER_FILES})
                get_filename_component(FILE_D "${HEADER_FILE}" DIRECTORY)
                list(APPEND FF_PATH_FOLDER_LIST "${FILE_D}")
            endforeach()

            list(APPEND FF_PATH_HEADER_LIST ${HEADER_FILES})

        endif()

    else()

        get_filename_component(FILE_D "${FF_PATH}" DIRECTORY)
        list(APPEND FF_PATH_FOLDER_LIST "${FILE_D}")

        get_filename_component(FILE_TYPE "${FF_PATH}" EXT)
        string(TOLOWER "${FILE_TYPE}" FILE_TYPE)

        if("${FILE_TYPE}" STREQUAL ".side")
            parse_side_file("${FF_PATH}")
            list(APPEND FF_PATH_SOURCE_LIST ${SIDE_FILE_SOURCES})
            list(APPEND FF_PATH_HEADER_LIST ${SIDE_FILE_HEADERS})
            list(APPEND FF_PATH_FOLDER_LIST ${SIDE_FILE_FOLDERS})
        elseif(("${FILE_TYPE}" STREQUAL ".cogc")
        OR ("${FILE_TYPE}" STREQUAL ".cogcpp"))
            generate_cogc_object("${FF_PATH}")
            list(APPEND FF_PATH_SOURCE_LIST "${COGC_FILE_OBJECT}")
        elseif("${FILE_TYPE}" STREQUAL ".spin")
            generate_spin_object("${FF_PATH}")
            list(APPEND FF_PATH_SOURCE_LIST "${SPIN_FILE_OBJECT}")
        elseif(("${FILE_TYPE}" STREQUAL ".c")
        OR ("${FILE_TYPE}" STREQUAL ".i")
        OR ("${FILE_TYPE}" STREQUAL ".cpp")
        OR ("${FILE_TYPE}" STREQUAL ".ii")
        OR ("${FILE_TYPE}" STREQUAL ".cc")
        OR ("${FILE_TYPE}" STREQUAL ".cp")
        OR ("${FILE_TYPE}" STREQUAL ".cxx")
        OR ("${FILE_TYPE}" STREQUAL ".c++")
        OR ("${FILE_TYPE}" STREQUAL ".s")
        OR ("${FILE_TYPE}" STREQUAL ".sx"))
            list(APPEND FF_PATH_SOURCE_LIST "${FF_PATH}")
        elseif(("${FILE_TYPE}" STREQUAL ".h")
        OR ("${FILE_TYPE}" STREQUAL ".hpp")
        OR ("${FILE_TYPE}" STREQUAL ".hh")
        OR ("${FILE_TYPE}" STREQUAL ".hp")
        OR ("${FILE_TYPE}" STREQUAL ".hxx")
        OR ("${FILE_TYPE}" STREQUAL ".h++"))
            list(APPEND FF_PATH_HEADER_LIST "${FF_PATH}")
        else()
            message(FATAL_ERROR "Unknown file type \"${FILE_TYPE}\"!")
        endif()

    endif()

    list(REMOVE_DUPLICATES FF_PATH_SOURCE_LIST)
    list(REMOVE_DUPLICATES FF_PATH_HEADER_LIST)
    list(REMOVE_DUPLICATES FF_PATH_FOLDER_LIST)

    set(FF_PATH_SOURCES ${FF_PATH_SOURCE_LIST} PARENT_SCOPE)
    set(FF_PATH_HEADERS ${FF_PATH_HEADER_LIST} PARENT_SCOPE)
    set(FF_PATH_FOLDERS ${FF_PATH_FOLDER_LIST} PARENT_SCOPE)

endfunction()

################################################################################
# setup_library() - Setup a library to be built.
#
# INPUT = FF_PATH - Full path to library project file or folder.
# INPUT = EXTRA_COMPILE_FLAGS - Extra compile flags for the library.
# INPUT = EXTRA_LINK_FLAGS - Extra link flags for the library.
# OUTPUT = LIB_TARGET - Library target name.
################################################################################

function(setup_library FF_PATH EXTRA_COMPILE_FLAGS EXTRA_LINK_FLAGS)

    parse_file_or_folder_path("${FF_PATH}")
    include_directories(${FF_PATH_FOLDERS})

    if(FF_PATH_SOURCES)

        get_filename_component(FF_PATH_NAME "${FF_PATH}" NAME_WE)
        string(REGEX REPLACE "[^0-9A-Za-z]" "_" FF_PATH_NAME "${FF_PATH_NAME}")

        list(APPEND FF_PATH_SOURCES ${FF_PATH_HEADERS})
        add_library("${FF_PATH_NAME}" STATIC ${FF_PATH_SOURCES})

        set_target_properties("${FF_PATH_NAME}" PROPERTIES
        COMPILE_FLAGS "${EXTRA_COMPILE_FLAGS} ${COMPILE_FLAGS}"
        LINK_FLAGS "${EXTRA_LINK_FLAGS} ${LINK_FLAGS}"
        SUFFIX ".a")

        set(LIB_TARGET "${FF_PATH_NAME}" PARENT_SCOPE)

    else()
        set(LIB_TARGET "" PARENT_SCOPE)
    endif()

endfunction()

################################################################################
# setup_executable() - Setup an executable to be built.
#
# INPUT = FF_PATH - Full path to executable project file or folder.
# INPUT = EXTRA_COMPILE_FLAGS - Extra compile flags for the executable.
# INPUT = EXTRA_LINK_FLAGS - Extra link flags for the executable.
# OUTPUT = EXE_TARGET - Executable target name.
################################################################################

function(setup_executable FF_PATH EXTRA_COMPILE_FLAGS EXTRA_LINK_FLAGS)

    parse_file_or_folder_path("${FF_PATH}")
    include_directories(${FF_PATH_FOLDERS})

    if(FF_PATH_SOURCES)

        get_filename_component(FF_PATH_NAME "${FF_PATH}" NAME_WE)
        string(REGEX REPLACE "[^0-9A-Za-z]" "_" FF_PATH_NAME "${FF_PATH_NAME}")

        list(APPEND FF_PATH_SOURCES ${FF_PATH_HEADERS})
        add_executable("${FF_PATH_NAME}" ${FF_PATH_SOURCES})

        set_target_properties("${FF_PATH_NAME}" PROPERTIES
        COMPILE_FLAGS "${EXTRA_COMPILE_FLAGS} ${COMPILE_FLAGS}"
        LINK_FLAGS "${EXTRA_LINK_FLAGS} ${LINK_FLAGS}"
        SUFFIX ".elf")

        set(EXE_TARGET "${FF_PATH_NAME}" PARENT_SCOPE)

    else()
        set(EXE_TARGET "" PARENT_SCOPE)
    endif()

endfunction()

################################################################################
# setup_libraries() - Setups all libraries to be built.
#
# INPUT = EXTRA_COMPILE_FLAGS - Extra compile flags for the library.
# INPUT = EXTRA_LINK_FLAGS - Extra link flags for the library.
# OUTPUT = LIB_TARGETS - Library target list.
################################################################################

function(setup_libraries EXTRA_COMPILE_FLAGS EXTRA_LINK_FLAGS)

    # Step 1 ###################################################################

    set(LIBRARY_PATH_LIST "")

    get_property(LIBRARY_PATHS DIRECTORY PROPERTY LINK_DIRECTORIES)

    foreach(LIBRARY_PATH ${LIBRARY_PATHS})

        get_filename_component(FOLDER_NAME "${LIBRARY_PATH}" NAME)

        if("${FOLDER_NAME}" STREQUAL "libraries")

            file(GLOB LIBRARIES "${LIBRARY_PATH}/*")

            foreach(LIBRARY ${LIBRARIES})
                if(IS_DIRECTORY "${LIBRARY}")
                    list(APPEND LIBRARY_PATH_LIST "${LIBRARY}")
                endif()
            endforeach()

        elseif("${FOLDER_NAME}" STREQUAL "Simple Libraries")

            file(GLOB_RECURSE LIBRARIES "${LIBRARY_PATH}/*.side")
            list(APPEND LIBRARY_PATH_LIST ${LIBRARIES})

        else()
            message(FATAL_ERROR "Unknown libs type \"${FOLDER_NAME}\"!")
        endif()

    endforeach()

    list(REMOVE_DUPLICATES LIBRARY_PATH_LIST)

    # Step 2 ###################################################################

    set(LIB_TARGET_LIST "")

    foreach(LIBRARY_PATH ${LIBRARY_PATH_LIST})

        setup_library("${LIBRARY_PATH}"
        "${EXTRA_COMPILE_FLAGS}" "${EXTRA_LINK_FLAGS}")

        if(LIB_TARGET)
            list(APPEND LIB_TARGET_LIST "${LIB_TARGET}")
        endif()

    endforeach()

    set(LIB_TARGETS ${LIB_TARGET_LIST} PARENT_SCOPE)

endfunction()

################################################################################
# setup_upload() - Setup upload.
#
# INPUT = TARGET_NAME - Target name.
################################################################################

function(setup_upload TARGET_NAME)

    set(UPLOAD_COMMAND_LIST "-r" "-e")

    if(DEFINED ${TARGET_NAME}_BOARD
    AND NOT "${${TARGET_NAME}_BOARD}" STREQUAL "")
        list(APPEND UPLOAD_COMMAND_LIST "-b" "${${TARGET_NAME}_BOARD}")
    endif()

    if(DEFINED ${TARGET_NAME}_PORT
    AND NOT "${${TARGET_NAME}_PORT}" STREQUAL "")
        list(APPEND UPLOAD_COMMAND_LIST "-p" "${${TARGET_NAME}_PORT}")
    endif()

    if(DEFINED ${TARGET_NAME}_CF
    AND NOT "${${TARGET_NAME}_CF}" STREQUAL "")
        list(APPEND UPLOAD_COMMAND_LIST "-D" "clkfreq=${${TARGET_NAME}_CF}")
    endif()

    if(DEFINED ${TARGET_NAME}_CM
    AND NOT "${${TARGET_NAME}_CM}" STREQUAL "")
        list(APPEND UPLOAD_COMMAND_LIST "-D" "clkmode=${${TARGET_NAME}_CM}")
    endif()

    add_custom_target("upload"
    COMMAND "${CMAKE_OBJLOAD}"
    ${UPLOAD_COMMAND_LIST}
    "${CMAKE_BINARY_DIR}/${TARGET_NAME}.elf"
    DEPENDS "${TARGET_NAME}")

endfunction()

################################################################################
# generate_propeller_firmware() - Main Function.
#
# INPUT = TARGET_NAME - Target name.
# INPUT = ${TARGET_NAME}_FPATH - File or folder path.
# INPUT = ${TARGET_NAME}_MM - Memory model.
# INPUT = ${TARGET_NAME}_BOARD - Board name (optional).
# INPUT = ${TARGET_NAME}_PORT - Port name (optional).
# INPUT = ${TARGET_NAME}_CF - Clock frequency (optional).
# INPUT = ${TARGET_NAME}_CM - Clock mode (optional).
################################################################################

function(generate_propeller_firmware TARGET_NAME)

    if(NOT DEFINED ${TARGET_NAME}_FPATH)
        message(FATAL_ERROR "File or folder path is not defined!")
    endif()

    if("${${TARGET_NAME}_FPATH}" STREQUAL "")
        message(FATAL_ERROR "File or folder path is empty!")
    endif()

    if(NOT DEFINED ${TARGET_NAME}_MM)
        message(FATAL_ERROR "Memory model is not defined!")
    endif()

    if("${${TARGET_NAME}_MM}" STREQUAL "")
        message(FATAL_ERROR "Memory model is empty!")
    endif()

    if((NOT "${${TARGET_NAME}_MM}" STREQUAL "cmm")
    AND (NOT "${${TARGET_NAME}_MM}" STREQUAL "lmm"))
        message(FATAL_ERROR "Unknown mem model \"${${TARGET_NAME}_MM}\"!")
    endif()

    add_definitions("-D__PROPELLER__")
    # add_definitions("-Dprintf=__simple_printf")

    setup_libraries(
    "-m${${TARGET_NAME}_MM}"
    "-m${${TARGET_NAME}_MM}")

    setup_executable("${${TARGET_NAME}_FPATH}"
    "-m${${TARGET_NAME}_MM}"
    "-m${${TARGET_NAME}_MM}")

    target_link_libraries("${EXE_TARGET}" ${LIB_TARGETS})
    setup_upload("${EXE_TARGET}")

endfunction()

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
