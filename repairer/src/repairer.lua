#!/usr/bin/lua
require "math"
local socket = require("socket")


local BASE_POLL_INTERVAL = 60
local POLL_INTERVAL = 60
local POLL_MIN_INTERVAL = 1
local ERRORS_COUNT = 0
local MAX_ERRORS_COUNT = 3
local REPAIR_TIMEOUT = 5
-- local REPAIR_COMMAND = "ifup wan; ifup waninet"
local REPAIR_COMMAND = "/etc/init.d/network restart"
local LOG = io.output()
function _check()
   return os.execute('ping ya.ru -q -c 1 2>&1 >/dev/null') == 0
   -- return socket.connect("ya.ru", 80)
end


function log(msg)
   if msg then
     LOG:write(string.format("%s\n", msg))
     LOG:flush()
   end
end

function need_repair()
   return (ERRORS_COUNT >= MAX_ERRORS_COUNT) and (ERRORS_COUNT % MAX_ERRORS_COUNT == 0)
end

function handle_error()
   ERRORS_COUNT = ERRORS_COUNT + 1
   -- if we couldn't repair at first time - retry every MAX_ERRORS_COUNT times - not everytime
   if need_repair() then
      log(REPAIR_COMMAND)
      repair_proc = io.popen(REPAIR_COMMAND)
      data = repair_proc:read()
      -- log(data)
   end
end

function handle_success()
   ERRORS_COUNT = 0
   POLL_INTERVAL = BASE_POLL_INTERVAL
end

function calc_poll_interval()
   -- if smth went wrong - enter panic mode, but only 1 time before successfull repair
   if ERRORS_COUNT == 1 then
      POLL_INTERVAL = POLL_MIN_INTERVAL
   else
      POLL_INTERVAL = math.min(POLL_INTERVAL * 2, BASE_POLL_INTERVAL)
   end
   ret_int = POLL_INTERVAL
   if need_repair() then
      ret_int = ret_int + REPAIR_TIMEOUT
   end
   -- log(string.format("Polling interval: %d", POLL_INTERVAL))
   return ret_int
end

function check()
   if _check() then
      handle_success()
   else
      log("check failed")
      handle_error()
   end
   return calc_poll_interval()
end


function main()
   log("repairer started")
   while true do
      socket.select(nil, nil, check())
   end
end

function daemonize()
   arg_count = 0
   for _ in pairs(arg) do arg_count = arg_count + 1 end
   if arg_count > 2 then
      LOG = io.open(arg[1], "w+")
   end
end


daemonize()
main()
