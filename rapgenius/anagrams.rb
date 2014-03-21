templates = {}
templates.default = 0

File.open('dict.txt', 'r+') do |file|
  file.each do |str|
    str = str.strip
    next unless str.length == 6

    str.chars.each.with_index.to_a.combination(2).each do |combo|
      templates[combo] += 1
    end
  end
end

p templates.select {|k, v| v == 1}.count
