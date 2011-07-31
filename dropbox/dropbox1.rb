require 'pp'
require 'set'

class Rect
  attr_accessor :w, :h
  
  def initialize(w, h)
    @w = w
    @h = h
  end
  
  def rotate
    Rect.new self.h, self.w
  end
end

class Placement < Rect
  attr_accessor :x1, :x2, :y1, :y2
  
  def initialize(rect, x, y)
    super(rect.w, rect.h)
    @x1 = x
    @x2 = x + @w
    @y1 = y
    @y2 = y + @h
  end
  
  def ==(other)
    @x1 == other.x1 && @x2 == other.x2 && @y1 == other.y1 && @y2 == other.y2
  end
  
  def eql?(other)
    self == other
  end
  
  def hash
    @x1 * 2 + @x2 * 3 + @y1 * 5 + @y2 * 7
  end
end

def validate_placement(placed, placement)
  not placed.any? { |check|
    (check.x1 < placement.x2) and (check.x2 > placement.x1) and
    (check.y1 < placement.y2) and (check.y2 > placement.y1)
  }
end

def generate_placements(rect, placed)
  placements = []
  [rect, rect.rotate].each do |rect|
    placements.push Placement.new(rect, 0, 0) if placed.empty?
    placed.each do |block|
      placements += [
        Placement.new(rect, block.x1,          block.y1 - rect.h),
        Placement.new(rect, block.x1,          block.y2),
        Placement.new(rect, block.x2 - rect.w, block.y1 - rect.h),
        Placement.new(rect, block.x2 - rect.w, block.y2),
        Placement.new(rect, block.x1 - rect.w, block.y1),
        Placement.new(rect, block.x2,          block.y1),
        Placement.new(rect, block.x1 - rect.w, block.y2 - rect.h),
        Placement.new(rect, block.x2,          block.y2 - rect.h)
      ]
    end
  end
  placements.select { |placement| validate_placement(placed, placement) }
end

def evaluate_cost(placed)
  min_x = placed.map { |placement| placement.x1 }.min
  max_x = placed.map { |placement| placement.x2 }.max
  min_y = placed.map { |placement| placement.y1 }.min
  max_y = placed.map { |placement| placement.y2 }.max
  (max_x - min_x) * (max_y - min_y)
end

$seen = Set.new
$cheapest = nil

def solve(placed, unplaced)
  return if not $seen.add? placed
  $cheapest = {:cost => evaluate_cost(placed), :placed => placed} if unplaced.empty?
  unplaced.each do |rect|
    generate_placements(rect, placed).each do |placement|
      newplaced = placed + [placement]
      next if ($cheapest and $cheapest[:cost] <= evaluate_cost(newplaced))
      solve newplaced, unplaced - [rect]
    end
  end
  $cheapest
end

rects = []
cheapest = nil

gets.to_i.times do 
    dim = gets.split.collect{|s| s.to_i}
    rects.push(Rect.new(dim[0], dim[1]))
end

p solve(Set.new, rects)[:cost]