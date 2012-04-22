n = gets.to_i
#n = 100000
@sieveMax = 2830
@sieve = [2]
additivePrimes = [2]
i = 3

while true
  break if i > @sieveMax
  isPrime = true
  ceil = Math.sqrt(i).ceil
  for prime in @sieve
    break if prime > ceil
    if i % prime == 0
      isPrime = false
      break
    end
  end
  @sieve.push(i) if isPrime
  i += 2
end

@map = {}
@sieve.each {|i| @map[i] = true}

def isPrime(num)
  return false if num <= 1
  ceil = Math.sqrt(num).ceil
  #puts("TOO HIGH " + ceil.to_s) if ceil > @sieveMax
  for prime in @sieve
    break if prime == num || prime > ceil
    return false if num % prime == 0
  end
  true
end

def digitSum(num)
  additive = 0
  while num > 0
    additive += num % 10
    num /= 10
  end
  additive
end

i = 3
while true
  if additivePrimes.length == n
    puts additivePrimes.last
    break
  end
  if @map.member?(digitSum(i)) and isPrime(i)
    additivePrimes.push i
  end
  i += 2
end