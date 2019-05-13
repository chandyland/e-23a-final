--[[
    Agar.vs

    -- Player Class --
]]

Player = Class{}

function Player:init(skin, playerNumber, left, right, up, down)
    self.playerNumber = playerNumber
    self.dx = 0
    self.dy = 0
    self.width = 16
    self.height = 16
    self.skin = skin
    self.left = left
    self.right = right
    self.up = up
    self.down = down
    self.size = 1
    self.maxSize = 10
end

function Player:reset()
    if self.playerNumber == 1 then
        self.x = VIRTUAL_WIDTH / 4 - 32
    else
        self.x = 3 * VIRTUAL_WIDTH / 4 + 32
    end

    self.dx = 0
    self.dy = 0
    self.y = VIRTUAL_HEIGHT - 32
    self.size = 1
    self.width = 16
    self.height = 16
end

function Player:collides(player)
    if self.x > player.x + player.width or player.x > self.x + self.width then
        return false
    end

    if self.y > player.y + player.height or player.y > self.y + self.height then
        return false
    end 

    return true
end

function Player:decreaseSize()
    if self.size > 1 then
        self.size = self.size - 1
        self.width = self.size * 16
        self.height = self.width
    end
end

function Player:increaseSize()
    if self.size < self.maxSize then
        self.size = self.size + 1
        self.width = self.size * 16
        self.height = self.width
    end
end

function Player:update(dt)
    if love.keyboard.isDown(self.left) then
        self.dx = -PLAYER_SPEED
    elseif love.keyboard.isDown(self.right) then
        self.dx = PLAYER_SPEED
    elseif love.keyboard.isDown(self.up) then
        self.dy = -PLAYER_SPEED
    elseif love.keyboard.isDown(self.down) then
        self.dy = PLAYER_SPEED
    end

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end

    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Player:render()
    love.graphics.draw(gTextures['blob' .. self.skin],
        self.x, self.y, 0, self.size / 4, self.size / 4)
end