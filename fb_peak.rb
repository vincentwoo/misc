require 'pp'
@names = {}
@rels = []

def process_name(name)
    return @names[name] if @names.include? name
    @rels.push Array.new(@rels.length, false)
    @rels.each {|row| row.push false}
    @names[name] = @names.length
end

def ingest(input)
    File.open(input, "r") do |f|
        f.each do |line|
            line = line.split
            to = process_name line.pop
            from = process_name line.pop
            @rels[from][to] = true
        end
    end
    for i in 0..@rels.length-1
        for j in i..@rels.length-1
            if i == j
                @rels[i][j] = true
            else
                @rels[i][j] = @rels[j][i] = @rels[i][j] and @rels[j][i]
            end
        end
    end
end

ingest('fb_peak.txt')
pp @rels