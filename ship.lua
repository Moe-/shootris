class "Ship" {
	parent = nil;
	body = nil;
	shape = nil;
	fixture = nil;
	x = 0;
	y = 0;
	timer = 0;
	dead = false;
	boost = false;
}

function Ship:__init(parent)
	self.parent = parent
	self.x = G.getWidth() * 0.5
	self.y = G.getHeight() - 256
	self.body = love.physics.newBody(parent.world, self.x, self.y, "dynamic")
	self.body:setFixedRotation(true)
	self.shape = love.physics.newRectangleShape(64, 128)
	self.fixture = love.physics.newFixture(self.body, self.shape, 20)
	self.fixture:setRestitution(0.2)
	self.quad = G.newQuad(0, 0, 64, 128, 320, 256)
	self.img = G.newImage("gfx/ship.png")
	self.booster = G.newImage("gfx/booster.png")
	self.timer = T.getTime()
end

function Ship:update(dt)
	if self.dead then
		return
	end

	if love.keyboard.isDown("w") then
		self.body:applyForce(0, -20000)
		boost = true;
	else
		boost = false;
	end
	if love.keyboard.isDown("a") then
		self.body:applyForce(-10000, 0)
	elseif love.keyboard.isDown("d") then
		self.body:applyForce(10000, 0)
	end
	if love.keyboard.isDown(" ") then
		if self.timer + 0.2 < T.getTime() then
			self.parent.shots:add(self.x + 32, self.y)
      gSound:playSound("ship_weapon_fire", 100, self.x, self.y, 0, true)
			self.timer = T.getTime()
		end
	end

	self.x, self.y = self.body:getPosition()
end

function Ship:draw()
	G.setColor(255, 255, 255)
	local x, y = self.body:getLinearVelocity()
	local shot = 0
	if self.timer + 0.05 > T.getTime() then
		shot = 1
	end
	self.quad:setViewport((math.min(4, math.max(0, math.floor(x / 100) + 2))) * 64, shot * 128, 64, 128)
	G.draw(self.img, self.quad, self.x, self.y - 32)
	if boost then
		G.draw(self.booster, self.x, self.y + 88)
	end
end

function Ship:getPosition()
	return self.x, self.y
end

function Ship:getVelocity()
	return self.body:getLinearVelocity()
end

function Ship:getVelocityLength()
	local x, y = self:getVelocity()
	return math.sqrt(x*x + y*y)
end

function Ship:kill()
  self.dead = true
end
