MENU_START = 0
MENU_CREDITS = 1
MENU_QUIT = 2

class "Menu" {
	parent = nil;
	cursor = 0;
	cursor_max = 2;
}

function Menu:__init(parent)
	self.parent = parent
	self.cursor = 0
end

function Menu:update()
	
end

function Menu:draw()
	if self.cursor == MENU_START then G.setColor(255, 255, 0) else G.setColor(255, 255, 255) end
	G.print("Start", 16, 16)
	if self.cursor == MENU_CREDITS then G.setColor(255, 255, 0) else G.setColor(255, 255, 255) end
	G.print("Credits", 16, 32)
	if self.cursor == MENU_QUIT then G.setColor(255, 255, 0) else G.setColor(255, 255, 255) end
	G.print("Quit", 16, 48)
end

function Menu:keyHit(key)
	if key == "up" then
		self:up()
	elseif key == "down" then
		self:down()
	elseif key == "return" then
		self:enter()
	end
end

function Menu:up()
	self.cursor = self.cursor - 1;
	if self.cursor < 0 then
		self.cursor = self.cursor_max;
	end
end

function Menu:down()
	self.cursor = self.cursor + 1;
	if self.cursor > self.cursor_max then
		self.cursor = 0;
	end
end

function Menu:enter()
	if self.cursor == MENU_START then
		self.parent:setState(STATE_MENU)
	elseif self.cursor == MENU_CREDITS then
		self.parent:setState(STATE_CREDITS)
	elseif self.cursor == MENU_QUIT then
		self.parent:setState(STATE_GAME)
	end
end