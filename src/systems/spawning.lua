-- Draws polygonal shapes to the screen
local spawning = Concord.system()

function spawning:init()
  self.wave_active = false
  self.wave_timer = Timer.new()

  self.spawn_rate = _constants.SPAWNER.BASE_SPAWN_RATE
  self.min_obstacle_velocity = _constants.SPAWNER.BASE_MIN_OBSTACLE_VELOCITY
  self.max_obstacle_velocity = _constants.SPAWNER.BASE_MAX_OBSTACLE_VELOCITY
end

function spawning:player_collided()
  self:disable()
end

function spawning:begin_wave()
  self.wave_timer:clear()
  self.wave_active = true
  self.wave_timer:every(
    self.spawn_rate,
    function()
      self:spawn_random_obstacle()
    end
  )
end

function spawning:spawn_random_obstacle()
  local edge = _util.g.choose("left", "top", "right", "bottom")

  local velocity = Vector(0, 0)
  local position = Vector(0, 0)
  if edge == "left" then
    -- position x coordinate needs to be some set value below 0 (to spawn 'offscreen')
    position.x = -_constants.SPAWNER.SPAWN_OFFSCREEN_OFFSET
    -- position y coordinate needs to be between 0 and screen height
    position.y = love.math.random(0, love.graphics.getHeight())
    -- velocity x needs to be positive
    velocity.x = love.math.random(self.min_obstacle_velocity, self.max_obstacle_velocity)
    -- velocity y can be anything
    velocity.y = love.math.random(-self.max_obstacle_velocity, self.max_obstacle_velocity)
  elseif edge == "top" then
    -- position x coordinate needs to be between 0 and screen width
    position.x = love.math.random(0, love.graphics.getWidth())
    -- position y coordinate needs to be some set value below 0 (to spawn 'offscreen')
    position.y = -_constants.SPAWNER.SPAWN_OFFSCREEN_OFFSET
    -- velocity x can be anything
    velocity.x = love.math.random(-self.max_obstacle_velocity, self.max_obstacle_velocity)
    -- velocity y needs to be positive
    velocity.y = love.math.random(self.min_obstacle_velocity, self.max_obstacle_velocity)
  elseif edge == "right" then
    -- position x coordinate needs to be some set value above screen_width (to spawn 'offscreen')
    position.x = love.graphics.getWidth() + _constants.SPAWNER.SPAWN_OFFSCREEN_OFFSET
    -- position y coordinate needs to be between 0 and screen height
    position.y = love.math.random(0, love.graphics.getHeight())
    -- velocity x needs to be negative
    velocity.x = love.math.random(-self.min_obstacle_velocity, -self.max_obstacle_velocity)
    -- velocity y can be anything
    velocity.y = love.math.random(-self.max_obstacle_velocity, self.max_obstacle_velocity)
  elseif edge == "bottom" then
    -- position x coordinate needs to be between 0 and screen width
    position.x = love.math.random(0, love.graphics.getWidth())
    -- position y coordinate needs to be some set value above screen_height (to spawn 'offscreen')
    position.y = love.graphics.getHeight() + _constants.SPAWNER.SPAWN_OFFSCREEN_OFFSET
    -- velocity x can be anything
    velocity.x = love.math.random(-self.max_obstacle_velocity, self.max_obstacle_velocity)
    -- velocity y needs to be negative
    velocity.y = love.math.random(-self.min_obstacle_velocity, -self.max_obstacle_velocity)
  end

  Concord.assemblages.obstacle:assemble(
    Concord.entity(Concord.worlds.game),
    position,
    velocity,
    _util.g.choose("RED", "BLUE"),
    _util.g.choose("TRIANGLE", "SQUARE"),
    love.math.random(1.25, 3.5),
    love.math.random(0, 2)
  )
end

function spawning:update(dt)
  self.wave_timer:update(dt)
end

return spawning
