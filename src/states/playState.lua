PlayState = Class{ __includes = BaseState }

function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = params.ball
    self.level = params.level
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = -100
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end
    return true
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
        
        self.ball.y = self.paddle.y - self.paddle.h / 2
        self.ball.dy = -self.ball.dy

        -- TODO: Offset ball.dx instead of using baseDx and clamp the value to a max
        -- TODO: Allow the ball.dx to be modified when paddle.dx is 0
        local baseDx = 50
        if self.ball.x < self.paddle.x + self.paddle.w / 2 and self.paddle.dx < 0 then
            self.ball.dx = -baseDx - (8 * (self.paddle.x + self.paddle.w / 2 - self.ball.x))
        elseif self.ball.x > self.paddle.x + self.paddle.w / 2 and self.paddle.dx > 0 then
            self.ball.dx = baseDx + (8 * math.abs(self.paddle.x + self.paddle.w / 2 - self.ball.x))
        end
    end

    for k, brick in pairs(self.bricks) do
        brick:update(dt)
        if brick.inPlay and self.ball:collides(brick) then
            self.score = self.score + (brick.tier * 200 + brick.colour * 20)

            brick:hit()

            if self:checkVictory() then
                sounds.victory:stop()
                sounds.victory:play()
                stateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    ball = self.ball
                })
            end

            -- TODO: Add rework the order of checks to prioritise vertical checks
            -- This is to prevent the ball intersecting from both horizontal and vertical directions
            -- By adding an offset to the horizontal collisions, we are prioritising vertical collisions
            local xOffset = 2
        
            if self.ball.x + xOffset < brick.x and self.ball.dx > 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - BALL_SIZE
            elseif self.ball.x + BALL_SIZE - xOffset > brick.x + brick.w and self.ball.dx < 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + 32
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - BALL_SIZE
            elseif self.ball.y > brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + brick.h
            end
            self.ball.dy = self.ball.dy * 1.025
            break

        end
    end


    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        sounds['hurt']:stop()
        sounds['hurt']:play()
        
        if self.health <= 0 then
            stateMachine:change('gameOver', {
                score = self.score
            })
        else
            stateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                level = self.level
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:draw()
    for k, brick in pairs(self.bricks) do
        brick:draw()
        brick:drawParticles()
    end
    
    self.paddle:draw()
    self.ball:draw()

    drawHealth(self.health)
    drawScore(self.score)

    if self.paused then
        love.graphics.setFont(fonts.large)
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    end
end