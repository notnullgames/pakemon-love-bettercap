-- setup some globals
conf = require "conf"

require "lib.REST-love.module-loader"
requireFromLib("lib/REST-love", "REST")

-- set dev in conf.lua to tru to live-reload
if conf.dev then
  lick = requireFromLib("lib/LICK", "lick")
  -- call love.load() on refresh?
  lick.reset = false
end

function love.load()
end

function love.draw()
  love.graphics.printf( "It works!", 0, 230, 640, "center")
end