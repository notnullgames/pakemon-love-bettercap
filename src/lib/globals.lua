require "lib.REST-love.module-loader"
requireFromLib("lib/REST-love", "REST")
Camera = requireFromLib("lib/hump", "camera")
json = require "lib.dkjson"
bettercap = require "lib.bettercap"
cron = require "lib.cron"
require "lib.inputmap"

StateHostList = require "states.host_list"

-- simple debug function to dump JSON
function debug(data)
  print(json.encode(data, { indent = 2 }))
end

-- return boolean from env-var, or default value (false)
function boolenv(name, default)
  local e = string.lower(os.getenv(name) or default  or "")
  return e == "yes" or e == "1" or e == "true" or e == "y" or e == "t"
end

-- return string from env-var, or default value (empty string)
function strenv(name, default)
  return os.getenv(name) or default or ""
end

-- switch to a new gamestate
function set_state(state)
  if current_state and current_state.leave then
    current_state:leave()
  end
  if state then
    current_state = state
    if state.enter then
      state:enter()
    end
  end
end

dev_mode = boolenv("PAKEMON_DEV")
bettercap.url = strenv("PAKEMON_URL", bettercap.url)
REST.isDebug = false
time = 0