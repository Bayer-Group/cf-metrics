require "string"
require "math"
local alert = require "alert"
local title = "unknown"
local summary = "unknown"
local source = "unknown"
local deploy_in_progress = 3
local send_alert = 0
local list= " "
local issues = {}
local send_alert = 0

function process_message ()
    title = read_message("Fields[Title]")
    if title == nil then
        title = "unknown"
    end

   summary = read_message("Fields[Summary]") 
   if summary == nil then
       summary = "unknown"
   end

   source = read_message("Fields[Source]") 
   if source == nil then
       source = "unknown"
   end
	
   if string.find(title, "finish") or string.find(title, "error during update") then
     deploy_in_progress=0
   elseif string.find(title, "begin") then
     deploy_in_progress=1
   end

   if string.find(title, "Does not exist") and deploy_in_progress ~= 1 then
	if issues[source] then
		issues[source] = issues[source] + 1
	else
		issues[source] = 1
	end
	send_alert = send_alert + 1
   end

   return 0
end

function timer_event(ns)
	if send_alert > 0 then
		for key,value in pairs(issues) do
			list = key .. "\n" .. list
		end

	local out_message=string.format("\nBOSH resurrector has detected and restarted the following missing instances\n%s\n",list)
	alert.send(0, out_message)
	end

	issues={}
	send_alert=0
	list=" "
end

