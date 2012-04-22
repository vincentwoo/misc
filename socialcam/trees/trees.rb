n = gets.to_i
level_depth = 4
level_width = 1

tree = []

n.times do |i|
  level_depth.times do
    tree.push("*" * level_width);
    level_width += 2
  end
  level_depth += 1
  level_width -= (i % 2 == 0 ? 4 : 6)
end

level_width = tree.last.length
n.times do
  tree.push("|" * (n + (n + 1) % 2))
end
for line in tree
  puts (" " * ((level_width - line.length)/2)) + line
end