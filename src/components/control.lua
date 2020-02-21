local control =
  Concord.component(
  function(e, binds)
    e.binds = binds or {}
    e.is_held = {}
    for _, v in pairs(e.binds) do
      e.is_held[v] = false
    end
  end
)

function control:get(key)
  return self.binds[key]
end

return control
