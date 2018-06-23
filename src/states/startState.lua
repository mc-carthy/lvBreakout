StartState = Class{ __includes = BaseState }

local highlighted = 1

function StartState:update(dt)
    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['paddle-hit']:play()
    end

    -- we no longer have this globally, so include here
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:draw()
    love.graphics.setFont(fonts['large'])
    love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(fonts['medium'])

    if highlighted == 1 then
        love.graphics.setColor(0.1, 1, 1, 1)
    end
    love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 2 then
        love.graphics.setColor(0.4, 1, 1, 1)
    end
    love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
end