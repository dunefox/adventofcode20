using BenchmarkTools, IterTools, Match, Test

p1, p2 = open("22input.txt") do f
    input = []
    for line in readlines(f)
        if !(startswith(line, "P") || line == "")
            push!(input, parse(Int, line))
        end
    end

    input[1:div(length(input), 2)], input[div(length(input), 2) + 1:end]
end

function part1(p1, p2)
    while length(p1) > 0 && length(p2) > 0
        c1 = popfirst!(p1)
        c2 = popfirst!(p2)

        if c1 > c2
            push!(p1, c1)
            push!(p1, c2)
        else
            push!(p2, c2)
            push!(p2, c1)
        end
    end

    result = 0

    for (rank, card) in enumerate(reverse(length(p1) > 0 ? p1 : p2))
        result += rank * card
    end

    result
end

part1(p1, p2)
