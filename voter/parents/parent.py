#!/usr/bin/python

import re
import argparse
import sys
import mysql.connector

parser = argparse.ArgumentParser(description='Grab options')

parser.add_argument('-i', dest="infile", action='store',
                    nargs=1,
                    help="input file", default="-")

parser.add_argument('-c', dest="confidence", action='store',
                    nargs=1,
                    help="confidence")

parser.add_argument('-d', dest='debug', action='store_true',
                    help='Turns on debug mode')

parser.add_argument('-n', dest="nodb", action='store_true',
                    help="Store in the database")

options = parser.parse_args()

if options.debug == True:
    print "nodb: ", options.nodb
    print "confidence: ", options.confidence
    print "infile: ", options.infile

# connect to my DB
if options.nodb == False:
    # read in the db password
    dbuser = ""
    db = ""
    dbhost = ""
    dbpass = ""
    with open("/home/ruddy/Projects/PAVoterInformation/etc/passwords.pw", "r") as pwfile:
        for line in pwfile:
            tup = line.split(" => ")
            if tup[0] == "dbuser":
                dbuser = tup[1].rstrip()
            elif tup[0] == "db":
                db = tup[1].rstrip()
            elif tup[0] == "dbhost":
                dbhost = tup[1].rstrip()
            elif tup[0] == "dbpass":
                dbpass = tup[1].rstrip()
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
    add_user = ("INSERT INTO parent_list "
                "(first_name, last_name, confidence) "
                "VALUES (%(first_name)s, %(last_name)s, %(confidence)s)")

# open the file
if options.infile == '-':
    infile = sys.stdin
else:
    infile = open(options.infile[0], "r")

# build my re
name = re.compile(r'^(.+)\t(.+)$')

for line in infile:  # loop through the file
    # nline = line.replace(madian, '')
    nline = re.sub(r' \(\S+\)$', "", line)
    # print nline
    #for pattern in (name, ''):  # loop through the regex
    pattern = name
    match = re.search(pattern, nline)
    if match:
        msg = "Name: "
        if options.nodb == False:
            data_user = {
                'first_name': match.group(1),
                'last_name': match.group(2),
                'confidence': options.confidence[0]
                }
            try:
                cur.execute(add_user, data_user)
            except mysql.connector.Error as err:
                msg = "Dup: "

            if ((options.debug == True and msg == "Dup: ") or (msg == "Name: ")):
                print msg + match.group(1) + " " + match.group(2)


if infile is not sys.stdin:
    infile.close()

# db cleanup
if options.nodb == False:
    conn.commit()
    cur.close()
    conn.close()
