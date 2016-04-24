local PANEL = {}

function PANEL:Init()
  local pnlIconLayout = vgui.Create("DListLayout", self)
  pnlIconLayout:DockMargin(4, 4, 4, 4)
  pnlIconLayout:DockPadding(4, 4, 4, 4)
  pnlIconLayout:Dock(TOP)
  --pnlIconLayout:SetSpaceX(4)
  --pnlIconLayout:SetSpaceY(4)
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

function PANEL:updatePlayerList()
  for k,v in pairs(self:getPlayerCards()) do
    if(not IsValid(v:getPlayer())) then
      self:GetParent():setPlayerSelected(v:getUniqueID(), false)
      v:Remove()
    end
  end

  for k,v in pairs(player.GetAll()) do
    if(not self:hasPlayerCard(v:UniqueID())) then
      self:addPlayerCard(v)
    end
  end
end

function PANEL:createPlayerList(objSortMethod)
  self:clearPlayerList()
  local tblMaster = objSortMethod and objSortMethod() or player.GetAll() -- TODO: default to group by team, sort by player name

  for k,v in pairs(tblMaster) do
    if(IsValid(v)) then
      self:addPlayerCard(v)
    end
  end
end

local tblPlayerCards = {}

function PANEL:addPlayerCard(objPl)
  local iCardHeight = 42 -- TODO: select size based on parent

  local pnl = self.m_pnlIconLayout:Add("MPlayerCard")
  pnl:SetTall(iCardHeight)
  pnl:setPlayer(objPl)
  pnl:SetParent(self.m_pnlIconLayout)

  if(self:GetParent():isPlayerSelected(objPl:UniqueID())) then
    pnl:setSelected(true)
  end

  tblPlayerCards[objPl:UniqueID()] = true
end

function PANEL:hasPlayerCard(strUniqueID)
  return tblPlayerCards[strUniqueID] ~= nil
end

function PANEL:removePlayerCard(strUniqueID)
  PrintTable(self:getPlayerCards())
  for k,v in pairs(self:getPlayerCards()) do
    if(v:getUniqueID() == strUniqueID) then
      v:Remove()
      break
    end
  end

  self:GetParent():setPlayerSelected(strUniqueID, false)
  tblPlayerCards[strUniqueID] = nil
end

function PANEL:Paint(iWidth, iHeight)
  surface.SetDrawColor(0, 0, 0)
  surface.DrawOutlinedRect(0, 0, iWidth, iHeight)
end

vgui.Register("MPlayerGrid", PANEL, "DScrollPanel")
