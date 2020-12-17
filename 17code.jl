using BenchmarkTools, IterTools, Match

function getadjacent(coords)
    global offsets

    return [coords .+ n for n in offsets]
end

# Handle a single cell
function evolvecell(coords)
    global active, next

    neighbours = getadjacent(coords)
    counter = 0

    for n in neighbours
        if n ∈ keys(active)
            counter += 1
        end
    end

    # Cell is alive and stays alive => copy to next
    if coords ∈ keys(active) && 2 <= counter <= 3
        next[coords] = true
    # Cell is dead and becomes alive => copy to next
    elseif coords ∉ keys(active) && counter == 3
        next[coords] = true
    end
end

# Create the hull of coordinates (all neighbours) around living cells
function createhull()
    global active

    hull = Set(Iterators.flatten(getadjacent.(keys(active))))

    return hull
end

# Iterate over all alive cells and empty cells adjacent to them
# => if eligible evolve and copy to next
function step()
    global active, next

    hull = createhull()
    alive = keys(active)
    allcells = union(hull, alive)

    foreach(evolvecell, allcells)

    active = copy(next)
    next = Dict{Array{Int64,1}, Bool}()
end

dims = 4
active = Dict{Array{Int64,1}, Bool}()
next = copy(active)
# All neighbours for a cell
inds = CartesianIndices(rand(Int8, [3 for i in 1:dims]...))
offsets = setdiff(map(x->x.I .- [2 for i in 1:dims], inds), [[0 for i in 1:dims]])

function resetstate!(file)
    global active, next

    active = Dict{Array{Int64,1}, Bool}()
    next = copy(active)

    open(file) do f
        for (row, line) in enumerate(readlines(f))
            for (col, cell) in enumerate(line)
                if cell == '#'
                    #           row    col    height width
                    if dims == 3
                        active[[row,   col,   1]]        = true
                    else
                        active[[row,   col,   1,     1]] = true
                    end
                end
            end
        end
    end
end

function main(file="17example.txt")
    global active

    resetstate!(file)

    counter = length(active)

    for stepᵢ in 1:6
        step()
        counter = length(active)
    end

    return counter
end

main("17input.txt")
