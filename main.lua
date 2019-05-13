require 'src/Dependencies'


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Agar.vs')

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    love.graphics.setFont(gFonts['small'])

    gTextures = {
        ['background'] = love.graphics.newImage('graphics/bg.png'),
        ['arrowLeft'] = love.graphics.newImage('graphics/leftarrow.png'),
        ['arrowRight'] = love.graphics.newImage('graphics/rightarrow.png'),
		['blob1'] = love.graphics.newImage('graphics/blob1.png'),
		['blob2'] = love.graphics.newImage('graphics/blob2.png'),   	
		['blob3'] = love.graphics.newImage('graphics/blob3.png'),   	
		['blob4'] = love.graphics.newImage('graphics/blob4.png'),
		['buff'] = love.graphics.newImage('graphics/buff.png'),
		['debuff'] = love.graphics.newImage('graphics/debuff.png')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gSounds = {
        ['good_hit'] = love.audio.newSource('sounds/good_hit.wav'),
        ['bad_hit'] = love.audio.newSource('sounds/bad_hit.wav'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav'),
        ['select'] = love.audio.newSource('sounds/select.wav'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav'),
        ['pause'] = love.audio.newSource('sounds/pause.wav'),
        ['win'] = love.audio.newSource('sounds/win.wav'),
    }

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['preplay'] = function() return PrePlayState() end,
        ['victory'] = function() return VictoryState() end,
        ['player-select'] = function() return PlayerSelectState() end
    }
    
    gStateMachine:change('start', {})

    love.keyboard.keysPressed = {}
end


function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.draw()
    push:apply('start')

    local bg_image = gTextures['background']
    bg_image:setWrap("repeat", "repeat")
    bg_quad = love.graphics.newQuad(0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, bg_image:getWidth() / 2, bg_image:getHeight() / 2)
    love.graphics.draw(bg_image, bg_quad, 0, 0)
    
    gStateMachine:render()
    
    push:apply('end')
end


function renderScores(score1, score2)
	love.graphics.setColor(0, 0, 0, 255)
    love.graphics.setFont(gFonts['small'])
    
    love.graphics.print('Player 1:', 5, 5)
    love.graphics.printf(tostring(score1), 5, 5, 45, 'right')
    
    love.graphics.print('Player 2:', VIRTUAL_WIDTH - 55, 5)
    love.graphics.printf(tostring(score2), VIRTUAL_WIDTH - 50, 5, 45, 'right')

    love.graphics.setColor(255, 255, 255, 255)
end