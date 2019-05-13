--[[
    Agar.vs

    -- PrePlayState Class --
]]

PrePlayState = Class{__includes = BaseState}

function PrePlayState:enter(params)
    self.player1 = params.player1
    self.player2 = params.player2
    self.score1 = params.score1
    self.score2 = params.score2
    self.round = params.round

    self.player1:reset()
    self.player2:reset() 
end

function PrePlayState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            player1 = self.player1,
            player2 = self.player2,
            score1 = self.score1,
            score2 = self.score2,
            round = self.round
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PrePlayState:render()
    self.player1:render()
    self.player2:render()

    renderScores(self.score1, self.score2)

    love.graphics.setColor(0, 0, 0, 255)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Round ' .. tostring(self.round), 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('ENTER to serve', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end