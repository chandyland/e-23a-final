--[[
    Agar.vs

    -- PlayState Class --
]]

PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.player1 = params.player1
    self.player2 = params.player2
    self.score1 = params.score1
    self.score2 = params.score2
    self.round = params.round

    self.objects = {}
    self:generateObjects()
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    self.player1:update(dt)
    self.player2:update(dt)

    if self.player1:collides(self.player2) or self.player2:collides(self.player1) then
        local roundWinner = nil
        if self.player1.size > self.player2.size then
            roundWinner = 1
            self.score1 = self.score1 + 1
        elseif self.player2.size > self.player1.size then
            roundWinner = 2
            self.score2 = self.score2 + 1
        else
            self.player1.dx = -self.player1.dx
            self.player1.dy = -self.player1.dy

            self.player2.dx = -self.player2.dx
            self.player2.dy = -self.player2.dy
        end

        if roundWinner then
            gStateMachine:change('victory', {
                player1 = self.player1,
                player2 = self.player2,
                winner = roundWinner,
                score1 = self.score1,
                score2 = self.score2,
                round = self.round
            })
            gSounds['win']:play()
        end
    end
    
    for k, object in pairs(self.objects) do
        if object.inPlay then
            if object:collides(self.player1) then
                object:handlePlayerCollision(self.player1)
            elseif object:collides(self.player2) then
                object:handlePlayerCollision(self.player2)
            end
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    self:refillObjects()
end

function PlayState:generateObjects()
    for i = 1, 10 do
        table.insert(self.objects, Buff(
            'buff',
            math.random(0, VIRTUAL_WIDTH - 16),
            math.random(0, VIRTUAL_HEIGHT - 16)
        ))
    end

    for i = 1, 10 do
        table.insert(self.objects, Buff(
            'debuff',
            math.random(0, VIRTUAL_WIDTH - 16),
            math.random(0, VIRTUAL_HEIGHT - 16)
        ))
    end
end

function PlayState:refillObjects()
    local inPlayObjects = {}

    for k, object in pairs(self.objects) do
        if object.inPlay then
            table.insert(inPlayObjects, object)
        end
    end

    if #inPlayObjects < 20 then
        local randomNum = math.random(1, 4)
        if (randomNum % 2 == 0) then
            table.insert(self.objects, Buff(
                'buff',
                math.random(0, VIRTUAL_WIDTH - 16),
                math.random(0, VIRTUAL_HEIGHT - 16)
            ))
        else
            table.insert(self.objects, Buff(
                'debuff',
                math.random(0, VIRTUAL_WIDTH - 16),
                math.random(0, VIRTUAL_HEIGHT - 16)
            ))
        end
    end
end

function PlayState:render()
    self.player1:render()
    self.player2:render()


    for k, object in pairs(self.objects) do
        object:render()
    end

    renderScores(self.score1, self.score2)

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end