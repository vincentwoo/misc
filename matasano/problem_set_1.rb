require 'base64'

def hex_decode str
  [str].pack('H*')
end

def hex_encode str
  str.unpack('H*')
end

def encode64 str
  str = hex_decode str
  Base64.strict_encode64 str
end

puts encode64 '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'
# should yield SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t


def fixed_xor str1, str2
  str1 = hex_decode str1
  str2 = hex_decode str2
  hex_encode str1.bytes.zip(str2.bytes).map {|b1, b2|
    (b1 ^ b2).chr
  }.join
end

puts fixed_xor(
  '1c0111001f010100061a024b53535009181c',
  '686974207468652062756c6c277320657965'
)
# should yield 746865206b696420646f6e277420706c6179