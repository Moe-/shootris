class "Shots" {
	parent = nil;
	shots = {};
  toRemove = {};
}

function Shots:__init(parent)
	self.parent = parent
	self.img = G.newImage("gfx/shot.png")
end

function Shots:update(dt)
  if #self.toRemove > 0 and #self.shots > 0 then
    for i = 1, #self.toRemove do
      table.remove(self.shots, self.toRemove[i])
    end
    self.toRemove = {}
  end

	for n = 1, #self.shots do
		self.shots[n].y = self.shots[n].y - dt * 1000
	end
end

function Shots:draw()
	for n = 1, #self.shots do
		G.setColor(255, 255, 255)
		G.draw(self.img, self.shots[n].x - 16, self.shots[n].y - 16)
	end
end

function Shots:add(x, y)
	self.shots[#self.shots + 1] = {}
	self.shots[#self.shots].x = x
	self.shots[#self.shots].y = y
end

function Shots:getSize()
	return #self.shots
end

function Shots:getShotCoords(number)
	if number < 1 or number > #self.shots then
		return -1, -1
	end
	return self.shots[number].x, self.shots[number].y
end

function Shots:removeShot(pos)
	self.toRemove[#self.toRemove + 1] = pos
end