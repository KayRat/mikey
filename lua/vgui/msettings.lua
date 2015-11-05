local PANEL = {}

function PANEL:Init()
  local objSettings = vgui.Create("MButton", self)
  objSettings:SetText("Settings")
  objSettings:Dock(FILL)
  objSettings.DoClick = function(selfButton)
    local objNoFunction = vgui.Create("MModal", self:GetParent():GetParent())
    objNoFunction:SetSize(150, 90)
    objNoFunction:Center()
    objNoFunction:SetText("mikey settings aren't implemented yet! give us time!")
    objNoFunction:MakePopup()
  end

  self.m_Settings = objSettings
end

function PANEL:Paint(iWidth, iHeight)
  surface.SetDrawColor(0, 0, 0, 255)
  surface.DrawOutlinedRect(0, 0, iWidth, iHeight)
end

vgui.Register("MSettings", PANEL, "DPanel")
