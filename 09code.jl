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
        s = sum(@view ns[i:j])

        if s == goal
            return extrema(@view ns[i:j])
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
    global lines = parse.(Int, open(readlines, "09input.txt"))
    global preamble = 25

    # Part 1
    p1 = solve_all(lines)

    # Part 2
    p2 = solve_contiguous(lines[556], lines[1:555])

    return p1, p2
end

@btime main(); # ~2.5 ms
