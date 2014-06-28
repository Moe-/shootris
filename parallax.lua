class "Parallax" {
	stars = {};
	starImgs = nil;
	nextUpdate = 0;
	starAmount = 0;
}
-- in order to add a parallax, you will need "require('parallax')", a new Parallax object (e.g. "par") with the amount of stars as parameter in the constructor, "par:update(dt)" in the update function and "par:draw()" in the draw function of the file.
--As of yet, images are hard-coded in the array "starImgs"
function Parallax:__init(starAmount)
	for i = 1,starAmount do
		self.stars[i] = Parallax:resetStar(self.stars[i])
	end
	self.starImgs = {love.graphics.newImage("gfx/star.png"),love.graphics.newImage("gfx/lblock.png"),love.graphics.newImage("gfx/longblock.png"),love.graphics.newImage("gfx/tblock.png"),love.graphics.newImage("gfx/sblock.png")}
	self.starAmount = starAmount
end

function Parallax:draw()
	local oldblendmode = love.graphics.getBlendMode()
	love.graphics.setBlendMode("screen")
	for _,v in ipairs(self.stars) do
		love.graphics.draw(self.starImgs[v.graphic],v.x,v.y)
	end
	love.graphics.setBlendMode(oldblendmode)
end

function Parallax:update(dt)
	if self.nextUpdate >= 0.001 then
		for i = 1, self.starAmount do
			if self.stars[i] then
				if self.stars[i].y >=love.window.getWidth()+50 then
					self.stars[i] = Parallax:resetStar(self.stars[i])
				else
					self.stars[i] = {x = self.stars[i].x,y = self.stars[i].y+self.stars[i].speed,speed = self.stars[i].speed,graphic = self.stars[i].graphic}
				end
			end
		end
		self.nextUpdate = 0
	else
		self.nextUpdate = self.nextUpdate+dt
	end
end

function Parallax:resetStar(v)
	return {x=math.random(10,love.window.getWidth()),y=-20,speed = math.random(8,20),graphic = math.random(1,5)}
end
