using BenchmarkTools, Match, IterTools, Test

# Part 1
depart, buses = open("13input.txt") do f
    fst, snd = readlines(f)
    depart = parse(Int, fst)
    buses = parse.(Int, filter(x->x!="x", split(snd, ",")))
    depart, buses
end

function part1(depart, buses)
    lowest = buses .- mod.(depart, buses)
    buses[argmin(lowest)] * minimum(lowest)
end

@btime part1(depart, buses)

# Part 2
# Chinese remainder problem, etc. ... no idea. 🤷

# This code works but I couldn't come up with my own solution => "part2" is taken from RC

function prep(buses)
    rests = (x->(x[2], x[1] - 1)).(filter(x->x[2] != "x", collect(enumerate(buses))))
    tmp = [0; abs.([el[2] for el in rests[2:end]] .- [el[1] for el in rests[2:end]])]
    
    return [x[1] for x in rests], tmp
end

buses = open("13input.txt") do f
    _, snd = readlines(f)
    buses = [x != "x" ? parse(Int, x) : x for x in split(snd, ",")]
    prep(buses)
end

# Taken from https://rosettacode.org/wiki/Chinese_remainder_theorem#Julia
function part2(n::Array, a::Array)
    Π = prod(n)
    mod(sum(ai * invmod(Π ÷ ni, ni) * Π ÷ ni for (ni, ai) in zip(n, a)), Π)
end

# Tests
@testset "Examples" begin
    @test part2(prep([17, "x", 13, 19])...)    == 3417
    @test part2(prep([67, 7, 59, 61])...)      == 754018
    @test part2(prep([67, "x", 7, 59, 61])...) == 779210
    @test part2(prep([67, 7, "x", 59, 61])...) == 1261476
    @test part2(prep([1789, 37, 47, 1889])...) == 1202161486
end;

@btime part2(buses...)
