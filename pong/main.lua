require "Paddle"
require "Ball"

function love.load()
    
    backgroundImage = love.graphics.newImage("img/stsena_dlya_igry.png")
    startImage = love.graphics.newImage("img/startImage.png")
    buttonStart = love.graphics.newImage("img/startPlay.png")
    buttonExit = love.graphics.newImage("img/exit.png")
    pongImage = love.graphics.newImage("img/Pong.png")
    backgroundEnd = love.graphics.newImage("img/backEnd.png")
    buttonImage = love.graphics.newImage("img/button.png")


    screenWidth, screenHeight = love.window.getDesktopDimensions()

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
        if paddleLeft.score == 1 then
            gameScreen = false
            endScreen = true
            winnerScreen = "left"
        end
    elseif border == "LeftBoundary" then
        paddleRight.score = paddleRight.score + 1
        if paddleRight.score == 1 then
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
        love.graphics.draw(backgroundImage, 0, 0)
        paddleLeft:startPosition()
        paddleRight:startPosition()
        paddleLeft:draw()
        paddleRight:draw()
        backgroundEndX = (screenWidth - backgroundEnd:getWidth()) / 2
        backgroundEndY = (screenHeight - backgroundEnd:getHeight()) / 2
        love.graphics.draw(backgroundEnd, backgroundEndX, backgroundEndY)
        local fontSize = 40
        local font = love.graphics.newFont(fontSize)
        love.graphics.setFont(font)
        local textScore = "Score"
        local textPlayer = "Player 1"
        local textPlayer2 = "Player 2"
        local textWidthScore = font:getWidth(textScore)
        local textWidthPlayer = font:getWidth(textPlayer)
        local textHeight = font:getHeight()
        love.graphics.print(textScore, (screenWidth - textWidthScore) / 2, backgroundEndY*1.1)
        love.graphics.print(textPlayer, ((screenWidth - textWidthPlayer) / 2)*0.75, backgroundEndY*1.2)
        love.graphics.print(textPlayer2, ((screenWidth - textWidthPlayer) / 2)*1.25, backgroundEndY*1.2)

        local textWidthScoreLeft = font:getWidth(paddleLeft.score)
        local textWidthScoreRight = font:getWidth(paddleRight.score)

        love.graphics.print(paddleLeft.score, ((screenWidth - textWidthScoreLeft) / 2)*1.25, backgroundEndY*1.5)
        love.graphics.print(paddleRight.score, ((screenWidth - textWidthScoreRight) / 2)*0.75, backgroundEndY*1.5)


        local buttonRightWidth = ((screenWidth - buttonImage:getWidth()) / 2)*1.25
        local buttonRightHeight = backgroundEndY*1.9
        love.graphics.draw(buttonImage, buttonRightWidth, buttonRightHeight)
        love.graphics.draw(buttonImage, ((screenWidth - buttonImage:getWidth()) / 2)*0.75, backgroundEndY*1.9)

        local textExit = "Exit"
        local textWidthScore = font:getWidth(textExit)
        love.graphics.print(textExit, buttonRightWidth + (buttonImage:getWidth() - textWidthScore) / 2, buttonRightHeight + (buttonImage:getHeight() - textHeight) / 2)

        -- if winnerScreen == "right" then
        --     love.graphics.print(
        --         "Right player win", 
        --         screenWidth / 2, 
        --         screenHeight / 2
        --     )
        --     paddleLeft.score = 0
        --     paddleRight.score = 0
        -- elseif winnerScreen == "left" then
        --     love.graphics.print(
        --         "Left player win", 
        --         screenWidth / 2, 
        --         screenHeight / 2
        --     )
        --     paddleLeft.score = 0
        --     paddleRight.score = 0
        -- end
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