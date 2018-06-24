ServeState = Class{ __includes = BaseState }

function ServeState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.highScores = params.highScores

    self.ball = Ball()
    self.ball.skin = math.random(7)
end

function ServeState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.w / 2) - BALL_SIZE / 2
    self.ball.y = self.paddle.y - self.paddle.h / 2

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
        stateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball,
            level = self.level,
            highScores = self.highScores
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ServeState:draw()
    self.paddle:draw()
    self.ball:draw()

    for k, brick in pairs(self.bricks) do
        brick:draw()
    end

    drawScore(self.score)
    drawHealth(self.health)

    love.graphics.setFont(fonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end