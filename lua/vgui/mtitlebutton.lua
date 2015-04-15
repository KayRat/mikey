local PANEL = {}

function PANEL:Init()
    self:SetTextColor(color_black)
    self:SetFont("MikeTitleControls")

    self.colors = {}
end

function PANEL:SetColorScheme(objBaseColor)
    self.colors.normal = objBaseColor
    self.colors.hover = Color(objBaseColor.r-30, objBaseColor.g-30, objBaseColor.b-30)
    self.colors.mouseDown = Color(self.colors.hover.r-30, self.colors.hover.g-30, self.colors.hover.b-30)
end

function PANEL:InvertColorOnHover(bInvert)
    self.invertColor = bInvert
end

function PANEL:OnCursorEntered()
    self.mouseInside = true

    if(self.invertColor) then
        self:SetTextColor(color_white)
    end

    self.BaseClass.OnCursorEntered(self)
end

function PANEL:OnCursorExited()
    self.mouseInside = false

    if(self.invertColor) then
        self:SetTextColor(color_black)
    end

    self.BaseClass.OnCursorExited(self)
end

function PANEL:OnMousePressed(objMouseCode)
    self.mouseDown = true

    self.BaseClass.OnMousePressed(self, objMouseCode)
end

function PANEL:OnMouseReleased(objMouseCode)
    self.mouseDown = false

    self.BaseClass.OnMouseReleased(self, objMouseCode)
end

function PANEL:Paint(w, h)
    if(self.mouseDown) then
        surface.SetDrawColor(self.colors.mouseDown)
    elseif(self.mouseInside) then
        surface.SetDrawColor(self.colors.hover)
    else
        surface.SetDrawColor(self.colors.normal)
    end

    surface.DrawRect(1, 1, w-1, h-1)
end

vgui.Register("MTitleButton", PANEL, "DButton")
