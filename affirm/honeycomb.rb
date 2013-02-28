def ring_to_max_num ring
  3 * ring**2 + 3 * ring + 1
end

def num_to_ring num
  (Math.sqrt((4 * num - 1) / 12.0) - 0.5).ceil
end

def cells_on_ring num
  num * 6
end

def side_length_on_ring num
  num
end

def num_to_coords num
  ring = num_to_ring num
  puts "calcing for #{num}"

  max_num = ring_to_max_num ring
  side = side_length_on_ring ring

  case num
    when (max_num-side)..max_num
      'quad 1'
    when (max_num-side*2)..(max_num-side)
      'quad 2'
    when (max_num-side*3)..(max_num-side*2)
      'quad 3'
    when (max_num-side*4)..(max_num-side*3)
      'quad 4'
    when (max_num-side*5)..(max_num-side*4)
      'quad 5'
    when (max_num-side*6)..(max_num-side*5)
      'quad 6'
  end
end

for i in 1..7
  puts num_to_coords(i)
end