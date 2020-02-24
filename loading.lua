loading = {}
local splash_displaying = false
local splash_screen = nil
local MINIMUM_LOAD_TIME = 1.25
local load_timer = 0

function loading:init()
  love.graphics.setDefaultFilter("nearest", "nearest", 4)
  splash_screen = love.graphics.newImage("resources/misc/splashscreen.png")
end

function loading:enter(previous, task, data)
end

function loading:leave()
end

function loading:update(dt)
  if splash_displaying and load_timer > MINIMUM_LOAD_TIME then
    load_game()
  end

  splash_displaying = true
  load_timer = load_timer + dt
end

function loading:draw()
  love.graphics.draw(
    splash_screen,
    0,
    0,
    0,
    love.graphics:getWidth() / splash_screen:getWidth(),
    love.graphics.getHeight() / splash_screen:getHeight()
  )
end

function load_game()
  Vector = require("libs.vector")
  Timer = require("libs.timer")
  _constants = require("src.constants")
  _util = require("libs.util")
  HC = require("libs.HC")
  moonshine = require("libs.moonshine")
  _sprites = require("src.sprites")
  _audio = require("src.audio")

  _fonts = {
    ["SCORE_COUNTER"] = love.graphics.newFont("resources/fonts/whitrabt.ttf", 48),
    ["FINAL_SCORE"] = love.graphics.newFont("resources/fonts/whitrabt.ttf", 36),
    ["RESTART"] = love.graphics.newFont("resources/fonts/whitrabt.ttf", 24),
    ["CONTROLS"] = love.graphics.newFont("resources/fonts/whitrabt.ttf", 16)
  }

  GamestateManager.switch(game)
end
