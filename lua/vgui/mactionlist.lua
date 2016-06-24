local PANEL = {}
PANEL.m_NumSelectedPlayers = 0
PANEL.m_SelectedPlayers = {}

function PANEL:Init()
  self:DockPadding(5, 5, 5, 5)

  local objHeader = vgui.Create("DLabel", self)
  objHeader:Dock(TOP)
  objHeader:SetTextColor(color_black)
  objHeader:SetText("0 players selected")

  local objQuickMenu = vgui.Create("DCollapsibleCategory", self)
  objQuickMenu:SetLabel("Quick-Menu")
  objQuickMenu:Dock(TOP)
  objQuickMenu.Paint = function(self, iWidth, iHeight)
    surface.SetDrawColor(255, 0, 0, 255)
    surface.DrawRect(0, 0, iWidth, iHeight)
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

    local pnlCanvas = self:GetParent()

    for k,v in pairs(tblPlugins) do
      local objThisPlugin = v
      local tblMenu = objThisPlugin["Menu"]
      local objDisplayName = tblMenu["DisplayName"]
      local strText = type(strText) == "function" and objDisplayName() or objDisplayName

      local objPluginButton = vgui.Create("MActionButton")
      objPluginButton:SetText(strText)
      --objPluginButton:SetIcon(tblMenu["Icon"])
      objPluginButton:SetWide(80)
      if(false and tblMenu["Category"] and objPluginButton.Colors[tblMenu["Category"]]) then
        objPluginButton:SetColorScheme(tblMenu["Category"])
      end
      objPluginButton.DoClick = function()
        if(objThisPlugin.onMenuClick) then
          objThisPlugin:onMenuClick(pnlCanvas:getSelectedPlayers())
        end
      end
      objPluginButton.DoRightClick = function()
        if(objThisPlugin.onMenuRightClick) then
          objThisPlugin:onMenuRightClick(pnlCanvas:getSelectedPlayers())
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
  local pnlCanvas = self:GetParent()
  local iNumSelected = pnlCanvas:getNumSelectedPlayers()

  self.m_Header:SetText(iNumSelected.." player"..(iNumSelected ~= 1 and "s" or "").." selected")

  self.m_QuickMenu:SetVisible(false)
  self.m_Menus:SetVisible(iNumSelected > 0)
end

function PANEL:onPlayerSelected(objPl, objCard)
  self:InvalidateLayout()
end

function PANEL:onPlayerDeselected(objPl, objCard)
  self:InvalidateLayout()
end

function PANEL:Paint(iWidth, iHeight)
  surface.SetDrawColor(0, 0, 0)
  surface.DrawOutlinedRect(0, 0, iWidth, iHeight)
end

vgui.Register("MActionList", PANEL, "DPanel")
