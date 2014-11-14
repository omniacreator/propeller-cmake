#!/usr/bin/env python

################################################################################
# @file
# Propeller BIN Size Script
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

import argparse, os, struct, sys

PROPELLER_SIZE = 32768

if __name__ == "__main__":

    __folder__ = os.path.dirname(os.path.abspath(__file__))

    parser = argparse.ArgumentParser(description =
    "Propeller BIN Size Script")

    parser.add_argument("bin_file", help =
    "Path to BIN file to read the size of")

    args = parser.parse_args()

    bin_file = os.path.abspath(args.bin_file)

    if not os.path.exists(bin_file):
        sys.exit("BIN File \"%s\" does not exist!" % bin_file)

    # Print Size ###############################################################

    with open(bin_file, "rb") as file:

        clock_freq = struct.unpack("<I", file.read(4))[0]
        clock_mode = struct.unpack("<B", file.read(1))[0]
        checksum = struct.unpack("<B", file.read(1))[0]

        pbase = struct.unpack("<H", file.read(2))[0]
        vbase = struct.unpack("<H", file.read(2))[0]
        dbase = struct.unpack("<H", file.read(2))[0]
        pcurr = struct.unpack("<H", file.read(2))[0]
        dcurr = struct.unpack("<H", file.read(2))[0]

        program_size = vbase
        program_percentage = (float(program_size)/PROPELLER_SIZE)*100

        data_size = dbase - vbase
        data_percentage = (float(data_size)/(PROPELLER_SIZE-program_size))*100

        print "Firmware Size: "\
              "[Program: %d bytes (%.1f%%)] "\
              "[Data: %d bytes (%.1f%%)] "\
              "on p8x32a" % (program_size, program_percentage,
              data_size, data_percentage)

        program_size = vbase
        program_percentage = (float(program_size)/PROPELLER_SIZE)*100

        data_size = dbase - vbase
        data_percentage = (float(data_size)/(PROPELLER_SIZE-program_size))*100

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
