
function walk_rest(diff, start, vals)
    for val in vals[start:end]
        if diff - val ∈ vals
            return val * (diff - val)
        end
    end

    return -1
end

function walk_all(vals)
    for (i, val) in enumerate(vals)
        let diff = 2020 - val
            res = walk_rest(diff, i, vals)

            if res != -1
                return val * res
            end
        end
    end
end

function main()
    vals = open("01input.txt") do f
        return parse.(Int64, readlines(f))
    end

    @assert walk_rest(2020, 1, vals) == 299299
    @assert walk_all(vals) == 287730716
end

