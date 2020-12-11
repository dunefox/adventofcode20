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
function apply_rule1!(M, M₊, xpos, ypos)
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

function solve(M, M₊, board_inds, rule_fn!)
    while true
        for (xᵢ, yⱼ) in board_inds
            if M[xᵢ, yⱼ] != '.'
                rule_fn!(M, M₊, xᵢ, yⱼ)
            end
        end
        
        if M == M₊
            break
        end
        
        M = copy(M₊)
    end
end

# Part 2
function sightlines(M, xpos, ypos)
    seats_visible = 0

    for (xdir, ydir) in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
        x_curr, y_curr = xpos + xdir, ypos + ydir

        while M[x_curr, y_curr] == '.'
            x_curr += xdir
            y_curr += ydir
        end

        if M[x_curr, y_curr] == '#'
            seats_visible += 1
        end
    end

    return seats_visible
end

function apply_rule2!(M, M₊, xpos, ypos)
    c = sightlines(M, xpos, ypos)
    
    if c == 0 && M[xpos, ypos] == 'L'
        M₊[xpos, ypos] = '#'
    elseif c >= 5 && M[xpos, ypos] == '#'
        M₊[xpos, ypos] = 'L'
    end
end

lines = pad(open(readlines, "11input.txt"))
M = Char.(transpose(Int.(reduce(hcat, [[l...] for l in lines]))))
M₊ = copy(M)

function main()
    board_inds = [(i, j) for i in 2:length(lines) - 1 for j in 2:length(lines[1]) - 1]
    solve(M, M₊, board_inds, apply_rule1!)
    println(count(x -> x == '#', M₊))

    solve(M, M₊, board_inds, apply_rule2!)
    println(count(x -> x == '#', M₊))
end

@time main()
