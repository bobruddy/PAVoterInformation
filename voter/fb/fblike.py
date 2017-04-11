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

# open the file
if options.infile == '-':
    infile = sys.stdin
else:
    infile = open( options.infile, "r")

# build my re
name = re.compile(r'^(\S+).* (\S+)$')
since = re.compile(r'^(\d\d.*)')
role = re.compile(r'^(\w)')

for line in infile:				# loop through the file
    for pattern in (name, since, role):		# loop through the regex
        match = re.search(pattern, line)
        if match:
            if pattern == name:
                print "Name: " + match.group(1) + " " + match.group(2)
            if pattern == since:
                print "\t" + match.group(1)



if infile is not sys.stdin:
        infile.close()
