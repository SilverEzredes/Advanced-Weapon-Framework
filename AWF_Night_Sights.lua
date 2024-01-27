--/////////////////////////////////////--
-- Advanced Weapon Framework - Night Sights

-- Author: SilverEzredes
-- Updated: 01/26/2024
-- Version: v1.4.48
-- Special Thanks to: praydog; alphaZomega

--/////////////////////////////////////--
local AWF = require("AWFCore")
local hk = require("_SharedCore/Hotkeys")
local func = require("_SharedCore/Functions")

local show_AWFNS_editor = false
local scene = func.get_CurrentScene()
local changed = false
local wc = false

local AWF_NS_default_settings = {
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
}

local AWFWeapons = {
    RE7_Night_Sights = {
        wp1010_Handgun_Item = {
            night_sight_toggled = false,
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
        },
        wp1030_Shotgun_Item = {
            night_sight_toggled = false,
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
        },
        wp1033_Shotgun_Item = {
            night_sight_toggled = false,
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
        },
        wp1140_Magnum_Item = {
            night_sight_toggled = false,
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
        },
        wp1160_MachineGun_Item = {
            night_sight_toggled = false,
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
        },
        wp1210_Handgun_Item = {
            night_sight_toggled = false,
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
        },
        wp1230_PumpShotgun_Item = {
            night_sight_toggled = false,
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
        },
        wp1240_MiaHandgun_Item = {
            night_sight_toggled = false,
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
        },
        wp1330_ChrisShotgun_Item = {
            night_sight_toggled = false,
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
        },
        wp1340_ChrisHandgun_Item = {
            night_sight_toggled = false,
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
        },
        wp1340_ChrisHandgun_Reward_Item = {
            night_sight_toggled = false,
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
        },
    },
    RE2_Night_Sights = {
        wp0000 = {
            night_sight_toggled = false,
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
        },
        wp0100 = {
            night_sight_toggled = false,
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
        },
        wp0200 = {
            night_sight_toggled = false,
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
        },
        wp0300 = {
            night_sight_toggled = false,
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
        },
        wp0600 = {
            night_sight_toggled = false,
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
        },
        wp0700 = {
            night_sight_toggled = false,
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
        },
        wp0800 = {
            night_sight_toggled = false,
            material_params = {
                EmissiveColor = {
                    R = 255,
                    G = 0,
                    B = 0,
                    A = 255,
                },
                EmissiveIntensity = 150.0,
                EmissiveRate = 0.0,
            },
        },
        wp1000 = {
            night_sight_toggled = false,
            material_params = {
                EmissiveColor = {
                    R = 255,
                    G = 0,
                    B = 0,
                    A = 255,
                },
                EmissiveIntensity = 150.0,
                EmissiveRate = 0.0,
            },
        },
        wp2000 = {
            night_sight_toggled = false,
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
        },
        wp2200 = {
            night_sight_toggled = false,
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
        },
        wp3000 = {
            night_sight_toggled = false,
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
        
        },
        wp4300 = {
            night_sight_toggled = false,
            material_params = {
                EmissiveColor = {
                    R = 0,
                    G = 220,
                    B = 255,
                    A = 255,
                },
                EmissiveIntensity = 150.0,
                EmissiveRate = 0.0,
            },
        
        },
        wp7000 = {
            night_sight_toggled = false,
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
        },
        wp7010 = {
            night_sight_toggled = false,
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
        },
        wp7020 = {
            night_sight_toggled = false,
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
        },
        wp7030 = {
            night_sight_toggled = false,
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
        },
    },
}

local AWF_NS_settings = hk.merge_tables({}, AWF_NS_default_settings) and func.recurse_def_settings(json.load_file("AWF/AWF_NightSights/AWF_NightSight_Settings.json") or {}, AWF_NS_default_settings)
hk.setup_hotkeys(AWF_NS_settings.hotkeys)

local AWF_settings = hk.merge_tables({}, AWFWeapons) and func.recurse_def_settings(json.load_file("AWF/AWF_NightSights/AWF_NightSight_ColorSettings.json") or {}, AWFWeapons)

local function toggle_night_sights_RE7(weaponData, NS_table)
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
                            
                            if MatName:match("%NightSight$") or MatName:match("%NSight$") or MatName:match("%NS$") then
                                --log.info("---------------------------Got " .. MatName)

                                if MatParam then
                                    --log.info("------------" .. MatParam .. " Material Params")
                                
                                    for j = 0, MatParam - 1 do
                                        local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                        
                                        if MatParamNames then
                                            --log.info(MatParamNames)

                                            if MatParamNames == "EmissiveColor" then
                                                render_mesh:call("setMaterialFloat4", i, j, func.convert_rgba_to_vector4f(NS_table[weapon.ID].material_params.EmissiveColor.R, NS_table[weapon.ID].material_params.EmissiveColor.G, NS_table[weapon.ID].material_params.EmissiveColor.B, NS_table[weapon.ID].material_params.EmissiveColor.A))
                                            end

                                            if MatParamNames == "EmissiveIntensity" then
                                                render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].material_params.EmissiveIntensity)
                                            end

                                            if MatParamNames == "EmissiveRate" then
                                                render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].material_params.EmissiveRate)
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

local function toggle_night_sights_RE2(weaponData, NS_table)
    for _, weapon in pairs(weaponData) do
        if NS_table[weapon.ID] then
            local Weapon_GameObject_RE2 = scene:call("findGameObject(System.String)", weapon.ID)

            if Weapon_GameObject_RE2 then
                local render_mesh = Weapon_GameObject_RE2:call("getComponent(System.Type)", sdk.typeof("via.render.Mesh"))

                local MatCount = render_mesh:call("get_MaterialNum")
                    
                if MatCount then
                    for i = 0, MatCount - 1 do
                        local MatName = render_mesh:call("getMaterialName", i)
                        local MatParam = render_mesh:call("getMaterialVariableNum", i)
                        
                        if MatName:match("%NightSight$") or MatName:match("%NSight$") or MatName:match("%NS$") then
                            --log.info("---------------------------Got " .. MatName)
                            if MatParam then
                                for j = 0, MatParam - 1 do
                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                    
                                    if MatParamNames then
                                        if MatParamNames == "EmissiveColor" then
                                            render_mesh:call("setMaterialFloat4", i, j, func.convert_rgba_to_vector4f(NS_table[weapon.ID].material_params.EmissiveColor.R, NS_table[weapon.ID].material_params.EmissiveColor.G, NS_table[weapon.ID].material_params.EmissiveColor.B, NS_table[weapon.ID].material_params.EmissiveColor.A))
                                        end
                                        if MatParamNames == "EmissiveIntensity" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].material_params.EmissiveIntensity)
                                        end
                                        if MatParamNames == "EmissiveRate" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].material_params.EmissiveRate)
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

if reframework.get_game_name() == "re7" then
    toggle_night_sights_RE7(AWF.AWF_settings.RE7_Weapons, AWF_settings.RE7_Night_Sights)
elseif reframework.get_game_name() == "re2" then
    toggle_night_sights_RE2(AWF.AWF_settings.RE2_Weapons, AWF_settings.RE2_Night_Sights)
end

local function update_night_sights_RE7(weaponData)
    local KM_controls = ((not AWF_NS_settings.use_modifier or hk.check_hotkey("Modifier", false)) and hk.check_hotkey("Night Sight Switch")) or (hk.check_hotkey("Modifier", true) and hk.check_hotkey("Night Sight Switch"))
    local PAD_controls = ((not AWF_NS_settings.use_pad_modifier or hk.check_hotkey("Pad Modifier", false)) and hk.check_hotkey("Pad Night Sight Switch")) or (hk.check_hotkey("Pad Modifier", true) and hk.check_hotkey("Pad Night Sight Switch"))

    if KM_controls or PAD_controls then
        for _, weapon in pairs(weaponData) do
            local NS_Params = AWF_settings.RE7_Night_Sights[weapon.ID]

            if NS_Params then
                NS_Params.material_params.EmissiveRate = NS_Params.night_sight_toggled and 0.0 or 1.0
                NS_Params.night_sight_toggled = not NS_Params.night_sight_toggled
                toggle_night_sights_RE2(AWF.AWF_settings.RE7_Weapons, AWF_settings.RE7_Night_Sights)
            end
        end
    end
end

local function update_night_sights_RE2(weaponData)
    local KM_controls = ((not AWF_NS_settings.use_modifier or hk.check_hotkey("Modifier", false)) and hk.check_hotkey("Night Sight Switch")) or (hk.check_hotkey("Modifier", true) and hk.check_hotkey("Night Sight Switch"))
    local PAD_controls = ((not AWF_NS_settings.use_pad_modifier or hk.check_hotkey("Pad Modifier", false)) and hk.check_hotkey("Pad Night Sight Switch")) or (hk.check_hotkey("Pad Modifier", true) and hk.check_hotkey("Pad Night Sight Switch"))

    if KM_controls or PAD_controls then
        for _, weapon in pairs(weaponData) do
            local NS_Params = AWF_settings.RE2_Night_Sights[weapon.ID]

            if NS_Params then
                NS_Params.material_params.EmissiveRate = NS_Params.night_sight_toggled and 0.0 or 1.0
                NS_Params.night_sight_toggled = not NS_Params.night_sight_toggled
                toggle_night_sights_RE2(AWF.AWF_settings.RE2_Weapons, AWF_settings.RE2_Night_Sights)
            end
        end
    end
end

re.on_frame(function()
	if reframework.get_game_name() == "re7" then
        update_night_sights_RE7(AWF.AWF_settings.RE7_Weapons)
    end
    if reframework.get_game_name() == "re2" then
        update_night_sights_RE2(AWF.AWF_settings.RE2_Weapons)
    end
end)

local function draw_AWFNS_RE7Editor_GUI(weaponOrder)
    if imgui.begin_window("AWF Night Sight Editor") then
        imgui.begin_rect()
        imgui.button("[==============| AWF NIGHT SIGHT EDITOR |==============]")

        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF.AWF_settings.RE7_Weapons[weaponName]

            if weapon.Type ~= "Ammo" and weapon.Type ~= "KNF" and imgui.tree_node(string.upper(weapon.Name)) then
                imgui.begin_rect()
                imgui.spacing()

                if imgui.button("Reset to Defaults") then
                    wc = true
                    AWF_settings.RE7_Night_Sights[weapon.ID] = func.recurse_def_settings({}, AWFWeapons.RE7_Night_Sights[weapon.ID]); wc = wc or changed
                end

                changed, AWF_settings.RE7_Night_Sights[weapon.ID].material_params.EmissiveIntensity = imgui.drag_float("Intensity", AWF_settings.RE7_Night_Sights[weapon.ID].material_params.EmissiveIntensity, 1.0, 0.0, 1000.0); wc = wc or changed

                local NS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE7_Night_Sights[weapon.ID].material_params.EmissiveColor.R, AWF_settings.RE7_Night_Sights[weapon.ID].material_params.EmissiveColor.G, AWF_settings.RE7_Night_Sights[weapon.ID].material_params.EmissiveColor.B, AWF_settings.RE7_Night_Sights[weapon.ID].material_params.EmissiveColor.A)
                changed, NS_EmissiveColor = imgui.color_picker4("Night Sight Color", NS_EmissiveColor); wc = wc or changed
                
                local R, G, B, A = func.convert_vector4f_to_rgba(NS_EmissiveColor)
                AWF_settings.RE7_Night_Sights[weapon.ID].material_params.EmissiveColor.R = R
                AWF_settings.RE7_Night_Sights[weapon.ID].material_params.EmissiveColor.G = G
                AWF_settings.RE7_Night_Sights[weapon.ID].material_params.EmissiveColor.B = B
                AWF_settings.RE7_Night_Sights[weapon.ID].material_params.EmissiveColor.A = A
                
                imgui.end_rect(2)
                imgui.tree_pop()
            end
            imgui.separator()
        end
        imgui.end_rect(1)
        imgui.end_window()
    end
end

local function draw_AWFNS_RE2Editor_GUI(weaponOrder)
    if imgui.begin_window("AWF Night Sight Editor") then
        imgui.begin_rect()
        imgui.button("[==============| AWF NIGHT SIGHT EDITOR |==============]")

        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF.AWF_settings.RE2_Weapons[weaponName]

            if (not weapon.ID:match("^wp4%d%d%d$") and not weapon.ID:match("^wp8%d%d%d$") or weapon.ID == "wp4300") and imgui.tree_node(string.upper(weapon.Name)) then
                imgui.begin_rect()
                imgui.spacing()

                if imgui.button("Reset to Defaults") then
                    wc = true
                    AWF_settings.RE2_Night_Sights[weapon.ID] = func.recurse_def_settings({}, AWFWeapons.RE2_Night_Sights[weapon.ID]); wc = wc or changed
                end

                changed, AWF_settings.RE2_Night_Sights[weapon.ID].material_params.EmissiveIntensity = imgui.drag_float("Intensity", AWF_settings.RE2_Night_Sights[weapon.ID].material_params.EmissiveIntensity, 1.0, 0.0, 1000.0); wc = wc or changed

                local NS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE2_Night_Sights[weapon.ID].material_params.EmissiveColor.R, AWF_settings.RE2_Night_Sights[weapon.ID].material_params.EmissiveColor.G, AWF_settings.RE2_Night_Sights[weapon.ID].material_params.EmissiveColor.B, AWF_settings.RE2_Night_Sights[weapon.ID].material_params.EmissiveColor.A)
                changed, NS_EmissiveColor = imgui.color_picker4("Night Sight Color", NS_EmissiveColor); wc = wc or changed
                
                local R, G, B, A = func.convert_vector4f_to_rgba(NS_EmissiveColor)
                AWF_settings.RE2_Night_Sights[weapon.ID].material_params.EmissiveColor.R = R
                AWF_settings.RE2_Night_Sights[weapon.ID].material_params.EmissiveColor.G = G
                AWF_settings.RE2_Night_Sights[weapon.ID].material_params.EmissiveColor.B = B
                AWF_settings.RE2_Night_Sights[weapon.ID].material_params.EmissiveColor.A = A
                
                imgui.end_rect(2)
                imgui.tree_pop()
            end
            imgui.separator()
        end
        imgui.end_rect(1)
        imgui.end_window()
    end
end

re.on_draw_ui(function()
    if reframework.get_game_name() == "re7" then
        imgui.begin_rect()
        if imgui.tree_node("AWF - Night Sights") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_NS_settings = func.recurse_def_settings({}, AWF_NS_default_settings); wc = wc or changed
                hk.reset_from_defaults_tbl(AWF_NS_default_settings.hotkeys)
                AWF_settings = func.recurse_def_settings({}, AWFWeapons); wc = wc or changed
            end
            
            changed, show_AWFNS_editor = imgui.checkbox("Open AWF Night Sight Editor", show_AWFNS_editor)
            func.tooltip("Show/Hide the AWF Night Sight Editor.")

            if show_AWFNS_editor then
                draw_AWFNS_RE7Editor_GUI(AWF.AWF_settings.RE7_Weapon_Order)
            end

            imgui.spacing()

            imgui.begin_rect()
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
            imgui.end_rect(2)

            ui.button_n_colored_txt("Current Version:", "v1.4.45 | 01/25/2024", 0xFF00FF00)
            imgui.same_line()
            imgui.text("| by SilverEzredes")
            
            if show_AWFNS_editor and (changed or wc) then
                hk.update_hotkey_table(AWF_NS_settings.hotkeys)
                json.dump_file("AWF/AWF_NightSights/AWF_NightSight_Settings.json", AWF_NS_settings)
                json.dump_file("AWF/AWF_NightSights/AWF_NightSight_ColorSettings.json", AWF_settings)
            end
            
            imgui.end_rect(1)
            imgui.tree_pop()
        end
    end

    if reframework.get_game_name() == "re2" then
        if imgui.tree_node("AWF - Night Sights") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_NS_settings = func.recurse_def_settings({}, AWF_NS_default_settings); wc = wc or changed
                hk.reset_from_defaults_tbl(AWF_NS_default_settings.hotkeys)
                AWF_settings = func.recurse_def_settings({}, AWFWeapons); wc = wc or changed
            end
            func.tooltip("Reset every parameter.")
            
            imgui.spacing()

            changed, show_AWFNS_editor = imgui.checkbox("Open AWF Night Sight Editor", show_AWFNS_editor)
            func.tooltip("Show/Hide the AWF Night Sight Editor.")

            if show_AWFNS_editor then
                draw_AWFNS_RE2Editor_GUI(AWF.AWF_settings.RE2_Weapon_Order)
            end
            
            imgui.spacing()

            imgui.begin_rect()
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
            imgui.end_rect(2)

            ui.button_n_colored_txt("Current Version:", "v1.4.45 | 01/24/2024", 0xFF00FF00)
            imgui.same_line()
            imgui.text("| by SilverEzredes")
            
            if show_AWFNS_editor and (changed or wc) then
                hk.update_hotkey_table(AWF_NS_settings.hotkeys)
                json.dump_file("AWF/AWF_NightSights/AWF_NightSight_Settings.json", AWF_NS_settings)
                json.dump_file("AWF/AWF_NightSights/AWF_NightSight_ColorSettings.json", AWF_settings)
            end
            
            imgui.end_rect(1)
            imgui.tree_pop()
        end
    end
end)

AWFNS = {
    AWFNS_Settings = AWF_settings,
    toggle_night_sights_RE7 = toggle_night_sights_RE7,
    toggle_night_sights_RE2 = toggle_night_sights_RE2,
}
return AWFNS