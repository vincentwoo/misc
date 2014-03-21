class MySortedSet
  attr_accessor :arr

  def initialize *args
    self.arr = args.dup
  end

  def << el
    arr << el
  end

  def to_a
    arr.uniq.sort
  end
end

set = MySortedSet.new(4, 1, 5, 10, 11, 4, 6)
set << 1
set << 41
set << 20

if set.to_a == [1, 4, 5, 6, 10, 11, 20, 41]
  puts "HUZZAH"
else
  puts "Whoops, it was #{set.to_a.inspect}"
end
