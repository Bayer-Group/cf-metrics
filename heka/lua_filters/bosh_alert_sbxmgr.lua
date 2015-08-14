require "string"
os = require 'os'
local title = "unknown"

function process_message ()
    title = read_message("Fields[Title]")
    if title == nil then
        title = "unkown"
    end
   ts = read_message("Fields[Tstamp]")
  -- make output like: 5MinAvg,Hostname=myhost,Environment=dev value=0.110000 1434932024
   env = read_message("Fields[Env]") 
   if env == nil then
       env = "unknown"
   end

   if string.find(title, "finish") then
     os.execute("/usr/bin/heka-sbmgr -action=load -config=/usr/share/heka/CloudOps.toml -script=/usr/share/heka/lua_filters/health_alert_np.lua -scriptconfig=/usr/share/heka/np_health.toml")
   end
   if string.find(title, "begin") then
     os.execute("/usr/bin/heka-sbmgr -action=unload -config=/usr/share/heka/CloudOps.toml -filtername=CFHealth_NP")
   end

   return 0
end

