local PANEL = {}

function PANEL:Initialize()
	self:SetText("")
end

vgui.Register("MIconButton", PANEL, "MButton")
