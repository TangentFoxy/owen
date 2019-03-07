localGenerator = love.math.newRandomGenerator os.time!

distance = (x, y, X, Y) ->
  x2 = x - X
  y2 = y - Y
  return math.sqrt x2*x2 + y2*y2

generate = (seed) ->
  -- random = love.math.newRandomGenerator(seed) if seed
  -- random = localGenerator unless random
  random = love.math -- TEMP love bug

  -- length can be up to 2 * segmentLength longer
  targetLength = math.max 1, random.randomNormal 2, 3
  -- does not count ends
  segmentCount = math.floor math.max 1, random.randomNormal 2, 3
  segmentLength = targetLength / segmentCount
  polygon = {}
  -- generate right side
  for i=1, segmentCount
    table.insert polygon, math.max 0.5, random.randomNormal 1.5, 1.25
    table.insert polygon, segmentLength * i
  -- place rear center point?
  if love.math.random! < 0.8
    table.insert polygon, 0
    table.insert polygon, targetLength + segmentLength
  -- clone right side backwards to make left side
  for i=#polygon-1, 1, -2
    if polygon[i] != 0
      table.insert polygon, -polygon[i]
      table.insert polygon, polygon[i + 1]
  -- place front center point?
  if love.math.random! > 0.2
    table.insert polygon, 0
    table.insert polygon, 0
  -- do not accept triangles
  if #polygon <= 6
    return generate seed

  -- find center of mass
  y = 0
  weight = 0
  for i=1, #polygon - 1, 2
    if polygon[i] == 0 -- ends have a 1.5 weighting
      y += math.abs 1.5 * polygon[i + 1]
      weight += math.abs 1.5
    else
      y += math.abs polygon[i] * polygon[i + 1]
      weight += math.abs polygon[i]
  y /= weight
  for i=2, #polygon, 2
    polygon[i] -= y

  ship = {
    polygon: polygon
    triangles: love.math.triangulate polygon
    area: 0 -- calculated below
  }

  for triangle in *ship.triangles
    a = distance triangle[1], triangle[2], triangle[3], triangle[4]
    b = distance triangle[3], triangle[4], triangle[5], triangle[6]
    c = distance triangle[1], triangle[2], triangle[5], triangle[6]
    s = 0.5 * ( a + b + c )
    ship.area += 10 * math.sqrt s * (s - a) * (s - b) * (s - c)

  for triangle in *ship.triangles
    for i=1, 6
      triangle[i] *= 10 --+ math.log ship.area

  return ship

return generate
