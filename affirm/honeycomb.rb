require 'matrix'

SIDE_TRANSLATIONS = {
  0 => Vector[-1,  0],
  1 => Vector[ 0,  1],
  2 => Vector[ 1,  1],
  3 => Vector[ 1,  0],
  4 => Vector[ 1, -1],
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

  max_num = ring_to_max_num ring
  side_length = ring

  side_number = (max_num - num) / side_length
  side_offset = (max_num - num) % side_length

  translation = SIDE_TRANSLATIONS[side_number]
  transition = SIDE_TRANSLATIONS[(side_number + 1) % 6] - translation
  (translation * side_length) + (transition * side_offset)
end

for i in 1..19
  puts "#{i}:\t#{num_to_coords(i)}"
end