local PANEL = {}
PANEL.Colors = {
  ["Normal"]          = mikey.colors.alt,
  ["Administration"]  = Color(255, 125, 125, 255),
  ["Fun"]             = Color(235, 235, 125, 255),
  ["OnHover"]         = Color(125, 235, 125, 195),
}
PANEL.m_Scheme = "Normal"

for k,v in pairs(PANEL.Colors) do
  local tblNewColor = table.Copy(v)
  tblNewColor = {
    ["r"] = math.Clamp(tblNewColor["r"]+20, 0, 255),
    ["g"] = math.Clamp(tblNewColor["g"]+20, 0, 255),
    ["b"] = math.Clamp(tblNewColor["b"]+20, 0, 255),
  }

  PANEL.Colors[k.."Hover"] = tblNewColor
end

local objTextNormal     = color_black
local objTextDepressed  = Color(95, 95, 95, 255)

function PANEL:Init()
  self:SetFont("MButtonDefault")
end

function PANEL:PerformLayout(iWidth, iHeight)
  self.BaseClass.PerformLayout(self, iWidth, iHeight)
  self:SetTextColor(self.Depressed and objTextDepressed or objTextNormal)
end

function PANEL:SetColorScheme(strScheme)
  self.m_Scheme = strScheme
end

function PANEL:GetColorScheme()
  return self.m_Scheme
end

function PANEL:Paint(iWidth, iHeight)
  do -- background
    surface.SetDrawColor(color_black)
    surface.DrawOutlinedRect(0, 0, iWidth, iHeight)

    local objColor = self.Colors[self:GetColorScheme()]

    if(self:IsHovered()) then
      objColor = self.Colors[self:GetColorScheme().."Hover"]
    end

    surface.SetDrawColor(objColor)
    surface.DrawRect(1, 1, iWidth-2, iHeight-2)
  end
end

vgui.Register("MButton", PANEL, "DButton")
