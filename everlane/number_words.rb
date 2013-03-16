NUMS = {
  1  => 'one',
  2  => 'two',
  3  => 'three',
  4  => 'four',
  5  => 'five',
  6  => 'six',
  7  => 'seven',
  8  => 'eight',
  9  => 'nine',
  10 => 'ten',
  11 => 'eleven',
  12 => 'twelve',
  13 => 'thirteen',
  14 => 'fourteen',
  15 => 'fifteen',
  16 => 'sixteen',
  17 => 'seventeen',
  18 => 'eighteen',
  19 => 'nineteen',
  20 => 'twenty',
  30 => 'thirty',
  40 => 'forty',
  50 => 'fifty',
  60 => 'sixty',
  70 => 'seven',
  80 => 'eighty',
  90 => 'ninety',
  100        => 'hundred',
  1000       => 'thousand',
  1000000    => 'million',
  1000000000 => 'billion'
}

def num_to_words num
  orig = num
  suffix = 1
  ret = []
  while num > 0
    ret.push print_tuple num % 1000, suffix
    num    /= 1000
    suffix *= 1000
  end
  ret = ret.reverse.join ' '
  puts "#{orig} => #{ret}"
end

def print_tuple tuple, suffix
  return if tuple == 0

  ret = ''
  until NUMS[tuple]
    if tuple > 100
      ret += NUMS[tuple / 100] + ' hundred '
      tuple = tuple % 100
    else
      ret += NUMS[tuple - tuple % 10] + ' '
      tuple = tuple % 10
    end
  end
  ret += NUMS[tuple] + ' '
  (suffix > 1 ? ret + NUMS[suffix] : ret).strip
end

num_to_words 1234567
num_to_words 1
num_to_words 10
num_to_words 18
num_to_words 212
num_to_words 111111111