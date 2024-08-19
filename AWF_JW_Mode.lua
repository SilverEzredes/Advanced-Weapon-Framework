--/////////////////////////////////////--
local modName =  "Advanced Weapon Framework - Weapon Stance"

local modAuthor = "SilverEzredes"
local modUpdated = "08/16/2024"
local modVersion = "v1.2.2"
local modCredits = "praydog; alphaZomega"

--/////////////////////////////////////--
local hk = require("Hotkeys/Hotkeys")
local func = require("_SharedCore/Functions")

local scene = func.get_CurrentScene()
local changed = false
local wc = false
local triggered = false
local isWeaponStanceUpdated = false

local AWF_WPS_default_settings = {
	stance_changed = true,
	-------------------------
    input_mode_idx =  1,
    option_mode_idx = 1,
    use_modifier = true,
    use_pad_modifier = true,
    -------------------------
	hotkeys = {
		["Modifier"] = "R Mouse",
		["Weapon Stance Switch"] = "Z",
		["Pad Modifier"] = "LT (L2)",
		["Pad Weapon Stance Switch"] = "B (Circle)",
	},
}

local WPS_vars = {
	player_ch0 = "ch0a0z0_body",
	player_ch3 = "ch3a8z0_body",
	motionType = "via.motion.Motion",
	motBankID = 2000,
	motBankType = {
		SG09R = 1,
		PUN = 4097,
		RED9 = 129,
		BT = 8193,
		VP70 = 257,
		SEN9 = 12289,
		SW_BT = 1,
		SW_PUN = 4097,
		SW_RED9 = 129,
	},
}

SG09R_Stance = func.create_resource("via.motion.MotionListBaseResource", "SILVER//Weapons//SG-09R//wp4000H.motlist")
SG09R_ExStance = func.create_resource("via.motion.MotionListBaseResource", "SILVER//Weapons//SG-09R//wp4000H_ex.motlist")
PUN_Stance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Punisher/wp4001H.motlist")
PUN_ExStance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Punisher/wp4001H_ex.motlist")
RED9_Stance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Red9/wp4002H.motlist")
RED9_ExStance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Red9/wp4002H_ex.motlist")
BT_Stance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Blacktail/wp4003H.motlist")
BT_ExStance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Blacktail/wp4003H_ex.motlist")
VP70_Stance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Matilda/wp4004H.motlist")
VP70_ExStance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Matilda/wp4004H_ex.motlist")
SEN9_Stance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Sentinel9/wp6000H.motlist")
SEN9_ExStance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Sentinel9/wp6000H_ex.motlist")
------------------------------------------------------------------------------------------------------------------------
SW_PUN_Stance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Punisher/SW/wp6112H.motlist")
SW_PUN_ExStance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Punisher/SW/wp6112H_ex.motlist")
SW_RED9_Stance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Red9/SW/wp6113H.motlist")
SW_RED9_ExStance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Red9/SW/wp6113H_ex.motlist")
SW_BT_Stance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Blacktail/SW/wp4000H.motlist")
SW_BT_ExStance = func.create_resource("via.motion.MotionListBaseResource", "SILVER/Weapons/Blacktail/SW/wp4000H_ex.motlist")

local AWF_WPS_settings = hk.merge_tables({}, AWF_WPS_default_settings) and hk.recurse_def_settings(json.load_file("AWF/AWF_WeaponStance_Settings.json") or {}, AWF_WPS_default_settings)
hk.setup_hotkeys(AWF_WPS_settings.hotkeys)

local function toggle_stance_change(mot, ExStance, Stance)
    if mot then
        mot:call("set_MotionList", AWF_WPS_settings.stance_changed and ExStance or Stance)
    end
end

local function setup_WeaponStances()
	local player_Leon = func.get_GameObject(scene, WPS_vars.player_ch0)
	local player_Leon_motion = func.get_GameObjectComponent(player_Leon, WPS_vars.motionType)
	local player_Ada = func.get_GameObject(scene, WPS_vars.player_ch3)
	local player_Ada_motion = func.get_GameObjectComponent(player_Ada, WPS_vars.motionType)

	if player_Leon_motion then
		local WeaponHold_Stance_SG09R = player_Leon_motion:call("findMotionBank(System.UInt32, System.UInt32)", WPS_vars.motBankID, WPS_vars.motBankType.SG09R)
		local WeaponHold_Stance_PUN = player_Leon_motion:call("findMotionBank(System.UInt32, System.UInt32)", WPS_vars.motBankID, WPS_vars.motBankType.PUN)
		local WeaponHold_Stance_RED9 = player_Leon_motion:call("findMotionBank(System.UInt32, System.UInt32)", WPS_vars.motBankID, WPS_vars.motBankType.RED9)
		local WeaponHold_Stance_BT = player_Leon_motion:call("findMotionBank(System.UInt32, System.UInt32)", WPS_vars.motBankID, WPS_vars.motBankType.BT)
		local WeaponHold_Stance_VP70 = player_Leon_motion:call("findMotionBank(System.UInt32, System.UInt32)", WPS_vars.motBankID, WPS_vars.motBankType.VP70)
		local WeaponHold_Stance_SEN9 = player_Leon_motion:call("findMotionBank(System.UInt32, System.UInt32)", WPS_vars.motBankID, WPS_vars.motBankType.SEN9)

		if isWeaponStanceUpdated then
			AWF_WPS_settings.stance_changed = not AWF_WPS_settings.stance_changed
			toggle_stance_change(WeaponHold_Stance_SG09R, SG09R_ExStance, SG09R_Stance)
			toggle_stance_change(WeaponHold_Stance_PUN, PUN_ExStance, PUN_Stance)
			toggle_stance_change(WeaponHold_Stance_RED9, RED9_ExStance, RED9_Stance)
			toggle_stance_change(WeaponHold_Stance_BT, BT_ExStance, BT_Stance)
			toggle_stance_change(WeaponHold_Stance_VP70, VP70_ExStance, VP70_Stance)
			toggle_stance_change(WeaponHold_Stance_SEN9, SEN9_ExStance, SEN9_Stance)
		end
	end

	if player_Ada_motion then
		local WeaponHold_Stance_SW_PUN = player_Ada_motion:call("findMotionBank(System.UInt32, System.UInt32)", WPS_vars.motBankID, WPS_vars.motBankType.SW_PUN)
		local WeaponHold_Stance_SW_RED9 = player_Ada_motion:call("findMotionBank(System.UInt32, System.UInt32)", WPS_vars.motBankID, WPS_vars.motBankType.SW_RED9)
		local WeaponHold_Stance_SW_BT = player_Ada_motion:call("findMotionBank(System.UInt32, System.UInt32)", WPS_vars.motBankID, WPS_vars.motBankType.SW_BT)

		if isWeaponStanceUpdated then
			AWF_WPS_settings.stance_changed = not AWF_WPS_settings.stance_changed
			toggle_stance_change(WeaponHold_Stance_SW_PUN, SW_PUN_ExStance, SW_PUN_Stance)
			toggle_stance_change(WeaponHold_Stance_SW_RED9, SW_RED9_ExStance, SW_RED9_Stance)
			toggle_stance_change(WeaponHold_Stance_SW_BT, SW_BT_ExStance, SW_BT_Stance)
		end
	end
end

local function update_WeaponStance()
	local KM_controls = ((not AWF_WPS_settings.use_modifier or hk.check_hotkey("Modifier", false)) and hk.check_hotkey("Weapon Stance Switch")) or (hk.check_hotkey("Modifier", true) and hk.check_hotkey("Weapon Stance Switch"))
	local PAD_controls = ((not AWF_WPS_settings.use_pad_modifier or hk.check_hotkey("Pad Modifier", false)) and hk.check_hotkey("Pad Weapon Stance Switch")) or (hk.check_hotkey("Pad Modifier", true) and hk.check_hotkey("Pad Weapon Stance Switch"))
	
	if KM_controls or PAD_controls then
		if not triggered then
			isWeaponStanceUpdated = true
			setup_WeaponStances()
			wc = true
            triggered = true
        end
    else
        triggered = false
        wc = false
    end
end

re.on_frame(function()
	update_WeaponStance()
end)

re.on_draw_ui(function()
	if imgui.tree_node("Advanced Weapon Framework: Weapon Stance") then
		imgui.begin_rect()
		imgui.spacing()
        imgui.indent(5)

		if imgui.button("Reset to Defaults") then
			wc = true
			AWF_WPS_settings = hk.recurse_def_settings({}, AWF_WPS_default_settings)
			hk.reset_from_defaults_tbl(AWF_WPS_default_settings.hotkeys)
		end
		
		imgui.begin_rect()
		changed, AWF_WPS_settings.input_mode_idx = imgui.combo("Input Settings", AWF_WPS_settings.input_mode_idx, {"Default", "Custom"}); wc = wc or changed
		func.tooltip("Set the control scheme for the mod")
		
		if AWF_WPS_settings.input_mode_idx == 2 then
			if imgui.tree_node("Keyboard and Mouse Settings") then
				changed, AWF_WPS_settings.use_modifier = imgui.checkbox(" ", AWF_WPS_settings.use_modifier); wc = wc or changed
				func.tooltip("Require that you hold down this button")
				imgui.same_line()
				changed = hk.hotkey_setter("Modifier"); wc = wc or changed
				changed = hk.hotkey_setter("Weapon Stance Switch", AWF_WPS_settings.use_modifier and "Modifier"); wc = wc or changed
				imgui.tree_pop()
			end
			
			if imgui.tree_node("Gamepad Settings") then
				changed, AWF_WPS_settings.use_pad_modifier = imgui.checkbox(" ", AWF_WPS_settings.use_pad_modifier); wc = wc or changed
				func.tooltip("Require that you hold down this button")
				imgui.same_line()
				changed = hk.hotkey_setter("Pad Modifier"); wc = wc or changed
				changed = hk.hotkey_setter("Pad Weapon Stance Switch", AWF_WPS_settings.use_pad_modifier and "Pad Modifier"); wc = wc or changed
				imgui.tree_pop()
			end
		end
		imgui.end_rect(1)

		ui.button_n_colored_txt("Current Version:", modVersion .. " | " .. modUpdated, func.convert_rgba_to_AGBR(0, 255, 0, 255))
        imgui.same_line()
        imgui.text("| by " .. modAuthor .. " ")

		if wc then
			hk.update_hotkey_table(AWF_WPS_settings.hotkeys)
			json.dump_file("AWF/AWF_WeaponStance_Settings.json", AWF_WPS_settings)
		end
		
		imgui.spacing()
        imgui.indent(-5)
		imgui.end_rect(2)
		imgui.tree_pop()
	end
end)