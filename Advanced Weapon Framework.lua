--/////////////////////////////////////--
local modName = "Advanced Weapon Framework"

local modAuthor = "SilverEzredes"
local modUpdated = "10/12/2024"
local modVersion = "v3.4.60"
local modCredits = "praydog; alphaZomega; MrBoobieBuyer; Lotiuss"

--/////////////////////////////////////--
local AWF = require("AWFCore")
local func = require("_SharedCore/Functions")

local scene = func.get_CurrentScene()
local last_time = 0.0
local tick_interval = 1.0 / 5.0
NowLoading = false
AWF_Inventory_Found = false
AWF_RE2 = {
    currentWeaponEnum = nil
}
local AWF_Cache = {
    get_DrawSelf = "get_DrawSelf",
    Inventory_RE7 = "InventoryMenu",
    Inventory_RE2 = "GUI_NewInventory",
    Inventory_RE3 = scene:call("findGameObject(System.String)", "GUI_Inventory"),
    Inventory_RE8 = "GUIInventoryMenu",
    Inventory_RE4 = "Gui_ui3006",
    LoadingTipsGUI_RE7 = "TipsGUI",
    LoadingGUI_RE2 = "GUI_GameSceneLoading",
    LoadingGUI_RE3 = "GUI_GameSceneLoading",
    LoadingGUI_RE8 = "GUISceneLoading",
    LoadingGUI_RE4 = "Gui_ui0600",
    
}
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: RE2R
local playerContext_RE2 = nil
local playerID_RE2 = nil
local isPlayerInScene_RE2 = false
local function get_playerContext_RE2()
    local playerManager
    playerManager = sdk.get_managed_singleton(sdk.game_namespace("PlayerManager"))
    playerContext_RE2 = playerManager and playerManager:call("get_CurrentPlayer")
    playerID_RE2 = playerManager and playerManager:call("get_CurrentPlayerType")
    return playerContext_RE2, playerID_RE2
end
local function check_if_playerIsInScene_RE2()
    get_playerContext_RE2()

    if playerContext_RE2 ~= nil then
        isPlayerInScene_RE2 = true
    elseif playerContext_RE2 == nil or {} then
        isPlayerInScene_RE2 = false
    end
end
-- This is the master function for RE2R, updates *all* AWF data on loading screens.
local function check_for_loading_screen_RE2()
    check_if_playerIsInScene_RE2()
    tick_interval = 1.0 / 2.0
    local loading_screen_GameObject_RE2 = func.get_GameObject(scene, AWF_Cache.LoadingGUI_RE2)

    if loading_screen_GameObject_RE2 then
        local loading_screen_RE2 = loading_screen_GameObject_RE2:call(AWF_Cache.get_DrawSelf)
        
        if loading_screen_RE2 and isPlayerInScene_RE2 then
            if os.clock() - last_time < tick_interval then return end
            log.info("[AWF] [--------------------- Loading... All AWF Data Updated!]")
            log.info("[AWF] [--------------------- Version: " .. modVersion .. " Updated: " .. modUpdated .. "]")

            NowLoading = true
            for _, weapon in pairs(AWF.AWF_settings.RE2.Weapons) do
                weapon.isUpdated = true
                AWF.get_WeaponData_RE2(AWF.AWF_settings.RE2.Weapons)

                if weapon.Type ~= "KNF" then
                    local selected_preset = AWF.AWF_settings.RE2.Weapon_Params[weapon.ID].Weapon_Presets[AWF.AWF_settings.RE2.Weapon_Params[weapon.ID].current_param_indx]
                    if selected_preset ~= weapon.Name .. " Default" and selected_preset ~= nil then
                        log.info("[AWF] [--------------------- [Auto Preset Loader] Loaded '" .. selected_preset .. "' for " .. weapon.Name .. "]")
                        local json_filepath = [[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                        local temp_params = json.load_file(json_filepath)

                        temp_params.Weapon_Presets = nil
                        temp_params.current_param_indx = nil

                        for key, value in pairs(temp_params) do
                            AWF.AWF_settings.RE2.Weapon_Params[weapon.ID][key] = value
                        end
                    elseif selected_preset == nil or {} then
                        AWF.AWF_settings.RE2.Weapon_Params[weapon.ID].current_param_indx = 1
                    end
                end

                if AWFNS then
                    AWFNS.toggle_night_sights_RE2(AWF.AWF_settings.RE2.Weapons, AWFNS.AWFNS_Settings.RE2_Night_Sights)
                end
                if AWFLS then
                    AWFLS.get_laser_sights_RE2(AWF.AWF_settings.RE2.Weapons, AWFLS.AWFLS_Settings.RE2_Laser_Sights)
                    log.info("[AWF-LS] [--------------------- Loading... AWF-LS Data Updated.]")
                end
            end
            last_time = os.clock()
        end
    elseif not loading_screen_GameObject_RE2 and NowLoading and isPlayerInScene_RE2 then
        AWF.cache_AWF_json_files_RE2(AWF.AWF_settings.RE2.Weapons)
        for _, weapon in pairs(AWF.AWF_settings.RE2.Weapons) do
            weapon.isUpdated = false
            log.info("[AWF] [--------------------- No longer Loading... AWF Data Stopped Updating.]")
        end
        if AWFGS then
            AWFGS.get_MasterMaterialData_RE2(AWF.AWF_settings.RE2.Weapons)
            AWFGS.dump_CurrentMaterialParam_json_RE2(AWF.AWF_settings.RE2.Weapons)
            AWFGS.cache_AWFGS_json_files_RE2(AWF.AWF_settings.RE2.Weapons)
            log.info("[AWF-GS] [--------------------- No longer Loading... AWF-GS Data Updated.]")
        end
        NowLoading = false
        json.dump_file("AWF/AWF_Settings.json", AWF.AWF_settings)
    end
end
local function check_for_inventory_RE2()
    local inventory_GUI_RE2 = func.get_GameObject(scene, AWF_Cache.Inventory_RE2)
   
    if inventory_GUI_RE2 then
        local inventory = inventory_GUI_RE2:call(AWF_Cache.get_DrawSelf)
        
        if inventory and not AWF_Inventory_Found then
            AWF_Inventory_Found = true
            log.info("[AWF] [------------------------------------------------------- AWF Inventory found, AWF data updated!]")
            for _, weapon in pairs(AWF.AWF_settings.RE2.Weapons) do
                weapon.isUpdated = true
                AWF.get_WeaponData_RE2(AWF.AWF_settings.RE2.Weapons)
            end
            if AWFGS then
                AWFGS_inventoryUpdater_RE2 = true
            end
        elseif not inventory and AWF_Inventory_Found then
            for _, weapon in pairs(AWF.AWF_settings.RE2.Weapons) do
                weapon.isUpdated = false
            end
            AWF_Inventory_Found = false
            log.info("[AWF] [--------------------- Closed AWF Inventory.]")
            json.dump_file("AWF/AWF_Settings.json", AWF.AWF_settings)
        end
    end
end
if reframework.get_game_name() == "re2" then
    sdk.hook(sdk.find_type_definition("app.ropeway.survivor.SurvivorCondition"):get_method("get_EquipWeaponType"),
    nil,
    function(retval)
        AWF_RE2.currentWeaponEnum = sdk.to_int64(retval)
    end
    )
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: RE3R
local function check_for_loading_screen_RE3()
    -- This is the master function for RE3R, updates *all* AWF data on loading screens.
    local loading_screen_GameObject_RE3 = func.get_GameObject(scene, AWF_Cache.LoadingGUI_RE3)

    if loading_screen_GameObject_RE3 then
        local loading_screen_RE3 = loading_screen_GameObject_RE3:call(AWF_Cache.get_DrawSelf)

        if loading_screen_RE3 then
            if os.clock() - last_time < tick_interval then return end
           
            NowLoading = true
            for _, weapon in pairs(AWF.AWF_settings.RE3.Weapons) do
                weapon.isUpdated = true
                AWF.cache_weapon_gameobjects_RE3(AWF.AWF_settings.RE3.Weapons)

                if AWFNS then
                    AWFNS.toggle_night_sights_RE3(AWF.AWF_settings.RE3.Weapons, AWFNS.AWFNS_Settings.RE3_Night_Sights)
                end
                if AWFGS then
                    if AWFGS.AWFGS_Settings.RE3_Gunsmith[weapon.ID] ~= nil then
                        AWFGS.AWFGS_Settings.RE3_Gunsmith[weapon.ID].isUpdated = true
                        AWFGS.dump_weapon_parts_json_RE3(AWF.AWF_settings.RE3.Weapons)
                    end
                    AWFGS.weapon_parts_Manager_RE3(AWF.AWF_settings.RE3.Weapons,  AWFGS.AWFGS_Settings.RE3_Gunsmith)
                    AWFGS.update_weapon_parts_Manager_RE3(AWF.AWF_settings.RE3.Weapons, AWFGS.AWFGS_Settings.RE3_Gunsmith)
                end
            end
            log.info("--------------------- Loading... All AWF Data Updated!")
            last_time = os.clock()
        end
    elseif not loading_screen_GameObject_RE3 and NowLoading then
        for _, weapon in pairs(AWF.AWF_settings.RE3.Weapons) do
            weapon.isUpdated = false
            log.info("--------------------- No longer Loading... AWF Data Stopped Updating.")
        end
        NowLoading = false
        json.dump_file("AWF/AWF_Settings.json", AWF.AWF_settings.RE3)
    end
end

local function check_for_inventory_RE3()
    local inventory_GUI_RE3 = AWF_Cache.Inventory_RE3
   
    if inventory_GUI_RE3 then
        local inventory = inventory_GUI_RE3:call(AWF_Cache.get_DrawSelf)
        
        if inventory and not AWF_Inventory_Found then
            AWF_Inventory_Found = true
            log.info("------------------------------------------------------- AWF Inventory found, AWF data updated!")
            for _, weapon in pairs(AWF.AWF_settings.RE3.Weapons) do
                weapon.isUpdated = true
                AWF.cache_weapon_gameobjects_RE3(AWF.AWF_settings.RE3.Weapons)
            end
        elseif not inventory and AWF_Inventory_Found then
            for _, weapon in pairs(AWF.AWF_settings.RE3.Weapons) do
                weapon.isUpdated = false
            end
            AWF_Inventory_Found = false
            log.info("--------------------- Closed AWF Inventory.")
            json.dump_file("AWF/AWF_Settings.json", AWF.AWF_settings.RE3)
        end
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: RE4R
local playerContext_RE4 = nil
local isPlayerInScene_RE4 = false
local function get_playerContext_RE4()
    local character_manager
    character_manager = sdk.get_managed_singleton(sdk.game_namespace("CharacterManager"))
    playerContext_RE4 = character_manager and character_manager:call("getPlayerContextRef")
    return playerContext_RE4
end

local function check_if_playerIsInScene_RE4()
    get_playerContext_RE4()

    if playerContext_RE4 ~= nil then
        isPlayerInScene_RE4 = true
    elseif playerContext_RE4 == nil or {} then
        isPlayerInScene_RE4 = false
    end
end

-- This is the master function for RE4R, updates *all* AWF data on loading screens.
local function check_for_loading_screen_RE4()
    check_if_playerIsInScene_RE4()
    tick_interval = 1.0 / 1.0
    local loading_screen_GameObject_RE4 = func.get_GameObject(scene, AWF_Cache.LoadingGUI_RE4)

    if loading_screen_GameObject_RE4 then
        local loading_screen_RE4 = loading_screen_GameObject_RE4:call(AWF_Cache.get_DrawSelf)

        if loading_screen_RE4 and isPlayerInScene_RE4 then
            if os.clock() - last_time < tick_interval then return end
            log.info("[AWF] [--------------------- Loading... All AWF Data Updated!]")
            log.info("[AWF] [--------------------- Version: " .. modVersion .. " Updated: " .. modUpdated .. "]")
            NowLoading = true
            for _, weapon in pairs(AWF.AWF_settings.RE4.Weapons) do
                weapon.isUpdated = true
                weapon.isCatalogUpdated = true
                weapon.isCustomCatalogUpdated = true
                weapon.isInventoryUpdated = true
                AWF.get_WeaponData_RE4(AWF.AWF_settings.RE4.Weapons)
                
                local selected_preset = AWF.AWF_settings.RE4.Weapon_Params[weapon.ID].Weapon_Presets[AWF.AWF_settings.RE4.Weapon_Params[weapon.ID].current_param_indx]
                if selected_preset ~= weapon.Name .. " Default" and selected_preset ~= nil then
                    log.info("[AWF] [--------------------- Loaded " .. selected_preset .. " for " .. weapon.Name)
                    local json_filepath = [[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                    local temp_params = json.load_file(json_filepath)

                    temp_params.Weapon_Presets = nil
                    temp_params.current_param_indx = nil

                    for key, value in pairs(temp_params) do
                        AWF.AWF_settings.RE4.Weapon_Params[weapon.ID][key] = value
                    end
                elseif selected_preset == nil or {} then
                    AWF.AWF_settings.RE4.Weapon_Params[weapon.ID].current_param_indx = 1
                end

                if AWFNS then
                    AWFNS.toggle_night_sights_RE4(AWF.AWF_settings.RE4.Weapons, AWFNS.AWFNS_Settings.RE4_Night_Sights)
                end
            end
            last_time = os.clock()
        elseif not loading_screen_RE4 and NowLoading and isPlayerInScene_RE4 then
            AWF.cache_AWF_json_files_RE4(AWF.AWF_settings.RE4.Weapons)
            for _, weapon in pairs(AWF.AWF_settings.RE4.Weapons) do
                weapon.isUpdated = false
                weapon.isCatalogUpdated = false
                weapon.isCustomCatalogUpdated = false
                weapon.isInventoryUpdated = false
                log.info("[AWF] [--------------------- No longer Loading... AWF Data Stopped Updating.]")
            end
            if AWFGS then
                AWFGS.get_MasterMaterialData_RE4(AWF.AWF_settings.RE4.Weapons)
                AWFGS.dump_CurrentMaterialParam_json_RE4(AWF.AWF_settings.RE4.Weapons)
                AWFGS.cache_AWFGS_json_files_RE4(AWF.AWF_settings.RE4.Weapons)
                log.info("[AWF-GS] [--------------------- No longer Loading... AWF-GS Data Updated.]")
            end
            NowLoading = false
            json.dump_file("AWF/AWF_Settings.json", AWF.AWF_settings)
        end
    end
end

local function check_for_inventory_RE4()
    local inventory_GUI_RE4 = func.get_GameObject(scene, AWF_Cache.Inventory_RE4)
   
    if inventory_GUI_RE4 then
        local inventory = inventory_GUI_RE4:call(AWF_Cache.get_DrawSelf)
        
        if inventory and not AWF_Inventory_Found then
            AWF_Inventory_Found = true
            log.info("[AWF] [------------------------------------------------------- AWF Inventory found, AWF data updated!]")
            for _, weapon in pairs(AWF.AWF_settings.RE4.Weapons) do
                weapon.isUpdated = true
                weapon.isInventoryUpdated = true
                AWF.get_WeaponData_RE4(AWF.AWF_settings.RE4.Weapons)
            end
            if AWFGS then
                AWFGS_inventoryUpdater_RE4 = true
            end
        elseif not inventory and AWF_Inventory_Found then
            for _, weapon in pairs(AWF.AWF_settings.RE4.Weapons) do
                weapon.isUpdated = false
                weapon.isInventoryUpdated = false
            end
            AWF_Inventory_Found = false
            log.info("[AWF] [--------------------- Closed AWF Inventory.]")
            json.dump_file("AWF/AWF_Settings.json", AWF.AWF_settings)
        end
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: RE7
local function check_for_loading_screen_RE7()
    -- This is the master function for RE7, updates *all* AWF data on loading screens.
    local loading_tip_GameObject_RE7 = func.get_GameObject(scene, AWF_Cache.LoadingTipsGUI_RE7)

    if loading_tip_GameObject_RE7 then
        local loading_tip_on_screen = loading_tip_GameObject_RE7:call(AWF_Cache.get_DrawSelf)

        if loading_tip_on_screen then
            if os.clock() - last_time < tick_interval then return end

            NowLoading = true
            for _, weapon in pairs(AWF.AWF_settings.RE7.Weapons) do
                weapon.isUpdated = true
                AWF.cache_weapon_gameobjects_RE7(AWF.AWF_settings.RE7.Weapons)
                
                if AWFNS then
                    AWFNS.toggle_night_sights_RE7(AWF.AWF_settings.RE7.Weapons, AWFNS.AWFNS_Settings.RE7_Night_Sights)
                end
                if AWFGS then
                    if AWFGS.AWFGS_Settings.RE7_Gunsmith[weapon.ID] ~= nil then
                        AWFGS.AWFGS_Settings.RE7_Gunsmith[weapon.ID].isUpdated = true
                        AWFGS.dump_weapon_parts_json_RE7(AWF.AWF_settings.RE7.Weapons)
                    end
                    AWFGS.weapon_parts_Manager_RE7(AWF.AWF_settings.RE7.Weapons,  AWFGS.AWFGS_Settings.RE7_Gunsmith)
                    AWFGS.update_weapon_parts_Manager_RE7(AWF.AWF_settings.RE7.Weapons, AWFGS.AWFGS_Settings.RE7_Gunsmith)
                end
            end
            log.info("--------------------- Loading... All AWF Data Updated!")
            last_time = os.clock()
        elseif not loading_tip_on_screen and NowLoading then
            for _, weapon in pairs(AWF.AWF_settings.RE7.Weapons) do
                weapon.isUpdated = false
                log.info("--------------------- No longer Loading... AWF Data Stopped Updating.")
            end
            NowLoading = false
            json.dump_file("AWF/AWF_Settings.json", AWF.AWF_settings)
        end
    end
end

local function check_for_inventory_RE7()
    local inventory_GUI_RE7 = func.get_GameObject(scene, AWF_Cache.Inventory_RE7)
   
    if inventory_GUI_RE7 then
        local inventory = inventory_GUI_RE7:call(AWF_Cache.get_DrawSelf)
        
        if inventory and not AWF_Inventory_Found then
            AWF_Inventory_Found = true
            log.info("------------------------------------------------------- AWF Inventory found, AWF data updated!")
            for _, weapon in pairs(AWF.AWF_settings.RE7.Weapons) do
                weapon.isUpdated = true
                AWF.cache_weapon_gameobjects_RE7(AWF.AWF_settings.RE7.Weapons)
            end
        elseif not inventory and AWF_Inventory_Found then
            for _, weapon in pairs(AWF.AWF_settings.RE7.Weapons) do
                weapon.isUpdated = false
            end
            AWF_Inventory_Found = false
            log.info("--------------------- Closed AWF Inventory.")
            json.dump_file("AWF/AWF_Settings.json", AWF.AWF_settings)
        end
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: RE8
local function check_for_loading_screen_RE8()
    -- This is the master function for RE8, updates *all* AWF data on loading screens.
    local loading_screen_GameObject_RE8 = func.get_GameObject(scene, AWF_Cache.LoadingGUI_RE8)

    if loading_screen_GameObject_RE8 then
        local loading_screen_RE8 = loading_screen_GameObject_RE8:call(AWF_Cache.get_DrawSelf)

        if loading_screen_RE8 then
            if os.clock() - last_time < tick_interval then return end
           
            NowLoading = true
            for _, weapon in pairs(AWF.AWF_settings.RE8.Weapons) do
                weapon.isUpdated = true
                if AWFGS then
                    if AWFGS.AWFGS_Settings.RE8_Gunsmith[weapon.ID] ~= nil then
                        AWFGS.AWFGS_Settings.RE8_Gunsmith[weapon.ID].isUpdated = true
                    end
                end

                if AWFNS then
                    AWFNS.toggle_night_sights_RE8(AWF.AWF_settings.RE8.Weapons, AWFNS.AWFNS_Settings.RE8_Night_Sights)
                end
            end
            log.info("--------------------- Loading... All AWF Data Updated!")
            last_time = os.clock()
        elseif not loading_screen_RE8 and NowLoading then
            for _, weapon in pairs(AWF.AWF_settings.RE8.Weapons) do
                AWF.cache_weapon_gameobjects_RE8(AWF.AWF_settings.RE8.Weapons)

                if AWFGS then
                    if AWFGS.AWFGS_Settings.RE8_Gunsmith[weapon.ID] ~= nil then
                        AWFGS.dump_weapon_parts_json_RE8(AWF.AWF_settings.RE8.Weapons)
                    end
                    AWFGS.weapon_parts_Manager_RE8(AWF.AWF_settings.RE8.Weapons, AWFGS.AWFGS_Settings.RE8_Gunsmith)
                    AWFGS.update_weapon_parts_Manager_RE8(AWF.AWF_settings.RE8.Weapons, AWFGS.AWFGS_Settings.RE8_Gunsmith)
                end

                weapon.isUpdated = false
                log.info("--------------------- No longer Loading... AWF Data Stopped Updating.")
            end
            NowLoading = false
            json.dump_file("AWF/AWF_Settings.json", AWF.AWF_settings)
        end
    end
end

local function check_for_inventory_RE8()
    local inventory_GUI_RE8 = func.get_GameObject(scene, AWF_Cache.Inventory_RE8)
   
    if inventory_GUI_RE8 then
        local inventory = inventory_GUI_RE8:call(AWF_Cache.get_DrawSelf)
        
        if inventory and not AWF_Inventory_Found then
            AWF_Inventory_Found = true
            log.info("------------------------------------------------------- AWF Inventory found, AWF data updated!")
            for _, weapon in pairs(AWF.AWF_settings.RE8.Weapons) do
                weapon.isUpdated = true
                AWF.cache_weapon_gameobjects_RE8(AWF.AWF_settings.RE8.Weapons)
            end
        elseif not inventory and AWF_Inventory_Found then
            for _, weapon in pairs(AWF.AWF_settings.RE8.Weapons) do
                weapon.isUpdated = false
            end
            AWF_Inventory_Found = false
            log.info("--------------------- Closed AWF Inventory.")
            json.dump_file("AWF/AWF_Settings.json", AWF.AWF_settings)
        end
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: On Frame
re.on_frame(function()
	if reframework.get_game_name() == "re2" then
        check_for_inventory_RE2()
        check_for_loading_screen_RE2()
        AWF.update_WeaponData_RE2()
    end
    if reframework.get_game_name() == "re3" then
        check_for_inventory_RE3()
        check_for_loading_screen_RE3()
        AWF.update_cached_weapon_gameobjects_RE3()
    end
    if reframework.get_game_name() == "re4" then
        check_for_inventory_RE4()
        check_for_loading_screen_RE4()
        AWF.update_WeaponData_RE4()
    end
    if reframework.get_game_name() == "re7" then
        check_for_inventory_RE7()
        check_for_loading_screen_RE7()
        AWF.update_cached_weapon_gameobjects_RE7()
    end
    if reframework.get_game_name() == "re8" then
        check_for_inventory_RE8()
        check_for_loading_screen_RE8()
        AWF.update_cached_weapon_gameobjects_RE8()
    end
end)