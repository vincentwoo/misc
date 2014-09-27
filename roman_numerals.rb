# I = 1
# V = 5
# X = 10
# L = 50
# C = 100
# D = 500
# M = 1000

MAPPINGS = {
  1000 => 'M',
  900  => 'CM',
  500  => 'D',
  400  => 'CD',
  100  => 'C',
  90   => 'XC',
  50   => 'L',
  40   => 'XL',
  10   => 'X',
  9    => 'IX',
  5    => 'V',
  4    => 'IV',
  1    => 'I'
}

def convert n
  res = ''
  MAPPINGS.each do |number, str|
    while n >= number
      n -= number
      res += str
    end
  end
  res
end

p 947
p convert 947

p 1023
p convert 1023

p 20
p convert 20

p 49
p convert 49

p 497
p convert 497

p 1944
p convert 1944
