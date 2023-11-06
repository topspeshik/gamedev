Paddle = {}
Paddle.__index = Paddle

function Paddle:create(side)
    local paddle = {}
    setmetatable(paddle, Paddle)
    paddleImageLeft = love.graphics.newImage("img/paddleLeft.png")
    paddleImageRight = love.graphics.newImage("img/paddleRight.png")
    if side == "left" then
        paddle.height = paddleImageLeft:getHeight()
        paddle.width = paddleImageLeft:getWidth()
    elseif side == "right" then
        paddle.height = paddleImageRight:getHeight()
        paddle.width = paddleImageRight:getWidth()
    end

    
    paddle.location = screenHeight / 2 - paddle.height / 2
    paddle.score = 0
    paddle.side = side
    

    return paddle
end

function Paddle:update()
    self.y = self.location
    if self.side == "left" then
        self.x = marginSide
    elseif self.side == "right" then
        self.x = screenWidth - self.width - marginSide
    end

end

function Paddle:move(dt)
    dist = dt * velocity
    if not ((self.location >= screenHeight - self.height - marginSide and dist > 0) 
            or (self.location <= 0 + marginSide) and dist < 0 ) then
        self.location = self.location + dist

    end
end

function Paddle:draw()
    if self.side == "left" then
        love.graphics.draw(paddleImageLeft, self.x, self.y)
    elseif self.side == "right" then
        love.graphics.draw(paddleImageRight, self.x, self.y)
    end
end

function Paddle:startPosition()
    self.location = screenHeight / 2 - self.height / 2
end