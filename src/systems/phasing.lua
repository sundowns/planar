local phasing = Concord.system({_components.phase}, {_components.phase, _components.control, "PLAYER"})

function phasing:init()
  self.phases = {"RED", "BLUE"}
  self.current_phase_index = 1
  self.ripple_radius = 0
  self.ripple_origin = Vector(0, 0)
  self.ripple_transparency = 0
  self.ripple_active = false
  self.canPhase = true
  self.timer = Timer.new()
  self.sfx = love.audio.newSource("resources/audio/phaseshift2.wav", "static")
  self.ambience = love.audio.newSource("resources/audio/ambience.wav", "static")
  self.ripple_tween_fn = nil

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
        charge.current_charge = charge.current_charge + (0.5 * (dt * (math.max(charge.current_charge, 1.2) / maximum)))
        if charge.current_charge > maximum then
          charge.current_charge = maximum
        end
      end
    end
  end

  -- Ripple
  if self.ripple_active then
    if love.graphics.getWidth() < self.ripple_radius and self.ripple_transparency <= 0 then
      --disperse the ripple
      self.ripple_radius = 0
      self.ripple_transparency = 0
      self.ripple_active = false
      self.timer:cancel(self.ripple_tween_fn)
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
          0.5,
          function()
            if love.math.random(1, 8) == 1 then
              love.audio.play(self.ambience)
            end
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
  end
  local player = self.PLAYER:get(1)
  self:ripple(player:get(_components.transform).position)
  self:getWorld():emit("shake_screen", 1, 1)
  if self.sfx:isPlaying() then
    self.sfx:stop()
    self.sfx:play()
  else
    self.sfx:play()
  end

  self:getWorld():emit("phase_update", self.phases[self.current_phase_index])
end

function phasing:ripple(origin)
  self.ripple_active = true
  self.ripple_origin = origin
  self.ripple_transparency = 0.75
  self.ripple_radius = 0.1
  -- this will tween to double the width of the screen
  self.ripple_tween_fn =
    self.timer:tween(8, self, {ripple_radius = love.graphics.getWidth(), ripple_transparency = 0}, "out-elastic")
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

    _util.l.resetColour()
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
