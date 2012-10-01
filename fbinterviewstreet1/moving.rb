def all_group_points range, k, start = nil
  return [[]] if k == 0
  start ||= range.first

  ret = []
  while range.include? start
    ret += all_group_points(range, k-1, start).map { |points| [start] + points }
    start += 1
  end
  ret
end

def solve objects, k
  range = (objects.min)..(objects.max)
  all_group_points(range, k).map { |points|
    objects.map { |obj|
      points.map {|point| (obj - point).abs}.min
    }.inject(:+)
  }.min
end

gets.to_i.times do
  _, k = gets.split.map(&:to_i)
  objects = gets.split.map(&:to_i)
  puts solve(objects, k)
end
