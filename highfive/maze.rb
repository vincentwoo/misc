require 'pp'
require 'set'

MAZE = [
  [1, 1, 1, 1, 0],
  [1, 1, 0, 1, 0],
  [1, 1, 0, 1, 0],
  [1, 1, 0, 1, 0],
  [1, 1, 0, 1, 1]
].map {|row| row.map { |x| x == 1 }}

start = [1, 1]
targets = [[2, 3], [4, 4]]#, [0, 0]]


def solve start, targets
  return true if targets.empty?
  stack = [[start]]
  seen = Set.new [start]

  while !stack.empty?
    path = stack.shift
    point = path.last

    if targets.include? point
      path[0..(path.length-2)].each { |pt| print_point pt }
      remaining = targets - [point]
      if remaining.empty?
        print_point point
        return true
      end
      return solve point, remaining
    end

    childs = children(point).select do |child|
      if seen.include? child
        false
      else
        seen.add child
        true
      end
    end
    stack += childs.map { |child| path + [child] }
  end

  puts 'we failed'
  false
end

def print_point point
  puts "x: #{point.first}, y: #{point.last}"
end

def children point
  x, y = point
  points = [ [x, y - 1], [x, y + 1], [x - 1, y], [x + 1, y] ]
  points.reject do |x, y|
    x < 0 || x >= MAZE.length || y < 0 || y > MAZE[0].length || !MAZE[x][y]
  end
end

solve start, targets