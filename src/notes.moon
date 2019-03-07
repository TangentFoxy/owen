-- 'infinte' galaxy map
-- star colors (use chart w its percentages for now, later use ED data)
-- ship construction: grid of modules
-- - life support: replaces some sensors, controls, tanks
-- - resource handler: replaces tanks, cargo space, docking ports, airlocks
-- - storage system: replaces tanks & cargo space (expansion based on resource handler)
-- - survival system: combines cockpit & life support
-- - integrated drive system: combines reactor, rcs thrusters, ion drive, battery, and gyroscopes
-- - radar, lidar, radio, infrared sensor, spectrometer, radiation sensor (geiger counter),
--   camera, cpu, motion detector
-- starter ship: resource handler, integrated drive system, survival system
-- grammars for generating names of star systems, stars, planets, parts, vessels
-- remember to generate colors and color sets for ships?

Part: {
  materials: {} -- what it is made of (a percentage can be reclaimed by recycling)
  modules: {} -- what features are added at what strengths
}

-- what needs to be done every tick
-- - each 'on' system runs in turn based on priority, taking available energy
--   - alerts may trigger if a system cannot function
-- - systems should be responsible for everything else :D
