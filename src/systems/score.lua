local score = Concord.system()

function score:init()
    self.current = _constants.SCORE.START
    self.score_increment = _constants.SCORE.INCREMENT
    self.timer = Timer.new()
    self.timer:every(
        2,
        function()
            flux.to(self, 1, {current = (self.current + 10)})
        end
    )
end

function score:player_collided()
    local output = math.floor(self.current + 0.5)
    self:getWorld():emit("display_final_score", output)
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
    local output = math.floor(self.current + 0.5)
    love.graphics.print(output, _constants.SCORE.X, _constants.SCORE.Y)
end

return score
