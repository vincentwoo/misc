test  = [ "THIS IS A TEST STRING\n test test ",
          "45blah blah blah \n newlines everywhere \n",
          "i'm really bad at \ncoming up with test \"data!\"",
          "9",
          "",
          "\n\n\n"
        ]

#encoding:
out = File.new("output.txt", "w")
for str in test
    out.syswrite(str.length.to_s + ":" + str + "\n")
    # format ex: "hello world" becomes "11:hello world\n"
end
out.syswrite("\n") # convenience extra line break at end for iteration
out.close

#decoding
input = File.new("output.txt", "r")
toRead = 0
decoded_strings = []
str = ""
for line in input
    if toRead <= 0
        decoded_strings.push str.chomp #chomp the extra "\n"
        str = ""
        str_toRead = line.split(':').first 
        toRead = str_toRead.to_i + 1 #account for addition of extra "\n"
        line = line[str_toRead.length + 1, line.length - str_toRead.length - 1]
    end
    if !line.nil?
        str += line
        toRead -= line.length
    end
end
decoded_strings.delete_at 0 #delete the dummy element that gets added in first loop
input.close

puts "Decoded strings match originals" if decoded_strings == test