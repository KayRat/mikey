local PANEL = {}

function PANEL:Init()
  local objSettings = vgui.Create("MButton", self)
  objSettings:SetText("Settings")
  objSettings:Dock(FILL)
  objSettings.DoClick = function(selfButton)
    local objNoFunction = vgui.Create("MModal", self:GetParent():GetParent())
    objNoFunction:SetTitle("information")
    objNoFunction:SetSize(150, 90)
    objNoFunction:Center()

    local objText = vgui.Create("DLabel", objNoFunction)
    objText:Dock(FILL)
    objText:SetTextColor(color_black)
    objText:SetWrap(true)
    objText:SetText("this feature is set for a feature release. check back soon!")

    local objClose = vgui.Create("MButton", objNoFunction)
    objClose:SetText("Close")
    objClose.DoClick = function(selfButton)
      objNoFunction:Close()
    end
    objClose:Dock(BOTTOM)

    self.m_Text = objText
    self.m_CloseButton = objClose

    objNoFunction:MakePopup()
  end

  self.m_Settings = objSettings
end

function PANEL:Paint(iWidth, iHeight)
  surface.SetDrawColor(0, 0, 0, 255)
  surface.DrawOutlinedRect(0, 0, iWidth, iHeight)
end

vgui.Register("MSettings", PANEL, "DPanel")
