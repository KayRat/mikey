local PANEL = {}

function PANEL:Init()
  self:DockMargin(4, 4, 4, 4)

  local objSettings = vgui.Create("MButton", self)
  objSettings:SetText("Settings")
  objSettings:SetIcon("icon16/cog.png")
  objSettings:Dock(LEFT)
  objSettings.DoClick = function(selfButton)
    local objNoFunction = vgui.Create("MModal", self:GetParent():GetParent():GetParent())
    objNoFunction:SetTitle("information")
    objNoFunction:SetSize(150, 90)
    objNoFunction:Center()

    local objText = vgui.Create("DLabel", objNoFunction)
    objText:Dock(FILL)
    objText:SetTextColor(color_black)
    objText:SetWrap(true)
    objText:SetText("this feature is set for a future release. check back soon!")

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

  local objDisguise = vgui.Create("MButton", self)
  objDisguise:SetText("Disguise")
  objDisguise:SetIcon("icon16/find.png")
  objDisguise:Dock(LEFT)
  objDisguise:DockMargin(4, 0, 0, 0)

  self.m_Settings = objSettings
  self.m_Disguise = objDisguise
end

function PANEL:PerformLayout(iWidth, iHeight)
  if(LocalPlayer():hasPermission("disguise")) then
    self.m_Settings:SetWide(iWidth / 2)
    self.m_Settings:Dock(LEFT)
    self.m_Disguise:SetVisible(true)
    self.m_Disguise:Dock(FILL)
  else
    self.m_Disguise:SetVisible(false)
    self.m_Settings:Dock(FILL)
  end
end

function PANEL:Paint(iWidth, iHeight)
end

vgui.Register("MSettings", PANEL, "DPanel")
