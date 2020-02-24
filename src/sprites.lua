local PARTICLE_QUAD_WIDTH = 8
local ship_particle_sheet = love.graphics.newImage("resources/sprites/ship_particles.png")

return {
  ["SHIP"] = {
    ["BLUE"] = love.graphics.newImage("resources/sprites/ship_blue.png"),
    ["RED"] = love.graphics.newImage("resources/sprites/ship_red.png")
  },
  ["PARTICLES"] = {
    sheet = ship_particle_sheet,
    -- quads = {
    --   love.graphics.newQuad(0, 0, PARTICLE_QUAD_WIDTH, PARTICLE_QUAD_WIDTH, ship_particle_sheet:getDimensions()),
    --   love.graphics.newQuad(
    --     PARTICLE_QUAD_WIDTH,
    --     0,
    --     PARTICLE_QUAD_WIDTH,
    --     PARTICLE_QUAD_WIDTH,
    --     ship_particle_sheet:getDimensions()
    --   )
    -- }
    -- quads = {
    --   love.graphics.newQuad(
    --     0,
    --     PARTICLE_QUAD_WIDTH,
    --     PARTICLE_QUAD_WIDTH,
    --     PARTICLE_QUAD_WIDTH,
    --     ship_particle_sheet:getDimensions()
    --   ),
    --   love.graphics.newQuad(
    --     PARTICLE_QUAD_WIDTH,
    --     PARTICLE_QUAD_WIDTH,
    --     PARTICLE_QUAD_WIDTH,
    --     PARTICLE_QUAD_WIDTH,
    --     ship_particle_sheet:getDimensions()
    --   ),
    --   love.graphics.newQuad(
    --     2 * PARTICLE_QUAD_WIDTH,
    --     PARTICLE_QUAD_WIDTH,
    --     PARTICLE_QUAD_WIDTH,
    --     PARTICLE_QUAD_WIDTH,
    --     ship_particle_sheet:getDimensions()
    --   )
    -- }
    quads = {
      love.graphics.newQuad(
        0,
        2 * PARTICLE_QUAD_WIDTH,
        PARTICLE_QUAD_WIDTH,
        PARTICLE_QUAD_WIDTH,
        ship_particle_sheet:getDimensions()
      ),
      love.graphics.newQuad(
        PARTICLE_QUAD_WIDTH,
        2 * PARTICLE_QUAD_WIDTH,
        PARTICLE_QUAD_WIDTH,
        PARTICLE_QUAD_WIDTH,
        ship_particle_sheet:getDimensions()
      ),
      love.graphics.newQuad(
        2 * PARTICLE_QUAD_WIDTH,
        2 * PARTICLE_QUAD_WIDTH,
        PARTICLE_QUAD_WIDTH,
        PARTICLE_QUAD_WIDTH,
        ship_particle_sheet:getDimensions()
      )
    }
  }
}
