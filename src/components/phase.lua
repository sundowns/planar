local phase =
  Concord.component(
  function(e, phases)
    e.phases = phases
    e.current = phases[1]
  end
)

function phase:toggle()
  print("before: " .. self.state)
  if self.state == self.phases[1] then
    self.state = self.phases[2]
  else
    self.state = self.phases[1]
  end
  print("after: " .. self.state)
end

return phase
