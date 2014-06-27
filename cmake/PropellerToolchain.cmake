################################################################################
# @file
# Propeller Toolchain CMake
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

set(CMAKE_SYSTEM_NAME Propeller)

set(CMAKE_C_COMPILER propeller-elf-gcc)
set(CMAKE_CXX_COMPILER propeller-elf-g++)

if(EXISTS ${CMAKE_CURRENT_LIST_DIR}/Platform/Propeller.cmake)
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
endif()

if(WIN32)
    include(Platform/WindowsPaths)
elseif(UNIX)
    include(Platform/UnixPaths)
    if(APPLE)
        list(APPEND CMAKE_SYSTEM_PREFIX_PATH
        ~/Applications /Applications /Developer/Applications /sw /opt/local)
    endif()
endif()

if(PROPELLER_SDK_PATH)
    list(APPEND CMAKE_SYSTEM_PREFIX_PATH ${PROPELLER_SDK_PATH}/propeller-gcc)
else()
    message(FATAL_ERROR "PROPELLER_SDK_PATH not defined!")
endif()

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
