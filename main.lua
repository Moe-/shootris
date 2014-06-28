require('lib/postshader')

require('utils')
require('game')
require('menu')
require('credits')
require('level')
require('sound')

function love.load()
	G = love.graphics
	W = love.window
	T = love.timer

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