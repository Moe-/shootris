class "Stone" {
  width = 4;
  height = 4;
  moveTime = 0.25;
  fallTime = 0.5;
  nextFall = 0.5;
  nextMove = 0;
}

function Stone:__init(posx, posy, tileWidth, tileHeight, fieldWidth, fieldHeight)
  self.posx = posx
  self.posy = posy
  self.fieldWidth = fieldWidth
  self.fieldHeight = fieldHeight

  self.stones = {}
  for x = 1, self.width do
    self.stones[x] = {}
    for y = 1, self.height do
      self.stones[x][y] = math.random(0, 1)
    end
  end
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
  
  self:updateSize()
end

function Stone:draw(offsetx, offsety)
  for y = 1, self.height do
    for x = 1, self.width do
      if self.stones[x][y] == 0 then
        -- do nothing, it's empty
      elseif self.stones[x][y] == 1 then
        love.graphics.setColor(128, 0, 128, 128)
        love.graphics.rectangle("fill", offsetx + (self.posx + x - 1) * self.tileWidth, offsety + (self.posy + y - 1) * self.tileHeight, self.tileWidth, self.tileHeight)
      else
        love.graphics.setColor(0, 128, 128, 128)
        love.graphics.rectangle("fill", offsetx + (self.posx + x - 1) * self.tileWidth, offsety + (self.posy + y - 1) * self.tileHeight, self.tileWidth, self.tileHeight)
      end
    end
  end
end

function Stone:update(dt)
  if self.nextMove > 0 then
    self.nextMove = self.nextMove - dt
  end
  
  if self.nextFall > 0 then
    self.nextFall = self.nextFall - dt
  else
    self.posy = self.posy + 1
    self.nextFall = self.nextFall + self.fallTime
    return true
  end
  return false
end

function Stone:updateSizeInternal()
  local blank = true
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
  end
  
  blank = true
  for x = 1, self.width do
    if self.stones[x][self.height] > 0 then
      blank = false
    end
  end
  if blank then
    self.height = self.height - 1
  end
  
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
  end
  
  blank = true
  for y = 1, self.width do
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
  
end

function Stone:rotateLeft()
  
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
