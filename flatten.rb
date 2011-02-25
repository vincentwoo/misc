def flatten(input)
	return [input] unless input.kind_of?(Array)
	ret = []
	for element in input
		ret = ret + flatten(element)
	end
	ret
end

p flatten [1, [[]], 2, [3, [4, 5], 6, 7, 8], 9, [10]]