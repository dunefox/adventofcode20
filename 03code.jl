using Test

board = open(readlines, "03input.txt")

test_board = split("""..##.........##.........##.........##.........##.........##.......
                      #...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
                      .#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
                      ..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
                      .#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
                      ..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....
                      .#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
                      .#........#.#........#.#........#.#........#.#........#.#........#
                      #.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
                      #...##....##...##....##...##....##...##....##...##....##...##....#
                      .#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#"""
                      )

# Part 1

function boring_part1(board)
    counter = 0
    rowlen =length(board[1])

    for (ind, row) in enumerate(board[2:end])
        pos = ((ind * 3) % rowlen) + 1

        if row[pos] == '#'
            counter += 1
        end
    end

    return counter
end

@test boring_part1(board) == 203

# Part 2

slopes = [
    (1, 1),
    (3, 1),
    (5, 1),
    (7, 1),
    (1, 2)
]

function walkdown(col, row, board)
    rowlen = length(board[1])
    counter = 0

    for (ind, rowᵢ) in enumerate(board[row+1:row:end])
        if rowᵢ[((ind * col) % rowlen) + 1] == '#'
            counter += 1
        end
    end

    return counter
end

reduce(*, [walkdown(slp..., board) for slp in slopes])

# Tests

@testset "Real" begin
    @test walkdown(slopes[2]..., board) == 203
end;

@testset "Example" begin
    @test walkdown(slopes[1]..., test_board) == 2
    @test walkdown(slopes[2]..., test_board) == 7
    @test walkdown(slopes[3]..., test_board) == 3
    @test walkdown(slopes[4]..., test_board) == 4
    @test walkdown(slopes[5]..., test_board) == 2
end;
