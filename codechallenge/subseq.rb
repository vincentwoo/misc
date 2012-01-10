
def binary_search(lst, lower, upper, target)
  return -1 if lower > upper
  
  mid = (lower+upper)/2
  
  if (lst[mid][0] == target)
    mid
  elsif (target < lst[mid][0])
    binary_search(lst, lower, mid-1, target)
  else
    binary_search(lst, mid+1, upper, target)
  end
end

def find_indicies_less_than(sorted, x)
  ret = binary_search(sorted, 0, sorted.size - 1, x)
  while (sorted[ret +1] == sorted[ret])
    ret += 1
  end
  (0..ret).map { |i| sorted[i][1] }
end

def solve(sequence, weights)
  n = sequence.size
  dp = Array.new(n)
  dp[0] = weights[0]
  
  sorted_idx = sequence.each_with_index.map {|x, i| [x, i]}
  sorted_idx.sort! {|a, b| a[0] <=> b[0]}
  
  for i in 1.upto n-1
    dp[i] = weights[i]
    
    for j in (i-1).downto(0)
    #for j in find_indicies_less_than(sorted_idx, sequence[i])
      if (sequence[j] < sequence[i] and dp[j] + weights[i] > dp[i])
        dp[i] = dp[j] + weights[i]
      end
    end
  end
  
  dp.max
end

numtests = gets.to_i
numtests.times do
  gets
  sequence = gets.split.map { |x| x.to_i }
  weights = gets.split.map { |x| x.to_i }
  p solve(sequence, weights)
end