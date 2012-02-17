def fact(n)
  ret = 1
  for i in n.downto(1)
    ret = ret * i
  end
  ret
end

def digitsum(n)
  ret = 0
  while (n > 0)
    ret = ret + (n % 10)
    n = n / 10
  end
  ret
end

i = 0
while (digitsum(fact(i)) != 8001)
  i += 1
end
p i