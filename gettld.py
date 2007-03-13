#!/usr/bin/env python
# -*- coding: utf8 -*-
#
# This script is used for migration from the old system version. 
# It needs curl for running. This script extends example bash script:
#
#    echo '<?xml version="1.0" encoding="utf-8"?>'
#    echo '<data>'
#    {
#        curl -ksG -uUSER:PASSW -d VSS_SERV=DSDR2R302 -d name=nic.cz https://r2r.tld.cz/cgi-bin/dsd/dsdr2r.sh
#        curl -ksG -uUSER:PASSW -d VSS_SERV=DSDR2R203 -d id=CZ-NIC https://r2r.tld.cz/cgi-bin/dsd/dsdr2r.sh
#        curl -ksG -uUSER:PASSW -d VSS_SERV=DSDR2R102 -d id=MAPET https://r2r.tld.cz/cgi-bin/dsd/dsdr2r.sh
#        curl -ksG -uUSER:PASSW -d VSS_SERV=DSDR2R102 -d id=FEELA https://r2r.tld.cz/cgi-bin/dsd/dsdr2r.sh
#        curl -ksG -uUSER:PASSW -d VSS_SERV=DSDR2R102 -d id=TM-NIC https://r2r.tld.cz/cgi-bin/dsd/dsdr2r.sh 
#    } | grep -v "<?xml"
#    echo '</data>'
#
# The script works this way:
#
#     1. Load domain record
#     2. Fetch idadm and idtech from dsdDomain
#     3. Load them as a subjects
#     4. Fetch admin-c from dsdSubject
#     5. Load them as contacts
#     6. Display result as XML
#
#
"""Usage: gettld.py <OPTIONS>
OPTIONS:
 -h/--help        This help
 -u/--user        User name
 -w/--password    User Password
 -d/--domain      Domain name

EXAMPLE:
$ ./gettld.py -u USER -w PASSW -d nic.cz > nic_cz.xml
"""

import sys, os, re
import getopt

URL   = 'https://r2r.tld.cz/cgi-bin/dsd/dsdr2r.sh'
STYLE = '<?xml-stylesheet href="templates/migrace.xsl" type="text/xsl"?>'
VSS_SERV = (
    'DSDR2R302',    # domain
    'DSDR2R203',    # subject
    'DSDR2R102',    # contact
    )
ANCHOR_ADMIN   = 'dsdDomain:idadm'
ANCHOR_TECH    = 'dsdDomain:idtech'
ANCHOR_CONTACT = 'dsdSubject:admin-c'
TOP_ELEMENT    = 'migration'

is_xml = re.compile('<\?xml.+?>')
is_domain = re.compile('\.cz$')

def get_subjects(keys, params):
    'Load all Subject and returns list of XML subject and list of the contact ID.'
    epp_data = []
    contacts = []
    for key in keys:
        params[2] = key
        body = load(params, 'id', VSS_SERV[1])
        if body == '':
            sys.exit(-1)
        epp_data.append(is_xml.sub('',body))
        for cont in re.findall('<%s>(.+?)</%s>'%(ANCHOR_CONTACT,ANCHOR_CONTACT), body):
            if cont not in contacts:
                contacts.append(cont)
    return epp_data, contacts

def get_contacts(keys, params):
    'Load contacts ID and returns XML of the contacts.'
    epp_data = []
    for key in keys:
        params[2] = key
        body = load(params, 'id', VSS_SERV[2])
        if body == '':
            sys.exit(-1)
        epp_data.append(is_xml.sub('',body))
    return epp_data
    
def make_info(domain_name, subjects, contacts):
    body = []
    body.append('<info>')
    body.append('<domain>%s</domain>'%domain_name)
    body.append('<subjects>\n\t<rec>%s</rec>\n</subjects>'%'</rec>\n\t<rec>'.join(subjects))
    body.append('<contacts>\n\t<rec>%s</rec>\n</contacts>'%'</rec>\n\t<rec>'.join(contacts))
    body.append('</info>')
    return body
    
def main(options):
    try:
        optlist, args = getopt.getopt(options, 'hu:w:d:',['help', 'user=','password=','domain='])
    except getopt.GetoptError, msg:
        sys.stderr.write('Option error: %s\n'%msg)
        return
    params = ['']*3
    for k,v in optlist:
        if k  in ('-h','--help'):
            print __doc__
            return
        elif k in ('-u','--user'):
            params[0] = v
        elif k in ('-w','--password'):
            params[1] = v
        elif k in ('-d','--domain'):
            params[2] = v
    # set domain name without parameter
    if params[2] == '' and len(args):
        params[2] = args[0]
    # check required
    if params[0] == '':
        sys.stderr.write('Username missing.\n')
    if params[1] == '':
        sys.stderr.write('Password missing.\n')
    if params[2] == '':
        sys.stderr.write('Domain name missing.\n')
    if not is_domain.search(params[2]):
        sys.stderr.write('Invalid domain name. Valid is "%s.cz"\n'%params[2])
        params[2] = ''
    if '' in params:
        return

    # Get domain
    domain_name = params[2]
    domain = load(params, 'name', VSS_SERV[0])
    if domain == '':
        return
    match = re.match('<?xml\s+.*?encoding\s*=\s*[\'"]([^\'"]+)[\'"]',domain)
    encoding = match and match.group(1) or getattr(sys.stdout,'encoding','UTF-8')
    xml_data = ['<?xml version="1.0" encoding="%s"?>'%encoding, STYLE, '<%s>'%TOP_ELEMENT]

    # Fetch subject:
    subjects = []
    for anchor in (ANCHOR_ADMIN, ANCHOR_TECH):
        for subj in re.findall('<%s>(.+?)</%s>'%(anchor,anchor), domain):
            if subj not in subjects:
                subjects.append(subj)

    # for every subject
    body_subjects, contacts = get_subjects(subjects, params)
    xml_data.extend(make_info(domain_name, subjects, contacts))
    xml_data.append(is_xml.sub('',domain))
    xml_data.extend(body_subjects)

    # for all contacts
    xml_data.extend(get_contacts(contacts, params))

    # End of XML
    xml_data.append('</%s>'%TOP_ELEMENT)
    print '\n'.join(xml_data)

def load(params, name, code):
    'Load page from web with using curl.'
    command = 'curl -ksG -u%s:%s -d VSS_SERV=%s -d %s=%s %s'%(params[0], params[1], code, name, params[2], URL)
    f = os.popen(command)
    body = f.read()
    if is_xml.match(body):
        pass
    else:
        sys.stderr.write(body)
        body = ''
    return body

    
if __name__ == '__main__':
    if len(sys.argv) > 1:
        main(sys.argv[1:])
    else:
        print __doc__
