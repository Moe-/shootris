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
	self.shape = love.physics.newRectangleShape(32, 32)
	self.fixture = love.physics.newFixture(self.body, self.shape, 20)
	self.fixture:setRestitution(0.2)
end

function Ship:update(dt)
	if love.keyboard.isDown("w") then
		self.body:applyForce(0, -2000)
	end
	if love.keyboard.isDown("a") then
		self.body:applyForce(-500, 0)
	elseif love.keyboard.isDown("d") then
		self.body:applyForce(500, 0)
	end
	if love.keyboard.isDown(" ") then
		self.parent.shots:add(self.x + 32, self.y + 32)
	end

	self.x, self.y = self.body:getPosition()
end

function Ship:draw()
	G.setColor(255, 255, 255)
	G.rectangle("fill", self.x + 16, self.y + 16, 32, 32)
end