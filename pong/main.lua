require "Paddle"
require "Ball"

function love.load()
    
    backgroundImage = love.graphics.newImage("img/stsena_dlya_igry.png")
    startImage = love.graphics.newImage("img/startImage.png")
    buttonStart = love.graphics.newImage("img/startPlay.png")
    buttonStartScreenExit = love.graphics.newImage("img/exit.png")
    pongImage = love.graphics.newImage("img/Pong.png")
    backgroundEnd = love.graphics.newImage("img/backEnd.png")
    buttonImage = love.graphics.newImage("img/button.png")
    buttonExit = love.graphics.newImage("img/buttonExit.png")
    buttonAgain = love.graphics.newImage("img/buttonAgain.png")

    local fontSize = 30
    font = love.graphics.newFont(fontSize)
    love.graphics.setFont(font)

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
    print(dt)
    if isComputerPlay then 
        if ball.location.y < paddleLeft.location or 
                ball.location.y > paddleLeft.location + paddleLeft.height then
            local randomDelta = love.math.random() * 0.2 - 0.1        
            if paddleLeft.location > ball.location.y - paddleLeft.height / 2 then
                paddleLeft:move(-dt+randomDelta)
            elseif paddleLeft.location < ball.location.y - paddleLeft.height / 2 then
                paddleLeft:move(dt+randomDelta)
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
        if paddleLeft.score == 3 then
            gameScreen = false
            endScreen = true
            winnerScreen = "left"
        end
    elseif border == "LeftBoundary" then
        paddleRight.score = paddleRight.score + 1
        if paddleRight.score == 3 then
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
        -- Background start image
        scaleStartImageX =  screenWidth  / startImage:getWidth()
        scaleStartImageY =  screenHeight /  startImage:getHeight()
        love.graphics.draw(startImage, 0, 0,0,scaleStartImageX,scaleStartImageY)

        -- Pong Img
        local marginPongImage = 100
        pongImageWidth = pongImage:getWidth()
        pongImageHeight = pongImage:getHeight()
        love.graphics.draw(pongImage, (screenWidth- pongImageWidth)/2 , marginPongImage)

        -- Start Game
        buttonStartY = marginPongImage + pongImageHeight + 150
        buttonStartHeight = buttonStart:getHeight()
        buttonStartX = (screenWidth- buttonStart:getWidth())/2
        love.graphics.draw(buttonStart, buttonStartX , buttonStartY)

        -- Exit
        buttonStartScreenExitY = buttonStartY + buttonStartHeight + 50
        buttonStartScreenExitX = (screenWidth- buttonStartScreenExit:getWidth())/2
        love.graphics.draw(buttonStartScreenExit, (screenWidth- buttonStartScreenExit:getWidth())/2 , buttonStartScreenExitY)

    elseif gameScreen then
        velocity = 450
        scaleBackgroundImageX =  screenWidth  / backgroundImage:getWidth()
        scaleBackgroundImageY =  screenHeight /  backgroundImage:getHeight()
       
        love.graphics.draw(backgroundImage, 0, 0,0,scaleBackgroundImageX,scaleBackgroundImageY)
        love.graphics.print(paddleLeft.score, screenWidth / 2, 10)
        love.graphics.print(paddleRight.score, screenWidth / 2 + 50, 10)
        local computerText = "Press = for playing against the computer"
        
        love.graphics.print(computerText, (screenWidth - font:getWidth(computerText))/2, screenHeight - font:getHeight(computerText))

        paddleLeft:draw()
        paddleRight:draw()
        ball:draw()
    elseif endScreen then
        velocity = 0
        love.graphics.draw(backgroundImage, 0, 0,0,scaleBackgroundImageX,scaleBackgroundImageY)
        paddleLeft:startPosition()
        paddleRight:startPosition()
        paddleLeft:draw()
        paddleRight:draw()
        backgroundEndX = (screenWidth - backgroundEnd:getWidth()) / 2
        backgroundEndY = (screenHeight - backgroundEnd:getHeight()) / 2
        love.graphics.draw(backgroundEnd, backgroundEndX, backgroundEndY)
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


        buttonExitX = ((screenWidth - buttonExit:getWidth()) / 2)*1.25
        buttonExitY = backgroundEndY*2.25

        buttonAgainX = ((screenWidth - buttonAgain:getWidth()) / 2)*0.75
        buttonAgainY = backgroundEndY*2.25
        love.graphics.draw(buttonExit, buttonExitX, buttonExitY)
        love.graphics.draw(buttonAgain,buttonAgainX , buttonAgainY)
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

function love.mousepressed(x, y, button, istouch, presses)
    -- Проверяем, был ли клик внутри кнопки Start
    if startScreen and x >= buttonStartX and x <= buttonStartX + buttonStart:getWidth() and
       y >= buttonStartY and y <= buttonStartY + buttonStartHeight then
        startScreen = false
        gameScreen = true
        endScreen = false
    end

    if startScreen and  x >= buttonStartScreenExitX and x <= buttonStartScreenExitX + buttonStartScreenExit:getWidth() and
    y >= buttonStartScreenExitY and y <= buttonStartScreenExitY + buttonStartScreenExit:getHeight() then
        love.event.quit()
    end

    if endScreen and x >= buttonAgainX and x <= buttonAgainX + buttonAgain:getWidth() and
    y >= buttonAgainY and y <= buttonAgainY + buttonAgain:getHeight()  then
        startScreen = false
        gameScreen = true
        endScreen = false
        paddleLeft.score = 0
        paddleRight.score = 0
    end

    if endScreen and x >= buttonExitX and x <= buttonExitX + buttonExit:getWidth() and
    y >= buttonExitY and y <= buttonExitY + buttonExit:getHeight()  then
        love.event.quit()
    end

    


 
end