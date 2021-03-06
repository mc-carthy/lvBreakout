Paddle = Class{}

local distanceFromBottom = 32

function Paddle:init(skin)
    self.w = 64
    self.h = 16
    self.x = VIRTUAL_WIDTH / 2 - self.w / 2
    self.y = VIRTUAL_HEIGHT - distanceFromBottom
    self.dx = 0
    self.skin = skin
    self.size = 2
end

function Paddle:update(dt)
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.w, self.x + self.dx * dt)
    end
end

function Paddle:draw()
    love.graphics.draw(
        textures['main'],
        frames['paddles'][self.size + 4 * (self.skin - 1)],
        self.x,
        self.y
    )
end