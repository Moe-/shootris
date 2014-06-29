require('lib/postshader')

require('utils')
require('stone')
require('ship')
require('shots')
require('game')
require('menu')
require('credits')
require('level')
require('sound')

function love.load()
	G = love.graphics
	W = love.window
	T = love.timer
	math.randomseed(os.time())
  gSound = Sound:new()
  gSound:playMusic("music_main", 100)

	game = Game:new()
end

function love.update(dt)
	game:update(dt)
end

function love.draw()
	game:draw()
end

function love.keypressed(key, unicode)
	game:keyHit(key)
end