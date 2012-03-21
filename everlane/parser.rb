# usage
# vwoo$ ruby parser.rb "a Qa Zj PaZZZZg QQQaaaa QQQaaaaa"
# a VALID
# Qa INVALID
# Zj VALID
# PaZZZZg VALID
# QQQaaaa VALID
# QQQaaaaa INVALID

def validate(input)
   valid, idx = validate_recursive(input.split(//), 0)
   return false unless valid
   return idx == input.size
end

# returns t/f, index one past the end of the message beginning at idx
def validate_recursive(chars, idx)
  return if (idx > chars.size)
  char = chars[idx]
  case char
  when 'a'..'j'
    return true, idx + 1
  when 'Z'
    return validate_recursive chars, idx+1
  when 'M', 'K', 'P', 'Q'
    first = validate_recursive chars, idx+1
    return false, idx + 1 unless first[0]
    return validate_recursive chars, first[1]
  else
    return false, idx + 1
  end
  validate_recursive(chars, idx+1)
end

inputs = ARGV[0].split
for input in inputs
  puts "%s %s" % [input, validate(input) ? "VALID" : "INVALID"]
end