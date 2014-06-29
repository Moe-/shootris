class "Credits" {
	parent = nil;
	cursor = 0;
	cursor_max = 2;
	font = nil;
	quad = nil;
	background = nil;
}

function Credits:__init(parent)
	self.parent = parent
	self.cursor = 0
	self.font = G.newFont(24)
	self.quad = G.newQuad(0, 0, gScreenWidth, gScreenHeight, 256, 256)
	self.background = G.newImage("gfx/space.png")
	self.background:setWrap("repeat", "repeat")
end

function Credits:update()
	
end

function Credits:draw()
	G.setFont(self.font)
	love.postshader.setBuffer("render")

	self.quad:setViewport(-T.getTime() * 5, -T.getTime() * 20, gScreenWidth, gScreenHeight)
	G.draw(self.background, self.quad)
	G.printf("Aldo Brießmann (Code) \nMarcus Ihde (Code) \nMarkus Vill (Code)\nMichael Klier (Sound)\nThomas Wellmann (Graphics)", gScreenWidth * 0.5 - 256, 240, 512, "center")

	love.postshader.addEffect("scanlines")
	love.postshader.addEffect("bloom")
	love.postshader.draw()
end

function Credits:keyHit(key)
	if key == "return" or key == "escape" then
		self.parent:setState(STATE_MENU)
	end
end