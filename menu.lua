MENU_START = 0
MENU_CREDITS = 1
MENU_QUIT = 2

class "Menu" {
	parent = nil;
	cursor = 0;
	cursor_max = 2;
	font = nil;
	color_normal = {0, 127, 255, 31};
	color_hover = {255, 127, 0, 255};
	quad = nil;
	background = nil;
}

function Menu:__init(parent)
	self.parent = parent
	self.cursor = 0
	self.font = G.newFont(36)
	self.quad = G.newQuad(0, 0, W.getWidth(), W.getHeight(), 256, 256)
	self.background = G.newImage("gfx/space.png")
	self.background:setWrap("repeat", "repeat")
end

function Menu:update()
	
end

function Menu:draw()
	G.setFont(self.font)
	love.postshader.setBuffer("render")

	self.quad:setViewport(-T.getTime() * 5, -T.getTime() * 20, W.getWidth(), W.getHeight())
	G.draw(self.background, self.quad)
	--MENU START
	self:setColor(MENU_START)
	G.rectangle("fill", W.getWidth() * 0.5 - 128, 240 + 0, 256, 42)
	G.setColor(0, 0, 0)
	G.printf("Start", W.getWidth() * 0.5 - 128, 240 + 0, 256, "center")

	--MENU CREDITS
	self:setColor(MENU_CREDITS)
	G.rectangle("fill", W.getWidth() * 0.5 - 128, 240 + 48, 256, 42)
	G.setColor(0, 0, 0)
	G.printf("Credits", W.getWidth() * 0.5 - 128, 240 + 48, 256, "center")

	--MENU QUIT
	self:setColor(MENU_QUIT)
	G.rectangle("fill", W.getWidth() * 0.5 - 128, 240 + 96, 256, 42)
	G.setColor(0, 0, 0)
	G.printf("Quit", W.getWidth() * 0.5 - 128, 240 + 96, 256, "center")

	--love.postshader.addEffect("chromatic", 0, 0, 0, 1, -1, 0)
	love.postshader.addEffect("scanlines")
	love.postshader.addEffect("bloom")
	love.postshader.draw()
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
		self.parent:setState(STATE_GAME)
	elseif self.cursor == MENU_CREDITS then
		self.parent:setState(STATE_CREDITS)
	elseif self.cursor == MENU_QUIT then
		love.event.quit()
	end
end

function Menu:setColor(position)
	if self.cursor == position then
		G.setColor(self.color_hover[1], self.color_hover[2], self.color_hover[3], self.color_hover[4])
	else
		G.setColor(self.color_normal[1], self.color_normal[2], self.color_normal[3], self.color_normal[4])
	end
end