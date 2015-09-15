local kickPlugin = mike.plugins.get("Kick")
local kickCmd = mike.commands.get("kick")

kickCmd.canUserRun = function(self, pl, cmd, args)
  local targetUniqueID = args[1]

  if(not IsValid(pl)) then
    mike.log.error("Console is not permitted to kick")
    return mike.commands.error.NO_CONSOLE
  end

  if(pl:hasPermission("kick")) then
    reutrn true
  end

  return mike.commands.error.NO_PERMISSION
end

kickCmd.onRun = function(self, pl, cmd, args)
  local targetUniqueID = args[1]

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

mike.plugins.add(kickPlugin)
mike.commands.add(kickCmd)
