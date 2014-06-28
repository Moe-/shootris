require('utils')
require('level')
gLevel = {}

function love.load()
    gLevel = Level:new()
end

function love.draw()
    gLevel:print()
    love.graphics.print('Hello World!', 400, 300)
end