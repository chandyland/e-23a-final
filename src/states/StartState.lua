--[[
    Agar.vs

    -- StartState Class --
]]

StartState = Class{__includes = BaseState}


function StartState:enter(params)
end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()

        gStateMachine:change('player-select', {})
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Agar.vs", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['medium'])

    love.graphics.printf("ENTER to Start", 0, VIRTUAL_HEIGHT / 2 + 30,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(0, 0, 0, 0)
end