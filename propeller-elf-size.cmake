################################################################################
# @file
# Propeller ELF Size Script
#
# @version @n 1.0
# @date @n 11/9/2014
#
# @author @n Kwabena W. Agyeman
# @copyright @n (c) 2014 Kwabena W. Agyeman
# @n All rights reserved - Please see the end of the file for the terms of use
#
# @par Update History:
# @n v1.0 - Original release - 11/9/2014
################################################################################

# Inspired By: https://github.com/queezythegreat/arduino-cmake #################

cmake_minimum_required(VERSION "2.8")
cmake_policy(VERSION "2.8")

set(PROP_SIZE "32768")

if(NOT DEFINED ELF_FILE_PATH)
    message(FATAL_ERROR "ELF_FILE_PATH is not defined!")
endif()

if("${ELF_FILE_PATH}" STREQUAL "")
    message(FATAL_ERROR "ELF_FILE_PATH is empty!")
endif()

if(NOT DEFINED PROPELLER_ELF_SIZE)
    message(FATAL_ERROR "PROPELLER_ELF_SIZE is not defined!")
endif()

if("${PROPELLER_ELF_SIZE}" STREQUAL "")
    message(FATAL_ERROR "PROPELLER_ELF_SIZE is empty!")
endif()

execute_process(COMMAND "${PROPELLER_ELF_SIZE}" "${ELF_FILE_PATH}"
OUTPUT_VARIABLE SIZE_OUTPUT)

set(S "[\t ]")
set(W "[^\t ]")

list(APPEND EXPRESSION
"^" "${S}*"
"text" "${S}+" "data" "${S}+" "bss"
"${S}+" "dec" "${S}+" "hex" "${S}+" "filename"
"${S}*" "[\n\r]+" "${S}*"
"(${W}+)" "${S}+" "(${W}+)" "${S}+" "(${W}+)"
"${S}+" "(${W}+)" "${S}+" "(${W}+)" "${S}+" "(.+)"
"${S}*" "$")

string(REPLACE ";" "" EXPRESSION "${EXPRESSION}")

string(REGEX REPLACE "${EXPRESSION}" "\\1" M_TEXT "${SIZE_OUTPUT}")
string(REGEX REPLACE "${EXPRESSION}" "\\2" M_DATA "${SIZE_OUTPUT}")
string(REGEX REPLACE "${EXPRESSION}" "\\3" M_BSS "${SIZE_OUTPUT}")
string(REGEX REPLACE "${EXPRESSION}" "\\4" M_DEC "${SIZE_OUTPUT}")
string(REGEX REPLACE "${EXPRESSION}" "\\5" M_HEX "${SIZE_OUTPUT}")
string(REGEX REPLACE "${EXPRESSION}" "\\6" M_FILENAME "${SIZE_OUTPUT}")

math(EXPR P_SIZE "${M_TEXT}")
math(EXPR P_PER_L "(${P_SIZE}*100)/${PROP_SIZE}")
math(EXPR P_PER_R "((((${P_SIZE}*10000)/${PROP_SIZE})+5)/10)%10")

math(EXPR D_SIZE "${M_DATA}+${M_BSS}")
math(EXPR D_PER_L "(${D_SIZE}*100)/(${PROP_SIZE}-${P_SIZE})")
math(EXPR D_PER_R "((((${D_SIZE}*10000)/(${PROP_SIZE}-${P_SIZE}))+5)/10)%10")

message("Firmware Size: "
        "[Program: ${P_SIZE} bytes (${P_PER_L}.${P_PER_R}%)] "
        "[Data: ${D_SIZE} bytes (${D_PER_L}.${D_PER_R}%)] "
        "on p8x32a")

math(EXPR P_SIZE "${M_TEXT}")
math(EXPR P_PER_L "(${P_SIZE}*100)/${PROP_SIZE}")
math(EXPR P_PER_R "((((${P_SIZE}*10000)/${PROP_SIZE})+5)/10)%10")

math(EXPR D_SIZE "${M_DATA}")
math(EXPR D_PER_L "(${D_SIZE}*100)/(${PROP_SIZE}-${P_SIZE})")
math(EXPR D_PER_R "((((${D_SIZE}*10000)/(${PROP_SIZE}-${P_SIZE}))+5)/10)%10")

message("EEPROM Size: "
        "[Program: ${P_SIZE} bytes (${P_PER_L}.${P_PER_R}%)] "
        "[Data: ${D_SIZE} bytes (${D_PER_L}.${D_PER_R}%)] "
        "on p8x32a")

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
