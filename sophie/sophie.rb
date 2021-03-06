#!/usr/bin/ruby

def ingest(input)
    f = File.open input, "r"
    $num = f.gets.to_i
    nodes = {}
    $probs = Array.new $num
    $weights = Array.new($num) {|i| Array.new($num) {|j| i == j ? 0 : Float::MAX}}
    $num.times do |i|
        line = f.gets.split
        nodes[line.first] = i
        $probs[i] = line.last.to_f
    end
    f.gets.to_i.times do
        line = f.gets.split
        x, y = line[0..1].collect{|n| nodes[n]}
        $weights[x][y] = $weights[y][x] = line.last.to_f
    end
    f.close
end

def floyd_warshall
    for k in 0..$num-1
    for i in 0..$num-1
    for j in 0..$num-1
        if $weights[i][k] + $weights[k][j] < $weights[i][j]
            $weights[i][j] = $weights[i][k] + $weights[k][j]
        end
    end
    end
    end
end

def solveable
    (1..$num-1).select {|i| $probs[i] > 0 and $weights[0][i] == Float::MAX}.empty?
end

$min = Float::MAX
def solve(node, remain, unseen, expect = 0, time = 0)
    return if expect + unseen * time >= $min
    return ($min = expect) if remain.empty?
    remain.each do |n|
        next_time  = time + $weights[node][n]
        solve n,
              remain - [n],
              unseen - $probs[n],
              expect + next_time * $probs[n],
              next_time
    end
    $min
end

ingest(ARGV[0])
floyd_warshall

unless solveable
    puts "-1.00"
    exit
end

puts "%.2f" % solve(0, (1..$num-1).select {|i| $probs[i] > 0}, 1 - $probs[0])
