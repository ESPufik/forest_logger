local PLUGIN = PLUGIN

PLUGIN.progressBars = {}

function PLUGIN:HUDPaint()
    for ply, data in pairs(self.progressBars) do
        if not IsValid(ply) then continue end
        if ply ~= LocalPlayer() then continue end

        local w, h = 300, 30
        local x, y = ScrW() / 2 - w / 2, ScrH() * 0.8

        local frac = math.Clamp((CurTime() - data.start) / data.duration, 0, 1)
        local barWidth = w * frac

        draw.RoundedBox(6, x, y, w, h, Color(50, 50, 50, 200))
        draw.RoundedBox(6, x + 2, y + 2, barWidth - 4, h - 4, Color(120, 180, 75, 255))

        draw.SimpleText("Рубка дерева...", "DermaDefaultBold", x + w / 2, y + h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

net.Receive("ixLumber_StartProgress", function()
    local duration = net.ReadFloat()
    PLUGIN.progressBars[LocalPlayer()] = {
        start = CurTime(),
        duration = duration
    }
end)

net.Receive("ixLumber_EndProgress", function()
    PLUGIN.progressBars[LocalPlayer()] = nil
end)
