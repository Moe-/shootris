class "Ship" {
	parent = nil;
	body = nil;
	shape = nil;
	fixture = nil;
	x = 32;
	y = 32;
}

function Ship:__init(parent)
	self.parent = parent
	self.body = love.physics.newBody(parent.world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(32, 32)
	self.fixture = love.physics.newFixture(self.body, self.shape, 20)
	self.fixture:setRestitution(0.2)
end

function Ship:update(dt)
	if love.keyboard.isDown("up") then
		self.body:applyForce(0, -5000)
	end
	if love.keyboard.isDown("left") then
		self.body:applyForce(-2000, 0)
	elseif love.keyboard.isDown("right") then
		self.body:applyForce(2000, 0)
	end
print(self.body:getPosition())
	self.x, self.y = self.body:getPosition()
end

function Ship:draw()
	G.setColor(255, 255, 255)
	G.rectangle("fill", self.x, self.y, 32, 32)
end