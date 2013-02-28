require 'matrix'

SIDE_TRANSLATIONS = {
  0 => {init: Vector[-1,  0], incr: Vector[ 1,  1]},
  1 => {init: Vector[ 0,  1], incr: Vector[ 1,  0]},
  2 => {init: Vector[ 1,  1], incr: Vector[ 0, -1]},
  3 => {init: Vector[ 1,  0], incr: Vector[-1, -1]},
  4 => {init: Vector[ 1, -1], incr: Vector[-1,  0]},
  5 => {init: Vector[-1, -1], incr: Vector[ 0,  1]}
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

  max_num = ring_to_max_num ring
  side_length = ring

  side_number = (max_num - num) / side_length
  side_offset = (max_num - num) % side_length

  translation = SIDE_TRANSLATIONS[side_number]
  (translation[:init] * side_length) + (translation[:incr] * side_offset)
end

for i in 1..19
  puts "#{i}:\t#{num_to_coords(i)}"
end