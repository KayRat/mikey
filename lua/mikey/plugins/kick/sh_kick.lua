PLUGIN["Menu"] = {
  ["Category"]      = mikey.menu.category.ADMIN,
  ["DisplayName"]   = "Kick",
  ["Icon"]          = "icon16/disconnect.png",
  ["SingleSelect"]  = false,
}

local kickCmd = mikey.commands.get("kick")
local kickIDCmd = mikey.commands.get("kickid")

local function canUserRun(self, pl, cmd, args)
  if(not IsValid(pl)) then
    return mikey.permission.NO_CONSOLE
  end

  if(pl:isMod()) then
    return true
  end

  return mikey.permission.NONE
end

PLUGIN.canUserRun = canUserRun
