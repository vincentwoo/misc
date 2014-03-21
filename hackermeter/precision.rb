$cache = {}

def solve hp, dmg
  #puts hp, dmg
  return $cache[[hp, dmg]] unless $cache[[hp, dmg]].nil?
  if hp == dmg
    ret = 1
  elsif hp < dmg
    ret = false
  else
    a = solve(hp - dmg, dmg)
    b = solve(hp - dmg, dmg * 2)
    ret = (a && b) ? [a, b].min : (a || b)
    ret += 1 if ret
  end
  $cache[[hp, dmg]] = ret
end

puts solve 1, 1
puts solve 3, 1
puts solve 4, 1
puts solve 341132412, 1