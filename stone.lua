class "Stone" {
  parent = nil;
  maxSize = 4;
  moveTime = 0.25;
  fallTime = 0.5;
  nextFall = 0.5;
  nextMove = 0;
  quickFall = false;
  shipHitPerSec = 0.667;
  shotHit = 0.2;
  physics = {};
}

function Stone:__init(parent, posx, posy, tileWidth, tileHeight, fieldWidth, fieldHeight)
  self.parent = parent
  self.posx = posx
  self.posy = posy
  self.width = self.maxSize
  self.height = self.maxSize
  self.fieldWidth = fieldWidth
  self.fieldHeight = fieldHeight
  self.quad = G.newQuad(0, 0, tileWidth, tileHeight, 192, 192)
  self.img = G.newImage("gfx/blocks.png")
  self.batch = G.newSpriteBatch(self.img, self.width * self.height)
  self.batch:setColor(255, 255, 255, 0)

  self.batch:bind()
  self.stones = {}
  for x = 1, self.width do
    self.stones[x] = {}
    for y = 1, self.height do
      self.stones[x][y] = math.random(0, 1)
	  self.batch:add(self.quad, 0, 0)
    end
  end
  self.batch:unbind()

  local stonetype = math.random(1,7)
  if stonetype == 1 then --T
    self.stones[2][2] = 2
    self.stones[3][1] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
  elseif stonetype == 2 then --inverse L
    self.stones[2][3] = 2
    self.stones[3][1] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
  elseif stonetype == 3 then --L
    self.stones[2][1] = 2
    self.stones[3][1] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
  elseif stonetype == 4 then--I
    self.stones[3][1] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
    self.stones[3][4] = 2
  elseif stonetype == 5 then--o
    self.stones[2][2] = 2
    self.stones[2][3] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
  elseif stonetype == 6 then--inverse z
    self.stones[2][3] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
    self.stones[4][2] = 2
  elseif stonetype == 7 then--z
    self.stones[2][2] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
    self.stones[4][3] = 2
  end
  self.tileWidth = tileWidth
  self.tileHeight = tileHeight
  
  for y = 1, self.height do
    for x = 1, self.width do
	  if self.stones[x][y] == 0 then
      self.parent.move_physics[x][y].body:setActive(false)
	  else
	    self.parent.move_physics[x][y].body:setActive(true)
	  end
    end
  end

  self:updateSize()
end

function Stone:draw(offsetx, offsety)
  self.batch:bind()
  for y = 1, self.height do
    for x = 1, self.width do
      self.parent.move_physics[x][y].body:setPosition(offsetx + (self.posx + x - 1) * self.tileWidth, offsety + (self.posy + y - 1) * self.tileHeight)
	  if self.stones[x][y] == 0 then
        -- do nothing, it's empty
		self.batch:setColor(255, 255, 255, 0)
      elseif math.ceil(self.stones[x][y]) == 1 then
        love.graphics.setColor(128, 0, 128, 128)
        love.graphics.rectangle("fill", offsetx + (self.posx + x - 1) * self.tileWidth, offsety + (self.posy + y - 1) * self.tileHeight, self.tileWidth, self.tileHeight)
        self.batch:setColor(255, 255, 255, 255)
	  elseif math.ceil(self.stones[x][y]) == 2 then
        love.graphics.setColor(0, 128, 128, 128)
        love.graphics.rectangle("fill", offsetx + (self.posx + x - 1) * self.tileWidth, offsety + (self.posy + y - 1) * self.tileHeight, self.tileWidth, self.tileHeight)
        self.batch:setColor(255, 255, 255, 255)
	  end

	  self.batch:set(y * self.width + x, self.quad, offsetx + (self.posx + x - 1) * self.tileWidth, offsety + (self.posy + y - 1) * self.tileHeight)
    end
  end
  self.batch:unbind()
end

function Stone:update(dt)
  if self.nextMove > 0 then
    self.nextMove = self.nextMove - dt
  end
  
  --self:shoot(3, 3)
  --self:sitOnStone(2,2,dt)
  
  if self.nextFall > 0 and not self.quickFall then
    self.nextFall = self.nextFall - dt
  else
    self.posy = self.posy + 1
    self.nextFall = self.nextFall + self.fallTime
    return true
  end
  return false
end

function Stone:isDead()
  if self.width == 0 or self.height == 0 then
    return true
  end
  return false
end

function Stone:updateSizeInternal()
  local blank = true
  
  if self.width == 0 or self.height == 0 then return end
  for x = 1, self.width do
    if self.stones[x][1] > 0 then
      blank = false
    end
  end
  if blank then
    for y = 2, self.height do
      for x = 1, self.width do
        self.stones[x][y-1] = self.stones[x][y]
      end
    end
    self.height = self.height - 1
    self.posy = self.posy + 1
  end
  
  if self.width == 0 or self.height == 0 then return end
  blank = true
  for x = 1, self.width do
    if self.stones[x][self.height] > 0 then
      blank = false
    end
  end
  if blank then
    self.height = self.height - 1
  end
  
  if self.width == 0 or self.height == 0 then return end
  blank = true
  for y = 1, self.height do
    if self.stones[1][y] > 0 then
      blank = false
    end
  end
  if blank then
    for y = 1, self.height do
      for x = 2, self.width do
        self.stones[x-1][y] = self.stones[x][y]
      end
    end
    self.width = self.width - 1
    self.posx = self.posx + 1
  end
  
  if self.width == 0 or self.height == 0 then return end
  blank = true
  for y = 1, self.height do
    if self.stones[self.width][y] > 0 then
      blank = false
    end
  end
  if blank then
    self.width = self.width - 1
  end
end

function Stone:updateSize()
  local repeatCount = math.max(self.width, self.height)
  for i = 1, repeatCount do
    self:updateSizeInternal()
  end
end

function Stone:fallDown()
  self.quickFall = true
end

function Stone:moveLeft()
  if self.nextMove <= 0 and self.posx - 1 >= 0 then
    self.posx = self.posx - 1
    self.nextMove = self.moveTime
  end
end

function Stone:moveRight()
  if self.nextMove <= 0 and self.posx + self.width < self.fieldWidth then
    self.posx = self.posx + 1
    self.nextMove = self.moveTime
  end
end

function Stone:rotateRight()
  if self.nextMove <= 0 then
    local newStones = {}
    for x = 1, self.height do
      newStones[x] = {}
      for y = 1, self.width do
        newStones[x][y] = 0
      end
    end
    
    for y = 1, self.height do
      for x = 1, self.width do
        newStones[self.height - y + 1][x] = self.stones[x][y]
      end
    end
    
    local temp = self.width
    self.width = self.height
    self.height = temp
    self.stones = newStones
    
    self.nextMove = self.moveTime
  end
end

function Stone:rotateLeft()
  if self.nextMove <= 0 then
    local newStones = {}
    for x = 1, self.height do
      newStones[x] = {}
      for y = 1, self.width do
        newStones[x][y] = 0
      end
    end
    
    for y = 1, self.height do
      for x = 1, self.width do
        newStones[y][self.width - x + 1] = self.stones[x][y]
      end
    end
    
    local temp = self.width
    self.width = self.height
    self.height = temp
    self.stones = newStones
    
    self.nextMove = self.moveTime
  end
end

function Stone:getWidth()
  return self.width
end

function Stone:getHeight()
  return self.height
end

function Stone:getBlock(x, y)
  return self.stones[x][y]
end

function Stone:getPosition()
  return self.posx, self.posy
end

function Stone:sitOnStone(x, y, dt)
  if x < 1 or x > self.width then
    return
  end
  
  if y < 1 or y > self.height then
    return
  end
  
  if self.stones[x][y] == 0 then
    return
  end

  local hit = dt * self.shipHitPerSec
  if math.ceil(self.stones[x][y]) ~= math.ceil(self.stones[x][y] - hit) then
    self.stones[x][y] = 0
    self.parent.move_physics[x][y].body:setActive(false)
    self:updateSize()
  else
    self.stones[x][y] = self.stones[x][y] - hit
  end
end

function Stone:shoot(x, y)
  if x < 1 or x > self.width then
    return false
  end
  
  if y < 1 or y > self.height then
    return false
  end
  
  if self.stones[x][y] == 0 then
    return false
  end

  local factor = 1
  if math.ceil(self.stones[x][y]) == 2 then
    factor = 0.075
  end
  local hit = factor * self.shotHit
  
  if math.ceil(self.stones[x][y]) ~= math.ceil(self.stones[x][y] - hit) then
    self.stones[x][y] = 0
    self.parent.move_physics[x][y].body:setActive(false)
    self:updateSize()
  else
    self.stones[x][y] = self.stones[x][y] - hit
  end
  return true
end
