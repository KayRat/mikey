util.AddNetworkString("mikey.commands.menu.open")
util.AddNetworkString("mikey.menu.refresh")

local objMenu = mikey.commands.new("menu", "Show the menu")

local function refreshMenus(objPl)
  net.Start("mikey.menu.refresh")
  net.Broadcast()
end

hook.Add("PlayerInitialSpawn", "mikey.menu.refresh", refreshMenus)
hook.Add("PlayerDisconnected", "mikey.menu.refresh", refreshMenus)

function objMenu:canUserRun(objPl)
    if(not IsValid(objPl)) then return mikey.commands.error.NO_CONSOLE end

    return true
end

function objMenu:onRun(objPl, strCmd, tblArgs)
    mikey.network.send("mikey.menu.open", objPl)
end

mikey.commands.add(objMenu)
