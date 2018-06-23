PlayState = Class{ __includes = BaseState }

function PlayState:init()
    self.paddle = Paddle()
    self.ball = Ball(math.random(7))
    self.ball.dx = math.random(-100, 100)
    self.ball.dy = -100
    self.bricks = LevelMaker.createMap()
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            sounds.pause:stop()
            sounds.pause:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        sounds.pause:stop()
        sounds.pause:play()
        return
    end

    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball:collides(self.paddle) then
        sounds.paddleHit:play()
        self.ball.dy = -self.ball.dy
    end

    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then
            brick:hit()
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:draw()
    self.paddle:draw()

    for k, brick in pairs(self.bricks) do
        brick:draw()
    end

    self.ball:draw()
    if self.paused then
        love.graphics.setFont(fonts.large)
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    end
end