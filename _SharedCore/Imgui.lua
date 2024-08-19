--/////////////////////////////////////--
-- Imgui LUA

-- Author: SilverEzredes
-- Updated: 04/07/2024
-- Version: v1.0.2
-- Special Thanks to: praydog; alphaZomega;

--/////////////////////////////////////--
local func = require("_SharedCore\\Functions")

local function button_n_colored_txt(label, text, color)
    imgui.button(label)
    imgui.same_line()
    imgui.text_colored(text, color)
    func.tooltip("Green = Stable | Orange = Mostly Stable | Red = Unstable")
end

local function draw_line(char, n)
    return string.rep(char, n)
end

local function table_vec(func, name, value, args)
    changed, value = func(name, _G["Vector"..#value.."f"].new(table.unpack(value)), table.unpack(args or {}))
    value = {value.x, value.y, value.z, value.w} --convert back to table
    return changed, value
end  

local function tree_node_colored(key, white_text, color_text, color)
	local output = imgui.tree_node_str_id(key or 'a', white_text or "")
	imgui.same_line()
	imgui.text_colored(color_text or "", color or 0xFFE0853D)
	return output
end

ui = {
    button_n_colored_txt = button_n_colored_txt,
    draw_line = draw_line,
	table_vec = table_vec,
	tree_node_colored = tree_node_colored,
}

return ui
