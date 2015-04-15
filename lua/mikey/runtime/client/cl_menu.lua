local objMenu = nil

net.Receive("mike.commands.menu.open", function(iLen)
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
