import qpid
from qpid.messaging import *
from qpid.datatypes import  uuid4
import sys


# Create connection and session

connection_src = Connection.establish("narcissus.rc.rit.edu:5672", username='guest', password='guest')
connection_dest = Connection.establish("ectet-esd3.rit.edu:5672", username="guest", password="guest")

session_src = connection_src.session()
session_dest = connection_dest.session()

recv = session_src.receiver("amq.topic/http_geojson; {create: always, delete: never, node: {durable: False}}")
send = session_dest.sender("nepotism_forwarder; {create:always, delete: never, node: {durable: False}}")

while True:
    try:
        message = recv.fetch()
#        print message.content
        session_src.acknowledge(message)
        send.send(message.content)
    except KeyboardInterrupt:
        break

recv.close()
session_src.close(timeout=10)
print "Done"
