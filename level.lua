class "Level" {
  width = 10;
  height = 17;
  world = nil;
  ship = nil;
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
      if self.level[x][y] == 1 then
        love.graphics.setColor(255, 0, 0, 255)
      else
        love.graphics.setColor(0, 255, 0, 255)
      end
      love.graphics.rectangle("fill", drawx, drawy, self.tileWidth, self.tileHeight)
    end
  end
  
  if self.stone ~= nil then
    self.stone:draw(offsetx, offsety)
  end

  self.ship:draw()
end

function Level:update(dt)
  self.world:update(dt)

  if self.stone == nil then
    self.stone = Stone:new(self.width/2 - 1, 1, self.tileWidth, self.tileHeight, self.width, self.height)
  end
  
  if self.stone ~= nil then
    self.stone:update(dt)
  end

  self.ship:update(dt)
end

function Level:keyHit(key)
  if self.stone ~= nil then
    if key == "down" then
      self.stone:fallDown()
    elseif key == "left" then
      self.stone:moveLeft() 
    elseif key == "right" then
      self.stone:moveRight()
    elseif key == "l" then
      self.stone:rotateRight()
    elseif key == "k" then
      self.stone:rotateLeft()
	elseif key == "escape" then
	  love.event.quit()
    end
  end
end
