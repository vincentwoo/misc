def analyze(line)
    splitted_strings = line.split '|'
    name = splitted_strings[0].strip
    ticker = splitted_strings[1].strip
    data = splitted_strings[2].strip[1..-2].split(', ').collect {|s| s.to_f}
    max_burst = [0, 0, 0]
    min = [data[0], 0]
    for i in 0..data.length-2
        if data[i] < min[0]
            min[0] = data[i]
            min[1] = i
        else
            if data[i] / min[0] > max_burst[0]
                max_burst[0] = data[i] / min[0]
                max_burst[1] = min[1]
                max_burst[2] = i
            end
        end
    end
    {   :name => name,
        :ticker => ticker,
        :burstPercentage => max_burst[0] * 100 - 100,
        :burstAmount => (data[max_burst[2]] - data[max_burst[1]]),
        :startMonth => max_burst[1],
        :endMonth => max_burst[2]
    }
end

## SCRIPT ENTRY POINT HERE ##

raw = File.new("data.txt", "r")
data = []
raw.each { |line| data.push(analyze line) }
data.sort! { |a, b| b[:burstPercentage] <=> a[:burstPercentage] }
for security in data
    puts security[:ticker] + " bursted $" + "%.2f" % security[:burstAmount] + "(" + 
                    "%.2f" % security[:burstPercentage] + "%) from month " +
                    security[:startMonth].to_s + " to month " +
                    security[:endMonth].to_s
end
raw.close