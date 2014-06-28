class "Level" {
  width = 10;
  height = 17;
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
            end
          end
        end
        self.stone = nil
        self:checkRowComplete()
      end
    end
  end
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
      self.stone:rotateRight(false)
    elseif key == "k" and self:checkNotBlocked() then
      self.stone:rotateLeft(false)
    end
  end
end
