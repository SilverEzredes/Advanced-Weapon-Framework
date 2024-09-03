--/////////////////////////////////////--
local modName =  "Advanced Weapon Framework - Night Sights"

local modAuthor = "SilverEzredes"
local modUpdated = "09/03/2024"
local modVersion = "v3.3.30"
local modCredits = "praydog; alphaZomega"

--/////////////////////////////////////--
local AWF = require("AWFCore")
local hk = require("Hotkeys/Hotkeys")
local func = require("_SharedCore/Functions")
local ui = require("_SharedCore/Imgui")

local show_AWFNS_editor = false
local scene = func.get_CurrentScene()
local changed = false
local wc = false

local AWF_NS_default_settings = {
    input_mode_idx =  1,
    option_mode_idx = 1,
    fl_input_mode_idx =  1,
    fl_option_mode_idx = 1,
    use_modifier = true,
    use_pad_modifier = true,
    fl_use_modifier = true,
    fl_use_pad_modifier = true,
    -------------------------
	hotkeys = {
		["Night Sight Modifier"] = "R Mouse",
		["Night Sight Switch"] = "E",
		["Pad Night Sight Modifier"] = "LT (L2)",
		["Pad Night Sight Switch"] = "A (X)",

        ["Gun Light Modifier"] = "R Mouse",
		["Gun Light Switch"] = "T",
		["Pad Gun Light Modifier"] = "LT (L2)",
		["Pad Gun Light Switch"] = "B (Circle)",
	},
}

local AWFWeapons = {
    RE2_Night_Sights = {},
    RE3_Night_Sights = {},
    RE4_Night_Sights = {},
    RE7_Night_Sights = {},
    RE8_Night_Sights = {},
}

AWFWeapons.RE2_Night_Sights = require("AWFCore/AWFNS/RE2R_NightSightData")
AWFWeapons.RE3_Night_Sights = require("AWFCore/AWFNS/RE3R_NightSightData")
AWFWeapons.RE4_Night_Sights = require("AWFCore/AWFNS/RE4R_NightSightData")
AWFWeapons.RE7_Night_Sights = require("AWFCore/AWFNS/RE7_NightSightData")
AWFWeapons.RE8_Night_Sights = require("AWFCore/AWFNS/RE8_NightSightData")

local AWF_NS_settings = hk.merge_tables({}, AWF_NS_default_settings) and hk.recurse_def_settings(json.load_file("AWF/AWF_NightSights/AWF_NightSight_Settings.json") or {}, AWF_NS_default_settings)
hk.setup_hotkeys(AWF_NS_settings.hotkeys)

local AWF_settings = hk.merge_tables({}, AWFWeapons) and hk.recurse_def_settings(json.load_file("AWF/AWF_NightSights/AWF_NightSight_ColorSettings.json") or {}, AWFWeapons)
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK:RE2R
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
                        
                        if MatName:match("NightSight$") or MatName:match("NightSights$") or MatName:match("NSights$") or MatName:match("NSight$") or MatName:match("NS$") then
                            --log.info("---------------------------Got " .. MatName)
                            if MatParam then
                                for j = 0, MatParam - 1 do
                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                    
                                    if MatParamNames then
                                        if MatParamNames == "EmissiveColor" then
                                            render_mesh:call("setMaterialFloat4", i, j, func.convert_rgba_to_vector4f(NS_table[weapon.ID].ns_material_params.EmissiveColor.R, NS_table[weapon.ID].ns_material_params.EmissiveColor.G, NS_table[weapon.ID].ns_material_params.EmissiveColor.B, NS_table[weapon.ID].ns_material_params.EmissiveColor.A))
                                        end
                                        if MatParamNames == "EmissiveIntensity" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ns_material_params.EmissiveIntensity)
                                        end
                                        if MatParamNames == "EmissiveRate" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ns_material_params.EmissiveRate)
                                        end
                                    end
                                end
                            end
                        end
                        if MatName:match("DotSight$") or MatName:match("DSight$") or MatName:match("DS$") or MatName:match("RedDotSight$") or MatName:match("RDS$") then
                            if MatParam then
                                for j = 0, MatParam - 1 do
                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                    
                                    if MatParamNames then
                                        if MatParamNames == "EmissiveColor" then
                                            render_mesh:call("setMaterialFloat4", i, j, func.convert_rgba_to_vector4f(NS_table[weapon.ID].ds_material_params.EmissiveColor.R, NS_table[weapon.ID].ds_material_params.EmissiveColor.G, NS_table[weapon.ID].ds_material_params.EmissiveColor.B, NS_table[weapon.ID].ds_material_params.EmissiveColor.A))
                                        end
                                        if MatParamNames == "EmissiveIntensity" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ds_material_params.EmissiveIntensity)
                                        end
                                        if MatParamNames == "EmissiveRate" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ds_material_params.EmissiveRate)
                                        end
                                    end
                                end
                            end
                        end
                        if MatName:match("Flashlight$") or MatName:match("FLight$") or MatName:match("FL$") then
                            if MatParam then
                                for j = 0, MatParam - 1 do
                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                    
                                    if MatParamNames then
                                        if MatParamNames == "EmissiveColor" then
                                            render_mesh:call("setMaterialFloat4", i, j, func.convert_rgba_to_vector4f(NS_table[weapon.ID].fl_material_params.EmissiveColor.R, NS_table[weapon.ID].fl_material_params.EmissiveColor.G, NS_table[weapon.ID].fl_material_params.EmissiveColor.B, NS_table[weapon.ID].fl_material_params.EmissiveColor.A))
                                        end
                                        if MatParamNames == "EmissiveIntensity" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].fl_material_params.EmissiveIntensity)
                                        end
                                        if MatParamNames == "EmissiveRate" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].fl_material_params.EmissiveRate)
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
if reframework.get_game_name() == "re2" then
    toggle_night_sights_RE2(AWF.AWF_settings.RE2.Weapons, AWF_settings.RE2_Night_Sights)
end
local function update_night_sights_RE2(weaponData)
    local KM_controls = ((not AWF_NS_settings.use_modifier or hk.check_hotkey("Night Sight Modifier", false)) and hk.check_hotkey("Night Sight Switch")) or (hk.check_hotkey("Night Sight Modifier", true) and hk.check_hotkey("Night Sight Switch"))
    local PAD_controls = ((not AWF_NS_settings.use_pad_modifier or hk.check_hotkey("Pad Night Sight Modifier", false)) and hk.check_hotkey("Pad Night Sight Switch")) or (hk.check_hotkey("Pad Night Sight Modifier", true) and hk.check_hotkey("Pad Night Sight Switch"))

    if KM_controls or PAD_controls then
        for _, weapon in pairs(weaponData) do
            local NS_Params = AWF_settings.RE2_Night_Sights[weapon.ID]

            if NS_Params then
                NS_Params.ns_material_params.EmissiveRate = NS_Params.night_sight_toggled and 0.0 or 1.0
                NS_Params.night_sight_toggled = not NS_Params.night_sight_toggled
                NS_Params.ds_material_params.EmissiveRate = NS_Params.dotsight_toggled and 0.0 or 1.0
                NS_Params.dotsight_toggled = not NS_Params.dotsight_toggled
                toggle_night_sights_RE2(AWF.AWF_settings.RE2.Weapons, AWF_settings.RE2_Night_Sights)
            end
        end
    end
end
local function draw_AWFNS_RE2Editor_GUI(weaponOrder)
    if imgui.begin_window("AWF Night Sight Editor") then
        imgui.begin_rect()
        imgui.button("[==============| AWF NIGHT SIGHT EDITOR |==============]")

        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF.AWF_settings.RE2.Weapons[weaponName]

            if (not weapon.ID:match("^wp4%d%d%d$") and not weapon.ID:match("^wp8%d%d%d$") or weapon.ID == "wp4300") and imgui.tree_node(string.upper(weapon.Name)) then
                imgui.begin_rect()
                imgui.spacing()

                if imgui.button("Reset to Defaults") then
                    wc = true
                    AWF_settings.RE2_Night_Sights[weapon.ID] = hk.recurse_def_settings({}, AWFWeapons.RE2_Night_Sights[weapon.ID]); wc = wc or changed
                end

                changed, AWF_settings.RE2_Night_Sights[weapon.ID].ns_material_params.EmissiveIntensity = imgui.drag_float("Intensity", AWF_settings.RE2_Night_Sights[weapon.ID].ns_material_params.EmissiveIntensity, 1.0, 0.0, 1000.0); wc = wc or changed

                local NS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE2_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.R, AWF_settings.RE2_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.G, AWF_settings.RE2_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.B, AWF_settings.RE2_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.A)
                changed, NS_EmissiveColor = imgui.color_picker4("Night Sight Color", NS_EmissiveColor); wc = wc or changed
                
                local R, G, B, A = func.convert_vector4f_to_rgba(NS_EmissiveColor)
                AWF_settings.RE2_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.R = R
                AWF_settings.RE2_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.G = G
                AWF_settings.RE2_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.B = B
                AWF_settings.RE2_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.A = A
                
                imgui.spacing()

                changed, AWF_settings.RE2_Night_Sights[weapon.ID].ds_material_params.EmissiveIntensity = imgui.drag_float("Dot Sight Intensity", AWF_settings.RE2_Night_Sights[weapon.ID].ds_material_params.EmissiveIntensity, 5.0, 0.0, 10000.0); wc = wc or changed

                local DS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE2_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.R, AWF_settings.RE2_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.G, AWF_settings.RE2_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.B, AWF_settings.RE2_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.A)
                changed, DS_EmissiveColor = imgui.color_picker4("Dot Sight Color", DS_EmissiveColor); wc = wc or changed
                
                local R2, G2, B2, A2 = func.convert_vector4f_to_rgba(DS_EmissiveColor)
                AWF_settings.RE2_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.R = R2
                AWF_settings.RE2_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.G = G2
                AWF_settings.RE2_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.B = B2
                AWF_settings.RE2_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.A = A2

                imgui.end_rect(2)
                imgui.tree_pop()
            end
            imgui.separator()
        end
        imgui.end_rect(1)
        imgui.end_window()
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK:RE3R
local function toggle_night_sights_RE3(weaponData, NS_table)
    for _, weapon in pairs(weaponData) do
        if NS_table[weapon.ID] then
            local Weapon_GameObject_RE3 = scene:call("findGameObject(System.String)", weapon.ID)

            if Weapon_GameObject_RE3 then
                local render_mesh = Weapon_GameObject_RE3:call("getComponent(System.Type)", sdk.typeof("via.render.Mesh"))
                local MatCount = render_mesh:call("get_MaterialNum")
                    
                if MatCount then
                    for i = 0, MatCount - 1 do
                        local MatName = render_mesh:call("getMaterialName", i)
                        local MatParam = render_mesh:call("getMaterialVariableNum", i)
                        
                        if MatName:match("NightSight$") or MatName:match("NightSights$") or MatName:match("NSights$") or MatName:match("NSight$") or MatName:match("NS$") then
                            --log.info("---------------------------Got " .. MatName)
                            if MatParam then
                                for j = 0, MatParam - 1 do
                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                    
                                    if MatParamNames then
                                        if MatParamNames == "EmissiveColor" then
                                            render_mesh:call("setMaterialFloat4", i, j, func.convert_rgba_to_vector4f(NS_table[weapon.ID].ns_material_params.EmissiveColor.R, NS_table[weapon.ID].ns_material_params.EmissiveColor.G, NS_table[weapon.ID].ns_material_params.EmissiveColor.B, NS_table[weapon.ID].ns_material_params.EmissiveColor.A))
                                        end
                                        if MatParamNames == "EmissiveIntensity" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ns_material_params.EmissiveIntensity)
                                        end
                                        if MatParamNames == "EmissiveRate" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ns_material_params.EmissiveRate)
                                        end
                                    end
                                end
                            end
                        end
                        if MatName:match("DotSight$") or MatName:match("DSight$") or MatName:match("DS$") or MatName:match("RedDotSight$") or MatName:match("RDS$") then
                            --log.info("---------------------------Got " .. MatName)
                            if MatParam then
                                for k = 0, MatParam - 1 do
                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, k)
                                    
                                    if MatParamNames then
                                        if MatParamNames == "EmissiveColor" then
                                            render_mesh:call("setMaterialFloat4", i, k, func.convert_rgba_to_vector4f(NS_table[weapon.ID].ds_material_params.EmissiveColor.R, NS_table[weapon.ID].ds_material_params.EmissiveColor.G, NS_table[weapon.ID].ds_material_params.EmissiveColor.B, NS_table[weapon.ID].ds_material_params.EmissiveColor.A))
                                        end
                                        if MatParamNames == "EmissiveIntensity" then
                                            render_mesh:call("setMaterialFloat", i, k, NS_table[weapon.ID].ds_material_params.EmissiveIntensity)
                                        end
                                        if MatParamNames == "EmissiveRate" then
                                            render_mesh:call("setMaterialFloat", i, k, NS_table[weapon.ID].ds_material_params.EmissiveRate)
                                        end
                                    end
                                end
                            end
                        end
                        if MatName:match("Flashlight$") or MatName:match("FLight$") or MatName:match("FL$") then
                            if MatParam then
                                for j = 0, MatParam - 1 do
                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                    
                                    if MatParamNames then
                                        if MatParamNames == "EmissiveColor" then
                                            render_mesh:call("setMaterialFloat4", i, j, func.convert_rgba_to_vector4f(NS_table[weapon.ID].fl_material_params.EmissiveColor.R, NS_table[weapon.ID].fl_material_params.EmissiveColor.G, NS_table[weapon.ID].fl_material_params.EmissiveColor.B, NS_table[weapon.ID].fl_material_params.EmissiveColor.A))
                                        end
                                        if MatParamNames == "EmissiveIntensity" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].fl_material_params.EmissiveIntensity)
                                        end
                                        if MatParamNames == "EmissiveRate" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].fl_material_params.EmissiveRate)
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
if reframework.get_game_name() == "re3" then
    toggle_night_sights_RE3(AWF.AWF_settings.RE3.Weapons, AWF_settings.RE3_Night_Sights)
end
local function update_night_sights_RE3(weaponData)
    local KM_controls = ((not AWF_NS_settings.use_modifier or hk.check_hotkey("Night Sight Modifier", false)) and hk.check_hotkey("Night Sight Switch")) or (hk.check_hotkey("Night Sight Modifier", true) and hk.check_hotkey("Night Sight Switch"))
    local PAD_controls = ((not AWF_NS_settings.use_pad_modifier or hk.check_hotkey("Pad Night Sight Modifier", false)) and hk.check_hotkey("Pad Night Sight Switch")) or (hk.check_hotkey("Pad Night Sight Modifier", true) and hk.check_hotkey("Pad Night Sight Switch"))

    if KM_controls or PAD_controls then
        for _, weapon in pairs(weaponData) do
            local NS_Params = AWF_settings.RE3_Night_Sights[weapon.ID]

            if NS_Params then
                NS_Params.ns_material_params.EmissiveRate = NS_Params.night_sight_toggled and 0.0 or 1.0
                NS_Params.night_sight_toggled = not NS_Params.night_sight_toggled
                NS_Params.ds_material_params.EmissiveRate = NS_Params.dotsight_toggled and 0.0 or 1.0
                NS_Params.dotsight_toggled = not NS_Params.dotsight_toggled
                toggle_night_sights_RE3(AWF.AWF_settings.RE3.Weapons, AWF_settings.RE3_Night_Sights)
            end
        end
    end
end
local function draw_AWFNS_RE3Editor_GUI(weaponOrder)
    if imgui.begin_window("AWF Night Sight Editor") then
        imgui.begin_rect()
        imgui.button("[==============| AWF NIGHT SIGHT EDITOR |==============]")

        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF.AWF_settings.RE3.Weapons[weaponName]

            if not weapon.ID:match("^wp4%d%d%d$") and imgui.tree_node(string.upper(weapon.Name)) then
                imgui.begin_rect()
                imgui.spacing()

                if imgui.button("Reset to Defaults") then
                    wc = true
                    AWF_settings.RE3_Night_Sights[weapon.ID] = hk.recurse_def_settings({}, AWFWeapons.RE3_Night_Sights[weapon.ID]); wc = wc or changed
                end

                changed, AWF_settings.RE3_Night_Sights[weapon.ID].ns_material_params.EmissiveIntensity = imgui.drag_float("Night Sight Intensity", AWF_settings.RE3_Night_Sights[weapon.ID].ns_material_params.EmissiveIntensity, 1.0, 0.0, 1000.0); wc = wc or changed

                local NS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE3_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.R, AWF_settings.RE3_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.G, AWF_settings.RE3_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.B, AWF_settings.RE3_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.A)
                changed, NS_EmissiveColor = imgui.color_picker4("Night Sight Color", NS_EmissiveColor); wc = wc or changed
                
                local R, G, B, A = func.convert_vector4f_to_rgba(NS_EmissiveColor)
                AWF_settings.RE3_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.R = R
                AWF_settings.RE3_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.G = G
                AWF_settings.RE3_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.B = B
                AWF_settings.RE3_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.A = A

                imgui.spacing()

                changed, AWF_settings.RE3_Night_Sights[weapon.ID].ds_material_params.EmissiveIntensity = imgui.drag_float("Dot Sight Intensity", AWF_settings.RE3_Night_Sights[weapon.ID].ds_material_params.EmissiveIntensity, 5.0, 0.0, 10000.0); wc = wc or changed

                local DS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE3_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.R, AWF_settings.RE3_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.G, AWF_settings.RE3_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.B, AWF_settings.RE3_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.A)
                changed, DS_EmissiveColor = imgui.color_picker4("Dot Sight Color", DS_EmissiveColor); wc = wc or changed
                
                local R2, G2, B2, A2 = func.convert_vector4f_to_rgba(DS_EmissiveColor)
                AWF_settings.RE3_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.R = R2
                AWF_settings.RE3_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.G = G2
                AWF_settings.RE3_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.B = B2
                AWF_settings.RE3_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.A = A2
                
                imgui.end_rect(2)
                imgui.tree_pop()
            end
            imgui.separator()
        end
        imgui.end_rect(1)
        imgui.end_window()
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK:RE4R
local RE4_Cache = {
    currentWeaponEnum = nil
}
--Returns the weapon.Enum values of the current weapons stored in the player inventory
sdk.hook(sdk.find_type_definition("chainsaw.Equipment"):get_method("getWeapon"),
    function(args)
        RE4_Cache.currentWeaponEnum = sdk.to_int64(args[3])
    end
)
--Sets the material params for the Night- and Dot Sights
local function toggle_night_sights_RE4(weaponData, NS_table)
    for _, weapon in pairs(weaponData) do
        if NS_table[weapon.ID] then
            local Weapon_GameObject_RE4 = scene:call("findGameObject(System.String)", weapon.ID)

            if Weapon_GameObject_RE4 then
                local render_mesh = Weapon_GameObject_RE4:call("getComponent(System.Type)", sdk.typeof("via.render.Mesh"))
                local MatCount = render_mesh:call("get_MaterialNum")
                    
                if MatCount then
                    for i = 0, MatCount - 1 do
                        local MatName = render_mesh:call("getMaterialName", i)
                        local MatParam = render_mesh:call("getMaterialVariableNum", i)
                        
                        if MatName:match("NightSight$") or MatName:match("NightSights$") or MatName:match("NSights$") or MatName:match("NSight$") or MatName:match("NS$") then
                            --log.info("---------------------------Got " .. MatName)
                            if MatParam then
                                for j = 0, MatParam - 1 do
                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                    
                                    if MatParamNames then
                                        if MatParamNames == "EmissiveColor" then
                                            render_mesh:call("setMaterialFloat4", i, j, func.convert_rgba_to_vector4f(NS_table[weapon.ID].ns_material_params.EmissiveColor.R, NS_table[weapon.ID].ns_material_params.EmissiveColor.G, NS_table[weapon.ID].ns_material_params.EmissiveColor.B, NS_table[weapon.ID].ns_material_params.EmissiveColor.A))
                                        end
                                        if MatParamNames == "EmissiveIntensity" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ns_material_params.EmissiveIntensity)
                                        end
                                        if MatParamNames == "EmissiveRate" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ns_material_params.EmissiveRate)
                                        end
                                    end
                                end
                            end
                        end
                        if MatName:match("DotSight$") or MatName:match("DSight$") or MatName:match("DS$") or MatName:match("RedDotSight$") or MatName:match("RDS$") then
                            --log.info("---------------------------Got " .. MatName)
                            if MatParam then
                                for k = 0, MatParam - 1 do
                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, k)
                                    
                                    if MatParamNames then
                                        if MatParamNames == "EmissiveColor" then
                                            render_mesh:call("setMaterialFloat4", i, k, func.convert_rgba_to_vector4f(NS_table[weapon.ID].ds_material_params.EmissiveColor.R, NS_table[weapon.ID].ds_material_params.EmissiveColor.G, NS_table[weapon.ID].ds_material_params.EmissiveColor.B, NS_table[weapon.ID].ds_material_params.EmissiveColor.A))
                                        end
                                        if MatParamNames == "EmissiveIntensity" then
                                            render_mesh:call("setMaterialFloat", i, k, NS_table[weapon.ID].ds_material_params.EmissiveIntensity)
                                        end
                                        if MatParamNames == "EmissiveRate" then
                                            render_mesh:call("setMaterialFloat", i, k, NS_table[weapon.ID].ds_material_params.EmissiveRate)
                                        end
                                    end
                                end
                            end
                        end
                        if MatName:match("Flashlight$") or MatName:match("FLight$") or MatName:match("FL$") then
                            --log.info("---------------------------Got " .. MatName)
                            if MatParam then
                                for v = 0, MatParam - 1 do
                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, v)
                                    
                                    if MatParamNames then
                                        if MatParamNames == "EmissiveColor" then
                                            render_mesh:call("setMaterialFloat4", i, v, func.convert_rgba_to_vector4f(NS_table[weapon.ID].fl_material_params.EmissiveColor.R, NS_table[weapon.ID].fl_material_params.EmissiveColor.G, NS_table[weapon.ID].fl_material_params.EmissiveColor.B, NS_table[weapon.ID].fl_material_params.EmissiveColor.A))
                                        end
                                        if MatParamNames == "EmissiveIntensity" then
                                            render_mesh:call("setMaterialFloat", i, v, NS_table[weapon.ID].fl_material_params.EmissiveIntensity)
                                        end
                                        if MatParamNames == "EmissiveRate" then
                                            render_mesh:call("setMaterialFloat", i, v, NS_table[weapon.ID].fl_material_params.EmissiveRate)
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
--Calls the material param setter function when the script is called for the first time
if reframework.get_game_name() == "re4" then
    toggle_night_sights_RE4(AWF.AWF_settings.RE4.Weapons, AWF_settings.RE4_Night_Sights)
end
--Updates the current state of the Night- and Dot Sights
local function update_night_sights_RE4(weaponData)
    local KM_controls = ((not AWF_NS_settings.use_modifier or hk.check_hotkey("Night Sight Modifier", false)) and hk.check_hotkey("Night Sight Switch")) or (hk.check_hotkey("Night Sight Modifier", true) and hk.check_hotkey("Night Sight Switch"))
    local PAD_controls = ((not AWF_NS_settings.use_pad_modifier or hk.check_hotkey("Pad Night Sight Modifier", false)) and hk.check_hotkey("Pad Night Sight Switch")) or (hk.check_hotkey("Pad Night Sight Modifier", true) and hk.check_hotkey("Pad Night Sight Switch"))

    if KM_controls or PAD_controls then
        for _, weapon in pairs(weaponData) do
            local NS_Params = AWF_settings.RE4_Night_Sights[weapon.ID]

            if NS_Params and RE4_Cache.currentWeaponEnum == weapon.Enum then
                NS_Params.ns_material_params.EmissiveRate = NS_Params.night_sight_toggled and 0.0 or 1.0
                NS_Params.night_sight_toggled = not NS_Params.night_sight_toggled
                NS_Params.ds_material_params.EmissiveRate = NS_Params.dotsight_toggled and 0.0 or 1.0
                NS_Params.dotsight_toggled = not NS_Params.dotsight_toggled
                toggle_night_sights_RE4(AWF.AWF_settings.RE4.Weapons, AWF_settings.RE4_Night_Sights)
                json.dump_file("AWF/AWF_NightSights/AWF_NightSight_ColorSettings.json", AWF_settings)
            end
        end
    end
end
--Draws the Night Sight Editor
local function draw_AWFNS_RE4Editor_GUI(weaponOrder)
    if imgui.begin_window("Advanced Weapon Framework: Night and Dot Sight Editor") then
        imgui.begin_rect()
        local weaponsByGame = {}
        local lastGame = nil

        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF.AWF_settings.RE4.Weapons[weaponName]
            if weapon then
                local game = weapon.Game
                if not weaponsByGame[game] then
                    weaponsByGame[game] = {}
                end
                table.insert(weaponsByGame[game], weapon)
            end
        end
            
        local gameModeLabels = {
            Main = "Main Game",
            SW = "Separate Ways",
            Mercs = "Mercenaries"
        }

        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF.AWF_settings.RE4.Weapons[weaponName]
            
            if weapon and weapon.Type ~= "KNF" then
                local textColor = {255,255,255,255}

                if weapon.Game == "Main" then
                    textColor = {255, 187, 0, 255}
                elseif weapon.Game == "SW" then
                    textColor = {245, 56, 81, 255}
                elseif weapon.Game == "Mercs" then
                    textColor = {0, 255, 219, 255}
                end

                if weapon.Game ~= lastGame then
                    imgui.text_colored("  [ " .. ui.draw_line("=", 30) .. " | " .. (gameModeLabels[weapon.Game] or weapon.Game) .. " | " .. ui.draw_line("=", 30) .. " ] ", func.convert_rgba_to_AGBR(textColor))
                    lastGame = weapon.Game
                end
                
                if imgui.tree_node(weapon.Name) then
                    imgui.begin_rect()
                    imgui.spacing()
                    imgui.indent(5)
                    if imgui.button("Reset to Defaults") then
                        AWF_settings.RE4_Night_Sights[weapon.ID] = hk.recurse_def_settings({}, AWFWeapons.RE4_Night_Sights[weapon.ID]); wc = wc or changed
                    end

                    changed, AWF_settings.RE4_Night_Sights[weapon.ID].ns_material_params.EmissiveIntensity = imgui.drag_float("Night Sight Intensity", AWF_settings.RE4_Night_Sights[weapon.ID].ns_material_params.EmissiveIntensity, 1.0, 0.0, 1000.0); wc = wc or changed

                    local NS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE4_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.R, AWF_settings.RE4_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.G, AWF_settings.RE4_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.B, AWF_settings.RE4_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.A)
                    changed, NS_EmissiveColor = imgui.color_edit4("Night Sight Color", NS_EmissiveColor); wc = wc or changed
                    
                    local R, G, B, A = func.convert_vector4f_to_rgba(NS_EmissiveColor)
                    AWF_settings.RE4_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.R = R
                    AWF_settings.RE4_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.G = G
                    AWF_settings.RE4_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.B = B
                    AWF_settings.RE4_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.A = A

                    imgui.spacing()

                    changed, AWF_settings.RE4_Night_Sights[weapon.ID].ds_material_params.EmissiveIntensity = imgui.drag_float("Dot Sight Intensity", AWF_settings.RE4_Night_Sights[weapon.ID].ds_material_params.EmissiveIntensity, 5.0, 0.0, 10000.0); wc = wc or changed

                    local DS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE4_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.R, AWF_settings.RE4_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.G, AWF_settings.RE4_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.B, AWF_settings.RE4_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.A)
                    changed, DS_EmissiveColor = imgui.color_edit4("Dot Sight Color", DS_EmissiveColor); wc = wc or changed
                    
                    local R2, G2, B2, A2 = func.convert_vector4f_to_rgba(DS_EmissiveColor)
                    AWF_settings.RE4_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.R = R2
                    AWF_settings.RE4_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.G = G2
                    AWF_settings.RE4_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.B = B2
                    AWF_settings.RE4_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.A = A2
                    
                    -- if weapon.ID == "ri3124_Inventory" then
                    --     imgui.spacing()

                    --     changed, AWF_settings.RE4_Night_Sights[weapon.ID].fl_material_params.EmissiveIntensity = imgui.drag_float("Gun Light Intensity", AWF_settings.RE4_Night_Sights[weapon.ID].fl_material_params.EmissiveIntensity, 5.0, 0.0, 10000.0); wc = wc or changed

                    --     local FL_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE4_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.R, AWF_settings.RE4_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.G, AWF_settings.RE4_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.B, AWF_settings.RE4_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.A)
                    --     changed, FL_EmissiveColor = imgui.color_picker4("Gun Light Color", FL_EmissiveColor); wc = wc or changed
                        
                    --     local R3, G3, B3, A3 = func.convert_vector4f_to_rgba(FL_EmissiveColor)
                    --     AWF_settings.RE4_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.R = R3
                    --     AWF_settings.RE4_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.G = G3
                    --     AWF_settings.RE4_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.B = B3
                    --     AWF_settings.RE4_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.A = A3
                    -- end
                    imgui.indent(-5)
                    imgui.spacing()
                    imgui.end_rect(2)
                    imgui.tree_pop()
                end

                imgui.text_colored("  " .. ui.draw_line("-", 100) .."  ", func.convert_rgba_to_AGBR(255,255,255,255))
            end
        end
        imgui.end_rect(1)
        imgui.end_window()
    end
end
--Draws the AWFNS GUI for the 'Script Generated UI' tab in the main REF Window
local function draw_AWFNS_GUI()
    if imgui.tree_node("Advanced Weapon Framework: Night Sights") then
        imgui.begin_rect()
        imgui.spacing()
        imgui.indent(5)
        if imgui.button("Reset to Defaults") then
            AWF_NS_settings = hk.recurse_def_settings({}, AWF_NS_default_settings); wc = wc or changed
            hk.reset_from_defaults_tbl(AWF_NS_default_settings.hotkeys)
            AWF_settings = hk.recurse_def_settings({}, AWFWeapons); wc = wc or changed
        end
        func.tooltip("Reset every parameter.")
        
        imgui.same_line()

        changed, show_AWFNS_editor = imgui.checkbox("Open AWF Night Sight Editor", show_AWFNS_editor)
        func.tooltip("Show/Hide the AWF Night Sight Editor.")

        if not show_AWFNS_editor or imgui.begin_window("Advanced Weapon Framework: Night and Dot Sight Editor", true, 0) == false  then
            show_AWFNS_editor = false
        else
            imgui.spacing()
            imgui.indent()

            draw_AWFNS_RE4Editor_GUI(AWF.AWF_settings.RE4.Weapon_Order)

            imgui.unindent()
            imgui.end_window()
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
                changed = hk.hotkey_setter("Night Sight Modifier"); wc = wc or changed
                changed = hk.hotkey_setter("Night Sight Switch", AWF_NS_settings.use_modifier and "Night Sight Modifier"); wc = wc or changed
                imgui.tree_pop()
            end
            
            if imgui.tree_node("Gamepad Settings") then
                changed, AWF_NS_settings.use_pad_modifier = imgui.checkbox(" ", AWF_NS_settings.use_pad_modifier); wc = wc or changed
                func.tooltip("Require that you hold down this button")
                imgui.same_line()
                changed = hk.hotkey_setter("Pad Night Sight Modifier"); wc = wc or changed
                changed = hk.hotkey_setter("Pad Night Sight Switch", AWF_NS_settings.use_pad_modifier and "Pad Night Sight Modifier"); wc = wc or changed
                imgui.tree_pop()
            end
        end
        imgui.end_rect(2)
        
        -- imgui.spacing()

        -- imgui.begin_rect()
        -- changed, AWF_NS_settings.fl_input_mode_idx = imgui.combo("Gun Light: Input Settings", AWF_NS_settings.fl_input_mode_idx, {"Default", "Custom"}); wc = wc or changed
        -- func.tooltip("Set the control scheme for the mod")
        -- if AWF_NS_settings.fl_input_mode_idx == 2 then
        --     if imgui.tree_node("Keyboard and Mouse Settings") then
        --         changed, AWF_NS_settings.fl_use_modifier = imgui.checkbox(" ", AWF_NS_settings.fl_use_modifier); wc = wc or changed
        --         func.tooltip("Require that you hold down this button")
        --         imgui.same_line()
        --         changed = hk.hotkey_setter("Gun Light Modifier"); wc = wc or changed
        --         changed = hk.hotkey_setter("Gun Light Switch", AWF_NS_settings.fl_use_modifier and "Gun Light Modifier"); wc = wc or changed
        --         imgui.tree_pop()
        --     end
            
        --     if imgui.tree_node("Gamepad Settings") then
        --         changed, AWF_NS_settings.fl_use_pad_modifier = imgui.checkbox(" ", AWF_NS_settings.fl_use_pad_modifier); wc = wc or changed
        --         func.tooltip("Require that you hold down this button")
        --         imgui.same_line()
        --         changed = hk.hotkey_setter("Pad Gun Light Modifier"); wc = wc or changed
        --         changed = hk.hotkey_setter("Pad Gun Light Switch", AWF_NS_settings.fl_use_pad_modifier and "Pad Gun Light Modifier"); wc = wc or changed
        --         imgui.tree_pop()
        --     end
        -- end
        -- imgui.end_rect(3)

        ui.button_n_colored_txt("Current Version:", modVersion .. " | " .. modUpdated, func.convert_rgba_to_AGBR(0, 255, 0, 255))
        imgui.same_line()
        imgui.text("| by " .. modAuthor .. " ")
        
        if show_AWFNS_editor and changed or wc then
            hk.update_hotkey_table(AWF_NS_settings.hotkeys)
            json.dump_file("AWF/AWF_NightSights/AWF_NightSight_Settings.json", AWF_NS_settings)
            json.dump_file("AWF/AWF_NightSights/AWF_NightSight_ColorSettings.json", AWF_settings)
            changed = false
            wc = false
        end

        imgui.indent(-5)
        imgui.spacing()
        imgui.end_rect(1)
        imgui.tree_pop()
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK:RE7
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
                            
                            if MatName:match("NightSight$") or MatName:match("NightSights$") or MatName:match("NSights$") or MatName:match("NSight$") or MatName:match("NS$") then
                                --log.info("---------------------------Got " .. MatName)

                                if MatParam then
                                    --log.info("------------" .. MatParam .. " Material Params")
                                
                                    for j = 0, MatParam - 1 do
                                        local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                        
                                        if MatParamNames then
                                            --log.info(MatParamNames)

                                            if MatParamNames == "EmissiveColor" then
                                                render_mesh:call("setMaterialFloat4", i, j, func.convert_rgba_to_vector4f(NS_table[weapon.ID].ns_material_params.EmissiveColor.R, NS_table[weapon.ID].ns_material_params.EmissiveColor.G, NS_table[weapon.ID].ns_material_params.EmissiveColor.B, NS_table[weapon.ID].ns_material_params.EmissiveColor.A))
                                            end

                                            if MatParamNames == "EmissiveIntensity" then
                                                render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ns_material_params.EmissiveIntensity)
                                            end

                                            if MatParamNames == "EmissiveRate" then
                                                render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ns_material_params.EmissiveRate)
                                            end
                                        end
                                    end
                                end
                            end
                            if MatName:match("DotSight$") or MatName:match("DSight$") or MatName:match("DS$") or MatName:match("RedDotSight$") or MatName:match("RDS$") then
                                if MatParam then
                                    for j = 0, MatParam - 1 do
                                        local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                        
                                        if MatParamNames then
                                            if MatParamNames == "EmissiveColor" then
                                                render_mesh:call("setMaterialFloat4", i, j, func.convert_rgba_to_vector4f(NS_table[weapon.ID].ds_material_params.EmissiveColor.R, NS_table[weapon.ID].ds_material_params.EmissiveColor.G, NS_table[weapon.ID].ds_material_params.EmissiveColor.B, NS_table[weapon.ID].ds_material_params.EmissiveColor.A))
                                            end
                                            if MatParamNames == "EmissiveIntensity" then
                                                render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ds_material_params.EmissiveIntensity)
                                            end
                                            if MatParamNames == "EmissiveRate" then
                                                render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ds_material_params.EmissiveRate)
                                            end
                                        end
                                    end
                                end
                            end
                            if MatName:match("Flashlight$") or MatName:match("FLight$") or MatName:match("FL$") then
                                if MatParam then
                                    for j = 0, MatParam - 1 do
                                        local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                        
                                        if MatParamNames then
                                            if MatParamNames == "EmissiveColor" then
                                                render_mesh:call("setMaterialFloat4", i, j, func.convert_rgba_to_vector4f(NS_table[weapon.ID].fl_material_params.EmissiveColor.R, NS_table[weapon.ID].fl_material_params.EmissiveColor.G, NS_table[weapon.ID].fl_material_params.EmissiveColor.B, NS_table[weapon.ID].fl_material_params.EmissiveColor.A))
                                            end
                                            if MatParamNames == "EmissiveIntensity" then
                                                render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].fl_material_params.EmissiveIntensity)
                                            end
                                            if MatParamNames == "EmissiveRate" then
                                                render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].fl_material_params.EmissiveRate)
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
if reframework.get_game_name() == "re7" then
    toggle_night_sights_RE7(AWF.AWF_settings.RE7.Weapons, AWF_settings.RE7_Night_Sights)
end
local function update_night_sights_RE7(weaponData)
    local KM_controls = ((not AWF_NS_settings.use_modifier or hk.check_hotkey("Night Sight Modifier", false)) and hk.check_hotkey("Night Sight Switch")) or (hk.check_hotkey("Night Sight Modifier", true) and hk.check_hotkey("Night Sight Switch"))
    local PAD_controls = ((not AWF_NS_settings.use_pad_modifier or hk.check_hotkey("Pad Night Sight Modifier", false)) and hk.check_hotkey("Pad Night Sight Switch")) or (hk.check_hotkey("Pad Night Sight Modifier", true) and hk.check_hotkey("Pad Night Sight Switch"))

    if KM_controls or PAD_controls then
        for _, weapon in pairs(weaponData) do
            local NS_Params = AWF_settings.RE7_Night_Sights[weapon.ID]

            if NS_Params then
                NS_Params.ns_material_params.EmissiveRate = NS_Params.night_sight_toggled and 0.0 or 1.0
                NS_Params.night_sight_toggled = not NS_Params.night_sight_toggled
                NS_Params.ds_material_params.EmissiveRate = NS_Params.dotsight_toggled and 0.0 or 1.0
                NS_Params.dotsight_toggled = not NS_Params.dotsight_toggled
                toggle_night_sights_RE7(AWF.AWF_settings.RE7.Weapons, AWF_settings.RE7_Night_Sights)
            end
        end
    end
end
local function draw_AWFNS_RE7Editor_GUI(weaponOrder)
    if imgui.begin_window("AWF Night Sight Editor") then
        imgui.begin_rect()
        imgui.button("[==============| AWF NIGHT SIGHT EDITOR |==============]")

        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF.AWF_settings.RE7.Weapons[weaponName]

            if weapon.Type ~= "Ammo" and weapon.Type ~= "KNF" and imgui.tree_node(string.upper(weapon.Name)) then
                imgui.begin_rect()
                imgui.spacing()

                if imgui.button("Reset to Defaults") then
                    wc = true
                    AWF_settings.RE7_Night_Sights[weapon.ID] = hk.recurse_def_settings({}, AWFWeapons.RE7_Night_Sights[weapon.ID]); wc = wc or changed
                end

                changed, AWF_settings.RE7_Night_Sights[weapon.ID].ns_material_params.EmissiveIntensity = imgui.drag_float("Intensity", AWF_settings.RE7_Night_Sights[weapon.ID].ns_material_params.EmissiveIntensity, 1.0, 0.0, 1000.0); wc = wc or changed

                local NS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE7_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.R, AWF_settings.RE7_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.G, AWF_settings.RE7_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.B, AWF_settings.RE7_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.A)
                changed, NS_EmissiveColor = imgui.color_picker4("Night Sight Color", NS_EmissiveColor); wc = wc or changed
                
                local R, G, B, A = func.convert_vector4f_to_rgba(NS_EmissiveColor)
                AWF_settings.RE7_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.R = R
                AWF_settings.RE7_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.G = G
                AWF_settings.RE7_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.B = B
                AWF_settings.RE7_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.A = A

                imgui.spacing()

                changed, AWF_settings.RE7_Night_Sights[weapon.ID].ds_material_params.EmissiveIntensity = imgui.drag_float("Dot Sight Intensity", AWF_settings.RE7_Night_Sights[weapon.ID].ds_material_params.EmissiveIntensity, 5.0, 0.0, 10000.0); wc = wc or changed

                local DS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE7_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.R, AWF_settings.RE7_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.G, AWF_settings.RE7_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.B, AWF_settings.RE7_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.A)
                changed, DS_EmissiveColor = imgui.color_picker4("Dot Sight Color", DS_EmissiveColor); wc = wc or changed
                
                local R2, G2, B2, A2 = func.convert_vector4f_to_rgba(DS_EmissiveColor)
                AWF_settings.RE7_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.R = R2
                AWF_settings.RE7_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.G = G2
                AWF_settings.RE7_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.B = B2
                AWF_settings.RE7_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.A = A2
                
                imgui.end_rect(2)
                imgui.tree_pop()
            end
            imgui.separator()
        end
        imgui.end_rect(1)
        imgui.end_window()
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK:RE8
local function toggle_night_sights_RE8(weaponData, NS_table)
    for _, weapon in pairs(weaponData) do
        if NS_table[weapon.ID] then
            local Weapon_GameObject_RE8 = scene:call("findGameObject(System.String)", weapon.ID)

            if Weapon_GameObject_RE8 then
                local render_mesh = Weapon_GameObject_RE8:call("getComponent(System.Type)", sdk.typeof("via.render.Mesh"))
                local MatCount = render_mesh:call("get_MaterialNum")
                    
                if MatCount then
                    for i = 0, MatCount - 1 do
                        local MatName = render_mesh:call("getMaterialName", i)
                        local MatParam = render_mesh:call("getMaterialVariableNum", i)
                        
                        if MatName:match("NightSight$") or MatName:match("NightSights$") or MatName:match("NSights$") or MatName:match("NSight$") or MatName:match("NS$") then
                            --log.info("---------------------------Got " .. MatName)
                            if MatParam then
                                for j = 0, MatParam - 1 do
                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                    
                                    if MatParamNames then
                                        if MatParamNames == "EmissiveColor" then
                                            render_mesh:call("setMaterialFloat4", i, j, func.convert_rgba_to_vector4f(NS_table[weapon.ID].ns_material_params.EmissiveColor.R, NS_table[weapon.ID].ns_material_params.EmissiveColor.G, NS_table[weapon.ID].ns_material_params.EmissiveColor.B, NS_table[weapon.ID].ns_material_params.EmissiveColor.A))
                                        end
                                        if MatParamNames == "EmissiveIntensity" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ns_material_params.EmissiveIntensity)
                                        end
                                        if MatParamNames == "EmissiveRate" then
                                            render_mesh:call("setMaterialFloat", i, j, NS_table[weapon.ID].ns_material_params.EmissiveRate)
                                        end
                                    end
                                end
                            end
                        end
                        if MatName:match("DotSight$") or MatName:match("DSight$") or MatName:match("DS$") or MatName:match("RedDotSight$") or MatName:match("RDS$") then
                            --log.info("---------------------------Got " .. MatName)
                            if MatParam then
                                for k = 0, MatParam - 1 do
                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, k)
                                    
                                    if MatParamNames then
                                        if MatParamNames == "EmissiveColor" then
                                            render_mesh:call("setMaterialFloat4", i, k, func.convert_rgba_to_vector4f(NS_table[weapon.ID].ds_material_params.EmissiveColor.R, NS_table[weapon.ID].ds_material_params.EmissiveColor.G, NS_table[weapon.ID].ds_material_params.EmissiveColor.B, NS_table[weapon.ID].ds_material_params.EmissiveColor.A))
                                        end
                                        if MatParamNames == "EmissiveIntensity" then
                                            render_mesh:call("setMaterialFloat", i, k, NS_table[weapon.ID].ds_material_params.EmissiveIntensity)
                                        end
                                        if MatParamNames == "EmissiveRate" then
                                            render_mesh:call("setMaterialFloat", i, k, NS_table[weapon.ID].ds_material_params.EmissiveRate)
                                        end
                                    end
                                end
                            end
                        end
                        if MatName:match("Flashlight$") or MatName:match("FLight$") or MatName:match("FL$") then
                            --log.info("---------------------------Got " .. MatName)
                            if MatParam then
                                for v = 0, MatParam - 1 do
                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, v)
                                    
                                    if MatParamNames then
                                        if MatParamNames == "EmissiveColor" then
                                            render_mesh:call("setMaterialFloat4", i, v, func.convert_rgba_to_vector4f(NS_table[weapon.ID].fl_material_params.EmissiveColor.R, NS_table[weapon.ID].fl_material_params.EmissiveColor.G, NS_table[weapon.ID].fl_material_params.EmissiveColor.B, NS_table[weapon.ID].fl_material_params.EmissiveColor.A))
                                        end
                                        if MatParamNames == "EmissiveIntensity" then
                                            render_mesh:call("setMaterialFloat", i, v, NS_table[weapon.ID].fl_material_params.EmissiveIntensity)
                                        end
                                        if MatParamNames == "EmissiveRate" then
                                            render_mesh:call("setMaterialFloat", i, v, NS_table[weapon.ID].fl_material_params.EmissiveRate)
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
if reframework.get_game_name() == "re8" then
    toggle_night_sights_RE8(AWF.AWF_settings.RE8.Weapons, AWF_settings.RE8_Night_Sights)
end
local function update_night_sights_RE8(weaponData)
    local KM_controls = ((not AWF_NS_settings.use_modifier or hk.check_hotkey("Night Sight Modifier", false)) and hk.check_hotkey("Night Sight Switch")) or (hk.check_hotkey("Night Sight Modifier", true) and hk.check_hotkey("Night Sight Switch"))
    local PAD_controls = ((not AWF_NS_settings.use_pad_modifier or hk.check_hotkey("Pad Night Sight Modifier", false)) and hk.check_hotkey("Pad Night Sight Switch")) or (hk.check_hotkey("Pad Night Sight Modifier", true) and hk.check_hotkey("Pad Night Sight Switch"))

    if KM_controls or PAD_controls then
        for _, weapon in pairs(weaponData) do
            local NS_Params = AWF_settings.RE8_Night_Sights[weapon.ID]

            if NS_Params then
                NS_Params.ns_material_params.EmissiveRate = NS_Params.night_sight_toggled and 0.0 or 1.0
                NS_Params.night_sight_toggled = not NS_Params.night_sight_toggled
                NS_Params.ds_material_params.EmissiveRate = NS_Params.dotsight_toggled and 0.0 or 1.0
                NS_Params.dotsight_toggled = not NS_Params.dotsight_toggled
                toggle_night_sights_RE8(AWF.AWF_settings.RE8.Weapons, AWF_settings.RE8_Night_Sights)
            end
        end
    end
end
local function update_gun_light_RE8(weaponData)
    local KM_controls = ((not AWF_NS_settings.fl_use_modifier or hk.check_hotkey("Gun Light Modifier", false)) and hk.check_hotkey("Gun Light Switch")) or (hk.check_hotkey("Gun Light Modifier", true) and hk.check_hotkey("Gun Light Switch"))
    local PAD_controls = ((not AWF_NS_settings.fl_use_pad_modifier or hk.check_hotkey("Pad Gun Light Modifier", false)) and hk.check_hotkey("Pad Gun Light Switch")) or (hk.check_hotkey("Pad Gun Light Modifier", true) and hk.check_hotkey("Pad Gun Light Switch"))

    if KM_controls or PAD_controls then
        for _, weapon in pairs(weaponData) do
            local NS_Params = AWF_settings.RE8_Night_Sights[weapon.ID]

            if NS_Params then
                NS_Params.fl_material_params.EmissiveRate = NS_Params.flashlight_toggled and 0.0 or 1.0
                NS_Params.flashlight_toggled = not NS_Params.flashlight_toggled
                toggle_night_sights_RE8(AWF.AWF_settings.RE8.Weapons, AWF_settings.RE8_Night_Sights)
            end
        end
    end
end
local function draw_AWFNS_RE8Editor_GUI(weaponOrder)
    if imgui.begin_window("AWF Night Sight Editor") then
        imgui.begin_rect()
        imgui.button("[==============| AWF NIGHT SIGHT EDITOR |==============]")

        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF.AWF_settings.RE8.Weapons[weaponName]

            if imgui.tree_node(string.upper(weapon.Name)) then
                imgui.begin_rect()
                imgui.spacing()

                if imgui.button("Reset to Defaults") then
                    wc = true
                    AWF_settings.RE8_Night_Sights[weapon.ID] = hk.recurse_def_settings({}, AWFWeapons.RE8_Night_Sights[weapon.ID]); wc = wc or changed
                end

                changed, AWF_settings.RE8_Night_Sights[weapon.ID].ns_material_params.EmissiveIntensity = imgui.drag_float("Night Sight Intensity", AWF_settings.RE8_Night_Sights[weapon.ID].ns_material_params.EmissiveIntensity, 1.0, 0.0, 1000.0); wc = wc or changed

                local NS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE8_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.R, AWF_settings.RE8_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.G, AWF_settings.RE8_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.B, AWF_settings.RE8_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.A)
                changed, NS_EmissiveColor = imgui.color_picker4("Night Sight Color", NS_EmissiveColor); wc = wc or changed
                
                local R, G, B, A = func.convert_vector4f_to_rgba(NS_EmissiveColor)
                AWF_settings.RE8_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.R = R
                AWF_settings.RE8_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.G = G
                AWF_settings.RE8_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.B = B
                AWF_settings.RE8_Night_Sights[weapon.ID].ns_material_params.EmissiveColor.A = A

                imgui.spacing()

                changed, AWF_settings.RE8_Night_Sights[weapon.ID].ds_material_params.EmissiveIntensity = imgui.drag_float("Dot Sight Intensity", AWF_settings.RE8_Night_Sights[weapon.ID].ds_material_params.EmissiveIntensity, 5.0, 0.0, 10000.0); wc = wc or changed

                local DS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE8_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.R, AWF_settings.RE8_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.G, AWF_settings.RE8_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.B, AWF_settings.RE8_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.A)
                changed, DS_EmissiveColor = imgui.color_picker4("Dot Sight Color", DS_EmissiveColor); wc = wc or changed
                
                local R2, G2, B2, A2 = func.convert_vector4f_to_rgba(DS_EmissiveColor)
                AWF_settings.RE8_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.R = R2
                AWF_settings.RE8_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.G = G2
                AWF_settings.RE8_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.B = B2
                AWF_settings.RE8_Night_Sights[weapon.ID].ds_material_params.EmissiveColor.A = A2
                
                if weapon.ID == "ri3124_Inventory" then
                    imgui.spacing()

                    changed, AWF_settings.RE8_Night_Sights[weapon.ID].fl_material_params.EmissiveIntensity = imgui.drag_float("Gun Light Intensity", AWF_settings.RE8_Night_Sights[weapon.ID].fl_material_params.EmissiveIntensity, 5.0, 0.0, 10000.0); wc = wc or changed

                    local FL_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE8_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.R, AWF_settings.RE8_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.G, AWF_settings.RE8_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.B, AWF_settings.RE8_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.A)
                    changed, FL_EmissiveColor = imgui.color_picker4("Gun Light Color", FL_EmissiveColor); wc = wc or changed
                    
                    local R3, G3, B3, A3 = func.convert_vector4f_to_rgba(FL_EmissiveColor)
                    AWF_settings.RE8_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.R = R3
                    AWF_settings.RE8_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.G = G3
                    AWF_settings.RE8_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.B = B3
                    AWF_settings.RE8_Night_Sights[weapon.ID].fl_material_params.EmissiveColor.A = A3
                end
                imgui.end_rect(2)
                imgui.tree_pop()
            end
            imgui.separator()
        end
        imgui.end_rect(1)
        imgui.end_window()
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK:On Frame
re.on_frame(function()
    if reframework.get_game_name() == "re2" then
        update_night_sights_RE2(AWF.AWF_settings.RE2.Weapons)
    end
    if reframework.get_game_name() == "re3" then
        update_night_sights_RE3(AWF.AWF_settings.RE3.Weapons)
    end
    if reframework.get_game_name() == "re4" then
        update_night_sights_RE4(AWF.AWF_settings.RE4.Weapons)
    end
    if reframework.get_game_name() == "re7" then
        update_night_sights_RE7(AWF.AWF_settings.RE7.Weapons)
    end
    if reframework.get_game_name() == "re8" then
        update_gun_light_RE8(AWF.AWF_settings.RE8.Weapons)
        update_night_sights_RE8(AWF.AWF_settings.RE8.Weapons)
    end
end)

--MARK:On Draw UI
re.on_draw_ui(function()
    if reframework.get_game_name() == "re2" then
        if imgui.tree_node("AWF - Night Sights") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_NS_settings = hk.recurse_def_settings({}, AWF_NS_default_settings); wc = wc or changed
                hk.reset_from_defaults_tbl(AWF_NS_default_settings.hotkeys)
                AWF_settings = hk.recurse_def_settings({}, AWFWeapons); wc = wc or changed
            end
            func.tooltip("Reset every parameter.")
            
            imgui.spacing()

            changed, show_AWFNS_editor = imgui.checkbox("Open AWF Night Sight Editor", show_AWFNS_editor)
            func.tooltip("Show/Hide the AWF Night Sight Editor.")

            if show_AWFNS_editor then
                draw_AWFNS_RE2Editor_GUI(AWF.AWF_settings.RE2.Weapon_Order)
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
                    changed = hk.hotkey_setter("Night Sight Modifier"); wc = wc or changed
                    changed = hk.hotkey_setter("Night Sight Switch", AWF_NS_settings.use_modifier and "Night Sight Modifier"); wc = wc or changed
                    imgui.tree_pop()
                end
                
                if imgui.tree_node("Gamepad Settings") then
                    changed, AWF_NS_settings.use_pad_modifier = imgui.checkbox(" ", AWF_NS_settings.use_pad_modifier); wc = wc or changed
                    func.tooltip("Require that you hold down this button")
                    imgui.same_line()
                    changed = hk.hotkey_setter("Pad Night Sight Modifier"); wc = wc or changed
                    changed = hk.hotkey_setter("Pad Night Sight Switch", AWF_NS_settings.use_pad_modifier and "Pad Night Sight Modifier"); wc = wc or changed
                    imgui.tree_pop()
                end
            end
            imgui.end_rect(2)

            ui.button_n_colored_txt("Current Version:", "v1.8.0 | 03/05/2024", 0xFF00FF00)
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
    if reframework.get_game_name() == "re3" then
        if imgui.tree_node("AWF - Night Sights") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_NS_settings = hk.recurse_def_settings({}, AWF_NS_default_settings); wc = wc or changed
                hk.reset_from_defaults_tbl(AWF_NS_default_settings.hotkeys)
                AWF_settings = hk.recurse_def_settings({}, AWFWeapons); wc = wc or changed
            end
            func.tooltip("Reset every parameter.")
            
            imgui.spacing()

            changed, show_AWFNS_editor = imgui.checkbox("Open AWF Night Sight Editor", show_AWFNS_editor)
            func.tooltip("Show/Hide the AWF Night Sight Editor.")

            if show_AWFNS_editor then
                draw_AWFNS_RE3Editor_GUI(AWF.AWF_settings.RE3.Weapon_Order)
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
                    changed = hk.hotkey_setter("Night Sight Modifier"); wc = wc or changed
                    changed = hk.hotkey_setter("Night Sight Switch", AWF_NS_settings.use_modifier and "Night Sight Modifier"); wc = wc or changed
                    imgui.tree_pop()
                end
                
                if imgui.tree_node("Gamepad Settings") then
                    changed, AWF_NS_settings.use_pad_modifier = imgui.checkbox(" ", AWF_NS_settings.use_pad_modifier); wc = wc or changed
                    func.tooltip("Require that you hold down this button")
                    imgui.same_line()
                    changed = hk.hotkey_setter("Pad Night Sight Modifier"); wc = wc or changed
                    changed = hk.hotkey_setter("Pad Night Sight Switch", AWF_NS_settings.use_pad_modifier and "Pad Night Sight Modifier"); wc = wc or changed
                    imgui.tree_pop()
                end
            end
            imgui.end_rect(2)

            ui.button_n_colored_txt("Current Version:", "v1.8.0 | 03/05/2024", 0xFF00FF00)
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
    if reframework.get_game_name() == "re4" then
        draw_AWFNS_GUI()
    end
    if reframework.get_game_name() == "re7" then
        imgui.begin_rect()
        if imgui.tree_node("AWF - Night Sights") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_NS_settings = hk.recurse_def_settings({}, AWF_NS_default_settings); wc = wc or changed
                hk.reset_from_defaults_tbl(AWF_NS_default_settings.hotkeys)
                AWF_settings = hk.recurse_def_settings({}, AWFWeapons); wc = wc or changed
            end
            
            changed, show_AWFNS_editor = imgui.checkbox("Open AWF Night Sight Editor", show_AWFNS_editor)
            func.tooltip("Show/Hide the AWF Night Sight Editor.")

            if show_AWFNS_editor then
                draw_AWFNS_RE7Editor_GUI(AWF.AWF_settings.RE7.Weapon_Order)
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
                    changed = hk.hotkey_setter("Night Sight Modifier"); wc = wc or changed
                    changed = hk.hotkey_setter("Night Sight Switch", AWF_NS_settings.use_modifier and "Night Sight Modifier"); wc = wc or changed
                    imgui.tree_pop()
                end
                
                if imgui.tree_node("Gamepad Settings") then
                    changed, AWF_NS_settings.use_pad_modifier = imgui.checkbox(" ", AWF_NS_settings.use_pad_modifier); wc = wc or changed
                    func.tooltip("Require that you hold down this button")
                    imgui.same_line()
                    changed = hk.hotkey_setter("Pad Night Sight Modifier"); wc = wc or changed
                    changed = hk.hotkey_setter("Pad Night Sight Switch", AWF_NS_settings.use_pad_modifier and "Pad Night Sight Modifier"); wc = wc or changed
                    imgui.tree_pop()
                end
            end
            imgui.end_rect(2)

            ui.button_n_colored_txt("Current Version:", "v1.8.0 | 03/05/2024", 0xFF00FF00)
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
    if reframework.get_game_name() == "re8" then
        if imgui.tree_node("AWF - Night Sights") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_NS_settings = hk.recurse_def_settings({}, AWF_NS_default_settings); wc = wc or changed
                hk.reset_from_defaults_tbl(AWF_NS_default_settings.hotkeys)
                AWF_settings = hk.recurse_def_settings({}, AWFWeapons); wc = wc or changed
            end
            func.tooltip("Reset every parameter.")
            
            imgui.spacing()

            changed, show_AWFNS_editor = imgui.checkbox("Open AWF Night Sight Editor", show_AWFNS_editor)
            func.tooltip("Show/Hide the AWF Night Sight Editor.")

            if show_AWFNS_editor then
                draw_AWFNS_RE8Editor_GUI(AWF.AWF_settings.RE8.Weapon_Order)
            end
            
            imgui.spacing()

            imgui.begin_rect()
            changed, AWF_NS_settings.input_mode_idx = imgui.combo("Night Sight and Dot Sight: Input Settings", AWF_NS_settings.input_mode_idx, {"Default", "Custom"}); wc = wc or changed
            func.tooltip("Set the control scheme for the mod")
            if AWF_NS_settings.input_mode_idx == 2 then
                if imgui.tree_node("Keyboard and Mouse Settings") then
                    changed, AWF_NS_settings.use_modifier = imgui.checkbox(" ", AWF_NS_settings.use_modifier); wc = wc or changed
                    func.tooltip("Require that you hold down this button")
                    imgui.same_line()
                    changed = hk.hotkey_setter("Night Sight Modifier"); wc = wc or changed
                    changed = hk.hotkey_setter("Night Sight Switch", AWF_NS_settings.use_modifier and "Night Sight Modifier"); wc = wc or changed
                    imgui.tree_pop()
                end
                
                if imgui.tree_node("Gamepad Settings") then
                    changed, AWF_NS_settings.use_pad_modifier = imgui.checkbox(" ", AWF_NS_settings.use_pad_modifier); wc = wc or changed
                    func.tooltip("Require that you hold down this button")
                    imgui.same_line()
                    changed = hk.hotkey_setter("Pad Night Sight Modifier"); wc = wc or changed
                    changed = hk.hotkey_setter("Pad Night Sight Switch", AWF_NS_settings.use_pad_modifier and "Pad Night Sight Modifier"); wc = wc or changed
                    imgui.tree_pop()
                end
            end
            imgui.end_rect(2)
            
            imgui.spacing()

            imgui.begin_rect()
            changed, AWF_NS_settings.fl_input_mode_idx = imgui.combo("Gun Light: Input Settings", AWF_NS_settings.fl_input_mode_idx, {"Default", "Custom"}); wc = wc or changed
            func.tooltip("Set the control scheme for the mod")
            if AWF_NS_settings.fl_input_mode_idx == 2 then
                if imgui.tree_node("Keyboard and Mouse Settings") then
                    changed, AWF_NS_settings.fl_use_modifier = imgui.checkbox(" ", AWF_NS_settings.fl_use_modifier); wc = wc or changed
                    func.tooltip("Require that you hold down this button")
                    imgui.same_line()
                    changed = hk.hotkey_setter("Gun Light Modifier"); wc = wc or changed
                    changed = hk.hotkey_setter("Gun Light Switch", AWF_NS_settings.fl_use_modifier and "Gun Light Modifier"); wc = wc or changed
                    imgui.tree_pop()
                end
                
                if imgui.tree_node("Gamepad Settings") then
                    changed, AWF_NS_settings.fl_use_pad_modifier = imgui.checkbox(" ", AWF_NS_settings.fl_use_pad_modifier); wc = wc or changed
                    func.tooltip("Require that you hold down this button")
                    imgui.same_line()
                    changed = hk.hotkey_setter("Pad Gun Light Modifier"); wc = wc or changed
                    changed = hk.hotkey_setter("Pad Gun Light Switch", AWF_NS_settings.fl_use_pad_modifier and "Pad Gun Light Modifier"); wc = wc or changed
                    imgui.tree_pop()
                end
            end
            imgui.end_rect(3)

            ui.button_n_colored_txt("Current Version:", "v1.8.0 | 03/05/2024", 0xFF00FF00)
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

--Functions that are accessible outside of this script
AWFNS = {
    AWFNS_Settings = AWF_settings,
    toggle_night_sights_RE2 = toggle_night_sights_RE2,
    toggle_night_sights_RE3 = toggle_night_sights_RE3,
    toggle_night_sights_RE4 = toggle_night_sights_RE4,
    toggle_night_sights_RE7 = toggle_night_sights_RE7,
    toggle_night_sights_RE8 = toggle_night_sights_RE8,
}
return AWFNS