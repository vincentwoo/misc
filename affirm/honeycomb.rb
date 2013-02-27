def ring_to_max_num ring
  3 * ring**2 + 3 * ring + 1
end

def num_to_ring num
  (Math.sqrt((4 * num - 1) / 12.0) - 0.5).ceil
end

def cells_on_ring num
  num * 6
end

def num_to_coords num
  ring = num_to_ring num
  puts "calcing for #{num}"

  offset = ring_to_max_num(ring) - cells_on_ring(ring)
  num - offset - 1
end

for i in 1..50
  puts num_to_coords(i)
end