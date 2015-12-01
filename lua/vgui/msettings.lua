local PANEL = {}

function PANEL:Init()
  local objSettings = vgui.Create("MButton", self)
  objSettings:SetText("Settings")
  objSettings:SetIcon("icon16/cog.png")
  objSettings:Dock(LEFT)
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

function PANEL:InvalidateLayout()
  if(LocalPlayer():IsAdmin()) then
    local objDisguise = vgui.Create("MButton", self)
    objDisguise:SetText("Disguise")
    objDisguise:SetIcon("icon16/status_online.png")
    objDisguise:Dock(LEFT)
    objDisguise:DockMargin(2, 0, 0, 0)

    self.m_Disguise = objDisguise
  else
    if(self.m_Disguise) then
      self.m_Disguise:Remove()
    end
  end
end

function PANEL:PerformLayout(iWidth, iHeight)
  if(self.m_Disguise) then
    local iHalfsies = iWidth/2-1
    self.m_Settings:SetWidth(iHalfsies)
    self.m_Disguise:SetWidth(iHalfsies)
  else
    self.m_Settings:SetWidth(iWidth)
  end
end

function PANEL:Paint(iWidth, iHeight)
end

vgui.Register("MSettings", PANEL, "DPanel")
