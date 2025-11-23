-- State variables
local winning_score = 5
game_over = false
winner = nil

function love.load()
    -- Window constants
    TITLE = "Pong"
    WIN_WIDTH = 800
    WIN_HEIGHT = 600

    -- Window
    love.window.setTitle(TITLE)
    love.window.setMode(WIN_WIDTH, WIN_HEIGHT)

    -- Paddle and ball constants
    PADDLE_WIDTH = 20
    PADDLE_HEIGHT = 100
    BALL_SIZE = 20
    BALL_SPEED = 200
    speed_increase = 1.10

    -- Scores
    score_1 = 0
    score_2 = 0

    -- Left paddle
    player_1 = {
        x = 50,
        y = 250,
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
    }

    -- Right paddle
    player_2 = {
        x = 800 - 50 - PADDLE_WIDTH,
        y = 250, 
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
    }

    -- Ball
    ball = {
        x = 400 - BALL_SIZE / 2,
        y = 300 - BALL_SIZE / 2,
        size = BALL_SIZE,
    }

    -- Initial speed for ball
    ball.dx = BALL_SPEED -- Horizontal speed
    ball.dy = BALL_SPEED -- Vertical speed
end


-- Check collision between paddles and balls
local function check_collision(ball, paddle)
    return ball.x <= paddle.x + paddle.width and 
            ball.x + ball.size >= paddle.x and
            ball.y <= paddle.y + paddle.height and
            ball.y + ball.size >= paddle.y 
end


local function reset_ball()
    ball.x = 400 - ball.size / 2
    ball.y = 300 - ball.size / 2
    ball.dx = 200 * (math.random(2) == 1 and 1 or -1)
    ball.dy = 200 * (math.random(2) == 1 and 1 or -1)
end


local function reset_pladdles()
    player_1.x = 50
    player_1.y = 250

    player_2.x = 800 - 50 - PADDLE_WIDTH
    player_2.y = 250
end


function love.update(dt)
    -- Stop all game logic when game is over
    if game_over then
        return
    end

    local speed = 350 -- Pixels per second

    -- Player 1 (left) input
    if love.keyboard.isDown("w") then
        player_1.y = math.max(0, player_1.y - speed*dt)
    elseif love.keyboard.isDown("s") then
        player_1.y = math.min(600 - player_1.height, player_1.y + speed*dt)
    end

    -- Player 2 (right) input
    if love.keyboard.isDown("up") then
        player_2.y = math.max(0, player_2.y - speed*dt)
    elseif love.keyboard.isDown("down") then
        player_2.y = math.min(600 - player_2.height, player_2.y + speed*dt)
    end

    -- Move ball
    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    -- Ball should bounce off walls
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy -- Reverse direction
    elseif ball.y + ball.size >= WIN_HEIGHT then
        ball.y = WIN_HEIGHT - ball.size
        ball.dy = -ball.dy -- Reverse direction
    end

    -- Ball collision with player 1
    if check_collision(ball, player_1) then
        ball.x = player_1.x + player_1.width -- Prevent overlap
        ball.dx = -ball.dx * speed_increase -- Reverse direction
    end

    -- Ball collision with player 2
    if check_collision(ball, player_2) then
        ball.x = player_2.x - ball.size -- Prevent overlap
        ball.dx = -ball.dx * speed_increase -- Reverse direction
    end

    -- If ball enters goal
    if ball.x + ball.size < 0 then
        score_2 = score_2 + 1
        reset_ball()
    elseif ball.x + ball.size > WIN_WIDTH then
        score_1 = score_1 + 1
        reset_ball()
    end

    -- Check if someone won
    if score_1 >= winning_score then
        game_over = true
        winner = "Player 1"
        return
    elseif score_2 >= winning_score then
        game_over = true
        winner = "Player 2"
        return
    end
end


-- If restart pressed
function love.keypressed(key)
    if key == "r" and game_over then
        score_1 = 0
        score_2 = 0
        game_over = false
        winner = nil
        reset_ball()
        reset_pladdles()
    end
end


function love.draw()
    -- Game over state
    if game_over then
        love.graphics.setFont(love.graphics.newFont(36))
        love.graphics.printf(winner .. " Won!", 0, 250, 800, "center")
        love.graphics.setFont(love.graphics.newFont(22))
        love.graphics.printf("Press R to restart", 0, 300, 800, "center")
        return -- Stop drawing other components
    end

    -- Background color
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    -- Draw line at center
    love.graphics.setColor(1, 1, 1)
    for i = 0, 600, 30 do
        love.graphics.rectangle("fill", 395, i, 10, 15)
    end

    -- Draw paddles
    love.graphics.rectangle("fill", player_1.x, player_1.y, player_1.width, player_1.height)
    love.graphics.rectangle("fill", player_2.x, player_2.y, player_2.width, player_2.height)

    -- Draw ball
    love.graphics.rectangle("fill", ball.x, ball.y, ball.size, ball.size)

    -- Score display
    local scoreFont = love.graphics.newFont(40)
    love.graphics.setFont(scoreFont)
    love.graphics.print(score_1, 300, 50)
    love.graphics.print(score_2, 470, 50)
end