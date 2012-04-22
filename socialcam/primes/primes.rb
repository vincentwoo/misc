n = gets.to_i
@sieveMax = 500
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

def isPrime(num)
  ceil = Math.sqrt(num).ceil
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
#require 'pp'
while true
  if additivePrimes.length == n
    puts additivePrimes.last
    #pp additivePrimes
    break
  end
  
  if isPrime(digitSum(i)) and isPrime(i)
    additivePrimes.push i
  end
  
  i += 2
 end