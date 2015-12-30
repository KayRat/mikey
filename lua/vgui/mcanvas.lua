local PANEL = {}

function PANEL:Init()
  self.m_tblSelectedPlayers    = {}
  self.m_iNumSelectedPlayers = 0
end

function PANEL:PerformLayout(iWidth, iHeight)
end

function PANEL:Paint(iWidth, iHeight)
end

function PANEL:PerformLayout(iWidth, iHeight)
  local iOneThird = math.Round(iWidth / 3)

  self.m_pnlPlayerList:SetWide(iOneThird*2.25)
  --self.m_pnlActionList:SetWide(iOneThird)
end

function PANEL:updateSelectedPlayerCount()
  self.m_iNumSelectedPlayers = table.Count(self.m_tblSelectedPlayers)
end

function PANEL:setPlayerSelected(objPl, bSelected)
  local bIsEnt = type(objPl) == "Player"
  self.m_tblSelectedPlayers[bIsEnt and objPl:UniqueID() or objPl] = bSelected and (bIsEnt and objPl or player.GetByUniqueID(objPl)) or nil

  self:updateSelectedPlayerCount()
  self:InvalidateChildren()
end

function PANEL:isPlayerSelected(strUniqueID)
  return self.m_tblSelectedPlayers[strUniqueID] ~= nil
end

function PANEL:onPlayerSelected(objPl, objPanel)
  self:setPlayerSelected(objPl, true)

  for k,v in pairs(self:GetChildren()) do
    if(objPanel ~= v and v.onPlayerSelected) then
      v:onPlayerSelected(objPl, objPanel)
    end
  end
end

function PANEL:onPlayerDeselected(objPl, objPanel)
  self:setPlayerSelected(objPl, false)

  for k,v in pairs(self:GetChildren()) do
    if(objPanel ~= v and v.onPlayerDeselected) then
      v:onPlayerDeselected(objPl, objPanel)
    end
  end
end

function PANEL:getSelectedPlayers()
  return table.Copy(self.m_tblSelectedPlayers)
end

function PANEL:setSelectedPlayers(tblPlayers)
  self.m_tblSelectedPlayers = tblPlayers
  self:updateSelectedPlayerCount()
end

function PANEL:getNumSelectedPlayers()
  return self.m_iNumSelectedPlayers
end

vgui.Register("MCanvas", PANEL, "DPanel")
