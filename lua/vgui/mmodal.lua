local PANEL = {}

function PANEL:Init()
  self:ShowCloseButton(false)
  self:DoModal(true)
  self:DockPadding(4, 4, 4, 4)
end

vgui.Register("MModal", PANEL, "MFrame")
