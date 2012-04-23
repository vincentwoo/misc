# usage
# woo$ ruby parser.rb "a Qa Zj PaZZZZg QQQaaaa QQQaaaaa ZZQaZ"
# a VALID
# Qa INVALID
# Zj VALID
# PaZZZZg VALID
# QQQaaaa VALID
# QQQaaaaa INVALID
# ZZQaZ INVALID

def validate(input)
   valid, idx = validate_recursive(input.split(//), 0)
   valid ? idx == input.size : false
end

# returns t/f, index one past the end of the message beginning at idx
def validate_recursive(chars, idx)
  return false, idx + 1 if idx >= chars.size
  case chars[idx]
  when 'a'..'j'
    return true, idx + 1
  when 'Z'
    return validate_recursive chars, idx + 1
  when 'M', 'K', 'P', 'Q'
    chunk = validate_recursive chars, idx + 1
    return chunk unless chunk.first
    return validate_recursive chars, chunk.last
  else
    return false, idx + 1
  end
  validate_recursive chars, idx + 1
end

inputs = ARGV[0].split
for input in inputs
  puts "%s %s" % [input, validate(input) ? "VALID" : "INVALID"]
end