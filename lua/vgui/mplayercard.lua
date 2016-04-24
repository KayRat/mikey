local PANEL = {}
PANEL.m_bSelected = false
PANEL.m_tblColors = {
  ["onHover"]         = mikey.colors.alt,
  ["onSelected"]      = mikey.colors.alt2,
  ["onHoverSelected"] = mikey.colors.alt2,
  ["notSelected"]     = color_black,
}

local iBarHeight = 20

function PANEL:Init()
  self:SetText("")
  self.avatar = vgui.Create("AvatarImage", self)
  self.avatar.DoClick = function(self)
    self:GetParent():DoClick()
  end
  self.avatar.PerformLayout = function(self, iWidth, iHeight)
    self:CenterVertical()
    self:SetPos(0, 0)
  end
  self.avatar.Paint = function(self, iWidth, iHeight)
    surface.SetDrawColor(color_white)
    surface.DrawRect(0, 0, iWidth, iHeight)
  end
  self.avatar.PaintOver = function(self, iWidth, iHeight)
    do -- outline
      if((self:IsHovered() or self:GetParent():IsHovered()) and self:GetParent():IsSelected()) then
        surface.SetDrawColor(self:GetParent().m_tblColors.onSelected)
      else
        surface.SetDrawColor(self:GetParent().m_tblColors.notSelected)
      end
      surface.DrawOutlinedRect(0, 0, iWidth, iHeight)
    end
  end

  local objFakeButton = vgui.Create("DButton", self)
  objFakeButton:SetText("")
  objFakeButton:SetPos(0, 0)
  objFakeButton.Paint = function(self, iWidth, iHeight) return end
  objFakeButton.DoClick = function(self) objFakeButton:GetParent():DoClick() end

  self.m_pnlFakeButton = objFakeButton
end

function PANEL:PerformLayout(iWidth, iHeight)
  self.m_pnlFakeButton:SetSize(self:GetWide(), self:GetTall())
end

PANEL.m_iSelectionWidth = 0

function PANEL:Paint(iWidth, iHeight)
  surface.SetDrawColor(0, 0, 0, 255)
  surface.DrawOutlinedRect(0, 0, iWidth, iHeight)

  local iPiece = self:IsSelected() and math.floor(iWidth*0.02) or 0
  self.m_iSelectionWidth = math.Approach(self.m_iSelectionWidth, iPiece, 0.5)

  local objTeamColor = team.GetColor(self:getPlayer():Team()) or color_white
  local iOffset = self:IsSelected() and self.m_iSelectionWidth or 0

  surface.SetDrawColor(objTeamColor)
  surface.DrawRect(self.avatar:GetWide(), 1, iWidth-iOffset-2, iHeight-2)

  if(not self:IsHovered() and not self:IsChildHovered(6) and not self:IsSelected()) then return end

  --if(self:IsSelected() or self.avatar:GetWide() ~= self:GetWide()) then
  if(self.m_iSelectionWidth > 0) then
    surface.SetDrawColor(color_black)
    surface.DrawLine(iWidth-self.m_iSelectionWidth-1, 1, iWidth-self.m_iSelectionWidth-1, iHeight-1)

    surface.SetDrawColor(self.m_tblColors.onSelected)
    surface.DrawRect(iWidth-self.m_iSelectionWidth, 1, iWidth-1, iHeight-2)
  end
end

function PANEL:PaintOver(iWidth, iHeight)
  local strName = self:getPlayer():Nick() or "..."

  surface.SetFont("PlayerCardName")
  local iNameHeight = select(2, surface.GetTextSize(string.sub(strName, 1, 1)))

  draw.SimpleTextOutlined(strName,
    "PlayerCardName",
    self.avatar:GetWide()+4,
    iNameHeight,
    color_white,
    TEXT_ALIGN_LEFT,
    TEXT_ALIGN_CENTER,
    1,
    color_black
  )
end

function PANEL:SetSelected(bSelected)
  self.m_bSelected = bSelected

  if(bSelected) then
    --self.avatar:SizeTo(self:GetWide() - 4 - 4, self:GetTall() - 4 - 4, 0.15, 0)
  else
    --self.avatar:SizeTo(self:GetWide(), self:GetTall(), 0.15, 0)
  end

  if(bSelected) then
    self:GetParent():GetParent():GetParent():GetParent():onPlayerSelected(self:getPlayer(), self)
  else
    self:GetParent():GetParent():GetParent():GetParent():onPlayerDeselected(self:getPlayer(), self)
  end
end

PANEL.setSelected = PANEL.SetSelected

function PANEL:IsSelected()
  return self.m_bSelected
end

function PANEL:setPlayer(objPl)
  self.m_objPlayer = objPl
  self.avatar:SetPlayer(objPl, self:GetWide())
  self.m_strUniqueID = objPl:UniqueID()
end

function PANEL:getPlayer()
  return self.m_objPlayer
end

function PANEL:getUniqueID()
  return self.m_strUniqueID
end

function PANEL:DoClick()
  self:SetSelected(not self:IsSelected())
end

function PANEL:SetSize(iWidth, iHeight)
  self.BaseClass.SetSize(self, iWidth, iHeight)
  self.avatar:SetSize(iHeight, iHeight)
end

vgui.Register("MPlayerCard", PANEL, "DButton")
