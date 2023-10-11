Ball = {}
Ball.__index = Ball

function Ball:create()
    local ball = {}
    setmetatable(ball, Ball)
    ballImage = love.graphics.newImage("img/ball.png")
    ball.size = ballImage:getHeight()
    ball.location = { x = screenWidth / 2, y = screenHeight / 2 }
    ball.direction = {x = velocity, y = 0}

    return ball
end

function Ball:draw()
    love.graphics.draw(ballImage, self.location.x, self.location.y)
end

function Ball:checkBoundaries()
    if self.location.x >= screenWidth-marginSide then
        self.location = { x = screenWidth / 2, y = screenHeight / 2 }
        self.direction.y = 0
        self.direction.x = -velocity
        return "RightBoundary"
    elseif self.location.x <= marginSide then
        self.location = { x = screenWidth / 2, y = screenHeight / 2 }
        self.direction.y = 0
        self.direction.x = velocity
        return "LeftBoundary"
    elseif self.location.y <=  marginUpDown then
        self.direction.y = math.abs(self.direction.y)
        return "UpperBoundary"
    elseif self.location.y >= screenHeight - marginUpDown - self.size then
        self.direction.y = -math.abs(self.direction.y)
        return "LowerBoundary"
    end
    
end

function Ball:update(dt)
    self.location.x = self.location.x + self.direction.x * dt
    self.location.y = self.location.y + self.direction.y * dt
end

function Ball:checkPaddle(paddle)
    if self.location.y <= paddle.y + paddle.height and self.location.y + self.size >= paddle.y and
        self.location.x <= paddle.x + paddle.width  and self.location.x + self.size >= paddle.x 
    then
        return true
    end

end
