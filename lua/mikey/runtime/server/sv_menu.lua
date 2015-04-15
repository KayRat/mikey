util.AddNetworkString("mike.commands.menu.open")
util.AddNetworkString("mike.commands.menu.open.withTarget")

local objMenu = mike.commands.new("menu", "Show the menu")

function objMenu:canUserRun(objPl)
    if(not IsValid(objPl)) then return mike.commands.error.NO_CONSOLE end

    return true
end

function objMenu:onRun(objPl, strFirst, tblArgs)
    print("[SERVER] onRun called by", objPl, tblArgs and tblArgs[1] or nil)

    if(strFirst and string.len(strFirst) > 0) then
        net.Start("mike.commands.menu.open.withTarget")
            net.WriteString(strFirst)
        net.Send(objPl)
    else
        net.Start("mike.commands.menu.open")
        net.Send(objPl)
    end
end

mike.commands.add(objMenu)
