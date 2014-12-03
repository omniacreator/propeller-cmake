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

function(LE_HEX_2_DEC DEC_STRING HEX_STRING)

    set(SUM "0")

    string(TOUPPER "${HEX_STRING}" HEX_STRING)
    string(LENGTH "${HEX_STRING}" HEX_STRING_LENGTH)

    set(NIBBLE "4")
    set(BYTE "0")

    set(I "${HEX_STRING_LENGTH}")
    while("${I}")

        math(EXPR INDEX "${HEX_STRING_LENGTH} - ${I}")
        string(SUBSTRING "${HEX_STRING}" "${INDEX}" "1" CHAR)

        if("${CHAR}" STREQUAL "0")
            math(EXPR SUM "${SUM} + (0 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "1")
            math(EXPR SUM "${SUM} + (1 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "2")
            math(EXPR SUM "${SUM} + (2 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "3")
            math(EXPR SUM "${SUM} + (3 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "4")
            math(EXPR SUM "${SUM} + (4 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "5")
            math(EXPR SUM "${SUM} + (5 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "6")
            math(EXPR SUM "${SUM} + (6 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "7")
            math(EXPR SUM "${SUM} + (7 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "8")
            math(EXPR SUM "${SUM} + (8 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "9")
            math(EXPR SUM "${SUM} + (9 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "A")
            math(EXPR SUM "${SUM} + (10 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "B")
            math(EXPR SUM "${SUM} + (11 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "C")
            math(EXPR SUM "${SUM} + (12 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "D")
            math(EXPR SUM "${SUM} + (13 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "E")
            math(EXPR SUM "${SUM} + (14 << (${NIBBLE} + ${BYTE}))")
        elseif("${CHAR}" STREQUAL "F")
            math(EXPR SUM "${SUM} + (15 << (${NIBBLE} + ${BYTE}))")
        else()
            message(FATAL_ERROR "Unknown hexadecimal character \"${CHAR}\"!")
        endif()

        if("${NIBBLE}" STREQUAL "4")
            set(NIBBLE "0")
        else()
            set(NIBBLE "4")
            math(EXPR BYTE "${BYTE} + 8")
        endif()

        math(EXPR I "${I} - 1")
    endwhile()

    set("${DEC_STRING}" "${SUM}" PARENT_SCOPE)

endfunction()

set(PROP_SIZE "32768")

if(NOT DEFINED BIN_FILE_PATH)
    message(FATAL_ERROR "BIN_FILE_PATH is not defined!")
endif()

if("${BIN_FILE_PATH}" STREQUAL "")
    message(FATAL_ERROR "BIN_FILE_PATH is empty!")
endif()

file(READ "${BIN_FILE_PATH}" CLOCK_FREQ LIMIT "4" OFFSET "0" HEX)
file(READ "${BIN_FILE_PATH}" CLOCK_MODE LIMIT "1" OFFSET "4" HEX)
file(READ "${BIN_FILE_PATH}" CHECKSUM LIMIT "1" OFFSET "5" HEX)

file(READ "${BIN_FILE_PATH}" PBASE LIMIT "2" OFFSET "6" HEX)
file(READ "${BIN_FILE_PATH}" VBASE LIMIT "2" OFFSET "8" HEX)
file(READ "${BIN_FILE_PATH}" DBASE LIMIT "2" OFFSET "10" HEX)
file(READ "${BIN_FILE_PATH}" PCURR LIMIT "2" OFFSET "12" HEX)
file(READ "${BIN_FILE_PATH}" DCURR LIMIT "2" OFFSET "14" HEX)

le_hex_2_dec(CLOCK_FREQ "${CLOCK_FREQ}")
le_hex_2_dec(CLOCK_MODE "${CLOCK_MODE}")
le_hex_2_dec(CHECKSUM "${CHECKSUM}")

le_hex_2_dec(PBASE "${PBASE}")
le_hex_2_dec(VBASE "${VBASE}")
le_hex_2_dec(DBASE "${DBASE}")
le_hex_2_dec(PCURR "${PCURR}")
le_hex_2_dec(DCURR "${DCURR}")

math(EXPR P_SIZE "${VBASE}")
math(EXPR P_PER_L "(${P_SIZE}*100)/${PROP_SIZE}")
math(EXPR P_PER_R "((((${P_SIZE}*10000)/${PROP_SIZE})+5)/10)%10")

math(EXPR D_SIZE "${DBASE}-${VBASE}")
math(EXPR D_PER_L "(${D_SIZE}*100)/${PROP_SIZE}")
math(EXPR D_PER_R "((((${D_SIZE}*10000)/${PROP_SIZE})+5)/10)%10")

message("Firmware Size: "
        "[Program: ${P_SIZE} bytes (${P_PER_L}.${P_PER_R}%)] "
        "[Data: ${D_SIZE} bytes (${D_PER_L}.${D_PER_R}%)] "
        "on p8x32a")

math(EXPR P_SIZE "${VBASE}")
math(EXPR P_PER_L "(${P_SIZE}*100)/${PROP_SIZE}")
math(EXPR P_PER_R "((((${P_SIZE}*10000)/${PROP_SIZE})+5)/10)%10")

math(EXPR D_SIZE "${DBASE}-${VBASE}")
math(EXPR D_PER_L "(${D_SIZE}*100)/${PROP_SIZE}")
math(EXPR D_PER_R "((((${D_SIZE}*10000)/${PROP_SIZE})+5)/10)%10")

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
