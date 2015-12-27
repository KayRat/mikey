local objMenu = mikey.commands.new("menu", "Show the menu")

local function refreshMenus(objPl)
  mikey.network.send("mikey.menu.refresh", player.GetAll())
end

hook.Add("PlayerInitialSpawn", "mikey.menu.refresh", refreshMenus)
hook.Add("player_disconnect", "mikey.menu.refresh", function()
  timer.Simple(0.15, refreshMenus)
end)

function objMenu:canUserRun(objPl)
    if(not IsValid(objPl)) then return mikey.commands.error.NO_CONSOLE end

    return objPl:isMod() or mikey.commands.error.NO_PERMISSION
end

function objMenu:onRun(objPl, strCmd, tblArgs)
    mikey.network.send("mikey.menu.open", objPl)
end

mikey.commands.add(objMenu)
