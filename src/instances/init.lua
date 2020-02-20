local PATH = (...):gsub("%.init$", "")

return {
  world = require(PATH .. ".world")
}
