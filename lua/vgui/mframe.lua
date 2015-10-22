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
    ["background"] = Color(220, 220, 220),
    ["outline"] = Color(80, 80, 80),
  },

  ["title"] = {
    ["background"] = Color(245, 245, 245)
  }
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
    self.btnClose.colors = {
        ["normal"] = self.colors.title.background,
        ["hover"] = Color(214, 42, 42),
        ["mouseDown"] = Color(174, 12, 12),
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

function PANEL:Paint(w, h)
  if(self.m_bBackgroundBlur) then
    Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
  end

  derma.SkinHook("Paint", "Frame", self, w, h)

  -- frame title bar
  surface.SetDrawColor(self.colors.title.background)
  surface.DrawRect(1, 1, w-2, self.titleBar.height)

  -- frame background
  surface.SetDrawColor(self.colors.frame.background)
  surface.DrawRect(1, self.titleBar.height, w-2, h-self.titleBar.height-1)
end

function PANEL:PaintOver(w, h)
  -- frame outline
  surface.SetDrawColor(self.colors.frame.outline)
  surface.DrawOutlinedRect(0, 0, w, h)
end

vgui.Register("MFrame", PANEL, "DFrame")
