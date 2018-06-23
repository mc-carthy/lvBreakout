Brick = Class{}

function Brick:init(x, y)
    self.tier = 0
    self.colour = 1
    self.x = x
    self.y = y
    self.w = BRICK_WIDTH
    self.h = BRICK_HEIGHT

    self.inPlay = true
end

function Brick:hit()
    sounds.brickHit2:stop()
    sounds.brickHit2:play()
    self.inPlay = false
end

function Brick:draw()
    if self.inPlay then
        love.graphics.draw(
            textures['main'],
            frames['bricks'][1 + ((self.colour) - 1) * 4],
            self.x,
            self.y
        )
    end
end