#!/usr/bin/python
import sys
import re
"""Load configuration file in desktop format:

# comment
key1=value
key2 = value
"""

def load(filename,  data):
    """Load configuration. Data is dictionnary with
    defaults which will be filled from configuration file
    filename. Functions returns status 1 if is success or
    0 if configuration file is not found.
    """
    status = 1
    try:
        body = open(filename).read()
    except IOError,  msg:
        sys.stderr.write('IOError: %s\n'%msg)
        status = 0
    else:
        keys = data.keys()
        for line in body.split('\n'):
            match = re.match('(\w+)\s*=\s*(.+)',line)
            if match and match.group(1) in keys:
                data[match.group(1)] = match.group(2)
    return status

def save(filename,  data, order=()):
    """Save data (dictionnary) into filename file.
    filename - path and name of the configuration file
    data - dictionnary with variables
    order - (optional) order for saved variables
    """
    status = 1
    try:
        fp = open(filename, 'w')
        keys = len(order) and order or data.keys()
        for k in keys:
            if k == '': continue
            value = data.get(k, '')
            if k[0] == '#':
                fp.write('%s\n'%k) # write comment
            else:
                if not data[k]:
                    continue # jump over empty keys
                fp.write('%s=%s\n'%(k, value))
        fp.close()
    except IOError,  msg:
        sys.stderr.write('IOError: %s\n'%msg)
        status = 0
    return status
    
    
if __name__=="__main__":
    if len(sys.argv) > 2:
        data = {}
        for key in sys.argv[2:]:
            data[key] = ''
        load(sys.argv[1],  data)
        print 'CONFIG: %s\n'%sys.argv[1]
        for k, v in data.items():
            print ('%s:'%k).ljust(20), v
    else:
        print 'Usage: destop_config.py name.conf [key_name1 key_name2 ...]'
#        print save('/tmp/test_save1.conf', {'one':'this is one', 
#                'two':'dvojka', 
#                'myarray': 'hokus pokus jojo jo', 
#                '#comment1':'This is comment one', 
#                '#comment2':'This is comment two', 
#                }) ('#comment1', 'one', 'two', '#comment2', 'myarray'))

    
    
