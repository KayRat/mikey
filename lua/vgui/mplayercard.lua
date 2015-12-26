local PANEL = {}
PANEL.m_bSelected = false
PANEL.m_tblColors = {
  ["onHover"]         = mikey.colors.alt,
  ["onSelected"]      = mikey.colors.secondary,
  ["onHoverSelected"] = mikey.colors.alt2,
  ["notSelected"]     = color_black,
}

function PANEL:Init()
  self.avatar = vgui.Create("AvatarImage", self)
  self.avatar.DoClick = function(self)
    self:GetParent():DoClick()
  end
  self.avatar.PerformLayout = function(self, iWidth, iHeight)
    self:CenterVertical()
    self:CenterHorizontal()
  end
  self.avatar.Paint = function(self, iWidth, iHeight)
    surface.SetDrawColor(color_white)
    surface.DrawRect(0, 0, iWidth, iHeight)
  end
  self.avatar.PaintOver = function(self, iWidth, iHeight)
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

  local objFakeButton = vgui.Create("DButton", self)
  objFakeButton:SetText("")
  objFakeButton:SetPos(0, 0)
  objFakeButton.Paint = function(self, iWidth, iHeight) return end
  objFakeButton.DoClick = function(self) objFakeButton:GetParent():DoClick() end

  self.m_pnlFakeButton = objFakeButton
end

function PANEL:PerformLayout(iWidth, iHeight)
  self.m_pnlFakeButton:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:Paint(iWidth, iHeight)
  if(not self:IsHovered() and not self:IsChildHovered(6) and not self:IsSelected()) then return end

  if(self:IsSelected() or self.avatar:GetWide() ~= self:GetWide()) then
    surface.SetDrawColor(self.m_tblColors.onSelected)
    surface.DrawRect(0, 0, iWidth, iHeight)
  end
end

function PANEL:SetSelected(bSelected)
  self.m_bSelected = bSelected

  if(bSelected) then
    self.avatar:SizeTo(self:GetWide() - 4 - 4, self:GetTall() - 4 - 4, 0.15, 0)
  else
    self.avatar:SizeTo(self:GetWide(), self:GetTall(), 0.15, 0)
  end

  if(bSelected) then
    self:GetParent():GetParent():GetParent():GetParent():onPlayerSelected(self:getPlayer(), self)
  else
    self:GetParent():GetParent():GetParent():GetParent():onPlayerDeselected(self:getPlayer(), self)
  end
end

--PANEL.setSelected = PANEL.SetSelected

function PANEL:IsSelected()
  return self.m_bSelected
end

function PANEL:setPlayer(objPl)
  self.m_objPlayer = objPl
  self.avatar:SetPlayer(objPl, self:GetWide())
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

function PANEL:SetSize(iWidth, iHeight)
  self.BaseClass.SetSize(self, iWidth, iHeight)
  self.avatar:SetSize(iWidth, iHeight)
end

vgui.Register("MPlayerCard", PANEL, "DButton")
