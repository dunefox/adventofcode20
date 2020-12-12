using BenchmarkTools, IterTools, Match

input = open(readlines, "12input.txt")

# Part 1
mutable struct Ship
    x
    y
    curr
end

function steer!(val)
    ship.curr = (360 + ship.curr + val) % 360 # TODO
end

function move!(w)
    @match ship.curr begin
        90  => move!(w, 0)
        180 => move!(0, -w)
        270 => move!(-w, 0)
        0   => move!(0, w)
    end
end

function move!(dx, dy)
    ship.x += dx
    ship.y += dy
end

function run1(instr)
    r, w = instr[1], parse(Int, instr[2:end])
    
    @match r begin
        'N' => move!(0, w)
        'S' => move!(0, -w)
        'E' => move!(w, 0)
        'W' => move!(-w, 0)
        'R' => steer!(w)
        'L' => steer!(-w)
        'F' => move!(w)
    end
end

function part1()
    global ship = Ship(0, 0, 90)

    map(x->run1(x), input)

    return abs(ship.x) + abs(ship.y)
end
