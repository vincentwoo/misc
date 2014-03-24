def parse
  9.times.map do
    gets[0..8].chars.map {|c| c == ' ' ? nil : c.to_i}
  end
end

def output grid
  grid.each.with_index do |row, i|
    puts row.map {|i| i == nil ? ' ' : i.to_s}.each_slice(3).map {|slice| slice.join}.join(' ')
    puts "\n" if i % 3 == 2
  end
end

$meno = {}
def block_coords row, col
  hash = row * 2 + col * 13
  row = row / 3 * 3
  col = col / 3 * 3
  return $meno[hash] if $meno[hash]
  $meno[hash] = (row..row+2).to_a.product (col..col+2).to_a
end

def block_for_coords grid, row, col
  block_coords(row, col).map do |row, col|
    grid[row][col]
  end
end

def column grid, col
  grid.map { |row| row[col] }
end

def valid_move? grid, try, row, col
  !grid[row].include?(try) &&
  !column(grid, col).include?(try) &&
  !block_for_coords(grid, row, col).include?(try)
end

def find_next_blank grid, row, col
  while row != 9
    return [row, col] unless grid[row][col]
    col += 1
    if col == 9
      row += 1
      col = 0
    end
  end
  [false, false]
end

def solve grid, row = 0, col = 0
  row, col = find_next_blank grid, row, col
  return grid if !row && !col

  (1..9).each do |try|
    next unless valid_move?(grid, try, row, col)
    grid[row][col] = try
    ret = solve grid, row, col
    return ret if ret
  end
  grid[row][col] = nil
end

output solve parse
