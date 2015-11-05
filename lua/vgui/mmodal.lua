local PANEL = {}

function PANEL:Init()
  self:ShowCloseButton(false)
  self:DoModal(true)
  self:SetTitle("Alert")
  self:DockPadding(4, 4, 4, 4)
  self:DockMargin(5, 5, 5, 5)

  local objText = vgui.Create("DLabel", self)
  objText:Dock(FILL)
  objText:SetTextColor(color_black)
  objText:SetWrap(true)

  local objClose = vgui.Create("MButton", self)
  objClose:SetText("Close")
  objClose.DoClick = function(selfButton)
    self:Close()
  end
  objClose:Dock(BOTTOM)

  self.m_Text = objText
  self.m_CloseButton = objClose
end

function PANEL:SetText(strText)
  self.m_Text:SetText(strText)
end

function PANEL:PerformLayout(iWidth, iHeight)
end

vgui.Register("MModal", PANEL, "MFrame")
