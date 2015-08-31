local objMenu = nil

net.Receive("mike.commands.menu.open", function(iLen)
    local bHasTarget = net.ReadBool()
    local strTarget = bHasTarget and net.ReadString()

    if(IsValid(objMenu)) then
        objMenu:InvalidateLayout()
    else
        objMenu = vgui.Create("MFrame")
        objMenu:SetTitle("Mike's Cereal Shack")
        objMenu:SetSize(500, 400)
        objMenu:Center()
        objMenu:MakePopup()
    end
end)
