local PANEL = {}

function PANEL:Init()
  self:DockPadding(4, 20, 4, 4)
  self:ShowCloseButton(false)
  self:DoModal(true)
end

vgui.Register("MModal", PANEL, "MFrame")
