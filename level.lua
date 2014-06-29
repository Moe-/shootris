require('particle')

class "Level" {
  width = 10;
  height = 17;
  shipHitPerSec = 0.667;
  shotHit = 0.2;
  particles = {};
  rowParticles = {};
  particleSystemCount = 15;
  rowParticleSystemCount = 20;
  points = 0;
  par = nil;
}

function Level:__init(tileWidth, tileHeight)
  self.tileWidth = tileWidth
  self.tileHeight = tileHeight
  for i = 1, self.particleSystemCount do
    self.particles[i] = Particle:new(50, 50, 255, 255, 255, 0.5)
  end
  for i = 1, self.rowParticleSystemCount do
    self.rowParticles[i] = Particle:new(50, 50, 255, 255, 128, 1.5)
  end
  self:reset()
  self:setup()
  self.par = Parallax:new(10)
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
  for i = 1, self.rowParticleSystemCount do
    self.rowParticles[i]:reset()
    self.rowParticles[i]:stop()
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
  self.bg = G.newImage("gfx/lvl_bg.png")
	self.quad = G.newQuad(0, 0, gScreenWidth, gScreenHeight, 256, 256)
	self.plx = G.newImage("gfx/space.png")
	self.plx:setWrap("repeat", "repeat")

  for x = 1, self.width + 1 do
    self.level[x] = {}
    for y = 1, self.height do
      self.level[x][y] = 0 --math.random(0, 1)
    end
  end
 
  -- moving block
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
  self.batch = G.newSpriteBatch(self.img, (self.width + 1) * (self.height))
  self.batch:setColor(255, 255, 255, 0)

  self.batch:bind()
  for x = 1, self.width do
    for y = 1, self.height do
	  self.batch:add(self.quad, (x - 1) * self.tileWidth + gScreenWidth * 0.5 - self.width * 0.5 * self.tileWidth, (y - 1) * self.tileHeight)
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
			self.physics[x][y].body = love.physics.newBody(self.world, gScreenWidth * 0.5 - self.width * 0.5 * self.tileWidth + (x - 1) * self.tileWidth, (y - 1) * self.tileHeight, "static")
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
	self.wall[1].body = love.physics.newBody(self.world, 328, gScreenHeight * 0.5, "static")
	self.wall[1].shape = love.physics.newRectangleShape(16, gScreenHeight)
	self.wall[1].fixture = love.physics.newFixture(self.wall[1].body, self.wall[1].shape, 1)

	--Add right wall
	self.wall[2] = {}
	self.wall[2].body = love.physics.newBody(self.world, gScreenWidth - 392, gScreenHeight * 0.5, "static")
	self.wall[2].shape = love.physics.newRectangleShape(16, gScreenHeight)
	self.wall[2].fixture = love.physics.newFixture(self.wall[2].body, self.wall[2].shape, 1)

	--Add bottom wall
	self.wall[3] = {}
	self.wall[3].body = love.physics.newBody(self.world, gScreenWidth * 0.5, gScreenHeight, "static")
	self.wall[3].shape = love.physics.newRectangleShape(gScreenWidth, 16)
	self.wall[3].fixture = love.physics.newFixture(self.wall[3].body, self.wall[3].shape, 1)

	--Add top wall
	self.wall[4] = {}
	self.wall[4].body = love.physics.newBody(self.world, gScreenWidth * 0.5, -16, "static")
	self.wall[4].shape = love.physics.newRectangleShape(gScreenWidth, 16)
	self.wall[4].fixture = love.physics.newFixture(self.wall[4].body, self.wall[4].shape, 1)
end

function Level:draw()
  local width = gScreenWidth
  local height = gScreenHeight
  local offsetx = width / 2 - self.width/2 * self.tileWidth
  local offsety = height - self.height * self.tileHeight
	self.quad:setViewport(-T.getTime() * 5, -T.getTime() * 20, gScreenWidth, gScreenHeight)
	G.draw(self.plx, self.quad)
	self.par:draw()
	G.draw(self.bg, offsetx, offsety)
  self.batch:bind()
  for y = 1, self.height do
    for x = 1, self.width do
      local drawx = offsetx + (x-1) * self.tileWidth
      local drawy = offsety + (y-1) * self.tileHeight
      if self.level[x][y] == 0 then
        --love.graphics.setColor(0, 255, 0, 255)
      elseif math.ceil(self.level[x][y]) == 1 then
        --love.graphics.setColor(255, 0, 0, 255)
		--love.graphics.rectangle("fill", drawx, drawy, self.tileWidth, self.tileHeight)
      elseif math.ceil(self.level[x][y]) >= 2 then
        --love.graphics.setColor(0, 0, 255, 255)
		--love.graphics.rectangle("fill", drawx, drawy, self.tileWidth, self.tileHeight)
      end

		--update physics
		if self.level[x][y] == 0 then
			self.physics[x][y].body:setActive(false)
			self.batch:setColor(255, 255, 255, 0)
		else
			local stone_id = math.ceil(self.level[x][y])
			self.physics[x][y].body:setActive(true)
			self.batch:setColor(255, 255, 255, 255 * (self.level[x][y] - math.ceil(self.level[x][y]) + 1))
			self.quad:setViewport(((stone_id - 1) % 3) * self.tileWidth, math.floor((stone_id - 1) / 3) * self.tileHeight, self.tileWidth, self.tileHeight)
		end

		--update graphics
		self.batch:set((x-1) * self.height + (y-1), self.quad, (x - 1) * self.tileWidth + gScreenWidth * 0.5 - self.width * 0.5 * self.tileWidth, (y - 1) * self.tileHeight - 8)
  
    end
  end
  self.batch:unbind()
  
  if self.stone ~= nil then
    self.stone:draw(offsetx, offsety)
  end
  G.setColor(255, 255, 255)
  G.draw(self.batch)

  self.ship:draw()
  self.shots:draw()
  
  if self.gameLost then
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print("The block player sucks.", 64, 256)
  end
  
  if self.shipLost then
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.print("The ship player sucks.", 64, 288)
  end
  
  if self.gameLost or self.shipLost then
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.print("Press enter to restart.", 64, 320)
  end
  
  love.graphics.setColor(255, 0, 255, 255)
  love.graphics.print("Points: " .. self.points, 10, 500)
  love.graphics.print("Level: " .. math.floor(1 + self.points / 10000), 10, 600)
  
  for i = 1, self.particleSystemCount do
    self.particles[i]:draw()
  end
  for i = 1, self.rowParticleSystemCount do
    self.rowParticles[i]:draw()
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
  local count = 0
  for y = 1, self.height do
    local rowComplete = true
    for x = 1, self.width do
      if math.ceil(self.level[x][y]) == 0 then
        rowComplete = false
      end
    end
    if rowComplete then
      count = count + 1
      for y2 = y, 2, -1 do
        for x = 1, self.width do
          self.level[x][y2] = self.level[x][y2 - 1]
        end
      end
      for x = 1, self.width do
        self.level[x][1] = 0
        if (x + y) % 4 == 0 then
          for i = 1, self.rowParticleSystemCount do
            if not self.rowParticles[i]:isActive() then
              local offsetx = gScreenWidth / 2 - self.width/2 * self.tileWidth
              self.rowParticles[i]:setPosition(x * self.tileWidth + offsetx, (y - 0.5) * self.tileHeight)
              self.rowParticles[i]:reset()
              break
            end
          end
        end
      end
    end
  end
  if count == 1 then
    gSound:playSound("row_clear_1", 100, gScreenWidth/2, gScreenHeight, 0)
    self.points = self.points + 500
  elseif count == 2 then
    gSound:playSound("row_clear_2", 100, gScreenWidth/2, gScreenHeight, 0)
    self.points = self.points + 1250
  elseif count == 3 then
    gSound:playSound("row_clear_3", 100, gScreenWidth/2, gScreenHeight, 0)
    self.points = self.points + 1850
  elseif count == 4 then
    gSound:playSound("row_clear_4", 100, gScreenWidth/2, gScreenHeight, 0)
    self.points = self.points + 3000
  end
end

function Level:update(dt)
  self.world:update(dt)
  for i = 1, self.particleSystemCount do
    self.particles[i]:update(dt)
  end
  for i = 1, self.rowParticleSystemCount do
    self.rowParticles[i]:update(dt)
  end

  if self.stone == nil then
    local factor = 1 + self.points / 10000
    self.stone = Stone:new(self, self.width/2 - 2, 0, self.tileWidth, self.tileHeight, self.width, self.height, 1.0 * factor, 7.5 * factor)
    if not self:checkNotBlocked() then
      self.gameLost = true
    else
      gSound:playSound("cube_appear", 100, gScreenWidth/2, 0, 0)
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
    
    local posx = math.floor((px - gScreenWidth/2) / self.tileWidth + self.width/2) + 1
    local posy = math.floor(py / self.tileHeight)
    
    local shotHit = self:shoot(posx, posy)
    
    local bindStone = false
    if not shotHit and self.stone ~= nil then
      local stonex, stoney = self.stone:getPosition()
      shotHit = shotHit or self.stone:shoot(posx - stonex, posy - stoney)
      bindStone = true
    end
    
    if shotHit then
      self.points = self.points + 50
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
      
      local sound = math.random(1, 15)
      if sound == 1 then
        gSound:playSound("cube_hit_a2", 100, gScreenWidth/2, gScreenHeight, 0)
      elseif sound == 2 then
        gSound:playSound("cube_hit_a3", 100, gScreenWidth/2, gScreenHeight, 0)
      elseif sound == 3 then
        gSound:playSound("cube_hit_c3", 100, gScreenWidth/2, gScreenHeight, 0)
      elseif sound == 4 then
        gSound:playSound("cube_hit_c4", 100, gScreenWidth/2, gScreenHeight, 0)
      elseif sound == 5 then
        gSound:playSound("cube_hit_d2", 100, gScreenWidth/2, gScreenHeight, 0)
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
    posx = math.floor((posx - gScreenWidth/2) / self.tileWidth + self.width/2 + 0.5) + 1
    posy = math.ceil(posy / self.tileHeight) + 1
    
    if velocity == 0 and self.lastVelocity == 0 then
      self:sitOnStone(posx, posy + 1, dt)
      if self.stone ~= nil then
        local stonex, stoney = self.stone:getPosition()
        self.stone:sitOnStone(posx - stonex, posy - stoney + 1, dt)
      end
    end
    self.lastVelocity = velocity
    
    if posx > 0 and posx < self.width then
      if (posy > self.height or self.level[posx][posy] > 0) and self.level[posx][posy - 1] > 0 then
        self.shipLost = true
        self.ship:kill()
      end
    end
  end

  self.par:update(dt)
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
    elseif (key == "l" or key == "up") and self:checkNotBlocked() then
      self.stone:rotateRight()
    elseif key == "k" and self:checkNotBlocked() then
      self.stone:rotateLeft()
    elseif key == "escape" then
      game:setState(STATE_MENU)
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
    gSound:playSound("cube_hit_d4", 100, gScreenWidth/2, gScreenHeight, 0)
    self.points = self.points + 100
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
  if math.ceil(self.level[x][y]) >= 2 then
    factor = 0.075
  end
  local hit = factor * self.shotHit
  if math.ceil(self.level[x][y]) ~= math.ceil(self.level[x][y] - hit) then
    self.level[x][y] = 0
    gSound:playSound("cube_hit_d3", 100, gScreenWidth/2, gScreenHeight, 0)
    self.points = self.points + 200
  else
    self.level[x][y] = self.level[x][y] - hit
  end
  return true
end
