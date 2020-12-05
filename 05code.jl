function main()
    function run1(p)
        parse(Int, join(Int.([p...]) .% 7 .% 2), base=2)
    end

    lines = sort(map(run1, open(readlines, "/home/paul/projekte/adventofcode20/05input.txt")))

    # Part 1
    @assert maximum(lines) == 890

    # Part 2
    (v1, v2) = filter(x->abs(x[1] - x[2]) == 2, collect(zip(lines, lines[2:end])))[1]
    @assert v1 + 1 == 651
end
