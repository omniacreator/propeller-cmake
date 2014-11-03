################################################################################
# @file
# Propeller Toolchain CMake
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

include("CMakeForceCompiler")

set(CMAKE_SYSTEM_NAME "Propeller")
cmake_force_c_compiler("propeller-elf-gcc" GNU)
cmake_force_cxx_compiler("propeller-elf-g++" GNU)

if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/Platform/Propeller.cmake")
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")
else()
    message(FATAL_ERROR
    "\"${CMAKE_CURRENT_LIST_DIR}/Platform/Propeller.cmake\" not found!")
endif()

if(UNIX)
    include("Platform/UnixPaths")
    find_path(PROPELLER_SDK_PATH NAMES
    "propeller-gcc/bin/propeller-elf-gcc")
elseif(WIN32)
    include("Platform/WindowsPaths")
    find_path(PROPELLER_SDK_PATH NAMES
    "propeller-gcc/bin/propeller-elf-gcc.exe")
else()
    message(FATAL_ERROR "Unknown platform!")
endif()

if(EXISTS "${PROPELLER_SDK_PATH}/propeller-gcc")
    list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${PROPELLER_SDK_PATH}/propeller-gcc")
else()
    message(FATAL_ERROR
    "\"${PROPELLER_SDK_PATH}/propeller-gcc\" not found!")
endif()

set(CMAKE_FIND_ROOT_PATH "${PROPELLER_SDK_PATH}/propeller-gcc")

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
