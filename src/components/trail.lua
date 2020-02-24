local MAX_PARTICLES = 100
local PARTICLE_SIZE = 8
local PARTICLE_SCALE = 1.5
local trail =
  Concord.component(
  function(e, spritesheet, quads)
    e.system = love.graphics.newParticleSystem(spritesheet, MAX_PARTICLES)
    e.system:setInsertMode("bottom")
    e.system:setQuads(quads)
    e.system:stop()
    e.system:setEmissionRate(50)
    e.system:setSizes(PARTICLE_SCALE)
    e.system:setParticleLifetime(0.5, 1.5)
  end
)

function trail:start()
  self.system:start()
end

function trail:stop()
  self.system:stop()
end

function trail:draw(position)
  love.graphics.draw(self.system, 0, 0, 0, 1, 1)
end

-- offset from where the particle system is being drawn
function trail:update(dt, origin, offset_direction)
  local half_particle_width = (PARTICLE_SIZE * PARTICLE_SCALE) / 2
  local min_speed, max_speed = 40, 50
  local offset = offset_direction * 8
  self.system:setPosition(origin.x - half_particle_width + offset.x, origin.y + half_particle_width + offset.y)
  self.system:setLinearAcceleration(
    offset_direction.x * min_speed,
    offset_direction.y * min_speed,
    offset_direction.x * max_speed,
    offset_direction.y * max_speed
  )
  self.system:update(dt)
end

return trail
