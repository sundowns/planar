local score = Concord.system()

function score:init()
    self.current = _constants.SCORE.START
    self.score_increment = _constants.SCORE.INCREMENT
    self.score_text = love.graphics.newText(_fonts["SCORE_COUNTER"], 0)
    self.timer = Timer.new()
    self.timer:every(
        2,
        function()
            self:increment(self.score_increment)
        end
    )
end

function score:player_collided()
    local output = math.floor(self.current + 0.5)
    self:getWorld():emit("display_final_score", output)
    love.audio.stop(_audio["BGM"])
    love.audio.play(_audio["GAMEOVER"])
    self:disable()
end

function score:increment(delta_points)
    self.timer:tween(1, self, {current = self.current + delta_points})
end

function score:update(dt)
    self.timer:update(dt)
    self.score_text:set(math.floor(self.current + 0.5))
end

function score:draw_ui()
    love.graphics.setColor(_constants.SCORE.COLOUR)
    love.graphics.draw(self.score_text, _constants.SCORE.X, _constants.SCORE.Y)
    _util.l.resetColour()
end

return score
