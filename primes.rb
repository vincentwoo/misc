def nthprime(n)
	return 2 if n == 0
	i = 3
	primes = [2]
	while n != 0
		found = true
		for prime in primes
			if i % prime == 0
				found = false
				break
			end
		end
		if found
			primes.push i
			n -= 1
		end
		i += 2
	end
	primes.last
end

p nthprime 20000