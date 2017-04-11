#!/usr/bin/python

import re
import optparse
import sys

parser = optparse.OptionParser()

parser.add_option('-i', '--infile',
    action="store", dest="infile",
    help="input file", default="-")

parser.add_option('-o', '--outfile',
    action="store", dest="outfile",
    help="output file", default="-")

options, args = parser.parse_args()

if options.infile == '-':
    infile = sys.stdin
else:
    infile = open( options.infile, "r")

for line in infile:
    if match = re.search(r'     Last_Name: (\S*)', line):
        print "Last Name: ": match.group(1)


if infile is not sys.stdin:
        infile.close()
