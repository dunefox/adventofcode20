function main()
    lines = open(x->read(x, String), "/home/paul/projekte/adventofcode20/06input.txt")

    # Part 1
    sum([length(unique(join(x))) for x in split.(split(lines, "\n\n"), "\n", keepempty=false)])

    # Part 2
    sum([length(reduce(intersect, x[2:end], init=x[1])) for x in split.(split(lines, "\n\n"), "\n", keepempty=false)])
end

using BenchmarkTools
@btime main();
