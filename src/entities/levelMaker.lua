LevelMaker = Class{}

local padding = 8

function LevelMaker:createMap(level)
    local bricks = {}

    local numRows = math.random(1, 5)
    local numCols = math.random(7, 13)

    for y = 1, numRows do
        for x = 1, numCols do
            b = Brick(
                (x - 1) * BRICK_WIDTH + padding + (13 - numCols) * padding * 2,
                y * BRICK_HEIGHT
            )
            table.insert(bricks, b)
        end
    end

    return bricks
end