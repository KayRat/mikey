local PANEL = {}
PANEL.colors = {
  ["normal"] = {
    ["outline"] = Color(90, 90, 90, 255),
    ["fill"]    = color_black,
  },

  ["hover"] = {
    ["outline"] = Color(125, 125, 125, 255),
    ["fill"]    = color_black,
  }
}

function PANEL:PerformLayout(iWidth, iHeight)
  self.BaseClass.PerformLayout(self, iWidth, iHeight)
  self.BaseClass.SetText(self, "")
end

function PANEL:GetText()
  return self.m_strText or "na"
end

function PANEL:SetText(strText)
  self.m_strText = strText
end

function PANEL:Paint(iWidth, iHeight)
  local bHovered = self:IsHovered()
  surface.SetDrawColor(self.colors[(bHovered and "hover" or "normal")].outline)
  surface.DrawRect(0, 0, iWidth, iHeight)

  surface.SetDrawColor(self.colors[(bHovered and "hover" or "normal")].fill)
  surface.DrawRect(3, 3, iWidth-6, iHeight-6)

  do -- text
    surface.SetTextColor(color_white)
    surface.SetFont("MSmallTextBold")
    local iTextW, iTextH = surface.GetTextSize(self:GetText())
    surface.SetTextPos(iWidth/2-iTextW, iHeight/2-iTextH/2)
    surface.DrawText(self:GetText())
  end
end

vgui.Register("MActionButton", PANEL, "DButton")
