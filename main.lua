require('utils')
require('stone')
require('level')

gLevel = nil

function love.load()
    gLevel = Level:new(64, 64)
    math.randomseed( os.time() )
end

function love.draw()
    gLevel:draw()
end

function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
   end
end

function love.update(dt)
  if gLevel ~= nil then
    gLevel:update(dt)
  end
end
