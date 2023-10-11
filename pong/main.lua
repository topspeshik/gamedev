require "Paddle"
require "Ball"

function love.load()
    
    backgroundImage = love.graphics.newImage("img/stsena_dlya_igry.png")
    screenWidth = backgroundImage:getWidth()
    screenHeight = backgroundImage:getHeight()

    marginSide = screenWidth * 0.075
    marginUpDown = screenWidth * 0.06
    velocity = 450
    love.window.setMode(screenWidth, screenHeight)

    startScreen = true
    gameScreen = false
    endScreen = false
    winnerScreen = ""
    isComputerPlay = false

    paddleRight = Paddle:create("right")
    paddleLeft = Paddle:create("left")
   
    ball = Ball:create()
end

function love.update(dt)

    if paddleRight.pressKey == "up" then
        paddleRight:move(-dt)
    elseif paddleRight.pressKey == "down" then
        paddleRight:move(dt)
    end

    if isComputerPlay then 
        if ball.location.y < paddleLeft.location or 
                ball.location.y > paddleLeft.location + paddleLeft.height then
            if paddleLeft.location > ball.location.y - paddleLeft.height / 2 then
                paddleLeft:move(-dt)
            elseif paddleLeft.location < ball.location.y - paddleLeft.height / 2 then
                paddleLeft:move(dt)
            end
        end
    else
        if paddleLeft.pressKey == "w" then
            paddleLeft:move(-dt)
        elseif paddleLeft.pressKey == "s" then
            paddleLeft:move(dt)
        end
    end
    

    local border = ball:checkBoundaries()
    if border == "RightBoundary" then
        paddleLeft.score = paddleLeft.score + 1
        if paddleLeft.score == 5 then
            gameScreen = false
            endScreen = true
            winnerScreen = "left"
        end
    elseif border == "LeftBoundary" then
        paddleRight.score = paddleRight.score + 1
        if paddleRight.score == 5 then
            gameScreen = false
            endScreen = true
            winnerScreen = "right"
        end
    end

    paddleLeft:update()
    paddleRight:update()

    if ball:checkPaddle(paddleLeft) then
        ball.direction.x = velocity
        ball.direction.y = ((ball.location.y - paddleLeft.location) /
                                 paddleLeft.height) * velocity
    elseif ball:checkPaddle(paddleRight) then
        ball.direction.x = -velocity
        ball.direction.y = ((ball.location.y - paddleRight.location) /
                                 paddleRight.height) * velocity
    end

    ball:update(dt)
end

function love.draw()
    if startScreen then
        love.graphics.print(
        "Press enter", 
        screenWidth / 2, 
        screenHeight / 2
    )
    elseif gameScreen then
        love.graphics.draw(backgroundImage, 0, 0)
        love.graphics.print(paddleLeft.score, screenWidth / 2, 10)
        love.graphics.print(paddleRight.score, screenWidth / 2 + 50, 10)
        love.graphics.print("Press = for playing against the computer ", screenWidth / 2 - 70, 35)
        paddleLeft:draw()
        paddleRight:draw()
        ball:draw()
    elseif endScreen then
        if winnerScreen == "right" then
            love.graphics.print(
                "Right player win", 
                screenWidth / 2, 
                screenHeight / 2
            )
            paddleLeft.score = 0
            paddleRight.score = 0
        elseif winnerScreen == "left" then
            love.graphics.print(
                "Left player win", 
                screenWidth / 2, 
                screenHeight / 2
            )
            paddleLeft.score = 0
            paddleRight.score = 0
        end
    end     
end

function love.keypressed(key)
    if key == "up" then
        paddleRight.pressKey = "up"
    elseif key == "down" then
        paddleRight.pressKey = "down"
    end
    if key == "w" then
        paddleLeft.pressKey = "w"
    elseif key == "s" then
        paddleLeft.pressKey = "s"
    end
    if key == "=" then
        isComputerPlay = not isComputerPlay
    end
    if startScreen or endScreen and key == "return" then
        startScreen = false
        gameScreen = true
        endScreen = false
    end
end

function love.keyreleased(key)
    if key == "w" and paddleLeft.pressKey == "w" then
        paddleLeft.pressKey = false
    elseif key == "s" and paddleLeft.pressKey == "s" then
        paddleLeft.pressKey = false
    end
    if key == "up" and paddleRight.pressKey == "up" then
        paddleRight.pressKey = false
    elseif key == "down" and paddleRight.pressKey == "down" then
        paddleRight.pressKey = false
    end
end