--/////////////////////////////////////--
-- Advanced Weapon Framework - Laser Sights

-- Author: SilverEzredes
-- Updated: 01/25/2024
-- Version: v1.4.46
-- Special Thanks to: praydog; alphaZomega

--/////////////////////////////////////--
local AWF = require("AWFCore")
local hk = require("_SharedCore/Hotkeys")
local func = require("_SharedCore/Functions")

local scene = func.get_CurrentScene()
local changed = false
local wc = false
local show_AWFLS_editor = false

local AWF_RE2_Cache = {
    LaserSightController = sdk.typeof("app.ropeway.LaserSightController"),
}

local AWF_LS_default_settings = {
    input_mode_idx =  1,
    option_mode_idx = 1,
    use_modifier = true,
    use_pad_modifier = true,
    -------------------------
	hotkeys = {
		["Modifier"] = "R Mouse",
		["Laser Sight Switch"] = "T",
		["Pad Modifier"] = "LT (L2)",
		["Pad Laser Sight Switch"] = "LStickPush",
	},
}

local AWFWeapons = {
    RE2_Laser_Sights = {
        wp0000 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp0100 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp0200 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle3",
        },
        wp0300 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp0600 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp0700 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp0800 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp1000 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp2000 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp2200 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp3000 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp4100 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp4200 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp4300 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp4400 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp4600 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp4700 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp7000 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp7010 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp7020 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp7030 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp8400 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
        wp8700 = {
            isEnabled = false,
            isReticleEnabled = false,
            PartNum = 7652,
            HideAngle = 15.0,
            ShowAngle = 2.0,
            HideLength = 0.8,
            ShowLength = 4.0,
            SightEmitJointName = "vfx_muzzle1",
        },
    },
}

local AWF_LS_settings = hk.merge_tables({}, AWF_LS_default_settings) and func.recurse_def_settings(json.load_file("AWF/AWF_LaserSights/AWF_LaserSight_Settings.json") or {}, AWF_LS_default_settings)
hk.setup_hotkeys(AWF_LS_settings.hotkeys)

local AWF_settings = hk.merge_tables({}, AWFWeapons) and func.recurse_def_settings(json.load_file("AWF/AWF_LaserSights/AWF_LaserSight_ParamSettings.json") or {}, AWFWeapons)

local function cache_reticle_GUI_RE2()
    local ReticleGUI_GameObject_RE2 = scene:call("findGameObject(System.String)", "GUI_Reticle")

    if ReticleGUI_GameObject_RE2 then
        AWF_RE2_Cache.ReticleGUI = ReticleGUI_GameObject_RE2
    end
end
cache_reticle_GUI_RE2()

local function get_reticle_GUI(weaponData, LS_table)
    local ReticleGUI_GameObject_RE2 = AWF_RE2_Cache.ReticleGUI

    if (ReticleGUI_GameObject_RE2 and NowLoading) or (not ReticleGUI_GameObject_RE2 and NowLoading) then
        cache_reticle_GUI_RE2()
        return
    end
       
    if ReticleGUI_GameObject_RE2 then
        for _, weapon in pairs(weaponData) do
            if LS_table[weapon.ID] then
                if LS_table[weapon.ID].isEnabled then
                    ReticleGUI_GameObject_RE2:call("set_DrawSelf", false)
                elseif not LS_table[weapon.ID].isEnabled then
                    ReticleGUI_GameObject_RE2:call("set_DrawSelf", true)
                end
            end
        end
    end
end

local function get_laser_sights_RE2(weaponData, LS_table)
    for _, weapon in pairs(weaponData) do
        if LS_table[weapon.ID] and LS_table[weapon.ID].isUpdated then
            local Laser_GameObject_RE2 = scene:call("findGameObject(System.String)", "LaserSight_" .. weapon.ID)

            if Laser_GameObject_RE2 then
                local LaserSight_Controller_RE2 = Laser_GameObject_RE2:call("getComponent(System.Type)", AWF_RE2_Cache.LaserSightController)

                if LaserSight_Controller_RE2 then
                    LaserSight_Controller_RE2.WeaponPartsBits = LS_table[weapon.ID].isEnabled and 0 or 7652
                    LaserSight_Controller_RE2.HideAngle = LS_table[weapon.ID].HideAngle
                    LaserSight_Controller_RE2.ShowAngle = LS_table[weapon.ID].ShowAngle
                    LaserSight_Controller_RE2.HideLength = LS_table[weapon.ID].HideLength
                    LaserSight_Controller_RE2.ShowLength = LS_table[weapon.ID].ShowLength
                    LaserSight_Controller_RE2.SightEmitJointName = LS_table[weapon.ID].SightEmitJointName
                end
            end
            LS_table[weapon.ID].isUpdated = false
        end
    end
end
get_laser_sights_RE2(AWF.AWF_settings.RE2_Weapons, AWF_settings.RE2_Laser_Sights)

local function toggle_laser_sights_RE2(weaponData)
    local KM_controls = ((not AWF_LS_settings.use_modifier or hk.check_hotkey("Modifier", false)) and hk.check_hotkey("Laser Sight Switch")) or (hk.check_hotkey("Modifier", true) and hk.check_hotkey("Laser Sight Switch"))
    local PAD_controls = ((not AWF_LS_settings.use_pad_modifier or hk.check_hotkey("Pad Modifier", false)) and hk.check_hotkey("Pad Laser Sight Switch")) or (hk.check_hotkey("Pad Modifier", true) and hk.check_hotkey("Pad Laser Sight Switch"))

    if KM_controls or PAD_controls then
        for _, weapon in pairs(weaponData) do
            local LS_Params = AWF_settings.RE2_Laser_Sights[weapon.ID]
            
            if LS_Params then
                LS_Params.isUpdated = true
                LS_Params.PartNum = LS_Params.isEnabled and 0 or 7652
                LS_Params.isEnabled = not LS_Params.isEnabled
                get_laser_sights_RE2(AWF.AWF_settings.RE2_Weapons, AWF_settings.RE2_Laser_Sights)
                if LS_Params.isEnabled then
                    weapon.isUpdated = true
                    AWF.AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._AddPoint = 5000.0
                    AWF.AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._KeepPoint = 0.0
                    AWF.AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._ShootPoint = 0.0
                    AWF.AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._MovePoint = 0.0
                    AWF.AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._WatchPoint = 0.0
                    AWF.cache_weapon_gameobjects_RE2(AWF.AWF_settings.RE2_Weapons)
                elseif not LS_Params.isEnabled then
                    weapon.isUpdated = true
                    AWF.AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle = func.recurse_def_settings({}, AWF.AWF_Master.RE2_Weapon_Params[weapon.ID].Reticle)
                    AWF.cache_weapon_gameobjects_RE2(AWF.AWF_settings.RE2_Weapons)
                end
                weapon.isUpdated = false
                LS_Params.isUpdated = false
            end
        end
    end
end

re.on_frame(function()
    if reframework.get_game_name() == "re2" then
        get_reticle_GUI(AWF.AWF_settings.RE2_Weapons, AWF_settings.RE2_Laser_Sights)
        toggle_laser_sights_RE2(AWF.AWF_settings.RE2_Weapons)
    end
end)

local function draw_AWFLS_RE2Editor_GUI(weaponOrder)
    if imgui.begin_window("AWF Laser Sight Editor") then
        imgui.begin_rect()
        imgui.button("[==============| AWF LASER SIGHT EDITOR |==============]")

        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF.AWF_settings.RE2_Weapons[weaponName]

            if imgui.tree_node(string.upper(weapon.Name)) then
                imgui.begin_rect()
                imgui.spacing()

                if imgui.button("Reset to Defaults") then
                    wc = true
                    AWF_settings.RE2_Laser_Sights[weapon.ID] = func.recurse_def_settings({}, AWFWeapons.RE2_Laser_Sights[weapon.ID]); wc = wc or changed
                end
                --TODO
                -- local LS_EmissiveColor = func.convert_rgba_to_vector4f(AWF_settings.RE2_Laser_Sights[weapon.ID].EmissiveColor.R, AWF_settings.RE2_Laser_Sights[weapon.ID].EmissiveColor.G, AWF_settings.RE2_Laser_Sights[weapon.ID].EmissiveColor.B, AWF_settings.RE2_Laser_Sights[weapon.ID].EmissiveColor.A)
                -- changed, LS_EmissiveColor = imgui.color_picker4("Laser Sight Color", LS_EmissiveColor); wc = wc or changed
                
                -- local R, G, B, A = func.convert_vector4f_to_rgba(LS_EmissiveColor)
                -- AWF_settings.RE2_Laser_Sights[weapon.ID].EmissiveColor.R = R
                -- AWF_settings.RE2_Laser_Sights[weapon.ID].EmissiveColor.G = G
                -- AWF_settings.RE2_Laser_Sights[weapon.ID].EmissiveColor.B = B
                -- AWF_settings.RE2_Laser_Sights[weapon.ID].EmissiveColor.A = A

                changed, AWF_settings.RE2_Laser_Sights[weapon.ID].HideAngle = imgui.drag_float("Hide Angle", AWF_settings.RE2_Laser_Sights[weapon.ID].HideAngle, 1.0, -1000.0, 1000.0); wc = wc or changed
                changed, AWF_settings.RE2_Laser_Sights[weapon.ID].ShowAngle = imgui.drag_float("Show Angle", AWF_settings.RE2_Laser_Sights[weapon.ID].ShowAngle, 1.0, -1000.0, 1000.0); wc = wc or changed
                changed, AWF_settings.RE2_Laser_Sights[weapon.ID].HideLength = imgui.drag_float("Hide Length", AWF_settings.RE2_Laser_Sights[weapon.ID].HideLength, 1.0, -1000.0, 1000.0); wc = wc or changed
                changed, AWF_settings.RE2_Laser_Sights[weapon.ID].ShowLength = imgui.drag_float("Show Length", AWF_settings.RE2_Laser_Sights[weapon.ID].ShowLength, 1.0, -1000.0, 1000.0); wc = wc or changed
                changed, AWF_settings.RE2_Laser_Sights[weapon.ID].SightEmitJointName = imgui.input_text("Emitter Joint Name", AWF_settings.RE2_Laser_Sights[weapon.ID].SightEmitJointName); wc = wc or changed

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
    if reframework.get_game_name() == "re2" then
        if imgui.tree_node("AWF - Laser Sights") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_LS_settings = func.recurse_def_settings({}, AWF_LS_default_settings); wc = wc or changed
                hk.reset_from_defaults_tbl(AWF_LS_default_settings.hotkeys)
                AWF_settings = func.recurse_def_settings({}, AWFWeapons); wc = wc or changed
                get_laser_sights_RE2(AWF.AWF_settings.RE2_Weapons, AWF_settings.RE2_Laser_Sights)
            end
            func.tooltip("Reset every parameter.")
            
            imgui.spacing()

            changed, show_AWFLS_editor = imgui.checkbox("Open AWF Laser Sight Editor", show_AWFLS_editor)
            func.tooltip("Show/Hide the AWF Laser Sight Editor.")

            if show_AWFLS_editor then
                draw_AWFLS_RE2Editor_GUI(AWF.AWF_settings.RE2_Weapon_Order)
            end
            
            imgui.spacing()

            imgui.begin_rect()
            changed, AWF_LS_settings.input_mode_idx = imgui.combo("Input Settings", AWF_LS_settings.input_mode_idx, {"Default", "Custom"}); wc = wc or changed
            func.tooltip("Set the control scheme for the mod")
            if AWF_LS_settings.input_mode_idx == 2 then
                if imgui.tree_node("Keyboard and Mouse Settings") then
                    changed, AWF_LS_settings.use_modifier = imgui.checkbox(" ", AWF_LS_settings.use_modifier); wc = wc or changed
                    func.tooltip("Require that you hold down this button")
                    imgui.same_line()
                    changed = hk.hotkey_setter("Modifier"); wc = wc or changed
                    changed = hk.hotkey_setter("Laser Sight Switch", AWF_LS_settings.use_modifier and "Modifier"); wc = wc or changed
                    imgui.tree_pop()
                end
                
                if imgui.tree_node("Gamepad Settings") then
                    changed, AWF_LS_settings.use_pad_modifier = imgui.checkbox(" ", AWF_LS_settings.use_pad_modifier); wc = wc or changed
                    func.tooltip("Require that you hold down this button")
                    imgui.same_line()
                    changed = hk.hotkey_setter("Pad Modifier"); wc = wc or changed
                    changed = hk.hotkey_setter("Pad Laser Sight Switch", AWF_LS_settings.use_pad_modifier and "Pad Modifier"); wc = wc or changed
                    imgui.tree_pop()
                end
            end
            imgui.end_rect(2)

            ui.button_n_colored_txt("Current Version:", "v1.4.46 | 01/25/2024", 0xFF00FF00)
            imgui.same_line()
            imgui.text("| by SilverEzredes")
            
            if show_AWFLS_editor and (changed or wc) then
                hk.update_hotkey_table(AWF_LS_settings.hotkeys)
                json.dump_file("AWF/AWF_LaserSights/AWF_LaserSight_Settings.json", AWF_LS_settings)
                json.dump_file("AWF/AWF_LaserSights/AWF_LaserSight_ParamSettings.json", AWF_settings)
            end
            
            imgui.end_rect(1)
            imgui.tree_pop()
        end
    end
end)

AWFLS = {
    AWFLS_Settings = AWF_settings,
    cache_reticle_GUI_RE2 = cache_reticle_GUI_RE2,
    get_laser_sights_RE2 = get_laser_sights_RE2,
}
return AWFLS