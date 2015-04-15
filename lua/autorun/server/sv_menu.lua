util.AddNetworkString("mike.commands.menu.open")

local objMenu = mike.commands.new("menu", "Show the menu")

function objMenu:canUserRun(objPl)
    if(not IsValid(objPl)) then return mike.commands.error.NO_CONSOLE end

    return true
end

function objMenu:onRun(objPl)
    print("[SERVER] onRun called by", objPl)
    net.Start("mike.commands.menu.open")
    net.Send(objPl)
end

mike.commands.add(objMenu)
