local kickPlugin = mikey.plugins.get("Kick")
local kickCmd = mikey.commands.get("kick")
local kickIDCmd = mikey.commands.get("kickid")

local function canUserRun(self, pl, cmd, args)
  if(not IsValid(pl)) then
    return mikey.commands.error.NO_CONSOLE
  end

  if(pl:isMod()) then
    return true
  end

  return mikey.commands.error.NO_PERMISSION
end

kickPlugin.canUserRun = canUserRun
kickCmd.canUserRun = canUserRun
kickIDCmd.canUserRun = canUserRun

mikey.plugins.add(kickPlugin)
mikey.commands.add(kickCmd)
mikey.commands.add(kickIDCmd)
