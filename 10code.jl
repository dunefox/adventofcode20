using Test, BenchmarkTools, IterTools

input = sort(parse.(Int, open(readlines, "10input.txt")))
input = [0, input..., input[end] + 3]

# Part 1
function part1(adapters)
    interm = map(((x1, x2),) -> (abs(x1 - x2) == 1 || abs(x1 - x2) == 3) ? (abs(x1 - x2), (x1, x2)) : (),
                 collect(zip(input, input[2:end])))
    count(x -> x[1] == 1, interm) * count(x -> x[1] == 3, interm)
end

# Part 2
function solve(graph)
    node2ind = Dict([node=>ind for (ind, node) in enumerate([name for (name, vals) in graph])])
    A⁰ = UpperTriangular(zeros(Int, length(graph), length(graph)))

    # Create adjacency matrix
    for (name, cols) in graph
        row = node2ind[name]

        for col in cols
            A⁰[row, node2ind[col]] += 1
        end
    end

    Aⁱ = UpperTriangular(zeros(Int, length(graph), length(graph)))

    for i in 1:length(graph)
        Aⁱ += A⁰^i
    end

    return Aⁱ
end

function valid_options(all_vals)
    graph = []

    for (ind, el) in enumerate(all_vals)
        push!(graph, (el, collect(takewhile(x -> abs(x - all_vals[ind]) ∈ 1:3, all_vals[ind + 1:end]))))
    end
    
    return solve(graph)
end

function main()
    @info "Part 1" part1(input)
    @info "Part 2" valid_options(input[1:end-1])[1, end]
end
