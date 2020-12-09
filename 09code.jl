using Test, BenchmarkTools

# Part 1 - Brute force
function solve_range1(pos, numbers, preamble=preamble)
    for i in pos - preamble:pos - 1
        for j in i + 1:pos - 1
            if numbers[i] + numbers[j] == numbers[pos]
                return true
            end
        end
    end

    return false
end

function solve_all(lines)
    for pos in preamble + 1:length(lines)
        if !solve_range1(pos, lines)
            return lines[pos]
        end
    end
end

# Part 2 - Brute force
function solve_contiguous(goal, ns)
    i, j = 1, 2

    while j <= length(ns)
        s = sum(ns[i:j])

        if s == goal
            rs = ns[i:j]
            return minimum(rs), maximum(rs)
        elseif s < goal
            j += 1
        else
            i += 1
            j = i + 1
        end
    end

    return rs
end

function main()
    global lines = parse.(Int, open(readlines, "09example.txt"))
    global preamble = 5

    # Part 1
    @assert solve_all(lines) == 127

    # Part 2
    @assert solve_contiguous(127, lines) == (15, 47)
end

@btime main();
