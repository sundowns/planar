local score = Concord.system()

function score:init()
    self.current = _constants.SCORE.START
    self.score_increment = _constants.SCORE.INCREMENT
    self.timer = Timer.new()
    self.timer:every(
        2,
        function()
            self:increment(self.score_increment)
        end
    )
end

function score:player_collided()
    self:getWorld():emit("display_final_score", self.current)
    self:disable()
end

function score:increment(delta_points)
    self.current = self.current + delta_points
end

function score:update(dt)
    self.timer:update(dt)
end

function score:draw_ui()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print(self.current, _constants.SCORE.X, _constants.SCORE.Y)
end

return score
