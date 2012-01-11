from twisted.internet import protocol, reactor
from struct import unpack

# Some notes:

# Usage: python server.py
# The port is hardcoded at 1234

# I'm assuming the terminator for the ASCII string is a NULL byte, otherwise
# there isn't a way for a client to send more than one message per connection

# I'm assuming the header values are all unsigned

# output looks like
# [vers] (msg type) User.ID: MSG

# You need Twisted (http://twistedmatrix.com/trac/) installed to get evented IO

# Improvements:
# Probably want to be more state-aware about whether the header has been received
# yet or not. That way we don't have to search the entire buffer each time for a
# NULL byte, but otherwise this should be pretty darn fast. We could also
# probably do away with slicing the buffer when the buffer wraps around to
# another message.

class Echo(protocol.Protocol):
  def connectionMade(self):
    self.buffer = ""
    self.header = None
  
  def dataReceived(self, data):
    self.buffer += data
    if len(self.buffer) < 7:
      return
    if (self.header == None):
      self.header = unpack('xBHI', ' ' + self.buffer[0:7])
      #unpack byte aligns to 8 so add a pad format char
    nul = self.buffer.find('\x00', 7)
    if nul == -1:
      return
    self.printMessage(self.buffer[7:nul])
    tmp = self.buffer[nul+1:]
    self.buffer = ""
    self.dataReceived(tmp)
      
  def printMessage(self, msg):
    print ("[%u] (%u) User.%u: " % self.header) + msg
    self.header = None

class EchoFactory(protocol.Factory):
  def buildProtocol(self, addr):
    return Echo()

reactor.listenTCP(1234, EchoFactory())
reactor.run()