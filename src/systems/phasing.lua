local phasing = Concord.system({_components.phase})

function phasing:init()
  self.phases = {"RED", "BLUE"}
  self.current_phase_index = 1
end

function phasing:entityAdded(e)
  local entity_phase = e:get(_components.phase)
  if entity_phase.follow_world_phase then
    entity_phase:set(self.phases[self.current_phase_index])
  end
end

function phasing:update(dt)
  for i = 1, self.pool.size do
    local e = self.pool:get(i)
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
end

function phasing:attempt_phase_shift()
  for i = 1, self.pool.size do
    local e = self.pool:get(i)
    if e:has(_components.charge) then
      local charge = e:get(_components.charge)
      if charge.current_charge >= 1 then
        charge.current_charge = charge.current_charge - 1
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
    local phase = self.pool:get(i):get(_components.phase)
    if phase.follow_world_phase then
      phase:set(self.phases[self.current_phase_index])
    end
  end

  self:getWorld():emit("phase_update", self.phases[self.current_phase_index])
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
