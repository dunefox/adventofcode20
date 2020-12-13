using BenchmarkTools, Match, IterTools, Test

# Part 1
depart, buses = open("13input.txt") do f
    fst, snd = readlines(f)
    depart = parse(Int, fst)
    buses = parse.(Int, filter(x->x!="x", split(snd, ",")))
    depart, buses
end

function solve_part1(depart, buses)
    lowest = buses .- mod.(depart, buses)
    buses[argmin(lowest)] * minimum(lowest)
end

@btime solve_part1(depart, buses)

# Part 2
busplan = open("13input.txt") do f
    _, snd = readlines(f)
    [x != "x" ? parse(BigInt, x) : x for x in split(snd, ",")]
end

function crunch_numbers(buses)
    parsed = filter(x -> x[2] != "x", collect(enumerate(buses)))
    modulos = map(x -> x[2], parsed)
    remainders = map(x -> x[2] - (x[1] - 1), parsed)

    modulos, remainders
end

# Taken from https://rosettacode.org/wiki/Chinese_remainder_theorem#Julia
function solve_part2(n::Array, a::Array)
    Π = prod(n)
    mod(sum(ai * invmod(Π ÷ ni, ni) * Π ÷ ni for (ni, ai) in zip(n, a)), Π)
end

# Tests
@testset "Examples" begin
    @test solve_part2(crunch_numbers([17, "x", 13, 19])...)    == 3417
    @test solve_part2(crunch_numbers([67, 7, 59, 61])...)      == 754018
    @test solve_part2(crunch_numbers([67, "x", 7, 59, 61])...) == 779210
    @test solve_part2(crunch_numbers([67, 7, "x", 59, 61])...) == 1261476
    @test solve_part2(crunch_numbers([1789, 37, 47, 1889])...) == 1202161486
end;

@btime solve_part2(crunch_numbers(busplan)...)
