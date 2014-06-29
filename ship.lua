class "Ship" {
	parent = nil;
	body = nil;
	shape = nil;
	fixture = nil;
	x = 0;
	y = 0;
}

function Ship:__init(parent)
	self.parent = parent
	self.x = G.getWidth() * 0.5
	self.y = G.getHeight() - 256
	self.body = love.physics.newBody(parent.world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(64, 128)
	self.fixture = love.physics.newFixture(self.body, self.shape, 20)
	self.fixture:setRestitution(0.2)
	self.quad = G.newQuad(0, 0, 64, 128, 320, 256)
	self.img = G.newImage("gfx/ship.png")
end

function Ship:update(dt)
	if love.keyboard.isDown("w") then
		self.body:applyForce(0, -20000)
	end
	if love.keyboard.isDown("a") then
		self.body:applyForce(-10000, 0)
	elseif love.keyboard.isDown("d") then
		self.body:applyForce(10000, 0)
	end
	if love.keyboard.isDown(" ") then
		self.parent.shots:add(self.x + 32, self.y + 32)
	end

	self.x, self.y = self.body:getPosition()
end

function Ship:draw()
	G.setColor(255, 255, 255)
	G.draw(self.img, self.quad, self.x + 16, self.y + 16)
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
