local PANEL = {}
PANEL.m_NumSelectedPlayers = 0
PANEL.m_SelectedPlayers = {}

function PANEL:Init()
  self:DockPadding(5, 5, 5, 5)

  local objHeader = vgui.Create("DLabel", self)
  objHeader:Dock(TOP)
  objHeader:SetTextColor(color_black)
  objHeader:SetText("0 players selected")

  if(false) then
    local objQuickMenu = vgui.Create("DCollapsibleCategory", self)
    objQuickMenu:SetLabel("Quick-Menu")
    objQuickMenu:Dock(TOP)
    objQuickMenu.Paint = function(self, iWidth, iHeight)
      surface.SetDrawColor(255, 0, 0, 255)
      surface.DrawRect(0, 0, iWidth, iHeight)
    end
  end

  local objMenu = vgui.Create("DPanel", self)
  objMenu.Paint = function(self, iWidth, iHeight) end
  objMenu:Dock(FILL)

  for k,v in pairs(mikey.menu.category) do
    local tblPlugins = mikey.plugins.getAll(v)
    table.sort(tblPlugins, function(a, b)
      return a["Menu"]["DisplayName"] > b["Menu"]["DisplayName"]
    end)

    local objMenuCat = vgui.Create("DIconLayout")
    objMenuCat:Dock(TOP)
    --objMenuCat:DockPadding(5, 5, 5, 5)
    objMenuCat.Paint = function(self, iWidth, iHeight)
      surface.SetDrawColor(0, 255, 255, 255)
      --surface.DrawRect(0, 0, iWidth, iHeight)
    end

    local objCatTitle = vgui.Create("DLabel", objMenuCat)
    objCatTitle:SetText(v)
    objCatTitle:SetTextColor(color_black)
    objCatTitle:Dock(TOP)

    for k,v in pairs(tblPlugins) do
      local objThisPlugin = v
      local tblMenu = objThisPlugin["Menu"]
      local objDisplayName = tblMenu["DisplayName"]
      local strText = type(strText) == "function" and objDisplayName() or objDisplayName

      local objPluginButton = vgui.Create("MButton")
      objPluginButton:SetText(strText)
      objPluginButton:SetIcon(tblMenu["Icon"])
      objPluginButton:SetWide(80)
      if(tblMenu["Category"] and objPluginButton.Colors[tblMenu["Category"]]) then
        objPluginButton:SetColorScheme(tblMenu["Category"])
      end
      objPluginButton.DoClick = function()
        if(objThisPlugin.onMenuClick) then
          objThisPlugin:onMenuClick(self.m_SelectedPlayers)
        end
      end
      objPluginButton.DoRightClick = function()
        if(objThisPlugin.onMenuRightClick) then
          objThisPlugin:onMenuRightClick(self.m_SelectedPlayers)
        end
      end

      objMenuCat:Add(objPluginButton)
    end

    -- TODO: add buttons for plugins in this category
    objMenu:Add(objMenuCat)
  end

  self.m_Header = objHeader
  self.m_QuickMenu = objQuickMenu
  self.m_Menus = objMenu
end

function PANEL:PerformLayout(iWidth, iHeight)
  local iNumSelected = self.m_NumSelectedPlayers

  self.m_Header:SetText(iNumSelected.." player"..(iNumSelected ~= 1 and "s" or "").." selected")

  self.m_Menus:SetVisible(iNumSelected > 0)
end

function PANEL:OnPlayerSelected(objPl, objCard)
  self.m_SelectedPlayers[objPl:UniqueID()] = objPl
  self.m_NumSelectedPlayers = self.m_NumSelectedPlayers + 1
  self:InvalidateLayout()
end

function PANEL:OnPlayerDeselected(objPl, objCard)
  self.m_SelectedPlayers[objPl:UniqueID()] = nil
  self.m_NumSelectedPlayers = self.m_NumSelectedPlayers - 1
  self:InvalidateLayout()
end

function PANEL:Paint(iWidth, iHeight)
  surface.SetDrawColor(0, 0, 0)
  surface.DrawOutlinedRect(0, 0, iWidth, iHeight)
end

vgui.Register("MActionList", PANEL, "DPanel")
