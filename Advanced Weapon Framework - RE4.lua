--/////////////////////////////////////--
-- Advanced Weapon Framework - RE4R

-- Author: SilverEzredes
-- Updated: 04/21/2023
-- Version: v2.0.4
-- Special Thanks to: praydog; alphaZomega

--/////////////////////////////////////--
local AWF = require("AWF Core")
local scene_manager = AWF.scene_manager
local scene = AWF.scene
local create_resource = AWF.create_resource
local meshType = sdk.typeof("via.render.Mesh")
local triggered = false
local WasTriggered = false
local last_time = 0.0
local tick_interval = 1.0 / 30.0

-- AWF_Experimental = false
-- AWF_Experimental = json.load_file("SILVER\\AWF_Experimental.json") or { }

AWF_Control_Settings = {
	UI_NightSight_Alt = false,
	UI_JohnWickMode_Alt = false,
	night_sight_toggled = true,
}

AWF_Control_Settings = json.load_file("SILVER\\AWF_Control_Settings.json") or { }

--//////MDFS//////--
SG09R_NS_off = create_resource("SILVER/Weapons/SG-09R/wp4000_0.mdf2", "via.render.MeshMaterialResource")
SG09R_NS_on = create_resource("SILVER/Weapons/SG-09R/wp4000_1.mdf2", "via.render.MeshMaterialResource")
PUN_NS_off = create_resource("SILVER/Weapons/Punisher/wp4001_0.mdf2", "via.render.MeshMaterialResource")
PUN_NS_on = create_resource("SILVER/Weapons/Punisher/wp4001_1.mdf2", "via.render.MeshMaterialResource")
Red9_NS_off = create_resource("SILVER/Weapons/Red9/wp4002_0.mdf2", "via.render.MeshMaterialResource")
Red9_NS_on = create_resource("SILVER/Weapons/Red9/wp4002_1.mdf2", "via.render.MeshMaterialResource")
BT_NS_off = create_resource("SILVER/Weapons/Blacktail/wp4003_0.mdf2", "via.render.MeshMaterialResource")
BT_NS_on = create_resource("SILVER/Weapons/Blacktail/wp4003_1.mdf2", "via.render.MeshMaterialResource")
VP70_NS_off = create_resource("SILVER/Weapons/Matilda/wp4004_0.mdf2", "via.render.MeshMaterialResource")
VP70_NS_on = create_resource("SILVER/Weapons/Matilda/wp4004_1.mdf2", "via.render.MeshMaterialResource")
SEN9_NS_off = create_resource("SILVER/Weapons/Sentinel9/wp6000_0.mdf2", "via.render.MeshMaterialResource")
SEN9_NS_on = create_resource("SILVER/Weapons/Sentinel9/wp6000_1.mdf2", "via.render.MeshMaterialResource")
TMP_NS_off = create_resource("SILVER/Weapons/TMP/wp4200_0.mdf2", "via.render.MeshMaterialResource")
TMP_NS_on = create_resource("SILVER/Weapons/TMP/wp4200_1.mdf2", "via.render.MeshMaterialResource")
M870_NS_off = create_resource("SILVER/Weapons/M870/wp4100_0.mdf2", "via.render.MeshMaterialResource")
M870_NS_on = create_resource("SILVER/Weapons/M870/wp4100_1.mdf2", "via.render.MeshMaterialResource")
BM4_NS_off = create_resource("SILVER/Weapons/BM4/wp4101_0.mdf2", "via.render.MeshMaterialResource")
BM4_NS_on = create_resource("SILVER/Weapons/BM4/wp4101_1.mdf2", "via.render.MeshMaterialResource")


local function get_WeaponMeshComponent(WeaponGameObject, meshType)
	return WeaponGameObject and WeaponGameObject:call("getComponent(System.Type)", meshType)
end

local function toggle_night_sight(mesh, ns_on, ns_off)
    if mesh then
        mesh:call("set_Material", AWF_Control_Settings.night_sight_toggled and ns_on or ns_off)
    end
end

re.on_frame(function()
	
	if scene_manager then 
        scene = sdk.call_native_func(scene_manager, sdk.find_type_definition("via.SceneManager"), "get_CurrentScene")
   	end
	
	if not scene then return end
	
	AWF.update_gamepad_state()
	local is_L2_button_down = AWF.gamepad_state.down[via.hid.GamePadButton.LTrigBottom]
	local is_A_button_released = AWF.gamepad_state.released[via.hid.GamePadButton.Decide]

	AWF.update_keyboard_state()
	AWF.update_mouse_state()
	local is_x_key_released = AWF.kb_state.released[via.hid.KeyboardKey.X]
	local is_mouseL_button_down = AWF.mouse_state.down[via.hid.MouseButton.L]
	local is_mouseR_button_down = AWF.mouse_state.down[via.hid.MouseButton.R]
	
	if os.clock() - last_time < tick_interval then return end
		--//////WEAPONS//////--
		local SG09R = AWF.getGameObject(scene, AWF.WeaponIDs.SG09R_id)
		local SG09R_Mesh = get_WeaponMeshComponent(SG09R, meshType)
		local PUN = AWF.getGameObject(scene, AWF.WeaponIDs.PUN_id)
		local PUN_Mesh = get_WeaponMeshComponent(PUN, meshType)
		local Red9 = AWF.getGameObject(scene, AWF.WeaponIDs.RED9_id)
		local Red9_Mesh = get_WeaponMeshComponent(Red9, meshType)
		local BT = AWF.getGameObject(scene, AWF.WeaponIDs.BT_id)
		local BT_Mesh = get_WeaponMeshComponent(BT, meshType)
		local VP70 = AWF.getGameObject(scene, AWF.WeaponIDs.VP70_id)
		local VP70_Mesh = get_WeaponMeshComponent(VP70, meshType)
		local SEN9 = AWF.getGameObject(scene, AWF.WeaponIDs.SEN9_id)
		local SEN9_Mesh = get_WeaponMeshComponent(SEN9, meshType)
		local TMP = AWF.getGameObject(scene, AWF.WeaponIDs.TMP_id)
		local TMP_Mesh = get_WeaponMeshComponent(TMP, meshType)
		local M870 = AWF.getGameObject(scene, AWF.WeaponIDs.M870_id)
		local M870_Mesh = get_WeaponMeshComponent(M870, meshType)
		local BM4 = AWF.getGameObject(scene, AWF.WeaponIDs.BM4_id)
		local BM4_Mesh = get_WeaponMeshComponent(BM4, meshType)
	last_time = os.clock()

		--//////CONTROLS//////--
	if (is_L2_button_down and is_A_button_released) or (((AWF_Control_Settings.UI_NightSight_Alt and is_mouseL_button_down) or (not AWF_Control_Settings.UI_NightSight_Alt and is_mouseR_button_down)) and is_x_key_released) then
		AWF_Control_Settings.night_sight_toggled = not AWF_Control_Settings.night_sight_toggled
		triggered = true
		toggle_night_sight(SG09R_Mesh, SG09R_NS_on, SG09R_NS_off)
		toggle_night_sight(TMP_Mesh, TMP_NS_on, TMP_NS_off)
		toggle_night_sight(M870_Mesh, M870_NS_on, M870_NS_off)
		toggle_night_sight(PUN_Mesh, PUN_NS_on, PUN_NS_off)
		toggle_night_sight(Red9_Mesh, Red9_NS_on, Red9_NS_off)
		toggle_night_sight(BT_Mesh, BT_NS_on, BT_NS_off)
		toggle_night_sight(VP70_Mesh, VP70_NS_on, VP70_NS_off)
		toggle_night_sight(SEN9_Mesh, SEN9_NS_on, SEN9_NS_off)
		toggle_night_sight(BM4_Mesh, BM4_NS_on, BM4_NS_off)
		if triggered ~= WasTriggered then
			json.dump_file("SILVER\\AWF_Control_Settings.json", AWF_Control_Settings)
		end
	end
	
	if not triggered and not AWF_Control_Settings.night_sight_toggled then
		toggle_night_sight(SG09R_Mesh, SG09R_NS_on, SG09R_NS_off)
		toggle_night_sight(TMP_Mesh, TMP_NS_on, TMP_NS_off)
		toggle_night_sight(M870_Mesh, M870_NS_on, M870_NS_off)
		toggle_night_sight(PUN_Mesh, PUN_NS_on, PUN_NS_off)
		toggle_night_sight(Red9_Mesh, Red9_NS_on, Red9_NS_off)
		toggle_night_sight(BT_Mesh, BT_NS_on, BT_NS_off)
		toggle_night_sight(VP70_Mesh, VP70_NS_on, VP70_NS_off)
		toggle_night_sight(SEN9_Mesh, SEN9_NS_on, SEN9_NS_off)
		toggle_night_sight(BM4_Mesh, BM4_NS_on, BM4_NS_off)
	end
end)

re.on_frame(function ()
	if reframework:is_drawing_ui() and AWF_window then
		show_AWF_window()
	end
end)

function show_AWF_window()
	
	if imgui.begin_window("Advanced Weapon Framework", true) then
		AWF_window = true
		was_changed = false
		local changed = false
		
		imgui.separator()
		if imgui.button(AWF_Control_Settings.night_sight_toggled and "Night Sights ON" or "Night Sights OFF") then end

		if EMV then
			if imgui.tree_node("Weapon Stats") then
				for WP_ID, AWFWeapon in pairs(AWF.AWFWeapons) do
					AWFWeapon:display_imgui()
				end
				imgui.tree_pop()
			end
		end

		if imgui.tree_node("Controls") then
			if imgui.tree_node("Night Sights") then
				if not AWF_Control_Settings.UI_NightSight_Alt then
					imgui.text("K&M: [HOLD] Right Mouse Button + [PRESS] X")	
				else 
					imgui.text("K&M: [HOLD] Left Mouse Button + [PRESS] X")
				end
				
				imgui.text("Gamepad: [HOLD] L2 + [PRESS] X // [HOLD] LT + [PRESS] A")
									
				changed, AWF_Control_Settings.UI_NightSight_Alt = imgui.checkbox("Invert Controls", AWF_Control_Settings.UI_NightSight_Alt)
				was_changed = changed or was_changed
				imgui.tree_pop()
			end
			
			if UI_JohnWickMode then
				imgui.separator()
				if imgui.tree_node("John Wick Mode") then
					if not AWF_Control_Settings.UI_JohnWickMode_Alt then
						imgui.text("K&M: [HOLD] Right Mouse Button + [PRESS] Z")
					else 
						imgui.text("K&M: [HOLD] Left Mouse Button + [PRESS] Z")
					end
					
					imgui.text("Gamepad: [HOLD] L2 + [PRESS] O // [HOLD] LT + [PRESS] B")
					
				changed, AWF_Control_Settings.UI_JohnWickMode_Alt = imgui.checkbox("Invert Controls", AWF_Control_Settings.UI_JohnWickMode_Alt)
				was_changed = changed or was_changed
				imgui.tree_pop()
				end
			end
			imgui.tree_pop()
		end

		-- if imgui.tree_node("Experimental") then
		-- 	imgui.text("Enable or disable experimental features.")
		-- 	imgui.text("These features might not work properly or only support a select few weapons.")
		-- 	--imgui.text("Current untested features: Hand Shake Params/ Reticle Types")

		-- 	changed, AWF_Experimental = imgui.checkbox("Enable Experimental Features", AWF_Experimental)
		-- 	was_changed = changed or was_changed
		-- 	imgui.tree_pop()
		-- end
		
    end
	
	if was_changed then
		json.dump_file("SILVER\\AWF_Control_Settings.json", AWF_Control_Settings)
		--json.dump_file("SILVER\\AWF_Experimental.json", AWF_Experimental)
	end
	
	imgui.end_window()
end

function show_AWF_settings()
	if imgui.tree_node("AWF Settings") then
		local changed = false
	
		changed, AWF_window = imgui.checkbox("Show AWF UI", AWF_window)
		imgui.tree_pop()
	end
end

re.on_draw_ui(function()
	show_AWF_settings()
end)