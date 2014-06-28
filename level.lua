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
      if self.level[x][y] == 1 then
        love.graphics.setColor(255, 0, 0, 255)
      else
        love.graphics.setColor(0, 255, 0, 255)
      end
      love.graphics.rectangle("fill", drawx, drawy, self.tileWidth, self.tileHeight)
    end
  end
  
  if self.stone ~= nil then
    self.stone:draw()
  end
end

function Level:update(dt)
  if self.stone == nil then
    self.stone = Stone:new(love.graphics.getWidth()/2, self.tileHeight, self.tileWidth, self.tileHeight)
  end
  
  if self.stone ~= nil then
    self.stone:update(dt)
  end
end
