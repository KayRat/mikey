mikey = mikey or {}
mikey.menu = mikey.menu or {}

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

mikey.network.receive("mikey.menu.refresh", function(tblData)
  if(IsValid(objMenu)) then
    objMenu:InvalidateLayout()
  end
end)

mikey.network.receive("mikey.menu.open", function(tblData)
  if(IsValid(objMenu)) then
    objMenu:InvalidateChildren(true)
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
    pnlCanvas.PerformLayout = function(self, iWidth, iHeight)
      local iOneThird = math.Round(iWidth / 3)

      self.m_pnlPlayerList:SetWide(iOneThird*2)
      --self.m_pnlActionList:SetWide(iOneThird)
      print("OK")
    end

    local pnlPlayerList, pnlActionList, pnlSettings

    do -- player list
      pnlPlayerList = vgui.Create("MPlayerGrid", pnlCanvas)
      pnlPlayerList:DockMargin(0, 0, 5, 0)
      pnlPlayerList:DockPadding(4, 4, 4, 4)
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

    objMenu:InvalidateChildren(true)
    objMenu:MakePopup()
  end
end)
