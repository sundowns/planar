-- Draws polygonal shapes to the screen
local spawning = Concord.system()

-- maybe just use polar coordinates with set magnitude instead?
local MIN_OBSTACLE_VELOCITY = 10
local MAX_OBSTACLE_VELOCITY = 25
local SPAWN_OFFSCREEN_OFFSET = 50

function spawning:init()
  self.wave_active = false
  self.wave_timer = Timer.new()
end

function spawning:begin_wave()
  self.wave_timer:clear()
  self.wave_active = true
  self.wave_timer:every(
    3,
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
    position.x = -SPAWN_OFFSCREEN_OFFSET
    -- position y coordinate needs to be between 0 and screen height
    position.y = love.math.random(0, love.graphics.getHeight())
    -- velocity x needs to be positive
    velocity.x = love.math.random(MIN_OBSTACLE_VELOCITY, MAX_OBSTACLE_VELOCITY)
    -- velocity y can be anything
    velocity.y = love.math.random(-MAX_OBSTACLE_VELOCITY, MAX_OBSTACLE_VELOCITY)
  elseif edge == "top" then
    -- position x coordinate needs to be between 0 and screen width
    position.x = love.math.random(0, love.graphics.getWidth())
    -- position y coordinate needs to be some set value below 0 (to spawn 'offscreen')
    position.y = -SPAWN_OFFSCREEN_OFFSET
    -- velocity x can be anything
    velocity.x = love.math.random(-MAX_OBSTACLE_VELOCITY, MAX_OBSTACLE_VELOCITY)
    -- velocity y needs to be positive
    velocity.y = love.math.random(MIN_OBSTACLE_VELOCITY, MAX_OBSTACLE_VELOCITY)
  elseif edge == "right" then
    -- position x coordinate needs to be some set value above screen_width (to spawn 'offscreen')
    position.x = love.graphics.getWidth() + SPAWN_OFFSCREEN_OFFSET
    -- position y coordinate needs to be between 0 and screen height
    position.y = love.math.random(0, love.graphics.getHeight())
    -- velocity x needs to be negative
    velocity.x = love.math.random(-MIN_OBSTACLE_VELOCITY, -MAX_OBSTACLE_VELOCITY)
    -- velocity y can be anything
    velocity.y = love.math.random(-MAX_OBSTACLE_VELOCITY, MAX_OBSTACLE_VELOCITY)
  elseif edge == "bottom" then
    -- position x coordinate needs to be between 0 and screen width
    position.x = love.math.random(0, love.graphics.getWidth())
    -- position y coordinate needs to be some set value above screen_height (to spawn 'offscreen')
    position.y = love.graphics.getHeight() + SPAWN_OFFSCREEN_OFFSET
    -- velocity x can be anything
    velocity.x = love.math.random(-MAX_OBSTACLE_VELOCITY, MAX_OBSTACLE_VELOCITY)
    -- velocity y needs to be negative
    velocity.y = love.math.random(-MIN_OBSTACLE_VELOCITY, -MAX_OBSTACLE_VELOCITY)
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
