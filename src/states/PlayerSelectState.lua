--[[
    Agar.vs

    -- PlayerSelectState Class --
]]

PlayerSelectState = Class{__includes = BaseState}

function PlayerSelectState:enter(params)
end

function PlayerSelectState:init()
    self.leftMostColor = 1
    self.rightMostColor = 4
    self.selectedColor = 1
    self.selectingPlayer = 1
    self.player1 = nil
    self.player2 = nil
    self.player1Color = nil
end

function PlayerSelectState:update(dt)
    if love.keyboard.wasPressed('left') then
        if self.selectedColor == self.leftMostColor then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.selectedColor = self.selectedColor - 1
        end
    elseif love.keyboard.wasPressed('right') then
        if self.selectedColor == self.rightMostColor then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.selectedColor = self.selectedColor + 1
        end
    end

    if self.selectedColor == self.player1Color then
        if self.selectedColor < self.rightMostColor then
            if self.player1Color == 1 then
                self.leftMostColor = 2
            end
            self.selectedColor = self.selectedColor + 1
        else
            self.selectedColor = 1
            self.rightMostColor = 3
        end
    end

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        if self.player1 == nil then
            self.player1 = Player(self.selectedColor, 1, 'a', 'd', 'w', 's')
            self.player1Color = self.selectedColor 
            self.selectingPlayer = 2
        elseif self.player2 == nil then
            self.player2 = Player(self.selectedColor, 2, 'left', 'right', 'up', 'down')
        end

        if self.player1 and self.player2 then
            gSounds['confirm']:play()
            gStateMachine:change('preplay', {
                player1 = self.player1,
                player2 = self.player2,
                score1 = 0,
                score2 = 0,
                round = 1
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayerSelectState:render()
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Player " .. tostring(self.selectingPlayer), 0, VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Select your color with left and right", 0, VIRTUAL_HEIGHT / 4 + 48,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf("ENTER to continue", 0, VIRTUAL_HEIGHT / 3 + 48,
        VIRTUAL_WIDTH, 'center')
        
    if self.selectedColor == self.leftMostColor then
        love.graphics.setColor(40, 40, 40, 128)
    end
    
    love.graphics.draw(gTextures['arrowLeft'], VIRTUAL_WIDTH / 4 - 24,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
   
    love.graphics.setColor(255, 255, 255, 255)

    if self.selectedColor == self.rightMostColor then
        love.graphics.setColor(40, 40, 40, 128)
    end
    
    love.graphics.draw(gTextures['arrowRight'], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
    
    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.draw(gTextures['blob' .. self.selectedColor],
        VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3, 0, 0.5, 0.5)
end