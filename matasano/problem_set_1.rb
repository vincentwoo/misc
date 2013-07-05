require 'base64'
require 'pp'

def hex_decode str
  [str].pack('H*')
end

def hex_encode str
  str.unpack('H*').join
end

def encode64 bytes
  Base64.strict_encode64 bytes
end

def problem1
  str = '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'
  puts 'problem 1: base64ing', str, 'yields'
  puts encode64(hex_decode(str))
end

def fixed_xor str1, str2
  str1.bytes.zip(str2.bytes).map {|b1, b2|
    (b1 ^ b2).chr
  }.join
end

def problem2
  str1 = '1c0111001f010100061a024b53535009181c'
  str2 = '686974207468652062756c6c277320657965'
  puts 'problem 2: xoring', str1, str2, 'yields'
  str1 = hex_decode str1
  str2 = hex_decode str2
  puts hex_encode fixed_xor(str1, str2)
end

CHAR_FREQUENCIES = {
  'A' => 0.008167,
  'B' => 0.001492,
  'C' => 0.002782,
  'D' => 0.004253,
  'E' => 0.001270,
  'F' => 0.002228,
  'G' => 0.002015,
  'H' => 0.006094,
  'I' => 0.006966,
  'J' => 0.000153,
  'K' => 0.000772,
  'L' => 0.004025,
  'M' => 0.002406,
  'N' => 0.006749,
  'O' => 0.007507,
  'P' => 0.001929,
  'Q' => 0.000095,
  'R' => 0.005987,
  'S' => 0.006327,
  'T' => 0.009056,
  'U' => 0.002758,
  'V' => 0.000978,
  'W' => 0.002360,
  'X' => 0.000150,
  'Y' => 0.001974,
  'Z' => 0.000074
}

def score_english str
  str = str.upcase
  frequencies = str.chars.group_by {|i| i}
  frequencies.default = 0
  frequencies.each do |letter, value|
    frequencies[letter] = value.length.to_f / str.length
  end
  sum = 0
  CHAR_FREQUENCIES.each do |letter, freq|
    sum += ((freq - frequencies[letter]).abs ** 2)
  end
  sum += (str.chars.reject {|letter|
    (CHAR_FREQUENCIES.keys + [' ']).include? letter
  }.count.to_f / str.length)
  sum
end

def single_byte_xor_decode str
  (65..122).map do |i|
    out = str.bytes.map { |b| (b ^ i).chr }.join
    [score_english(out), i.chr, out, str]
  end
end

def problem3
  orig = '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'
  str = hex_decode orig

  possibilities = single_byte_xor_decode str

  score, key, out = possibilities.sort_by {|score, _| score}.first
  puts 'problem 3: decrypting', orig, 'yields', out, 'XORd by', key
end

def problem4
  possibilities = []
  File.foreach('problem_4.txt') do |orig|
    str = hex_decode orig
    possibilities += single_byte_xor_decode(str)
  end
  score, chr, out, orig = possibilities.sort_by {|score, _| score}.first
  puts 'problem 4: decrypting', hex_encode(orig), 'yields',
    out, 'XORd by', chr
end

def rot_xor str, key
  key_bytes = key.bytes
  str.bytes.map.with_index { |byte, idx|
    (byte ^ key_bytes[idx % key_bytes.length]).chr
  }.join
end

def problem5
  str = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
  puts 'problem 5: repeated-key XORing', str, 'with the key ICE yields'
  puts hex_encode(rot_xor(str, 'ICE'))
end

$weights = {}
def hamming_weight num
  return $weights[num] if $weights[num]
  weight = 0
  tmp = num
  while tmp > 0
    weight += (tmp & 1)
    tmp >>= 1
  end
  $weights[num] = weight
end

def hamming_distance bytes1, bytes2
  bytes1.zip(bytes2).map {|b1, b2|
    hamming_weight(b1 ^ b2)
  }.inject(:+)
end

def problem6
  str = Base64.decode64 File.read('problem_6.txt')
  sizes = (2..40).map do |keysize|
    blocks = str.bytes.each_slice(keysize).first(4)
    dist = hamming_distance(blocks[0], blocks[1])
      + hamming_distance(blocks[2], blocks[3])
    dist /= (keysize.to_f * 2)
    [dist, keysize]
  end

  sizes.sort_by! {|dist, _| dist}
  sizes = sizes.first(3).map {|_, size| size}

  puts 'key sizes: ', sizes

  keys = sizes.map do |keysize|
    blocks = str.chars.each_slice(keysize).to_a
    while blocks.last.length != keysize
      blocks.last.push nil
    end
    blocks = blocks.transpose.map &:compact

    key = blocks.map do |block|
      results = single_byte_xor_decode(block.join)
      results.sort_by! &:first
      results.first[1]
    end
    key.join
  end

  puts 'KEYS: ', '=' * 80
  puts keys

  puts 'answers:', '=' * 80

  keys.each do |key|
    puts rot_xor(str, key)[0..100], '=' * 80
  end
end

# problem1
# problem2
# problem3
# problem4
# problem5
problem6
