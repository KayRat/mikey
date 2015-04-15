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
        ["background"] = Color(190, 190, 190)
    }
}

PANEL.titleBar = {
    ["height"] = 30,
}

function PANEL:Init()
    self:ShowCloseButton(false)

    self.lblTitle:SetFont("MikeDefault")
    self.lblTitle:SetTextColor(color_black)

    -- context button
    do
        self.btnContext = vgui.Create("MTitleButton", self)
        self.btnContext:SetPos(0, 0)
        self.btnContext:SetSize(22, self.titleBar.height)
        self.btnContext:SetText("=")
        self.btnContext:SetColorScheme(self.colors.title.background)
        self.btnContext.DoClick = function(btn) print("Surprise!") end
    end

    -- close button
    do
        self.btnClose = vgui.Create("MTitleButton", self)
        self.btnClose:SetText("X")
        self.btnClose:SetTall(self.titleBar.height-2)
        self.btnClose.DoClick = function(btn) self:Close() end
        self.btnClose:InvertColorOnHover(true)
        self.btnClose.colors = {
            ["normal"] = self.colors.title.background,
            ["hover"] = Color(214, 42, 42),
            ["mouseDown"] = Color(174, 12, 12),
        }
    end

    self:DockPadding(2, self.titleBar.height, 2, 2)
end

function PANEL:PerformLayout()
    self.BaseClass.PerformLayout(self)

    self.btnClose:SetPos(self:GetWide()-self.btnClose:GetWide()-1, 0)

    self.lblTitle:SetPos(32, 4)
end

function PANEL:Paint(w, h)
    if(self.m_bBackgroundBlur) then
        Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
    end

    derma.SkinHook("Paint", "Frame", self, w, h)

    -- frame outline
    surface.SetDrawColor(self.colors.frame.outline)
    surface.DrawOutlinedRect(0, 0, w, h)

    -- frame title bar
    surface.SetDrawColor(self.colors.title.background)
    surface.DrawRect(1, 1, w-2, self.titleBar.height)

    -- frame background
    surface.SetDrawColor(self.colors.frame.background)
    surface.DrawRect(1, self.titleBar.height, w-2, h-self.titleBar.height-2)
end

vgui.Register("MFrame", PANEL, "DFrame")
