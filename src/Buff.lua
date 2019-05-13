--[[
    Agar.vs

    -- Buff Class --
]]

Buff = Class{}

function Buff:init(type, x, y)
    self.x = x
    self.y = y

    self.width = 4
    self.height = 4

    self.dx = math.random(-200, 200)
    self.dy = math.random(-50, -60)

    self.type = type
    self.inPlay = true
end

function Buff:collides(player)
    if self.x > player.x + player.width or player.x > self.x + self.width then
        return false
    end

    if self.y > player.y + player.height or player.y > self.y + self.height then
        return false
    end 

    return true
end

function Buff:handlePlayerCollision(player)
    self.inPlay = false
    if self.type == "buff" then
        player:increaseSize();
        gSounds['good_hit']:play()
    else
        player:decreaseSize();
        gSounds['bad_hit']:play()
    end
end      

function Buff:update(dt)
    
end

function Buff:render()
    if self.inPlay then
        love.graphics.draw(gTextures[self.type],
            self.x, self.y, 0, 0.5, 0.5)
    end
end