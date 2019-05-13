--[[
    Agar.vs

    -- StartState Class --
]]

VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.player1 = params.player1
    self.player2 = params.player2
    self.winner = params.winner
    self.score1 = params.score1
    self.score2 = params.score2
    self.round = params.round
end

function VictoryState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.score1 == 3 or self.score2 == 3 then
            gStateMachine:change('start', {})
        else
            gStateMachine:change('preplay', {
                player1 = self.player1,
                player2 = self.player2,
                score1 = self.score1,
                score2 = self.score2,
                round = self.round + 1
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function VictoryState:render()
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Player " .. tostring(self.winner) .. " wins Round " .. tostring(self.round),
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("" .. tostring(self.score1) .. " - " .. tostring(self.score2), 0, VIRTUAL_HEIGHT / 4 + 25,
        VIRTUAL_WIDTH, 'center')

    if self.score1 == 3 or self.score2 == 3 then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("Player " .. tostring(self.winner) .. " wins!",
            0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf('ENTER to restart', 0, VIRTUAL_HEIGHT / 2 + 48,
            VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf('ENTER to start next round', 0, VIRTUAL_HEIGHT / 2 + 16,
            VIRTUAL_WIDTH, 'center')
    end
end