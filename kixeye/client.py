from twisted.internet import reactor, protocol
from struct import pack

# Just a sample script I used to test. Sends 8 messages and thenn quits.

class MyClient(protocol.Protocol):
  def connectionMade(self):
    for i in xrange(0, 8):
      reactor.callLater(i, self.sendMsg)
    reactor.callLater(9, self.transport.loseConnection)
    reactor.callLater(10, reactor.stop)
    
  def sendMsg(self):
    header = pack('xBHI', 10, 2000, 500000000)[1:]
    self.transport.write(header + "MESSAGE\x00")

class MyClientFactory(protocol.ClientFactory):
    protocol = MyClient

factory = MyClientFactory()
reactor.connectTCP('localhost', 1234, factory)

reactor.run()