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

gScreenWidth = 1920
gScreenHeight = 1080

function love.load()
	G = love.graphics
	W = love.window
	T = love.timer
	math.randomseed(os.time())
  gSound = Sound:new()
  gSound:playMusic("music_main", 100)
	game = Game:new()
  
  gScaleX = love.graphics.getWidth() / gScreenWidth
  gScaleY = love.graphics.getHeight() / gScreenHeight
end

function love.update(dt)
	game:update(dt)
end

function love.draw()
love.postshader.setBuffer("render")
  love.graphics.push()
  love.graphics.scale(gScaleX, gScaleY)
	game:draw()
  love.graphics.pop()
	love.postshader.addEffect("chromatic", 0, 0, 0, 1, -1, 0)
	love.postshader.addEffect("scanlines")
	love.postshader.addEffect("bloom")
	love.postshader.draw()
end

function love.keypressed(key, unicode)
	game:keyHit(key)
end