function love.load()
    GamestateManager = require("libs.gamestate")
    require("loading")
    require("game")
    love.window.setIcon(love.image.newImageData("resources/sprites/ship_blue.png"))
    GamestateManager.registerEvents()
    GamestateManager.switch(loading)
end

function love.update(dt)
end

function love.draw()
end
