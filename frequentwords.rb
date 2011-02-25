# assuming words are separated by whitespace 
def frequencyCount(input)
	set = {}
	input.split.each { |word|
		set[word] = 0 if set[word].nil?
		set[word] = set[word] + 1
	}
	set = set.sort { |a, b| b[1] <=> a[1] }
	set[0..4].collect { |pair| pair[0] }
end

p frequencyCount "apple banana tangerine mango apple banana banana orange kiwi mango pineapple"