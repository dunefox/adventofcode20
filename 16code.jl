using Test, BenchmarkTools, Match, DataFrames, CSV

data, ranges, myticket, tickets = open("16input.txt") do f
    blocks = split(read(f, String), "\n\n", keepempty=false)
    data = Dict{String,Array{Int,1}}()
    ranges = Dict{String,Array{UnitRange{Int64},1}}()

    for spec in split(blocks[1], "\n")
        field_vals = []
        field, r1s, r1e, r2s, r2e = match(r"^([A-Za-z ]*): (\d+)\-(\d+) or (\d+)\-(\d+)$", string(spec)).captures
        
        for val in [parse(Int, r1s):parse(Int, r1e)..., parse(Int, r2s):parse(Int, r2e)...]
            push!(field_vals, val)
        end

        ranges[field] = [parse(Int, r1s):parse(Int, r1e), parse(Int, r2s):parse(Int, r2e)]
        data[field] = field_vals
    end

    myticket = parse.(Int, split(split(blocks[2], "\n", keepempty=false)[2], ",", keepempty=false))
    tickets = collect(map(x -> parse.(Int, x), split.(split(blocks[3], "\n")[2:end], ",")))

    data, ranges, myticket, tickets
end

# Part 1
function part1(data, tickets)
    invalid = 0
    allranges = Iterators.flatten(values(data))
    invalid_inds = []

    for (ind, ticket) in enumerate(tickets)
        for val in ticket
            if val ∉ allranges
                invalid += val
                push!(invalid_inds, ind)
            end
        end
    end

    deleteat!(tickets, invalid_inds)

    invalid
end

part1(data, tickets)
