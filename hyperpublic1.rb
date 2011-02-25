def parse(input)
    arr = []
    File.open(input, "r") do |f|
        f.readlines.each_with_index do |row, i|
            arr.push []
            row.each_char do |col|
                if col == 'O'
                    arr[i].push false
                elsif col == 'X'
                    arr[i].push true
                end
            end
        end
    end
    arr
end

def calc_influence(graph, row)
    ret = 0
    row.each_with_index do |col, j|
        ret += 1 + calc_influence(graph, graph[j]) if col
    end
    ret
end

M = parse 'challenge2input.txt'
p M.each.map{ |row| calc_influence M, row }.sort.reverse
