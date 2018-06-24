Brick = Class{}

paletteColours = {
    -- blue
    [1] = {
        ['r'] = 0.4,
        ['g'] = 0.6,
        ['b'] = 1
    },
    -- green
    [2] = {
        ['r'] = 0.4,
        ['g'] = 0.8,
        ['b'] = 0.2
    },
    -- red
    [3] = {
        ['r'] = 0.9,
        ['g'] = 0.35,
        ['b'] = 0.4
    },
    -- purple
    [4] = {
        ['r'] = 0.85,
        ['g'] = 0.5,
        ['b'] = 0.85
    },
    -- gold
    [5] = {
        ['r'] = 1,
        ['g'] = 1,
        ['b'] = 0.2
    }
}

function Brick:init(x, y)
    self.tier = 0
    self.colour = 1
    self.x = x
    self.y = y
    self.w = BRICK_WIDTH
    self.h = BRICK_HEIGHT
    
    self.psystem = love.graphics.newParticleSystem(textures['particle'], 64)
    self.psystem:setParticleLifetime(0.5, 1)
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)
    self.psystem:setEmissionArea('normal', 10, 10)

    self.inPlay = true
end

function Brick:hit()
    self.psystem:setColors(
        paletteColours[self.colour].r,
        paletteColours[self.colour].g,
        paletteColours[self.colour].b,
        0.2 * (self.tier + 1),
        paletteColours[self.colour].r,
        paletteColours[self.colour].g,
        paletteColours[self.colour].b,
        0
    )
    self.psystem:emit(64)

    sounds.brickHit2:stop()
    sounds.brickHit2:play()

    if self.tier > 0 then
        if self.colour == 1 then
            self.tier = self.tier - 1
            self.colour = 5
        else
            self.colour = self.colour - 1
        end
    else
        if self.colour <= 1 then
            self.inPlay = false
        else
            self.colour = self.colour - 1
        end
    end

    if not self.inPlay then
        sounds.brickHit1:stop()
        sounds.brickHit1:play()
    end
end

function Brick:update(dt)
    self.psystem:update(dt)
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

function Brick:drawParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end