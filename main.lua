require('src.utils.dependencies')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    
    sounds = {
        ['paddle-hit'] = love.audio.newSource('assets/audio/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('assets/audio/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('assets/audio/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('assets/audio/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('assets/audio/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('assets/audio/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('assets/audio/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('assets/audio/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('assets/audio/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('assets/audio/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('assets/audio/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('assets/audio/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('assets/audio/pause.wav', 'static'),

        ['music'] = love.audio.newSource('assets/audio/music.wav', 'static')
    }

    fonts = {
        ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32)
    }

    love.graphics.setFont(fonts.small)

    textures = {
        ['background'] = love.graphics.newImage('assets/images/background.png'),
        ['main'] = love.graphics.newImage('assets/images/breakout.png'),
        ['arrows'] = love.graphics.newImage('assets/images/arrows.png'),
        ['hearts'] = love.graphics.newImage('assets/images/hearts.png'),
        ['particle'] = love.graphics.newImage('assets/images/particle.png')
    }

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    stateMachine = StateMachine {
        ['start'] = function() return StartState() end
    }

    stateMachine:change('start')

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.update(dt)
    stateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    Push:start()

    local backgroundWidth = textures['background']:getWidth()
    local backgroundHeight = textures['background']:getHeight()

    love.graphics.draw(textures['background'], 
        0, 0, 
        0,
        VIRTUAL_WIDTH / (backgroundWidth), VIRTUAL_HEIGHT / (backgroundHeight))
    
    stateMachine:draw()
    
    displayFPS()
    
    Push:finish()
end

function displayFPS()
    love.graphics.setFont(fonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end