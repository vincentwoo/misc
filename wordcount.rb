# problems:
#  words like don't
#  reading the entire file in memory
#  builds reverse index dumbly, not while iterating, pretty slow
# pros:
#  EASY TO CODE FAST

require 'pp'

file = File.open "wordinput.txt", "rb"
contents = file.read.downcase
index = contents.scan(/\w+/).group_by{|x| x}.map {|k,v| [k, v.length]}
reverse = index.map {|word, count|
  last = 0
  ret = []
  count.times do
    last = contents.index word, last
    ret.push last
    last += 1
  end
  [word, ret]
}

p "indices: "
pp index
p "reverse indices: "
pp reverse