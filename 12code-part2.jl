using BenchmarkTools, IterTools, Match

input = open(readlines, "12example.txt")

# Part 1
mutable struct Waypoint
    x::Integer
    y::Integer
    curr::Integer
end

mutable struct Ship
    x::Integer
    y::Integer
    # curr::Integer
    waypoint::Waypoint
end

function steer!(coeff, val)
    wp = ship.waypoint
    if 0 < 


    # s = (360 + ship.waypoint.curr + val) % 360 # TODO
    
    # @match ship.curr begin
    #     90  => move!(w, 0, ship.waypoint)
    #     180 => move!(0, -w, ship.waypoint)
    #     270 => move!(-w, 0, ship.waypoint)
    #     0   => move!(0, w, ship.waypoint)
    # end
end

function move!(w)
    ship.x += w * ship.waypoint.x
    ship.y += w * ship.waypoint.y
end

function move!(dx, dy, what)
    what.x += dx
    what.y += dy
end

function run1(instr)
    r, w = instr[1], parse(Int, instr[2:end])
    
    @match r begin
        # Move Waypoint
        'N' => move!(0, w, ship.waypoint)
        'S' => move!(0, -w, ship.waypoint)
        'E' => move!(w, 0, ship.waypoint)
        'W' => move!(-w, 0, ship.waypoint)
        # Turn Waypoint
        'R' => steer!(1, w)
        'L' => steer!(-1, -w)
        # Move Ship towards Waypoint
        'F' => move!(w)
    end
end

function part1()
    global ship = Ship(0, 0, Waypoint(10, 1, 90))

    map(x->run1(x), input)

    return abs(ship.x) + abs(ship.y)
end
