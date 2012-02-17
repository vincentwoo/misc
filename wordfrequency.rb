total = 0
for i in 1..900
  total += 2520 / i
end
p total

cur = 0
for i in 1..900
  cur += 2520 / i
  if cur >= total / 2
    p i + 1
    break
  end
end