# level 1, pseudo random number generator prediction

def rand(last)
  a = 69069
  m = 2 ** 32
  c = 1
  (a * last + c) % m
end

# level 2, find bad closing brace

str = <<HEREDOC
{{[{{{{}}{{}}}[]}[][{}][({[((
{{[][()()]}}{[{{{}}}]}))][()]
{[[{((()))({}(())[][])}][]()]
}{()[()]}]})][]]}{{}[]}}
HEREDOC

str = str.split("\n").join

chars = {
  ']' => 1,
  '[' => 1,
  '(' => 2,
  ')' => 2,
  '{' => 3,
  '}' => 3
}
stack = []
str.split('').each_with_index do |char, idx|
  case char
  when '[', '{', '('
    stack.push chars[char]
  else
    if stack.last != chars[char]
      puts idx
      break
    end
    stack.pop
  end
end

# level 3, traverse a map

require 'matrix'
FUEL = 35
START = Vector[0, 0]
GOAL = Vector[4, 4]
MOVES = Vector[1, 0], Vector[0, 1], Vector[-1, 0], Vector[0, -1]
MAP = <<HEREDOC
8 8 4 4 5
4 9 6 4 8
8 6 4 1 2
4 8 2 6 3
0 6 8 8 4
HEREDOC
MAP = MAP.split("\n").reverse.map{|s| s.split(' ').map(&:to_i) }

def cost(pos)
  MAP[pos[1]][pos[0]]
end

def legal?(pos)
  pos.all? {|i| i >= 0 && i <= 4}
end

def print_path path
  path.each do |move|
    puts case move
    when Vector[1, 0] then 'go e'
    when Vector[0, 1] then 'go n'
    when Vector[-1, 0] then 'go w'
    when Vector[0, -1] then 'go s'
    end
  end
end

def solve(pos, fuel, path = [])
  if pos == GOAL && fuel == 0
    print_path path
    return true
  end
  return false if fuel <= 0
  MOVES.each do |move|
    newpos = pos + move
    next unless legal?(newpos)
    return true if solve(newpos, fuel - cost(newpos), path + [move])
  end
  return false
end

solve(START, FUEL)

# bonus level?

tries = 0
last = 0
SEQUENCE = [34, 27, 16, 1, 34, 31, 24, 17, 34, 35, 16, 13].reverse
buffer = []

while tries < 10000000
  last = rand(last)
  buffer.push last % 36
  buffer.shift if buffer.length > SEQUENCE.length
  if buffer == SEQUENCE
    puts last
    break
  end
  tries += 1
end