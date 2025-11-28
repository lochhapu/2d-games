-- ===== OBJECTS =====
local enemy = require "Enemy"


-- Random seed
math.randomseed(os.time())


-- ===== TABLES =====

-- Game state structure
local game = {
    diffculty = 1,
    state = {
        menu = false,
        paused = false,
        running = true,
        ended = false,
    }
}

-- Player structure
local player = {
    radius = 20,
    x = 30,
    y = 30,
}

-- List of enemies
local enemies = {}


-- ===== LOAD =====
function love.load()
    -- Window and title initilization
    love.window.setTitle("Save the ball")

    -- Hide mouse cursor
    love.mouse.setVisible(false)

    -- First enemy
    table.insert(enemies, 1, enemy())
end


-- ===== UPDATE =====
function love.update()
    -- Player follows mouse
    player.x, player.y = love.mouse.getPosition()

    -- Move every enemy
    for i = 1, #enemies do
        enemies[i]:move(player.x, player.y)
    end
end


-- ===== DRAW =====
function love.draw()
    -- ===== Show FPS =====
    love.graphics.printf("FPS: " .. love.timer.getFPS(), love.graphics.newFont(16), 10, love.graphics.getHeight() - 30, love.graphics.getWidth())

    -- ===== Game running state =====
    if game.state.running then
        -- Draw enemies
        for i = 1, #enemies do
            enemies[i]:draw(player.x, player.y)
        end
       
        -- Draw player
        love.graphics.circle("fill", player.x, player.y, player.radius)
    end

    -- ===== Non running states =====
    if not game.state.running then
        -- Cursor
        love.graphics.circle("fill", player.x, player.y, player.radius / 2)
    end
end