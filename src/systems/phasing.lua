local phasing = Concord.system({_components.phase})

function phasing:init()
  self.phases = {"RED", "BLUE"}
  self.current_phase_index = 1
  self.ripple_radius = 0
  self.ripple_origin = Vector(0, 0)
  self.ripple_transparency = 0
  self.canPhase = true
  self.timer = Timer.new()
  self.sfx = love.audio.newSource("resources/audio/phaseshift2.wav", "static")

  self.pool.onEntityAdded = function(pool, e)
    local entity_phase = e:get(_components.phase)
    if entity_phase.follow_world_phase then
      entity_phase:set(self.phases[self.current_phase_index])
    end
  end
end

function phasing:player_collided()
  self:disable()
end

function phasing:update(dt)
  self.timer:update(dt)
  for i = 1, self.pool.size do
    local e = self.pool:get(i)
    -- Charge
    local maximum = _constants.PLAYER.MAX_CHARGE
    if e:has(_components.charge) then
      local charge = e:get(_components.charge)
      if charge.current_charge < maximum then
        charge.current_charge = charge.current_charge + (0.25 * dt)
        if charge.current_charge > maximum then
          charge.current_charge = maximum
        end
      end
    end
  end

  -- Ripple
  if self.ripple_radius > 0 then
    if love.graphics.getWidth() > self.ripple_radius and self.ripple_transparency > 0 then
      self.ripple_radius = self.ripple_radius + (600 * dt)
      self.ripple_transparency = self.ripple_transparency - (0.8 * dt)
      self:getWorld():emit("shake_screen", 1, 1)
      love.audio.play(self.sfx)
    else --disperse the ripple
      self.ripple_radius = 0
      self.ripple_transparency = 0
    end
  end
end

function phasing:attempt_phase_shift()
  for i = 1, self.pool.size do
    local e = self.pool:get(i)
    if e:has(_components.charge) then
      local charge = e:get(_components.charge)
      if charge.current_charge >= 1 and self.canPhase then
        charge.current_charge = charge.current_charge - 1
        self.canPhase = false
        self.timer:after(
          2.5,
          function()
            self.canPhase = true
          end
        )
        self:trigger_phase_shift()
      end
    end
  end
end

function phasing:trigger_phase_shift()
  if self.current_phase_index == 1 then
    self.current_phase_index = 2
  else
    self.current_phase_index = 1
  end
  for i = 1, self.pool.size do
    local e = self.pool:get(i)
    local phase = e:get(_components.phase)
    if phase.follow_world_phase then
      phase:set(self.phases[self.current_phase_index])
    end
    if e:has(_components.control) then
      self:ripple(e)
    end
  end

  self:getWorld():emit("phase_update", self.phases[self.current_phase_index])
end

function phasing:ripple(entity)
  local transform = entity:get(_components.transform)
  local position = transform.position
  self.ripple_origin = position
  self.ripple_transparency = 0.75
  self.ripple_radius = 0.1
end

function phasing:draw(dt)
  if self.ripple_radius > 0 then
    local red = 0
    local blue = 0
    if self.current_phase_index == 1 then
      red = self.ripple_transparency
    else
      blue = self.ripple_transparency
    end
    love.graphics.setColor(red, 0, blue, self.ripple_transparency)
    love.graphics.circle("fill", self.ripple_origin.x, self.ripple_origin.y, self.ripple_radius)
  end
end

function phasing:draw_ui(dt)
  local CHARGE_BAR_WIDTH = love.graphics.getWidth() * _constants.CHARGE_BAR_WIDTH
  local CHARGE_BAR_HEIGHT = love.graphics.getHeight() * _constants.CHARGE_BAR_HEIGHT
  for i = 1, self.pool.size do
    local e = self.pool:get(i)
    if e:has(_components.charge) then
      local charge = e:get(_components.charge)

      --Bar structure
      love.graphics.setColor(0.5, 0.5, 0.5, 0.3)
      love.graphics.rectangle(
        "fill",
        (love.graphics.getWidth() * 0.8) - (CHARGE_BAR_WIDTH),
        love.graphics.getHeight() * 0.9,
        CHARGE_BAR_WIDTH,
        CHARGE_BAR_HEIGHT
      )
      --Current charge fill
      love.graphics.setColor(1, 1, 1, 0.5)
      love.graphics.rectangle(
        "fill",
        (love.graphics.getWidth() * 0.8) - (CHARGE_BAR_WIDTH),
        love.graphics.getHeight() * 0.9 + CHARGE_BAR_HEIGHT,
        (CHARGE_BAR_WIDTH * (charge.current_charge / 2)),
        -(CHARGE_BAR_HEIGHT)
      )
      --Outline 1
      love.graphics.setColor(1, 1, 0, 0.3)
      love.graphics.rectangle(
        "line",
        (love.graphics.getWidth() * 0.8) - (CHARGE_BAR_WIDTH),
        love.graphics.getHeight() * 0.9,
        CHARGE_BAR_WIDTH,
        CHARGE_BAR_HEIGHT
      )
      love.graphics.setColor(1, 1, 0, 0.3)
      love.graphics.rectangle(
        "fill",
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() * 0.9,
        2,
        CHARGE_BAR_HEIGHT
      )
    end
  end
end

return phasing
