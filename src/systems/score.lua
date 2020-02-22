local score = Concord.system()

function score:init()
    self.current = 0
    self.increment = 10
    self.timer = Timer.new()
    self.timer:every(
        2,
        function()
            for i = 1, self.increment do -- use a for loop for nicer looking increase
                self.current = self.current + 1
            end
        end
    )
end

function score:increment(points)
    self.current = self.current + points
end

function score:update(dt)
    self.timer:update(dt)
end

function score:draw_ui()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print(self.current, 10, 10)
end

return score
