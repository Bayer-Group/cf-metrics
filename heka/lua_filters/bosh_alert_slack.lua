require "string"
local title = "unknown"
local slack_message = "blah"

function process_message ()
    title = read_message("Fields[Title]")
    if title == nil then
        title = "unkown"
    end
   ts = read_message("Fields[Tstamp]")
   env = read_message("Fields[Env]") 
   if env == nil then
       env = "unknown"
   end

   if string.find(title, "finish") then
     slack_message = string.format("Bosh deploy finished in %s", env)
   end
   if string.find(title, "error during update") then
     slack_message = string.format("Bosh deploy finished with error in %s", env)
   end
   if string.find(title, "begin") then
     slack_message = string.format("Bosh deploy started in %s", env)
   end

   inject_payload("txt", "slack-message", slack_message) 
   return 0
end

