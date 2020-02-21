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

return phasing
