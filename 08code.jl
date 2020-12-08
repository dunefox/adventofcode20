read_instructions() = return [[x[1], parse(Int, x[2])] for x in split.(open(readlines, "08input.txt"))]

# Part 1
function run(pos=1, accumulator=0)
    pos = 1
    accumulator = 0
    visited = []
    
    while pos ∉ visited # && pos != length(instructions)
        if pos == length(instructions) + 1
            return accumulator, visited, true
        end
        
        push!(visited, pos)
        (inst, arg) = instructions[pos]

        if inst == "jmp"
            pos += arg
        elseif inst == "nop"
            pos += 1
        else
            pos += 1
            accumulator += arg
        end
    end

    return accumulator, visited, false
end

# Part 2
function change_pos(pos)
    val = instructions[pos][1]
    
    if val == "nop"
        instructions[pos][1] = "jmp"
    elseif val == "jmp"
        instructions[pos][1] = "nop"
    end
end

function main()
    global instructions = read_instructions()
    acc_, visited_, _ = run()
    initial_run = [acc_, visited_]

    for pos in initial_run[2]
        change_pos(pos)
        current_acc, current_positions, end_reached = run()

        if end_reached
            return current_acc
        end

        change_pos(pos)
    end
end

@assert main() == 1403
