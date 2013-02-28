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

  side_number = (max_num - num) / ring
  side_offset = (max_num - num) % ring

  translation = SIDE_TRANSLATIONS[side_number]
  transition = SIDE_TRANSLATIONS[(side_number + 1) % 6] - translation
  (translation * ring) + (transition * side_offset)
end

def distance_between num1, num2
  delta = num_to_coords(num1) - num_to_coords(num2)
  delta = -1 * delta if delta.all? {|i| i < 0}
  delta.all? {|i| i > 0} ? delta.max : delta.max - delta.min
end

num1 = ARGV[0].to_i
num2 = ARGV[1].to_i
puts "distance between #{num1} and #{num2} is #{distance_between num1, num2}"
