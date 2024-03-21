--/////////////////////////////////////--
-- Imgui LUA

-- Author: SilverEzredes
-- Updated: 03/04/2024
-- Version: v1.0.1
-- Special Thanks to: praydog; alphaZomega

--/////////////////////////////////////--
local DEBUG = false
local func = require("_SharedCore/Functions")
--TODO
local function manual_slider(label, value)
    imgui.button(label)
    imgui.same_line()
    imgui.button("-")
    imgui.same_line()
    imgui.button(value)
    imgui.same_line()
    imgui.button("+")
end
--TODO
local function progress_bar(label, level, percentage)
    imgui.begin_rect()
    imgui.button(label)
    imgui.text("LVL:")
    imgui.same_line()
    imgui.text(level)
    imgui.same_line()
    imgui.text(percentage .. "%")
    imgui.text("[ " .. "//////////////////////////////////////////////////" .. " ]")
    imgui.text("[ " .. "============================================" .. " ]")
end

local function button_n_colored_txt(label, text, color)
    imgui.button(label)
    imgui.same_line()
    imgui.text_colored(text, color)
    func.tooltip("Green = Stable | Orange = Mostly Stable | Red = Unstable")
end

local function utf16(charid)
    return imgui.load_font("NotoSansJP-Regular.otf", utf8.char(charid))
end
--TODO
re.on_draw_ui(function()
	if DEBUG and imgui.tree_node("[IMGUI DEBUG]") then
        imgui.begin_rect()
        
        manual_slider("Lorem Ipsum Borpsum", 10.0)
        progress_bar("YEEEET", 7, 69.420)
        button_n_colored_txt("BOOOORPAAA:", "Version", 0xFF00FF00)

        imgui.end_rect(1)
        imgui.tree_pop()
    end
end)

ui = {
    button_n_colored_txt = button_n_colored_txt,
}

return ui
