local PANEL = {}
PANEL.m_bSelected = false
PANEL.m_tblColors = {
  ["onHover"]         = mikey.colors.alt,
  ["onSelected"]      = mikey.colors.secondary,
  ["onHoverSelected"] = mikey.colors.alt2,
  ["notSelected"]     = color_black,
}

function PANEL:Init()
  self.m_pnlAvatar = vgui.Create("AvatarImage", self)
  self.m_pnlAvatar:SetSize(128, 128)
  self.m_pnlAvatar.DoClick = function(self)
    self:GetParent():DoClick()
  end
  self.m_pnlAvatar.Paint = function(self, iWidth, iHeight)
    surface.SetDrawColor(color_white)
    surface.DrawRect(0, 0, iWidth, iHeight)
  end
  self.m_pnlAvatar.PaintOver = function(self, iWidth, iHeight)
    do -- outline
      if((self:IsHovered() or self:GetParent():IsHovered()) and self:GetParent():IsSelected()) then
        surface.SetDrawColor(self:GetParent().m_tblColors.onSelected)
      else
        surface.SetDrawColor(self:GetParent().m_tblColors.notSelected)
      end
      surface.DrawOutlinedRect(0, 0, iWidth, iHeight)
    end

    do -- player details
      local objParent = self:GetParent()
      local objPl = objParent:getPlayer()
      local iBarHeight = 20

      if(not IsValid(objPl)) then return end

      do -- team bar background
        local objColor = team.GetColor(objPl:Team()) or color_white

        objColor.a = 175

        surface.SetDrawColor(objColor)
        surface.DrawRect(1, iHeight-iBarHeight-1, iWidth-2, iBarHeight)

        surface.SetDrawColor(color_black)
        surface.DrawLine(0, iHeight-iBarHeight-1, iWidth-1, iHeight-iBarHeight-1)
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

  local objSuperParent = self.m_pnlAvatar

  local objFakeButton = vgui.Create("DButton", self)
  objFakeButton:SetText("")
  objFakeButton:SetPos(0, 0)
  objFakeButton.Paint = function(self, iWidth, iHeight) return end
  objFakeButton.DoClick = function(self) objFakeButton:GetParent():DoClick() end

  self.m_pnlFakeButton = objFakeButton
end

function PANEL:PerformLayout(iWidth, iHeight)
  self.m_pnlAvatar:CenterHorizontal()
  local x, y = self.m_pnlAvatar:GetPos()
  self.m_pnlAvatar:SetPos(4, 4)

  self.m_pnlFakeButton:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:Paint(iWidth, iHeight)
  if(not self:IsHovered() and not self:IsChildHovered(6) and not self:IsSelected()) then return end

  if(self:IsHovered() or self:IsChildHovered(6)) then
    surface.SetDrawColor(self.m_tblColors.onHover)
  end

  if(self:IsSelected()) then
    surface.SetDrawColor(self.m_tblColors.onSelected)
  end

  if((self:IsHovered() or self:IsChildHovered(6)) and self:IsSelected()) then
    surface.SetDrawColor(self.m_tblColors.onHoverSelected)
  end

  surface.DrawRect(0, 0, iWidth, iHeight)
end

function PANEL:SetSelected(bSelected)
  self.m_bSelected = bSelected

  if(bSelected) then
    self:GetParent():GetParent():GetParent():GetParent():onPlayerSelected(self:getPlayer(), self)
  else
    self:GetParent():GetParent():GetParent():GetParent():onPlayerDeselected(self:getPlayer(), self)
  end
end

PANEL.setSelected = PANEL.SetSelected

function PANEL:IsSelected()
  return self.m_bSelected
end

function PANEL:SetPlayer(objPl)
  self.m_objPlayer = objPl
  self.m_pnlAvatar:SetPlayer(objPl, self:GetWide())
  self.m_strUniqueID = objPl:UniqueID()
end

function PANEL:getPlayer()
  return self.m_objPlayer
end

function PANEL:getUniqueID()
  return self.m_strUniqueID
end

function PANEL:DoClick()
  self:SetSelected(not self:IsSelected())
end

vgui.Register("MPlayerCard", PANEL, "DButton")
