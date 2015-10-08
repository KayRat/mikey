local iPadding = 10

local PANEL = {}
PANEL.m_Selected = false

function PANEL:Init()
  self.m_Avatar = vgui.Create("AvatarImage", self)
  self.m_Avatar:SetSize(64, 64)
  self.m_Avatar.PaintOver = function(self, iWidth, iHeight)
  end

  self.m_PlayerName = vgui.Create("DLabel", self)
  self.m_PlayerName:SetColor(color_black)
  self.m_PlayerName:SetWrap(true)
end

function PANEL:PerformLayout(iWidth, iHeight)
  self.m_Avatar:CenterHorizontal()
  local x, y = self.m_Avatar:GetPos()
  self.m_Avatar:SetPos(2, 2)

  self.m_PlayerName:SetSize(iWidth-(iPadding*2), 25)
  self.m_PlayerName:SetPos(0, y + self.m_Avatar:GetTall() + 5)
  self.m_PlayerName:CenterHorizontal()
end

function PANEL:Paint(w, h)
  surface.SetDrawColor(0, 255, 255, 155)
  surface.DrawRect(0, 0, w, h)
end

function PANEL:SetSelected(bSelected)
  self.m_Selected = bSelected
end

function PANEL:IsSelected()
  return self.m_Selected
end

function PANEL:SetPlayer(objPl)
  self.m_Player = objPl
  self.m_Avatar:SetPlayer(objPl, self:GetWide())
  self.m_PlayerName:SetText(objPl:Nick())
end

function PANEL:GetPlayer()
  return self.m_Player
end

vgui.Register("MPlayerCard", PANEL, "DPanel")
