class "Credits" {
	parent = nil;
	cursor = 0;
	cursor_max = 2;
}

function Credits:__init(parent)
	self.parent = parent
	self.cursor = 0
end

function Credits:update()
	
end

function Credits:draw()
	G.print("Credits", 16, 16)
end

function Credits:keyHit(key)
	if key == "return" or key == "escape" then
		self:enter()
	end
end