local PANEL = {}

function PANEL:Init()
  local pnlIconLayout = vgui.Create("DIconLayout", self)
  pnlIconLayout:DockMargin(5, 5, 5, 5)
  --pnlIconLayout:DockPadding(5, 5, 5, 5)
  pnlIconLayout:Dock(TOP)
  pnlIconLayout:SetSpaceX(4)
  pnlIconLayout:SetSpaceY(4)

  self.m_pnlIconLayout = pnlIconLayout
end

function PANEL:PerformLayout(iWidth, iHeight)
  self.BaseClass.PerformLayout(self, iWidth, iHeight)

  if(not self.VBar.Enabled) then
    self.VBar:SetEnabled(true)
  end
end

function PANEL:CreatePlayerList()
  for k,v in pairs(player.GetAll()) do
    self:AddPlayerCard(v)
  end
end

function PANEL:AddPlayerCard(objPl)
  local iCardWidth, iCardHeight = 136, 136

  local pnl = self.m_pnlIconLayout:Add("MPlayerCard")
  pnl:SetSize(iCardWidth, iCardHeight)
  pnl:SetPlayer(objPl)
  --pnl:SetSelected(true)
end

function PANEL:Paint(w, h)
  surface.SetDrawColor(0, 0, 0)
  surface.DrawOutlinedRect(0, 0, w, h)

  --[[surface.SetDrawColor(0, 255, 0, 155)
  surface.DrawRect(1, 1, w-2, h-2)]]
end

vgui.Register("MPlayerGrid", PANEL, "DScrollPanel")
