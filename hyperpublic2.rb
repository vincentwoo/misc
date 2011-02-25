ACTIONS = [2, 3, 17, 23, 42, 98]
PEOPLE = [2349, 2102, 2001, 1747]

@meno = Array.new 2500, -1

def solve(val)
    return 0 if val == 0
    return nil if val < 2
    return @meno[val] unless @meno[val] == -1
    ret = []
    for action in ACTIONS
        break if action > val
        if action == val
            @meno[val] = 1
            return 1
        end
        r = solve(val - action)
        ret.push(r+1) unless r.nil?
    end
    @meno[val] = ret.min
end

for person in PEOPLE
    p solve person
end
