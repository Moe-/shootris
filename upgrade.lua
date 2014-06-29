class "Upgrade" {
	weaponLvl = 1;
	weaponCosts = 100;
	weaponCostMultiplier = 2;
	currentWeaponCosts = 100;
	driveLvl = 1;
	driveCosts = 300;
	driveCostMultiplier = 3;
	currentDriveCosts = 300;
	buttonSize = 64;
	mouseOnButton1 = false;
	mouseOnButton2 = false;
	width = nil;
	height = nil;
	dtime = 0;
	parent = nil;
	rectPosX1 = 0;
	rectPosY1 = 0;
	rectPosX2 = 0;
	rectPosY2 = 0;
}

function Upgrade:__init(level)
	self.width = gScreenWidth
	self.height = gScreenHeight
	self.parent = level
	self.rectPosX1 = self.width - 96
	self.rectPosY1 = self.height - 128
	self.rectPosX2 = self.width - 192
	self.rectPosY2 = self.height - 128
end

function Upgrade:draw()
	--draw blocks with icons on top
	-- button1
	if self.parent.points <= self.currentWeaponCosts then
		love.graphics.setColor(180,100,100,255)
	else
		if self.mouseOnButton1 then
			love.graphics.setColor(100,100,180,255)
		else
			love.graphics.setColor(100,230,100,255)
		end
	end
	love.graphics.rectangle("fill",self.rectPosX1,self.rectPosY1,self.buttonSize,self.buttonSize)
	-- button2
		if self.parent.points <= self.currentDriveCosts then
		love.graphics.setColor(180,100,100,255)
	else
		if self.mouseOnButton2 then
			love.graphics.setColor(100,100,180,255)
		else
			love.graphics.setColor(100,230,100,255)
		end
	end
	love.graphics.rectangle("fill",self.rectPosX2,self.rectPosY2,self.buttonSize,self.buttonSize)
end

function Upgrade:update(dt)
	if self.dtime <0.01 then
		self.dtime = self.dtime + dt
	else
		local mX,mY = love.mouse.getPosition()
		mX = mX/gScaleX
		mY = mY/gScaleY
		--print(self.rectPosX1.."-"..mX.."-"..self.buttonSize)
		-- button1
		if self.rectPosX1<=mX and mX<=(self.rectPosX1+self.buttonSize) and self.rectPosY1<=mY and mY<=(self.rectPosY1+self.buttonSize) then
			self.mouseOnButton1 = true
		else
			self.mouseOnButton1 = false
		end
		-- button 2
		if self.rectPosX2<=mX and mX<=(self.rectPosX2+self.buttonSize) and self.rectPosY2<=mY and mY<=(self.rectPosY2+self.buttonSize) then
			self.mouseOnButton2 = true
		else
			self.mouseOnButton2 = false
		end
		-- check if mouse is clicked
		if love.mouse.isDown("l") then
			if self.mouseOnButton1 and self.parent.points >= self.currentWeaponCosts then
				self.parent.points = self.parent.points - self.currentWeaponCosts
				self.currentWeaponCosts = self.weaponCosts*self.weaponLvl*self.weaponCostMultiplier
				self.weaponLvl = self.weaponLvl + 1
				self.parent.ship.hitStrength = 0.2+0.1*self.weaponLvl
			end
			if self.mouseOnButton2 and self.parent.points >= self.currentDriveCosts then
				self.parent.points = self.parent.points - self.currentDriveCosts
				self.currentDriveCosts = self.driveCosts*self.driveLvl*self.driveCostMultiplier
				self.driveLvl = self.driveLvl + 1
				self.parent.ship.movementSpeed = 20000+0.2*self.driveLvl*750
			end
		end
	end
end

