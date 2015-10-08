local PANEL = {}

function PANEL:Init()
end

function PANEL:Paint(w, h)
  surface.SetDrawColor(0, 0, 255, 155)
  surface.DrawRect(1, 1, w-1, h-2)
end

vgui.Register("MActionList", PANEL, "DPanel")
