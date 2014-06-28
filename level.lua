class "Level" {
  width = 10;
  height = 17;
  world = nil;
  ship = nil;
  shots = nil;
  wall = {};
}

function Level:__init(tileWidth, tileHeight)
  self.level = {}
  self.stone = nil
  for x = 1, self.width do
    self.level[x] = {}
    for y = 1, self.height do
      self.level[x][y] = 0 --math.random(0, 1)
    end
  end
  self.tileWidth = tileWidth
  self.tileHeight = tileHeight
  love.physics.setMeter(64)
  self.world = love.physics.newWorld(0, 9.81 * 64, true)
  self.ship = Ship:new(self)
  self.shots = Shots:new(self)

	--Add block physics
	self.physics = {}
	for x = 1, self.width do
		self.physics[x] = {}
		for y = 1, self.height do
			self.physics[x][y] = {}
			self.physics[x][y].body = love.physics.newBody(self.world, W.getWidth() * 0.5 - self.width * 0.5 * self.tileWidth + (x - 1) * self.tileWidth, (y - 1) * self.tileHeight, "static")
			self.physics[x][y].shape = love.physics.newRectangleShape(self.tileWidth, self.tileHeight)
			self.physics[x][y].fixture = love.physics.newFixture(self.physics[x][y].body, self.physics[x][y].shape, 1)
			self.physics[x][y].body:setActive(false)
		end
	end

	--Add left wall
	self.wall[1] = {}
	self.wall[1].body = love.physics.newBody(self.world, 0, W.getHeight() * 0.5, "static")
	self.wall[1].shape = love.physics.newRectangleShape(16, W.getHeight())
	self.wall[1].fixture = love.physics.newFixture(self.wall[1].body, self.wall[1].shape, 1)

	--Add right wall
	self.wall[2] = {}
	self.wall[2].body = love.physics.newBody(self.world, W.getWidth(), W.getHeight() * 0.5, "static")
	self.wall[2].shape = love.physics.newRectangleShape(16, W.getHeight())
	self.wall[2].fixture = love.physics.newFixture(self.wall[2].body, self.wall[2].shape, 1)

	--Add bottom wall
	self.wall[3] = {}
	self.wall[3].body = love.physics.newBody(self.world, W.getWidth() * 0.5, W.getHeight(), "static")
	self.wall[3].shape = love.physics.newRectangleShape(W.getWidth(), 16)
	self.wall[3].fixture = love.physics.newFixture(self.wall[3].body, self.wall[3].shape, 1)
end

function Level:draw()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  local offsetx = width / 2 - self.width/2 * self.tileWidth
  local offsety = 0
  for y = 1, self.height do
    for x = 1, self.width do
      local drawx = offsetx + (x-1) * self.tileWidth
      local drawy = offsety + (y-1) * self.tileHeight
      if self.level[x][y] == 0 then
        love.graphics.setColor(0, 255, 0, 255)
      elseif self.level[x][y] == 1 then
        love.graphics.setColor(255, 0, 0, 255)
      else
        love.graphics.setColor(0, 0, 255, 255)
      end
      love.graphics.rectangle("fill", drawx, drawy, self.tileWidth, self.tileHeight)
    end
  end
  
  if self.stone ~= nil then
    self.stone:draw(offsetx, offsety)
  end

  self.ship:draw()
  self.shots:draw()
end

function Level:checkStoneCollision(offsetx, offsety)
  local posx, posy = self.stone:getPosition()
  for x = 1, self.stone:getWidth() do
    for y = 1, self.stone:getHeight() do
      if self.stone:getBlock(x, y) > 0 and self.level[posx + x + offsetx][posy + y + offsety] > 0 then
        return true
      end
    end
  end
  return false
end

function Level:checkRowComplete()
  for y = 1, self.height do
    local rowComplete = true
    for x = 1, self.width do
      if self.level[x][y] == 0 then
        rowComplete = false
      end
    end
    if rowComplete then
      for y2 = y, 2, -1 do
        for x = 1, self.width do
          self.level[x][y2] = self.level[x][y2 - 1]
        end
      end
      for x = 1, self.width do
        self.level[x][1] = 0
      end
    end
  end
end

function Level:update(dt)
  self.world:update(dt)

  if self.stone == nil then
    self.stone = Stone:new(self.width/2 - 1, 1, self.tileWidth, self.tileHeight, self.width, self.height)
  end

  if self.stone ~= nil then
    if self.stone:update(dt) then -- check collision
      local collision = false
      local posx, posy = self.stone:getPosition()
      if posy + self.stone:getHeight() > self.height then
        collision = true
      else
        collision = self:checkStoneCollision(0,0)
      end

      if collision then
        for x = 1, self.stone:getWidth() do
          for y = 1, self.stone:getHeight() do
            if self.stone:getBlock(x, y) > 0 and self.level[posx + x][posy + y - 1] == 0 then
              self.level[posx + x][posy + y - 1] = self.stone:getBlock(x, y)
				if self.level[posx + x][posy + y - 1] == 0 then
					self.physics[posx + x][posy + y - 1].body:setActive(false)
				else
					self.physics[posx + x][posy + y - 1].body:setActive(true)
				end
            end
          end
        end
        self.stone = nil
        self:checkRowComplete()
      end
    end
  end

  self.ship:update(dt)
  self.shots:update(dt)
end

function Level:checkNotBlocked()
  local size = math.max(self.stone:getWidth(), self.stone:getHeight())
  local posx, posy = self.stone:getPosition()
  for x = 1, size do
    for y = 1, size do
      if self.level[posx + x][posy + y] > 0 then
        return false
      end
    end
  end
  return true
end

function Level:keyHit(key)
  if self.stone ~= nil then
    local posx, posy = self.stone:getPosition()
    if key == "down" then
      self.stone:fallDown()
    elseif posx - 1 >= 0 and key == "left" and not self:checkStoneCollision(-1,0) then
      self.stone:moveLeft() 
    elseif posx + 1 + self.stone:getWidth() <= self.width and key == "right" and not self:checkStoneCollision(1,0) then
      self.stone:moveRight()
    elseif key == "l" and self:checkNotBlocked() then
      self.stone:rotateRight()
    elseif key == "k" and self:checkNotBlocked() then
      self.stone:rotateLeft()
	elseif key == "escape" then
	  love.event.quit()
    end
  end
end
