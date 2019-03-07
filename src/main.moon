-- changes:
--  reposition center based on weighted values from all points
--   so it is relatively near the center of mass
--  mass will be the number of parts that can be added?
--   if so, need to make minimum size of ship 3 (or 4? for the jump drive?)

ships = {}
justGenerated = false

make = ->
  generate = require "ships"
  for i=1, 75
    ship = generate!
    minx = 0
    maxx = 0
    miny = 0
    maxy = 0
    for i=1, #ship.polygon, 2
      minx = math.min minx, ship.polygon[i]
      maxx = math.max maxx, ship.polygon[i]
    for i=2, #ship.polygon, 2
      miny = math.min miny, ship.polygon[i]
      maxy = math.max maxy, ship.polygon[i]
    ship.ratio = (maxx - minx) / (miny - maxy)
    table.insert ships, ship
    -- table.sort ships, (A, B) -> A.ratio > B.ratio
    table.sort ships, (A, B) -> A.area > B.area
make!

love.draw = ->
  for i=1, #ships
    love.graphics.setColor 1, 1, 1, 1
    love.graphics.translate (i + 1) % 14 * 55, 100 * (1 + math.floor i / 14)
    ship = ships[i]
    for triangle in *ship.triangles
      love.graphics.polygon "fill", triangle
    love.graphics.origin!

love.olddraw = ->
  love.graphics.scale 10, 10
  love.graphics.translate 5, 5.5
  -- for ship in *ships
  for i=1, #ships
    love.graphics.setColor 1, 1, 1, 1
    ship = ships[i]
    for triangle in *ship.triangles
      love.graphics.polygon "fill", triangle
    -- love.graphics.print ship.area, 1, 1
    love.graphics.setColor 1, 0, 0, 1
    love.graphics.circle "fill", 0, 0, 0.25
    love.graphics.setColor 1, 1, 1, 1
    love.graphics.push!
    love.graphics.origin!
    love.graphics.print math.floor(math.log(ship.area)), (1 + (i-1) % 15) * 50, math.floor((i-1)/15+1) * 110
    love.graphics.pop!
    love.graphics.translate 5, 0
    if i % 15 == 0
      love.graphics.translate -5*15, 11
  -- if justGenerated
  --   justGenerated = false
  --   love.graphics.captureScreenshot "#{love.filesystem.getSourceBaseDirectory!}/#{love.math.random!}.png"

love.keypressed = (key) ->
  if key == "escape" then
    love.event.quit!
  elseif key == "r" then
    ships = {}
    make!
    justGenerated = true
