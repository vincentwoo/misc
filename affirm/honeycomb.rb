# Solution + extra credit for affirm.com/jobs

require 'matrix'

UNIT_HEXAGON = {
  0 => Vector[-1,  0],
  1 => Vector[ 0,  1],
  2 => Vector[ 1,  1],
  3 => Vector[ 1,  0],
  4 => Vector[ 0, -1],
  5 => Vector[-1, -1]
}

def ring_to_max_num ring
  3 * ring**2 + 3 * ring + 1
end

def num_to_ring num
  (Math.sqrt((4 * num - 1) / 12.0) - 0.5).ceil
end

def num_to_coords num
  return Vector[0, 0] if num == 1

  ring = num_to_ring num
  offset = ring_to_max_num(ring) - num

  side_number = offset / ring
  side_offset = offset % ring

  translation = UNIT_HEXAGON[side_number]
  transition = UNIT_HEXAGON[(side_number + 1) % 6] - translation
  (translation * ring) + (transition * side_offset)
end

def length_of_delta delta
  delta = -1 * delta if delta.all? {|i| i < 0}
  [delta.max, delta.max - delta.min].max
end

def distance_between num1, num2
  delta = num_to_coords(num1) - num_to_coords(num2)
  length_of_delta delta
end

def coords_to_num pos
  return 1 if pos == Vector[0, 0]

  ring = (pos[0] < 0) != (pos[1] < 0) ? pos.max - pos.min : pos.map(&:abs).max

  side = if pos[0] == ring then 2
    elsif pos[0] == -ring then 5
    elsif pos[1] == ring then 1
    elsif pos[1] == -ring then 4
    elsif pos[0] > pos[1] then 3
    else 0
  end

  max_num = ring_to_max_num ring
  offset = side * ring + length_of_delta(pos - (UNIT_HEXAGON[side] * ring))
  offset == ring * 6 ? max_num : max_num - offset
end

def path_between num1, num2
  pos1 = num_to_coords num1
  pos2 = num_to_coords num2
  delta = pos1 - pos2

  path = []

  while delta != Vector[0, 0]
    path.push(coords_to_num(pos2 + delta))

    move = if delta.all? {|i| i < 0}
      Vector[1, 1]
    elsif delta.all? {|i| i > 0}
      Vector[-1, -1]
    elsif delta[0] != 0
      Vector[delta[0] > 0 ? -1 : 1, 0]
    else
      Vector[0, delta[1] > 0 ? -1 : 1]
    end

    delta += move
  end

  path.push num2
  path
end

if ARGV[0] && ARGV[1]
  num1 = ARGV[0].to_i
  num2 = ARGV[1].to_i
  puts "distance between #{num1} and #{num2} is #{distance_between num1, num2}"
  puts "path is #{path_between num1, num2}"
end