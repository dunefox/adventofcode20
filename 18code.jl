using Test, BenchmarkTools, IterTools, Match

tokenise(expr) = split(reduce(replace, ["(" => " ( ", ")" => " ) "], init="(" * expr * ")"), " ", keepempty=false)

input = tokenise.(readlines("18input.txt"))

# Part 1
mutable struct Interpreter
    pos
    expr
end

isnumber(s::AbstractString) = tryparse(Int, s) isa Int

function eat(I)
    if I.pos == length(I.expr)
        error("OVER BOUNDS: $(I.pos) > $(length(I.expr))")
    end

    I.pos += 1

    return I.expr[I.pos - 1]
end

function parsetoken(token)
    @match token begin
        "*" || "+" => Symbol(token)
        _          => parse(Int, token)
    end
end

function parseexpr(I)
    if I.expr[I.pos] == "("
        tree = []
        
        eat(I) # advance

        while I.expr[I.pos] != ")"
            if I.expr[I.pos] == "("
                push!(tree, parseexpr(I))
            else
                push!(tree, parsetoken(I.expr[I.pos]))
            end

            eat(I) # advance
        end

        return tree
    end
end

function matchop(op)
    return op == :+ ? (+) : (*)
end

function evalast(ast)
    # Ugly hack needed due to ( Expr ) that's added by tokenise
    if ast[1] isa Array && length(ast) == 1
        ast = ast[1]
    end

    i = 3
    
    if ast[1] isa Array
        acc = evalast(ast[1])
    else
        acc = ast[1]
    end

    while i <= length(ast)
        if ast[i] isa Array
            acc = matchop(ast[i - 1])(acc, evalast(ast[i]))
        else
            acc = matchop(ast[i - 1])(acc, ast[i])
        end

        i += 2
    end

    return acc
end

function evalast2(ast)
    # Ugly hack needed due to ( Expr ) that's added by tokenise
    if ast[1] isa Array && length(ast) == 1
        ast = ast[1]
    end

    i = 3
    
    acc = Array{Any,1}()

    if ast[1] isa Array
        push!(acc, evalast2(ast[1]))
    else
        push!(acc, ast[1])
    end

    while i <= length(ast)
        if ast[i] isa Array && ast[i - 1] == :+
            el = evalast2(ast[i])
            push!(acc, pop!(acc) + el)
        elseif ast[i - 1] == :+
            push!(acc, pop!(acc) + ast[i])
        else
            push!(acc, ast[i - 1])
            push!(acc, evalast2(ast[i]))
        end

        i += 2
    end

    if all(x -> !(x isa Array), acc)
        return evalast(acc)
    end

    return acc
end

function main(input, evaluator)
    results = []

    for line in input
        I = Interpreter(1, line)
        push!(results, evaluator(parseexpr(I)))
    end

    return sum(results)
end

main(input, evalast)
main(input, evalast2)

# Tests
@testset "Examples Part 1" begin
    @test main([tokenise("2 * 3 + (4 * 5)")], evalast) == 26
    @test main([tokenise("5 + (8 * 3 + 9 + 3 * 4 * 3)")], evalast) == 437
    @test main([tokenise("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")], evalast) == 12240
    @test main([tokenise("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")], evalast) == 13632
end

@testset "Examples Part 2" begin
    @test main([tokenise("1 + (2 * 3) + (4 * (5 + 6))")], evalast2) == 51
    @test main([tokenise("2 * 3 + (4 * 5)")], evalast2) == 46
    @test main([tokenise("5 + (8 * 3 + 9 + 3 * 4 * 3)")], evalast2) == 1445
    @test main([tokenise("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")], evalast2) == 669060
    @test main([tokenise("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")], evalast2) == 23340
end
