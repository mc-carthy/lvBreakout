require('src.utils.dependencies')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    
    sounds = {
        ['paddleHit'] = love.audio.newSource('assets/audio/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('assets/audio/score.wav', 'static'),
        ['wallHit'] = love.audio.newSource('assets/audio/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('assets/audio/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('assets/audio/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('assets/audio/no-select.wav', 'static'),
        ['brickHit1'] = love.audio.newSource('assets/audio/brick-hit-1.wav', 'static'),
        ['brickHit2'] = love.audio.newSource('assets/audio/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('assets/audio/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('assets/audio/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('assets/audio/recover.wav', 'static'),
        ['highScore'] = love.audio.newSource('assets/audio/high_score.wav', 'static'),
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
        ['background'] = love.graphics.newImage('assets/sprites/background.png'),
        ['main'] = love.graphics.newImage('assets/sprites/breakout.png'),
        ['arrows'] = love.graphics.newImage('assets/sprites/arrows.png'),
        ['hearts'] = love.graphics.newImage('assets/sprites/hearts.png'),
        ['particle'] = love.graphics.newImage('assets/sprites/particle.png')
    }

    frames = {
        ['paddles'] = GenerateQuadsPaddles(textures.main),
        ['balls'] = GenerateQuadsBalls(textures.main),
        ['bricks'] = GenerateQuadsBricks(textures.main),
        ['hearts'] = GenerateQuads(textures.hearts, 10, 9)
    }

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    stateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function() return ServeState() end,
        ['gameOver'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['highScores'] = function() return HighScoreState() end,
        ['enterHighScore'] = function() return EnterHighScoreState() end
    }

    stateMachine:change('start', {
        highScores = loadHighScores()
    })

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
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
    
    stateMachine:draw()
    
    displayFPS()
    
    Push:finish()
end

function displayFPS()
    love.graphics.setFont(fonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

function drawScore(score)
    love.graphics.setFont(fonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end

function drawHealth(health)
    local healthX = VIRTUAL_WIDTH - 100
    
    for i = 1, health do
        love.graphics.draw(textures['hearts'], frames['hearts'][1], healthX, 4)
        healthX = healthX + 11
    end

    -- render missing health
    for i = 1, 3 - health do
        love.graphics.draw(textures['hearts'], frames['hearts'][2], healthX, 4)
        healthX = healthX + 11
    end
end

function loadHighScores()
    love.filesystem.setIdentity('breakout')

    if not love.filesystem.exists('breakout.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'MIC\n'
            scores = scores .. tostring(i * 1000) .. '\n'
        end

        love.filesystem.write('breakout.lst', scores)
    end

    local name = true
    local currentName = nil
    local counter = 1

    local scores = {}

    for i = 1, 10 do
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    for line in love.filesystem.lines('breakout.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        name = not name
    end

    return scores
end