local PANEL = {}
PANEL.Colors = {
  ["Normal"]          = Color(125, 125, 235, 255),
  ["Administration"]  = Color(255, 125, 125, 255),
  ["Fun"]             = Color(235, 235, 125, 255),
  ["OnHover"]         = Color(125, 235, 125, 195),
}

for k,v in pairs(PANEL.Colors) do
  local tblNewColor = table.Copy(v)
  tblNewColor = {
    ["r"] = math.Clamp(tblNewColor["r"]+20, 0, 255),
    ["g"] = math.Clamp(tblNewColor["g"]+20, 0, 255),
    ["b"] = math.Clamp(tblNewColor["b"]+20, 0, 255),
  }

  PANEL.Colors[k.."Hover"] = tblNewColor
end

function PANEL:Paint(iWidth, iHeight)
  do -- background
    surface.SetDrawColor(color_black)
    surface.DrawOutlinedRect(0, 0, iWidth, iHeight)

    local objColor = self.Colors.Administration

    if(self:IsHovered()) then
      objColor = self.Colors.AdministrationHover
    end

    surface.SetDrawColor(objColor)
    surface.DrawRect(1, 1, iWidth-2, iHeight-2)
  end
end

vgui.Register("MButton", PANEL, "DButton")
