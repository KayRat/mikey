local objKick = mike.plugins.get("Kick")
local objKickCmd = mike.commands.get("kick")

function objKick:canUserRun(objPl)
    if(not IsValid(objPl)) then return true end

    if(IsValid(objPl)) then return true end -- TODO: add actual permission logic wtf

    return mike.commands.error.NOT_FOUND
end

objKickCmd.onRun = function(self, pl, cmd, args)
  local targetUniqueID = args[1]
  
  if(not IsValid(pl)) then
    mike.info.error("Console tried to kick, this isn't supported yet")
    return
  end
  
  local target = player.GetByUniqueID(targetUniqueID)
  
  if(not IsValid(target)) then
    mike.log.error("Player '"..targetUniqueID.."' not found")
    return
  end
  
  table.remove(args, 1)
  
  local reason = #args > 0 and table.concat(args, " ") or "Consider this a warning...don't do it again"
  
  mike.log.info("Kicking '"..target:Nick().."' ("..reason..")")
  target:Kick("Kicked by "..pl:Nick()..": "..reason)
end

mike.plugins.add(objKick)
mike.commands.add(objKickCmd)
