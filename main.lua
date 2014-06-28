require('utils')
require('game')
require('menu')
require('credits')
require('level')

function love.load()
	G = love.graphics

	game = Game:new()
end

function love.update(dt)
	game:update()
end

function love.draw()
	game:draw()
end

function love.keypressed(key, unicode)
	game:keyHit(key)
end