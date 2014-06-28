STATE_MENU = 0
STATE_CREDITS = 1
STATE_GAME = 2

class "Game" {
	state = STATE_MENU;
	stateObject = {};
}

function Game:__init()
	self.stateObject[STATE_MENU] = Menu:new(self)
	self.stateObject[STATE_CREDITS] = Credits:new(self)
	self.stateObject[STATE_GAME] = Level:new(64, 64)
end

function Game:update(dt)
	if self.stateObject[self.state] and self.stateObject[self.state].update then
		self.stateObject[self.state]:update(dt)
	end
end

function Game:draw()
	if self.stateObject[self.state] and self.stateObject[self.state].draw then
		self.stateObject[self.state]:draw()
	end
end

function Game:keyHit(key)
	if self.stateObject[self.state] and self.stateObject[self.state].keyHit then
		self.stateObject[self.state]:keyHit(key)
	end
end

function Game:setState(state)
	self.state = state
end