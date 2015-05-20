--[[
Monsanto wrapper over Heka Anomaly Detection module to 
translate individual algorithms to a friendly name. 
This should make it easier to configure anomaly algorithms without know a the data science behind the
algorithms

--]]

local alert = require "alert"
require("string")
function trnslt_anomaly_config(pl,mon_cfg)
   local payl = pl or 'Stats'
   local mon_anomaly_config = mon_cfg

   local t_anomcfg = {}
   for k,v in string.gmatch(mon_anomaly_config,"(%w+):(%d*%,?%d*%,?%d*)")  do t_anomcfg[k] = v end
   local fld = ''
   local a_anomcfg = ' '
   local win = 0
   local hwin = 0
   local ky = ''
   local anon_str = ''

   for k in pairs(t_anomcfg)
     do
       if string.find(t_anomcfg[k],",") then
          local i = 1
          for k in string.gmatch(t_anomcfg[k],"([^"..",".."]+)") 
             do 
               if i==1 then
                 fld = k
               elseif i==2 then
                 win = k
               elseif i==3 then
                  hwin = k
               end    
               i=i+1 
            end
       else   
         fld = t_anom[k]
       end  
        
       ky = string.lower(k)
       if ky == 'spike' then
         anon_str = 'roc("' .. payl .. '",' .. fld .. ','.. win .. ',' .. hwin ..',3,false,false)'
       elseif ky == 'slowchange' then
         anon_str = 'mww("' .. payl .. '",' .. fld .. ','.. win .. ',' .. hwin ..',0.0002,any)'
       elseif ky == 'creepingchange' then
         anon_str = 'mww_nonparameteric("'.. payl .. '",' .. fld .. ','.. win .. ',' .. hwin ..',0.60)'
       elseif ky == 'breakout' then
         anon_str = ''
       elseif ky == 'breakdown' then
         anon_str = 'roc("' .. payl .. '",' .. fld .. ',3,0,1,true,false)'
       elseif ky == 'threshold' then
         anon_str = ' '
       end
       a_anomcfg = a_anomcfg .. ' ' .. anon_str
    end  
    return a_anomcfg
  end
 
--Test Code
--[[
a_cfg = trnslt_anomaly_config(nil,nil)
print(a_cfg)
--]]
-- end test code
