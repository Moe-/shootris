class "Stone" {
  width = 4;
  height = 4;
}

function Stone:__init(posx, posy, tileWidth, tileHeight)
  self.posx = posx
  self.posy = posy
  self.stones = {}
  for x = 1, self.width do
    self.stones[x] = {}
    for y = 1, self.height do
      self.stones[x][y] = math.random(0, 1)
    end
  end
  local stonetype = math.random(1,7)
  if stonetype == 1 then
    self.stones[2][2] = 2
    self.stones[3][1] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
  elseif stonetype == 2 then
    self.stones[2][3] = 2
    self.stones[3][1] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
  elseif stonetype == 3 then
    self.stones[2][1] = 2
    self.stones[3][1] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
  elseif stonetype == 4 then
    self.stones[3][1] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
    self.stones[3][4] = 2
  elseif stonetype == 5 then
    self.stones[2][2] = 2
    self.stones[2][3] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
  elseif stonetype == 6 then
    self.stones[2][3] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
    self.stones[4][2] = 2
  elseif stonetype == 7 then
    self.stones[2][2] = 2
    self.stones[3][2] = 2
    self.stones[3][3] = 2
    self.stones[4][3] = 2
  end
  self.tileWidth = tileWidth
  self.tileHeight = tileHeight
end

function Stone:draw()
  for y = 1, self.height do
    for x = 1, self.width do
      if self.stones[x][y] == 0 then
        love.graphics.setColor(128, 128, 0, 128)
      elseif self.stones[x][y] == 1 then
        love.graphics.setColor(128, 0, 128, 128)
      else
        love.graphics.setColor(0, 128, 128, 128)
      end
      love.graphics.rectangle("fill", self.posx + (x - 1) * self.tileWidth, self.posy + (y - 1) * self.tileHeight, self.tileWidth, self.tileHeight)
    end
  end
end

function Stone:update()
  
end