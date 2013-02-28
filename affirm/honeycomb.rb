AXES = [[:x, 1], [:y, 1], [:z, 1], [:x, -1], [:y, -1], [:z, -1]]

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
  coord = {x: 0, y: 0, z: 0}
  return coord if num == 1

  ring = num_to_ring num

  max_num = ring_to_max_num ring
  side = side_length_on_ring ring

  side_number = (max_num - num) / side
  side_offset = (max_num - num) % side

  primary_axis, secondary_axis = AXES.rotate(side_number)[0..1]

  coord[primary_axis.first] = primary_axis.last * (side - side_offset)
  coord[secondary_axis.first] = secondary_axis.last * side_offset
  coord
end

for i in 1..19
  puts "#{i}:\t#{num_to_coords(i)}"
end