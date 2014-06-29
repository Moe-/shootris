class "Particle" {
  p = nil;
  active = true;
  lifetime = 0;
  maxLifetime = 0.5;
}

function Particle:__init(x, y, r, g, b, lifetime)
  self.posx = x
  self.posy = y
  self.maxLifetime = lifetime
  local id = love.image.newImageData(32, 32)
  for x = 0, 31 do
    for y = 0, 31 do
      local gradient = 1 - ((x-15)^2+(y-15)^2)/40
      id:setPixel(x, y, r, g, b, 255*(gradient<0 and 0 or gradient))
    end
  end
  
  local i = love.graphics.newImage(id)
  
  self.p = love.graphics.newParticleSystem(i, 256)
  self.p:setEmissionRate          (20)
  self.p:setParticleLifetime      (4)
  self.p:setPosition              (0, 0)
  if lifetime < 1.0 then
    self.p:setDirection             (1.7)
  else
    self.p:setDirection             (4.8)
  end
  self.p:setSpread                (2)
  self.p:setSpeed                 (10, 30)
  self.p:setRadialAcceleration    (10)
  self.p:setTangentialAcceleration(0)
  self.p:setSizes                 (1)
  self.p:setSizeVariation         (0.5)
  self.p:setRotation              (0)
  self.p:setSpin                  (0)
  self.p:setSpinVariation         (0)
  self.p:setColors                (200, 200, 255, 240, 255, 255, 255, 10)
  self.p:stop();
end

function Particle:update(dt)
  if self.active then
    self.p:start()
    self.p:update(dt)
    self.lifetime = self.lifetime + dt
    if self.lifetime > self.maxLifetime then
      self.active = false
    end
  end
end

function Particle:draw()
  if self.active then
    love.graphics.draw(self.p, self.posx, self.posy)
  end
end

function Particle:setPosition(x, y)
  self.posx = x
  self.posy = y
end

function Particle:translate(x, y)
  self.posx = self.posx + x
  self.posy = self.posy + y
end

function Particle:stop()
  self.p:stop()
  self.active = false
end

function Particle:reset()
  self.p:reset()
  self.active = true
  self.lifetime = 0
end

function Particle:start()
  self.active = true
end

function Particle:isActive()
  return self.active
end