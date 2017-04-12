#!/usr/bin/python

import re
import argparse
import sys
import mysql.connector

parser = argparse.ArgumentParser(description = 'Grab options')

parser.add_argument('-i', dest="infile", action='store',
    nargs=1,
    help="input file", default="-")

parser.add_argument('-d', dest='debug', action='store_true',
        help='Turns on debug mode')

parser.add_argument('-g', dest='type', action='store_const',
        const='agcPrivate', default='agcPublic',
        help='by default this script will process a page file. This will process a group file')

parser.add_argument('-n', dest="nodb", action='store_true',
    help="Store in the database")

options = parser.parse_args()

if options.debug == True:
    print "nodb: " , options.nodb
    print "type: " , options.type
    print "infile: " , options.infile

# connect to my DB
if options.nodb == False:
    # read in the db password
    dbuser = ""
    db = ""
    dbhost = ""
    dbpass = ""
    with open( "/home/ruddy/Projects/PAVoterInformation/etc/passwords.pw", "r") as pwfile:
    	for line in pwfile:
    		tup = line.split( " => " )
    		if tup[0] == "dbuser":
    			dbuser=tup[1].rstrip()
    		elif tup[0] == "db":
    			db=tup[1].rstrip()
    		elif tup[0] == "dbhost":
    			dbhost=tup[1].rstrip()
    		elif tup[0] == "dbpass":
    			dbpass=tup[1].rstrip()
    		else:
    			break
        
        if options.debug == True:
            print "dbuser: ." + dbuser + "."
            print "db: ." + db + "."
            print "dbpass: ." + dbpass + "."
            print "dbhost: ." + dbhost + "."

	conn = mysql.connector.connect(
         	user=dbuser,
         	password=dbpass,
         	host=dbhost,
         	database=db)
	cur = conn.cursor()

	# define insert query
	add_user = ("INSERT INTO fb_list "
              	"(first_name, last_name, page) "
              	"VALUES (%(first_name)s, %(last_name)s, %(page)s)")

# open the file
if options.infile == '-':
    infile = sys.stdin
else:
    infile = open( options.infile[0], "r")

# build my re
name = re.compile(r'^([a-zA-Z]\S+).* (\S+)$')
since = re.compile(r'^(\d+ \w+ ago|\d\d/\d\d/\d\d)')
role = re.compile(r'^(\w)')
recordstart = re.compile(r'^$')
newrecord = "yes"

for line in infile:				# loop through the file
    for pattern in (name, since, role, recordstart):		# loop through the regex
        match = re.search(pattern, line)
        if match:
            if pattern == recordstart:
                newrecord = "yes"
            elif ( pattern == name and newrecord == "yes" ):
                newrecord = "no"
                print "Name: " + match.group(1) + " " + match.group(2)
		if options.nodb == False:
			data_user = {
		  	  'first_name': match.group(1),
		  	  'last_name': match.group(2),
		  	  'page': options.type
			}
			cur.execute(add_user, data_user)
            else:
	   	break



if infile is not sys.stdin:
        infile.close()

# db cleanup
if options.nodb == False:
	conn.commit()
	cur.close()
	conn.close()
