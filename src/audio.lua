local bgm = love.audio.newSource("resources/audio/bgm.wav", "stream")
bgm:setLooping(true)

local ambience = love.audio.newSource("resources/audio/pulsing2.wav", "stream")
ambience:setLooping(true)

return {
  ["BGM"] = bgm,
  ["AMBIENCE"] = ambience,
  ["GAMEOVER"] = love.audio.newSource("resources/audio/gameover.wav", "stream")
}
