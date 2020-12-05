function main()
    lines = open(readlines, "02input.txt")

    vals = split.(filter(x -> x != "", lines), ": ", keepempty=false)
    println(length(filter(validate1, vals)), "\n", length(filter(validate2, vals)))
end

# Part 1
function validate1(line)
    number, char = split(line[1])
    from, to = parse.(Int32, split(number, "-"))

    return from <= count(x -> string(x) == char, [line[2]...]) <= to
end

# Part 2
function validate2(line)
    number, char = split(line[1])
    from, to = parse.(Int32, split(number, "-"))

    return (string(line[2][from]) == char) ⊻ (string(line[2][to]) == char)
end

main()

