do -- create fonts
  surface.CreateFont("PlayerCardName", {
    ["font"]      = "DermaDefault",
    ["size"]      = 16,
    ["weight"]    = 600,
    ["antialias"] = true,
    ["outline"]   = false,
  })
end

local iPadding = 10

local PANEL = {}
PANEL.m_Selected = false
PANEL.Colors = {
  ["OnHover"]         = Color(125, 235, 125, 195),
  ["OnSelected"]      = Color(35, 235, 35, 245),
  ["OnHoverSelected"] = Color(35, 235, 35, 245),
  ["NotSelected"]     = color_black,
}

function PANEL:Init()
  self.m_Avatar = vgui.Create("AvatarImage", self)
  self.m_Avatar:SetSize(128, 128)
  self.m_Avatar.DoClick = function(self)
    self:GetParent():DoClick()
  end
  self.m_Avatar.Paint = function(self, iWidth, iHeight)
    surface.SetDrawColor(color_white)
    surface.DrawRect(0, 0, iWidth, iHeight)
  end
  self.m_Avatar.PaintOver = function(self, iWidth, iHeight)
    do -- outline
      if((self:IsHovered() or self:GetParent():IsHovered()) and self:GetParent():IsSelected()) then
        surface.SetDrawColor(self:GetParent().Colors.OnSelected)
      else
        surface.SetDrawColor(self:GetParent().Colors.NotSelected)
      end
      surface.DrawOutlinedRect(0, 0, iWidth, iHeight)
    end

    do -- player details
      local objParent = self:GetParent()
      local objPl = objParent:GetPlayer()
      local iBarHeight = 20

      if(not IsValid(objPl)) then return end

      do -- team bar background
        local objColor = team.GetColor(objPl:Team()) or color_white

        objColor.a = 175

        surface.SetDrawColor(objColor)
        surface.DrawRect(1, iHeight-iBarHeight-1, iWidth-2, iBarHeight)

        surface.SetDrawColor(color_black)
        surface.DrawLine(1, iHeight-iBarHeight-1, iWidth-2, iHeight-iBarHeight-1)
      end

      do -- player name
        local strName = objPl:Nick() or "..."

        draw.SimpleTextOutlined(strName,
          "PlayerCardName",
          4,
          iHeight-iBarHeight+8,
          color_white,
          TEXT_ALIGN_LEFT,
          TEXT_ALIGN_CENTER,
          1,
          color_black
        )

        --[[surface.SetFont("PlayerCardName")
        surface.SetTextColor(color_white)
        surface.SetTextPos(4, iHeight-iBarHeight)
        surface.DrawText(strName)]]
      end
    end
  end

  local objSuperParent = self.m_Avatar

  local objFakeButton = vgui.Create("DButton", self)
  objFakeButton:SetText("")
  objFakeButton:SetPos(0, 0)
  objFakeButton.Paint = function(self, iWidth, iHeight) end
  objFakeButton.DoClick = function(self) objFakeButton:GetParent():DoClick() end

  self.m_FakeButton = objFakeButton
end

function PANEL:PerformLayout(iWidth, iHeight)
  self.m_Avatar:CenterHorizontal()
  local x, y = self.m_Avatar:GetPos()
  self.m_Avatar:SetPos(4, 4)

  self.m_FakeButton:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:Paint(iWidth, iHeight)
  if(not self:IsHovered() and not self:IsChildHovered(6) and not self:IsSelected()) then return end

  if(self:IsHovered() or self:IsChildHovered(6)) then
    surface.SetDrawColor(self.Colors.OnHover)
  end

  if(self:IsSelected()) then
    surface.SetDrawColor(self.Colors.OnSelected)
  end

  if((self:IsHovered() or self:IsChildHovered(6)) and self:IsSelected()) then
    surface.SetDrawColor(self.Colors.OnHoverSelected)
  end

  surface.DrawRect(0, 0, iWidth, iHeight)
end

function PANEL:SetSelected(bSelected)
  self.m_Selected = bSelected
end

function PANEL:IsSelected()
  return self.m_Selected
end

function PANEL:SetPlayer(objPl)
  self.m_Player = objPl
  self.m_Avatar:SetPlayer(objPl, self:GetWide())
end

function PANEL:GetPlayer()
  return self.m_Player
end

function PANEL:DoClick()
  self:SetSelected(not self:IsSelected())
end

vgui.Register("MPlayerCard", PANEL, "DButton")
