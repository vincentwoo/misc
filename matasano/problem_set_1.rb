require 'base64'

def hex_decode str
  [str].pack('H*')
end

def hex_encode str
  str.unpack('H*')
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
    sum += (freq - frequencies[letter]).abs
  end
  sum += (str.chars.reject {|letter|
    (CHAR_FREQUENCIES.keys + [' ']).include? letter
  }.count.to_f / str.length)
  sum
end

def problem3
  orig = '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'
  str = hex_decode orig

  possibilities = (0..255).map do |i|
    out = str.bytes.map { |b| (b ^ i).chr }.join
    [score_english(out), i.chr, out]
  end

  winner = possibilities.sort_by {|score, _| score}.first
  puts 'problem 3: decrypting', orig, 'yields',
    winner.last, 'XORd by', winner[1]
end

def problem4
  possibilities = []
  File.foreach('problem_4.txt') do |orig|
    str = hex_decode orig
    possibilities += (0..255).map do |i|
      out = str.bytes.map { |b| (b ^ i).chr }.join
      [score_english(out), i.chr, out, orig]
    end
  end
  score, chr, out, orig = possibilities.sort_by {|score, _| score}.first
  puts 'problem 4: decrypting', orig, 'yields',
    out, 'XORd by', chr
end

problem1
problem2
problem3
problem4
