$primes = [2]
$last_prime = 3
$factors = {
  1 => [1],
  2 => [2]
}

def generate_primes n
  return if n < $last_prime

  ($last_prime..n).each do |candidate|
    breakpoint = Math.sqrt(candidate)
    found = true
    $primes.each do |prime|
      break if prime > breakpoint
      if candidate % prime == 0
        found = false
        break
      end
    end

    if found
      $primes.push candidate
      $factors[candidate] = [candidate]
    end
  end

  $last_prime = n + 1
end

def factorize n, ith_prime = 0
  return $factors[n] if $factors[n]
  generate_primes n

  breakpoint = n / 2

  while ith_prime < $primes.length
    prime = $primes[ith_prime]
    raise 'Uhh...' if prime > breakpoint

    if n % prime == 0
      return $factors[n] = [prime] + factorize(n / prime, ith_prime)
    end

    ith_prime += 1
  end
end

1000000.downto(1).each do |i|
  raise "error factorizing #{i}" unless factorize(i).inject(:*) == i
end
