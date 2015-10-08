local objMenu = nil
local tblTitles = {
  "what's cookin?",
  "feat. some admin tools",
  "feat. Pitbull",
  "michael scott approved",
  "now with 20% fewer inconsistencies"
}

net.Receive("mikey.menu.refresh", function(iLen)
  if(IsValid(objMenu)) then
    objMenu:InvalidateLayout()
  end
end)

net.Receive("mikey.commands.menu.open", function(iLen)
  if(IsValid(objMenu)) then
    objMenu:InvalidateLayout()
  else
    objMenu = vgui.Create("MFrame")
    objMenu:SetTitle("mikey's cereal shack - "..table.Random(tblTitles))
    objMenu:SetSize(825, 525)
    objMenu:Center()

    objMenu:MakePopup()
  end
end)
