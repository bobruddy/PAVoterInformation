#!/usr/bin/python

import re
import optparse
import sys
import mysql.connector

parser = optparse.OptionParser()

parser.add_option('-i', '--infile',
    action="store", dest="infile",
    help="input file", default="-")

parser.add_option('-o', '--outfile',
    action="store", dest="outfile",
    help="output file", default="-")

parser.add_option('-n', '--nodb',
    action="store", dest="nodb",
    help="Store in the database", default="no")

options, args = parser.parse_args()

# read in the db password
dbuser = ""
db = ""
dbhost = ""
dbpass = ""
with open( "/home/ruddy/Projects/PAVoterInformation/etc/passwords.pw", "r") as pwfile:
	for line in pwfile:
		tup = line.split( " => " )
		if tup[0] == "dbuser":
			dbuser=tup[1]
		elif tup[0] == "db":
			db=tup[1]
		elif tup[0] == "dbhost":
			dbhost=tup[1]
		elif tup[0] == "dbpass":
			dbpass=tup[1]
		else:
			break

# connect to my DB
if options.nodb == "no":
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
    infile = open( options.infile, "r")

# build my re
name = re.compile(r'^([a-zA-Z]\S+).* (\S+)$')
since = re.compile(r'^(\d\d.*)')
role = re.compile(r'^(\w)')

for line in infile:				# loop through the file
    for pattern in (name, since, role):		# loop through the regex
        match = re.search(pattern, line)
        if match:
            if pattern == name:
                print "Name: " + match.group(1) + " " + match.group(2)
		if options.nodb == "no":
			data_user = {
		  	  'first_name': match.group(1),
		  	  'last_name': match.group(2),
		  	  'page': "agcPublic"
			}
			cur.execute(add_user, data_user)
            else:
	   	break



if infile is not sys.stdin:
        infile.close()

# db cleanup
if options.nodb == "no":
	conn.commit()
	cur.close()
	conn.close()
