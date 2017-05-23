#/bin/env python2.7 
# pip install dnspython
# pip install requests


import xml.dom.minidom
import argparse
import hashlib
import dns.resolver
import sys
import re
import requests
import xml.etree.ElementTree as ET

parser = argparse.ArgumentParser(description='SML/SMP lookup')
parser.add_argument('participantid', metavar='id', type=str,
                    help='the participantID in format <scheme_id>:<organization_id>, e.g. 0106:41215724')

args = parser.parse_args()

print 'Looking for participantid:',args.participantid


# Calculate the hash of the ID according to the SML specification
# peppol needs the organisation to be lower case
hash = hashlib.md5(str.lower(args.participantid)).hexdigest()

hostname = "b-" + hash + ".iso6523-actorid-upis.edelivery.tech.ec.europa.eu"

print 'Hostname to resolve',hostname

# Look up the hostname in the SML; if the lookup succeeds, we know
# there is an SMP for this organization, and we are done.
# Normally, the calling application would then contact the SMP for
# endpoint details.
resolver = dns.resolver.Resolver() 
anwsers = resolver.query(hostname, "A")

for rdata in anwsers: 
    print 'DNS A record found:',rdata
    ip4 = rdata



if len(anwsers) == 1:
  print "Result:",anwsers[0]
else:
  print "ERROR in SML LOOKUP; multiple CNAME anwsers"
  sys.exit(-1)

ir = requests.get("http://"+hostname+"/iso6523-actorid-upis::"+args.participantid)
#print ir.text


print '####################################'
print '       ServiceGroup'
print '       href=http://'+hostname+'/iso6523-actorid-upis::'+args.participantid
print '####################################'
xml = xml.dom.minidom.parseString(ir.text)
print xml.toprettyxml()
print '####################################'


root = ET.fromstring(ir.text)
#print root

ns = {'pub' : 'http://busdox.org/serviceMetadata/publishing/1.0/'}

collection = root.findall('pub:ServiceMetadataReferenceCollection',ns)
# print collection
# size should be 1

if len(collection) != 1:
  print "ERROR in ServiceGroup XML ServiceMetadataReferenceCollection > 1",collection
  sys.exit(-1)

SMRs = collection[0].findall("pub:ServiceMetadataReference",ns)

#print SMRs

for SMR in SMRs:
  href = SMR.get('href')
  smr_response = requests.get(href)
  print '-------------------------------- '
  print '    SignedServiceMetaData'
  print '    href=',href
  print '-------------------------------- '
  print smr_response.text

print '--------------------------------' 







