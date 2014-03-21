# the smallest number that is both a multiple of 225 and whose digits are all 1s and 0s
# 11111111100

# string.chars.all? { |c| c == '0' || c == '1' }

# i = 225
# i += 225 until i.to_s =~ /^[01]+$/
# p i

# to_test = [1]

# while to_test.any?
#   i = to_test.shift

#   if i % 225 == 0
#     p i
#     break
#   end

#   to_test += [i * 10, i * 10 + 1]
# end

class BinaryNumbers
  include Enumerable

  def each
    i = 0
    loop do
      yield i.to_s(2).to_i
      i += 1
    end
  end
end

p BinaryNumbers.new.lazy.drop(1).find {|i| i % 225 == 0}
