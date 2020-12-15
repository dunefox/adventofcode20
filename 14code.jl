using BenchmarkTools, IterTools

lines = split(open(x -> read(x, String), "14input.txt"), "mask = ", keepempty=false);

# Part 1
function part1(lines)
    memory = Dict{Int, Int}()

    for block in split.(lines, "\n", keepempty=false)
        mask, instructions = block[1], block[2:end]

        for instr in instructions
            adr, content = parse.(Int, [m.match for m in eachmatch(r"(\d+)", instr)])
            
            bits = collect(bitstring(content)[end-35:end])

            for (i, c) in filter(x -> x[2] != 'X', collect(enumerate(mask)))
                bits[i] = c
            end

            memory[adr] = parse(Int, join(bits), base=2)
        end
    end

    return sum(values(memory))
end

@btime part1(lines)

# Part 2
permutations(n::Int) = vec(map(collect, Iterators.product(ntuple(_ -> [0, 1], n)...)))

function part2(lines)
    memory = Dict{Int, Int}()

    for block in split.(lines, "\n", keepempty=false)
        mask, instructions = filter(x -> x[2] != '0', collect(enumerate(block[1]))), block[2:end]

        for instr in instructions
            adr, content = parse.(Int, [m.match for m in eachmatch(r"(\d+)", instr)])
            
            bits = collect(bitstring(adr)[end-35:end])
            val = parse(Int, bitstring(content)[end-35:end], base=2)
            
            for (i, c) in mask
                bits[i] = c
            end

            fluctuations = []

            for p in permutations(count(x->x=='X', bits))
                cp = copy(bits)
                cp[bits .== 'X'] .= Char.('0' .+ p)
                push!(fluctuations, cp)
            end

            adresses = parse.(Int, join.(fluctuations), base=2)

            for adress in adresses
                memory[adress] = val
            end
        end
    end

    return sum(values(memory))
end

@btime part2(lines)
