class "Shots" {
	parent = nil;
	shots = {};
	timer = 0;
}

function Shots:__init(parent)
	self.parent = parent
	self.timer = T.getTime()
end

function Shots:update(dt)
	for n = 1, #self.shots do
		self.shots[n].y = self.shots[n].y - dt * 1000
	end
end

function Shots:draw()
	for n = 1, #self.shots do
		G.setColor(0, 127, 255)
		G.rectangle("fill", self.shots[n].x, self.shots[n].y, 8, 8)
	end
end

function Shots:add(x, y)
	if self.timer + 0.2 < T.getTime() then
		self.shots[#self.shots + 1] = {}
		self.shots[#self.shots].x = x
		self.shots[#self.shots].y = y
		self.timer = T.getTime()
	end
end