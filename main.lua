require('utils')
require('stone')
require('game')
require('menu')
require('credits')
require('level')
require('sound')

function love.load()
	G = love.graphics
  
  math.randomseed(os.time())
	game = Game:new()
end

function love.update(dt)
	game:update(dt)
end

function love.draw()
	game:draw()
end

function love.keypressed(key, unicode)
  if key == "escape" then
      love.event.quit()
  end
	game:keyHit(key)
end