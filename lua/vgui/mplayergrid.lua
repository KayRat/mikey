local PANEL = {}

function PANEL:Init()
  local pnlIconLayout = vgui.Create("DIconLayout", self)
  pnlIconLayout:DockMargin(5, 5, 5, 5)
  --pnlIconLayout:DockPadding(5, 5, 5, 5)
  pnlIconLayout:Dock(TOP)
  pnlIconLayout:SetSpaceX(4)
  pnlIconLayout:SetSpaceY(4)
  pnlIconLayout.onPlayerSelected = self.onPlayerSelected
  pnlIconLayout.onPlayerDeselected = self.onPlayerDeselected

  self.m_pnlIconLayout = pnlIconLayout
end

function PANEL:PerformLayout(iWidth, iHeight)
  self.BaseClass.PerformLayout(self, iWidth, iHeight)

  if(not self.VBar.Enabled) then
    self.VBar:SetEnabled(true)
  end
end

function PANEL:clearPlayerList()
  self.m_pnlIconLayout:Clear()
end

function PANEL:getPlayerCards()
  PrintTable(self.m_pnlIconLayout:GetChildren())
  return self.m_pnlIconLayout:GetChildren()
end

function PANEL:createPlayerList(objSortMethod)
  self:clearPlayerList()
  local tblMaster = objSortMethod and objSortMethod() or player.GetAll() -- TODO: default to group by team, sort by player name

  for k,v in pairs(tblMaster) do
    if(IsValid(v)) then
      self:addPlayerCard(v)
    end
  end

  local pnlParent = self:GetParent()

  for k,v in pairs(pnlParent:getSelectedPlayers()) do
    if(not IsValid(v)) then
      pnlParent:setPlayerSelected(k, false)
    end
  end

  local pnlActionList = pnlParent.m_pnlActionList
  if(IsValid(pnlActionList)) then
    pnlActionList:InvalidateLayout()
  end
end

function PANEL:addPlayerCard(objPl)
  local iCardWidth, iCardHeight = 136, 136 -- TODO: select size based on parent

  local pnl = self.m_pnlIconLayout:Add("MPlayerCard")
  pnl:SetSize(iCardWidth, iCardHeight)
  pnl:SetPlayer(objPl)
  pnl:SetParent(self.m_pnlIconLayout)

  if(self:GetParent():isPlayerSelected(objPl:UniqueID())) then
    pnl:setSelected(true)
  end
end

function PANEL:removePlayerCard(strUniqueID)
  PrintTable(self:getPlayerCards())
  for k,v in pairs(self:getPlayerCards()) do
    print("checking card", k, v)
    if(v:getUniqueID() == strUniqueID) then
      print("removing", v:getUniqueID())
      v:Remove()
      break
    end
  end

  self:GetParent():setPlayerSelected(strUniqueID, false)
end

function PANEL:Paint(iWidth, iHeight)
  surface.SetDrawColor(0, 0, 0)
  surface.DrawOutlinedRect(0, 0, iWidth, iHeight)
end

vgui.Register("MPlayerGrid", PANEL, "DScrollPanel")
