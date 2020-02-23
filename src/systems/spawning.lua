-- Draws polygonal shapes to the screen
local spawning = Concord.system()

function spawning:init()
  self.current_phase = nil
  self.wave_active = false
  self.time_elapsed = 0
  self.wave_timer = Timer.new()

  self.spawn_interval = _constants.SPAWNER.INITIAL_SPAWN_INTERVAL
  self.min_obstacle_velocity = _constants.SPAWNER.BASE_MIN_OBSTACLE_VELOCITY
  self.max_obstacle_velocity = _constants.SPAWNER.BASE_MAX_OBSTACLE_VELOCITY

  self.minimum_spawn_interval = 0.1
end

function spawning:player_collided()
  self:disable()
end

function spawning:phase_update(new_phase)
  self.current_phase = new_phase
end

function spawning:begin_wave()
  self.wave_timer:clear()
  self.wave_active = true
  self.spawning_fn =
    self.wave_timer:every(
    self.spawn_interval,
    function()
      self:spawn_random_obstacle()
    end
  )

  self.increase_rate_fn =
    self.wave_timer:every(
    4,
    function()
      self:increase_spawn_rate()
    end
  )
end

function spawning:increase_spawn_rate()
  self.spawn_interval = math.max((1 / math.log(2 * self.time_elapsed)) - 0.1, self.minimum_spawn_interval)
  if self.spawn_interval == self.minimum_spawn_interval then
    self.wave_timer:cancel(self.increase_rate_fn)
  end

  self.wave_timer:cancel(self.spawning_fn)
  self.spawning_fn =
    self.wave_timer:every(
    self.spawn_interval,
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

  local obstacle_phase = nil
  if self.current_phase == "RED" then
    obstacle_phase =
      _util.g.choose_weighted(
      {"RED", _constants.SPAWNER.CHANCE_TO_SPAWN_CURRENT_PHASE_OBSTACLE},
      {"BLUE", 100 - _constants.SPAWNER.CHANCE_TO_SPAWN_CURRENT_PHASE_OBSTACLE}
    )
  else
    obstacle_phase =
      _util.g.choose_weighted(
      {"RED", 100 - _constants.SPAWNER.CHANCE_TO_SPAWN_CURRENT_PHASE_OBSTACLE},
      {"BLUE", _constants.SPAWNER.CHANCE_TO_SPAWN_CURRENT_PHASE_OBSTACLE}
    )
  end

  Concord.assemblages.obstacle:assemble(
    Concord.entity(Concord.worlds.game),
    position,
    velocity,
    obstacle_phase,
    _util.g.choose("TRIANGLE", "SQUARE", "PENTAGON"),
    love.math.random(1.25, 3.5),
    love.math.random(0, 2)
  )
end

function spawning:update(dt)
  self.wave_timer:update(dt)
  self.time_elapsed = self.time_elapsed + dt
end

return spawning
