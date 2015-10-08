local PANEL = {}

function PANEL:Init()
  local pnlIconLayout = vgui.Create("DIconLayout", self)
  pnlIconLayout:DockMargin(1, 1, 1, 1)
  pnlIconLayout:DockPadding(5, 5, 5, 5)
  pnlIconLayout:Dock(FILL)
  pnlIconLayout:SetSpaceX(5)
  pnlIconLayout:SetSpaceY(5)
  pnlIconLayout.Paint = function(self, w, h)
    surface.SetDrawColor(255, 255, 255)
    surface.DrawRect(0, 0, w, h)
  end

  self.m_pnlIconLayout = pnlIconLayout
end

function PANEL:InvalidateLayout()
  local pnlPlayer
  local iCardWidth, iCardHeight = 100, 128

  for k,v in pairs(player.GetAll()) do
    pnlPlayer = self.m_pnlIconLayout:Add("MPlayerCard")
    pnlPlayer:SetSize(iCardWidth, iCardHeight)
    pnlPlayer:SetPlayer(v)
  end
end

function PANEL:Paint(w, h)
  surface.SetDrawColor(0, 0, 0)
  surface.DrawOutlinedRect(0, 0, w, h)

  surface.SetDrawColor(0, 255, 0, 155)
  surface.DrawRect(1, 1, w-2, h-2)
end

vgui.Register("MPlayerList", PANEL, "DScrollPanel")
