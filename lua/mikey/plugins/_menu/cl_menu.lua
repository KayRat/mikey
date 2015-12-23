mikey = mikey or {}
mikey.menu = mikey.menu or {}

gameevent.Listen("player_disconnect")

local objMenu = nil
local tblTitles = {
  "what's cookin?",
  "feat. some admin tools",
  "feat. Pitbull",
  "michael scott approved",
  "now with 20% fewer inconsistencies",
  "super duper hacky version",
  "assistant (to the) regional manager",
  "isn't this random title a waste of CPU?",
  os.time(),
}

local function refreshCards()
  print("received refresh request")
  if(IsValid(objMenu)) then
    print("refreshing currently opened menu")
    objMenu.m_pnlCanvas.m_pnlPlayerList:createPlayerList()
  end
end

mikey.network.receive("mikey.menu.refresh", refreshCards)

mikey.network.receive("mikey.menu.open", function(tblData)
  local iWidth, iHeight = ScrW(), ScrH()
  local iMenuWidth  = math.Clamp(ScrW()*0.6, 825, ScrW())
  local iMenuHeight = math.Clamp(ScrH()*0.4, 525, ScrH())

  if(IsValid(objMenu)) then
    objMenu:InvalidateChildren(true)
  else
    objMenu = vgui.Create("MFrame")
    objMenu:SetTitle("mike's cereal shack - "..table.Random(tblTitles))
    objMenu:SetSize(iMenuWidth, iMenuHeight)
    objMenu:SetSizable(true)
    objMenu:Center()

    local pnlCanvas = vgui.Create("MCanvas", objMenu)
    pnlCanvas:DockMargin(2, 2, 2, 2)
    pnlCanvas:DockPadding(4, 4, 4, 4)
    pnlCanvas:Dock(FILL)

    local pnlPlayerList, pnlActionList, pnlSettings

    do -- player list
      pnlPlayerList = vgui.Create("MPlayerGrid", pnlCanvas)
      pnlPlayerList:DockMargin(0, 0, 5, 0)
      pnlPlayerList:DockPadding(4, 4, 4, 4)
      pnlPlayerList:Dock(LEFT)
      pnlPlayerList:createPlayerList()
    end -- end player list

    do -- settings
      pnlSettings = vgui.Create("MSettings", pnlCanvas)
      pnlSettings:DockMargin(0, 0, 0, 5)
      pnlSettings:Dock(TOP)
    end -- end settings

    do -- action list
      pnlActionList = vgui.Create("MActionList", pnlCanvas)
      pnlActionList:DockMargin(0, 0, 0, 0)
      pnlActionList:Dock(FILL)
    end -- end action list

    pnlCanvas.m_pnlPlayerList = pnlPlayerList
    pnlCanvas.m_pnlActionList = pnlActionList
    pnlCanvas.m_pnlSettings = pnlSettings
    objMenu.m_pnlCanvas = pnlCanvas

    objMenu:InvalidateChildren(true)
    objMenu:MakePopup()
  end
end)
