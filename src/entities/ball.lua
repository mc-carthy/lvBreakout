Ball = Class{}

function Ball:init(skin)
    self.w = BALL_SIZE
    self.h = BALL_SIZE
    self:reset()
    self.skin = skin
end

function Ball:collides(other)
    if 
        self.x > other.x + other.w or
        self.x + self.w < other.x or
        self.y > other.y + other.h or
        self.y + self.h < other.y
    then 
        return false
    end

    return true
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - BALL_SIZE / 2
    self.y = VIRTUAL_HEIGHT / 2 - BALL_SIZE / 2
    self.dx, self.dy = 0, 0
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        sounds.wallHit:play()
    end
    if self.x >= VIRTUAL_WIDTH - BALL_SIZE then
        self.x = VIRTUAL_WIDTH - BALL_SIZE
        self.dx = -self.dx
        sounds.wallHit:play()
    end
    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        sounds.wallHit:play()
    end
end

function Ball:draw()
    love.graphics.draw(textures['main'], frames['balls'][self.skin], self.x, self.y)
end