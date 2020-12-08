using Test

function create_graph()
    d = Dict()

    for val in vals
        if val[1] ∈ keys(d)
            for bag in val[2:end]
                if (b = join(split(bag, " ")[2:end], " ")) ∉ keys(d[val[1]])
                    d[val[1]][b] = parse(Int, split(bag, " ")[1])
                end
            end
        else
            d[val[1]] = Dict()
            for bag in val[2:end]
                d[val[1]][join(split(bag, " ")[2:end], " ")] = parse(Int, split(bag, " ")[1])
            end
        end
    end

    return d
end

function solve_graph1()
    stack = ["shiny gold bag"]
    colours = []

    while length(stack) > 0
        val = popfirst!(stack)
        for colour in keys(graph)
            if val ∈ keys(graph[colour])
                push!(stack, colour)
                push!(colours, colour)
            end
        end
    end
    length(unique(colours))
end

function solve_graph3(bag="shiny gold bag")
    return sum([sub_bag ∈ keys(graph) ? (graph[bag][sub_bag] * solve_graph3(sub_bag) + graph[bag][sub_bag]) : graph[bag][sub_bag]
                for sub_bag in keys(graph[bag])])
end

vals = filter(x->x[2] != "no other bags", split.(open(readlines, "07input.txt"), r"(\.|\scontain\s|,\s)", keepempty=false))
vals = [rstrip.(val, 's') for val in vals]

function main()
    global graph = create_graph()

    l1 = solve_graph1()
    l2 = solve_graph3()
end

main()

# Tests
@testset "Examples" begin
    @test solve_graph1() == 254
    @test solve_graph3() == 6006
end;
