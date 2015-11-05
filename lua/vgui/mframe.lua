surface.CreateFont("MikeDefault", {
  ["font"] = "DermaDefault",
  ["size"] = 16,
  ["weight"] = 500,
  ["rotary"] = false,
})

surface.CreateFont("MikeDefaultBold", {
  ["font"] = "MikeDefault",
  ["weight"] = 700,
})

surface.CreateFont("MikeTitleControls", {
  ["font"] = "MikeDefaultBold",
  ["size"] = 18,
  ["weight"] = 900,
})

local PANEL = {}

PANEL.colors = {
  ["frame"] = {
    ["background"] = Color(220, 220, 220, 255),
    ["outline"] = Color(50, 50, 50, 255),
  },
}

PANEL.titleBar = {
  ["height"] = 20,
}

function PANEL:Init()
  self:ShowCloseButton(false)

  self.lblTitle:SetFont("MikeDefault")
  self.lblTitle:SetTextColor(color_black)

  -- close button
  do
    self.btnClose = vgui.Create("MTitleButton", self)
    self.btnClose:SetText("X")
    self.btnClose.DoClick = function(btn) self:Close() end
    self.btnClose:SetInvertColorOnHover(true)
    local objDarker = utils.darkenColor(mikey.colors.menus.secondary)
    self.btnClose.colors = {
        ["normal"] = mikey.colors.menus.primary,
        ["hover"] = objDarker,
        ["mouseDown"] = utils.darkenColor(objDarker),
    }
  end

  self:DockPadding(2, self.titleBar.height, 2, 2)
end

function PANEL:PerformLayout(iWidth, iHeight)
  self.BaseClass.PerformLayout(self)

  self.btnClose:SetPos(iWidth-self.btnClose:GetWide()-1, 0)

  self.lblTitle:SetPos(5, 0)

  self.btnClose:SetSize(40, self.titleBar.height)
  self.btnClose:SetPos(iWidth-self.btnClose:GetWide()-1, 0)
end

function PANEL:Paint(iWidth, iHeight)
  if(self.m_bBackgroundBlur) then
    Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
  end

  derma.SkinHook("Paint", "Frame", self, iWidth, iHeight)

  -- frame title bar
  surface.SetDrawColor(mikey.colors.menus.primary)
  surface.DrawRect(1, 1, iWidth-2, self.titleBar.height)

  surface.SetDrawColor(color_black)
  surface.DrawLine(1, self.titleBar.height, iWidth-2, self.titleBar.height+1)

  -- frame background
  surface.SetDrawColor(self.colors.frame.background)
  surface.DrawRect(1, self.titleBar.height, iWidth-2, iHeight-self.titleBar.height-1)
end

function PANEL:PaintOver(iWidth, iHeight)
  -- title bar underline
  surface.SetDrawColor(color_black)
  surface.DrawLine(1, self.titleBar.height, iWidth-2, self.titleBar.height)

  -- frame outline
  surface.SetDrawColor(self.colors.frame.outline)
  surface.DrawOutlinedRect(0, 0, iWidth, iHeight)
end

vgui.Register("MFrame", PANEL, "DFrame")
