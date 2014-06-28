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

function Stone:draw(offsetx, offsety)
  for y = 1, self.height do
    for x = 1, self.width do
      if self.stones[x][y] == 0 then
        love.graphics.setColor(128, 128, 0, 128)
      elseif self.stones[x][y] == 1 then
        love.graphics.setColor(128, 0, 128, 128)
      else
        love.graphics.setColor(0, 128, 128, 128)
      end
      love.graphics.rectangle("fill", offsetx + (self.posx + x - 1) * self.tileWidth, offsety + (self.posy + y - 1) * self.tileHeight, self.tileWidth, self.tileHeight)
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
