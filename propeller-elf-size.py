#!/usr/bin/env python

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

import argparse, os, re, subprocess, sys

PROPELLER_SIZE = 32768

if __name__ == "__main__":

    __folder__ = os.path.dirname(os.path.abspath(__file__))

    parser = argparse.ArgumentParser(description =
    "Propeller ELF Size Script")

    parser.add_argument("elf_file", help =
    "Path to ELF file to read the size of")

    args = parser.parse_args()

    elf_file = os.path.abspath(args.elf_file)

    if not os.path.exists(elf_file):
        sys.exit("ELF File \"%s\" does not exist!" % elf_file)

    # Print Size ###############################################################

    match = re.match(
    r"^" r"[\t ]*"
    r"text" r"[\t ]+" r"data" r"[\t ]+" r"bss"
    r"[\t ]+" r"dec" r"[\t ]+" r"hex" r"[\t ]+" r"filename"
    r"[\t ]*" r"[\n\r]+" r"[\t ]*"
    r"([^\t ]+)" r"[\t ]+" r"([^\t ]+)" r"[\t ]+" r"([^\t ]+)"
    r"[\t ]+" r"([^\t ]+)" r"[\t ]+" r"([^\t ]+)" r"[\t ]+" r"(.+)"
    r"[\t ]*" r"$",
    subprocess.check_output(["propeller-elf-size", elf_file]))

    if not match:
        sys.exit("No Match")

    match_text = int(match.group(1), 10)
    match_data = int(match.group(2), 10)
    match_bss = int(match.group(3), 10)
    match_dec = int(match.group(4), 10)
    match_hex = int(match.group(5), 16)
    match_filename = match.group(6)

    program_size = match_text
    program_percentage = (float(program_size)/PROPELLER_SIZE)*100

    data_size = match_data + match_bss
    data_percentage = (float(data_size)/PROPELLER_SIZE)*100

    print "Firmware Size: "\
          "[Program: %d bytes (%.1f%%)] "\
          "[Data: %d bytes (%.1f%%)] "\
          "on p8x32a" % (program_size, program_percentage,
          data_size, data_percentage)

    program_size = match_text
    program_percentage = (float(program_size)/PROPELLER_SIZE)*100

    data_size = match_data
    data_percentage = (float(data_size)/PROPELLER_SIZE)*100

    print "EEPROM Size: "\
          "[Program: %d bytes (%.1f%%)] "\
          "[Data: %d bytes (%.1f%%)] "\
          "on p8x32a" % (program_size, program_percentage,
          data_size, data_percentage)

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
