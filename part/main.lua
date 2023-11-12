require('vector')
require('particle')
require('particle-system')
require('repeller')
require('rectangle')

local width, height
local repeller
local ps
local rectangles = {}

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    repeller = Repeller:create(width / 2 + 100, height / 2 + 150)
    
    rectangles = {
        Rectangle:create(Vector:create(100, 100), 20, 40),
        Rectangle:create(Vector:create(200, 350), 25, 50),
        Rectangle:create(Vector:create(450, 400), 50, 100),
        Rectangle:create(Vector:create(350, 400), 10, 25)
    }
    
    ps = ParticleSystem:create(Particle)
end

function love.draw()
    ps:draw()
    
    for _, r in pairs(rectangles) do
        r:draw()
    end
end

function love.update()
    ps:update(repeller)
end

function love.mousepressed(x, y, button, istouch, presses)
    for i, r in pairs(rectangles) do
        if r:clicked(ps, x, y) then
            table.remove(rectangles, i)
        end
    end
end


