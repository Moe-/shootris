class "Upgrade" {
	weaponLvl = 1;
	weaponCosts = 100;
	weaponCostMultiplier = 2;
	currentWeaponCosts = 100;
	driveLvl = 1;
	driveCosts = 300;
	driveCostMultiplier = 3;
	buttonSize = 64;
	mouseOnButton1 = false;
	mouseOnButton2 = false;
	width = nil;
	height = nil;
	dtime = 0;
	level = nil;
}

function Upgrade:__init(level)
	self.width = gScreenWidth
	self.height = gScreenHeight
	self.level = level
end

function Upgrade:draw()
	--draw blocks with icons on top
	self.rectPosX1 = self.width - 96
	self.rectPosY1 = self.height - 128
	if self.level.points <= self.currentWeaponCosts then
		love.graphics.setColor(180,100,100,255)
	else
		if self.mouseOnButton1 then
			love.graphics.setColor(100,100,180,255)
		else
			love.graphics.setColor(100,230,100,255)
		end
	end
	love.graphics.rectangle("fill",self.rectPosX1,self.rectPosY1,self.buttonSize,self.buttonSize)
end

function Upgrade:update(dt)
	if self.dtime <0.01 then
		self.dtime = self.dtime + dt
	else
		local mX,mY = love.mouse.getPosition()
		mX = mX/gScaleX
		mY = mY/gScaleY
		--print(self.rectPosX1.."-"..mX.."-"..self.buttonSize)
		if self.rectPosX1<=mX and mX<=(self.rectPosX1+self.buttonSize) and self.rectPosY1<=mY and mY<=(self.rectPosY1+self.buttonSize) then
			self.mouseOnButton1 = true
		else
			self.mouseOnButton1 = false
		end
	end
	if love.mouse.isDown("l") and self.mouseOnButton1 then
		if self.level.points >= self.currentWeaponCosts then
			self.level.points = self.level.points - self.currentWeaponCosts
			self.currentWeaponCosts = self.weaponCosts*self.weaponLvl*self.weaponCostMultiplier
			self.weaponLvl = self.weaponLvl + 1
		end
	end
end

