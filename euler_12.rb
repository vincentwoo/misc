triangles = Enumerator.new do |yielder|
  num = 1
  sum = 1
  loop do
    yielder.yield sum
    num += 1
    sum += num
  end
end

triangles.each do |triangle|
  divisors = 0
  (1..Math.sqrt(triangle).ceil).each do |factor|
    divisors += 2 if triangle % factor == 0
  end
  # p [triangle, divisors]
  if divisors > 500
    p triangle
    exit
  end
end
