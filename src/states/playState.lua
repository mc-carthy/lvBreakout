PlayState = Class{ __includes = BaseState }

function PlayState:init()
    self.paddle = Paddle()
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            sounds.pause:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        sounds.pause:play()
        return
    end

    self.paddle:update(dt)

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:draw()
    self.paddle:draw()
    if self.paused then
        love.graphics.setFont(fonts.large)
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    end
end