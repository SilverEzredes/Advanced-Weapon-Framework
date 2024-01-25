--/////////////////////////////////////--
-- Advanced Weapon Framework

-- Author: SilverEzredes
-- Updated: 01/25/2024
-- Version: v1.4.45
-- Special Thanks to: praydog; alphaZomega; MrBoobieBuyer; Lotiuss

--/////////////////////////////////////--
local AWF = require("AWFCore")
local func = require("_SharedCore/Functions")

local scene = func.get_CurrentScene()
local last_time = 0.0
local tick_interval = 1.0 / 5.0
NowLoading = false

local AWF_Cache = {
    get_DrawSelf = "get_DrawSelf",
    LoadingTipsGUI_RE7 = "TipsGUI",
    InvetoryMenu_RE7 = "InventoryMenu",
    LoadingGUI_RE2 = "GUI_GameSceneLoading",
}

-- This is the master function for RE7, updates *all* AWF data on loading screens.
local function check_for_loading_tip_RE7()
    local loading_tip_GameObject_RE7 = func.get_GameObject(scene, AWF_Cache.LoadingTipsGUI_RE7)

    if loading_tip_GameObject_RE7 then
        local loading_tip_on_screen = loading_tip_GameObject_RE7:call(AWF_Cache.get_DrawSelf)

        if loading_tip_on_screen then
            if os.clock() - last_time < tick_interval then return end

            NowLoading = true
            for _, weapon in pairs(AWF.AWF_settings.RE7_Weapons) do
                weapon.isUpdated = true
                AWF.cache_weapon_gameobjects_RE7(AWF.AWF_settings.RE7_Weapons)
                
                if AWFNS then
                    AWFNS.toggle_night_sights_RE7(AWF.AWF_settings.RE7_Weapons, AWFNS.AWFNS_Settings.RE7_Night_Sights)
                end
                if AWFGS then
                    if AWFGS.AWFGS_Settings.RE7_Gunsmith[weapon.ID] ~= nil then
                        AWFGS.AWFGS_Settings.RE7_Gunsmith[weapon.ID].isUpdated = true
                        AWFGS.dump_weapon_parts_json_RE7(AWF.AWF_settings.RE7_Weapons)
                    end
                    AWFGS.weapon_parts_Manager_RE7(AWF.AWF_settings.RE7_Weapons, AWFGS.AWFGS_Settings.RE7_Gunsmith)
                    AWFGS.update_weapon_parts_Manager_RE7(AWF.AWF_settings.RE7_Weapons, AWFGS.AWFGS_Settings.RE7_Gunsmith)
                end
            end
            log.info("--------------------- Loading... All AWF Data Updated!")
            last_time = os.clock()
        elseif not loading_tip_on_screen and NowLoading then
            for _, weapon in pairs(AWF.AWF_settings.RE7_Weapons) do
                weapon.isUpdated = false
                log.info("--------------------- No longer Loading... AWF Data Stopped Updating.")
            end
            NowLoading = false
            json.dump_file("AWF/AWF_Settings.json", AWF.AWF_settings)
        end
    end
end

-- This is the master function for RE2R, updates *all* AWF data on loading screens.
local function check_for_loading_screen_RE2()
    local loading_screen_GameObject_RE2 = func.get_GameObject(scene, AWF_Cache.LoadingGUI_RE2)

    if loading_screen_GameObject_RE2 then
        local loading_screen_RE2 = loading_screen_GameObject_RE2:call(AWF_Cache.get_DrawSelf)

        if loading_screen_RE2 then
            -- This is here to speed up load times, since without it total REF time can go over 200ms. AWFWeapons is over 3000 lines what did you expect?
            if os.clock() - last_time < tick_interval then return end

            NowLoading = true
            for _, weapon in pairs(AWF.AWF_settings.RE2_Weapons) do
                weapon.isUpdated = true
                AWF.cache_weapon_gameobjects_RE2(AWF.AWF_settings.RE2_Weapons)

                if AWFNS then
                    AWFNS.toggle_night_sights_RE2(AWF.AWF_settings.RE2_Weapons, AWFNS.AWFNS_Settings.RE2_Night_Sights)
                end
                if AWFLS then
                    AWFLS.get_laser_sights_RE2(AWF.AWF_settings.RE2_Weapons, AWFLS.AWFLS_Settings.RE2_Laser_Sights)
                end
                if AWFGS then
                    if AWFGS.AWFGS_Settings.RE2_Gunsmith[weapon.ID] ~= nil then
                        AWFGS.AWFGS_Settings.RE2_Gunsmith[weapon.ID].isUpdated = true
                        AWFGS.dump_weapon_parts_json_RE2(AWF.AWF_settings.RE2_Weapons)
                    end
                    AWFGS.weapon_parts_Manager_RE2(AWF.AWF_settings.RE2_Weapons, AWFGS.AWFGS_Settings.RE2_Gunsmith)
                    AWFGS.update_weapon_parts_Manager_RE2(AWF.AWF_settings.RE2_Weapons, AWFGS.AWFGS_Settings.RE2_Gunsmith)
                end
            end
            log.info("--------------------- Loading... All AWF Data Updated!")
            last_time = os.clock()
        end
    elseif not loading_screen_GameObject_RE2 and NowLoading then
        for _, weapon in pairs(AWF.AWF_settings.RE2_Weapons) do
            weapon.isUpdated = false
            log.info("--------------------- No longer Loading... AWF Data Stopped Updating.")
        end
        NowLoading = false
        json.dump_file("AWF/AWF_Settings.json", AWF.AWF_settings)
    end
end

re.on_frame(function()
    if reframework.get_game_name() == "re7" then
	    AWF.update_cached_weapon_gameobjects_RE7()
        check_for_loading_tip_RE7()
    end
	if reframework.get_game_name() == "re2" then
        check_for_loading_screen_RE2()
        AWF.update_cached_weapon_gameobjects_RE2()
    end
end)