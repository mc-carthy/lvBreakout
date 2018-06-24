LevelMaker = Class{}

-- global patterns (used to make the entire map a certain shape)
NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

-- per-row patterns
SOLID = 1           -- all colours the same in this row
ALTERNATE = 2       -- alternate colours
SKIP = 3            -- skip every other block
NONE = 4            -- no blocks this row

local padding = 8

function LevelMaker.createMap(level)
    local bricks = {}

    local numRows = math.random(1, 5)
    local numCols = math.random(7, 13)
    numCols = numCols % 2 == 0 and (numCols + 1) or numCols

    local highestTier = math.min(3, math.floor(level / 5))
    local highestColour = math.min(5, level % 5 + 3)

    for y = 1, numRows do
        local skipPattern = math.random(1, 2) == 1 and true or false

        local alternatePattern = math.random(1, 2) == 1 and true or false
        
        local alternateColour1 = math.random(1, highestColour)
        local alternateColour2 = math.random(1, highestColour)
        local alternateTier1 = math.random(0, highestTier)
        local alternateTier2 = math.random(0, highestTier)
        
        local skipFlag = math.random(2) == 1 and true or false

        local alternateFlag = math.random(2) == 1 and true or false

        local solidColour = math.random(1, highestColour)
        local solidTier = math.random(0, highestTier)

        for x = 1, numCols do
            if skipPattern and skipFlag then
                skipFlag = not skipFlag

                goto continue
            else
                skipFlag = not skipFlag
            end

            b = Brick(
                (x - 1) * BRICK_WIDTH + padding + (13 - numCols) * padding * 2, 
                y * padding * 2
            )

            if alternatePattern and alternateFlag then
                b.colour = alternateColour1
                b.tier = alternateTier1
                alternateFlag = not alternateFlag
            else
                b.colour = alternateColour2
                b.tier = alternateTier2
                alternateFlag = not alternateFlag
            end

            if not alternatePattern then
                b.colour = solidColour
                b.tier = solidTier
            end 

            table.insert(bricks, b)

            ::continue::
        end
    end

    if #bricks == 0 then
        return self.createMap(level)
    else
        return bricks
    end
end