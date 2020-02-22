return {
    PLAYER = {
        FRICTION = 1.5,
        MAX_SPEED = 360,
        SIZE = 64,
        MAX_CHARGE = 2
    },
    SPAWNER = {
        SPAWN_OFFSCREEN_OFFSET = 50,
        BASE_SPAWN_RATE = 0.1, -- every 1 second
        BASE_MAX_OBSTACLE_VELOCITY = 25,
        BASE_MIN_OBSTACLE_VELOCITY = 10
    },
    SCORE = {
        START = 0,
        INCREMENT = 10,
        X = 10,
        Y = 10,
        X_FINAL = love.graphics.getWidth() / 2.2,
        Y_FINAL = love.graphics.getHeight() / 2
    },
    CHARGE_BAR_HEIGHT = 0.04,
    CHARGE_BAR_WIDTH = 0.6
}
