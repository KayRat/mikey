local PANEL = {}

function PANEL:Init()
  self:ShowCloseButton(false)
  self:DoModal(true)
end

vgui.Register("MModal", PANEL, "MFrame")
