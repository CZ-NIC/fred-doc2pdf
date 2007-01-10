#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
This module unifiques access to the any database.

Usage:

import loader
source = loader.Data()
if source.connect():
    lines = source.load("SELECT * FROM table")
    print lines
    source.close()

For succefully connection this module needs configuration file
which is implicitly defined in variable DEFAULT_CONFIG_PATH.
The values in this file must be saved in this format:

host=myhost
port=myport
...

All available names are defined in list KEYNAMES.
"""
import re

from pyPgSQL import PgSQL
from pyPgSQL.libpq import DatabaseError, OperationalError

DEFAULT_CONFIG_PATH = '/etc/ccReg.conf'
KEYNAMES = ('host','port','dbname','user','password') # MUST be in this order!

def parse_config(config_path=''):
    """Returns list of the values required for connection.
    If fails returns None.
    """
    if not len(config_path): config_path = DEFAULT_CONFIG_PATH
    try:
        body = open(config_path).read()
    except IOError, msg:
        print 'Configuration file not found: IOError:',msg
        return None
    condata = ['']*len(KEYNAMES)
    for n in range(len(KEYNAMES)):
        match = re.search('^%s\s*=\s*(.+)$'%KEYNAMES[n], body, re.M)
        if match:
            condata[n] = match.group(1).strip()
    return condata

def get_connection(config_path=''):
    """Returns string in format:  'host:port:dbname:user:password'
    If fails returns None.
    """
    data = parse_config(config_path)
    if data is not None:
        data = ':'.join(data)
    return  data

class Data:
    """Class for access PostgreSQL database.
    """
    def __init__(self):
        self.db = None
        self.cr = None

    def close(self):
        if self.db: self.db.close()

    def connect(self, config_path=''):
        """Connect to the database. Optional config_path is name of the
        configuration file, where are stored values required for connection.
        """
        # connecting string is in format: "host:port:database:user:password"
        conn = get_connection(config_path)
        if not conn: return False
        try:
            self.db = PgSQL.connect(conn)
        except DatabaseError, msg:
            print 'Data.connect() DatabaseError:', msg
            return False
        self.cr = self.db.cursor()
        return True

    def load(self, sql):
        if not self.cr: return None
        try:
            self.cr.execute(sql)
        except OperationalError, msg:
            print 'Data.load() OperationalError:',msg
            return None
        return self.cr.fetchall()

if __name__=="__main__":
    SQL = "SELECT * FROM message"
    source = Data()
    if source.connect(): # optional parameter: DEFAULT_CONFIG_PATH
        print "SQL:", SQL
        lines = source.load(SQL)
        if lines:
            print "RESULT:"
            for line in lines:
                for column in line:
                    print str(type(column)).ljust(30), column
                print '-'*31 # line separator
        source.close()
