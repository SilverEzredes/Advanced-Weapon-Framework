--/////////////////////////////////////--
-- Advanced Weapon Framework - Night Sights

-- Author: SilverEzredes
-- Updated: 12/20/2023
-- Version: v1.3.0
-- Special Thanks to: praydog; alphaZomega

--/////////////////////////////////////--
local AWF = require("AWFCore")
local hk = require("_SharedCore/Hotkeys")
local func = require("_SharedCore/Functions")

local scene = func.get_CurrentScene()
local changed = false
local wc = false

local AWF_NS_default_settings = {
	night_sight_toggled = false,
	-------------------------
    input_mode_idx =  1,
    option_mode_idx = 1,
    use_modifier = true,
    use_pad_modifier = true,
    -------------------------
	hotkeys = {
		["Modifier"] = "R Mouse",
		["Night Sight Switch"] = "E",
		["Pad Modifier"] = "LT (L2)",
		["Pad Night Sight Switch"] = "A (X)",
	},
    material_params = {
        EmissiveColor = {
            R = 0,
            G = 255,
            B = 0,
            A = 255,
        },
        EmissiveIntensity = 150.0,
        EmissiveRate = 0.0,
    },
}

local AWF_settings = {
    RE7_Night_Sights = {
        wp1010_Handgun_Item = {},
        wp1030_Shotgun_Item = {},
        wp1033_Shotgun_Item = {},
        wp1140_Magnum_Item = {},
        wp1160_MachineGun_Item = {},
        wp1210_Handgun_Item = {},
        wp1230_PumpShotgun_Item = {},
        wp1240_MiaHandgun_Item = {},
        wp1330_ChrisShotgun_Item = {},
        wp1340_ChrisHandgun_Item = {},
        wp1340_ChrisHandgun_Reward_Item = {},
    },
}

local AWF_NS_settings = hk.merge_tables({}, AWF_NS_default_settings) and func.recurse_def_settings(json.load_file("AWF/AWF_NightSight_Settings.json") or {}, AWF_NS_default_settings)
hk.setup_hotkeys(AWF_NS_settings.hotkeys)

local function toggle_night_sights(weaponData, NS_table)
    for _, weapon in pairs(weaponData) do
        if NS_table[weapon.ID] then
            local Weapon_GameObject_RE7 = scene:call("findGameObject(System.String)", weapon.ID)
            
            if weapon.Type ~= "Ammo" and Weapon_GameObject_RE7 then
                local render_mesh = Weapon_GameObject_RE7:call("getComponent(System.Type)", sdk.typeof("via.render.Mesh"))
                
                if render_mesh then
                    --log.info("Got " .. weapon.Name .. " Render Mesh component!")

                    local MatCount = render_mesh:call("get_MaterialNum")
                    
                    if MatCount then
                        --log.info("Got [" .. MatCount .. "] Materials")

                        for i = 0, MatCount - 1 do
                            local MatName = render_mesh:call("getMaterialName", i)
                            local MatParam = render_mesh:call("getMaterialVariableNum", i)
                            
                            if MatName == "%NightSight" or "%NS" or "%NSight" then
                                --log.info("---------------------------Got " .. MatName)

                                if MatParam then
                                    --log.info("------------" .. MatParam .. " Material Params")
                                
                                    for j = 0, MatParam - 1 do
                                        local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                        
                                        if MatParamNames then
                                            --log.info(MatParamNames)

                                            if MatParamNames == "EmissiveColor" then
                                                render_mesh:call("setMaterialFloat4", i, j, func.convert_rgba_to_vector4f(AWF_NS_settings.material_params.EmissiveColor.R, AWF_NS_settings.material_params.EmissiveColor.G, AWF_NS_settings.material_params.EmissiveColor.B, AWF_NS_settings.material_params.EmissiveColor.A))
                                            end

                                            if MatParamNames == "EmissiveIntensity" then
                                                render_mesh:call("setMaterialFloat", i, j, AWF_NS_settings.material_params.EmissiveIntensity)
                                            end

                                            if MatParamNames == "EmissiveRate" then
                                                render_mesh:call("setMaterialFloat", i, j, AWF_NS_settings.material_params.EmissiveRate)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

toggle_night_sights(AWF.AWF_settings.RE7_Weapons, AWF_settings.RE7_Night_Sights)

re.on_frame(function()
	local KM_controls = ((not AWF_NS_settings.use_modifier or hk.check_hotkey("Modifier", false)) and hk.check_hotkey("Night Sight Switch")) or (hk.check_hotkey("Modifier", true) and hk.check_hotkey("Night Sight Switch"))
	local PAD_controls = ((not AWF_NS_settings.use_pad_modifier or hk.check_hotkey("Pad Modifier", false)) and hk.check_hotkey("Pad Night Sight Switch")) or (hk.check_hotkey("Pad Modifier", true) and hk.check_hotkey("Pad Night Sight Switch"))

    if KM_controls or PAD_controls then
        changed = true
        wc = true
        AWF_NS_settings.material_params.EmissiveRate = AWF_NS_settings.night_sight_toggled and 0.0 or 1.0
        AWF_NS_settings.night_sight_toggled = not AWF_NS_settings.night_sight_toggled
        toggle_night_sights(AWF.AWF_settings.RE7_Weapons, AWF_settings.RE7_Night_Sights)
    end
end)

re.on_draw_ui(function()
    imgui.begin_rect()
    if imgui.tree_node("AWF - Night Sights") then
        imgui.begin_rect()
        if imgui.button("Reset to Defaults") then
            wc = true
            changed = true
            AWF_NS_settings = func.recurse_def_settings({}, AWF_NS_default_settings); wc = wc or changed
            hk.reset_from_defaults_tbl(AWF_NS_default_settings.hotkeys)
        end

        imgui.same_line()
		func.colored_TextSwitch("Night Sight State:", AWF_NS_settings.night_sight_toggled, "ON", 0xFF00FF00, "OFF", 0xFF0000FF)

        imgui.begin_rect()
        changed, AWF_NS_settings.material_params.EmissiveIntensity = imgui.drag_float("Intensity", AWF_NS_settings.material_params.EmissiveIntensity, 1.0, 0.0, 1000.0); wc = wc or changed
        
        local NS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_NS_settings.material_params.EmissiveColor.R, AWF_NS_settings.material_params.EmissiveColor.G, AWF_NS_settings.material_params.EmissiveColor.B, AWF_NS_settings.material_params.EmissiveColor.A)
        changed, NS_EmissiveColor = imgui.color_picker4("Night Sight Color", NS_EmissiveColor); wc = wc or changed
        
        local R, G, B, A = func.convert_vector4f_to_rgba(NS_EmissiveColor)
        AWF_NS_settings.material_params.EmissiveColor.R = R
        AWF_NS_settings.material_params.EmissiveColor.G = G
        AWF_NS_settings.material_params.EmissiveColor.B = B
        AWF_NS_settings.material_params.EmissiveColor.A = A
        
        imgui.spacing()
        changed, AWF_NS_settings.input_mode_idx = imgui.combo("Input Settings", AWF_NS_settings.input_mode_idx, {"Default", "Custom"}); wc = wc or changed
        func.tooltip("Set the control scheme for the mod")
        
        if AWF_NS_settings.input_mode_idx == 2 then
            if imgui.tree_node("Keyboard and Mouse Settings") then
                changed, AWF_NS_settings.use_modifier = imgui.checkbox(" ", AWF_NS_settings.use_modifier); wc = wc or changed
                func.tooltip("Require that you hold down this button")
                imgui.same_line()
                changed = hk.hotkey_setter("Modifier"); wc = wc or changed
                changed = hk.hotkey_setter("Night Sight Switch", AWF_NS_settings.use_modifier and "Modifier"); wc = wc or changed
                imgui.tree_pop()
            end
            
            if imgui.tree_node("Gamepad Settings") then
                changed, AWF_NS_settings.use_pad_modifier = imgui.checkbox(" ", AWF_NS_settings.use_pad_modifier); wc = wc or changed
                func.tooltip("Require that you hold down this button")
                imgui.same_line()
                changed = hk.hotkey_setter("Pad Modifier"); wc = wc or changed
                changed = hk.hotkey_setter("Pad Night Sight Switch", AWF_NS_settings.use_pad_modifier and "Pad Modifier"); wc = wc or changed
                imgui.tree_pop()
            end
        end
        imgui.text("				    v1.3.0 by SilverEzredes")
        imgui.end_rect(1)
        
        if changed or wc then
			hk.update_hotkey_table(AWF_NS_settings.hotkeys)
			json.dump_file("AWF/AWF_NightSight_Settings.json", AWF_NS_settings)
		end
        
        imgui.end_rect(2)
        imgui.tree_pop()
    end
end)