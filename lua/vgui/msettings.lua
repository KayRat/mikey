local PANEL = {}

function PANEL:Init()
  local objSettings = vgui.Create("MButton", self)
  objSettings:SetText("Settings")
  objSettings:Dock(FILL)
  objSettings.DoClick = function(selfButton)
    local objNoFunction = vgui.Create("MModal", self:GetParent():GetParent())
    objNoFunction:SetSize(150, 100)
    objNoFunction:Center()
    objNoFunction:SetText("mikey settings aren't implemented yet! give us time!")
    objNoFunction:MakePopup()
  end

  self.m_Settings = objSettings
end

function PANEL:Paint(w, h)
  surface.SetDrawColor(0, 0, 0, 255)
  surface.DrawOutlinedRect(0, 0, w, h)
end

vgui.Register("MSettings", PANEL, "DPanel")
