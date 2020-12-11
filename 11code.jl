using BenchmarkTools, IterTools

function pad(s, padding="■")
    l = length(s[1])
    return [padding^(l + 2);
     [padding * el * padding for el in s]...;
     padding^(l + 2)]
end

function prettyprint(M, M₊)
    s = join([join([join(m_row), " "^10, join(mp_row)], "") for (m_row, mp_row) in zip(eachrow(M), eachrow(M₊))], "\n")

    println(s)
    println("\n$(M == M₊)\n______________________________________\n")
end

# Part 1
function apply_rule!(M, M₊, xpos, ypos)
    els = [M[xpos + x, ypos + y] for (x, y) in [
        (-1, -1), (-1, 0), (-1, 1), (0, -1), 
        (0, 1), (1, -1), (1, 0), (1, 1)
    ]]
    c = count(x -> x == '#', els)
    
    if c == 0 && M[xpos, ypos] == 'L'
        M₊[xpos, ypos] = '#'
    elseif c >= 4 && M[xpos, ypos] == '#'
        M₊[xpos, ypos] = 'L'
    end
end

lines = pad(open(readlines, "11example.txt"))
M = Char.(transpose(Int.(reduce(hcat, [[l...] for l in lines]))))
M₊ = copy(M)

# Part 1
function part1(M, M₊, board_inds)
    M₋ = copy(M)
    
    for (xᵢ, yⱼ) in board_inds
        if M[xᵢ, yⱼ] != '.'
            apply_rule!(M, M₊, xᵢ, yⱼ)
        end
    end

    M = copy(M₊)

    # prettyprint(M₋, M)

    while M != M₋ # true
        # if M == M₊
        #     break
        # end

        M₋ = copy(M)

        for (xᵢ, yⱼ) in board_inds
            if M[xᵢ, yⱼ] != '.'
                apply_rule!(M, M₊, xᵢ, yⱼ)
            end
        end
        
        M = copy(M₊)

        # prettyprint(M₋, M)
    end
end

# Part 2


function main()
    board_inds = [(i, j) for i in 2:length(lines)-1 for j in 2:length(lines[1])-1]
    part1(M, M₊, board_inds)

    count(x->x=='#', M₊)
end

@time main()