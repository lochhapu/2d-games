function Enemy()
    local dice = math.random(1, 4)
    local _x, _y = 0, 0
    local _radius = 20

    -- Find position for enemy to spawn randomly outside the screen
    if dice == 1 then -- top
        _x = math.random(0, love.graphics.getWidth())
        _y = -_radius * 4
    elseif dice == 2 then -- bottom
        _x = math.random(0, love.graphics.getWidth())
        _y = love.graphics.getHeight + _radius * 4
    elseif dice == 3 then -- left
        _y = math.random(0, love.graphics.getHeight())
        _x = -_radius * 4
    elseif dice == 4 then -- right
        _y = math.random(0, love.graphics.getHeight())
        _x = love.graphics.getWidth() + _radius * 4
    end

    return {
        level = 1,
        radius = _radius,
        x = _x,
        y = _y,

        -- Move enemy towards player
        move = function (self, player_x, player_y)
            -- move to in player x pos
            if player_x - self.x > 0 then
                self.x = self.x + self.level
            elseif player_x - self.x < 0 then
                self.x = self.x - self.level
            end
         
            -- move to player y pos
            if player_y - self.y > 0 then
                self.y = self.y + self.level
            elseif player_y - self.y < 0 then
                self.y = self.y - self.level
            end
        end,

        -- Draw enemy
        draw = function (self)
            -- set the color to white
            love.graphics.setColor(1, 0.5, 0.7)

            -- draw a circle (the enemy)
            love.graphics.circle("fill", self.x, self.y, self.radius)

            -- reset the color back to white
            love.graphics.setColor(1, 1, 1)
        end,
    }
end

return Enemy