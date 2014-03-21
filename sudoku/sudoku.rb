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

def block_for_coords grid, row, col
  row = row / 3 * 3
  col = col / 3 * 3
  ret = []
  (row..row+2).each do |row|
    (col..col+2).each do |col|
      ret.push grid[row][col]
    end
  end
  ret
end

def column grid, col
  grid.map { |row| row[col] }
end

def no_dupes? group
  test = [false, false, false, false, false, false, false, false, false, false]
  group.each do |num|
    next unless num
    return false if test[num]
    test[num] = true
  end
  true
end

def valid? grid, row, col
  no_dupes?(grid[row]) &&
  no_dupes?(column(grid, col)) &&
  no_dupes?(block_for_coords(grid, row, col))
end

def find_next_blank grid
  9.times do |row|
    9.times do |col|
      return [row, col] unless grid[row][col]
    end
  end
  return [false, false]
end

def solve grid
  row, col = find_next_blank grid
  return grid if !row && !col

  (1..9).each do |try|
    grid[row][col] = try
    next unless valid?(grid, row, col)
    ret = solve grid
    return ret if ret
  end
  grid[row][col] = nil
  false
end

output solve parse
