mikey = mikey or {}
mikey.menu = mikey.menu or {}

local objMenu = nil
local tblTitles = {
  "what's cookin?",
  "feat. some admin tools",
  "feat. Pitbull",
  "michael scott approved",
  "now with 20% fewer inconsistencies",
  "I hope Aaron isn't here",
  "super duper hacky version",
  "assistant (to the) regional manager",
  "isn't this title a waste of CPU?",
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
    objMenu:SetTitle("mike's cereal shack - "..table.Random(tblTitles))
    objMenu:SetSize(825, 525)
    objMenu:SetSizable(true)
    objMenu:Center()

    local pnlCanvas = vgui.Create("DPanel", objMenu)
    pnlCanvas:DockMargin(2, 2, 2, 2)
    pnlCanvas:DockPadding(4, 4, 4, 4)
    pnlCanvas:Dock(FILL)
    pnlCanvas:InvalidateParent(true)
    pnlCanvas.OldPaint = function(self, iWidth, iHeight)
      surface.SetDrawColor(255, 0, 0)
      surface.DrawRect(0, 0, iWidth, iHeight)
    end

    local pnlPlayerList, pnlActionList, pnlSettings

    do -- player list
      pnlPlayerList = vgui.Create("MPlayerGrid", pnlCanvas)
      pnlPlayerList:DockMargin(0, 0, 5, 0)
      pnlPlayerList:DockPadding(4, 4, 4, 4)
      pnlPlayerList:SetWide(2*(pnlCanvas:GetWide()/2.8))
      pnlPlayerList:Dock(LEFT)
      --pnlPlayerList:InvalidateParent(true)
      pnlPlayerList:CreatePlayerList()
      pnlPlayerList.OnPlayerSelected = function(self, objPl, objPanel)
        pnlActionList:OnPlayerSelected(objPl, objPanel)
      end
      pnlPlayerList.OnPlayerDeselected = function(self, objPl, objPanel)
        pnlActionList:OnPlayerDeselected(objPl, objPanel)
      end
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
      --pnlActionList:InvalidateParent(true)
    end -- end action list

    pnlCanvas.m_pnlPlayerList = pnlPlayerList
    pnlCanvas.m_pnlActionList = pnlActionList
    pnlCanvas.m_pnlSettings = pnlSettings
    objMenu.m_pnlCanvas = pnlCanvas

    objMenu:MakePopup()
  end
end)
