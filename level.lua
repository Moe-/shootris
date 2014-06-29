require('particle')

class "Level" {
  width = 10;
  height = 17;
  shipHitPerSec = 0.667;
  shotHit = 0.2;
  particles = {};
  particleSystemCount = 15;
}

function Level:__init(tileWidth, tileHeight)
  self.tileWidth = tileWidth
  self.tileHeight = tileHeight
  for i = 1, self.particleSystemCount do
    self.particles[i] = Particle:new(50,50)
  end
  self:reset()
  self:setup()
  
end

function Level:reset()
  self.world = nil
  self.ship = nil
  self.shots = nil
  self.wall = {}
  self.lastVelocity = 0
  self.gameLost = false
  self.shipLost = false
  for i = 1, self.particleSystemCount do
    self.particles[i]:reset()
    self.particles[i]:stop()
  end
end

function Level:setup()
  self.level = {}
  self.stone = nil

  --stone blocks
  self.stone_quad = G.newQuad(0, 0, self.tileWidth, self.tileHeight, 192, 192)
  self.stone_img = G.newImage("gfx/blocks.png")
  self.stone_batch = G.newSpriteBatch(self.stone_img, 16)
  self.stone_batch:setColor(255, 255, 255, 0)

  self.stone_batch:bind()
  for x = 1, self.width do
    for y = 1, self.height do
	  self.stone_batch:add(self.stone_quad, 0, 0)
    end
  end
  self.stone_batch:unbind()

  -- level blocks
  self.quad = G.newQuad(0, 0, self.tileWidth, self.tileHeight, 192, 192)
  self.img = G.newImage("gfx/blocks.png")
  self.batch = G.newSpriteBatch(self.img, 171)
  self.batch:setColor(255, 255, 255, 0)

  self.batch:bind()
  for x = 1, self.width do
    self.level[x] = {}
    for y = 1, self.height do
      self.level[x][y] = 0 --math.random(0, 1)
	  self.batch:add(self.quad, (x - 1) * self.tileWidth + G.getWidth() * 0.5 - self.width * 0.5 * self.tileWidth, (y - 1) * self.tileHeight)
    end
  end
  self.batch:unbind()

  
  love.physics.setMeter(128)
  self.world = love.physics.newWorld(0, 9.81 * 128, true)
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

	--Add movable block physics
	self.move_physics = {}
	for x = 1, self.width do
		self.move_physics[x] = {}
		for y = 1, self.height do
			self.move_physics[x][y] = {}
			self.move_physics[x][y].body = love.physics.newBody(self.world, 0, 0, "static")
			self.move_physics[x][y].shape = love.physics.newRectangleShape(self.tileWidth, self.tileHeight)
			self.move_physics[x][y].fixture = love.physics.newFixture(self.move_physics[x][y].body, self.move_physics[x][y].shape, 1)
			self.move_physics[x][y].body:setActive(false)
		end
	end

	--Add left wall
	self.wall[1] = {}
	self.wall[1].body = love.physics.newBody(self.world, 328, W.getHeight() * 0.5, "static")
	self.wall[1].shape = love.physics.newRectangleShape(16, W.getHeight())
	self.wall[1].fixture = love.physics.newFixture(self.wall[1].body, self.wall[1].shape, 1)

	--Add right wall
	self.wall[2] = {}
	self.wall[2].body = love.physics.newBody(self.world, W.getWidth() - 392, W.getHeight() * 0.5, "static")
	self.wall[2].shape = love.physics.newRectangleShape(16, W.getHeight())
	self.wall[2].fixture = love.physics.newFixture(self.wall[2].body, self.wall[2].shape, 1)

	--Add bottom wall
	self.wall[3] = {}
	self.wall[3].body = love.physics.newBody(self.world, W.getWidth() * 0.5, W.getHeight(), "static")
	self.wall[3].shape = love.physics.newRectangleShape(W.getWidth(), 16)
	self.wall[3].fixture = love.physics.newFixture(self.wall[3].body, self.wall[3].shape, 1)

	--Add top wall
	self.wall[4] = {}
	self.wall[4].body = love.physics.newBody(self.world, W.getWidth() * 0.5, -16, "static")
	self.wall[4].shape = love.physics.newRectangleShape(W.getWidth(), 16)
	self.wall[4].fixture = love.physics.newFixture(self.wall[4].body, self.wall[4].shape, 1)
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
      elseif math.ceil(self.level[x][y]) == 1 then
        love.graphics.setColor(255, 0, 0, 255)
      elseif math.ceil(self.level[x][y]) == 2 then
        love.graphics.setColor(0, 0, 255, 255)
      end
      love.graphics.rectangle("fill", drawx, drawy, self.tileWidth, self.tileHeight)
    end
  end
  
  if self.stone ~= nil then
    self.stone:draw(offsetx, offsety)
  end
  G.setColor(255, 255, 255)
  G.draw(self.batch)

  self.ship:draw()
  self.shots:draw()
  
  if self.gameLost then
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print("The block player sucks.", 10, 200)
  end
  
  if self.shipLost then
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.print("The ship player sucks.", 10, 300)
  end
  
  if self.gameLost or self.shipLost then
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.print("Press enter to restart.", 10, 400)
  end
  
  for i = 1, self.particleSystemCount do
    self.particles[i]:draw()
  end
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
  for i = 1, self.particleSystemCount do
    self.particles[i]:update(dt)
  end

  if self.stone == nil then
    self.stone = Stone:new(self, self.width/2 - 2, 0, self.tileWidth, self.tileHeight, self.width, self.height)
    if not self:checkNotBlocked() then
      self.gameLost = true
    end
  end

  self.batch:bind()
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
            end

			--update physics
			if self.level[posx + x][posy + y - 1] == 0 then
				self.physics[posx + x][posy + y - 1].body:setActive(false)
				self.batch:setColor(255, 255, 255, 0)
			else
				self.physics[posx + x][posy + y - 1].body:setActive(true)
				self.batch:setColor(255, 255, 255, 255)
			end

			--update graphics
			self.batch:set((posx + x - 1) * self.height + (posy + y - 1), self.quad, (posx + x - 1) * self.tileWidth + G.getWidth() * 0.5 - self.width * 0.5 * self.tileWidth, (posy + y - 2) * self.tileHeight)
          end
        end
        self.stone = nil
        self:checkRowComplete()
      end
    end
  end
  self.batch:unbind()

  self.ship:update(dt)
  self.shots:update(dt)
  
  for i = 1, self.shots:getSize() do
    local px, py = self.shots:getShotCoords(i)
    
    local posx = math.floor((px - love.graphics.getWidth()/2) / self.tileWidth + self.width/2) + 1
    local posy = math.floor(py / self.tileHeight)
    
    local shotHit = self:shoot(posx, posy)
    
    local bindStone = false
    if not shotHit and self.stone ~= nil then
      local stonex, stoney = self.stone:getPosition()
      shotHit = shotHit or self.stone:shoot(posx - stonex, posy - stoney)
      bindStone = true
    end
    
    if shotHit then
      for i = 1, self.particleSystemCount do
        if not self.particles[i]:isActive() then
          self.particles[i]:setPosition(px, posy * self.tileHeight)
          self.particles[i]:reset()
          if bindStone then
            self.stone:setParticle(self.particles[i])
          end
          break
        end
    end
      
      self.shots:removeShot(i)
    end
  end
  
  if self.stone ~= nil and self.stone:isDead() then
    self.stone = nil
  end

  if self.ship ~= nil then
    local velocity = self.ship:getVelocityLength()
    local posx, posy = self.ship:getPosition()
    posx = math.floor((posx - love.graphics.getWidth()/2) / self.tileWidth + self.width/2 + 0.5) + 1
    posy = math.ceil(posy / self.tileHeight) + 1
    
    if velocity == 0 and self.lastVelocity == 0 then
      self:sitOnStone(posx, posy, dt)
      if self.stone ~= nil then
        local stonex, stoney = self.stone:getPosition()
        self.stone:sitOnStone(posx - stonex, posy - stoney, dt)
      end
    end
    self.lastVelocity = velocity
    
    if posx > 0 and posx < self.width then
      if (posy > self.height or self.level[posx][posy] > 0) and self.level[posx][posy - 1] > 0 then
        self.shipLost = true
      end
    end
  end
  --self:sitOnStone(3, 15, dt)
  --self:shoot(3, 15)
end

function Level:checkNotBlocked()
  local size = math.max(self.stone:getWidth(), self.stone:getHeight())
  local posx, posy = self.stone:getPosition()
  
  if posx + size > self.width or posy + size > self.height then
    return false
  end
  
  
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
    elseif key == "return" and (self.gameLost == true or self.shipLost == true) then
        self:reset()
        self:setup()
    end
  end
end

function Level:sitOnStone(x, y, dt)
  if x < 1 or x > self.width then
    return
  end
  
  if y < 1 or y > self.height then
    return
  end

  if self.level[x][y] == 0 then
    return
  end

  local hit = dt * self.shipHitPerSec
  if math.ceil(self.level[x][y]) ~= math.ceil(self.level[x][y] - hit) then
    self.level[x][y] = 0
    self.physics[x][y].body:setActive(false)
	self.batch:setColor(255, 255, 255, 0)
	self.batch:set(x * self.height + y)
  else
    self.level[x][y] = self.level[x][y] - hit
  end
end

function Level:shoot(x, y)
  if x < 1 or x > self.width then
    return false
  end
  
  if y < 1 or y > self.height then
    return false
  end

  if self.level[x][y] == 0 then
    return false
  end

  local factor = 1
  if math.ceil(self.level[x][y]) == 2 then
    factor = 0.075
  end
  local hit = factor * self.shotHit
  if math.ceil(self.level[x][y]) ~= math.ceil(self.level[x][y] - hit) then
    self.level[x][y] = 0
	self.physics[x][y].body:setActive(false)

	--update graphics
	self.batch:setColor(255, 255, 255, 0)
	self.batch:set(x * self.height + y, self.quad, (x) * self.tileWidth + G.getWidth() * 0.5 - self.width * 0.5 * self.tileWidth, (y - 1) * self.tileHeight)
  else
    self.level[x][y] = self.level[x][y] - hit
  end
  return true
end
