using BenchmarkTools, IterTools, Match

input = open(readlines, "12input.txt")

# Part 2
mutable struct Waypoint
    x::Integer
    y::Integer
end

mutable struct Ship
    x::Integer
    y::Integer
    waypoint::Waypoint
end

function rot90(x, y)
    return (y, -x)
end

function steer!(coeff, val)
    wp = ship.waypoint
    val = coeff == 1 ? val : (360 - val)

    if val == 90
        (dx, dy) = rot90(wp.x, wp.y)
        wp.x = dx
        wp.y = dy
    elseif val == 180
        (dx, dy) = rot90(rot90(wp.x, wp.y)...)
        wp.x = dx
        wp.y = dy
    elseif val == 270
        (dx, dy) = rot90(-wp.x, -wp.y)
        wp.x = dx
        wp.y = dy
    end
end

function moveship!(w)
    ship.x += w * ship.waypoint.x
    ship.y += w * ship.waypoint.y
end

function movewp!(dx, dy)
    ship.waypoint.x += dx
    ship.waypoint.y += dy
end

function run1(instr)
    r, w = instr[1], parse(Int, instr[2:end])
    
    @match r begin
        # Move Waypoint
        'N' => movewp!(0, w)
        'S' => movewp!(0, -w)
        'E' => movewp!(w, 0)
        'W' => movewp!(-w, 0)
        # Turn Waypoint
        'R' => steer!(1, w)
        'L' => steer!(-1, w)
        # Move Ship towards Waypoint
        'F' => moveship!(w)
    end
end

function part2()
    global ship = Ship(0, 0, Waypoint(10, 1))

    map(x -> run1(x), input)

    return abs(ship.x) + abs(ship.y)
end

part2()
