using Test, BenchmarkTools, IterTools

input = open("15input.txt") do f
    parse.(Int, split(read(f, String), ","))
end

# Part1
function part1(numbers, n=2020)
    while length(numbers) < n
        if (pos = findlast(x -> x == numbers[end], numbers[1:end - 1])) != nothing
            push!(numbers, length(numbers) - pos)
        else
            push!(numbers, 0)
        end
    end
    
    return numbers[end]
end

# Part 2
function part2(numbers, n=30000000)
    mem = Dict(numbers[1:end - 1] .=> 1:length(numbers) - 1)
    last_spoken = numbers[end]

    for i in length(mem) + 2:n
        if last_spoken ∈ keys(mem)
            spoken = i - 1 - mem[last_spoken]
        else
            spoken = 0
        end

        mem[last_spoken] = i - 1
        last_spoken = spoken
    end

    return last_spoken
end

@testset "Examples1" begin
    @test part1([1, 3, 2]) == 1
    @test part1([2, 1, 3]) == 10
    @test part1([1, 2, 3]) == 27
    @test part1([2, 3, 1]) == 78
    @test part1([3, 2, 1]) == 438
    @test part1([3, 1, 2]) == 1836
end

@testset "Examples2" begin
    @test part2([0, 3, 6]) == 175594
    @test part2([1, 3, 2]) == 2578
    @test part2([2, 1, 3]) == 3544142
    @test part2([1, 2, 3]) == 261214
    @test part2([2, 3, 1]) == 6895259
    @test part2([3, 2, 1]) == 18
    @test part2([3, 1, 2]) == 362
end
