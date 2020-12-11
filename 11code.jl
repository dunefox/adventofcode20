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

lines = pad(open(readlines, "11example.txt"))
M = Char.(transpose(Int.(reduce(hcat, [[l...] for l in lines]))))
M₊ = copy(M)

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
        
        prettyprint(M, M₊)

        if M == M₊
            break
        end
        
        M = copy(M₊)
        # break
    end
end

# Part 2
function sightlines(M, xpos, ypos)
    seats_visible = 0

    for (xdir, ydir) in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
        x_curr, y_curr = xpos + xdir, ypos + ydir

        while M[x_curr, y_curr] == '.'
            # @info "WHILE" x_curr, y_curr xdir ydir
            # if M[x_curr, y_curr] == '#'
            #     seats_visible += 1
            #     break
            # elseif M[x_curr, y_curr] == '?'
            #     break
            # end

            x_curr += xdir
            y_curr += ydir
        end

        # @info "AFTER WHILE" x_curr y_curr

        if M[x_curr, y_curr] == '#'
            seats_visible += 1
            # @info "found #" seats_visible
        end
    end

    # if seats_visible != 0
    #     @info "RETURN" seats_visible
    # end

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

function main()
    lines = pad(open(readlines, "11input.txt"))
    M = Char.(transpose(Int.(reduce(hcat, [[l...] for l in lines]))))
    M₊ = copy(M)

    board_inds = [(i, j) for i in 2:length(lines) - 1 for j in 2:length(lines[1]) - 1]
    solve(M, M₊, board_inds, apply_rule2!)

    count(x -> x == '#', M₊)
end

main()
