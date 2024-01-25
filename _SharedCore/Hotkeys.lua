--'Hotkeys' REFramework lua script
--By alphaZomega
--v1.2.0 August 14, 2023
--Manage custom hotkeys across scripts

local kb
local mouse
local pad

local kb_state = { down = {}, released = {},}
local gp_state = { down = {}, released = {},}
local mb_state = { down = {}, released = {},}
local modifiers = {}
local temp_data = {}

--Merge hashed dictionaries. table_b will be merged into table_a
local function merge_tables(table_a, table_b, no_overwrite)
	table_a = table_a or {}
	table_b = table_b or {}
	if no_overwrite then 
		for key_b, value_b in pairs(table_b) do 
			if table_a[key_b] == nil then
				table_a[key_b] = value_b 
			end
		end
	else
		for key_b, value_b in pairs(table_b) do table_a[key_b] = value_b end
	end
	return table_a
end

--Gets an enum
local function generate_statics(typename)
	local t = sdk.find_type_definition(typename)
    local fields = t:get_fields()
    local enum = {}
	local names = {}
    for i, field in ipairs(fields) do
        if field:is_static() then
            local raw_value = field:get_data(nil)
			if raw_value ~= nil then
				local name = field:get_name()
				enum[name] = raw_value 
				table.insert(names, name)
			end
        end
    end
    return enum, names
end

local hotkeys = {}
local default_hotkeys = {}
local backup_hotkeys = {}
local hotkeys_down = {}
local hotkeys_up = {}
local hotkeys_trig = {}

local keys = generate_statics("via.hid.KeyboardKey")
local buttons = generate_statics("via.hid.GamePadButton")
local mbuttons = generate_statics("via.hid.MouseButton")
keys.DefinedEnter = nil
keys.Shift = nil
keys.LAlt, keys.RAlt, keys.Alt = keys.LMenu, keys.RMenu, keys.Menu
keys.LMenu, keys.RMenu, keys.Menu = nil
mbuttons.NONE = nil
mbuttons["R Mouse"] = mbuttons.R
mbuttons["L Mouse"] = mbuttons.L
mbuttons["M Mouse"] = mbuttons.C
mbuttons.R, mbuttons.L, mbuttons.C = nil
buttons.None = nil
buttons.RDown = 131104
buttons.RRight = 262272
buttons.Select = buttons.CLeft
buttons.Start = buttons.CRight 
buttons["X (Square)"] = buttons.RLeft
buttons["Y (Triangle)"] = buttons.RUp
buttons["A (X)"] = buttons.RDown
buttons["B (Circle)"] = buttons.RRight
buttons["RB (R1)"] = buttons.RTrigTop
buttons["RT (R2)"] = buttons.RTrigBottom
buttons["LB (L1)"] = buttons.LTrigTop
buttons["LT (L2)"] = buttons.LTrigBottom
buttons.LTrigTop, buttons.RTrigTop, buttons.RTrigBottom, buttons.LTrigBottom = nil
buttons.CLeft, buttons.CRight, buttons.RLeft, buttons.RUp, buttons.RDown, buttons.RRight, buttons.Cancel = nil

local function setup_active_keys_tbl()
	kb_state.down = {}
	kb_state.released = {}
	kb_state.triggered = {}
	mb_state.down = {}
	mb_state.released = {}
	mb_state.triggered = {}
	gp_state.down = {}
	gp_state.released = {}
	gp_state.triggered = {}
	
	for action_name, key_name in pairs(hotkeys) do
		if buttons[key_name] ~= nil then
			gp_state.down[buttons[key_name] ] = false
			gp_state.released[buttons[key_name] ] = false
			gp_state.triggered[buttons[key_name] ] = false
		end 
		if keys[key_name] ~= nil then
			kb_state.down[keys[key_name] ] = false
			kb_state.released[keys[key_name] ] = false
			kb_state.triggered[keys[key_name] ] = false
		end 
		if mbuttons[key_name] ~= nil then
			mb_state.down[mbuttons[key_name] ] = false
			mb_state.released[mbuttons[key_name] ] = false
			mb_state.triggered[mbuttons[key_name] ] = false
		end
	end
end

local def_hk_data = {modifier_actions={}}

local function recurse_def_settings(tbl, defaults_tbl)
	for key, value in pairs(defaults_tbl) do
		if type(tbl[key]) ~= type(value) then 
			if type(value) == "table" then
				tbl[key] = recurse_def_settings({}, value)
			else
				tbl[key] = value
			end
		elseif type(value) == "table" then
			tbl[key] = recurse_def_settings(tbl[key], value)
		end
	end
	return tbl
end

local hk_data = recurse_def_settings(json.load_file("Hotkeys_data.json") or {}, def_hk_data)

for act_name, button_name in pairs(hk_data.modifier_actions) do
	hotkeys[act_name] = button_name
end

local function reset_from_defaults_tbl(default_hotkey_table)
	for key, value in pairs(default_hotkey_table) do
		hotkeys[key] = value
		hotkeys[key.."_$"], hotkeys[key.."_$_$"], hk_data.modifier_actions[key.."_$"], hk_data.modifier_actions[key.."_$_$"] = nil
	end
	json.dump_file("Hotkeys_data.json", hk_data)
	setup_active_keys_tbl()
end

local function update_hotkey_table(hotkey_table)
	for key, value in pairs(hotkey_table) do
		hotkey_table[key] = hotkeys[key]
	end
end

local function setup_hotkeys(hotkey_table, default_hotkey_table) 
	if not default_hotkey_table then
	     	default_hotkey_table = {}
		for key, value in pairs(hotkey_table) do
			default_hotkey_table[key] = value
		end
	end
	default_hotkeys = merge_tables(default_hotkeys, default_hotkey_table)
	for key, value in pairs(default_hotkey_table) do 
		if hotkey_table[key] == nil then 
			hotkey_table[key] = value 
		end 
	end
	hotkeys = merge_tables(hotkeys, hotkey_table)
	setup_active_keys_tbl()
end

--Checks if an action's binding is down
local function chk_down(action_name)
	if hotkeys_down[action_name] == nil then
		local key_name = hotkeys[action_name]
		hotkeys_down[action_name] = kb_state.down[keys[key_name ] ]  or gp_state.down[buttons[key_name ] ] or mb_state.down[mbuttons[key_name ] ]
	end
	return hotkeys_down[action_name]
end

--Checks if an action's binding is released
local function chk_up(action_name)
	if hotkeys_up[action_name] == nil then 
		local key_name = hotkeys[action_name]
		hotkeys_up[action_name] = kb_state.released[keys[key_name ] ]  or gp_state.released[buttons[key_name ] ] or mb_state.released[mbuttons[key_name ] ]
	end
	return hotkeys_up[action_name]
end

--Checks if an action's binding is just down
local function chk_trig(action_name)
	if hotkeys_trig[action_name] == nil then 
		local key_name = hotkeys[action_name]
		hotkeys_trig[action_name] = kb_state.triggered[keys[key_name ] ]  or gp_state.triggered[buttons[key_name ] ] or mb_state.triggered[mbuttons[key_name ] ]
	end
	return hotkeys_trig[action_name]
end

--Checks if an action's binding is released or down
local function check_hotkey(action_name, check_down)
	if check_down == true then
		if hotkeys_down[action_name] == nil then
			local key_name = hotkeys[action_name]
			hotkeys_down[action_name] = (kb_state.down[keys[key_name ] ]  or gp_state.down[buttons[key_name ] ] or mb_state.down[mbuttons[key_name ] ]) and (not hotkeys[action_name.."_$"] or check_hotkey(action_name.."_$", true))
		end
		return hotkeys_down[action_name]
	elseif hotkeys_up[action_name] == nil then 
		local key_name = hotkeys[action_name]
		hotkeys_up[action_name] = (kb_state.released[keys[key_name ] ]  or gp_state.released[buttons[key_name ] ] or mb_state.released[mbuttons[key_name ] ]) and (not hotkeys[action_name.."_$"] or check_hotkey(action_name.."_$", true))
	end
	return hotkeys_up[action_name]
end

--Displays an imgui button that you can click then and press a button to assign a button to an action
local function hotkey_setter(action_name, hold_action_name, hide_text)
	
	local key_updated = false
	local is_mod = (action_name:sub(-4, -1) == "_$_$")
	local is_mod_1 = (action_name:sub(-2, -1) == "_$")
	local is_down = check_hotkey(action_name, true)
	local default = default_hotkeys[action_name]
	local modifier_hotkey = hotkeys[hold_action_name]
	modifiers[action_name] = hold_action_name
	
	if is_down then imgui.begin_rect(); imgui.begin_rect() end
	imgui.push_id(action_name)
		hotkeys[action_name] = hotkeys[action_name] or default
		if hotkeys[action_name] == "[Press Input]" then
			local up = pad and pad:call("get_ButtonUp")
			if up and up ~= 0 then
				for button_name, id in pairs(buttons) do 
					if (up | id) == up then 
						hotkeys[action_name] = button_name
						key_updated = true
						goto exit
					end
				end
			end
			m_up = mouse and mouse:call("get_ButtonUp")
			if m_up and m_up ~= 0 then
				for button_name, id in pairs(mbuttons) do 
					if (m_up | id) == m_up then 
						hotkeys[action_name] = button_name
						key_updated = true
						goto exit
					end
				end
			end
			for key_name, id in pairs(keys) do 
				if kb and kb:call("isRelease", id) then 
					hotkeys[action_name] = key_name
					key_updated = true
					goto exit
				end
			end
			
		end
		::exit::
		if not hide_text then
			imgui.text(action_name .. ": ")
			imgui.same_line()
		end
		
		if key_updated then
			if is_mod_1 then
				hk_data.modifier_actions[action_name] = hotkeys[action_name]
				json.dump_file("Hotkeys_data.json", hk_data)
			end
			setup_active_keys_tbl()
		end
		
		if not is_mod and hotkeys[action_name.."_$"] then
			hotkey_setter(action_name.."_$", nil, true)
			imgui.same_line()
			imgui.text("+")
			imgui.same_line()
		end
		
		if imgui.button( ((modifier_hotkey and (modifier_hotkey .. " + ")) or "") .. hotkeys[action_name]) then
			if hotkeys[action_name] == "[Press Input]" then 
				hotkeys[action_name] = backup_hotkeys[action_name]
			else
				for name, action_n in pairs(hotkeys) do 
					if action_n == "[Press Input]" then 
						hotkeys[name] = backup_hotkeys[name]
					end
				end
				backup_hotkeys[action_name] = hotkeys[action_name]
				hotkeys[action_name] = "[Press Input]"
			end
		end
		if imgui.is_item_hovered() then 
			imgui.set_tooltip(hotkeys[action_name]=="[Press Input]" and "Click to cancel" or "Set " .. (is_mod_1 and "Modifier" or "Hotkey").."\nRight click for options") 
		end
		if imgui.begin_popup_context_item(action_name) then  
			if hotkeys[action_name] ~= "[Not Bound]" and not hotkeys[action_name.."_$_$"] and imgui.menu_item("Clear") then
				if is_mod_1 then
					hotkeys[action_name], hk_data.modifier_actions[action_name], hotkeys[action_name.."_$"], hk_data.modifier_actions[action_name.."_$"]  = hotkeys[action_name.."_$"], hk_data.modifier_actions[action_name.."_$"]
					json.dump_file("Hotkeys_data.json", hk_data)
				else
					hotkeys[action_name] = "[Not Bound]"
				end
				key_updated = true
			end
			if not is_mod and default_hotkeys[action_name] and imgui.menu_item("Reset to Default") then 
				hotkeys[action_name] = default_hotkeys[action_name]
				key_updated = true
			end
			if not is_mod and not hold_action_name and hotkeys[action_name] ~= "[Not Bound]" and imgui.menu_item((hotkeys[action_name.."_$"] and "Disable " or "Enable ") .. "Modifier") then
				hotkeys[action_name.."_$"] = not hotkeys[action_name.."_$"] and ((is_mod_1 and "LShift") or "LAlt") or nil
				hotkeys[action_name.."_$_$"], hk_data.modifier_actions[action_name.."_$_$"] = nil
				hk_data.modifier_actions[action_name.."_$"] = hotkeys[action_name.."_$"]
				json.dump_file("Hotkeys_data.json", hk_data)
			end
			imgui.end_popup() 
		end
		if not is_mod_1 and not hotkeys[action_name.."_$"] and hotkeys[action_name] ~= "[Not Bound]" then
			for act_name, key_name in pairs(hotkeys) do 
				if act_name ~= action_name and key_name == hotkeys[action_name] and key_name ~= "[Press Input]" and (not hold_action_name or modifiers[act_name] == hold_action_name) then
					imgui.same_line()
					imgui.text_colored("*", 0xFF00FFFF)
					if imgui.is_item_hovered() then
						imgui.set_tooltip("Conflict with " .. act_name)
					end
					break
				end
			end
		end
	imgui.pop_id()
	if is_down then imgui.end_rect(1); imgui.end_rect(2) end
	
	return key_updated
end

local kb_singleton = sdk.get_native_singleton("via.hid.Keyboard")
local gp_singleton = sdk.get_native_singleton("via.hid.Gamepad")
local mb_singleton = sdk.get_native_singleton("via.hid.Mouse")
local kb_typedef = sdk.find_type_definition("via.hid.Keyboard")
local gp_typedef = sdk.find_type_definition("via.hid.GamePad")
local mb_typedef = sdk.find_type_definition("via.hid.Mouse")

re.on_application_entry("UpdateHID", function()
	
	hk.kb = sdk.call_native_func(kb_singleton, kb_typedef, "get_Device")
	hk.pad = sdk.call_native_func(gp_singleton, gp_typedef, "getMergedDevice", 0)
	hk.mouse = sdk.call_native_func(mb_singleton, mb_typedef, "get_Device")
	kb, pad, mouse = hk.kb, hk.pad, hk.mouse
	hotkeys_down, hotkeys_up, hotkeys_trig = {}, {}, {}
	
	if kb then
		for key, state in pairs(kb_state.released) do 
			kb_state.released[key]  = kb:call("isRelease", key) 
			kb_state.down[key] 		= kb:call("isDown", key) 
			kb_state.triggered[key] = kb:call("isTrigger", key) 
		end
	end
	
	if pad then 
		local m_up, m_down, m_trig = mouse:call("get_ButtonUp"), mouse:call("get_Button"), mouse:call("get_ButtonDown")
		for button, state in pairs(mb_state.released) do 
			mb_state.released[button]	= ((m_up | button) == m_up) 
			mb_state.down[button] 		= ((m_down | button) == m_down) 
			mb_state.triggered[button]  = ((m_trig | button) == m_trig)
		end
	end
	
	if pad then 
		local up, down, trig = pad:call("get_ButtonUp"), pad:call("get_Button"), pad:call("get_ButtonDown")
		for button, state in pairs(gp_state.released) do 
			gp_state.released[button] 	= ((up | button) == up) 
			gp_state.down[button] 		= ((down | button) == down) 
			gp_state.triggered[button]  = ((trig | button) == trig) 
		end
	end
end)

hk = {
	kb = kb,
	mouse = mouse,
	pad = pad,
	hotkeys = hotkeys,
	default_hotkeys = default_hotkeys,
	kb_state = kb_state,
	gp_state = gp_state,
	mb_state = mb_state,
	check_hotkey = check_hotkey,
	hotkey_setter = hotkey_setter,
	setup_hotkeys = setup_hotkeys,
	reset_from_defaults_tbl = reset_from_defaults_tbl,
	update_hotkey_table = update_hotkey_table,
	merge_tables = merge_tables,
	generate_statics = generate_statics,
	chk_up = chk_up, 
	chk_down = chk_down,
	chk_trig = chk_trig,
	keys = keys,
	buttons = buttons,
	mbuttons = mbuttons,
}

return hk