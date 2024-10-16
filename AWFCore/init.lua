--/////////////////////////////////////--
local modName = "Advanced Weapon Framework Core"

local modAuthor = "SilverEzredes"
local modUpdated = "10/12/2024"
local modVersion = "v3.4.60"
local modCredits = "praydog; alphaZomega; MrBoobieBuyer; Lotiuss"

--/////////////////////////////////////--
local func = require("_SharedCore/Functions")
local ui = require("_SharedCore/Imgui")
local hk = require("Hotkeys/Hotkeys")

local show_AWF_editor = false
local scene = func.get_CurrentScene()
local changed = false
local wc = false
local presetName = "[Enter Preset Name Here]"
AWF_Weapons_Found = false

local AWF_default_settings = {
    isDebug = true,
    isInheritPresetName = false,
    isHideReticle = false,
    RE2 ={
        wp0000 = true,
        wp0100 = true,
        wp0200 = true,
        wp0300 = true,
        wp0600 = true,
        wp0700 = true,
        wp0800 = true,
        wp1000 = true,
        wp2000 = true,
        wp2200 = true,
        wp3000 = true,
        wp4100 = true,
        wp4200 = true,
        wp4300 = true,
        wp4400 = true,
        wp4500 = true,
        wp4510 = true,
        wp4600 = true,
        wp4700 = true,
        wp7000 = true,
        wp7010 = true,
        wp7020 = true,
        wp7030 = true,
        wp8400 = true,
        wp8700 = true,
    },
    RE4 = {
        isUnbreakable = false,
        wp4000 = true,
        wp4000_MC = true,
        wp4001 = true,
        wp4002 = true,
        wp4002_MC = true,
        wp4003 = true,
        wp4004 = true,
        wp4100 = true,
        wp4100_MC = true,
        wp4101 = true,
        wp4101_MC = true,
        wp4102 = true,
        wp4200 = true,
        wp4200_MC = true,
        wp4201 = true,
        wp4201_MC = true,
        wp4202 = true,
        wp4202_MC = true,
        wp4400 = true,
        wp4400_MC = true,
        wp4401 = true,
        wp4401_MC = true,
        wp4402 = true,
        wp4500 = true,
        wp4500_MC = true,
        wp4501 = true,
        wp4501_MC = true,
        wp4502 = true,
        wp4600 = true,
        wp4900 = true,
        wp4902 = true,
        wp5000 = true,
        wp5000_MC = true,
        wp5001 = true,
        wp5001_MC = true,
        wp5006 = true,
        wp5400 = true,
        wp5400_MC = true,
        wp5401 = true,
        wp5401_MC = true,
        wp5402 = true,
        wp5402_MC = true,
        wp5403 = true,
        wp5404 = true,
        wp5405 = true,
        wp6000 = true,
        wp6001 = true,
        wp6100 = true,
        wp6100_MC = true,
        wp6101 = true,
        wp6102 = true,
        wp6102_MC = true,
        wp6103 = true,
        wp6103_MC = true,
        wp6104 = true,
        wp6104_MC = true,
        wp6105 = true,
        wp6105_MC = true,
        wp6106 = true,
        wp6107 = true,
        wp6107_MC = true,
        wp6108 = true,
        wp6111 = true,
        wp6112_AO = true,
        wp6113_AO = true,
        wp6114 = true,
        wp6300_MC = true,
        wp6304 = true,
    }
}

--The AWF Master Table, includes all weapon data for RE2R, RE3R, RE4R, RE7 and RE8.
local AWFWeapons = {
    RE2 = {},
    RE3 = {},
    RE4 = {},
    RE7 = {},
    RE8 = {},
}
AWFWeapons.RE2 = require("AWFCore/AWF/RE2R_WeaponData")
AWFWeapons.RE3 = require("AWFCore/AWF/RE3R_WeaponData")
AWFWeapons.RE4 = require("AWFCore/AWF/RE4R_WeaponData")
AWFWeapons.RE7 = require("AWFCore/AWF/RE7_WeaponData")
AWFWeapons.RE8 = require("AWFCore/AWF/RE8_WeaponData")

local AWF_settings = hk.merge_tables({}, AWFWeapons) and hk.recurse_def_settings(json.load_file("AWF/AWF_Settings.json") or {}, AWFWeapons)
local AWF_tool_settings = hk.merge_tables({}, AWF_default_settings) and hk.recurse_def_settings(json.load_file("AWF/AWF_ToolSettings.json") or {}, AWF_default_settings)

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: RE2R
local cached_weapon_GameObjects_RE2 = {}
local cached_jsonPaths_RE2 = {}
local playerContext_RE2 = nil
local isPlayerInScene_RE2 = false
local RE2_Cache = {
    InventoryMaster = scene:call("findGameObject(System.String)", "50_InventoryMaster"),
    ImplementGunRE2 = sdk.typeof("app.ropeway.implement.Gun"),
    shellPrefabSettings = {
        "ShellPrefabSetting",
        "ShellPrefabSettingNormal",
        "ShellPrefabSettingEx",
        "ShellPrefabSettingAcid",
        "ShellPrefabSettingFire",
        "Center",
        "Around",
    },
}
local function get_playerContext_RE2()
    local playerManager
    playerManager = sdk.get_managed_singleton(sdk.game_namespace("PlayerManager"))
    playerContext_RE2 = playerManager and playerManager:call("get_CurrentPlayer")
    return playerContext_RE2
end
local function check_if_playerIsInScene_RE2()
    get_playerContext_RE2()

    if playerContext_RE2 ~= nil then
        isPlayerInScene_RE2 = true
    elseif playerContext_RE2 == nil or {} then
        isPlayerInScene_RE2 = false
    end
end
local function dump_Default_WeaponParam_json_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWFWeapons.RE2.Weapon_Params[weapon.ID]
        
        if weaponParams then
            json.dump_file("AWF/AWF_Weapons/".. weapon.Name .. "/" .. weapon.Name .. " Default".. ".json", weaponParams)
            if AWF_tool_settings.isDebug then
                log.info("[AWF] [Default Weapon Params for " .. weapon.Name .. " dumped.]")
            end
        end
    end
end
local function get_WeaponData_RE2(weaponData)
    get_playerContext_RE2()
    local Inventory_GameObject_RE2 = RE2_Cache.InventoryMaster

    for _, weapon in pairs(weaponData) do
        if weapon.isUpdated then
            local Weapon_GameObject_RE2 = scene:call("findGameObject(System.String)", weapon.ID)
            
            if Weapon_GameObject_RE2 and Weapon_GameObject_RE2:get_Valid() then
                cached_weapon_GameObjects_RE2[weapon.ID] = Weapon_GameObject_RE2
                if AWF_tool_settings.isDebug then
                    log.info("[AWF] [ " .. weapon.ID .. " Base data updated.]")
                end

                -- Main Game
                local Weapon_Stats_RE2 = Weapon_GameObject_RE2:call("getComponent(System.Type)", RE2_Cache.ImplementGunRE2)

                if Weapon_Stats_RE2 then
                    local weaponParams = AWF_settings.RE2.Weapon_Params[weapon.ID]
                    
                    if weaponParams then
                        for paramName, paramValue in pairs(weaponParams) do
                            if paramName == "EnableExecuteFire" then
                                Weapon_Stats_RE2[func.isBKF(paramName)] = paramValue
                            end
                            if paramName == "EnableRapidFireNumber" then
                                Weapon_Stats_RE2[func.isBKF(paramName)] = paramValue
                            end
                            if paramName == "Recoil" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local Weapon_RecoilParams_RE2 = Weapon_Stats_RE2:get_field("<RecoilParam>k__BackingField")

                                    if Weapon_RecoilParams_RE2 and subParamName ~= "RecoilRateRange" then
                                        Weapon_RecoilParams_RE2[subParamName] = subParamValue
                                    end
                                    if Weapon_RecoilParams_RE2 and subParamName == "RecoilRateRange" then
                                        for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                            local Weapon_RecoilRangeParams_RE2 = Weapon_RecoilParams_RE2:get_field("_RecoilRateRange")

                                            if Weapon_RecoilRangeParams_RE2 then
                                                Weapon_RecoilRangeParams_RE2[subParamName_2nd] = subParamValue_2nd
                                                func.write_valuetype(Weapon_RecoilParams_RE2, 0x10, Weapon_RecoilRangeParams_RE2)
                                            end
                                        end
                                    end
                                end
                            end
                            if paramName == "LoopFire" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local Weapon_LoopFireParams_RE2 = Weapon_Stats_RE2:get_field("<LoopFireParam>k__BackingField")

                                    if Weapon_LoopFireParams_RE2 then
                                        Weapon_LoopFireParams_RE2[subParamName] = subParamValue
                                    end
                                end
                            end
                            if paramName == "Reticle" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local Weapon_ReticleParams_RE2 = Weapon_Stats_RE2:get_field("<ReticleParam>k__BackingField")

                                    if Weapon_ReticleParams_RE2 and subParamName ~= "PointRange" then
                                        Weapon_ReticleParams_RE2[subParamName] = subParamValue
                                    end
                                    if Weapon_ReticleParams_RE2 and subParamName == "PointRange" then
                                        for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                            local Weapon_ReticleRangeParams_RE2 = Weapon_ReticleParams_RE2:get_field("_PointRange")

                                            if Weapon_ReticleRangeParams_RE2 then
                                                Weapon_ReticleRangeParams_RE2[subParamName_2nd] = subParamValue_2nd
                                                func.write_valuetype(Weapon_ReticleParams_RE2, 0x10, Weapon_ReticleRangeParams_RE2)
                                            end
                                        end
                                    end
                                end
                            end
                            if paramName == "Deviate" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local Weapon_DeviateParams_RE2 = Weapon_Stats_RE2:get_field("<DeviateParam>k__BackingField")

                                    if Weapon_DeviateParams_RE2 then
                                        if subParamName == "DeviateYaw" then
                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                local Weapon_DeviateYaw_RE2 = Weapon_DeviateParams_RE2:get_field("_TrainOffYaw")

                                                if Weapon_DeviateYaw_RE2 then
                                                    Weapon_DeviateYaw_RE2[subParamName_2nd] = subParamValue_2nd
                                                    func.write_valuetype(Weapon_DeviateParams_RE2, 0x60, Weapon_DeviateYaw_RE2)
                                                end
                                            end
                                        end
                                        if subParamName == "DeviatePitch" then
                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                local Weapon_DeviatePitch_RE2 = Weapon_DeviateParams_RE2:get_field("_TrainOffPitch")

                                                if Weapon_DeviatePitch_RE2 then
                                                    Weapon_DeviatePitch_RE2[subParamName_2nd] = subParamValue_2nd
                                                    func.write_valuetype(Weapon_DeviateParams_RE2, 0x68, Weapon_DeviatePitch_RE2)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if paramName == "ShellGenerator" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local Weapon_ShellGenerator_RE2 = Weapon_Stats_RE2:get_field("<ShellGenerator>k__BackingField")

                                    if Weapon_ShellGenerator_RE2 then
                                        local Weapon_ShellGenerator_UserDataBase_RE2 = Weapon_ShellGenerator_RE2:get_field("_TGeneratorUserDataBase")

                                        if Weapon_ShellGenerator_UserDataBase_RE2 then
                                            local Weapon_ShellGenerator_BulletGenerateSetting_RE2 = Weapon_ShellGenerator_UserDataBase_RE2:get_field("BulletGenerateSetting")
                                            local Weapon_ShellGenerator_RadiateGenerateSetting_RE2 = Weapon_ShellGenerator_UserDataBase_RE2:get_field("RadiateGenerateSetting")

                                            if Weapon_ShellGenerator_BulletGenerateSetting_RE2 then
                                                local Weapon_ShellGenerator_Normal_RE2 = Weapon_ShellGenerator_BulletGenerateSetting_RE2:get_field("Normal")
                                                local Weapon_ShellGenerator_Fit_RE2 = Weapon_ShellGenerator_BulletGenerateSetting_RE2:get_field("Fit")
                                                local weaponShellUserData = {}

                                                if Weapon_ShellGenerator_Normal_RE2 then
                                                    if subParamName == "Normal" then
                                                        for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                            Weapon_ShellGenerator_Normal_RE2[subParamName_2nd] = subParamValue_2nd
                                                        end
                                                    end
                                                end
                                                if Weapon_ShellGenerator_Fit_RE2 then
                                                    if subParamName == "Fit" then
                                                        for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                            Weapon_ShellGenerator_Fit_RE2[subParamName_2nd] = subParamValue_2nd
                                                        end
                                                    end
                                                end
                                                for _, settingName in ipairs(RE2_Cache.shellPrefabSettings) do
                                                    local setting = Weapon_ShellGenerator_BulletGenerateSetting_RE2:get_field(settingName)
                                                    weaponShellUserData[settingName] = setting and setting:get_field("ShellUserData")

                                                    for i, shellUserData in pairs(weaponShellUserData) do
                                                        if shellUserData then
                                                            if (subParamName == "BallisticSettingNormal") or (subParamName == "BallisticSettingEx") or (subParamName == "BallisticSettingAcid") or (subParamName == "BallisticSettingFire")then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    local Weapon_ShellUserData_BallisticSettingNormal_RE2 =  shellUserData:get_field("BallisticSetting")
    
                                                                    if Weapon_ShellUserData_BallisticSettingNormal_RE2 then
                                                                        Weapon_ShellUserData_BallisticSettingNormal_RE2[subParamName_2nd] = subParamValue_2nd
                                                                    end
                                                                end
                                                            end
                                                            if (subParamName == "AttackSettingNormal") or (subParamName == "AttackSettingEx") or (subParamName == "AttackSettingAcid") or (subParamName == "AttackSettingFire") then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    local Weapon_ShellUserData_AttackSetting_RE2 = shellUserData:get_field("AttackSetting")
                                                                    
                                                                    if Weapon_ShellUserData_AttackSetting_RE2 then
                                                                        if subParamName_2nd == "CriticalRatio" then
                                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingCriticalRatio_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("CriticalRatio")
            
                                                                                if Weapon_ShellUserData_AttackSettingCriticalRatio_RE2 then
                                                                                    Weapon_ShellUserData_AttackSettingCriticalRatio_RE2[subParamName_3rd] = subParamValue_3rd
                                                                                end
                                                                            end
                                                                        end
                                                                        if subParamName_2nd == "FitCriticalRatio"then
                                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("FitCriticalRatio")
    
                                                                                if Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE2 then
                                                                                    Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE2[subParamName_3rd] = subParamValue_3rd
                                                                                end
                                                                            end
                                                                        end
                                                                        if subParamName_2nd == "Normal" then
                                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingNormal_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("Normal")
                                                                                
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE2 and subParamName_3rd == "Damage" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Damage")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Damage_RE2[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE2 and subParamName_3rd == "Wince" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Wince")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Wince_RE2[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE2 and subParamName_3rd == "Break" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Break_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Break")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Break_RE2 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Break_RE2[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                        if subParamName_2nd == "NormalRate" then
                                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingNormal_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("NormalRate")
                                                                                
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE2 and subParamName_3rd == "Damage" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Damage")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Damage_RE2[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE2 and subParamName_3rd == "Wince" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Wince")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Wince_RE2[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE2 and subParamName_3rd == "Break" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Break_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Break")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Break_RE2 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Break_RE2[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                        if subParamName_2nd == "FitRatioContainer"then
                                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingFitRatioContainer_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("FitRatioContainer")
    
                                                                                if Weapon_ShellUserData_AttackSettingFitRatioContainer_RE2 then
                                                                                    Weapon_ShellUserData_AttackSettingFitRatioContainer_RE2[subParamName_3rd] = subParamValue_3rd
                                                                                end
                                                                            end
                                                                        end
                                                                        if subParamName_2nd == "CriticalRatioContainer"then
                                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingCritRatioContainer_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("CriticalRatioContainer")
    
                                                                                if Weapon_ShellUserData_AttackSettingCritRatioContainer_RE2 then
                                                                                    Weapon_ShellUserData_AttackSettingCritRatioContainer_RE2[subParamName_3rd] = subParamValue_3rd
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

                                            if Weapon_ShellGenerator_RadiateGenerateSetting_RE2 then
                                                local Weapon_ShellGenerator_ShellPrefabSetting_RE2 = Weapon_ShellGenerator_RadiateGenerateSetting_RE2:get_field("ShellPrefabSetting")

                                                if Weapon_ShellGenerator_ShellPrefabSetting_RE2 then
                                                    local Weapon_ShellGenerator_ShellUserData_RE2 = Weapon_ShellGenerator_ShellPrefabSetting_RE2:get_field("ShellUserData")

                                                    if Weapon_ShellGenerator_ShellUserData_RE2 then
                                                        if subParamName == "RadiateSettings" then
                                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                local Weapon_ShellGenerator_ShellRadiateSettings_RE2 = Weapon_ShellGenerator_ShellUserData_RE2:get_field("radiateSettings")

                                                                if Weapon_ShellGenerator_ShellRadiateSettings_RE2 then
                                                                    local Weapon_ShellGenerator_ShellRadiateSettingsRadius_RE2 = Weapon_ShellGenerator_ShellRadiateSettings_RE2:get_field("Radius")
                                                                    
                                                                    if Weapon_ShellGenerator_ShellRadiateSettings_RE2 and subParamName_2nd ~= "Radius" then
                                                                        Weapon_ShellGenerator_ShellRadiateSettings_RE2[subParamName_2nd] = subParamValue_2nd
                                                                    end

                                                                    if subParamName_2nd == "Radius" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            Weapon_ShellGenerator_ShellRadiateSettingsRadius_RE2[subParamName_3rd] = subParamValue_3rd
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                        if subParamName == "AttackSettingNormal" then
                                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                local Weapon_ShellUserData_AttackSetting_RE2 = Weapon_ShellGenerator_ShellUserData_RE2:get_field("AttackSetting")
                                                                
                                                                if Weapon_ShellUserData_AttackSetting_RE2 then
                                                                    if subParamName_2nd == "CriticalRatio" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            local Weapon_ShellUserData_AttackSettingCriticalRatio_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("CriticalRatio")
        
                                                                            if Weapon_ShellUserData_AttackSettingCriticalRatio_RE2 then
                                                                                Weapon_ShellUserData_AttackSettingCriticalRatio_RE2[subParamName_3rd] = subParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                    if subParamName_2nd == "FitCriticalRatio"then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            local Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("FitCriticalRatio")

                                                                            if Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE2 then
                                                                                Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE2[subParamName_3rd] = subParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                    if subParamName_2nd == "Normal" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            local Weapon_ShellUserData_AttackSettingNormal_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("Normal")
                                                                            
                                                                            if Weapon_ShellUserData_AttackSettingNormal_RE2 and subParamName_3rd == "Damage" then
                                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                    local Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Damage")
        
                                                                                    if Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 then
                                                                                        Weapon_ShellUserData_AttackSettingNormal_Damage_RE2[subParamName_4th] = subParamValue_4th
                                                                                    end
                                                                                end
                                                                            end
                                                                            if Weapon_ShellUserData_AttackSettingNormal_RE2 and subParamName_3rd == "Wince" then
                                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                    local Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Wince")
        
                                                                                    if Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 then
                                                                                        Weapon_ShellUserData_AttackSettingNormal_Wince_RE2[subParamName_4th] = subParamValue_4th
                                                                                    end
                                                                                end
                                                                            end
                                                                            if Weapon_ShellUserData_AttackSettingNormal_RE2 and subParamName_3rd == "Break" then
                                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                    local Weapon_ShellUserData_AttackSettingNormal_Break_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Break")
        
                                                                                    if Weapon_ShellUserData_AttackSettingNormal_Break_RE2 then
                                                                                        Weapon_ShellUserData_AttackSettingNormal_Break_RE2[subParamName_4th] = subParamValue_4th
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                    if subParamName_2nd == "NormalRate" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            local Weapon_ShellUserData_AttackSettingNormal_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("NormalRate")
                                                                            
                                                                            if Weapon_ShellUserData_AttackSettingNormal_RE2 and subParamName_3rd == "Damage" then
                                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                    local Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Damage")
        
                                                                                    if Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 then
                                                                                        Weapon_ShellUserData_AttackSettingNormal_Damage_RE2[subParamName_4th] = subParamValue_4th
                                                                                    end
                                                                                end
                                                                            end
                                                                            if Weapon_ShellUserData_AttackSettingNormal_RE2 and subParamName_3rd == "Wince" then
                                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                    local Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Wince")
        
                                                                                    if Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 then
                                                                                        Weapon_ShellUserData_AttackSettingNormal_Wince_RE2[subParamName_4th] = subParamValue_4th
                                                                                    end
                                                                                end
                                                                            end
                                                                            if Weapon_ShellUserData_AttackSettingNormal_RE2 and subParamName_3rd == "Break" then
                                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                    local Weapon_ShellUserData_AttackSettingNormal_Break_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Break")
        
                                                                                    if Weapon_ShellUserData_AttackSettingNormal_Break_RE2 then
                                                                                        Weapon_ShellUserData_AttackSettingNormal_Break_RE2[subParamName_4th] = subParamValue_4th
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                    if subParamName_2nd == "FitRatioContainer"then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            local Weapon_ShellUserData_AttackSettingFitRatioContainer_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("FitRatioContainer")

                                                                            if Weapon_ShellUserData_AttackSettingFitRatioContainer_RE2 then
                                                                                Weapon_ShellUserData_AttackSettingFitRatioContainer_RE2[subParamName_3rd] = subParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                    if subParamName_2nd == "CriticalRatioContainer"then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            local Weapon_ShellUserData_AttackSettingCritRatioContainer_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("CriticalRatioContainer")

                                                                            if Weapon_ShellUserData_AttackSettingCritRatioContainer_RE2 then
                                                                                Weapon_ShellUserData_AttackSettingCritRatioContainer_RE2[subParamName_3rd] = subParamValue_3rd
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
                            end
                            if paramName == "UserData" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local Weapon_UserDataParams_RE2 = Weapon_Stats_RE2:get_field("_UserData")

                                    if Weapon_UserDataParams_RE2 then
                                        local Weapon_UserDataParams_Gun_RE2 = Weapon_UserDataParams_RE2:get_field("_Gun")
                                        
                                        if Weapon_UserDataParams_Gun_RE2 then
                                            local Weapon_UserDataParams_Reticle_RE2 = Weapon_UserDataParams_Gun_RE2:get_field("_ReticlePartsCombos")
                                            Weapon_UserDataParams_Reticle_RE2 = Weapon_UserDataParams_Reticle_RE2 and Weapon_UserDataParams_Reticle_RE2:get_elements() or {}
                                            
                                            local Weapon_UserDataParams_Recoil_RE2 = Weapon_UserDataParams_Gun_RE2:get_field("_RecoilPartsCombos")
                                            Weapon_UserDataParams_Recoil_RE2 = Weapon_UserDataParams_Recoil_RE2 and Weapon_UserDataParams_Recoil_RE2:get_elements() or {}

                                            local Weapon_UserDataParams_RapidFire_RE2 = Weapon_UserDataParams_Gun_RE2:get_field("_RapidFirePartsCombos")
                                            Weapon_UserDataParams_RapidFire_RE2 = Weapon_UserDataParams_RapidFire_RE2 and Weapon_UserDataParams_RapidFire_RE2:get_elements() or {}

                                            local Weapon_UserDataParams_LoopFire_RE2 = Weapon_UserDataParams_Gun_RE2:get_field("_LoopFirePartsCombos")
                                            Weapon_UserDataParams_LoopFire_RE2 = Weapon_UserDataParams_LoopFire_RE2 and Weapon_UserDataParams_LoopFire_RE2:get_elements() or {}

                                            local Weapon_UserDataParams_Deviate_RE2 = Weapon_UserDataParams_Gun_RE2:get_field("_DeviatePartsCombos")
                                            Weapon_UserDataParams_Deviate_RE2 = Weapon_UserDataParams_Deviate_RE2 and Weapon_UserDataParams_Deviate_RE2:get_elements() or {}
                                            
                                            if Weapon_UserDataParams_Reticle_RE2 ~= nil then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    for i = 2, #Weapon_UserDataParams_Reticle_RE2 do
                                                        local Weapon_UserDataParams_ReticleParams_RE2 = Weapon_UserDataParams_Reticle_RE2[i]:get_field("_Param")
                                                        local matched_ParamName = "Reticle_LVL_" .. string.format("%02d", i)
                                                    
                                                        if Weapon_UserDataParams_ReticleParams_RE2 and subParamName_2nd == matched_ParamName then
                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                if Weapon_UserDataParams_ReticleParams_RE2 and subParamName_3rd ~= "PointRange" then
                                                                    Weapon_UserDataParams_ReticleParams_RE2[subParamName_3rd] = subParamValue_3rd
                                                                end
                                                                if Weapon_UserDataParams_ReticleParams_RE2 and subParamName_3rd == "PointRange" then
                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                        local Weapon_ReticleRangeParams_RE2 = Weapon_UserDataParams_ReticleParams_RE2:get_field("_PointRange")
                                
                                                                        if Weapon_ReticleRangeParams_RE2 then
                                                                            Weapon_ReticleRangeParams_RE2[subParamName_4th] = subParamValue_4th
                                                                            func.write_valuetype(Weapon_UserDataParams_ReticleParams_RE2, 0x10, Weapon_ReticleRangeParams_RE2)
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end

                                            if Weapon_UserDataParams_Recoil_RE2 ~= nil then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    for i = 2, #Weapon_UserDataParams_Recoil_RE2 do
                                                        local Weapon_UserDataParams_RecoilParams_RE2 = Weapon_UserDataParams_Recoil_RE2[i]:get_field("_Param")
                                                        local matched_ParamName = "Recoil_LVL_" .. string.format("%02d", i)

                                                        if Weapon_UserDataParams_RecoilParams_RE2 and subParamName_2nd == matched_ParamName then
                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                if Weapon_UserDataParams_RecoilParams_RE2 and subParamName_3rd ~= "RecoilRateRange" then
                                                                    Weapon_UserDataParams_RecoilParams_RE2[subParamName_3rd] = subParamValue_3rd
                                                                end
                                                                if Weapon_UserDataParams_RecoilParams_RE2 and subParamName_3rd == "RecoilRateRange" then
                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                        local Weapon_RecoilRangeParams_RE2 = Weapon_UserDataParams_RecoilParams_RE2:get_field("_RecoilRateRange")
                                
                                                                        if Weapon_RecoilRangeParams_RE2 then
                                                                            Weapon_RecoilRangeParams_RE2[subParamName_4th] = subParamValue_4th
                                                                            func.write_valuetype(Weapon_UserDataParams_RecoilParams_RE2, 0x10, Weapon_RecoilRangeParams_RE2)
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end

                                            if Weapon_UserDataParams_RapidFire_RE2 ~= nil then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    for i = 1, #Weapon_UserDataParams_RapidFire_RE2 do
                                                        local Weapon_UserDataParams_RapidFireParams_RE2 = Weapon_UserDataParams_RapidFire_RE2[i]:get_field("_Param")
                                                        local matched_ParamName = "RapidFire_LVL_" .. string.format("%02d", i)

                                                        if Weapon_UserDataParams_RapidFireParams_RE2 and subParamName_2nd == matched_ParamName then
                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                Weapon_UserDataParams_RapidFireParams_RE2[subParamName_3rd] = subParamValue_3rd
                                                            end
                                                        end
                                                    end
                                                end
                                            end

                                            if Weapon_UserDataParams_LoopFire_RE2 ~= nil then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    for i = 2, #Weapon_UserDataParams_LoopFire_RE2 do
                                                        local Weapon_UserDataParams_LoopFireParams_RE2 = Weapon_UserDataParams_LoopFire_RE2[i]:get_field("_Param")
                                                        local matched_ParamName = "LoopFire_LVL_" .. string.format("%02d", i)

                                                        if Weapon_UserDataParams_LoopFireParams_RE2 and subParamName_2nd == matched_ParamName then
                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                Weapon_UserDataParams_LoopFireParams_RE2[subParamName_3rd] = subParamValue_3rd
                                                            end
                                                        end
                                                    end
                                                end
                                            end

                                            if Weapon_UserDataParams_Deviate_RE2 ~= nil then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    for i = 2, #Weapon_UserDataParams_Deviate_RE2 do
                                                        local Weapon_UserDataParams_DeviateParams_RE2 = Weapon_UserDataParams_Deviate_RE2[i]:get_field("_Param")
                                                        local matched_ParamName = "Deviate_LVL_" .. string.format("%02d", i)

                                                        if Weapon_UserDataParams_DeviateParams_RE2 and subParamName_2nd == matched_ParamName then
                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                if Weapon_UserDataParams_DeviateParams_RE2 and subParamName_3rd == "DeviateYaw" then
                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                        local Weapon_UserDataParams_DeviateParamsYaw_RE2 = Weapon_UserDataParams_DeviateParams_RE2:get_field("_TrainOffYaw")
                                                                        

                                                                        if Weapon_UserDataParams_DeviateParamsYaw_RE2 then
                                                                            Weapon_UserDataParams_DeviateParamsYaw_RE2[subParamName_4th] = subParamValue_4th
                                                                            func.write_valuetype(Weapon_UserDataParams_DeviateParams_RE2, 0x60, Weapon_UserDataParams_DeviateParamsYaw_RE2)
                                                                        end
                                                                    end
                                                                end
                                                                if Weapon_UserDataParams_DeviateParams_RE2 and subParamName_3rd == "DeviatePitch" then
                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                        local Weapon_UserDataParams_DeviateParamsPitch_RE2 = Weapon_UserDataParams_DeviateParams_RE2:get_field("_TrainOffPitch")

                                                                        if Weapon_UserDataParams_DeviateParamsPitch_RE2 then
                                                                            Weapon_UserDataParams_DeviateParamsPitch_RE2[subParamName_4th] = subParamValue_4th
                                                                            func.write_valuetype(Weapon_UserDataParams_DeviateParams_RE2, 0x68, Weapon_UserDataParams_DeviateParamsPitch_RE2)
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
                        end
                    end
                end

                if Inventory_GameObject_RE2 then
                    local EquipmentManager_RE2 = Inventory_GameObject_RE2:call("getComponent(System.Type)", sdk.typeof("app.ropeway.EquipmentManager"))
                    
                    if EquipmentManager_RE2 then
                        local weaponParams = AWF_settings.RE2.Weapon_Params[weapon.ID]
                        if AWF_tool_settings.isDebug then
                            log.info("[AWF] [ " .. weapon.ID .. " Inventory data updated.]")
                        end
    
                        if weaponParams then
                            for paramName, paramValue in pairs(weaponParams) do
                                if paramName == "Inventory" then
                                    for subParamName, subParamValue in pairs(paramValue) do
                                        local EquipmentManager_WeaponBulletData_RE2 = EquipmentManager_RE2:get_field("_WeaponBulletUserdata")
    
                                        if EquipmentManager_WeaponBulletData_RE2 then
                                            local EquipmentManager_LoadingPartsCombos_RE2 = EquipmentManager_WeaponBulletData_RE2:get_field("_LoadingPartsCombos")
                                            EquipmentManager_LoadingPartsCombos_RE2 = EquipmentManager_LoadingPartsCombos_RE2 and EquipmentManager_LoadingPartsCombos_RE2:get_elements() or {}
                                            
                                            for i, WeaponNames in ipairs(EquipmentManager_LoadingPartsCombos_RE2) do
                                                local WeaponDisplayNames = WeaponNames:call("get_DisplayName")
                                                
                                                if WeaponDisplayNames and WeaponDisplayNames:find(string.upper(weapon.ID)) then
                                                    local Weapon_LoadingPartsCombos_RE2 = WeaponNames:call("get_LoadingPartsCombosForm")
                                                    Weapon_LoadingPartsCombos_RE2 = Weapon_LoadingPartsCombos_RE2 and Weapon_LoadingPartsCombos_RE2:get_elements() or {}
                                                    
                                                    for j, PartSettings in ipairs(Weapon_LoadingPartsCombos_RE2) do
                                                        if (subParamName ~= "AlwaysReloadableVariable") and (subParamName ~= "_NumberEX") then
                                                            PartSettings[subParamName] = subParamValue
                                                            
                                                            if j == 2 then
                                                                PartSettings["_Number"] = weaponParams.Inventory._NumberEX
                                                            end
                                                        end
                                                        if subParamName == "AlwaysReloadableVariable" then
                                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                local AlwaysReloadableVariable_RE2 = PartSettings:get_field("_AlwaysReloadableVariable")
                                                                if AlwaysReloadableVariable_RE2 and weaponParams.Inventory._AlwaysReloadable == true then
                                                                    AlwaysReloadableVariable_RE2[subParamName_2nd] = weaponParams.Inventory.AlwaysReloadableVariable
                                                                    func.write_valuetype(PartSettings, 0x38, AlwaysReloadableVariable_RE2)
                                                                elseif AlwaysReloadableVariable_RE2 and weaponParams.Inventory._AlwaysReloadable == false then
                                                                    AlwaysReloadableVariable_RE2[subParamName_2nd] = weaponParams.Inventory.AlwaysReloadableVariable.mData1 + 1
                                                                    func.write_valuetype(PartSettings, 0x38, AlwaysReloadableVariable_RE2)
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
                end
            end
        end
        weapon.isUpdated = false
    end
end
local function clear_AWF_json_cache_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        if weapon.isUpdated then
            local cacheKey = "AWF\\AWF_Weapons\\" .. weapon.Name
            cached_jsonPaths_RE2[cacheKey] = nil

            if AWF_tool_settings.isDebug then
                log.info("[AWF] [Preset path cache cleared for " .. weapon.Name .. " | " .. weapon.ID .. " ]")
            end
        end
    end
end
local function cache_AWF_json_files_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWF_settings.RE2.Weapon_Params[weapon.ID]
        
        if weaponParams then
            local json_names = weaponParams.Weapon_Presets or {}
            local cacheKey = "AWF\\AWF_Weapons\\" .. weapon.Name

            if not cached_jsonPaths_RE2[cacheKey] then
                local path = [[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\.*.json]]
                cached_jsonPaths_RE2[cacheKey] =  fs.glob(path)
            end

            local json_filepaths = cached_jsonPaths_RE2[cacheKey]
            
            if json_filepaths then
                local defaultName = weapon.Name .. " Default"
                local defaultNameInserted = false

                for i, filepath in ipairs(json_filepaths) do
                    local name = filepath:match("^.+\\(.+)%.")
                    local nameExists = false
                    
                    for j, existingName in ipairs(json_names) do
                        if existingName == name then
                            nameExists = true
                            break
                        end
                    end
                    
                    if not nameExists then
                        if name == defaultName then
                            table.insert(json_names, 1, name)
                            defaultNameInserted = true
                        else
                            table.insert(json_names, name)
                        end

                        if AWF_tool_settings.isDebug then
                            log.info("[AWF] [Loaded " .. filepath .. " for "  .. weapon.Name .. "]")
                        end
                    end
                end
                
                if not defaultNameInserted then
                    for i, name in ipairs(json_names) do
                        if name == defaultName then
                            table.remove(json_names, i)
                            table.insert(json_names, 1, name)
                            break
                        end
                    end
                end

                for i = #json_names, 1, -1 do
                    local nameExists = false
                    local name = json_names[i]
                    for _, filepath in ipairs(json_filepaths) do
                        if filepath:match("^.+\\(.+)%.") == name then
                            nameExists = true
                            break
                        end
                    end
                    if not nameExists then
                        if AWF_tool_settings.isDebug then
                            log.info("[AWF] [Removed " .. name .. " from " .. weapon.Name .. "]")
                        end
                        table.remove(json_names, i)
                    end
                end
            else
                if AWF_tool_settings.isDebug then
                    log.info("[AWF] [No AWF JSON files found.]")
                end
            end
        end
    end
end
if reframework.get_game_name() == "re2" then
    dump_Default_WeaponParam_json_RE2(AWFWeapons.RE2.Weapons)
    cache_AWF_json_files_RE2(AWF_settings.RE2.Weapons)
end
local function check_if_WeaponDataIsCached_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        local Weapon_GameObject_RE2 = cached_weapon_GameObjects_RE2[weapon.ID]
        
        if Weapon_GameObject_RE2 and weapon.isUpdated then
            log.info("[AWF] [Loaded " .. weapon.Name .. " Game Object from cache.]")
        end
    end
end
local function update_WeaponData_RE2()
    if changed or wc or not cached_weapon_GameObjects_RE2 then
        changed = false
        wc = false
        AWF_Weapons_Found = true
        get_WeaponData_RE2(AWF_settings.RE2.Weapons)
        check_if_WeaponDataIsCached_RE2(AWF_settings.RE2.Weapons)
        log.info("[AWF] [------------ AWF Weapon Data Updated!]")
    end
end
local function draw_AWF_RE2Editor_GUI(weaponOrder)
    if imgui.begin_window("Advanced Weapon Framework: Weapon Stat Editor") then
        imgui.begin_rect()
        local textColor = {0, 255, 255, 255}
        imgui.text_colored("  [ " .. ui.draw_line("=", 50) ..  " | " .. ui.draw_line("=", 50) .. " ] ", func.convert_rgba_to_AGBR(textColor))
        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF_settings.RE2.Weapons[weaponName]

            if weapon and imgui.tree_node(weapon.Name) then
                if imgui.begin_popup_context_item() then
                    if imgui.menu_item("Reset") then
                        wc = true
                        AWF_settings.RE2.Weapon_Params[weapon.ID] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID])
                        clear_AWF_json_cache_RE2(AWF_settings.RE2.Weapons)
                        cache_AWF_json_files_RE2(AWF_settings.RE2.Weapons)
                    end
                    func.tooltip("Reset all of the parameters of " .. weapon.Name)

                    imgui.end_popup()
                end
                imgui.begin_rect()
                imgui.text_colored("  " .. ui.draw_line("=", 100) .."  ", func.convert_rgba_to_AGBR(textColor))
                imgui.indent(10)

                if imgui.button("Update Preset List") then
                    clear_AWF_json_cache_RE2(AWF_settings.RE2.Weapons)
                    cache_AWF_json_files_RE2(AWF_settings.RE2.Weapons)
                end

                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].current_param_indx = imgui.combo("Preset", AWF_settings.RE2.Weapon_Params[weapon.ID].current_param_indx or 1, AWF_settings.RE2.Weapon_Params[weapon.ID].Weapon_Presets); wc = wc or changed
                func.tooltip("Select a file from the dropdown menu to load the weapon stats from that file.")
                if changed then
                    local selected_preset = AWF_settings.RE2.Weapon_Params[weapon.ID].Weapon_Presets[AWF_settings.RE2.Weapon_Params[weapon.ID].current_param_indx]
                    local json_filepath = [[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                    local temp_params = json.load_file(json_filepath)
                    
                    if AWF_tool_settings.isDebug then
                        log.info("[AWF] [--------------------- [Manual Preset Loader] Loaded '" .. selected_preset .. "' for " .. weapon.Name .. "]")
                    end

                    if AWF_tool_settings.isInheritPresetName then
                        presetName = selected_preset
                    end

                    temp_params.Weapon_Presets = nil
                    temp_params.current_param_indx = nil

                    for key, value in pairs(temp_params) do
                        AWF_settings.RE2.Weapon_Params[weapon.ID][key] = value
                    end
                    cache_AWF_json_files_RE2(AWF_settings.RE2.Weapons)
                end

                imgui.push_id(_)
                changed, presetName = imgui.input_text("", presetName); wc = wc or changed
                imgui.pop_id()

                imgui.same_line()
                if imgui.button("Save Preset") then
                    json.dump_file("AWF/AWF_Weapons/".. weapon.Name .. "/" .. presetName .. ".json", AWF_settings.RE2.Weapon_Params[weapon.ID])
                    log.info("[AWF] [Custom " .. weapon.Name ..  " params saved with the preset name " .. presetName .. " ]")
                    weapon.isUpdated = true
                    clear_AWF_json_cache_RE2(AWF_settings.RE2.Weapons)
                    cache_AWF_json_files_RE2(AWF_settings.RE2.Weapons)
                end
                func.tooltip("Save the current parameters of the " .. weapon.Name .. " to " .. presetName .. ".json found in [RESIDENT EVIL 2  BIOHAZARD RE2/reframework/data/AWF/AWF_Weapons/".. weapon.Name .. "]")


                imgui.spacing()

                if AWF_settings.RE2.Weapon_Params[weapon.ID].Inventory then
                    imgui.text_colored(ui.draw_line("=", 95) .. "| Inventory" , func.convert_rgba_to_AGBR(textColor))

                    if imgui.button("Reset Inventory Parameters") then
                        wc = true
                        AWF_settings.RE2.Weapon_Params[weapon.ID].Inventory = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].Inventory)
                    end

                    -- if AWF_tool_settings.isDebug then
                    --     changed, AWF_settings.RE2.Weapon_Params[weapon.ID].EnableExecuteFire = imgui.checkbox("[DEBUG] Enable Fire", AWF_settings.RE2.Weapon_Params[weapon.ID].EnableExecuteFire); wc = wc or changed
                    --     func.tooltip("[DEBUG] If disabled, the weapon can't fire. Also a debug option so if you see this IDK what you are doing.")

                    --     imgui.same_line()
                    -- end
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Inventory._Infinity = imgui.checkbox("Unlimited Capacity", AWF_settings.RE2.Weapon_Params[weapon.ID].Inventory._Infinity); wc = wc or changed
                    func.tooltip("If enabled, the weapon does not need to be reloaded.")

                    imgui.same_line()
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Inventory._AlwaysReloadable = imgui.checkbox("Unlimited Ammo", AWF_settings.RE2.Weapon_Params[weapon.ID].Inventory._AlwaysReloadable); wc = wc or changed
                    func.tooltip("If enabled, the weapon will never run out of ammo.")

                    imgui.spacing()
                    
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Inventory._Number = imgui.drag_int("Ammo Capacity",AWF_settings.RE2.Weapon_Params[weapon.ID].Inventory._Number, 1, 0, 1000); wc = wc or changed
                    func.tooltip("The maximum number of rounds the weapon can hold. Higher is better.")
                    
                    if (weapon.ID == "wp0000") or (weapon.ID == "wp0200") or (weapon.ID == "wp0800") or (weapon.ID == "wp1000") or (weapon.ID == "wp2000") then
                        changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Inventory._NumberEX = imgui.drag_int("EX Ammo Capacity",AWF_settings.RE2.Weapon_Params[weapon.ID].Inventory._NumberEX, 1, 0, 1000); wc = wc or changed
                        func.tooltip("The maximum number of rounds the upgraded weapon can hold. Higher is better.")
                    end
                end

                imgui.spacing()

                if AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator then
                    local shellGenTypes = AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator
                    local sortedKeys = {}

                    for i in pairs(shellGenTypes) do
                        table.insert(sortedKeys, i)
                    end
                    table.sort(sortedKeys)

                    for k, i in pairs(sortedKeys) do
                        if i:match("^BallisticSettingNormal") then
                            imgui.text_colored(ui.draw_line("=", 95) .. "| Bullet Ballistic" , func.convert_rgba_to_AGBR(textColor))
                            if AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur = imgui.drag_float("Spread", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread. Lower is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit = imgui.drag_float("Spread Fit", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum = imgui.drag_int("HitNum", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("Number of bullets on impact. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit = imgui.drag_int("HitNumBonusFit", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical = imgui.drag_int("HitNumBonusCritical", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue = imgui.drag_int("PerformanceValue", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue, 1, 0, 100); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed = imgui.drag_float("Speed", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed, 5.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The velocity of the bullet. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange = imgui.drag_float("FiringRange", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The maximum range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange = imgui.drag_float("EffectiveRange", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The effective range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity = imgui.drag_float("Gravity", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The strength of the gravitational force on the bullet.")
                            end
                        end

                        if i:match("^BallisticSettingEx") then
                            imgui.text_colored(ui.draw_line("=", 95) .. "| EX Bullet Ballistic" , func.convert_rgba_to_AGBR(textColor))
                            if AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset EX Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                if weapon.ID == "wp0800" then
                                    imgui.text("In this case EX refers to the High-Powered Rounds.")
                                elseif weapon.ID == "wp1000" then
                                    imgui.text("In this case EX refers to the Center Pellet.")
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur = imgui.drag_float("EX Spread", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread. Lower is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit = imgui.drag_float("EX Spread Fit", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum = imgui.drag_int("EX HitNum", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("Number of bullets on impact. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit = imgui.drag_int("EX HitNumBonusFit", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical = imgui.drag_int("EX HitNumBonusCritical", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue = imgui.drag_int("EX PerformanceValue", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue, 1, 0, 100); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed = imgui.drag_float("EX Speed", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed, 5.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The velocity of the bullet. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange = imgui.drag_float("EX FiringRange", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The maximum range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange = imgui.drag_float("EX EffectiveRange", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The effective range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity = imgui.drag_float("EX Gravity", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The strength of the gravitational force on the bullet.")
                            end
                        end

                        if i:match("^BallisticSettingAcid") then
                            imgui.text_colored(ui.draw_line("=", 95) .. "| Acid Bullet Ballistic" , func.convert_rgba_to_AGBR(textColor))
                            if AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Acid Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                if weapon.ID == "wp4100" then
                                    imgui.text("In this case Acid refers to the Acid Rounds.")
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur = imgui.drag_float("Acid Spread", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread. Lower is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit = imgui.drag_float("Acid Spread Fit", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum = imgui.drag_int("Acid HitNum", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("Number of bullets on impact. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit = imgui.drag_int("Acid HitNumBonusFit", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical = imgui.drag_int("Acid HitNumBonusCritical", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue = imgui.drag_int("Acid PerformanceValue", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue, 1, 0, 100); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed = imgui.drag_float("Acid Speed", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed, 5.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The velocity of the bullet. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange = imgui.drag_float("Acid FiringRange", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The maximum range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange = imgui.drag_float("Acid EffectiveRange", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The effective range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity = imgui.drag_float("Acid Gravity", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The strength of the gravitational force on the bullet.")
                            end
                        end

                        if i:match("^BallisticSettingFire") then
                            imgui.text_colored(ui.draw_line("=", 95) .. "| Fire Bullet Ballistic" , func.convert_rgba_to_AGBR(textColor))
                            if AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Fire Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                if weapon.ID == "wp4100" then
                                    imgui.text("In this case Fire refers to the Fire Rounds.")
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur = imgui.drag_float("Fire Spread", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread. Lower is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit = imgui.drag_float("Fire Spread Fit", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum = imgui.drag_int("Fire HitNum", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("Number of bullets on impact. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit = imgui.drag_int("Fire HitNumBonusFit", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical = imgui.drag_int("Fire HitNumBonusCritical", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue = imgui.drag_int("Fire PerformanceValue", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue, 1, 0, 100); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed = imgui.drag_float("Fire Speed", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed, 5.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The velocity of the bullet. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange = imgui.drag_float("Fire FiringRange", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The maximum range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange = imgui.drag_float("Fire EffectiveRange", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The effective range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity = imgui.drag_float("Fire Gravity", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The strength of the gravitational force on the bullet.")
                            end
                        end

                        if i:match("^AttackSettingNormal") then
                            imgui.text_colored(ui.draw_line("=", 95) .. "| Attack Settings" , func.convert_rgba_to_AGBR(textColor))
                            if AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Attack Settings") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                if weapon.Type ~="FT" then
                                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio = imgui.drag_int("Critical Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                    func.tooltip("The chance of landing a critical hit. Higher is better.")
                                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio = imgui.drag_int("Fit Critical Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                    func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue = imgui.drag_float("Base Damage", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base damage. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue = imgui.drag_float("Base Wince", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base stopping power. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue = imgui.drag_float("Base Break", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base dismemberment power. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue = imgui.drag_float("Base Damage Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base damage multiplier. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue = imgui.drag_float("Base Wince Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base stopping power multiplier. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue = imgui.drag_float("Base Break Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base dismemberment power multiplier. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage = imgui.drag_float("Fit Damage Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince = imgui.drag_float("Fit Wince Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break = imgui.drag_float("Fit Break Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage = imgui.drag_float("Critical Damage Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince = imgui.drag_float("Critical Wince Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break = imgui.drag_float("Critical Break Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier on a critical hit. Higher is better.")
                            end
                        end

                        if i:match("^AttackSettingEx") then
                            imgui.text_colored(ui.draw_line("=", 95) .. "| EX Attack Settings" , func.convert_rgba_to_AGBR(textColor))
                            if AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset EX Attack Settings") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                if weapon.ID == "wp0800" then
                                    imgui.text("In this case EX refers to the High-Powered Rounds.")
                                elseif weapon.ID == "wp1000" then
                                    imgui.text("In this case EX refers to the Center Pellet.")
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio = imgui.drag_int("EX Critical Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio = imgui.drag_int("EX Fit Critical Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue = imgui.drag_float("EX Base Damage", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base damage. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue = imgui.drag_float("EX Base Wince", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base stopping power. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue = imgui.drag_float("EX Base Break", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base dismemberment power. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue = imgui.drag_float("EX Base Damage Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base damage multiplier. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue = imgui.drag_float("EX Base Wince Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base stopping power multiplier. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue = imgui.drag_float("EX Base Break Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base dismemberment power multiplier. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage = imgui.drag_float("EX Fit Damage Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince = imgui.drag_float("EX Fit Wince Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break = imgui.drag_float("EX Fit Break Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage = imgui.drag_float("EX Critical Damage Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince = imgui.drag_float("EX Critical Wince Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break = imgui.drag_float("EX Critical Break Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier on a critical hit. Higher is better.")
                            end
                        end

                        if i:match("^AttackSettingAcid") then
                            if AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.text_colored(ui.draw_line("=", 95) .. "| Acid Attack Settings" , func.convert_rgba_to_AGBR(textColor))
                                imgui.spacing()
                                if imgui.button("Reset Acid Attack Settings") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio = imgui.drag_int("Acid Critical Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio = imgui.drag_int("Acid Fit Critical Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")

                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue = imgui.drag_float("Acid Base Damage", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base damage. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue = imgui.drag_float("Acid Base Wince", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base stopping power. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue = imgui.drag_float("Acid Base Break", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base dismemberment power. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue = imgui.drag_float("Acid Base Damage Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base damage multiplier. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue = imgui.drag_float("Acid Base Wince Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base stopping power multiplier. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue = imgui.drag_float("Acid Base Break Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base dismemberment power multiplier. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage = imgui.drag_float("Acid Fit Damage Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince = imgui.drag_float("Acid Fit Wince Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break = imgui.drag_float("Fit Break Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage = imgui.drag_float("Acid Critical Damage Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince = imgui.drag_float("Acid Critical Wince Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break = imgui.drag_float("Acid Critical Break Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier on a critical hit. Higher is better.")
                            end
                        end

                        if i:match("^AttackSettingFire") then
                            imgui.text_colored(ui.draw_line("=", 95) .. "| Fire Attack Settings" , func.convert_rgba_to_AGBR(textColor))
                            if AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Fire Attack Settings") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio = imgui.drag_int("Fire Critical Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio = imgui.drag_int("Fire Fit Critical Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")

                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue = imgui.drag_float("Fire Base Damage", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base damage. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue = imgui.drag_float("Fire Base Wince", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base stopping power. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue = imgui.drag_float("Fire Base Break", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base dismemberment power. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue = imgui.drag_float("Fire Base Damage Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base damage multiplier. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue = imgui.drag_float("Fire Base Wince Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base stopping power multiplier. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue = imgui.drag_float("Fire Base Break Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base dismemberment power multiplier. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage = imgui.drag_float("Fire Fit Damage Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince = imgui.drag_float("Fire Fit Wince Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break = imgui.drag_float("Fire Fit Break Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage = imgui.drag_float("Fire Critical Damage Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince = imgui.drag_float("Fire Critical Wince Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break = imgui.drag_float("Fire Critical Break Multiplier", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier on a critical hit. Higher is better.")
                            end
                        end

                        if i:match("^Normal") then
                            imgui.text_colored(ui.draw_line("=", 95) .. "| Around Pellet Ballistic" , func.convert_rgba_to_AGBR(textColor))
                            if AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Around Pellet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletNum = imgui.drag_int("Around Pellet Count", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("The number of pellets fired by a shotgun. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletDegree = imgui.drag_float("Around Pellet Angle", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletDegree, 0.1, 0.0, 180.0); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletLength = imgui.drag_float("Around Pellet Length", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletLength, 0.1, 0.0, 100.0); wc = wc or changed
                                func.tooltip("TBD")
                            end
                        end

                        if i:match("^Fit") then
                            imgui.text_colored(ui.draw_line("=", 95) .. "| Center Pellet Ballistic" , func.convert_rgba_to_AGBR(textColor))
                            if AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Center Pellet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletNum = imgui.drag_int("Center Pellet Count", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("The number of pellets fired by a shotgun. Higher is better.")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletDegree = imgui.drag_float("Center Pellet Angle", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletDegree, 0.1, 0.0, 180.0); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletLength = imgui.drag_float("Center Pellet Length", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletLength, 0.1, 0.0, 100.0); wc = wc or changed
                                func.tooltip("TBD")
                            end
                        end

                        if i:match("^RadiateSettings") then
                            imgui.text_colored(ui.draw_line("=", 95) .. "| Radiate" , func.convert_rgba_to_AGBR(textColor))
                            if AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Radiate Parameters") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].RadiateLength = imgui.drag_float("Flame Jet Length", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].RadiateLength, 0.1, 0.0, 100.0); wc = wc or changed
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Radius._BaseValue = imgui.drag_float("Flame Jet Radius", AWF_settings.RE2.Weapon_Params[weapon.ID].ShellGenerator[i].Radius._BaseValue, 0.1, 0.0, 100.0); wc = wc or changed
                            end
                        end
                    end
                end

                imgui.spacing()

                if AWF_settings.RE2.Weapon_Params[weapon.ID].Recoil then
                    imgui.text_colored(ui.draw_line("=", 95) .. "| Recoil" , func.convert_rgba_to_AGBR(textColor))
                            
                    if imgui.button("Reset Recoil Parameters") then
                        wc = true
                        AWF_settings.RE2.Weapon_Params[weapon.ID].Recoil = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].Recoil)
                    end
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Recoil._RecoilRate = imgui.drag_float("Recoil Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].Recoil._RecoilRate, 0.05, 0.0, 100.0); wc = wc or changed
                    func.tooltip("The strength of the visual recoil on the player. Lower is better.")
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Recoil._RecoilDampRate = imgui.drag_float("Recoil Damp Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].Recoil._RecoilDampRate, 0.01, 0.0, 100.0); wc = wc or changed
                    func.tooltip("The damping of the visual recoil on the player. Higher is better.")
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Recoil.RecoilRateRange.r = imgui.drag_float("Recoil Max", AWF_settings.RE2.Weapon_Params[weapon.ID].Recoil.RecoilRateRange.r, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("TBD")
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Recoil.RecoilRateRange.s = imgui.drag_float("Recoil Min", AWF_settings.RE2.Weapon_Params[weapon.ID].Recoil.RecoilRateRange.s, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("TBD")
                end
                
                imgui.spacing()

                if AWF_settings.RE2.Weapon_Params[weapon.ID].LoopFire then
                    imgui.text_colored(ui.draw_line("=", 95) .. "| Loop Fire" , func.convert_rgba_to_AGBR(textColor))
                    if imgui.button("Reset Loop Fire Parameters") then
                        wc = true
                        AWF_settings.RE2.Weapon_Params[weapon.ID].LoopFire = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].LoopFire)
                    end
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].LoopFire._Interval = imgui.drag_float("Loop Fire Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].LoopFire._Interval, 0.1, 0.0, 100.0); wc = wc or changed
                    func.tooltip("The speed at which the weapon depletes ammo. Lower is better.")
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].LoopFire._ReduceNumber = imgui.drag_int("Loop Fire Ammo Cost", AWF_settings.RE2.Weapon_Params[weapon.ID].LoopFire._ReduceNumber, 1, 0, 1000); wc = wc or changed
                    func.tooltip("The quantity of ammo expended per iteration. Lower is better.")
                end

                imgui.spacing()

                if AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle then
                    imgui.text_colored(ui.draw_line("=", 95) .. "| Reticle" , func.convert_rgba_to_AGBR(textColor))
                    if imgui.button("Reset Reticle Parameters") then
                        wc = true
                        AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].Reticle)
                    end
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle._AddPoint = imgui.drag_float("Reticle Add Point", AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle._AddPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points added over time by standing still while aiming.")
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle._KeepPoint = imgui.drag_float("Reticle Keep Point", AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle._KeepPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points required for the reticle to enter the focused state.")
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle._ShootPoint = imgui.drag_float("Reticle Shoot Point", AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle._ShootPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points subtracted for shooting.")
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle._MovePoint = imgui.drag_float("Reticle Move Point", AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle._MovePoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points subtracted for moving.")
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle._WatchPoint = imgui.drag_float("Reticle Watch Point", AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle._WatchPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points added over time by while the reticle is focused.")
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle.PointRange.r = imgui.drag_float("Reticle Max", AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle.PointRange.r, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The maximum range of points.")
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle.PointRange.s = imgui.drag_float("Reticle Min", AWF_settings.RE2.Weapon_Params[weapon.ID].Reticle.PointRange.s, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The minimum range of points.")
                end

                imgui.spacing()

                if AWF_settings.RE2.Weapon_Params[weapon.ID].Deviate then
                    imgui.text_colored(ui.draw_line("=", 95) .. "| Deviate" , func.convert_rgba_to_AGBR(textColor))
                    if imgui.button("Reset Deviate Parameters") then
                        wc = true
                        AWF_settings.RE2.Weapon_Params[weapon.ID].Deviate = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].Deviate)
                    end
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Deviate.DeviateYaw.r = imgui.drag_float("Deviate Yaw Max", AWF_settings.RE2.Weapon_Params[weapon.ID].Deviate.DeviateYaw.r, 0.01, -100.0, 100.0); wc = wc or changed
                    func.tooltip("Recoil maximum on the X axis.")
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Deviate.DeviateYaw.s = imgui.drag_float("Deviate Yaw Min", AWF_settings.RE2.Weapon_Params[weapon.ID].Deviate.DeviateYaw.s, 0.01, -100.0, 100.0); wc = wc or changed
                    func.tooltip("Recoil minimum on the X axis.")
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Deviate.DeviatePitch.r = imgui.drag_float("Deviate Pitch Max", AWF_settings.RE2.Weapon_Params[weapon.ID].Deviate.DeviatePitch.r, 0.01, -100.0, 100.0); wc = wc or changed
                    func.tooltip("Recoil maximum on the Y axis.")
                    changed, AWF_settings.RE2.Weapon_Params[weapon.ID].Deviate.DeviatePitch.s = imgui.drag_float("Deviate Pitch Min", AWF_settings.RE2.Weapon_Params[weapon.ID].Deviate.DeviatePitch.s, 0.01, -100.0, 100.0); wc = wc or changed
                    func.tooltip("Recoil minimum on the Y axis.")
                end

                imgui.spacing()

                if AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun then
                    local upgradeLVL = AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun
                    local sortedKeys = {}

                    for i in pairs(upgradeLVL) do
                        table.insert(sortedKeys, i)
                    end
                    table.sort(sortedKeys)

                    if imgui.tree_node((weapon.Name) .. " Upgrade Settings") then
                        for k, i in pairs(sortedKeys) do
                            if i:match("^Reticle_LVL_(%d+)$") then
                                local j = i:match("%d+$")
                                imgui.text_colored(ui.draw_line("=", 95) .. "| [ Level-" .. j .. " Reticle ]" , func.convert_rgba_to_AGBR(textColor))
                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Reticle Parameters") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].UserData.Gun[i])
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._AddPoint = imgui.drag_float("LVL-" .. j .. " Reticle Add Point", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._AddPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._KeepPoint = imgui.drag_float("LVL-" .. j .. " Reticle Keep Point", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._KeepPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._ShootPoint = imgui.drag_float("LVL-" .. j .. " Reticle Shoot Point", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._ShootPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._MovePoint = imgui.drag_float("LVL-" .. j .. " Reticle Move Point", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._MovePoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._WatchPoint = imgui.drag_float("LVL-" .. j .. " Reticle Watch Point", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._WatchPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].PointRange.r = imgui.drag_float("LVL-" .. j .. " Reticle Max", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].PointRange.r, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].PointRange.s = imgui.drag_float("LVL-" .. j .. " Reticle Min", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].PointRange.s, 1.0, -1000.0, 1000.0); wc = wc or changed
                                imgui.spacing()
                            end
                            if i:match("^Recoil_LVL_(%d+)$") then
                                local j = i:match("%d+$")
                                imgui.text_colored(ui.draw_line("=", 95) .. "| [ Level-" .. j .. " Recoil ]" , func.convert_rgba_to_AGBR(textColor))
                                
                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Recoil Parameters") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].UserData.Gun[i])
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._RecoilRate = imgui.drag_float("LVL-" .. j .. " Recoil Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._RecoilRate, 0.05, 0.0, 100.0); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._RecoilDampRate = imgui.drag_float("LVL-" .. j .. " Recoil Damp Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._RecoilDampRate, 0.01, 0.0, 100.0); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].RecoilRateRange.r = imgui.drag_float("LVL-" .. j .. " Recoil Max", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].RecoilRateRange.r, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].RecoilRateRange.s = imgui.drag_float("LVL-" .. j .. " Recoil Min", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].RecoilRateRange.s, 1.0, -1000.0, 1000.0); wc = wc or changed
                                imgui.spacing()
                            end
                            if i:match("^RapidFire_LVL_(%d+)$") then
                                local j = i:match("%d+$")
                                imgui.text_colored(ui.draw_line("=", 95) .. "| [ Level-" .. j .. " Rapid Fire ]" , func.convert_rgba_to_AGBR(textColor))
                                
                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Rapid Fire Parameters") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].UserData.Gun[i])
                                end

                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._Number = imgui.drag_int("LVL-" .. j .. " Burst Count", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._Number, 1, 0, 1000); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._Infinity = imgui.checkbox("LVL-" .. j .. "_Infinity", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._Infinity); wc = wc or changed
                                imgui.spacing()
                            end

                            if i:match("^LoopFire_LVL_(%d+)$") then
                                local j = i:match("%d+$")
                                imgui.text_colored(ui.draw_line("=", 95) .. "| [ Level-" .. j .. " Loop Fire ]" , func.convert_rgba_to_AGBR(textColor))
                                
                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Loop Fire Parameters") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].UserData.Gun[i])
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._Interval = imgui.drag_float("LVL-" .. j .. " Loop Fire Rate", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._Interval, 0.1, 0.0, 100.0); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._ReduceNumber = imgui.drag_int("LVL-" .. j .. " Loop Fire Ammo Cost", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i]._ReduceNumber, 1, 0, 1000); wc = wc or changed
                                imgui.spacing()
                            end

                            if i:match("^Deviate_LVL_(%d+)$") then
                                local j = i:match("%d+$")
                                imgui.text_colored(ui.draw_line("=", 95) .. "| [ Level-" .. j .. " Deviate ]" , func.convert_rgba_to_AGBR(textColor))
                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Deviate Parameters") then
                                    wc = true
                                    AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i] = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params[weapon.ID].UserData.Gun[i])
                                end
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].DeviateYaw.r = imgui.drag_float("LVL-" .. j .. " Deviate Yaw Max", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].DeviateYaw.r, 0.01, -100.0, 100.0); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].DeviateYaw.s = imgui.drag_float("LVL-" .. j .. " Deviate Yaw Min", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].DeviateYaw.s, 0.01, -100.0, 100.0); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].DeviatePitch.r = imgui.drag_float("LVL-" .. j .. " Deviate Pitch Max", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].DeviatePitch.r, 0.01, -100.0, 100.0); wc = wc or changed
                                
                                changed, AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].DeviatePitch.s = imgui.drag_float("LVL-" .. j .. " Deviate Pitch Min", AWF_settings.RE2.Weapon_Params[weapon.ID].UserData.Gun[i].DeviatePitch.s, 0.01, -100.0, 100.0); wc = wc or changed
                                imgui.spacing()
                            end
                        end
                        imgui.tree_pop()
                    end
                end
                
                imgui.indent(-10)
                imgui.end_rect(2)
                imgui.tree_pop()
            end
            if changed or wc then
                weapon.isUpdated = true
                get_WeaponData_RE2(AWF_settings.RE2.Weapons)
            end
            imgui.text_colored("  " .. ui.draw_line("-", 175) .."  ", func.convert_rgba_to_AGBR(textColor))
        end
        imgui.text_colored("  [ " .. ui.draw_line("=", 50) ..  " | " .. ui.draw_line("=", 50) .. " ] ", func.convert_rgba_to_AGBR(textColor))
        imgui.end_rect(1)
        imgui.end_window()
    end
end
local function draw_AWF_RE2Preset_GUI(weaponOrder)
    imgui.spacing()
    local textColor = {255,255,255,255}
    imgui.text_colored(" " .. ui.draw_line("=", 60), func.convert_rgba_to_AGBR(textColor))

    for _, weaponName in ipairs(weaponOrder) do
        local weapon = AWF_settings.RE2.Weapons[weaponName]
        
        if weapon and AWF_tool_settings.RE2[weapon.ID] then
            changed, AWF_settings.RE2.Weapon_Params[weapon.ID].current_param_indx = imgui.combo(weapon.Name, AWF_settings.RE2.Weapon_Params[weapon.ID].current_param_indx or 1, AWF_settings.RE2.Weapon_Params[weapon.ID].Weapon_Presets); wc = wc or changed
            if changed then
                local selected_preset = AWF_settings.RE2.Weapon_Params[weapon.ID].Weapon_Presets[AWF_settings.RE2.Weapon_Params[weapon.ID].current_param_indx]
                local json_filepath = [[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                local temp_params = json.load_file(json_filepath)
                
                if AWF_tool_settings.isDebug then
                    log.info("[AWF] [--------------------- [Manual Preset Loader] Loaded '" .. selected_preset .. "' for " .. weapon.Name .. "]")
                end

                if AWF_tool_settings.isInheritPresetName then
                    presetName = selected_preset
                end

                temp_params.Weapon_Presets = nil
                temp_params.current_param_indx = nil

                for key, value in pairs(temp_params) do
                    AWF_settings.RE2.Weapon_Params[weapon.ID][key] = value
                end
                clear_AWF_json_cache_RE2(AWF_settings.RE2.Weapons)
                cache_AWF_json_files_RE2(AWF_settings.RE2.Weapons)
                weapon.isUpdated = true
            end
            imgui.spacing()
        end
    end
    if changed or wc then
        json.dump_file("AWF/AWF_Settings.json", AWF_settings)
        json.dump_file("AWF/AWF_ToolSettings.json", AWF_tool_settings)
    end
    imgui.text_colored(ui.draw_line("=", 60), func.convert_rgba_to_AGBR(textColor))
end
local function draw_AWF_RE2_GUI()
    if reframework.get_game_name() == "re2" then
        if imgui.tree_node("Advanced Weapon Framework") then
            imgui.begin_rect()
            imgui.spacing()
            imgui.indent(5)
    
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_settings.RE2.Weapons = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapons)
                AWF_settings.RE2.Weapon_Params = hk.recurse_def_settings({}, AWFWeapons.RE2.Weapon_Params)
                AWF_tool_settings = hk.recurse_def_settings({}, AWF_default_settings)
                for _, weapon in pairs(AWF_settings.RE2.Weapons) do
                    weapon.isUpdated = true
                    get_WeaponData_RE2(AWF_settings.RE2.Weapons)
                end
                clear_AWF_json_cache_RE2(AWF_settings.RE2.Weapons)
                cache_AWF_json_files_RE2(AWF_settings.RE2.Weapons)
            end
            func.tooltip("Reset every parameter.")

            imgui.same_line()
            changed, show_AWF_editor = imgui.checkbox("Open AWF Weapon Stat Editor", show_AWF_editor)
            func.tooltip("Show/Hide the AWF Weapon Stat Editor.")

            if not show_AWF_editor or imgui.begin_window("Advanced Weapon Framework: Weapon Stat Editor", true, 0) == false  then
            show_AWF_editor = false
            else
                imgui.spacing()
                imgui.indent()
                
                draw_AWF_RE2Editor_GUI(AWF_settings.RE2.Weapon_Order)
                
                imgui.unindent()
                imgui.end_window()
            end

            if changed or wc or NowLoading then
                json.dump_file("AWF/AWF_Settings.json", AWF_settings)
                json.dump_file("AWF/AWF_ToolSettings.json", AWF_tool_settings)
                wc = false
                changed = false
            end
            
            draw_AWF_RE2Preset_GUI(AWF_settings.RE2.Weapon_Order)

            if imgui.tree_node("AWF Settings") then
                imgui.begin_rect()
                imgui.spacing()
                imgui.indent(5)
    
                changed, AWF_tool_settings.isDebug = imgui.checkbox("Debug Mode", AWF_tool_settings.isDebug); wc = wc or changed
                func.tooltip("Enable/Disable debug mode. When enabled, AWF will log significantly more information in the 're2_framework_log.txt' file, located in the game's root folder.\nLeave this on if you don't know what you are doing.")
                changed, AWF_tool_settings.isInheritPresetName = imgui.checkbox("Inherit Preset Name", AWF_tool_settings.isInheritPresetName); wc = wc or changed
                func.tooltip("If enabled the '[Enter Preset Name Here]' text in the Weapon Stat Editor will be replaced by the name of the last loaded preset.")
                
                if imgui.tree_node("Display Settings") then
                    for _, weaponName in ipairs(AWF_settings.RE2.Weapon_Order) do
                        local weapon = AWF_settings.RE2.Weapons[weaponName]
                        changed, AWF_tool_settings.RE2[weapon.ID] = imgui.checkbox(weapon.Name, AWF_tool_settings.RE2[weapon.ID]); wc = wc or changed
                        func.tooltip("Show/Hide the " .. weapon.Name .. " in the Preset Manager.")
                    end
                    imgui.tree_pop()
                end
    
                if imgui.tree_node("Credits") then
                    imgui.text(modCredits .. " ")
                    imgui.tree_pop()
                end
                
                imgui.indent(-5)
                imgui.spacing()
                imgui.end_rect(2)
                imgui.tree_pop()
            end
            imgui.spacing()
            ui.button_n_colored_txt("Current Version:", modVersion .. " | " .. modUpdated, func.convert_rgba_to_AGBR(0, 255, 0, 255))
            imgui.same_line()
            imgui.text("| by " .. modAuthor .. " ")
            
            imgui.spacing()
            imgui.indent(-5)
            imgui.end_rect(1)
            imgui.tree_pop()
        end
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: RE3R
local cached_weapon_GameObjects_RE3 = {}
local RE3_Cache = {
    InventoryMaster = scene:call("findGameObject(System.String)", "50_InventoryMaster"),
    ImplementGunRE3 = sdk.typeof("offline.implement.Gun"),
    EquipmentManager = sdk.typeof("offline.EquipmentManager"),
    shellPrefabSettings = {
        "ShellPrefabSetting",
        "ShellPrefabSettingNormal",
        "ShellPrefabSettingEx",
        "ShellPrefabSettingAcid",
        "ShellPrefabSettingFire",
        "ShellPrefabSettingMine",
        "Center",
        "Around",
    },
}

local function dump_default_weapon_params_RE3(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWFWeapons.RE3.Weapon_Params[weapon.ID]
        
        if weaponParams then
            json.dump_file("AWF/AWF_Weapons/".. weapon.Name .. "/" .. weapon.Name .. " Default".. ".json", weaponParams)
            log.info("AWF Default Weapon Params Dumped")
        end
    end
end
local function cache_weapon_gameobjects_RE3(weaponData)
    local Inventory_GameObject_RE3 = RE3_Cache.InventoryMaster

    for _, weapon in pairs(weaponData) do
        if weapon.isUpdated then
            local Weapon_GameObject_RE3 = scene:call("findGameObject(System.String)", weapon.ID)
            
            if Weapon_GameObject_RE3 then
                cached_weapon_GameObjects_RE3[weapon.ID] = Weapon_GameObject_RE3
                
                log.info("Cached " .. weapon.Name .. " Game Object")

                -- Main Game
                local Weapon_Stats_RE3 = Weapon_GameObject_RE3:call("getComponent(System.Type)", RE3_Cache.ImplementGunRE3)

                if Weapon_Stats_RE3 then
                    local weaponParams = AWF_settings.RE3.Weapon_Params[weapon.ID]
                    
                    if weaponParams then
                        for paramName, paramValue in pairs(weaponParams) do
                            if paramName == "EnableExecuteFire" then
                                Weapon_Stats_RE3[func.isBKF(paramName)] = paramValue
                            end
                            if paramName == "EnableRapidFireNumber" then
                                Weapon_Stats_RE3[func.isBKF(paramName)] = paramValue
                            end
                            if paramName == "Recoil" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local Weapon_RecoilParams_RE3 = Weapon_Stats_RE3:get_field("<RecoilParam>k__BackingField")

                                    if Weapon_RecoilParams_RE3 and subParamName ~= "RecoilRateRange" then
                                        Weapon_RecoilParams_RE3[subParamName] = subParamValue
                                    end
                                    if Weapon_RecoilParams_RE3 and subParamName == "RecoilRateRange" then
                                        for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                            local Weapon_RecoilRangeParams_RE3 = Weapon_RecoilParams_RE3:get_field("_RecoilRateRange")

                                            if Weapon_RecoilRangeParams_RE3 then
                                                Weapon_RecoilRangeParams_RE3[subParamName_2nd] = subParamValue_2nd
                                                func.write_valuetype(Weapon_RecoilParams_RE3, 0x10, Weapon_RecoilRangeParams_RE3)
                                            end
                                        end
                                    end
                                end
                            end
                            if paramName == "LoopFire" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local Weapon_LoopFireParams_RE3 = Weapon_Stats_RE3:get_field("<LoopFireParam>k__BackingField")

                                    if Weapon_LoopFireParams_RE3 then
                                        Weapon_LoopFireParams_RE3[subParamName] = subParamValue
                                    end
                                end
                            end
                            if paramName == "Reticle" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local Weapon_ReticleParams_RE3 = Weapon_Stats_RE3:get_field("<ReticleParam>k__BackingField")

                                    if Weapon_ReticleParams_RE3 and subParamName ~= "PointRange" then
                                        Weapon_ReticleParams_RE3[subParamName] = subParamValue
                                    end
                                    if Weapon_ReticleParams_RE3 and subParamName == "PointRange" then
                                        for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                            local Weapon_ReticleRangeParams_RE3 = Weapon_ReticleParams_RE3:get_field("_PointRange")

                                            if Weapon_ReticleRangeParams_RE3 then
                                                Weapon_ReticleRangeParams_RE3[subParamName_2nd] = subParamValue_2nd
                                                func.write_valuetype(Weapon_ReticleParams_RE3, 0x10, Weapon_ReticleRangeParams_RE3)
                                            end
                                        end
                                    end
                                end
                            end
                            if paramName == "Deviate" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local Weapon_DeviateParams_RE3 = Weapon_Stats_RE3:get_field("<DeviateParam>k__BackingField")

                                    if Weapon_DeviateParams_RE3 then
                                        if subParamName == "DeviateYaw" then
                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                local Weapon_DeviateYaw_RE3 = Weapon_DeviateParams_RE3:get_field("_TrainOffYaw")

                                                if Weapon_DeviateYaw_RE3 then
                                                    Weapon_DeviateYaw_RE3[subParamName_2nd] = subParamValue_2nd
                                                    func.write_valuetype(Weapon_DeviateParams_RE3, 0x60, Weapon_DeviateYaw_RE3)
                                                end
                                            end
                                        end
                                        if subParamName == "DeviatePitch" then
                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                local Weapon_DeviatePitch_RE3 = Weapon_DeviateParams_RE3:get_field("_TrainOffPitch")

                                                if Weapon_DeviatePitch_RE3 then
                                                    Weapon_DeviatePitch_RE3[subParamName_2nd] = subParamValue_2nd
                                                    func.write_valuetype(Weapon_DeviateParams_RE3, 0x68, Weapon_DeviatePitch_RE3)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if paramName == "ShellGenerator" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local Weapon_ShellGenerator_RE3 = Weapon_Stats_RE3:get_field("<ShellGenerator>k__BackingField")

                                    if Weapon_ShellGenerator_RE3 then
                                        local Weapon_ShellGenerator_UserDataBase_RE3 = Weapon_ShellGenerator_RE3:get_field("_TGeneratorUserDataBase")

                                        if Weapon_ShellGenerator_UserDataBase_RE3 then
                                            local Weapon_ShellGenerator_BulletGenerateSetting_RE3 = Weapon_ShellGenerator_UserDataBase_RE3:get_field("BulletGenerateSetting")

                                            if Weapon_ShellGenerator_BulletGenerateSetting_RE3 then
                                                local Weapon_ShellGenerator_Normal_RE3 = Weapon_ShellGenerator_BulletGenerateSetting_RE3:get_field("Normal")
                                                local Weapon_ShellGenerator_Fit_RE3 = Weapon_ShellGenerator_BulletGenerateSetting_RE3:get_field("Fit")
                                                local weaponShellUserData = {}

                                                if Weapon_ShellGenerator_Normal_RE3 then
                                                    if subParamName == "Normal" then
                                                        for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                            Weapon_ShellGenerator_Normal_RE3[subParamName_2nd] = subParamValue_2nd
                                                        end
                                                    end
                                                end
                                                if Weapon_ShellGenerator_Fit_RE3 then
                                                    if subParamName == "Fit" then
                                                        for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                            Weapon_ShellGenerator_Fit_RE3[subParamName_2nd] = subParamValue_2nd
                                                        end
                                                    end
                                                end
                                                for _, settingName in ipairs(RE3_Cache.shellPrefabSettings) do
                                                    local setting = Weapon_ShellGenerator_BulletGenerateSetting_RE3:get_field(settingName)
                                                    weaponShellUserData[settingName] = setting and setting:get_field("ShellUserData")

                                                    for i, shellUserData in pairs(weaponShellUserData) do
                                                        if shellUserData then
                                                            if (subParamName == "BallisticSettingNormal") or (subParamName == "BallisticSettingEx") or (subParamName == "BallisticSettingAcid") or (subParamName == "BallisticSettingFire") or (subParamName == "BallisticSettingMine") then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    local Weapon_ShellUserData_BallisticSettingNormal_RE3 =  shellUserData:get_field("BallisticSetting")
    
                                                                    if Weapon_ShellUserData_BallisticSettingNormal_RE3 then
                                                                        Weapon_ShellUserData_BallisticSettingNormal_RE3[subParamName_2nd] = subParamValue_2nd
                                                                    end
                                                                end
                                                            end
                                                            if (subParamName == "AttackSettingNormal") or (subParamName == "AttackSettingEx") or (subParamName == "AttackSettingAcid") or (subParamName == "AttackSettingFire") or (subParamName == "AttackSettingMine") then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    local Weapon_ShellUserData_AttackSetting_RE3 = shellUserData:get_field("AttackSetting")
                                                                    
                                                                    if Weapon_ShellUserData_AttackSetting_RE3 then
                                                                        if subParamName_2nd == "CriticalRatio" then
                                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingCriticalRatio_RE3 = Weapon_ShellUserData_AttackSetting_RE3:get_field("CriticalRatio")
            
                                                                                if Weapon_ShellUserData_AttackSettingCriticalRatio_RE3 then
                                                                                    Weapon_ShellUserData_AttackSettingCriticalRatio_RE3[subParamName_3rd] = subParamValue_3rd
                                                                                end
                                                                            end
                                                                        end
                                                                        if subParamName_2nd == "FitCriticalRatio"then
                                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE3 = Weapon_ShellUserData_AttackSetting_RE3:get_field("FitCriticalRatio")
    
                                                                                if Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE3 then
                                                                                    Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE3[subParamName_3rd] = subParamValue_3rd
                                                                                end
                                                                            end
                                                                        end
                                                                        if subParamName_2nd == "Normal" then
                                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingNormal_RE3 = Weapon_ShellUserData_AttackSetting_RE3:get_field("Normal")
                                                                                
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE3 and subParamName_3rd == "Damage" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Damage_RE3 = Weapon_ShellUserData_AttackSettingNormal_RE3:get_field("Damage")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Damage_RE3 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Damage_RE3[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE3 and subParamName_3rd == "Wince" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Wince_RE3 = Weapon_ShellUserData_AttackSettingNormal_RE3:get_field("Wince")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Wince_RE3 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Wince_RE3[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE3 and subParamName_3rd == "Break" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Break_RE3 = Weapon_ShellUserData_AttackSettingNormal_RE3:get_field("Break")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Break_RE3 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Break_RE3[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE3 and subParamName_3rd == "Accumulate" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Accumulate_RE3 = Weapon_ShellUserData_AttackSettingNormal_RE3:get_field("Accumulate")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Accumulate_RE3 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Accumulate_RE3[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                        if subParamName_2nd == "NormalRate" then
                                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingNormal_RE3 = Weapon_ShellUserData_AttackSetting_RE3:get_field("NormalRate")
                                                                                
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE3 and subParamName_3rd == "Damage" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Damage_RE3 = Weapon_ShellUserData_AttackSettingNormal_RE3:get_field("Damage")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Damage_RE3 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Damage_RE3[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE3 and subParamName_3rd == "Wince" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Wince_RE3 = Weapon_ShellUserData_AttackSettingNormal_RE3:get_field("Wince")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Wince_RE3 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Wince_RE3[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE3 and subParamName_3rd == "Break" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Break_RE3 = Weapon_ShellUserData_AttackSettingNormal_RE3:get_field("Break")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Break_RE3 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Break_RE3[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE3 and subParamName_3rd == "Accumulate" then
                                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Accumulate_RE3 = Weapon_ShellUserData_AttackSettingNormal_RE3:get_field("Accumulate")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Accumulate_RE3 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Accumulate_RE3[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                        if subParamName_2nd == "FitRatioContainer"then
                                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingFitRatioContainer_RE3 = Weapon_ShellUserData_AttackSetting_RE3:get_field("FitRatioContainer")
    
                                                                                if Weapon_ShellUserData_AttackSettingFitRatioContainer_RE3 then
                                                                                    Weapon_ShellUserData_AttackSettingFitRatioContainer_RE3[subParamName_3rd] = subParamValue_3rd
                                                                                end
                                                                            end
                                                                        end
                                                                        if subParamName_2nd == "CriticalRatioContainer"then
                                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingCritRatioContainer_RE3 = Weapon_ShellUserData_AttackSetting_RE3:get_field("CriticalRatioContainer")
    
                                                                                if Weapon_ShellUserData_AttackSettingCritRatioContainer_RE3 then
                                                                                    Weapon_ShellUserData_AttackSettingCritRatioContainer_RE3[subParamName_3rd] = subParamValue_3rd
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
                                end
                            end
                            if paramName == "UserData" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local Weapon_UserDataParams_RE3 = Weapon_Stats_RE3:get_field("_UserData")

                                    if Weapon_UserDataParams_RE3 then
                                        local Weapon_UserDataParams_Gun_RE3 = Weapon_UserDataParams_RE3:get_field("_Gun")
                                        
                                        if Weapon_UserDataParams_Gun_RE3 then
                                            local Weapon_UserDataParams_Reticle_RE3 = Weapon_UserDataParams_Gun_RE3:get_field("_ReticlePartsCombos")
                                            Weapon_UserDataParams_Reticle_RE3 = Weapon_UserDataParams_Reticle_RE3 and Weapon_UserDataParams_Reticle_RE3:get_elements() or {}
                                            
                                            local Weapon_UserDataParams_Recoil_RE3 = Weapon_UserDataParams_Gun_RE3:get_field("_RecoilPartsCombos")
                                            Weapon_UserDataParams_Recoil_RE3 = Weapon_UserDataParams_Recoil_RE3 and Weapon_UserDataParams_Recoil_RE3:get_elements() or {}

                                            local Weapon_UserDataParams_RapidFire_RE3 = Weapon_UserDataParams_Gun_RE3:get_field("_RapidFirePartsCombos")
                                            Weapon_UserDataParams_RapidFire_RE3 = Weapon_UserDataParams_RapidFire_RE3 and Weapon_UserDataParams_RapidFire_RE3:get_elements() or {}

                                            local Weapon_UserDataParams_LoopFire_RE3 = Weapon_UserDataParams_Gun_RE3:get_field("_LoopFirePartsCombos")
                                            Weapon_UserDataParams_LoopFire_RE3 = Weapon_UserDataParams_LoopFire_RE3 and Weapon_UserDataParams_LoopFire_RE3:get_elements() or {}

                                            local Weapon_UserDataParams_Deviate_RE3 = Weapon_UserDataParams_Gun_RE3:get_field("_DeviatePartsCombos")
                                            Weapon_UserDataParams_Deviate_RE3 = Weapon_UserDataParams_Deviate_RE3 and Weapon_UserDataParams_Deviate_RE3:get_elements() or {}
                                            
                                            if Weapon_UserDataParams_Reticle_RE3 ~= nil then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    for i = 2, #Weapon_UserDataParams_Reticle_RE3 do
                                                        local Weapon_UserDataParams_ReticleParams_RE3 = Weapon_UserDataParams_Reticle_RE3[i]:get_field("_Param")
                                                        local matched_ParamName = "Reticle_LVL_" .. string.format("%02d", i)
                                                    
                                                        if Weapon_UserDataParams_ReticleParams_RE3 and subParamName_2nd == matched_ParamName then
                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                if Weapon_UserDataParams_ReticleParams_RE3 and subParamName_3rd ~= "PointRange" then
                                                                    Weapon_UserDataParams_ReticleParams_RE3[subParamName_3rd] = subParamValue_3rd
                                                                end
                                                                if Weapon_UserDataParams_ReticleParams_RE3 and subParamName_3rd == "PointRange" then
                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                        local Weapon_ReticleRangeParams_RE3 = Weapon_UserDataParams_ReticleParams_RE3:get_field("_PointRange")
                                
                                                                        if Weapon_ReticleRangeParams_RE3 then
                                                                            Weapon_ReticleRangeParams_RE3[subParamName_4th] = subParamValue_4th
                                                                            func.write_valuetype(Weapon_UserDataParams_ReticleParams_RE3, 0x10, Weapon_ReticleRangeParams_RE3)
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            if Weapon_UserDataParams_Recoil_RE3 ~= nil then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    for i = 2, #Weapon_UserDataParams_Recoil_RE3 do
                                                        local Weapon_UserDataParams_RecoilParams_RE3 = Weapon_UserDataParams_Recoil_RE3[i]:get_field("_Param")
                                                        local matched_ParamName = "Recoil_LVL_" .. string.format("%02d", i)

                                                        if Weapon_UserDataParams_RecoilParams_RE3 and subParamName_2nd == matched_ParamName then
                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                if Weapon_UserDataParams_RecoilParams_RE3 and subParamName_3rd ~= "RecoilRateRange" then
                                                                    Weapon_UserDataParams_RecoilParams_RE3[subParamName_3rd] = subParamValue_3rd
                                                                end
                                                                if Weapon_UserDataParams_RecoilParams_RE3 and subParamName_3rd == "RecoilRateRange" then
                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                        local Weapon_RecoilRangeParams_RE3 = Weapon_UserDataParams_RecoilParams_RE3:get_field("_RecoilRateRange")
                                
                                                                        if Weapon_RecoilRangeParams_RE3 then
                                                                            Weapon_RecoilRangeParams_RE3[subParamName_4th] = subParamValue_4th
                                                                            func.write_valuetype(Weapon_UserDataParams_RecoilParams_RE3, 0x10, Weapon_RecoilRangeParams_RE3)
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            if Weapon_UserDataParams_RapidFire_RE3 ~= nil then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    for i = 1, #Weapon_UserDataParams_RapidFire_RE3 do
                                                        local Weapon_UserDataParams_RapidFireParams_RE3 = Weapon_UserDataParams_RapidFire_RE3[i]:get_field("_Param")
                                                        local matched_ParamName = "RapidFire_LVL_" .. string.format("%02d", i)

                                                        if Weapon_UserDataParams_RapidFireParams_RE3 and subParamName_2nd == matched_ParamName then
                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                Weapon_UserDataParams_RapidFireParams_RE3[subParamName_3rd] = subParamValue_3rd
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            if Weapon_UserDataParams_LoopFire_RE3 ~= nil then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    for i = 2, #Weapon_UserDataParams_LoopFire_RE3 do
                                                        local Weapon_UserDataParams_LoopFireParams_RE3 = Weapon_UserDataParams_LoopFire_RE3[i]:get_field("_Param")
                                                        local matched_ParamName = "LoopFire_LVL_" .. string.format("%02d", i)

                                                        if Weapon_UserDataParams_LoopFireParams_RE3 and subParamName_2nd == matched_ParamName then
                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                Weapon_UserDataParams_LoopFireParams_RE3[subParamName_3rd] = subParamValue_3rd
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            if Weapon_UserDataParams_Deviate_RE3 ~= nil then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    for i = 2, #Weapon_UserDataParams_Deviate_RE3 do
                                                        local Weapon_UserDataParams_DeviateParams_RE3 = Weapon_UserDataParams_Deviate_RE3[i]:get_field("_Param")
                                                        local matched_ParamName = "Deviate_LVL_" .. string.format("%02d", i)

                                                        if Weapon_UserDataParams_DeviateParams_RE3 and subParamName_2nd == matched_ParamName then
                                                            for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                if Weapon_UserDataParams_DeviateParams_RE3 and subParamName_3rd == "DeviateYaw" then
                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                        local Weapon_UserDataParams_DeviateParamsYaw_RE3 = Weapon_UserDataParams_DeviateParams_RE3:get_field("_TrainOffYaw")
                                                                        

                                                                        if Weapon_UserDataParams_DeviateParamsYaw_RE3 then
                                                                            Weapon_UserDataParams_DeviateParamsYaw_RE3[subParamName_4th] = subParamValue_4th
                                                                            func.write_valuetype(Weapon_UserDataParams_DeviateParams_RE3, 0x60, Weapon_UserDataParams_DeviateParamsYaw_RE3)
                                                                        end
                                                                    end
                                                                end
                                                                if Weapon_UserDataParams_DeviateParams_RE3 and subParamName_3rd == "DeviatePitch" then
                                                                    for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                        local Weapon_UserDataParams_DeviateParamsPitch_RE3 = Weapon_UserDataParams_DeviateParams_RE3:get_field("_TrainOffPitch")

                                                                        if Weapon_UserDataParams_DeviateParamsPitch_RE3 then
                                                                            Weapon_UserDataParams_DeviateParamsPitch_RE3[subParamName_4th] = subParamValue_4th
                                                                            func.write_valuetype(Weapon_UserDataParams_DeviateParams_RE3, 0x68, Weapon_UserDataParams_DeviateParamsPitch_RE3)
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
                        end
                    end
                end
            end

            if Inventory_GameObject_RE3 then
                local EquipmentManager_RE3 = Inventory_GameObject_RE3:call("getComponent(System.Type)", RE3_Cache.EquipmentManager)
                
                if EquipmentManager_RE3 then
                    local weaponParams = AWF_settings.RE3.Weapon_Params[weapon.ID]

                    if weaponParams then
                        for paramName, paramValue in pairs(weaponParams) do
                            if paramName == "Inventory" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local EquipmentManager_WeaponBulletData_RE3 = EquipmentManager_RE3:get_field("_WeaponBulletUserdata")

                                    if EquipmentManager_WeaponBulletData_RE3 then
                                        local EquipmentManager_LoadingPartsCombos_RE3 = EquipmentManager_WeaponBulletData_RE3:get_field("_LoadingPartsCombos")
                                        EquipmentManager_LoadingPartsCombos_RE3 = EquipmentManager_LoadingPartsCombos_RE3 and EquipmentManager_LoadingPartsCombos_RE3:get_elements() or {}
                                        
                                        for i, WeaponNames in ipairs(EquipmentManager_LoadingPartsCombos_RE3) do
                                            local WeaponDisplayNames = WeaponNames:call("get_DisplayName")
                                            
                                            if WeaponDisplayNames and WeaponDisplayNames:find(string.upper(weapon.ID)) then
                                                local Weapon_LoadingPartsCombos_RE3 = WeaponNames:call("get_LoadingPartsCombosForm")
                                                Weapon_LoadingPartsCombos_RE3 = Weapon_LoadingPartsCombos_RE3 and Weapon_LoadingPartsCombos_RE3:get_elements() or {}
                                                
                                                for j, PartSettings in ipairs(Weapon_LoadingPartsCombos_RE3) do
                                                    if (subParamName ~= "AlwaysReloadableVariable") and (subParamName ~= "_NumberEX") then
                                                        PartSettings[subParamName] = subParamValue
                                                        
                                                        if j == 2 then
                                                            PartSettings["_Number"] = weaponParams.Inventory._NumberEX
                                                        end
                                                    end
                                                    if subParamName == "AlwaysReloadableVariable" then
                                                        for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                            local AlwaysReloadableVariable_RE3 = PartSettings:get_field("_AlwaysReloadableVariable")

                                                            if AlwaysReloadableVariable_RE3 and weaponParams.Inventory._AlwaysReloadable == true then
                                                                AlwaysReloadableVariable_RE3[subParamName_2nd] = weaponParams.Inventory.AlwaysReloadableVariable
                                                                func.write_valuetype(PartSettings, 0x38, AlwaysReloadableVariable_RE3)
                                                            elseif AlwaysReloadableVariable_RE3 and weaponParams.Inventory._AlwaysReloadable == false then
                                                                AlwaysReloadableVariable_RE3[subParamName_2nd] = weaponParams.Inventory.AlwaysReloadableVariable.mData1 + 1
                                                                func.write_valuetype(PartSettings, 0x38, AlwaysReloadableVariable_RE3)
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
            end
        end
        weapon.isUpdated = false
    end
end
local function cache_json_files_RE3(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWF_settings.RE3.Weapon_Params[weapon.ID]
        
        if weaponParams then
            local json_names = AWF_settings.RE3.Weapon_Params[weapon.ID].Weapon_Presets or {}
            local json_filepaths = fs.glob([[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\.*.json]])
            
            if json_filepaths then
                for i, filepath in ipairs(json_filepaths) do
                    local name = filepath:match("^.+\\(.+)%.")
                    local nameExists = false
                    
                    for _, existingName in ipairs(json_names) do
                        if existingName == name then
                            nameExists = true
                            break
                        end
                    end
                    
                    if not nameExists then
                        log.info("Loaded " .. filepath .. " for " .. weapon.Name)
                        table.insert(json_names, 1, name)
                    end
                end
            else
                log.info("No JSON files found for " .. weapon.Name)
            end
        end
    end
end
if reframework.get_game_name() == "re3" then
    dump_default_weapon_params_RE3(AWFWeapons.RE3.Weapons)
    cache_json_files_RE3(AWF_settings.RE3.Weapons)
end
local function get_weapon_gameobject_RE3(weaponData)
    for _, weapon in pairs(weaponData) do
        local Weapon_GameObject_RE3 = cached_weapon_GameObjects_RE3[weapon.ID]
        
        if Weapon_GameObject_RE3 and weapon.isUpdated then
            log.info("Loaded " .. weapon.Name .. " Game Object from cache")
        end
    end
end
local function update_cached_weapon_gameobjects_RE3()
    if changed or wc or not cached_weapon_GameObjects_RE3 then
        changed = false
        wc = false
        AWF_Weapons_Found = true
        cache_weapon_gameobjects_RE3(AWF_settings.RE3.Weapons)
        get_weapon_gameobject_RE3(AWF_settings.RE3.Weapons)
        log.info("------------ AWF Weapon Data Updated!")
    end
end
local function draw_AWF_RE3Editor_GUI(weaponOrder)
    if imgui.begin_window("Advanced Weapon Framework") then
        imgui.begin_rect()
        imgui.button("[===============================| AWF WEAPON STAT EDITOR |===============================]")
        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF_settings.RE3.Weapons[weaponName]

            if weapon and imgui.tree_node(string.upper(weapon.Name)) then
                imgui.begin_rect()
                if imgui.button("Reset to Defaults") then
                    wc = true
                    AWF_settings.RE3.Weapon_Params[weapon.ID] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID])
                    cache_json_files_RE3(AWF_settings.RE3.Weapons)
                end
                func.tooltip("Reset the parameters of " .. weapon.Name)
                
                imgui.same_line()
                imgui.button(" | ")

                imgui.same_line()
                if imgui.button("Update Preset List") then
                    cache_json_files_RE3(AWF_settings.RE3.Weapons)
                end

                if imgui.button("Save Preset") then
                    json.dump_file("AWF/AWF_Weapons/".. weapon.Name .. "/" .. weapon.Name .. " Custom".. ".json", AWF_settings.RE3.Weapon_Params[weapon.ID])
                    log.info("AWF Custom " .. weapon.Name ..  " Params Saved")
                end
                func.tooltip("Save the current parameters of the " .. weapon.Name .. " to a .json file found in [RE3/reframework/data/AWF/AWF_Weapons/".. weapon.Name .. "]")

                imgui.same_line()
                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].current_param_indx = imgui.combo("Preset", AWF_settings.RE3.Weapon_Params[weapon.ID].current_param_indx or 1, AWF_settings.RE3.Weapon_Params[weapon.ID].Weapon_Presets); wc = wc or changed
                func.tooltip("Select a file from the dropdown menu to load the weapon stats from that file.")
                if changed then
                    local selected_preset = AWF_settings.RE3.Weapon_Params[weapon.ID].Weapon_Presets[AWF_settings.RE3.Weapon_Params[weapon.ID].current_param_indx]
                    local json_filepath = [[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                    local temp_params = json.load_file(json_filepath)
                    
                    temp_params.Weapon_Presets = nil
                    temp_params.current_param_indx = nil

                    for key, value in pairs(temp_params) do
                        AWF_settings.RE3.Weapon_Params[weapon.ID][key] = value
                    end
                end

                imgui.spacing()

                if AWF_settings.RE3.Weapon_Params[weapon.ID].Inventory then
                    if imgui.button("Reset Inventory Parameters") then
                        wc = true
                        AWF_settings.RE3.Weapon_Params[weapon.ID].Inventory = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].Inventory)
                    end

                    if AWF_tool_settings.isDebug then
                        changed, AWF_settings.RE3.Weapon_Params[weapon.ID].EnableExecuteFire = imgui.checkbox("[DEBUG] Enable Fire", AWF_settings.RE3.Weapon_Params[weapon.ID].EnableExecuteFire); wc = wc or changed
                        func.tooltip("[DEBUG] If disabled, the weapon can't fire. Also a debug option so if you see this IDK what you are doing.")

                        imgui.same_line()
                    end
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Inventory._Infinity = imgui.checkbox("Unlimited Capacity", AWF_settings.RE3.Weapon_Params[weapon.ID].Inventory._Infinity); wc = wc or changed
                    func.tooltip("If enabled, the weapon does not need to be reloaded.")

                    imgui.same_line()
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Inventory._AlwaysReloadable = imgui.checkbox("Unlimited Ammo", AWF_settings.RE3.Weapon_Params[weapon.ID].Inventory._AlwaysReloadable); wc = wc or changed
                    func.tooltip("If enabled, the weapon will never run out of ammo.")
                    
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Inventory._Number = imgui.drag_int("Ammo Capacity",AWF_settings.RE3.Weapon_Params[weapon.ID].Inventory._Number, 1, 0, 1000); wc = wc or changed
                    func.tooltip("The maximum number of rounds the weapon can hold. Higher is better.")
                    
                    if (weapon.ID == "wp0000") or (weapon.ID == "wp1000") or (weapon.ID == "wp2000") then
                        changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Inventory._NumberEX = imgui.drag_int("EX Ammo Capacity",AWF_settings.RE3.Weapon_Params[weapon.ID].Inventory._NumberEX, 1, 0, 1000); wc = wc or changed
                        func.tooltip("The maximum number of rounds the upgraded weapon can hold. Higher is better.")
                    end
                end

                imgui.spacing()

                if AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator then
                    local shellGenTypes = AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator
                    local sortedKeys = {}

                    for i in pairs(shellGenTypes) do
                        table.insert(sortedKeys, i)
                    end
                    table.sort(sortedKeys)

                    for k, i in pairs(sortedKeys) do
                        if i:match("^BallisticSettingNormal") then
                            if AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur = imgui.drag_float("Spread", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread. Lower is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit = imgui.drag_float("Spread Fit", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum = imgui.drag_int("HitNum", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("Number of bullets on impact. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit = imgui.drag_int("HitNumBonusFit", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical = imgui.drag_int("HitNumBonusCritical", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue = imgui.drag_int("PerformanceValue", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue, 1, 0, 100); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed = imgui.drag_float("Speed", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed, 5.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The velocity of the bullet. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange = imgui.drag_float("FiringRange", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The maximum range of the weapon. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange = imgui.drag_float("EffectiveRange", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The effective range of the weapon. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity = imgui.drag_float("Gravity", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The strength of the gravitational force on the bullet.")
                            end
                        end

                        if i:match("^BallisticSettingEx") then
                            if AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset EX Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                if weapon.ID == "wp1000" then
                                    imgui.text("In this case EX refers to the Center Pellet.")
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur = imgui.drag_float("EX Spread", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread. Lower is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit = imgui.drag_float("EX Spread Fit", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum = imgui.drag_int("EX HitNum", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("Number of bullets on impact. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit = imgui.drag_int("EX HitNumBonusFit", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical = imgui.drag_int("EX HitNumBonusCritical", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue = imgui.drag_int("EX PerformanceValue", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue, 1, 0, 100); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed = imgui.drag_float("EX Speed", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed, 5.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The velocity of the bullet. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange = imgui.drag_float("EX FiringRange", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The maximum range of the weapon. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange = imgui.drag_float("EX EffectiveRange", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The effective range of the weapon. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity = imgui.drag_float("EX Gravity", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The strength of the gravitational force on the bullet.")
                            end
                        end

                        if i:match("^BallisticSettingAcid") then
                            if AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Acid Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur = imgui.drag_float("Acid Spread", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread. Lower is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit = imgui.drag_float("Acid Spread Fit", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum = imgui.drag_int("Acid HitNum", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("Number of bullets on impact. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit = imgui.drag_int("Acid HitNumBonusFit", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical = imgui.drag_int("Acid HitNumBonusCritical", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue = imgui.drag_int("Acid PerformanceValue", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue, 1, 0, 100); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed = imgui.drag_float("Acid Speed", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed, 5.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The velocity of the bullet. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange = imgui.drag_float("Acid FiringRange", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The maximum range of the weapon. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange = imgui.drag_float("Acid EffectiveRange", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The effective range of the weapon. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity = imgui.drag_float("Acid Gravity", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The strength of the gravitational force on the bullet.")
                            end
                        end

                        if i:match("^BallisticSettingFire") then
                            if AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Fire Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur = imgui.drag_float("Fire Spread", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread. Lower is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit = imgui.drag_float("Fire Spread Fit", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum = imgui.drag_int("Fire HitNum", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("Number of bullets on impact. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit = imgui.drag_int("Fire HitNumBonusFit", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical = imgui.drag_int("Fire HitNumBonusCritical", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue = imgui.drag_int("Fire PerformanceValue", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue, 1, 0, 100); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed = imgui.drag_float("Fire Speed", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed, 5.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The velocity of the bullet. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange = imgui.drag_float("Fire FiringRange", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The maximum range of the weapon. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange = imgui.drag_float("Fire EffectiveRange", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The effective range of the weapon. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity = imgui.drag_float("Fire Gravity", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The strength of the gravitational force on the bullet.")
                            end
                        end

                        if i:match("^BallisticSettingMine") then
                            if AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Mine Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur = imgui.drag_float("Mine Spread", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Slur, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread. Lower is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit = imgui.drag_float("Mine Spread Fit", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum = imgui.drag_int("Mine HitNum", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("Number of bullets on impact. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit = imgui.drag_int("Mine HitNumBonusFit", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical = imgui.drag_int("Mine HitNumBonusCritical", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue = imgui.drag_int("Mine PerformanceValue", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue, 1, 0, 100); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed = imgui.drag_float("Mine Speed", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Speed, 5.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The velocity of the bullet. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange = imgui.drag_float("Mine FiringRange", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The maximum range of the weapon. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange = imgui.drag_float("Mine EffectiveRange", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The effective range of the weapon. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity = imgui.drag_float("Mine Gravity", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The strength of the gravitational force on the bullet.")
                            end
                        end

                        if i:match("^AttackSettingNormal") then
                            if AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Attack Settings") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                if weapon.Type ~="FT" then
                                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio = imgui.drag_int("Critical Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                    func.tooltip("The chance of landing a critical hit. Higher is better.")
                                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio = imgui.drag_int("Fit Critical Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                    func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue = imgui.drag_float("Base Damage", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base damage. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue = imgui.drag_float("Base Wince", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base stopping power. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue = imgui.drag_float("Base Break", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base dismemberment power. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue = imgui.drag_float("Base Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base damage multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue = imgui.drag_float("Base Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base stopping power multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue = imgui.drag_float("Base Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base dismemberment power multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage = imgui.drag_float("Fit Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince = imgui.drag_float("Fit Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break = imgui.drag_float("Fit Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage = imgui.drag_float("Critical Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince = imgui.drag_float("Critical Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break = imgui.drag_float("Critical Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier on a critical hit. Higher is better.")
                            end
                        end

                        if i:match("^AttackSettingEx") then
                            if AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset EX Attack Settings") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                if weapon.ID == "wp0800" then
                                    imgui.text("In this case EX refers to the High-Powered Rounds.")
                                elseif weapon.ID == "wp1000" then
                                    imgui.text("In this case EX refers to the Center Pellet.")
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio = imgui.drag_int("EX Critical Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio = imgui.drag_int("EX Fit Critical Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue = imgui.drag_float("EX Base Damage", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base damage. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue = imgui.drag_float("EX Base Wince", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base stopping power. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue = imgui.drag_float("EX Base Break", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base dismemberment power. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue = imgui.drag_float("EX Base Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base damage multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue = imgui.drag_float("EX Base Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base stopping power multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue = imgui.drag_float("EX Base Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base dismemberment power multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage = imgui.drag_float("EX Fit Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince = imgui.drag_float("EX Fit Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break = imgui.drag_float("EX Fit Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage = imgui.drag_float("EX Critical Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince = imgui.drag_float("EX Critical Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break = imgui.drag_float("EX Critical Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier on a critical hit. Higher is better.")
                            end
                        end

                        if i:match("^AttackSettingAcid") then
                            if AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Acid Attack Settings") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio = imgui.drag_int("Acid Critical Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio = imgui.drag_int("Acid Fit Critical Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")

                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue = imgui.drag_float("Acid Base Damage", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base damage. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue = imgui.drag_float("Acid Base Wince", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base stopping power. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue = imgui.drag_float("Acid Base Break", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base dismemberment power. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue = imgui.drag_float("Acid Base Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base damage multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue = imgui.drag_float("Acid Base Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base stopping power multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue = imgui.drag_float("Acid Base Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base dismemberment power multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage = imgui.drag_float("Acid Fit Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince = imgui.drag_float("Acid Fit Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break = imgui.drag_float("Fit Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage = imgui.drag_float("Acid Critical Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince = imgui.drag_float("Acid Critical Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break = imgui.drag_float("Acid Critical Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier on a critical hit. Higher is better.")
                            end
                        end

                        if i:match("^AttackSettingFire") then
                            if AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Fire Attack Settings") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio = imgui.drag_int("Fire Critical Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio = imgui.drag_int("Fire Fit Critical Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")

                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue = imgui.drag_float("Fire Base Damage", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base damage. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue = imgui.drag_float("Fire Base Wince", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base stopping power. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue = imgui.drag_float("Fire Base Break", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base dismemberment power. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue = imgui.drag_float("Fire Base Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base damage multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue = imgui.drag_float("Fire Base Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base stopping power multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue = imgui.drag_float("Fire Base Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base dismemberment power multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage = imgui.drag_float("Fire Fit Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince = imgui.drag_float("Fire Fit Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break = imgui.drag_float("Fire Fit Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage = imgui.drag_float("Fire Critical Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince = imgui.drag_float("Fire Critical Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break = imgui.drag_float("Fire Critical Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier on a critical hit. Higher is better.")
                            end
                        end

                        if i:match("^AttackSettingMine") then
                            if AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Mine Attack Settings") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio = imgui.drag_int("Mine Critical Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio = imgui.drag_int("Mine Fit Critical Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")

                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue = imgui.drag_float("Mine Base Damage", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base damage. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue = imgui.drag_float("Mine Base Wince", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base stopping power. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue = imgui.drag_float("Mine Base Break", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base dismemberment power. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue = imgui.drag_float("Mine Base Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base damage multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue = imgui.drag_float("Mine Base Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base stopping power multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue = imgui.drag_float("Mine Base Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base dismemberment power multiplier. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage = imgui.drag_float("Mine Fit Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince = imgui.drag_float("Mine Fit Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break = imgui.drag_float("Mine Fit Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage = imgui.drag_float("Mine Critical Damage Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince = imgui.drag_float("Mine Critical Wince Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break = imgui.drag_float("Mine Critical Break Multiplier", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier on a critical hit. Higher is better.")
                            end
                        end

                        if i:match("^Normal") then
                            if AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Around Pellet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletNum = imgui.drag_int("Around Pellet Count", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("The number of pellets fired by a shotgun. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletDegree = imgui.drag_float("Around Pellet Angle", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletDegree, 0.1, 0.0, 180.0); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletLength = imgui.drag_float("Around Pellet Length", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletLength, 0.1, 0.0, 100.0); wc = wc or changed
                                func.tooltip("TBD")
                            end
                        end

                        if i:match("^Fit") then
                            if AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Center Pellet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletNum = imgui.drag_int("Center Pellet Count", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("The number of pellets fired by a shotgun. Higher is better.")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletDegree = imgui.drag_float("Center Pellet Angle", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletDegree, 0.1, 0.0, 180.0); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletLength = imgui.drag_float("Center Pellet Length", AWF_settings.RE3.Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletLength, 0.1, 0.0, 100.0); wc = wc or changed
                                func.tooltip("TBD")
                            end
                        end
                    end
                end

                imgui.spacing()

                if AWF_settings.RE3.Weapon_Params[weapon.ID].Recoil then
                    if imgui.button("Reset Recoil Parameters") then
                        wc = true
                        AWF_settings.RE3.Weapon_Params[weapon.ID].Recoil = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].Recoil)
                    end
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Recoil._RecoilRate = imgui.drag_float("Recoil Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].Recoil._RecoilRate, 0.05, 0.0, 100.0); wc = wc or changed
                    func.tooltip("The strength of the visual recoil on the player. Lower is better.")
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Recoil._RecoilDampRate = imgui.drag_float("Recoil Damp Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].Recoil._RecoilDampRate, 0.01, 0.0, 100.0); wc = wc or changed
                    func.tooltip("The damping of the visual recoil on the player. Higher is better.")
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Recoil.RecoilRateRange.r = imgui.drag_float("Recoil Max", AWF_settings.RE3.Weapon_Params[weapon.ID].Recoil.RecoilRateRange.r, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("TBD")
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Recoil.RecoilRateRange.s = imgui.drag_float("Recoil Min", AWF_settings.RE3.Weapon_Params[weapon.ID].Recoil.RecoilRateRange.s, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("TBD")
                end
                
                imgui.spacing()

                if AWF_settings.RE3.Weapon_Params[weapon.ID].LoopFire then
                    if imgui.button("Reset Loop Fire Parameters") then
                        wc = true
                        AWF_settings.RE3.Weapon_Params[weapon.ID].LoopFire = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].LoopFire)
                    end
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].LoopFire._Interval = imgui.drag_float("Loop Fire Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].LoopFire._Interval, 0.1, 0.0, 100.0); wc = wc or changed
                    func.tooltip("The speed at which the weapon depletes ammo. Lower is better.")
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].LoopFire._ReduceNumber = imgui.drag_int("Loop Fire Ammo Cost", AWF_settings.RE3.Weapon_Params[weapon.ID].LoopFire._ReduceNumber, 1, 0, 1000); wc = wc or changed
                    func.tooltip("The quantity of ammo expended per iteration. Lower is better.")
                end

                imgui.spacing()

                if AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle then
                    if imgui.button("Reset Reticle Parameters") then
                        wc = true
                        AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].Reticle)
                    end
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle._AddPoint = imgui.drag_float("Reticle Add Point", AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle._AddPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points added over time by standing still while aiming.")
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle._KeepPoint = imgui.drag_float("Reticle Keep Point", AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle._KeepPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points required for the reticle to enter the focused state.")
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle._ShootPoint = imgui.drag_float("Reticle Shoot Point", AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle._ShootPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points subtracted for shooting.")
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle._MovePoint = imgui.drag_float("Reticle Move Point", AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle._MovePoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points subtracted for moving.")
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle._WatchPoint = imgui.drag_float("Reticle Watch Point", AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle._WatchPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points added over time by while the reticle is focused.")
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle.PointRange.r = imgui.drag_float("Reticle Max", AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle.PointRange.r, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The maximum range of points.")
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle.PointRange.s = imgui.drag_float("Reticle Min", AWF_settings.RE3.Weapon_Params[weapon.ID].Reticle.PointRange.s, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The minimum range of points.")
                end

                imgui.spacing()

                if AWF_settings.RE3.Weapon_Params[weapon.ID].Deviate then
                    if imgui.button("Reset Deviate Parameters") then
                        wc = true
                        AWF_settings.RE3.Weapon_Params[weapon.ID].Deviate = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].Deviate)
                    end
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Deviate.DeviateYaw.r = imgui.drag_float("Deviate Yaw Max", AWF_settings.RE3.Weapon_Params[weapon.ID].Deviate.DeviateYaw.r, 0.01, -100.0, 100.0); wc = wc or changed
                    func.tooltip("Recoil maximum on the X axis.")
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Deviate.DeviateYaw.s = imgui.drag_float("Deviate Yaw Min", AWF_settings.RE3.Weapon_Params[weapon.ID].Deviate.DeviateYaw.s, 0.01, -100.0, 100.0); wc = wc or changed
                    func.tooltip("Recoil minimum on the X axis.")
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Deviate.DeviatePitch.r = imgui.drag_float("Deviate Pitch Max", AWF_settings.RE3.Weapon_Params[weapon.ID].Deviate.DeviatePitch.r, 0.01, -100.0, 100.0); wc = wc or changed
                    func.tooltip("Recoil maximum on the Y axis.")
                    changed, AWF_settings.RE3.Weapon_Params[weapon.ID].Deviate.DeviatePitch.s = imgui.drag_float("Deviate Pitch Min", AWF_settings.RE3.Weapon_Params[weapon.ID].Deviate.DeviatePitch.s, 0.01, -100.0, 100.0); wc = wc or changed
                    func.tooltip("Recoil minimum on the Y axis.")
                end

                imgui.spacing()

                if AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun then
                    local upgradeLVL = AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun
                    local sortedKeys = {}

                    for i in pairs(upgradeLVL) do
                        table.insert(sortedKeys, i)
                    end
                    table.sort(sortedKeys)

                    if imgui.tree_node(string.upper(weapon.Name) .. " UPGRADE SETTINGS") then
                        for k, i in pairs(sortedKeys) do
                            if i:match("^Reticle_LVL_(%d+)$") then
                                local j = i:match("%d+$")
                                
                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Reticle Parameters") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].UserData.Gun[i])
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._AddPoint = imgui.drag_float("LVL-" .. j .. " Reticle Add Point", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._AddPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._KeepPoint = imgui.drag_float("LVL-" .. j .. " Reticle Keep Point", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._KeepPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._ShootPoint = imgui.drag_float("LVL-" .. j .. " Reticle Shoot Point", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._ShootPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._MovePoint = imgui.drag_float("LVL-" .. j .. " Reticle Move Point", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._MovePoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._WatchPoint = imgui.drag_float("LVL-" .. j .. " Reticle Watch Point", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._WatchPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].PointRange.r = imgui.drag_float("LVL-" .. j .. " Reticle Max", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].PointRange.r, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].PointRange.s = imgui.drag_float("LVL-" .. j .. " Reticle Min", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].PointRange.s, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                            end
                            if i:match("^Recoil_LVL_(%d+)$") then
                                local j = i:match("%d+$")

                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Recoil Parameters") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].UserData.Gun[i])
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._RecoilRate = imgui.drag_float("LVL-" .. j .. " Recoil Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._RecoilRate, 0.05, 0.0, 100.0); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._RecoilDampRate = imgui.drag_float("LVL-" .. j .. " Recoil Damp Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._RecoilDampRate, 0.01, 0.0, 100.0); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].RecoilRateRange.r = imgui.drag_float("LVL-" .. j .. " Recoil Max", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].RecoilRateRange.r, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].RecoilRateRange.s = imgui.drag_float("LVL-" .. j .. " Recoil Min", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].RecoilRateRange.s, 1.0, -1000.0, 1000.0); wc = wc or changed
                                
                            end
                            if i:match("^RapidFire_LVL_(%d+)$") then
                                local j = i:match("%d+$")

                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Rapid Fire Parameters") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].UserData.Gun[i])
                                end

                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._Number = imgui.drag_int("LVL-" .. j .. " Burst Count", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._Number, 1, 0, 1000); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._Infinity = imgui.checkbox("LVL-" .. j .. "_Infinity", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._Infinity); wc = wc or changed
                                
                            end
                            if i:match("^LoopFire_LVL_(%d+)$") then
                                local j = i:match("%d+$")

                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Loop Fire Parameters") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].UserData.Gun[i])
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._Interval = imgui.drag_float("LVL-" .. j .. " Loop Fire Rate", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._Interval, 0.1, 0.0, 100.0); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._ReduceNumber = imgui.drag_int("LVL-" .. j .. " Loop Fire Ammo Cost", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i]._ReduceNumber, 1, 0, 1000); wc = wc or changed
                                
                            end
                            if i:match("^Deviate_LVL_(%d+)$") then
                                local j = i:match("%d+$")

                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Deviate Parameters") then
                                    wc = true
                                    AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i] = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params[weapon.ID].UserData.Gun[i])
                                end
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].DeviateYaw.r = imgui.drag_float("LVL-" .. j .. " Deviate Yaw Max", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].DeviateYaw.r, 0.01, -100.0, 100.0); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].DeviateYaw.s = imgui.drag_float("LVL-" .. j .. " Deviate Yaw Min", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].DeviateYaw.s, 0.01, -100.0, 100.0); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].DeviatePitch.r = imgui.drag_float("LVL-" .. j .. " Deviate Pitch Max", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].DeviatePitch.r, 0.01, -100.0, 100.0); wc = wc or changed
                                
                                changed, AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].DeviatePitch.s = imgui.drag_float("LVL-" .. j .. " Deviate Pitch Min", AWF_settings.RE3.Weapon_Params[weapon.ID].UserData.Gun[i].DeviatePitch.s, 0.01, -100.0, 100.0); wc = wc or changed
                                
                            end
                        end
                        imgui.tree_pop()
                    end
                end

                if changed or wc then
                    weapon.isUpdated = true
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
--MARK: RE4R
local cached_weapon_GameObjects_RE4 = {}
local cached_jsonPaths_RE4 = {}
local RE4_Cache = {
    weaponCatalog = "WeaponCatalog",
    weaponCatalog_AO = "WeaponCatalog_AO",
    weaponCatalog_MC = "WeaponCatalog_MC",
    weaponCatalog_MC2 = "WeaponCatalog_MC_2nd",
    weaponCatalogRegister = sdk.typeof("chainsaw.WeaponCatalogRegister"),
    weaponCustomCatalog = "WeaponCustomCatalog",
    weaponCustomCatalog_AO = "WeaponCustomCatalog_AO",
    weaponCustomCatalog_MC = "WeaponCustomCatalog_MC",
    weaponCustomCatalogRegister = sdk.typeof("chainsaw.WeaponCustomCatalogRegister"),
    playerInventory = "PlayerInventoryObserver",
    playerInventoryObserver = sdk.typeof("chainsaw.PlayerInventoryObserver"),
    playerEquipment = "chainsaw.PlayerEquipment",
    reticleTypes = {
        [0] = "Handgun (Type-0)",
        [4] = "Handgun (Type-4)",
        [6] = "Handgun (Type-6)",
        [103] = "Shotgun (Type-103)",
        [104] = "Shotgun (Type-104)",
        [105] = "Shotgun (Type-105)",
        [106] = "Handgun (Type-106)",
        [201] = "Submachine Gun (Type-201)",
        [202] = "Submachine Gun (Type-202)",
        [203] = "Submachine Gun (Type-203)",
        [400] = "Submachine Gun (Type-400)",
        [500] = "Magnum (Type-500)",
        [501] = "Magnum (Type-501)",
        [800] = "X-BOW (Type-800)",
        [801] = "X-BOW (Type-801)",
        [901] = "RPG (Type-901)",
        [1001] = "Knife (Type-1001)",
        [9000] = "Throw (Type-9000)",
        [100000] = "None (100000)",
    },
    ammoTypes = {
        [-1] = "Invalid",
        [112320000] = "Explosive Arrows",
        [112480000] = "Blast Arrows",
        [112800000] = "Handgun Ammo",
        [112801600] = "Magnum Ammo",
        [112803200] = "Shotgun Ammo",
        [112804800] = "Rifle Ammo",
        [112806400] = "Submachine Gun Ammo",
        [112808000] = "Bolts",
        [112809600] = "Explosive Bolts",
    },
    itemSizeTypes = {
        [0] = "1x1",
        [1] = "1x2",
        [2] = "1x3",
        [3] = "1x4",
        [4] = "1x5",
        [5] = "1x9",
        [6] = "2x1",
        [7] = "2x2",
        [8] = "2x3",
        [9] = "2x4",
        [10] = "2x5",
        [11] = "2x6",
        [12] = "2x7",
        [13] = "2x8",
        [14] = "3x1",
        [15] = "3x5",
        [16] = "3x7",
        [17] = "4x1",
        [18] = "4x2",
        [19] = "6x2",

    },
    reloadTypes = {
        [0] = "At Once",
        [1] = "Every Single"
    },
    shootTypes = {
        [0] = "Semi Auto",
        [1] = "Full Auto"
    },
}
local playerContext = nil
local playerHead = nil
local isPlayerInScene = false

local function get_playerContext()
    local character_manager
    character_manager = sdk.get_managed_singleton(sdk.game_namespace("CharacterManager"))
    playerContext = character_manager and character_manager:call("getPlayerContextRef")
    return playerContext
end

--Dumps the default weapon data from the AWFWeapons table to [WeaponName]-Default.json
local function dump_Default_WeaponParam_json_RE4(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWFWeapons.RE4.Weapon_Params[weapon.ID]
        
        if weaponParams then
            json.dump_file("AWF/AWF_Weapons/".. weapon.Name .. "/" .. weapon.Name .. " Default".. ".json", weaponParams)
            if AWF_tool_settings.isDebug then
                log.info("[AWF] [Default Weapon Params for " .. weapon.Name .. " dumped.]")
            end
        end
    end
end
--Sets the weapon data for the weapons found in the AWF Master table, or uses the values from a custom preset
local function get_WeaponData_RE4(weaponData)
    get_playerContext()
    local currentGameMode = nil

    for _, weapon in pairs(weaponData) do
        if weapon.isUpdated then
            local Weapon_GameObject_RE4 = scene:call("findGameObject(System.String)", weapon.ID)

            if Weapon_GameObject_RE4 then
                cached_weapon_GameObjects_RE4[weapon.ID] = Weapon_GameObject_RE4
                log.info("[AWF] [ " .. weapon.ID .. " Base data updated.]")
                
                local Weapon_Stats_RE4 = Weapon_GameObject_RE4:call("getComponent(System.Type)", sdk.typeof("chainsaw.Gun"))

                if not Weapon_Stats_RE4 then
                    Weapon_Stats_RE4 = Weapon_GameObject_RE4:call("getComponent(System.Type)", sdk.typeof("chainsaw.Melee"))
                end
                
                if Weapon_Stats_RE4 then
                    local weaponParams = AWF_settings.RE4.Weapon_Params[weapon.ID]

                    if weaponParams then
                        for paramName, paramValue in pairs(weaponParams) do
                            if paramName == "BaseStats" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    if weapon.Type ~= "KNF" then
                                        if subParamName == "ShellGenerator" then
                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do                         
                                                local Weapon_ShellGenerator_RE4 = Weapon_Stats_RE4:get_field("<ShellGenerator>k__BackingField")

                                                if Weapon_ShellGenerator_RE4 then
                                                    local Weapon_ShellGenerator_UserData_RE4 = Weapon_ShellGenerator_RE4:get_field("_UserData")

                                                    if Weapon_ShellGenerator_UserData_RE4 then
                                                        local Weapon_ShellInfoUserData_RE4 = Weapon_ShellGenerator_UserData_RE4:get_field("_ShellInfoUserData")
                                                        
                                                        if Weapon_ShellInfoUserData_RE4 then
                                                            local Weapon_LifeInfo_RE4 = Weapon_ShellInfoUserData_RE4:get_field("_LifeInfo")
                                                            local Weapon_MoveInfo_RE4 = Weapon_ShellInfoUserData_RE4:get_field("_MoveInfo")
                                                            local Weapon_AttackInfo_RE4 = Weapon_ShellInfoUserData_RE4:get_field("_AttackInfo")

                                                            if subParamName_2nd == "LifeInfo" then
                                                                for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                    Weapon_LifeInfo_RE4[subParamName_3rd] = subParamValue_3rd
                                                                end 
                                                            end
                                                            if subParamName_2nd == "MoveInfo" then
                                                                for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                    Weapon_MoveInfo_RE4[subParamName_3rd] = subParamValue_3rd
                                                                end 
                                                            end
                                                            if subParamName_2nd == "AttackInfo" then
                                                                for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                    local Weapon_AttackInfo_DamageRate_RE4 = Weapon_AttackInfo_RE4:get_field("_DamageRate")
                                                                    local Weapon_AttackInfo_WinceRate_RE4 = Weapon_AttackInfo_RE4:get_field("_WinceRate")
                                                                    local Weapon_AttackInfo_BreakRate_RE4 = Weapon_AttackInfo_RE4:get_field("_BreakRate")
                                                                    local Weapon_AttackInfo_StoppingRate_RE4 = Weapon_AttackInfo_RE4:get_field("_StoppingRate")
                                                                    
                                                                    if subParamName_3rd == "_ColliderRadius" or subParamName_3rd == "_CriticalRate" or subParamName_3rd == "_CriticalRate_Fit" then
                                                                        Weapon_AttackInfo_RE4[subParamName_3rd] = subParamValue_3rd
                                                                    end

                                                                    if subParamName_3rd == "DamageRate" then
                                                                        for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                            Weapon_AttackInfo_DamageRate_RE4[subParamName_4th] = subParamValue_4th
                                                                        end
                                                                    end
                                                                    if subParamName_3rd == "WinceRate" then
                                                                        for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                            Weapon_AttackInfo_WinceRate_RE4[subParamName_4th] = subParamValue_4th
                                                                        end
                                                                    end
                                                                    if subParamName_3rd == "BreakRate" then
                                                                        for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                            Weapon_AttackInfo_BreakRate_RE4[subParamName_4th] = subParamValue_4th
                                                                        end
                                                                    end
                                                                    if subParamName_3rd == "StoppingRate" then
                                                                        for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                            Weapon_AttackInfo_StoppingRate_RE4[subParamName_4th] = subParamValue_4th
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                        if weapon.Type == "SG" then
                                                            local Weapon_CenterShellUserData_RE4 = Weapon_ShellGenerator_UserData_RE4:get_field("_CenterShellInfoUserData")
                                                            local Weapon_AroundShellUserData_RE4 = Weapon_ShellGenerator_UserData_RE4:get_field("_AroundShellInfoUserData")
                                                            local Weapon_AroundShellSetting_RE4 = Weapon_ShellGenerator_UserData_RE4:get_field("_AroundShellSetting")
                                                            
                                                            if Weapon_CenterShellUserData_RE4 then
                                                                if subParamName_2nd == "Center" then    
                                                                    for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                        local Weapon_LifeInfo_RE4 = Weapon_CenterShellUserData_RE4:get_field("_LifeInfo")
                                                                        local Weapon_MoveInfo_RE4 = Weapon_CenterShellUserData_RE4:get_field("_MoveInfo")
                                                                        local Weapon_AttackInfo_RE4 = Weapon_CenterShellUserData_RE4:get_field("_AttackInfo")
                                                                
                                                                        if subParamName_3rd == "LifeInfo" then
                                                                            for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                Weapon_LifeInfo_RE4[subParamName_4th] = subParamValue_4th
                                                                            end 
                                                                        end
                                                                        if subParamName_3rd == "MoveInfo" then
                                                                            for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                Weapon_MoveInfo_RE4[subParamName_4th] = subParamValue_4th
                                                                            end 
                                                                        end
                                                                        if subParamName_3rd == "AttackInfo" then
                                                                            
                                                                            for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                local Weapon_AttackInfo_DamageRate_RE4 = Weapon_AttackInfo_RE4:get_field("_DamageRate")
                                                                                local Weapon_AttackInfo_WinceRate_RE4 = Weapon_AttackInfo_RE4:get_field("_WinceRate")
                                                                                local Weapon_AttackInfo_BreakRate_RE4 = Weapon_AttackInfo_RE4:get_field("_BreakRate")
                                                                                local Weapon_AttackInfo_StoppingRate_RE4 = Weapon_AttackInfo_RE4:get_field("_StoppingRate")
                                                                                
                                                                                if subParamName_4th == "_ColliderRadius" or subParamName_4th == "_CriticalRate" or subParamName_4th == "_CriticalRate_Fit" then
                                                                                    Weapon_AttackInfo_RE4[subParamName_4th] = subParamValue_4th
                                                                                end

                                                                                if subParamName_4th == "DamageRate" then
                                                                                    for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                        Weapon_AttackInfo_DamageRate_RE4[subParamName_5th] = subParamValue_5th
                                                                                    end
                                                                                end
                                                                                if subParamName_4th == "WinceRate" then
                                                                                    for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                        Weapon_AttackInfo_WinceRate_RE4[subParamName_5th] = subParamValue_5th
                                                                                    end
                                                                                end
                                                                                if subParamName_4th == "BreakRate" then
                                                                                    for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                        Weapon_AttackInfo_BreakRate_RE4[subParamName_5th] = subParamValue_5th
                                                                                    end
                                                                                end
                                                                                if subParamName_4th == "StoppingRate" then
                                                                                    for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                        Weapon_AttackInfo_StoppingRate_RE4[subParamName_5th] = subParamValue_5th
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                            if Weapon_AroundShellUserData_RE4 then
                                                                if subParamName_2nd == "Around" then    
                                                                    for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                        local Weapon_LifeInfo_RE4 = Weapon_AroundShellUserData_RE4:get_field("_LifeInfo")
                                                                        local Weapon_MoveInfo_RE4 = Weapon_AroundShellUserData_RE4:get_field("_MoveInfo")
                                                                        local Weapon_AttackInfo_RE4 = Weapon_AroundShellUserData_RE4:get_field("_AttackInfo")
                                                                
                                                                        if subParamName_3rd == "LifeInfo" then
                                                                            for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                Weapon_LifeInfo_RE4[subParamName_4th] = subParamValue_4th
                                                                            end 
                                                                        end
                                                                        if subParamName_3rd == "MoveInfo" then
                                                                            for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                Weapon_MoveInfo_RE4[subParamName_4th] = subParamValue_4th
                                                                            end 
                                                                        end
                                                                        if subParamName_3rd == "AttackInfo" then
                                                                            
                                                                            for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                local Weapon_AttackInfo_DamageRate_RE4 = Weapon_AttackInfo_RE4:get_field("_DamageRate")
                                                                                local Weapon_AttackInfo_WinceRate_RE4 = Weapon_AttackInfo_RE4:get_field("_WinceRate")
                                                                                local Weapon_AttackInfo_BreakRate_RE4 = Weapon_AttackInfo_RE4:get_field("_BreakRate")
                                                                                local Weapon_AttackInfo_StoppingRate_RE4 = Weapon_AttackInfo_RE4:get_field("_StoppingRate")
                                                                                
                                                                                if subParamName_4th == "_ColliderRadius" or subParamName_4th == "_CriticalRate" or subParamName_4th == "_CriticalRate_Fit" then
                                                                                    Weapon_AttackInfo_RE4[subParamName_4th] = subParamValue_4th
                                                                                end

                                                                                if subParamName_4th == "DamageRate" then
                                                                                    for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                        Weapon_AttackInfo_DamageRate_RE4[subParamName_5th] = subParamValue_5th
                                                                                    end
                                                                                end
                                                                                if subParamName_4th == "WinceRate" then
                                                                                    for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                        Weapon_AttackInfo_WinceRate_RE4[subParamName_5th] = subParamValue_5th
                                                                                    end
                                                                                end
                                                                                if subParamName_4th == "BreakRate" then
                                                                                    for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                        Weapon_AttackInfo_BreakRate_RE4[subParamName_5th] = subParamValue_5th
                                                                                    end
                                                                                end
                                                                                if subParamName_4th == "StoppingRate" then
                                                                                    for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                        Weapon_AttackInfo_StoppingRate_RE4[subParamName_5th] = subParamValue_5th
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                            if Weapon_AroundShellSetting_RE4 then
                                                                if subParamName_2nd == "AroundSetting" then 
                                                                    for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                        if (subParamName_3rd ~= "CenterScatter") and (subParamName_3rd ~= "AroundScatter") then
                                                                            Weapon_AroundShellSetting_RE4[subParamName_3rd] = subParamValue_3rd
                                                                        end
                                                                        if subParamName_3rd == "CenterScatter" then
                                                                            local Weapon_AroundShellSetting_Center_RE4 = Weapon_AroundShellSetting_RE4:get_field("_CenterScatterParam")

                                                                            if Weapon_AroundShellSetting_Center_RE4 then
                                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                    local Weapon_AroundShellSetting_CenterVertical_RE4 = Weapon_AroundShellSetting_Center_RE4:get_field("_VerticalScatterDegreeRange")
                                                                                    local Weapon_AroundShellSetting_CenterHorizontal_RE4 = Weapon_AroundShellSetting_Center_RE4:get_field("_HorizontalScatterDegreeRange")

                                                                                    if subParamName_4th == "Vertical" then
                                                                                        if Weapon_AroundShellSetting_CenterVertical_RE4 then
                                                                                            for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                                Weapon_AroundShellSetting_CenterVertical_RE4[subParamName_5th] = subParamValue_5th
                                                                                                func.write_valuetype(Weapon_AroundShellSetting_Center_RE4, 0x10, Weapon_AroundShellSetting_CenterVertical_RE4)
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                    if subParamName_4th == "Horizontal" then
                                                                                        if Weapon_AroundShellSetting_CenterHorizontal_RE4 then
                                                                                            for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                                Weapon_AroundShellSetting_CenterHorizontal_RE4[subParamName_5th] = subParamValue_5th
                                                                                                func.write_valuetype(Weapon_AroundShellSetting_Center_RE4, 0x18, Weapon_AroundShellSetting_CenterHorizontal_RE4)
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end                                                                            
                                                                        end
                                                                        if subParamName_3rd == "AroundScatter" then
                                                                            local Weapon_AroundShellSetting_Around_RE4 = Weapon_AroundShellSetting_RE4:get_field("_AroundScatterParam")

                                                                            if Weapon_AroundShellSetting_Around_RE4 then
                                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                    local Weapon_AroundShellSetting_AroundVertical_RE4 = Weapon_AroundShellSetting_Around_RE4:get_field("_VerticalScatterDegreeRange")
                                                                                    local Weapon_AroundShellSetting_AroundHorizontal_RE4 = Weapon_AroundShellSetting_Around_RE4:get_field("_HorizontalScatterDegreeRange")

                                                                                    if subParamName_4th == "Vertical" then
                                                                                        if Weapon_AroundShellSetting_AroundVertical_RE4 then
                                                                                            for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                                Weapon_AroundShellSetting_AroundVertical_RE4[subParamName_5th] = subParamValue_5th
                                                                                                func.write_valuetype(Weapon_AroundShellSetting_Around_RE4, 0x10, Weapon_AroundShellSetting_AroundVertical_RE4)
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                    if subParamName_4th == "Horizontal" then
                                                                                        if Weapon_AroundShellSetting_AroundHorizontal_RE4 then
                                                                                            for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                                Weapon_AroundShellSetting_AroundHorizontal_RE4[subParamName_5th] = subParamValue_5th
                                                                                                func.write_valuetype(Weapon_AroundShellSetting_Around_RE4, 0x18, Weapon_AroundShellSetting_AroundHorizontal_RE4)
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
                                                        if weapon.Type == "THRW" then
                                                            local Weapon_GrenadeShellInfoUserData_RE4 = Weapon_ShellGenerator_UserData_RE4._GrenadeShellInfoUserData

                                                            if Weapon_GrenadeShellInfoUserData_RE4 then
                                                                local Weapon_LifeInfo_RE4 = Weapon_GrenadeShellInfoUserData_RE4._LifeInfo
                                                                local Weapon_MoveInfo_RE4 = Weapon_GrenadeShellInfoUserData_RE4._MoveInfo
                                                                local Weapon_AttackInfo_RE4 = Weapon_GrenadeShellInfoUserData_RE4._AttackInfo

                                                                if subParamName_2nd == "LifeInfo" then
                                                                    for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                        Weapon_LifeInfo_RE4[subParamName_3rd] = subParamValue_3rd
                                                                    end 
                                                                end
                                                                if subParamName_2nd == "MoveInfo" then
                                                                    for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                        Weapon_MoveInfo_RE4[subParamName_3rd] = subParamValue_3rd
                                                                    end 
                                                                end
                                                                if subParamName_2nd == "AttackInfo" then
                                                                    for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                        local Weapon_AttackInfo_DamageRate_RE4 = Weapon_AttackInfo_RE4._DamageRate
                                                                        local Weapon_AttackInfo_WinceRate_RE4 = Weapon_AttackInfo_RE4._WinceRate
                                                                        local Weapon_AttackInfo_BreakRate_RE4 = Weapon_AttackInfo_RE4._BreakRate
                                                                        local Weapon_AttackInfo_StoppingRate_RE4 = Weapon_AttackInfo_RE4._StoppingRate
                                                                        
                                                                        if subParamName_3rd == "_ColliderRadius" then
                                                                            Weapon_AttackInfo_RE4[subParamName_3rd] = subParamValue_3rd
                                                                        end

                                                                        if subParamName_3rd == "DamageRate" then
                                                                            for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                Weapon_AttackInfo_DamageRate_RE4[subParamName_4th] = subParamValue_4th
                                                                            end
                                                                        end
                                                                        if subParamName_3rd == "WinceRate" then
                                                                            for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                Weapon_AttackInfo_WinceRate_RE4[subParamName_4th] = subParamValue_4th
                                                                            end
                                                                        end
                                                                        if subParamName_3rd == "BreakRate" then
                                                                            for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                Weapon_AttackInfo_BreakRate_RE4[subParamName_4th] = subParamValue_4th
                                                                            end
                                                                        end
                                                                        if subParamName_3rd == "StoppingRate" then
                                                                            for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                Weapon_AttackInfo_StoppingRate_RE4[subParamName_4th] = subParamValue_4th
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if weapon.Type == "GL" then
                                                        local Weapon_RocketLauncherShellInfoUserData_RE4 = Weapon_ShellGenerator_UserData_RE4:get_field("_RocketLauncherShellInfoUserData")

                                                        if Weapon_RocketLauncherShellInfoUserData_RE4 then
                                                            local Weapon_LifeInfo_RE4 = Weapon_RocketLauncherShellInfoUserData_RE4:get_field("_LifeInfo")
                                                            local Weapon_MoveInfo_RE4 = Weapon_RocketLauncherShellInfoUserData_RE4:get_field("_MoveInfo")
                                                            local Weapon_AttackInfo_RE4 = Weapon_RocketLauncherShellInfoUserData_RE4:get_field("_AttackInfo")

                                                            if subParamName_2nd == "LifeInfo" then
                                                                for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                    Weapon_LifeInfo_RE4[subParamName_3rd] = subParamValue_3rd
                                                                end 
                                                            end
                                                            if subParamName_2nd == "MoveInfo" then
                                                                for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                    Weapon_MoveInfo_RE4[subParamName_3rd] = subParamValue_3rd
                                                                end 
                                                            end
                                                            if subParamName_2nd == "AttackInfo" then
                                                                for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                    local Weapon_AttackInfo_DamageRate_RE4 = Weapon_AttackInfo_RE4:get_field("_DamageRate")
                                                                    local Weapon_AttackInfo_WinceRate_RE4 = Weapon_AttackInfo_RE4:get_field("_WinceRate")
                                                                    local Weapon_AttackInfo_BreakRate_RE4 = Weapon_AttackInfo_RE4:get_field("_BreakRate")
                                                                    local Weapon_AttackInfo_StoppingRate_RE4 = Weapon_AttackInfo_RE4:get_field("_StoppingRate")
                                                                    
                                                                    if subParamName_3rd == "_ColliderRadius" then
                                                                        Weapon_AttackInfo_RE4[subParamName_3rd] = subParamValue_3rd
                                                                    end

                                                                    if subParamName_3rd == "DamageRate" then
                                                                        for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                            Weapon_AttackInfo_DamageRate_RE4[subParamName_4th] = subParamValue_4th
                                                                        end
                                                                    end
                                                                    if subParamName_3rd == "WinceRate" then
                                                                        for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                            Weapon_AttackInfo_WinceRate_RE4[subParamName_4th] = subParamValue_4th
                                                                        end
                                                                    end
                                                                    if subParamName_3rd == "BreakRate" then
                                                                        for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                            Weapon_AttackInfo_BreakRate_RE4[subParamName_4th] = subParamValue_4th
                                                                        end
                                                                    end
                                                                    if subParamName_3rd == "StoppingRate" then
                                                                        for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                            Weapon_AttackInfo_StoppingRate_RE4[subParamName_4th] = subParamValue_4th
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if weapon.Type == "XBOW" then
                                                        local Weapon_ShellGenerator_ArrowUserData_RE4 = Weapon_ShellGenerator_RE4:get_field("_ArrowBombShellGeneratorUserData")

                                                        if Weapon_ShellGenerator_ArrowUserData_RE4 then
                                                            if subParamName_2nd == "Arrow" then
                                                                for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                    Weapon_ShellGenerator_ArrowUserData_RE4[subParamName_3rd] = subParamValue_3rd
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                        if subParamName == "WeaponStructureParam" then
                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do                         
                                                local Weapon_WeaponStructureParam_RE4 = Weapon_Stats_RE4:get_field("WeaponStructureParam")
                                                Weapon_WeaponStructureParam_RE4[subParamName_2nd] = subParamValue_2nd
                                            end
                                        end
                                        if subParamName == "ThinkPlayerParam" then
                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                local Weapon_ThinkPlayerParam_RE4 = Weapon_Stats_RE4:get_field("<ThinkPlayerParam>k__BackingField")
                                                Weapon_ThinkPlayerParam_RE4[subParamName_2nd] = subParamValue_2nd
                                            end
                                        end
                                        if subParamName == "ReticleFitParam" then
                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                local Weapon_ReticleFitParam_RE4 = Weapon_Stats_RE4:get_field("<ReticleFitParam>k__BackingField")

                                                if subParamName_2nd ~= "PointRange" then
                                                    Weapon_ReticleFitParam_RE4[subParamName_2nd] = subParamValue_2nd
                                                end
                                                if subParamName_2nd == "PointRange" then
                                                    for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                        local Weapon_ReticleFitParamRange_RE4 = Weapon_ReticleFitParam_RE4:get_field("_PointRange")

                                                        Weapon_ReticleFitParamRange_RE4[subParamName_3rd] = subParamValue_3rd
                                                        func.write_valuetype(Weapon_ReticleFitParam_RE4, 0x10, Weapon_ReticleFitParamRange_RE4)
                                                    end
                                                end
                                            end
                                        end
                                    elseif weapon.Type == "KNF" then
                                        if subParamName == "MeleeParam" then
                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                local Weapon_MeleeParam_RE4 = Weapon_Stats_RE4:get_field("_MeleeParam")

                                                if Weapon_MeleeParam_RE4 then
                                                    local Weapon_MeleeAttackInfo_RE4 = Weapon_MeleeParam_RE4._AttackTypeInfoTable

                                                    for i, attackTypes in pairs(Weapon_MeleeAttackInfo_RE4) do
                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                            if i == 0 and subParamName_3rd == "Combat" then
                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                    Weapon_MeleeAttackInfo_RE4[i][subParamName_4th] = subParamValue_4th
                                                                end                                                                
                                                            end
                                                            if i == 1 and subParamName_3rd == "CombatCombo" then
                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                    Weapon_MeleeAttackInfo_RE4[i][subParamName_4th] = subParamValue_4th
                                                                end                                                                
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                        if subParamName == "ThinkPlayerParam" then
                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                local Weapon_ThinkPlayerParam_RE4 = Weapon_Stats_RE4:get_field("<ThinkPlayerParam>k__BackingField")
                                                Weapon_ThinkPlayerParam_RE4[subParamName_2nd] = subParamValue_2nd
                                            end
                                        end
                                        if subParamName == "ReticleFitParam" then
                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                local Weapon_ReticleFitParam_RE4 = Weapon_Stats_RE4:get_field("<ReticleFitParam>k__BackingField")

                                                if subParamName_2nd ~= "PointRange" then
                                                    Weapon_ReticleFitParam_RE4[subParamName_2nd] = subParamValue_2nd
                                                end
                                                if subParamName_2nd == "PointRange" then
                                                    for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                        local Weapon_ReticleFitParamRange_RE4 = Weapon_ReticleFitParam_RE4:get_field("_PointRange")

                                                        Weapon_ReticleFitParamRange_RE4[subParamName_3rd] = subParamValue_3rd
                                                        func.write_valuetype(Weapon_ReticleFitParam_RE4, 0x10, Weapon_ReticleFitParamRange_RE4)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if paramName == "LevelTracker" then
                                for subParamName, subParamValue in pairs(paramValue) do
                                    local Weapon_CustomLevel_RE4 = Weapon_Stats_RE4:get_field("<CustomLevelInWeapon>k__BackingField")

                                    if Weapon_CustomLevel_RE4 then
                                        local Weapon_CustomLevel_Common_RE4 = Weapon_CustomLevel_RE4:get_field("_CommonLevelInWeapon")
                                        local Weapon_CustomLevel_Common_items_RE4 = Weapon_CustomLevel_Common_RE4:get_field("_items")

                                        for i in pairs(Weapon_CustomLevel_Common_items_RE4) do   
                                            if i == 0 and weapon.Type ~= "GL" and weapon.ID ~= "wp6304" and weapon.Type ~= "THRW" then
                                                weaponParams[paramName].CurrentLevel.DMG = Weapon_CustomLevel_Common_items_RE4[0]:get_field("_DamageRateLevel") + 1
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
        weapon.isUpdated = false
        
        if weapon.isCatalogUpdated then
            currentGameMode = "Main"
            local Weapon_WeaponCatalog_RE4 = scene:call("findGameObject(System.String)", RE4_Cache.weaponCatalog)

            if not Weapon_WeaponCatalog_RE4 then
                Weapon_WeaponCatalog_RE4 = scene:call("findGameObject(System.String)", RE4_Cache.weaponCatalog_AO)
                currentGameMode = "SW"
            end

            if not Weapon_WeaponCatalog_RE4 then
                if weapon.ID == "wp6300_MC" then
                    Weapon_WeaponCatalog_RE4 = scene:call("findGameObject(System.String)", RE4_Cache.weaponCatalog_MC2)
                else
                    Weapon_WeaponCatalog_RE4 = scene:call("findGameObject(System.String)", RE4_Cache.weaponCatalog_MC)
                end
                currentGameMode = "Mercs"
            end

            if Weapon_WeaponCatalog_RE4 then
                local Weapon_WeaponCatalogRegister_RE4 = Weapon_WeaponCatalog_RE4:call("getComponent(System.Type)", RE4_Cache.weaponCatalogRegister)

                if Weapon_WeaponCatalogRegister_RE4 then
                    local Weapon_WeaponCatalog_EquipParamCatalogUserData_RE4 = Weapon_WeaponCatalogRegister_RE4:get_field("_WeaponEquipParamCatalogUserData")

                    if Weapon_WeaponCatalog_EquipParamCatalogUserData_RE4 then
                        local Weapon_WeaponCatalog_DataTable_RE4 = Weapon_WeaponCatalog_EquipParamCatalogUserData_RE4:get_field("_DataTable")
                        Weapon_WeaponCatalog_DataTable_RE4 = Weapon_WeaponCatalog_DataTable_RE4 and Weapon_WeaponCatalog_DataTable_RE4:get_elements() or {}

                        for i in pairs(Weapon_WeaponCatalog_DataTable_RE4) do
                            local Weapon_WeaponCatalog_DataTable_Data_RE4 = Weapon_WeaponCatalog_DataTable_RE4[i]:get_field("_WeaponID")

                            if Weapon_WeaponCatalog_DataTable_Data_RE4 == weapon.Enum and currentGameMode == weapon.Game then
                                if AWF_tool_settings.isDebug then
                                    log.info("[AWF] [ " .. weapon.ID .. " Catalog data updated.]")
                                end
                                local weaponParams = AWF_settings.RE4.Weapon_Params[weapon.ID]
                                
                                for paramName, paramValue in pairs(weaponParams) do
                                    if paramName == "Catalog" then
                                        for subParamName, subParamValue in pairs(paramValue) do
                                            if subParamName == "ReticleFitParamTable" then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    local Weapon_WeaponCatalog_ReticleFitParamTable_RE4 = Weapon_WeaponCatalog_DataTable_RE4[i]:get_field("_ReticleFitParamTable")
                                                    Weapon_WeaponCatalog_ReticleFitParamTable_RE4[subParamName_2nd] = subParamValue_2nd

                                                    if AWF_tool_settings.isHideReticle then
                                                        Weapon_WeaponCatalog_ReticleFitParamTable_RE4[subParamName_2nd] = 100000
                                                    end
                                                end
                                            end                                            
                                            if subParamName == "CameraRecoilParam" then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    local Weapon_WeaponCatalog_CameraRecoilParam_RE4 = Weapon_WeaponCatalog_DataTable_RE4[i]:get_field("_CameraRecoilParam")

                                                    if not subParamName_2nd:match("Deg$") then
                                                        Weapon_WeaponCatalog_CameraRecoilParam_RE4[subParamName_2nd] = subParamValue_2nd
                                                    end
                                                    if subParamName_2nd == "YawRangeDeg" then
                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                            local Weapon_WeaponCatalog_CameraRecoilParam_Yaw_RE4 = Weapon_WeaponCatalog_CameraRecoilParam_RE4:get_field("_YawRangeDeg")
                                                            Weapon_WeaponCatalog_CameraRecoilParam_Yaw_RE4[subParamName_3rd] = subParamValue_3rd
                                                            func.write_valuetype(Weapon_WeaponCatalog_CameraRecoilParam_RE4, 0x18, Weapon_WeaponCatalog_CameraRecoilParam_Yaw_RE4)
                                                        end
                                                    end
                                                    if subParamName_2nd == "PitchRangeDeg" then
                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                            local Weapon_WeaponCatalog_CameraRecoilParam_Pitch_RE4 = Weapon_WeaponCatalog_CameraRecoilParam_RE4:get_field("_PitchRangeDeg")
                                                            Weapon_WeaponCatalog_CameraRecoilParam_Pitch_RE4[subParamName_3rd] = subParamValue_3rd
                                                            func.write_valuetype(Weapon_WeaponCatalog_CameraRecoilParam_RE4, 0x20, Weapon_WeaponCatalog_CameraRecoilParam_Pitch_RE4)
                                                        end
                                                    end
                                                end
                                            end
                                            if subParamName == "CameraShakeParam" then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    local Weapon_WeaponCatalog_CameraShakeParam_RE4 = Weapon_WeaponCatalog_DataTable_RE4[i]:get_field("_CameraShakeParam")

                                                    if subParamName_2nd == "_Type" then
                                                        Weapon_WeaponCatalog_CameraShakeParam_RE4[subParamName_2nd] = subParamValue_2nd
                                                    end
                                                    if subParamName_2nd == "Life" then
                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                            local Weapon_WeaponCatalog_CameraShakeParam_Life_RE4 = Weapon_WeaponCatalog_CameraShakeParam_RE4:get_field("_Life")
                                                            Weapon_WeaponCatalog_CameraShakeParam_Life_RE4[subParamName_3rd] = subParamValue_3rd
                                                        end
                                                    end
                                                    if subParamName_2nd == "Move" then
                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                            local Weapon_WeaponCatalog_CameraShakeParam_Move_RE4 = Weapon_WeaponCatalog_CameraShakeParam_RE4:get_field("_Move")

                                                            if subParamName_3rd == "Period" then
                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_Period_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_Period")
                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_Period_RE4[subParamName_4th] = subParamValue_4th
                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x10, Weapon_WeaponCatalog_CameraShakeParam_Move_Period_RE4)
                                                                end
                                                            end
                                                            if subParamName_3rd == "TranslationXRange" then
                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_TransX_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_TranslationXRange")
                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_TransX_RE4[subParamName_4th] = subParamValue_4th
                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x18, Weapon_WeaponCatalog_CameraShakeParam_Move_TransX_RE4)
                                                                end
                                                            end
                                                            if subParamName_3rd == "TranslationYRange" then
                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_TransY_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_TranslationYRange")
                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_TransY_RE4[subParamName_4th] = subParamValue_4th
                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x20, Weapon_WeaponCatalog_CameraShakeParam_Move_TransY_RE4)
                                                                end
                                                            end
                                                            if subParamName_3rd == "TranslationZRange" then
                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_TransZ_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_TranslationZRange")
                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_TransZ_RE4[subParamName_4th] = subParamValue_4th
                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x28, Weapon_WeaponCatalog_CameraShakeParam_Move_TransZ_RE4)
                                                                end
                                                            end
                                                            if subParamName_3rd == "RotationXRange" then
                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_RotX_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_RotationXRange")
                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_RotX_RE4[subParamName_4th] = subParamValue_4th
                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x30, Weapon_WeaponCatalog_CameraShakeParam_Move_RotX_RE4)
                                                                end
                                                            end
                                                            if subParamName_3rd == "RotationYRange" then
                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_RotY_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_RotationYRange")
                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_RotY_RE4[subParamName_4th] = subParamValue_4th
                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x38, Weapon_WeaponCatalog_CameraShakeParam_Move_RotY_RE4)
                                                                end
                                                            end
                                                            if subParamName_3rd == "RotationZRange" then
                                                                for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_RotZ_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_RotationZRange")
                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_RotZ_RE4[subParamName_4th] = subParamValue_4th
                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x40, Weapon_WeaponCatalog_CameraShakeParam_Move_RotZ_RE4)
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            if subParamName == "ScopeParam" then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    local Weapon_WeaponCatalog_ScopeParam_RE4 = Weapon_WeaponCatalog_DataTable_RE4[i]:get_field("_ScopeParam")
                                                    Weapon_WeaponCatalog_ScopeParam_RE4[subParamName_2nd] = subParamValue_2nd
                                                end
                                            end
                                            if subParamName == "HandShakeParam" then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    local Weapon_WeaponCatalog_HandShakeParam_RE4 = Weapon_WeaponCatalog_DataTable_RE4[i]:get_field("_HandShakeParam")
                                                    Weapon_WeaponCatalog_HandShakeParam_RE4[subParamName_2nd] = subParamValue_2nd
                                                end
                                            end
                                            -- For some dumb reason the DualSense features are disabled on PC. I'll probably look into this one day | TODO | 03/11/2024
                                            -- if subParamName == "AdaptiveFeedBackParam" then
                                            --     for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                            --         local Weapon_WeaponCatalog_AdaptiveFeedBackParam_RE4 = Weapon_WeaponCatalog_DataTable_RE4[i]:get_field("_AdaptiveFeedBackParam")
                                            --         local Weapon_WeaponCatalog_AdaptiveFeedBack_Data_RE4 = Weapon_WeaponCatalog_AdaptiveFeedBackParam_RE4:get_field("_Data")
                                                    
                                            --         if subParamName_2nd == "Left" then
                                            --             local Weapon_WeaponCatalog_AdaptiveFeedBack_Left_RE4 = Weapon_WeaponCatalog_AdaptiveFeedBack_Data_RE4:get_field("_Left")
                                                        
                                            --             for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                            --                 if subParamName_3rd ~= "Range" then
                                            --                     Weapon_WeaponCatalog_AdaptiveFeedBack_Left_RE4[subParamName_3rd] = subParamValue_3rd
                                            --                 end
                                            --                 if subParamName_3rd == "Range" then
                                            --                     for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                            --                         local Weapon_WeaponCatalog_AdaptiveFeedBack_LeftRange_RE4 = Weapon_WeaponCatalog_AdaptiveFeedBack_Left_RE4:get_field("_Range")
                                            --                         Weapon_WeaponCatalog_AdaptiveFeedBack_LeftRange_RE4[subParamName_4th] = subParamValue_4th
                                            --                         func.write_valuetype(Weapon_WeaponCatalog_AdaptiveFeedBack_Left_RE4, 0x18, Weapon_WeaponCatalog_AdaptiveFeedBack_LeftRange_RE4)
                                            --                     end
                                            --                 end
                                            --             end 
                                            --         end
                                            --         if subParamName_2nd == "Right" then
                                            --             local Weapon_WeaponCatalog_AdaptiveFeedBack_Right_RE4 = Weapon_WeaponCatalog_AdaptiveFeedBack_Data_RE4:get_field("_Right")
                                                        
                                            --             for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                            --                 if subParamName_3rd ~= "Range" then
                                            --                     Weapon_WeaponCatalog_AdaptiveFeedBack_Right_RE4[subParamName_3rd] = subParamValue_3rd
                                            --                 end
                                            --                 if subParamName_3rd == "Range" then
                                            --                     for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                            --                         local Weapon_WeaponCatalog_AdaptiveFeedBack_RightRange_RE4 = Weapon_WeaponCatalog_AdaptiveFeedBack_Right_RE4:get_field("_Range")
                                            --                         Weapon_WeaponCatalog_AdaptiveFeedBack_RightRange_RE4[subParamName_4th] = subParamValue_4th
                                            --                         func.write_valuetype(Weapon_WeaponCatalog_AdaptiveFeedBack_Right_RE4, 0x18, Weapon_WeaponCatalog_AdaptiveFeedBack_RightRange_RE4)
                                            --                     end
                                            --                 end
                                            --             end 
                                            --         end
                                            --     end
                                            -- end
                                            if subParamName == "KnifeCombatSpeedParam" then
                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                    local Weapon_WeaponCatalog_KnifeCombatSpeedParam_RE4 = Weapon_WeaponCatalog_DataTable_RE4[i]:get_field("_knifeCombatSpeedParam")
                                                    Weapon_WeaponCatalog_KnifeCombatSpeedParam_RE4[subParamName_2nd] = subParamValue_2nd
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
        weapon.isCatalogUpdated = false

        if weapon.isCustomCatalogUpdated then
            currentGameMode = "Main"
            local Weapon_WeaponCustomCatalog_RE4 = scene:call("findGameObject(System.String)", RE4_Cache.weaponCustomCatalog)

            if not Weapon_WeaponCustomCatalog_RE4 then
                Weapon_WeaponCustomCatalog_RE4 = scene:call("findGameObject(System.String)", RE4_Cache.weaponCustomCatalog_AO)
                currentGameMode = "SW"
            end

            if not Weapon_WeaponCustomCatalog_RE4 then
                Weapon_WeaponCustomCatalog_RE4 = scene:call("findGameObject(System.String)", RE4_Cache.weaponCustomCatalog_MC)
                currentGameMode = "Mercs"
            end

            if Weapon_WeaponCustomCatalog_RE4 then
                local Weapon_WeaponCustomCatalogRegister_RE4 = Weapon_WeaponCustomCatalog_RE4:call("getComponent(System.Type)", RE4_Cache.weaponCustomCatalogRegister)

                if Weapon_WeaponCustomCatalogRegister_RE4 then
                    local weaponParams = AWF_settings.RE4.Weapon_Params[weapon.ID]
                    local Weapon_WeaponCustomCatalog_UserData_RE4 = Weapon_WeaponCustomCatalogRegister_RE4:get_field("_WeaponCustomUserdata")
                    local Weapon_WeaponDetailCustomCatalog_UserData_RE4 = Weapon_WeaponCustomCatalogRegister_RE4:get_field("_WeaponDetailCustomUserdata")
                    
                    for paramName, paramValue in pairs(weaponParams) do
                        if paramName == "CustomCatalog" then                            
                            if Weapon_WeaponCustomCatalog_UserData_RE4 then
                                local Weapon_WeaponCustomCatalog_UserData_WeaponStages_RE4 = Weapon_WeaponCustomCatalog_UserData_RE4:get_field("_WeaponStages")
                                Weapon_WeaponCustomCatalog_UserData_WeaponStages_RE4 = Weapon_WeaponCustomCatalog_UserData_WeaponStages_RE4 and Weapon_WeaponCustomCatalog_UserData_WeaponStages_RE4:get_elements() or {}

                                for i in pairs(Weapon_WeaponCustomCatalog_UserData_WeaponStages_RE4) do
                                    local Weapon_WeaponCustomCatalog_UserData_Weapons_RE4 = Weapon_WeaponCustomCatalog_UserData_WeaponStages_RE4[i]:get_field("_WeaponID")

                                    if Weapon_WeaponCustomCatalog_UserData_Weapons_RE4 == weapon.Enum and currentGameMode == weapon.Game then
                                        if AWF_tool_settings.isDebug then
                                            log.info("[AWF] [ " .. weapon.ID .. " Custom Catalog data updated.]")
                                        end
                                        local Weapon_WeaponCustomCatalog_UserData_WeaponsCustom_RE4 = Weapon_WeaponCustomCatalog_UserData_WeaponStages_RE4[i]:get_field("_WeaponCustom")

                                        if Weapon_WeaponCustomCatalog_UserData_WeaponsCustom_RE4 then
                                            for subParamName, subParamValue in pairs(paramValue) do
                                                local CommonsMap = {"_CustomAttackUp", "_CustomAmmoMaxUp"}
                                                local Weapon_WeaponCustomCatalog_UserData_Commons_RE4 = Weapon_WeaponCustomCatalog_UserData_WeaponsCustom_RE4:get_field("_Commons")
                                                Weapon_WeaponCustomCatalog_UserData_Commons_RE4 = Weapon_WeaponCustomCatalog_UserData_Commons_RE4 and Weapon_WeaponCustomCatalog_UserData_Commons_RE4:get_elements() or {}
                                                
                                                local IndividualsMap = {"_CustomReloadSpeed", "_CustomRapid", "_CustomStrength"}
                                                local Weapon_WeaponCustomCatalog_UserData_Individuals_RE4 = Weapon_WeaponCustomCatalog_UserData_WeaponsCustom_RE4:get_field("_Individuals")
                                                Weapon_WeaponCustomCatalog_UserData_Individuals_RE4 = Weapon_WeaponCustomCatalog_UserData_Individuals_RE4 and Weapon_WeaponCustomCatalog_UserData_Individuals_RE4:get_elements() or {}

                                                local LimitBreakMap = {"_CustomLimitBreak"}
                                                local Weapon_WeaponCustomCatalog_UserData_LimitBreak_RE4 = Weapon_WeaponCustomCatalog_UserData_WeaponsCustom_RE4:get_field("_LimitBreak")
                                                Weapon_WeaponCustomCatalog_UserData_LimitBreak_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreak_RE4 and Weapon_WeaponCustomCatalog_UserData_LimitBreak_RE4:get_elements() or {}

                                                for j, field in ipairs(CommonsMap) do
                                                    if Weapon_WeaponCustomCatalog_UserData_Commons_RE4[j] then
                                                        local Weapon_WeaponCustomCatalog_UserData_Commons_Field_RE4 = Weapon_WeaponCustomCatalog_UserData_Commons_RE4[j]:get_field(field)

                                                        if Weapon_WeaponCustomCatalog_UserData_Commons_Field_RE4 then
                                                            local customStagesField = field == "_CustomAttackUp" and "_AttackUpCustomStages" or "_AmmoMaxUpCustomStages"
                                                            local Weapon_WeaponCustomCatalog_UserData_Commons_Field_CustomStages_RE4 = Weapon_WeaponCustomCatalog_UserData_Commons_Field_RE4:get_field(customStagesField)
                                                            Weapon_WeaponCustomCatalog_UserData_Commons_Field_CustomStages_RE4 = Weapon_WeaponCustomCatalog_UserData_Commons_Field_CustomStages_RE4 and Weapon_WeaponCustomCatalog_UserData_Commons_Field_CustomStages_RE4:get_elements() or {}

                                                            for k, stage in ipairs(Weapon_WeaponCustomCatalog_UserData_Commons_Field_CustomStages_RE4) do
                                                                if subParamName:match("^Level_([1-9]%d*)$") then
                                                                    local v = subParamName:match("%d+$")
                                                                    local subParamMap = {[1] = "LVL" .. v .."_DMG", [2] = "LVL" .. v .."_AC"}
                                                                    local subParamName_2nd = subParamMap[j]
                                                                    
                                                                    if subParamName_2nd and tonumber(v) == k then
                                                                        for subParam, subParamValue_2nd in pairs(subParamValue) do
                                                                            if subParam == subParamName_2nd then
                                                                                for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                    if subParamName_3rd == "_Cost" then
                                                                                        stage[subParamName_3rd] = subParamValue_3rd
                                                                                    end
                                                                                    if subParamName_3rd == "_Info" then
                                                                                        if subParamName_2nd == subParamMap[1] then
                                                                                            if tonumber(v) == 1 then
                                                                                                if weapon.Type ~= "KNF" then
                                                                                                    if weapon.Type ~= "SG" then
                                                                                                        stage[subParamName_3rd] = tostring(string.format("%.2f", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_1.LVL1_DMG._BaseValue * AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo.DamageRate._BaseValue))
                                                                                                        weaponParams[paramName][subParamName]["LVL" .. v .."_DMG"]._Info = stage[subParamName_3rd]
                                                                                                    end
                                                                                                    if weapon.Type == "SG" then
                                                                                                        stage[subParamName_3rd] = tostring(string.format("%.2f", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_1.LVL1_DMG._BaseValue * AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo.DamageRate._BaseValue))
                                                                                                        weaponParams[paramName][subParamName]["LVL" .. v .."_DMG"]._Info = stage[subParamName_3rd]
                                                                                                    end
                                                                                                elseif weapon.Type == "KNF" then
                                                                                                    stage[subParamName_3rd] = tostring(string.format("%.2f", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_1.LVL1_DMG._Info))
                                                                                                    weaponParams[paramName][subParamName]["LVL" .. v .."_DMG"]._Info = stage[subParamName_3rd]
                                                                                                end
                                                                                            end
                                                                                            if tonumber(v) > 1 then
                                                                                                if weapon.Type ~= "KNF" then
                                                                                                    stage[subParamName_3rd] = tostring(string.format("%.2f", (AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_1.LVL1_DMG._Info * weaponParams[paramName][subParamName]["LVL" .. v .."_DMG"]._BaseValue)))
                                                                                                    weaponParams[paramName][subParamName]["LVL" .. v .."_DMG"]._Info = stage[subParamName_3rd]
                                                                                                elseif weapon.Type == "KNF" then
                                                                                                    stage[subParamName_3rd] = tostring(string.format("%.2f", (weaponParams[paramName][subParamName]["LVL" .. v .."_DMG"]._BaseValue / 2)))
                                                                                                    weaponParams[paramName][subParamName]["LVL" .. v .."_DMG"]._Info = stage[subParamName_3rd]
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                        if subParamName_2nd == subParamMap[2] then
                                                                                            stage[subParamName_3rd] = subParamValue_3rd
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
                                                
                                                for h, field in ipairs(IndividualsMap) do                                                    
                                                    if Weapon_WeaponCustomCatalog_UserData_Individuals_RE4[h] then
                                                        local Weapon_WeaponCustomCatalog_UserData_Individuals_Field_RE4 = Weapon_WeaponCustomCatalog_UserData_Individuals_RE4[h]:get_field(field)

                                                        if Weapon_WeaponCustomCatalog_UserData_Individuals_Field_RE4 then
                                                            local customStagesField
                                                            if field == "_CustomReloadSpeed" then
                                                                customStagesField = "_ReloadSpeedCustomStages"
                                                            elseif field == "_CustomRapid" then
                                                                customStagesField = "_RapidCustomStages"
                                                            elseif field == "_CustomStrength" then
                                                                customStagesField = "_StrengthCustomStages"
                                                            end
                                                            local Weapon_WeaponCustomCatalog_UserData_Individuals_Field_CustomStages_RE4 = Weapon_WeaponCustomCatalog_UserData_Individuals_Field_RE4:get_field(customStagesField)
                                                            Weapon_WeaponCustomCatalog_UserData_Individuals_Field_CustomStages_RE4 = Weapon_WeaponCustomCatalog_UserData_Individuals_Field_CustomStages_RE4 and Weapon_WeaponCustomCatalog_UserData_Individuals_Field_CustomStages_RE4:get_elements() or {}

                                                            for k, stage in ipairs(Weapon_WeaponCustomCatalog_UserData_Individuals_Field_CustomStages_RE4) do
                                                                if subParamName:match("^Level_([1-9]%d*)$") then
                                                                    local v = subParamName:match("%d+$")
                                                                    local subParamMap = {[1] = "LVL" .. v .."_RS", [2] = "LVL" .. v .."_ROF", [3] = "LVL" .. v .. "_DUR"}
                                                                    local subParamName_2nd = subParamMap[h]
                                                                    
                                                                    if subParamName_2nd and tonumber(v) == k then
                                                                        for subParam, subParamValue_2nd in pairs(subParamValue) do
                                                                            if subParam == subParamName_2nd then
                                                                                for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                    if subParamName_3rd == "_Cost" then
                                                                                        stage[subParamName_3rd] = subParamValue_3rd
                                                                                    end
                                                                                    if subParamName_3rd == "_Info" then                                                                     
                                                                                        if subParamName_2nd == subParamMap[1] then
                                                                                            stage[subParamName_3rd] = subParamValue_3rd
                                                                                        end
                                                                                        if subParamName_2nd == subParamMap[2] then
                                                                                            stage[subParamName_3rd] = subParamValue_3rd
                                                                                        end
                                                                                        if subParamName_2nd == subParamMap[3] then
                                                                                            stage[subParamName_3rd] = tostring(string.format("%.2f", (weaponParams[paramName][subParamName]["LVL" .. v .."_DUR"]._BaseValue / 1000)))
                                                                                            weaponParams[paramName][subParamName]["LVL" .. v .."_DUR"]._Info = stage[subParamName_3rd]
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
                                                for s, field in ipairs(LimitBreakMap) do
                                                    if Weapon_WeaponCustomCatalog_UserData_LimitBreak_RE4[s] then
                                                        local Weapon_WeaponCustomCatalog_UserData_LimitBreak_Field_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreak_RE4[s]:get_field(field)

                                                        if Weapon_WeaponCustomCatalog_UserData_LimitBreak_Field_RE4 then
                                                            local customStagesField = field == "_CustomLimitBreak" and "_LimitBreakCustomStages"
                                                            local Weapon_WeaponCustomCatalog_UserData_LimitBreak_Field_CustomStages_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreak_Field_RE4:get_field(customStagesField)
                                                            Weapon_WeaponCustomCatalog_UserData_LimitBreak_Field_CustomStages_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreak_Field_CustomStages_RE4 and Weapon_WeaponCustomCatalog_UserData_LimitBreak_Field_CustomStages_RE4:get_elements() or {}

                                                            for k, stage in ipairs(Weapon_WeaponCustomCatalog_UserData_LimitBreak_Field_CustomStages_RE4) do
                                                                if subParamName:match("Level_EX") then
                                                                    for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            if (subParamName_3rd == "_Cost") or (subParamName_3rd == "_Info") then
                                                                                stage[subParamName_3rd] = subParamValue_3rd
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
                            end

                            if Weapon_WeaponDetailCustomCatalog_UserData_RE4 then
                                local Weapon_WeaponCustomCatalog_UserData_WeaponDetailStages_RE4 = Weapon_WeaponDetailCustomCatalog_UserData_RE4:get_field("_WeaponDetailStages")
                                Weapon_WeaponCustomCatalog_UserData_WeaponDetailStages_RE4 = Weapon_WeaponCustomCatalog_UserData_WeaponDetailStages_RE4 and Weapon_WeaponCustomCatalog_UserData_WeaponDetailStages_RE4:get_elements() or {}

                                for i in pairs(Weapon_WeaponCustomCatalog_UserData_WeaponDetailStages_RE4) do
                                    local Weapon_WeaponCustomCatalog_UserData_WeaponsDetail_RE4 = Weapon_WeaponCustomCatalog_UserData_WeaponDetailStages_RE4[i]:get_field("_WeaponID")

                                    if Weapon_WeaponCustomCatalog_UserData_WeaponsDetail_RE4 == weapon.Enum then                                        
                                        local Weapon_WeaponCustomCatalog_UserData_WeaponsDetailCustom_RE4 = Weapon_WeaponCustomCatalog_UserData_WeaponDetailStages_RE4[i]:get_field("_WeaponDetailCustom")

                                        if Weapon_WeaponCustomCatalog_UserData_WeaponsDetailCustom_RE4 then
                                            for subParamName, subParamValue in pairs(paramValue) do
                                                local Weapon_WeaponCustomCatalog_UserData_CommonsCustom_RE4 = Weapon_WeaponCustomCatalog_UserData_WeaponsDetailCustom_RE4:get_field("_CommonCustoms")
                                                local Weapon_WeaponCustomCatalog_UserData_IndividualCustom_RE4 = Weapon_WeaponCustomCatalog_UserData_WeaponsDetailCustom_RE4:get_field("_IndividualCustoms")
                                                local Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_RE4 = Weapon_WeaponCustomCatalog_UserData_WeaponsDetailCustom_RE4:get_field("_LimitBreakCustoms")
                                                local Weapon_WeaponCustomCatalog_UserData_AttachmentCustom_RE4 = Weapon_WeaponCustomCatalog_UserData_WeaponsDetailCustom_RE4:get_field("_AttachmentCustoms")

                                                for j in pairs(Weapon_WeaponCustomCatalog_UserData_CommonsCustom_RE4) do
                                                    local Weapon_WeaponCustomCatalog_UserData_CommmonCustom_Category_RE4 = Weapon_WeaponCustomCatalog_UserData_CommonsCustom_RE4[j]:get_field("_CommonCustomCategory")
                                                    
                                                    if Weapon_WeaponCustomCatalog_UserData_CommmonCustom_Category_RE4 then
                                                        if Weapon_WeaponCustomCatalog_UserData_CommmonCustom_Category_RE4 == 0 then
                                                            local Weapon_WeaponCustomCatalog_UserData_CommonsCustomAttackUp_RE4 = Weapon_WeaponCustomCatalog_UserData_CommonsCustom_RE4[j]:get_field("_AttackUp")
                                                        
                                                            if Weapon_WeaponCustomCatalog_UserData_CommonsCustomAttackUp_RE4 then
                                                                local rateTypes = {
                                                                    ["_DamageRates"] = {suffix = "_DMG", multiplier = "DamageRate"},
                                                                    ["_WinceRates"] = {suffix = "_WIN", multiplier = "WinceRate"},
                                                                    ["_BreakRates"] = {suffix = "_BRK", multiplier = "BreakRate"},
                                                                    ["_StoppingRates"] = {suffix = "_STP", multiplier = "StoppingRate"}
                                                                }
                                                            
                                                                for rateType, rateInfo in pairs(rateTypes) do
                                                                    local ratesTable = Weapon_WeaponCustomCatalog_UserData_CommonsCustomAttackUp_RE4:get_field(rateType)
                                                                    ratesTable = ratesTable and ratesTable:get_elements() or {}
                                                            
                                                                    for k in pairs(ratesTable) do
                                                                        if subParamName:match("^Level_([1-9]%d*)$") then
                                                                            local v = subParamName:match("%d+$")
                                                                            local subParamName_2nd = "LVL" .. v .. rateInfo.suffix
                                                            
                                                                            if tonumber(v) == k then
                                                                                for subParam, subParamValue_2nd in pairs(subParamValue) do
                                                                                    if subParam == subParamName_2nd then
                                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                            if subParamName_3rd == "_BaseValue" then
                                                                                                if weapon.Type ~= "KNF" then
                                                                                                    if weapon.Type ~= "SG" then
                                                                                                        ratesTable[k][subParamName_3rd] = subParamValue_3rd * AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo[rateInfo.multiplier]._BaseValue
                                                                                                    elseif weapon.Type == "SG" then
                                                                                                        ratesTable[k][subParamName_3rd] = subParamValue_3rd * AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo[rateInfo.multiplier]._BaseValue
                                                                                                    end
                                                                                                elseif weapon.Type == "KNF" then
                                                                                                    ratesTable[k][subParamName_3rd] = subParamValue_3rd
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
                                                        if Weapon_WeaponCustomCatalog_UserData_CommmonCustom_Category_RE4 == 2 then 
                                                            local Weapon_WeaponCustomCatalog_UserData_CommonsCustomAmmoMaxUp_RE4 = Weapon_WeaponCustomCatalog_UserData_CommonsCustom_RE4[j]:get_field("_AmmoMaxUp")
                                                        
                                                            if Weapon_WeaponCustomCatalog_UserData_CommonsCustomAmmoMaxUp_RE4 then
                                                                local rateTypes = {
                                                                    ["_AmmoMaxs"] = "_AC",
                                                                }
                                                        
                                                                for rateType, subParamSuffix in pairs(rateTypes) do
                                                                    local ratesTable = Weapon_WeaponCustomCatalog_UserData_CommonsCustomAmmoMaxUp_RE4:get_field(rateType)
                                                        
                                                                    for k in pairs(ratesTable) do
                                                                        if subParamName:match("^Level_([1-9]%d*)$") then
                                                                            local v = subParamName:match("%d+$")
                                                                            local subParamName_2nd = "LVL" .. v .. subParamSuffix
                                                        
                                                                            if tonumber(v-1) == k then
                                                                                --log.info(subParamName_2nd .. "--" .. v .. "==" .. k) 
                                                                                for subParam, subParamValue_2nd in pairs(subParamValue) do
                                                                                    if subParam == subParamName_2nd then
                                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                            if subParamName_3rd == "_BaseValue" then
                                                                                                ratesTable[k] = subParamValue_3rd
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

                                                for j in pairs(Weapon_WeaponCustomCatalog_UserData_IndividualCustom_RE4) do
                                                    local Weapon_WeaponCustomCatalog_UserData_IndividualCustom_Category_RE4 = Weapon_WeaponCustomCatalog_UserData_IndividualCustom_RE4[j]:get_field("_IndividualCustomCategory")
                                                    
                                                    if Weapon_WeaponCustomCatalog_UserData_IndividualCustom_Category_RE4 == 6 then
                                                        local Weapon_WeaponCustomCatalog_UserData_IndividualCustom_Strength_RE4 = Weapon_WeaponCustomCatalog_UserData_IndividualCustom_RE4[j]:get_field("_Strength")

                                                        if Weapon_WeaponCustomCatalog_UserData_IndividualCustom_Strength_RE4 then
                                                            local rateTypes = {
                                                                ["_DurabilityMaxes"] = "_DUR",
                                                            }

                                                            for rateType, subParamSuffix in pairs(rateTypes) do
                                                                local ratesTable = Weapon_WeaponCustomCatalog_UserData_IndividualCustom_Strength_RE4:get_field(rateType)
                                                    
                                                                for k in pairs(ratesTable) do
                                                                    if subParamName:match("^Level_([1-9]%d*)$") then
                                                                        local v = subParamName:match("%d+$")
                                                                        local subParamName_2nd = "LVL" .. v .. subParamSuffix
                                                    
                                                                        if tonumber(v-1) == k then
                                                                            for subParam, subParamValue_2nd in pairs(subParamValue) do
                                                                                if subParam == subParamName_2nd then
                                                                                    for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                        if subParamName_3rd == "_BaseValue" then
                                                                                            ratesTable[k] = subParamValue_3rd
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

                                                    if Weapon_WeaponCustomCatalog_UserData_IndividualCustom_Category_RE4 == 7 then
                                                        local Weapon_WeaponCustomCatalog_UserData_IndividualCustom_ReloadSpeed_RE4 = Weapon_WeaponCustomCatalog_UserData_IndividualCustom_RE4[j]:get_field("_ReloadSpeed")
                                                        
                                                        if Weapon_WeaponCustomCatalog_UserData_IndividualCustom_ReloadSpeed_RE4 then
                                                            local rateTypes = {
                                                                ["_ReloadSpeedRates"] = "_RS",
                                                                ["_ReloadNums"] = "_RN",

                                                            }

                                                            for rateType, subParamSuffix in pairs(rateTypes) do
                                                                local ratesTable = Weapon_WeaponCustomCatalog_UserData_IndividualCustom_ReloadSpeed_RE4:get_field(rateType)
                                                    
                                                                for k in pairs(ratesTable) do
                                                                    if subParamName:match("^Level_([1-9]%d*)$") then
                                                                        local v = subParamName:match("%d+$")
                                                                        local subParamName_2nd = "LVL" .. v .. subParamSuffix
                                                    
                                                                        if tonumber(v-1) == k then
                                                                            --log.info(subParamName_2nd .. "--" .. v .. "==" .. k) 
                                                                            for subParam, subParamValue_2nd in pairs(subParamValue) do
                                                                                if subParam == subParamName_2nd then
                                                                                    for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                        if subParamName_3rd == "_BaseValue" then
                                                                                            ratesTable[k] = subParamValue_3rd
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
                                                    if Weapon_WeaponCustomCatalog_UserData_IndividualCustom_Category_RE4 == 8 then
                                                        local Weapon_WeaponCustomCatalog_UserData_IndividualCustom_Rapid_RE4 = Weapon_WeaponCustomCatalog_UserData_IndividualCustom_RE4[j]:get_field("_Rapid")
                                                        
                                                        if Weapon_WeaponCustomCatalog_UserData_IndividualCustom_Rapid_RE4 then
                                                            local rateTypes = {
                                                                ["_RapidSpeed"] = "_ROF",
                                                                ["_PumpActionRapidSpeed"] = "_PMP"
                                                            }

                                                            for rateType, subParamSuffix in pairs(rateTypes) do
                                                                local ratesTable = Weapon_WeaponCustomCatalog_UserData_IndividualCustom_Rapid_RE4:get_field(rateType)
                                                    
                                                                for k in pairs(ratesTable) do
                                                                    if subParamName:match("^Level_([1-9]%d*)$") then
                                                                        local v = subParamName:match("%d+$")
                                                                        local subParamName_2nd = "LVL" .. v .. subParamSuffix
                                                    
                                                                        if tonumber(v-1) == k then
                                                                            --log.info(subParamName_2nd .. "--" .. v .. "==" .. k) 
                                                                            for subParam, subParamValue_2nd in pairs(subParamValue) do
                                                                                if subParam == subParamName_2nd then
                                                                                    for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                        if subParamName_3rd == "_BaseValue" then
                                                                                            ratesTable[k] = subParamValue_3rd
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

                                                for j in pairs(Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_RE4) do
                                                    local Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Category_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_RE4[j]:get_field("_LimitBreakCustomCategory")

                                                    if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Category_RE4 == 0 then
                                                        local Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_CriticalRate_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_RE4[j]:get_field("_LimitBreakCriticalRate")

                                                        if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_CriticalRate_RE4 then
                                                            if subParamName:match("Level_EX") then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    if subParamName_2nd == "EXCRIT" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            if (subParamName_3rd == "_CriticalRateNormalScale") or (subParamName_3rd == "_CriticalRateFitScale") then
                                                                                Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_CriticalRate_RE4[subParamName_3rd] = subParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Category_RE4 == 1 then
                                                        local Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_AttackUp_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_RE4[j]:get_field("_LimitBreakAttackUp")

                                                        if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_AttackUp_RE4 then
                                                            if subParamName:match("Level_EX") then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    if subParamName_2nd == "EXDMG" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            if (subParamName_3rd == "_DamageRateScale") or (subParamName_3rd == "_WinceRateScale") or (subParamName_3rd == "_BreakRateScale") or (subParamName_3rd == "_StoppingRateScale") then
                                                                                Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_AttackUp_RE4[subParamName_3rd] = subParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Category_RE4 == 2 then
                                                        local Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_SGAttackUp_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_RE4[j]:get_field("_LimitBreakShotGunAroundAttackUp")

                                                        if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_SGAttackUp_RE4 then
                                                            if subParamName:match("Level_EX") then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    if subParamName_2nd == "EXDMGSG" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            if (subParamName_3rd == "_DamageRateScale") or (subParamName_3rd == "_WinceRateScale") or (subParamName_3rd == "_BreakRateScale") or (subParamName_3rd == "_StoppingRateScale") then
                                                                                Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_SGAttackUp_RE4[subParamName_3rd] = subParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Category_RE4 == 3 then
                                                        local Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_ThroughNum_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_RE4[j]:get_field("_LimitBreakThroughNum")

                                                        if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_ThroughNum_RE4 then
                                                            if subParamName:match("Level_EX") then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    if subParamName_2nd == "EXTHRU" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            if (subParamName_3rd == "_ThroughNumNormal") or (subParamName_3rd == "_ThroughNumFit") then
                                                                                Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_ThroughNum_RE4[subParamName_3rd] = subParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Category_RE4 == 4 then
                                                        local Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_AmmoMaxUp_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_RE4[j]:get_field("_LimitBreakAmmoMaxUp")

                                                        if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_AmmoMaxUp_RE4 then
                                                            if subParamName:match("Level_EX") then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    if subParamName_2nd == "EXAC" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            if (subParamName_3rd == "_AmmoMaxScale") or (subParamName_3rd == "_ReloadNumScale") then
                                                                                Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_AmmoMaxUp_RE4[subParamName_3rd] = subParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Category_RE4 == 5 then
                                                        local Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Rapid_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_RE4[j]:get_field("_LimitBreakRapid")

                                                        if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Rapid_RE4 then
                                                            if subParamName:match("Level_EX") then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    if subParamName_2nd == "EXROF" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            if subParamName_3rd == "_RapidSpeedScale" then
                                                                                Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Rapid_RE4[subParamName_3rd] = subParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Category_RE4 == 7 then
                                                        local Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_OK_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_RE4[j]:get_field("_LimitBreakOKReload")

                                                        if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_OK_RE4 then
                                                            if subParamName:match("Level_EX") then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    if subParamName_2nd == "EXINF" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            if subParamName_3rd == "_IsOKReload" then
                                                                                Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_OK_RE4[subParamName_3rd] = subParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Category_RE4 == 8 then
                                                        local Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Speed_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_RE4[j]:get_field("_LimitBreakCombatSpeed")

                                                        if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Speed_RE4 then
                                                            if subParamName:match("Level_EX") then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    if subParamName_2nd == "EXSPD" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            if subParamName_3rd == "_CombatSpeed" then
                                                                                Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Speed_RE4[subParamName_3rd] = subParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Category_RE4 == 9 then
                                                        local Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_UNBRK_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_RE4[j]:get_field("_LimitBreakUnbreakable")

                                                        if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_UNBRK_RE4 then
                                                            if subParamName:match("Level_EX") then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    if subParamName_2nd == "EXUNBRK" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            if subParamName_3rd == "_IsUnbreakable" then
                                                                                Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_UNBRK_RE4[subParamName_3rd] = subParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Category_RE4 == 10 then
                                                        local Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Blast_RE4 = Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_RE4[j]:get_field("_LimitBreakBlastRange_1011")

                                                        if Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Blast_RE4 then
                                                            if subParamName:match("Level_EX") then
                                                                for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                    if subParamName_2nd == "EXEXP" then
                                                                        for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                            if subParamName_3rd == "_BlastRangeScale" then
                                                                                Weapon_WeaponCustomCatalog_UserData_LimitBreakCustom_Blast_RE4[subParamName_3rd] = subParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end

                                                for j in pairs(Weapon_WeaponCustomCatalog_UserData_AttachmentCustom_RE4) do
                                                    if weapon.isUseCustomPart then
                                                        local Weapon_WeaponCustomCatalog_UserData_AttachmentParams_Category_RE4 = Weapon_WeaponCustomCatalog_UserData_AttachmentCustom_RE4[j]:get_field("_AttachmentParams")

                                                        for k in pairs(Weapon_WeaponCustomCatalog_UserData_AttachmentParams_Category_RE4) do
                                                            local Weapon_WeaponCustomCatalog_UserData_AttachmentCustom_Category_RE4 = Weapon_WeaponCustomCatalog_UserData_AttachmentParams_Category_RE4[k]:get_field("_AttachmentParamName")
                                                            
                                                            if Weapon_WeaponCustomCatalog_UserData_AttachmentCustom_Category_RE4 == 101 then
                                                                Weapon_WeaponCustomCatalog_UserData_AttachmentParams_Category_RE4[k]._RandomRadius_Fit = AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts._RandomRadius_Fit
                                                            end

                                                            if Weapon_WeaponCustomCatalog_UserData_AttachmentCustom_Category_RE4 == 103 then
                                                                local Weapon_WeaponCustomCatalog_UserData_ReticleFit_Category_RE4 = Weapon_WeaponCustomCatalog_UserData_AttachmentParams_Category_RE4[k]:get_field("_ReticleFitParam")

                                                                if Weapon_WeaponCustomCatalog_UserData_ReticleFit_Category_RE4 then
                                                                    if subParamName:match("CustomParts") then
                                                                        for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                            if subParamName_2nd == "ReticleFitParam" then
                                                                                for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                    if subParamName_3rd ~= "PointRange" then
                                                                                        Weapon_WeaponCustomCatalog_UserData_ReticleFit_Category_RE4[subParamName_3rd] = subParamValue_3rd
                                                                                    end
                                                                                    if subParamName_3rd == "PointRange" then
                                                                                        for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                            local Weapon_WeaponCustomCatalog_UserData_ReticleFit_PointRange_RE4 = Weapon_WeaponCustomCatalog_UserData_ReticleFit_Category_RE4:get_field("_PointRange")

                                                                                            Weapon_WeaponCustomCatalog_UserData_ReticleFit_PointRange_RE4[subParamName_4th] = subParamValue_4th
                                                                                            func.write_valuetype(Weapon_WeaponCustomCatalog_UserData_ReticleFit_Category_RE4, 0x10, Weapon_WeaponCustomCatalog_UserData_ReticleFit_PointRange_RE4)
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end

                                                            if Weapon_WeaponCustomCatalog_UserData_AttachmentCustom_Category_RE4 == 104 then
                                                                local Weapon_WeaponCustomCatalog_UserData_CameraRecoil_Category_RE4 = Weapon_WeaponCustomCatalog_UserData_AttachmentParams_Category_RE4[k]:get_field("_CameraRecoilParam")

                                                                if Weapon_WeaponCustomCatalog_UserData_CameraRecoil_Category_RE4 then
                                                                    if subParamName:match("CustomParts") then
                                                                        for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                            if subParamName_2nd == "CameraRecoilParam" then
                                                                                for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                    if not subParamName_3rd:match("Deg$") then
                                                                                        Weapon_WeaponCustomCatalog_UserData_CameraRecoil_Category_RE4[subParamName_3rd] = subParamValue_3rd
                                                                                    end
                                                                                    if subParamName_3rd == "YawRangeDeg" then
                                                                                        for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                            local Weapon_WeaponCatalog_CameraRecoilParam_Yaw_RE4 = Weapon_WeaponCustomCatalog_UserData_CameraRecoil_Category_RE4:get_field("_YawRangeDeg")
                                                                                            Weapon_WeaponCatalog_CameraRecoilParam_Yaw_RE4[subParamName_4th] = subParamValue_4th
                                                                                            func.write_valuetype(Weapon_WeaponCustomCatalog_UserData_CameraRecoil_Category_RE4, 0x18, Weapon_WeaponCatalog_CameraRecoilParam_Yaw_RE4)
                                                                                        end
                                                                                    end
                                                                                    if subParamName_3rd == "PitchRangeDeg" then
                                                                                        for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                            local Weapon_WeaponCatalog_CameraRecoilParam_Pitch_RE4 = Weapon_WeaponCustomCatalog_UserData_CameraRecoil_Category_RE4:get_field("_PitchRangeDeg")
                                                                                            Weapon_WeaponCatalog_CameraRecoilParam_Pitch_RE4[subParamName_4th] = subParamValue_4th
                                                                                            func.write_valuetype(Weapon_WeaponCustomCatalog_UserData_CameraRecoil_Category_RE4, 0x20, Weapon_WeaponCatalog_CameraRecoilParam_Pitch_RE4)
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end

                                                            if Weapon_WeaponCustomCatalog_UserData_AttachmentCustom_Category_RE4 == 105 then
                                                                local Weapon_WeaponCustomCatalog_UserData_CameraShakeParam_Category_RE4 = Weapon_WeaponCustomCatalog_UserData_AttachmentParams_Category_RE4[k]:get_field("_CameraShakeParam")

                                                                if Weapon_WeaponCustomCatalog_UserData_CameraShakeParam_Category_RE4 then
                                                                    if subParamName:match("CustomParts") then
                                                                        for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                            if subParamName_2nd == "CameraShakeParam" then
                                                                                for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                    if subParamName_3rd == "_Type" then
                                                                                        Weapon_WeaponCustomCatalog_UserData_CameraShakeParam_Category_RE4[subParamName_3rd] = subParamValue_3rd
                                                                                    end
                                                                                    if subParamName_3rd == "Life" then
                                                                                        for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                            local Weapon_WeaponCatalog_CameraShakeParam_Life_RE4 = Weapon_WeaponCustomCatalog_UserData_CameraShakeParam_Category_RE4:get_field("_Life")
                                                                                            Weapon_WeaponCatalog_CameraShakeParam_Life_RE4[subParamName_4th] = subParamValue_4th
                                                                                        end
                                                                                    end
                                                                                    if subParamName_3rd == "Move" then
                                                                                        for subParamName_4th, subParamValue_4th in pairs(subParamValue_3rd) do
                                                                                            local Weapon_WeaponCatalog_CameraShakeParam_Move_RE4 = Weapon_WeaponCustomCatalog_UserData_CameraShakeParam_Category_RE4:get_field("_Move")

                                                                                            if subParamName_4th == "Period" then
                                                                                                for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_Period_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_Period")
                                                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_Period_RE4[subParamName_5th] = subParamValue_5th
                                                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x10, Weapon_WeaponCatalog_CameraShakeParam_Move_Period_RE4)
                                                                                                end
                                                                                            end
                                                                                            if subParamName_4th == "TranslationXRange" then
                                                                                                for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_TransX_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_TranslationXRange")
                                                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_TransX_RE4[subParamName_5th] = subParamValue_5th
                                                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x18, Weapon_WeaponCatalog_CameraShakeParam_Move_TransX_RE4)
                                                                                                end
                                                                                            end
                                                                                            if subParamName_4th == "TranslationYRange" then
                                                                                                for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_TransY_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_TranslationYRange")
                                                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_TransY_RE4[subParamName_5th] = subParamValue_5th
                                                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x20, Weapon_WeaponCatalog_CameraShakeParam_Move_TransY_RE4)
                                                                                                end
                                                                                            end
                                                                                            if subParamName_4th == "TranslationZRange" then
                                                                                                for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_TransZ_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_TranslationZRange")
                                                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_TransZ_RE4[subParamName_5th] = subParamValue_5th
                                                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x28, Weapon_WeaponCatalog_CameraShakeParam_Move_TransZ_RE4)
                                                                                                end
                                                                                            end
                                                                                            if subParamName_4th == "RotationXRange" then
                                                                                                for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_RotX_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_RotationXRange")
                                                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_RotX_RE4[subParamName_5th] = subParamValue_5th
                                                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x30, Weapon_WeaponCatalog_CameraShakeParam_Move_RotX_RE4)
                                                                                                end
                                                                                            end
                                                                                            if subParamName_4th == "RotationYRange" then
                                                                                                for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_RotY_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_RotationYRange")
                                                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_RotY_RE4[subParamName_5th] = subParamValue_5th
                                                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x38, Weapon_WeaponCatalog_CameraShakeParam_Move_RotY_RE4)
                                                                                                end
                                                                                            end
                                                                                            if subParamName_4th == "RotationZRange" then
                                                                                                for subParamName_5th, subParamValue_5th in pairs(subParamValue_4th) do
                                                                                                    local Weapon_WeaponCatalog_CameraShakeParam_Move_RotZ_RE4 = Weapon_WeaponCatalog_CameraShakeParam_Move_RE4:get_field("_RotationZRange")
                                                                                                    Weapon_WeaponCatalog_CameraShakeParam_Move_RotZ_RE4[subParamName_5th] = subParamValue_5th
                                                                                                    func.write_valuetype(Weapon_WeaponCatalog_CameraShakeParam_Move_RE4, 0x40, Weapon_WeaponCatalog_CameraShakeParam_Move_RotZ_RE4)
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

                                                            if Weapon_WeaponCustomCatalog_UserData_AttachmentCustom_Category_RE4 == 106 then
                                                                local Weapon_WeaponCustomCatalog_UserData_Handshake_Category_RE4 = Weapon_WeaponCustomCatalog_UserData_AttachmentParams_Category_RE4[k]:get_field("_WeaponHandShakeParam")
                                                                
                                                                if Weapon_WeaponCustomCatalog_UserData_Handshake_Category_RE4 then
                                                                    if subParamName:match("CustomParts") then
                                                                        for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                            if subParamName_2nd == "HandShakeParam" then
                                                                                for subParamName_3rd, subParamValue_3rd in pairs(subParamValue_2nd) do
                                                                                    Weapon_WeaponCustomCatalog_UserData_Handshake_Category_RE4[subParamName_3rd] = subParamValue_3rd
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end

                                                            if Weapon_WeaponCustomCatalog_UserData_AttachmentCustom_Category_RE4 == 501 and weapon.ID ~= "wp4401" then
                                                                Weapon_WeaponCustomCatalog_UserData_AttachmentParams_Category_RE4[k]._ReticleGuiType = AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts._ReticleGuiType

                                                                if AWF_tool_settings.isHideReticle then
                                                                    Weapon_WeaponCustomCatalog_UserData_AttachmentParams_Category_RE4[k]._ReticleGuiType = 100000
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
                end
            end
        end
        weapon.isCustomCatalogUpdated = false

        if weapon.isInventoryUpdated then
            if playerContext ~= nil then
                playerHead = playerContext and playerContext:get_HeadGameObject()
                isPlayerInScene = true

                if playerHead then
                    local playerEquipmentComp = func.get_GameObjectComponent(playerHead, RE4_Cache.playerEquipment)
        
                    if playerEquipmentComp then
                        local Weapon_PlayerInventoryObserver_CSInventory_RE4 = playerEquipmentComp:get_InventoryController():get__CsInventory()

                        if Weapon_PlayerInventoryObserver_CSInventory_RE4 then
                            local Weapon_PlayerInventoryObserver_InventoryItems_RE4 = Weapon_PlayerInventoryObserver_CSInventory_RE4:get_field("_InventoryItems")

                            if Weapon_PlayerInventoryObserver_InventoryItems_RE4 then
                                local Weapon_PlayerInventoryObserver_InventoryItems_Items_RE4 = Weapon_PlayerInventoryObserver_InventoryItems_RE4:get_field("_items")
                                
                                for i = 0, #Weapon_PlayerInventoryObserver_InventoryItems_Items_RE4 do
                                    local ItemID = Weapon_PlayerInventoryObserver_InventoryItems_Items_RE4[i]
                                    
                                    if ItemID then
                                        local WeaponID = ItemID:call("get_WeaponId")
                                        
                                        if WeaponID == weapon.Enum and currentGameMode == weapon.Game then
                                            if AWF_tool_settings.isDebug then
                                                log.info("[AWF] [ " .. weapon.ID .. " Inventory data updated.]")
                                            end
                                            local Weapon_InventoryItem_RE4 = ItemID:get_field("<Item>k__BackingField")

                                            if Weapon_InventoryItem_RE4 then
                                                local weaponParams = AWF_settings.RE4.Weapon_Params[weapon.ID]
                                                local Weapon_InventoryItem_Define_RE4 = Weapon_InventoryItem_RE4:get_field("<_DefaultWeaponDefine>k__BackingField")
                                                
                                                Weapon_InventoryItem_RE4._CurrentAmmo = AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory._CurrentAmmo
                                                
                                                for paramName, paramValue in pairs(weaponParams) do
                                                    if paramName == "Inventory" then
                                                        for subParamName, subParamValue in pairs(paramValue) do
                                                            if subParamName == "Define" then
                                                                if Weapon_InventoryItem_Define_RE4 then
                                                                    for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                        if subParamName_2nd ~= "_AmmoCost" then
                                                                            Weapon_InventoryItem_Define_RE4[subParamName_2nd] = subParamValue_2nd
                                                                        end
                                                                        if subParamName_2nd == "_AmmoCost" then
                                                                            if weaponParams.UnlimitedCapacity then
                                                                                Weapon_InventoryItem_Define_RE4._AmmoCost = 0
                                                                            elseif not weaponParams.UnlimitedCapacity then
                                                                                Weapon_InventoryItem_Define_RE4[subParamName_2nd] = subParamValue_2nd
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
                            end
                        end
                    end
                end
            end
        end
        weapon.isInventoryUpdated = false
    end
end

--Clears the cached path for a weapon if a new preset is saved
local function clear_AWF_json_cache_RE4(weaponData)
    for _, weapon in pairs(weaponData) do
        if weapon.isUpdated then
            local cacheKey = "AWF\\AWF_Weapons\\" .. weapon.Name
            cached_jsonPaths_RE4[cacheKey] = nil

            if AWF_tool_settings.isDebug then
                log.info("[AWF] [Preset path cache cleared for " .. weapon.Name .. " | " .. weapon.ID .. " ]")
            end
        end
    end
end

--Caches the .json files
local function cache_AWF_json_files_RE4(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWF_settings.RE4.Weapon_Params[weapon.ID]
        
        if weaponParams then
            local json_names = weaponParams.Weapon_Presets or {}
            local cacheKey = "AWF\\AWF_Weapons\\" .. weapon.Name

            if not cached_jsonPaths_RE4[cacheKey] then
                local path = [[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\.*.json]]
                cached_jsonPaths_RE4[cacheKey] =  fs.glob(path)
            end

            local json_filepaths = cached_jsonPaths_RE4[cacheKey]
            
            if json_filepaths then
                local defaultName = weapon.Name .. " Default"
                local defaultNameInserted = false

                for i, filepath in ipairs(json_filepaths) do
                    local name = filepath:match("^.+\\(.+)%.")
                    local nameExists = false
                    
                    for j, existingName in ipairs(json_names) do
                        if existingName == name then
                            nameExists = true
                            break
                        end
                    end
                    
                    if not nameExists then
                        if name == defaultName then
                            table.insert(json_names, 1, name)
                            defaultNameInserted = true
                        else
                            table.insert(json_names, name)
                        end

                        if AWF_tool_settings.isDebug then
                            log.info("[AWF] [Loaded " .. filepath .. " for "  .. weapon.Name .. "]")
                        end
                    end
                end
                
                if not defaultNameInserted then
                    for i, name in ipairs(json_names) do
                        if name == defaultName then
                            table.remove(json_names, i)
                            table.insert(json_names, 1, name)
                            break
                        end
                    end
                end

                for i = #json_names, 1, -1 do
                    local nameExists = false
                    local name = json_names[i]
                    for _, filepath in ipairs(json_filepaths) do
                        if filepath:match("^.+\\(.+)%.") == name then
                            nameExists = true
                            break
                        end
                    end
                    if not nameExists then
                        if AWF_tool_settings.isDebug then
                            log.info("[AWF] [Removed " .. name .. " from " .. weapon.Name .. "]")
                        end
                        table.remove(json_names, i)
                    end
                end
            else
                if AWF_tool_settings.isDebug then
                    log.info("[AWF] [No AWF JSON files found.]")
                end
            end
        end
    end
end

--Calls 'dump_Default_WeaponParam_json_RE4' and then 'cache_AWF_json_files_RE4' when the script is called for the first time
if reframework.get_game_name() == "re4" then
    --Prevents knives to lose durability
    sdk.hook(sdk.find_type_definition("chainsaw.Item"):get_method("reduceDurability(System.Int32)"),
    function(args)
        if AWF_tool_settings.RE4.isUnbreakable then
            return sdk.PreHookResult.SKIP_ORIGINAL
        end
    end,
    function(retval)
        return retval
    end)
    dump_Default_WeaponParam_json_RE4(AWFWeapons.RE4.Weapons)
    cache_AWF_json_files_RE4(AWF_settings.RE4.Weapons)
end

--Checks if a Weapon is already in cache
local function check_if_WeaponDataIsCached_RE4(weaponData)
    for _, weapon in pairs(weaponData) do
        local Weapon_GameObject_RE4 = cached_weapon_GameObjects_RE4[weapon.ID]
        
        if Weapon_GameObject_RE4 and weapon.isUpdated then
            log.info("[AWF] [Loaded " .. weapon.Name .. " Game Object from cache.]")
        end
    end
end

--Update function for get_WeaponData_RE4
local function update_WeaponData_RE4()
    if changed or wc or not cached_weapon_GameObjects_RE4 then
        changed = false
        wc = false
        AWF_Weapons_Found = true
        get_WeaponData_RE4(AWF_settings.RE4.Weapons)
        check_if_WeaponDataIsCached_RE4(AWF_settings.RE4.Weapons)
        log.info("[AWF] [------------ AWF Weapon Data Updated!]")
    end
end

--Draws the Weapon Stat Editor GUI
local function draw_AWF_RE4Editor_GUI(weaponOrder)
    if imgui.begin_window("Advanced Weapon Framework: Weapon Stat Editor") then
        imgui.begin_rect()
        local weaponsByGame = {}
        local lastGame = nil

        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF_settings.RE4.Weapons[weaponName]
            if weapon then
                local gameMode = weapon.Game
                if not weaponsByGame[gameMode] then
                    weaponsByGame[gameMode] = {}
                end
                table.insert(weaponsByGame[gameMode], weapon)
            end
        end
            
        local gameModeLabels = {
            Main = "Main Game",
            SW = "Separate Ways",
            Mercs = "Mercenaries"
        }
        
        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF_settings.RE4.Weapons[weaponName]
            
            if weapon then
                local textColor = {255,255,255,255}

                if weapon.Game == "Main" then
                    textColor = {255, 187, 0, 255}
                elseif weapon.Game == "SW" then
                    textColor = {245, 56, 81, 255}
                elseif weapon.Game == "Mercs" then
                    textColor = {0, 255, 219, 255}
                end

                if weapon.Game ~= lastGame then
                    imgui.text_colored("  [ " .. ui.draw_line("=", 50) .. " | " .. (gameModeLabels[weapon.Game] or weapon.Game) .. " | " .. ui.draw_line("=", 50) .. " ] ", func.convert_rgba_to_AGBR(textColor))
                    lastGame = weapon.Game
                end
                
                if imgui.tree_node(weapon.Name) then
                    if imgui.begin_popup_context_item() then
                        if imgui.menu_item("Reset") then
                            wc = true
                            AWF_settings.RE4.Weapon_Params[weapon.ID] = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID])
                            cache_AWF_json_files_RE4(AWF_settings.RE4.Weapons)
                        end
                        func.tooltip("Reset all of the parameters of " .. weapon.Name)

                        imgui.end_popup()
                    end
                    imgui.begin_rect()


                    imgui.text_colored("  " .. ui.draw_line("=", 100) .."  ", func.convert_rgba_to_AGBR(textColor))
                    imgui.indent(10)

                    if imgui.button("Update Preset List") then
                        cache_AWF_json_files_RE4(AWF_settings.RE4.Weapons)
                    end

                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].current_param_indx = imgui.combo("Preset", AWF_settings.RE4.Weapon_Params[weapon.ID].current_param_indx or 1, AWF_settings.RE4.Weapon_Params[weapon.ID].Weapon_Presets); wc = wc or changed
                    func.tooltip("Select a file from the dropdown menu to load the weapon stats from that file.")
                    if changed then
                        local selected_preset = AWF_settings.RE4.Weapon_Params[weapon.ID].Weapon_Presets[AWF_settings.RE4.Weapon_Params[weapon.ID].current_param_indx]
                        local json_filepath = [[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                        local temp_params = json.load_file(json_filepath)
                        
                        if AWF_tool_settings.isInheritPresetName then
                            presetName = selected_preset
                        end

                        temp_params.Weapon_Presets = nil
                        temp_params.current_param_indx = nil

                        for key, value in pairs(temp_params) do
                            AWF_settings.RE4.Weapon_Params[weapon.ID][key] = value
                        end
                        cache_AWF_json_files_RE4(AWF_settings.RE4.Weapons)
                    end
                    
                    imgui.push_id(_)
                    changed, presetName = imgui.input_text("", presetName); wc = wc or changed
                    imgui.pop_id()

                    imgui.same_line()
                    if imgui.button("Save Preset") then
                        json.dump_file("AWF/AWF_Weapons/".. weapon.Name .. "/" .. presetName .. ".json", AWF_settings.RE4.Weapon_Params[weapon.ID])
                        log.info("[AWF] [Custom " .. weapon.Name ..  " params saved with the preset name " .. presetName .. " ]")
                        weapon.isUpdated = true
                        clear_AWF_json_cache_RE4(AWF_settings.RE4.Weapons)
                        cache_AWF_json_files_RE4(AWF_settings.RE4.Weapons)
                    end
                    func.tooltip("Save the current parameters of the " .. weapon.Name .. " to '[PresetName].json' found in [RESIDENT EVIL 4  BIOHAZARD RE4/reframework/data/AWF/AWF_Weapons/".. weapon.Name .. "]")

                    imgui.spacing()

                    if weapon.Type ~= "KNF" then
                        changed, AWF_settings.RE4.Weapon_Params[weapon.ID].UnlimitedCapacity = imgui.checkbox("Unlimited Capacity", AWF_settings.RE4.Weapon_Params[weapon.ID].UnlimitedCapacity); wc = wc or changed
                        func.tooltip("If enabled, the weapon does not need to be reloaded.")
                    end

                    -- if AWF_tool_settings.isDebug then
                    --     ui.button_n_colored_txt("DAMAGE LVL:", AWF_settings.RE4.Weapon_Params[weapon.ID].LevelTracker.CurrentLevel.DMG, 0xFF00FF00); wc = wc or changed
                    --     if AWF_settings.RE4.Weapon_Params[weapon.ID].LevelTracker.CurrentLevel.DMG == 1 then
                    --         AWF_settings.RE4.Weapon_Params[weapon.ID].LevelTracker.CurrentStats.DMG = (AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_1.LVL1_DMG._BaseValue * AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo.DamageRate._BaseValue)
                    --     elseif AWF_settings.RE4.Weapon_Params[weapon.ID].LevelTracker.CurrentLevel.DMG > 1 then
                    --         AWF_settings.RE4.Weapon_Params[weapon.ID].LevelTracker.CurrentStats.DMG = ((AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_1.LVL1_DMG._BaseValue * AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo.DamageRate._BaseValue) * AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog["Level_" .. tostring(AWF_settings.RE4.Weapon_Params[weapon.ID].LevelTracker.CurrentLevel.DMG)]["LVL" .. tostring(AWF_settings.RE4.Weapon_Params[weapon.ID].LevelTracker.CurrentLevel.DMG) .. "_DMG"]._BaseValue)
                    --     end
                    --     if weapon.Type == "HG" then
                    --         imgui.progress_bar(AWF_settings.RE4.Weapon_Params[weapon.ID].LevelTracker.CurrentStats.DMG / 10.0, Vector2f.new(500, 20), string.format("Current Damage: %.2f", AWF_settings.RE4.Weapon_Params[weapon.ID].LevelTracker.CurrentStats.DMG))
                    --     end
                    --     if weapon.Type == "MAG" then
                    --         imgui.progress_bar(AWF_settings.RE4.Weapon_Params[weapon.ID].LevelTracker.CurrentStats.DMG / 100.0, Vector2f.new(500, 20), string.format("Current Damage: %.2f", AWF_settings.RE4.Weapon_Params[weapon.ID].LevelTracker.CurrentStats.DMG))
                    --     end
                    -- end

                    imgui.spacing()

                    if imgui.tree_node(weapon.Name .. ": Base Stats") then
                        if imgui.begin_popup_context_item() then
                            if imgui.menu_item("Reset") then
                                wc = true
                                AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].BaseStats)
                                AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].Catalog)
                            end
                            imgui.end_popup()
                        end

                        if AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats then
                            imgui.spacing()

                            if AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator then
                                imgui.text_colored(ui.draw_line("=", 95) .. "|  Bullet Ballistic " , func.convert_rgba_to_AGBR(textColor))

                                if imgui.button("Reset Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator)
                                    AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ThinkPlayerParam = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].BaseStats.ThinkPlayerParam)
                                end
                                if weapon.Type ~= "SG" then
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo.DamageRate._BaseValue = imgui.drag_float("Damage Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo.DamageRate._BaseValue,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Damage multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo.WinceRate._BaseValue = imgui.drag_float("Wince Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo.WinceRate._BaseValue,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Melee prompt frequency multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo.BreakRate._BaseValue = imgui.drag_float("Break Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo.BreakRate._BaseValue,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Dismemberment Power multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo.StoppingRate._BaseValue = imgui.drag_float("Stopping Power Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo.StoppingRate._BaseValue,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Stopping Power multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo._CriticalRate = imgui.drag_float("Critical Rate", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo._CriticalRate, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("The chance of landing a critical hit. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo._CriticalRate_Fit = imgui.drag_float("Critical Rate Fit ", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo._CriticalRate_Fit,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo._ColliderRadius = imgui.drag_float("Bullet Hitbox Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AttackInfo._ColliderRadius, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("The size of the bullet's hitbox.")
                                    
                                    imgui.spacing()

                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.MoveInfo._RandomRadius = imgui.drag_float("Spread", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.MoveInfo._RandomRadius, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Weapon spread. Lower is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.MoveInfo._RandomRadius_Fit = imgui.drag_float("Spread Fit", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.MoveInfo._RandomRadius_Fit, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.MoveInfo._Speed = imgui.drag_float("Speed", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.MoveInfo._Speed, 1.0, 0.0, 1000.0); wc = wc or changed
                                    func.tooltip("The velocity of the bullet. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.MoveInfo._Gravity = imgui.drag_float("Gravity", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.MoveInfo._Gravity, 1.0, 0.0, 1000.0); wc = wc or changed
                                    func.tooltip("The strength of the gravitational force on the bullet.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.MoveInfo._IgnoreGravityDistance = imgui.drag_float("Ignore Gravity Distance", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.MoveInfo._IgnoreGravityDistance, 1.0, 0.0, 1000.0); wc = wc or changed
                                    func.tooltip("The range at which the bullet disregards gravitational force.")

                                    imgui.spacing()

                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.LifeInfo._Type = imgui.combo("Life Type", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.LifeInfo._Type, {"Time", "Distance"}); wc = wc or changed
                                    func.tooltip("How the bullet's uptime is measured.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.LifeInfo._Time = imgui.drag_float("Time", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.LifeInfo._Time, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("The bullet's uptime in seconds. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.LifeInfo._Distance = imgui.drag_float("Distance", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.LifeInfo._Distance, 1.0, 0.0, 1000.0); wc = wc or changed
                                    func.tooltip("The bullet's uptime in meters; the weapon's effective range. Higher is better.")
                                end
                                if weapon.Type == "SG" then
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo.DamageRate._BaseValue = imgui.drag_float("Center Pellet Damage Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo.DamageRate._BaseValue,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Damage multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo.WinceRate._BaseValue = imgui.drag_float("Center Pellet Wince Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo.WinceRate._BaseValue,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Melee prompt frequency multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo.BreakRate._BaseValue = imgui.drag_float("Center Pellet Break Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo.BreakRate._BaseValue,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Dismemberment Power multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo.StoppingRate._BaseValue = imgui.drag_float("Center Pellet Stopping Power Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo.StoppingRate._BaseValue,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Stopping Power multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo._CriticalRate = imgui.drag_float("Center Pellet Critical Rate", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo._CriticalRate, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("The chance of landing a critical hit. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo._CriticalRate_Fit = imgui.drag_float("Center Pellet Critical Rate Fit ", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo._CriticalRate_Fit,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo._ColliderRadius = imgui.drag_float("Center Pellet Bullet Hitbox Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.AttackInfo._ColliderRadius, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("The size of the bullet's hitbox.")
                                    
                                    imgui.spacing()

                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.MoveInfo._RandomRadius = imgui.drag_float("Center Pellet Spread", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.MoveInfo._RandomRadius, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Weapon spread. Lower is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.MoveInfo._RandomRadius_Fit = imgui.drag_float("Center Pellet Spread Fit", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.MoveInfo._RandomRadius_Fit, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.MoveInfo._Speed = imgui.drag_float("Center Pellet Speed", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.MoveInfo._Speed, 1.0, 0.0, 1000.0); wc = wc or changed
                                    func.tooltip("The velocity of the bullet. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.MoveInfo._Gravity = imgui.drag_float("Center Pellet Gravity", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.MoveInfo._Gravity, 1.0, 0.0, 1000.0); wc = wc or changed
                                    func.tooltip("The strength of the gravitational force on the bullet.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.MoveInfo._IgnoreGravityDistance = imgui.drag_float("Center Pellet Ignore Gravity Distance", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.MoveInfo._IgnoreGravityDistance, 1.0, 0.0, 1000.0); wc = wc or changed
                                    func.tooltip("The range at which the bullet disregards gravitational force.")

                                    imgui.spacing()

                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.LifeInfo._Type = imgui.combo("Center Pellet Bullet Life Type", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.LifeInfo._Type, {"Time", "Distance"}); wc = wc or changed
                                    func.tooltip("How the bullet's uptime is measured.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.LifeInfo._Time = imgui.drag_float("Center Pellet Time", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.LifeInfo._Time, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("The bullet's uptime in seconds. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.LifeInfo._Distance = imgui.drag_float("Center Pellet Distance", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Center.LifeInfo._Distance, 1.0, 0.0, 1000.0); wc = wc or changed
                                    func.tooltip("The bullet's uptime in meters; the weapon's effective range. Higher is better.")

                                    imgui.spacing()

                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo.DamageRate._BaseValue = imgui.drag_float("Around Pellet Damage Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo.DamageRate._BaseValue,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Damage multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo.WinceRate._BaseValue = imgui.drag_float("Around Pellet Wince Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo.WinceRate._BaseValue,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Melee prompt frequency multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo.BreakRate._BaseValue = imgui.drag_float("Around Pellet Break Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo.BreakRate._BaseValue,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Dismemberment Power multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo.StoppingRate._BaseValue = imgui.drag_float("Around Pellet Stopping Power Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo.StoppingRate._BaseValue,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Stopping Power multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo._CriticalRate = imgui.drag_float("Around Pellet Critical Rate", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo._CriticalRate, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("The chance of landing a critical hit. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo._CriticalRate_Fit = imgui.drag_float("Around Pellet Critical Rate Fit ", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo._CriticalRate_Fit,  0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo._ColliderRadius = imgui.drag_float("Around Pellet Bullet Hitbox Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.AttackInfo._ColliderRadius, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("The size of the bullet's hitbox.")
                                    
                                    imgui.spacing()

                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.MoveInfo._RandomRadius = imgui.drag_float("Around Pellet Spread", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.MoveInfo._RandomRadius, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Weapon spread. Lower is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.MoveInfo._RandomRadius_Fit = imgui.drag_float("Around Pellet Spread Fit", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.MoveInfo._RandomRadius_Fit, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.MoveInfo._Speed = imgui.drag_float("Around Pellet Speed", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.MoveInfo._Speed, 1.0, 0.0, 1000.0); wc = wc or changed
                                    func.tooltip("The velocity of the bullet. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.MoveInfo._Gravity = imgui.drag_float("Around Pellet Gravity", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.MoveInfo._Gravity, 1.0, 0.0, 1000.0); wc = wc or changed
                                    func.tooltip("The strength of the gravitational force on the bullet.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.MoveInfo._IgnoreGravityDistance = imgui.drag_float("Around Pellet Ignore Gravity Distance", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.MoveInfo._IgnoreGravityDistance, 1.0, 0.0, 1000.0); wc = wc or changed
                                    func.tooltip("The range at which the bullet disregards gravitational force.")

                                    imgui.spacing()

                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.LifeInfo._Type = imgui.combo("Around Pellet Bullet Life Type", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.LifeInfo._Type, {"Time", "Distance"}); wc = wc or changed
                                    func.tooltip("How the bullet's uptime is measured.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.LifeInfo._Time = imgui.drag_float("Around Pellet Time", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.LifeInfo._Time, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("The bullet's uptime in seconds. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.LifeInfo._Distance = imgui.drag_float("Around Pellet Distance", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Around.LifeInfo._Distance, 1.0, 0.0, 1000.0); wc = wc or changed
                                    func.tooltip("The bullet's uptime in meters; the weapon's effective range. Higher is better.")
                                
                                    imgui.spacing()

                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting._AroundBulletCount = imgui.drag_int("Around Pellet Count", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting._AroundBulletCount, 1, 0, 100); wc = wc or changed
                                    func.tooltip("The number of around pellets. Higher is better.")
                                    -- changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting._CenterBulletCount = imgui.drag_int("Center Pellet Count", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting._CenterBulletCount, 1, 0, 100); wc = wc or changed
                                    -- func.tooltip("The number of center pellets. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting._InnerRadius = imgui.drag_float("Inner Radius", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting._InnerRadius, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting._OuterRadius = imgui.drag_float("Outer Radius", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting._OuterRadius, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.CenterScatter.Vertical.s = imgui.drag_float("Center Scatter Y Min", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.CenterScatter.Vertical.s, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.CenterScatter.Vertical.r = imgui.drag_float("Center Scatter Y Max", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.CenterScatter.Vertical.r, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.CenterScatter.Horizontal.s = imgui.drag_float("Center Scatter X Min", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.CenterScatter.Horizontal.s, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.CenterScatter.Horizontal.r = imgui.drag_float("Center Scatter X Max", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.CenterScatter.Horizontal.r, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.AroundScatter.Vertical.s = imgui.drag_float("Around Scatter Y Min", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.AroundScatter.Vertical.s, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.AroundScatter.Vertical.r = imgui.drag_float("Around Scatter Y Max", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.AroundScatter.Vertical.r, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.AroundScatter.Horizontal.s = imgui.drag_float("Around Scatter X Min", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.AroundScatter.Horizontal.s, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.AroundScatter.Horizontal.r = imgui.drag_float("Around Scatter X Max", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.AroundSetting.AroundScatter.Horizontal.r, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")

                                end
                                if weapon.Type == "XBOW" then
                                    imgui.spacing()

                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Arrow._BombStartTime = imgui.drag_float("Bomb Start Time", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Arrow._BombStartTime, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Arrow._SensorTime = imgui.drag_float("Sensor Time", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Arrow._SensorTime, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Arrow._SensorRadius = imgui.drag_float("Sensor Radius", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Arrow._SensorRadius, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Arrow._LightLoopTime = imgui.drag_float("Light Loop Time", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ShellGenerator.Arrow._LightLoopTime, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("TBD")
                                end
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ThinkPlayerParam.RangeDistance = imgui.drag_float("Think Range Distance", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ThinkPlayerParam.RangeDistance,  1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("TBD")
                            end

                            if AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.MeleeParam then
                                imgui.text_colored(ui.draw_line("=", 95) .. "|  Melee Params " , func.convert_rgba_to_AGBR(textColor))

                                if imgui.button("Reset Melee Parameters") then
                                    wc = true
                                    AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.MeleeParam = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].BaseStats.MeleeParam)
                                    AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ThinkPlayerParam = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].BaseStats.ThinkPlayerParam)
                                end

                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.MeleeParam.AttackInfo.Combat._ReducePoint = imgui.drag_int("Combat: Reduce Point", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.MeleeParam.AttackInfo.Combat._ReducePoint,  1, 0, 1000); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.MeleeParam.AttackInfo.Combat._CriticalRate = imgui.drag_int("Combat: Critical Rate", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.MeleeParam.AttackInfo.Combat._CriticalRate,  1, 0, 1000); wc = wc or changed
                                func.tooltip("TBD")
                                hanged, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.MeleeParam.AttackInfo.CombatCombo._ReducePoint = imgui.drag_int("Combat Combo: Reduce Point", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.MeleeParam.AttackInfo.CombatCombo._ReducePoint,  1, 0, 1000); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.MeleeParam.AttackInfo.CombatCombo._CriticalRate = imgui.drag_int("Combat Combo: Critical Rate", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.MeleeParam.AttackInfo.CombatCombo._CriticalRate,  1, 0, 1000); wc = wc or changed
                                func.tooltip("TBD")

                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ThinkPlayerParam.RangeDistance = imgui.drag_float("Think Range Distance", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ThinkPlayerParam.RangeDistance,  1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("TBD")
                            end

                            imgui.spacing()
                            if AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory then
                                imgui.text_colored(ui.draw_line("=", 95) .. "| Inventory" , func.convert_rgba_to_AGBR(textColor))

                                if imgui.button("Reset Inventory Parameters") then
                                    wc = true
                                    AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].Inventory)
                                end
        
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory._CurrentAmmo = imgui.combo("Ammo Type", AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory._CurrentAmmo, RE4_Cache.ammoTypes); wc = wc or changed
                                func.tooltip("The ammo type used by the weapon.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory.Define._AmmoCost = imgui.drag_int("Ammo Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory.Define._AmmoCost, 1, 0, 1000); wc = wc or changed
                                func.tooltip("The amount ammo used up per shot.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory.Define._ItemSize = imgui.combo("Item Size", AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory.Define._ItemSize, RE4_Cache.itemSizeTypes); wc = wc or changed
                                func.tooltip("The amount of space taken up by the item in the Attaché Case.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory.Define._StackMax = imgui.drag_int("Stack Limit", AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory.Define._StackMax, 1, 0, 10000); wc = wc or changed
                                func.tooltip("Item stack limit.")

                                imgui.spacing()

                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory.Define.DefaultDurabilityMaxValue = imgui.drag_int("Default Durability Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory.Define.DefaultDurabilityMaxValue, 10, 0, 10000); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory.Define._SliderDurabilityMaxValue = imgui.drag_int("Slider Durability Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory.Define._SliderDurabilityMaxValue, 10, 0, 10000); wc = wc or changed
                                func.tooltip("TBD")
                            end

                            imgui.spacing()
                            
                            if AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam then
                                imgui.text_colored(ui.draw_line("=", 95) .. "| Reload" , func.convert_rgba_to_AGBR(textColor))

                                if imgui.button("Reset Reload Parameters") then
                                    wc = true
                                    AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam)
                                end

                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam.TypeOfReload = imgui.combo("Reload Type", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam.TypeOfReload, RE4_Cache.reloadTypes); wc = wc or changed
                                func.tooltip("The weapon's reload type. This is somewhat limited by the animations.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam.ReloadNum = imgui.drag_int("Reload Num", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam.ReloadNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("The number of bullets loaded in a single cycle. Higher is better.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam._ReloadSpeedRate = imgui.drag_float("Reload Speed Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam._ReloadSpeedRate,  0.1, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Reload Speed multiplier. Higher is better.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam.TypeOfShoot = imgui.combo("Fire Mode", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam.TypeOfShoot, RE4_Cache.shootTypes); wc = wc or changed
                                func.tooltip("The weapon's fire mode. This is somewhat limited by the animations.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam._RapidSpeed = imgui.drag_float("Rate of Fire Multiplier", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam._RapidSpeed,  0.1, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Rate of Fire multiplier. This is somewhat limited by the animations.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam._RapidBaseFrame = imgui.drag_float("Rate of Fire Base Frame", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam._RapidBaseFrame,  0.1, -100.0, 100.0); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam._PumpActionRapidSpeed = imgui.drag_float("Pump Action Speed", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam._PumpActionRapidSpeed,  0.1, -100.0, 100.0); wc = wc or changed
                                func.tooltip("The speed of the pump action animation for shotguns.")
                            end

                            imgui.spacing()

                            if AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam then
                                imgui.text_colored(ui.draw_line("=", 95) .. "| ReticleFitParam" , func.convert_rgba_to_AGBR(textColor))

                                if imgui.button("Reset ReticleFitParam Parameters") then
                                    wc = true
                                    AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam)
                                    AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ReticleFitParamTable = hk.recurse_def_settings({},AWFWeapons.RE4.Weapon_Params[weapon.ID].Catalog.ReticleFitParamTable)
                                end
                                if AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ReticleFitParamTable._ReticleShape then 
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ReticleFitParamTable._ReticleShape = imgui.combo("Reticle Type", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ReticleFitParamTable._ReticleShape, RE4_Cache.reticleTypes); wc = wc or changed
                                    -- if AWF_tool_settings.isHideReticle then
                                    --     AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ReticleFitParamTable._ReticleShape = 100000
                                    -- elseif not AWF_tool_settings.isHideReticle then
                                    --     AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ReticleFitParamTable = hk.recurse_def_settings({},AWFWeapons.RE4.Weapon_Params[weapon.ID].Catalog.ReticleFitParamTable)
                                    -- end
                                end
        
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam._HoldAddPoint = imgui.drag_float("Hold Add Point", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam._HoldAddPoint,  1.0, 0.0, 10000.0); wc = wc or changed
                                func.tooltip("The amount of focus points added over time by standing still while aiming.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam._MoveSubPoint = imgui.drag_float("Move Sub Point", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam._MoveSubPoint,  1.0, 0.0, 10000.0); wc = wc or changed
                                func.tooltip("The amount of focus points subtracted for moving.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam._CameraSubPoint = imgui.drag_float("Camera Sub Point", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam._CameraSubPoint,  1.0, 0.0, 10000.0); wc = wc or changed
                                func.tooltip("The amount of focus points subtracted for moving the camera.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam._KeepFitLimitPoint = imgui.drag_float("Keep Fit Limit Point", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam._KeepFitLimitPoint,  1.0, 0.0, 10000.0); wc = wc or changed
                                func.tooltip("The amount of focus points required for the reticle to stay in focused state.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam._ShootSubPoint = imgui.drag_float("Shoot Sub Point", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam._ShootSubPoint,  1.0, 0.0, 10000.0); wc = wc or changed
                                func.tooltip("The amount of focus points subtracted for shooting.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam.PointRange.s = imgui.drag_float("Reticle Min Point", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam.PointRange.s,  1.0, -1000.0, 1000.0); wc = wc or changed
                                func.tooltip("The minimum range of focus points.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam.PointRange.r = imgui.drag_float("Reticle Max Point", AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.ReticleFitParam.PointRange.r,  1.0, -1000.0, 1000.0); wc = wc or changed
                                func.tooltip("The maximum range of focus points.")
                            end
                        end

                        if AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog then
                            
                            imgui.spacing()

                            if AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam then
                                imgui.text_colored(ui.draw_line("=", 95) .. "| CameraRecoilParam" , func.convert_rgba_to_AGBR(textColor))

                                if imgui.button("Reset CameraRecoilParam Parameters") then
                                    wc = true
                                    AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam)
                                end
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam._Yaw = imgui.drag_float("Recoil Yaw", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam._Yaw,  0.1, -100.0, 100.0); wc = wc or changed
                                func.tooltip("The amount the weapon recoils on the X axis. Lower is better.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam.YawRangeDeg.s = imgui.drag_float("Recoil Yaw Min", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam.YawRangeDeg.s,  0.1, -100.0, 100.0); wc = wc or changed
                                func.tooltip("Recoil Yaw minimum.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam.YawRangeDeg.r = imgui.drag_float("Recoil Yaw Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam.YawRangeDeg.r,  0.1, -100.0, 100.0); wc = wc or changed
                                func.tooltip("Recoil Yaw maximum.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam._Pitch = imgui.drag_float("Recoil Pitch", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam._Pitch,  0.1, -100.0, 100.0); wc = wc or changed
                                func.tooltip("The amount the weapon recoils on the Y axis. Lower is better.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam.PitchRangeDeg.s = imgui.drag_float("Recoil Pitch Min", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam.PitchRangeDeg.s,  0.1, -100.0, 100.0); wc = wc or changed
                                func.tooltip("Recoil Pitch minimum.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam.PitchRangeDeg.r = imgui.drag_float("Recoil Pitch Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam.PitchRangeDeg.r,  0.1, -100.0, 100.0); wc = wc or changed
                                func.tooltip("Recoil Pitch maximum.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam._CurveTime = imgui.drag_float("Recoil Curve Time", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraRecoilParam._CurveTime,  0.1, 0.0, 100.0); wc = wc or changed
                                func.tooltip("TBD")
                            end
                            
                            if AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.KnifeCombatSpeedParam and weapon.Type == "KNF" then
                                if imgui.button("Reset KnifeCombatSpeedParam Parameters") then
                                    wc = true
                                    AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.KnifeCombatSpeedParam = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].Catalog.KnifeCombatSpeedParam)
                                end

                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.KnifeCombatSpeedParam._KnifeCombatSpeed = imgui.drag_float("KnifeCombatSpeed", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.KnifeCombatSpeedParam._KnifeCombatSpeed,  0.01, 0.0, 10.0); wc = wc or changed    
                            end
                        
                            -- if AWF_tool_settings.isDebug then
                            --     imgui.spacing()

                            --     if AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam then
                            --         if imgui.button("Reset CameraShakeParam Parameters") then
                            --             wc = true
                            --             AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam)
                            --         end

                            --         local cameraShakeTypes = {
                            --             [0] = "Inherited",
                            --             [1] = "Sin",
                            --         }
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam._Type = imgui.combo("CameraShakeType", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam._Type, cameraShakeTypes)

                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Life._LifeTime = imgui.drag_float("Cam Shake LifeTime", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Life._LifeTime,  0.1, 0.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.Period.s = imgui.drag_float("Cam Shake Period Min", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.Period.s,  0.01, -100.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.Period.r = imgui.drag_float("Cam Shake Period Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.Period.r,  0.01, -100.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.TranslationXRange.s = imgui.drag_float("Cam Shake TranslationXRange Min", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.TranslationXRange.s,  0.01, -100.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.TranslationXRange.r = imgui.drag_float("Cam Shake TranslationXRange Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.TranslationXRange.r,  0.01, -100.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.TranslationYRange.s = imgui.drag_float("Cam Shake TranslationYRange Min", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.TranslationYRange.s,  0.01, -100.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.TranslationYRange.r = imgui.drag_float("Cam Shake TranslationYRange Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.TranslationYRange.r,  0.01, -100.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.TranslationZRange.s = imgui.drag_float("Cam Shake TranslationZRange Min", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.TranslationZRange.s,  0.01, -100.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.TranslationZRange.r = imgui.drag_float("Cam Shake TranslationZRange Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.TranslationZRange.r,  0.01, -100.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.RotationXRange.s = imgui.drag_float("Cam Shake RotationXRange Min", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.RotationXRange.s,  0.01, -100.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.RotationXRange.r = imgui.drag_float("Cam Shake RotationXRange Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.RotationXRange.r,  0.01, -100.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.RotationYRange.s = imgui.drag_float("Cam Shake RotationYRange Min", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.RotationYRange.s,  0.01, -100.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.RotationYRange.r = imgui.drag_float("Cam Shake RotationYRange Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.RotationYRange.r,  0.01, -100.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.RotationZRange.s = imgui.drag_float("Cam Shake RotationZRange Min", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.RotationZRange.s,  0.01, -100.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.RotationZRange.r = imgui.drag_float("Cam Shake RotationZRange Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.CameraShakeParam.Move.RotationZRange.r,  0.01, -100.0, 100.0); wc = wc or changed
                            --     end
                                                    
                            --     imgui.spacing()

                            --     if AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam then
                            --         if imgui.button("Reset ScopeParam Parameters") then
                            --             wc = true
                            --             AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam)
                            --         end

                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam._FOVMin = imgui.drag_float("Scope FOV Min", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam._FOVMin,  0.1, 0.0, 256.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam._FOVMax = imgui.drag_float("Scope FOV Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam._FOVMax,  0.1, 0.0, 256.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam.SpeedAtFovMin = imgui.drag_float("Scope Speed FOV Min", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam.SpeedAtFovMin,  1.0, 0.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam.SpeedAtFovMax = imgui.drag_float("Scope Speed FOV Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam.SpeedAtFovMax,  1.0, 0.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam.PCSpeedScale = imgui.drag_float("Scope PC Speed Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam.PCSpeedScale,  1.0, 0.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam.CameraJoint = imgui.input_text("Scope Camera Joint Name", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.ScopeParam.CameraJoint); wc = wc or changed
                            --     end

                            --     imgui.spacing()

                            --     if AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.HandShakeParam then
                            --         if imgui.button("Reset HandShakeParam Parameters") then
                            --             wc = true
                            --             AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.HandShakeParam = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].Catalog.HandShakeParam)
                            --         end

                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.HandShakeParam.Time = imgui.drag_float("Handshake Time", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.HandShakeParam.Time,  0.1, 0.0, 100.0); wc = wc or changed
                            --         changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.HandShakeParam.RStickOffset = imgui.drag_float("Handshake RStickOffset", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.HandShakeParam.RStickOffset,  0.1, 0.0, 100.0); wc = wc or changed
                            --     end
                            
                            --     -- imgui.spacing()

                            --     -- if AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam then
                            --     --     if imgui.button("Reset AdaptiveFeedBackParam Parameters") then
                            --     --         wc = true
                            --     --         AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam)
                            --     --     end

                            --     --     changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Left._Power = imgui.drag_float("AdaptiveFeedBackParam Left Power", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Left._Power,  0.1, 0.0, 100.0); wc = wc or changed
                            --     --     changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Left._Frequency = imgui.drag_float("AdaptiveFeedBackParam Left _Frequency", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Left._Frequency,  0.1, 0.0, 100.0); wc = wc or changed
                            --     --     changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Left.Range.s = imgui.drag_float("AdaptiveFeedBackParam Left Min", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Left.Range.s,  0.01, -100.0, 100.0); wc = wc or changed
                            --     --     changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Left.Range.r = imgui.drag_float("AdaptiveFeedBackParam Left Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Left.Range.r,  0.01, -100.0, 100.0); wc = wc or changed
                            --     --     changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Right._Power = imgui.drag_float("AdaptiveFeedBackParam Right Power", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Right._Power,  0.1, 0.0, 100.0); wc = wc or changed
                            --     --     changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Right._Frequency = imgui.drag_float("AdaptiveFeedBackParam Right _Frequency", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Right._Frequency,  0.1, 0.0, 100.0); wc = wc or changed
                            --     --     changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Right.Range.s = imgui.drag_float("AdaptiveFeedBackParam Right Min", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Right.Range.s,  0.01, -100.0, 100.0); wc = wc or changed
                            --     --     changed, AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Right.Range.r = imgui.drag_float("AdaptiveFeedBackParam Right Max", AWF_settings.RE4.Weapon_Params[weapon.ID].Catalog.AdaptiveFeedBackParam.Right.Range.r,  0.01, -100.0, 100.0); wc = wc or changed
                            --     -- end

                            --     imgui.spacing()

                            
                            imgui.spacing()
                            imgui.text_colored(ui.draw_line("=", 95) .. "|" , func.convert_rgba_to_AGBR(textColor))
                        end

                        imgui.tree_pop()
                    end

                    if weapon.isUseCustom and imgui.tree_node(weapon.Name .. ": Custom Stats") then
                        if imgui.begin_popup_context_item() then
                            if imgui.menu_item("Reset") then
                                wc = true
                                AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].CustomCatalog)
                            end
                            imgui.end_popup()
                        end
                        if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog then
                            
                            local upgradeLVL = AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog
                            local sortedKeys = {}

                            for i in pairs(upgradeLVL) do
                                table.insert(sortedKeys, i)
                            end
                            table.sort(sortedKeys)

                            for k, i in pairs(sortedKeys) do
                                if i:match("^Level_([1-9]%d*)$") then
                                    local j = i:match("%d+$")

                                    
                                    imgui.text_colored(ui.draw_line("=", 95) .. "|  [ LEVEL " .. j .. " ] " , func.convert_rgba_to_AGBR(textColor))
                                    imgui.spacing()
                                    if imgui.button("Reset Level " .. j .." Parameters") then
                                        wc = true
                                        AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i] = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].CustomCatalog[i])
                                    end

                                    if tonumber(j) == 1 then 
                                        if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DMG"] then
                                            imgui.drag_float("LVL-" .. j .. " Power", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DMG"]._BaseValue); wc = wc or changed
                                            imgui.input_text("LVL-" .. j .. " Power Info", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DMG"]._Info); wc = wc or changed
                                        end
                                        if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_WIN"] then
                                        imgui.drag_float("LVL-" .. j .. " Wince", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_WIN"]._BaseValue); wc = wc or changed
                                        end
                                        if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_BRK"] then
                                            imgui.drag_float("LVL-" .. j .. " Break", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_BRK"]._BaseValue); wc = wc or changed
                                        end
                                        if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_STP"] then
                                            imgui.drag_float("LVL-" .. j .. " Stopping Power", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_STP"]._BaseValue); wc = wc or changed
                                        end
                                    end

                                    if tonumber(j) > 1 then
                                        if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DMG"] then
                                            changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DMG"]._BaseValue = imgui.drag_float("LVL-" .. j .. " Power", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DMG"]._BaseValue, 0.01, -1.0, 10000.0); wc = wc or changed
                                            changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DMG"]._Cost = imgui.drag_int("LVL-" .. j .. " Power Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DMG"]._Cost, 100, 0, 1000000); wc = wc or changed
                                            changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DMG"]._Info = imgui.input_text("LVL-" .. j .. " Power Info", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DMG"]._Info); wc = wc or changed
                                        end
                                        if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_WIN"] then
                                            changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_WIN"]._BaseValue = imgui.drag_float("LVL-" .. j .. " Wince", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_WIN"]._BaseValue, 0.01, -1.0, 10000.0); wc = wc or changed
                                        end
                                        if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_BRK"] then
                                            changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_BRK"]._BaseValue = imgui.drag_float("LVL-" .. j .. " Break", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_BRK"]._BaseValue, 0.01, -1.0, 10000.0); wc = wc or changed
                                        end
                                        if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_STP"] then
                                            changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_STP"]._BaseValue = imgui.drag_float("LVL-" .. j .. " Stopping Power", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_STP"]._BaseValue, 0.01, -1.0, 10000.0); wc = wc or changed
                                        end
                                    end

                                    imgui.spacing()
                                    
                                    if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_AC"] then
                                        
                                        changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_AC"]._BaseValue = imgui.drag_int("LVL-" .. j .. " Ammo Capacity", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_AC"]._BaseValue, 1, -1, 10000); wc = wc or changed
                                        AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory.Define._AmmoMax = AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_1.LVL1_AC._BaseValue
                                        if tonumber(j) > 1 then
                                            changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_AC"]._Cost = imgui.drag_int("LVL-" .. j .. " Ammo Capacity Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_AC"]._Cost, 100, 0, 1000000); wc = wc or changed
                                        end
                                        changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_AC"]._Info = imgui.input_text("LVL-" .. j .. " Ammo Capacity Info", tostring(AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_AC"]._BaseValue)); wc = wc or changed
                                    end
                                    
                                    imgui.spacing()
                                    
                                    if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RS"] then
                                        changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RS"]._BaseValue = imgui.drag_float("LVL-" .. j .. " Reload Speed", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RS"]._BaseValue, 0.01, -1.0, 10000.0); wc = wc or changed
                                        AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam._ReloadSpeedRate = AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_1.LVL1_RS._BaseValue
                                        if tonumber(j) > 1 then
                                            changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RS"]._Cost = imgui.drag_int("LVL-" .. j .. " Reload Speed Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RS"]._Cost, 100, 0, 1000000); wc = wc or changed
                                        end
                                        changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RS"]._Info = imgui.input_text("LVL-" .. j .. " Reload Speed Info", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RS"]._Info); wc = wc or changed
                                    end

                                    if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RN"] then
                                        changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RN"]._BaseValue = imgui.drag_int("LVL-" .. j .. " Reload Number", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RN"]._BaseValue, 1, 0, 100); wc = wc or changed
                                        AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam.ReloadNum = AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_1.LVL1_RN._BaseValue
                                        if tonumber(j) > 1 then
                                            changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RN"]._Cost = imgui.drag_int("LVL-" .. j .. " Reload Number Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RN"]._Cost, 100, 0, 1000000); wc = wc or changed
                                        end
                                        changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RN"]._Info = imgui.input_text("LVL-" .. j .. " Reload Number Info", tostring(string.format("%.2f", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_RN"]._BaseValue))); wc = wc or changed
                                    end
                                    
                                    imgui.spacing()
                                    
                                    if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_ROF"] then
                                        changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_ROF"]._BaseValue = imgui.drag_float("LVL-" .. j .. " Rate of Fire", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_ROF"]._BaseValue, 0.01, -1.0, 10000.0); wc = wc or changed
                                        AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam._RapidSpeed = AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_1.LVL1_ROF._BaseValue
                                        if tonumber(j) > 1 then
                                            changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_ROF"]._Cost = imgui.drag_int("LVL-" .. j .. " Rate of Fire Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_ROF"]._Cost, 100, 0, 1000000); wc = wc or changed
                                        end
                                        changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_ROF"]._Info = imgui.input_text("LVL-" .. j .. " Rate of Fire Info", tostring(string.format("%.2f", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_ROF"]._Info))); wc = wc or changed
                                    
                                        --changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_ROF"]._Info = imgui.input_text("LVL-" .. j .. " Rate of Fire Info", tostring(string.format("%.2f", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_1.LVL1_ROF._BaseValue / AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_ROF"]._BaseValue))); wc = wc or changed
                                    end
                                    if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_PMP"] then
                                        changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_PMP"]._BaseValue = imgui.drag_float("LVL-" .. j .. " Pump Action Speed", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_PMP"]._BaseValue, 0.01, -1.0, 10000.0); wc = wc or changed
                                        AWF_settings.RE4.Weapon_Params[weapon.ID].BaseStats.WeaponStructureParam._PumpActionRapidSpeed = AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_1.LVL1_PMP._BaseValue
                                    end
                                    if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DUR"] then
                                        changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DUR"]._BaseValue = imgui.drag_int("LVL-" .. j .. " Durability", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DUR"]._BaseValue, 10, 0, 10000); wc = wc or changed
                                        AWF_settings.RE4.Weapon_Params[weapon.ID].Inventory.Define._DefaultDurabilityMax =  AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_1.LVL1_DUR._BaseValue

                                        changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DUR"]._Cost = imgui.drag_int("LVL-" .. j .. " Durability Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DUR"]._Cost, 100, 0, 1000000); wc = wc or changed
                                        changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DUR"]._Info = imgui.input_text("LVL-" .. j .. " Durability Info", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog[i]["LVL" .. j .."_DUR"]._Info); wc = wc or changed
                                    
                                    end
                                    imgui.spacing()
                                end
                            end

                            imgui.spacing()

                            if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX then
                                imgui.text_colored(ui.draw_line("=", 95) .. "|  [ LEVEL EX ] " , func.convert_rgba_to_AGBR(textColor))

                                if imgui.button("Reset Limit Break Parameters") then
                                    wc = true
                                    AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX)
                                end

                                if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXCRIT then
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXCRIT._CriticalRateNormalScale = imgui.drag_float("Critical Rate Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXCRIT._CriticalRateNormalScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Critical Rate multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXCRIT._CriticalRateFitScale = imgui.drag_float("Critical Rate Fit Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXCRIT._CriticalRateFitScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Critical Rate Fit multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXCRIT._Cost = imgui.drag_int("EX Upgrade Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXCRIT._Cost, 100, 0, 1000000); wc = wc or changed
                                end
                                if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXTHRU then
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXTHRU._ThroughNumNormal = imgui.drag_int("Piercing Rate Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXTHRU._ThroughNumNormal, 1, 0, 100); wc = wc or changed
                                    func.tooltip("Piercing Rate multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXTHRU._ThroughNumFit = imgui.drag_int("Piercing Rate Fit Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXTHRU._ThroughNumFit, 1, 0, 100); wc = wc or changed
                                    func.tooltip("Piercing Rate Fit multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXTHRU._Cost = imgui.drag_int("EX Upgrade Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXTHRU._Cost, 100, 0, 1000000); wc = wc or changed
                                end
                                if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMG then
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMG._DamageRateScale = imgui.drag_float("Damage Rate Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMG._DamageRateScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Damage Rate multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMG._WinceRateScale = imgui.drag_float("Wince Rate Fit Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMG._WinceRateScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Wince Rate multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMG._BreakRateScale = imgui.drag_float("Break Rate Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMG._BreakRateScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Break Rate multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMG._StoppingRateScale = imgui.drag_float("Stopping Rate Fit Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMG._StoppingRateScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Stopping Power Rate multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMG._Cost = imgui.drag_int("EX Upgrade Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMG._Cost, 100, 0, 1000000); wc = wc or changed
                                end
                                if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMGSG then
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMGSG._DamageRateScale = imgui.drag_float("Around Pellet Damage Rate Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMGSG._DamageRateScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Damage Rate multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMGSG._WinceRateScale = imgui.drag_float("Around Pellet Wince Rate Fit Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMGSG._WinceRateScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Wince Rate multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMGSG._BreakRateScale = imgui.drag_float("Around Pellet Break Rate Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMGSG._BreakRateScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Break Rate multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMGSG._StoppingRateScale = imgui.drag_float("Around Pellet Stopping Rate Fit Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMGSG._StoppingRateScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Stopping Power Rate multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMGSG._Cost = imgui.drag_int("EX Upgrade Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXDMGSG._Cost, 100, 0, 1000000); wc = wc or changed
                                end
                                if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXAC then
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXAC._AmmoMaxScale = imgui.drag_float("Ammo Capacity Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXAC._AmmoMaxScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Ammo Capacity multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXAC._ReloadNumScale = imgui.drag_float("Realod Number Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXAC._ReloadNumScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Realod Number multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXAC._Cost = imgui.drag_int("EX Upgrade Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXAC._Cost, 100, 0, 1000000); wc = wc or changed
                                end
                                if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXROF then
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXROF._RapidSpeedScale = imgui.drag_float("Rate of Fire Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXROF._RapidSpeedScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Rate of Fire multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXROF._Cost = imgui.drag_int("EX Upgrade Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXROF._Cost, 100, 0, 1000000); wc = wc or changed
                                end
                                if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXINF then
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXINF._IsOKReload = imgui.checkbox("Unlimited Ammo", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXINF._IsOKReload); wc = wc or changed
                                    func.tooltip("Unlimited Ammo")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXINF._Cost = imgui.drag_int("EX Upgrade Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXINF._Cost, 100, 0, 1000000); wc = wc or changed
                                end
                                if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXEXP then
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXEXP._BlastRangeScale = imgui.drag_float("Blast Range Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXEXP._BlastRangeScale, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Blast Range Scale multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXEXP._Cost = imgui.drag_int("EX Upgrade Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXEXP._Cost, 100, 0, 1000000); wc = wc or changed
                                end
                                if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXSPD then
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXSPD._CombatSpeed = imgui.drag_float("Combat Speed Scale", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXSPD._CombatSpeed, 0.01, 0.0, 100.0); wc = wc or changed
                                    func.tooltip("Combat Speed Scale multiplier. Higher is better.")
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXSPD._Cost = imgui.drag_int("EX Upgrade Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXSPD._Cost, 100, 0, 1000000); wc = wc or changed
                                end
                                if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXUNBRK then
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXUNBRK._IsUnbreakable = imgui.checkbox("Unbreakable", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXUNBRK._IsUnbreakable); wc = wc or changed
                                    changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXUNBRK._Cost = imgui.drag_int("EX Upgrade Cost", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.Level_EX.EXUNBRK._Cost, 100, 0, 1000000); wc = wc or changed
                                end
                            end
                        end
                        imgui.tree_pop()
                    end
                    
                    if weapon.isUseCustomPart and AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts then
                        if imgui.tree_node(weapon.Name .. ": Custom Part Stats") then
                            if imgui.begin_popup_context_item() then
                                if imgui.menu_item("Reset") then
                                    wc = true
                                    AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts)
                                end    
                                imgui.end_popup()
                            end

                            imgui.spacing()

                            if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts._RandomRadius_Fit then
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts._RandomRadius_Fit = imgui.drag_float("Custom Part: Random Radius Fit", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts._RandomRadius_Fit, 0.01, 0.0, 100.0); wc = wc or changed
                            end
                            if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts._ReticleGuiType then
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts._ReticleGuiType = imgui.combo("Custom Part: Reticle Type", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts._ReticleGuiType, RE4_Cache.reticleTypes); wc = wc or changed
                            end

                            imgui.spacing()

                            if AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam then
                                if imgui.button("Reset ReticleFitParam Parameters") then
                                    wc = true
                                    AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam = hk.recurse_def_settings({}, AWFWeapons.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam)
                                end
                                
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam._HoldAddPoint = imgui.drag_float("Custom Part: Hold Add Point", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam._HoldAddPoint,  1.0, 0.0, 10000.0); wc = wc or changed
                                func.tooltip("The amount of focus points added over time by standing still while aiming.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam._MoveSubPoint = imgui.drag_float("Custom Part: Move Sub Point", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam._MoveSubPoint,  1.0, 0.0, 10000.0); wc = wc or changed
                                func.tooltip("The amount of focus points subtracted for moving.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam._CameraSubPoint = imgui.drag_float("Custom Part: Camera Sub Point", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam._CameraSubPoint,  1.0, 0.0, 10000.0); wc = wc or changed
                                func.tooltip("The amount of focus points subtracted for moving the camera.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam._KeepFitLimitPoint = imgui.drag_float("Custom Part: Keep Fit Limit Point", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam._KeepFitLimitPoint,  1.0, 0.0, 10000.0); wc = wc or changed
                                func.tooltip("The amount of focus points required for the reticle to stay in focused state.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam._ShootSubPoint = imgui.drag_float("Custom Part: Shoot Sub Point", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam._ShootSubPoint,  1.0, 0.0, 10000.0); wc = wc or changed
                                func.tooltip("The amount of focus points subtracted for shooting.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam.PointRange.s = imgui.drag_float("Custom Part: Reticle Min Point", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam.PointRange.s,  1.0, -1000.0, 1000.0); wc = wc or changed
                                func.tooltip("The minimum range of focus points.")
                                changed, AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam.PointRange.r = imgui.drag_float("Custom Part: Reticle Max Point", AWF_settings.RE4.Weapon_Params[weapon.ID].CustomCatalog.CustomParts.ReticleFitParam.PointRange.r,  1.0, -1000.0, 1000.0); wc = wc or changed
                                func.tooltip("The maximum range of focus points.")
                            end
                            imgui.tree_pop()
                        end
                    end

                    if changed or wc then
                        weapon.isUpdated = true
                        weapon.isCatalogUpdated = true
                        weapon.isCustomCatalogUpdated = true
                        weapon.isInventoryUpdated = true
                        get_WeaponData_RE4(AWF_settings.RE4.Weapons)
                    end
                    imgui.indent(-10)
                    imgui.text_colored("  " .. ui.draw_line("=", 100) .."  ", func.convert_rgba_to_AGBR(textColor))
                    
                    imgui.end_rect(2)
                    imgui.tree_pop()
                end
                imgui.text_colored("  " .. ui.draw_line("-", 175) .."  ", 0xFFFFFFFF)
            end
        end
       
        imgui.end_rect(1)
        imgui.end_window()
    end
end

--Draws the Preset Manager GUI
local function draw_AWF_RE4Preset_GUI(weaponOrder)
    imgui.spacing()
    local weaponsByGame = {}
    local lastGame = nil

    for _, weaponName in ipairs(weaponOrder) do
        local weapon = AWF_settings.RE4.Weapons[weaponName]
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
        local weapon = AWF_settings.RE4.Weapons[weaponName]
        local textColor = {255,255,255,255}

        if weapon.Game == "Main" then
            textColor = {255, 187, 0, 255}
        elseif weapon.Game == "SW" then
            textColor = {245, 56, 81, 255}
        elseif weapon.Game == "Mercs" then
            textColor = {0, 255, 219, 255}
        end
    
        if weapon.Game ~= lastGame then
            imgui.text_colored(" " .. ui.draw_line("=", 60) .. " | " .. (gameModeLabels[weapon.Game] or weapon.Game) .. " ", func.convert_rgba_to_AGBR(textColor))
            lastGame = weapon.Game
        end

        if weapon and AWF_tool_settings.RE4[weapon.ID] then
            changed, AWF_settings.RE4.Weapon_Params[weapon.ID].current_param_indx = imgui.combo(weapon.Name, AWF_settings.RE4.Weapon_Params[weapon.ID].current_param_indx or 1, AWF_settings.RE4.Weapon_Params[weapon.ID].Weapon_Presets); wc = wc or changed
            if changed then
                local selected_preset = AWF_settings.RE4.Weapon_Params[weapon.ID].Weapon_Presets[AWF_settings.RE4.Weapon_Params[weapon.ID].current_param_indx]
                local json_filepath = [[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                local temp_params = json.load_file(json_filepath)
                
                if AWF_tool_settings.isInheritPresetName then
                    presetName = selected_preset
                end

                temp_params.Weapon_Presets = nil
                temp_params.current_param_indx = nil

                for key, value in pairs(temp_params) do
                    AWF_settings.RE4.Weapon_Params[weapon.ID][key] = value
                end
                cache_AWF_json_files_RE4(AWF_settings.RE4.Weapons)
                
                weapon.isUpdated = true
                weapon.isCatalogUpdated = true
                weapon.isCustomCatalogUpdated = true
                weapon.isInventoryUpdated = true
            end

            imgui.spacing()
        end
    end
    imgui.text_colored(ui.draw_line("=", 60), 0xFFFFFFFF)
end

--Draws the AWF GUI for the 'Script Generated UI' tab in the main REF Window
local function draw_AWF_RE4_GUI()
    if imgui.tree_node("Advanced Weapon Framework") then
        imgui.begin_rect()
        imgui.spacing()
        imgui.indent(5)

        if imgui.button("Reset to Defaults") then
            wc = true
            changed = true
            AWF_settings.RE4 = hk.recurse_def_settings({}, AWFWeapons.RE4)
            AWF_tool_settings = hk.recurse_def_settings({}, AWF_default_settings)
            for _, weapon in pairs(AWF_settings.RE4.Weapons) do
                weapon.isUpdated = true
                weapon.isCatalogUpdated = true
                weapon.isCustomCatalogUpdated = true
                weapon.isInventoryUpdated = true
                get_WeaponData_RE4(AWF_settings.RE4.Weapons)
            end
            cache_AWF_json_files_RE4(AWF_settings.RE4.Weapons)
        end
        func.tooltip("Reset every parameter.")
        
        imgui.same_line()
        changed, show_AWF_editor = imgui.checkbox("Open AWF Weapon Stat Editor", show_AWF_editor)
        func.tooltip("Show/Hide the AWF Weapon Stat Editor.")

        if not show_AWF_editor or imgui.begin_window("Advanced Weapon Framework: Weapon Stat Editor", true, 0) == false  then
            show_AWF_editor = false
        else
            imgui.spacing()
            imgui.indent()
            
            draw_AWF_RE4Editor_GUI(AWF_settings.RE4.Weapon_Order)
            
            imgui.unindent()
            imgui.end_window()
        end
        
        draw_AWF_RE4Preset_GUI(AWF_settings.RE4.Weapon_Order)

        if imgui.tree_node("AWF Settings") then
            imgui.begin_rect()
            imgui.spacing()
            imgui.indent(5)

            changed, AWF_tool_settings.isDebug = imgui.checkbox("Debug Mode", AWF_tool_settings.isDebug); wc = wc or changed
            func.tooltip("Enable/Disable debug mode. When enabled, AWF will log significantly more information in the 're2_framework_log.txt' file, located in the game's root folder.\nLeave this on if you don't know what you are doing.")
            changed, AWF_tool_settings.isInheritPresetName = imgui.checkbox("Inherit Preset Name", AWF_tool_settings.isInheritPresetName); wc = wc or changed
            func.tooltip("If enabled the '[Enter Preset Name Here]' text in the Weapon Stat Editor will be replaced by the name of the last loaded preset.")
            changed, AWF_tool_settings.isHideReticle = imgui.checkbox("Hide Weapon Reticles", AWF_tool_settings.isHideReticle); wc = wc or changed
            if AWF_tool_settings.isHideReticle and wc or changed then
                for _, weapon in pairs(AWF_settings.RE4.Weapons) do
                    weapon.isCatalogUpdated = true
                end
                get_WeaponData_RE4(AWF_settings.RE4.Weapons)
            elseif not AWF_tool_settings.isHideReticle and wc or changed then
                for _, weapon in pairs(AWF_settings.RE4.Weapons) do
                    weapon.isCatalogUpdated = true
                end
                get_WeaponData_RE4(AWF_settings.RE4.Weapons)
            end
            changed, AWF_tool_settings.RE4.isUnbreakable = imgui.checkbox("Unbreakable Knives", AWF_tool_settings.RE4.isUnbreakable); wc = wc or changed

            if imgui.tree_node("Display Settings") then
                local weaponsByGame = {}
                local lastGame = nil
                for _, weaponName in ipairs(AWF_settings.RE4.Weapon_Order) do
                    local weapon = AWF_settings.RE4.Weapons[weaponName]
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

                for gameMode, label in func.orderedPairs(gameModeLabels) do
                    if weaponsByGame[gameMode] then
                        if imgui.tree_node(label) then
                            for _, weapon in ipairs(weaponsByGame[gameMode]) do
                                changed, AWF_tool_settings.RE4[weapon.ID] = imgui.checkbox(weapon.Name, AWF_tool_settings.RE4[weapon.ID]); wc = wc or changed
                                func.tooltip("Show/Hide the " .. weapon.Name .. " in the Preset Manager.")
                            end
                            imgui.tree_pop()
                        end
                    end
                end
                imgui.tree_pop()
            end

            if imgui.tree_node("Credits") then
                imgui.text(modCredits .. " ")
                imgui.tree_pop()
            end
            
            imgui.indent(-5)
            imgui.spacing()
            imgui.end_rect(2)
            imgui.tree_pop()
        end
        
        ui.button_n_colored_txt("Current Version:", modVersion .. " | " .. modUpdated, func.convert_rgba_to_AGBR(0, 255, 0, 255))
        imgui.same_line()
        imgui.text("| by " .. modAuthor .. " ")
        
        if changed or wc or NowLoading then
            json.dump_file("AWF/AWF_Settings.json", AWF_settings)
            json.dump_file("AWF/AWF_ToolSettings.json", AWF_tool_settings)
            wc = false
            changed = false
        end

        imgui.spacing()
        imgui.indent(-5)
        imgui.end_rect(1)
        imgui.tree_pop()
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: RE7
local cached_weapon_GameObjects_RE7 = {}
local cached_ammo_GameObjects_RE7 = {}

local function dump_default_weapon_params_RE7(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWFWeapons.RE7.Weapon_Params[weapon.ID]
        
        if weaponParams then
            json.dump_file("AWF/AWF_Weapons/".. weapon.Name .. "/" .. weapon.Name .. " Default".. ".json", weaponParams)
            log.info("AWF Default Weapon Params Dumped")
        end
    end
end
local function cache_weapon_gameobjects_RE7(weaponData)
    for _, weapon in pairs(weaponData) do
        if weapon.isUpdated then
            local Weapon_GameObject_RE7 = scene:call("findGameObject(System.String)", weapon.ID)
            
            --Here we exclude all the 'Ammo' and 'Knife' GameObjects. 
            if weapon.Type ~= "Ammo" or weapon.Type ~= "KNF" then
                if Weapon_GameObject_RE7 then
                    cached_weapon_GameObjects_RE7[weapon.ID] = Weapon_GameObject_RE7
                    log.info("Cached " .. weapon.Name .. " Game Object")

                    --Main Game
                    local Weapon_Stats_RE7 = Weapon_GameObject_RE7:call("getComponent(System.Type)", sdk.typeof("app.WeaponGun"))

                    --Not A Hero
                    if not Weapon_Stats_RE7 then
                        Weapon_Stats_RE7 = Weapon_GameObject_RE7:call("getComponent(System.Type)", sdk.typeof("app.CH8WeaponGun"))
                    end

                    --End of Zoe
                    if not Weapon_Stats_RE7 then
                        Weapon_Stats_RE7 = Weapon_GameObject_RE7:call("getComponent(System.Type)", sdk.typeof("app.CH9WeaponGun"))
                    end

                    if Weapon_Stats_RE7 then
                        local weaponParams = AWF_settings.RE7.Weapon_Params[weapon.ID]

                        if weaponParams then
                            for paramName, paramValue in pairs(weaponParams) do
                                --Here we exclude the params that are not under WeaponGunParameter. 
                                if paramName ~= "Weapon_Presets" and paramName ~= "current_param_indx" and paramName ~= "LoadNum" then
                                    local Weapon_Params_RE7 = Weapon_Stats_RE7:get_field("WeaponGunParameter")
                                    
                                    if Weapon_Params_RE7 then
                                        Weapon_Params_RE7[paramName] = paramValue
                                    end
                                end

                                if paramName == "LoadNum" then
                                    local Weapon_BulletParams_RE7 = Weapon_Stats_RE7:get_field("CurrentBulletInfo")

                                    if Weapon_BulletParams_RE7 then
                                        Weapon_BulletParams_RE7[paramName] = paramValue
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
       
        if weapon.isUpdated then
            if weapon.Type == "Ammo" then
                local Ammo_GameObject_RE7 = scene:call("findGameObject(System.String)", weapon.ID)
                
                if Ammo_GameObject_RE7 then
                    cached_ammo_GameObjects_RE7[weapon.ID] = Ammo_GameObject_RE7
                    log.info("Cached " .. weapon.Name .. " Game Object")

                    local Ammo_Stats_RE7 = Ammo_GameObject_RE7:call("getComponent(System.Type)", sdk.typeof("app.Item"))

                    if Ammo_Stats_RE7 then
                        local ammoParams = AWF_settings.RE7.Ammo_Params[weapon.ID]

                        if ammoParams then
                            for paramName, paramValue in pairs(ammoParams) do
                                local Ammo_Params_RE7 = Ammo_Stats_RE7:get_field("_ItemData")
                                
                                if Ammo_Params_RE7 then
                                    Ammo_Params_RE7[paramName] = paramValue
                                end
                            end
                        end
                    end
                end
            end
        end
        weapon.isUpdated = false
    end
end
local function cache_json_files_RE7(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWF_settings.RE7.Weapon_Params[weapon.ID]
        
        if weaponParams then
            local json_names = AWF_settings.RE7.Weapon_Params[weapon.ID].Weapon_Presets or {}
            local json_filepaths = fs.glob([[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\.*.json]])
            
            if json_filepaths then
                for i, filepath in ipairs(json_filepaths) do
                    local name = filepath:match("^.+\\(.+)%.")
                    local nameExists = false
                    
                    for _, existingName in ipairs(json_names) do
                        if existingName == name then
                            nameExists = true
                            break
                        end
                    end
                    
                    if not nameExists then
                        log.info("Loaded " .. filepath .. " for " .. weapon.Name)
                        table.insert(json_names, 1, name)
                    end
                end
            else
                log.info("No JSON files found for " .. weapon.Name)
            end
        end
    end
end
if reframework.get_game_name() == "re7" then
    dump_default_weapon_params_RE7(AWFWeapons.RE7.Weapons)
    cache_json_files_RE7(AWF_settings.RE7.Weapons)
end
local function get_weapon_gameobject_RE7(weaponData)
    for _, weapon in pairs(weaponData) do
        local Weapon_GameObject_RE7 = cached_weapon_GameObjects_RE7[weapon.ID]
        
        if Weapon_GameObject_RE7 and weapon.isUpdated then
            log.info("Loaded " .. weapon.Name .. " Game Object from cache")
        end
    end
end
local function update_cached_weapon_gameobjects_RE7()
    if changed or wc or not cached_weapon_GameObjects_RE7 then
        changed = false
        wc = false
        AWF_Weapons_Found = true
        cache_weapon_gameobjects_RE7(AWF_settings.RE7.Weapons)
        get_weapon_gameobject_RE7(AWF_settings.RE7.Weapons)
        log.info("------------ AWF Weapon Data Updated!")
    end
end
local function draw_AWF_RE7Editor_GUI(weaponOrder)
    if imgui.begin_window("Advanced Weapon Framework") then
        imgui.begin_rect()
        imgui.button("[===============================| AWF WEAPON STAT EDITOR |===============================]")
        for _, weaponName in ipairs(weaponOrder) do
            local weaponData = AWF_settings.RE7.Weapons[weaponName]
            
            if weaponData and (weaponData.Type ~= "Ammo") and (weaponData.Type ~= "KNF") and imgui.tree_node(string.upper(weaponData.Name)) then
                imgui.begin_rect()
                if imgui.button("Reset to Defaults") then
                    wc = true
                    AWF_settings.RE7.Weapon_Params[weaponData.ID] = hk.recurse_def_settings({}, AWFWeapons.RE7.Weapon_Params[weaponData.ID])
                    cache_json_files_RE7(AWF_settings.RE7.Weapons)
                end
                func.tooltip("Reset the parameters of " .. weaponData.Name)

                imgui.same_line()
                imgui.button(" | ")

                imgui.same_line()
                if imgui.button("Update Preset List") then
                    cache_json_files_RE7(AWF_settings.RE7.Weapons)
                end         
                
                if imgui.button("SAVE") then
                    json.dump_file("AWF/AWF_Weapons/".. weaponData.Name .. "/" .. weaponData.Name .. " Custom".. ".json", AWF_settings.RE7.Weapon_Params[weaponData.ID])
                    log.info("AWF Custom " .. weaponData.Name ..  " Params Saved")
                end
                func.tooltip("Save the current parameters of the " .. weaponData.Name .. " to a .json file found in [RESIDENT EVIL 7  BIOHAZARD/reframework/data/AWF/AWF_Weapons/".. weaponData.Name .. "]")

                imgui.same_line()
                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].current_param_indx = imgui.combo("Preset", AWF_settings.RE7.Weapon_Params[weaponData.ID].current_param_indx or 1, AWF_settings.RE7.Weapon_Params[weaponData.ID].Weapon_Presets); wc = wc or changed
                func.tooltip("Select a file from the dropdown menu to load the weapon stats from that file.")
                if changed then
                    local selected_preset = AWF_settings.RE7.Weapon_Params[weaponData.ID].Weapon_Presets[AWF_settings.RE7.Weapon_Params[weaponData.ID].current_param_indx]
                    local json_filepath = [[AWF\\AWF_Weapons\\]] .. weaponData.Name .. [[\\]] .. selected_preset .. [[.json]]
                    local temp_params = json.load_file(json_filepath)
                    
                    temp_params.Weapon_Presets = nil
                    temp_params.current_param_indx = nil

                    for key, value in pairs(temp_params) do
                        AWF_settings.RE7.Weapon_Params[weaponData.ID][key] = value
                    end
                end

                imgui.spacing()

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].IsLoadNumInfinity = imgui.checkbox("Unlimited Capacity", AWF_settings.RE7.Weapon_Params[weaponData.ID].IsLoadNumInfinity); wc = wc or changed
                func.tooltip("If enabled, the weapon does not need to be reloaded.")
                
                imgui.same_line()
                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].IsBulletStackNumInfinity = imgui.checkbox("Unlimited Ammo", AWF_settings.RE7.Weapon_Params[weaponData.ID].IsBulletStackNumInfinity); wc = wc or changed
                func.tooltip("If enabled, the weapon will never run out of ammo.")

                imgui.spacing()

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].MaxLoadNum = imgui.drag_int("Ammo Capacity", AWF_settings.RE7.Weapon_Params[weaponData.ID].MaxLoadNum, 1, 0, 1000); wc = wc or changed
                func.tooltip("The maximum number of rounds of ammo the weapon can hold. Higher is better.")

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].Range = imgui.drag_float("Range", AWF_settings.RE7.Weapon_Params[weaponData.ID].Range, 1.0, -1000.0, 1000.0); wc = wc or changed
                func.tooltip("The effective range of the weapon. Higher is better.")

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].AttenuationStart = imgui.drag_float("Attenuation Start", AWF_settings.RE7.Weapon_Params[weaponData.ID].AttenuationStart, 1.0, 0.0, 1000.0); wc = wc or changed
                func.tooltip("Damage dropoff starts at this distance. Higher is better.")

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].AttenuationEnd = imgui.drag_float("Attenuation End", AWF_settings.RE7.Weapon_Params[weaponData.ID].AttenuationEnd, 1.0, 0.0, 1000.0); wc = wc or changed
                func.tooltip("Damage dropoff ends at this distance. Higher is better.")

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].MinAttenuationDamageRate = imgui.drag_float("Min Attenuation Damage Rate", AWF_settings.RE7.Weapon_Params[weaponData.ID].MinAttenuationDamageRate, 0.1, 0.0, 1000.0); wc = wc or changed
                func.tooltip("The minimum amount of damage that's dealt after damage dropoff. Higher is better.")

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].Radius = imgui.drag_float("Radius", AWF_settings.RE7.Weapon_Params[weaponData.ID].Radius, 0.01, 0.0, 1000.0); wc = wc or changed
                func.tooltip("Weapon spread. Lower is better.")

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].DiffusionNum = imgui.drag_int("Pellet Count", AWF_settings.RE7.Weapon_Params[weaponData.ID].DiffusionNum, 1, 0, 1000); wc = wc or changed
                func.tooltip("The number of pellets fired by a shotgun. Higher is better.")

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].DiffusionRadius = imgui.drag_float("Diffusion Radius", AWF_settings.RE7.Weapon_Params[weaponData.ID].DiffusionRadius, 0.01, 0.0, 1000.0); wc = wc or changed
                func.tooltip("Pellet spread for shotguns - Hipfire. Lower is better.")

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].AimDiffusionRadius = imgui.drag_float("Aim Diffusion Radius", AWF_settings.RE7.Weapon_Params[weaponData.ID].AimDiffusionRadius, 0.01, 0.0, 1000.0); wc = wc or changed
                func.tooltip("Pellet spread for shotguns - ADS. Lower is better.")

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].RecoilBurstInterval = imgui.drag_float("Recoil Burst Interval", AWF_settings.RE7.Weapon_Params[weaponData.ID].RecoilBurstInterval, 0.01, 0.0, 1000.0); wc = wc or changed
                func.tooltip("TBD")

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].RecoilBurstCount = imgui.drag_int("Recoil Burst Count", AWF_settings.RE7.Weapon_Params[weaponData.ID].RecoilBurstCount, 1, 0, 1000); wc = wc or changed
                func.tooltip("TBD")

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].RecoilYAngle = imgui.drag_float("Recoil Y Axis", AWF_settings.RE7.Weapon_Params[weaponData.ID].RecoilYAngle, 0.01, 0.0, 1000.0); wc = wc or changed
                func.tooltip("The amount the weapon recoils on the Y axis. Lower is better.")

                changed, AWF_settings.RE7.Weapon_Params[weaponData.ID].RecoilXAngle = imgui.drag_float("Recoil X Axis", AWF_settings.RE7.Weapon_Params[weaponData.ID].RecoilXAngle, 0.01, 0.0, 1000.0); wc = wc or changed
                func.tooltip("The amount the weapon recoils on the X axis. Lower is better.")
                
                imgui.end_rect(2)
                imgui.tree_pop()
            end
            
            if weaponData and weaponData.Type == "Ammo" and imgui.tree_node(string.upper(weaponData.Name)) then
                if imgui.button("Reset to Defaults") then
                    wc = true
                    AWF_settings.RE7.Weapon_Params[weaponData.ID] = hk.recurse_def_settings({}, AWFWeapons.RE7.Weapon_Params[weaponData.ID])
                    cache_json_files_RE7(AWF_settings.RE7.Weapons)
                end
                func.tooltip("Reset the parameters of " .. weaponData.Name)
                
                imgui.spacing()
                changed, AWF_settings.RE7.Ammo_Params[weaponData.ID].MaxStackNum = imgui.drag_int("Max Stack Limit", AWF_settings.RE7.Ammo_Params[weaponData.ID].MaxStackNum, 1, 0, 9999); wc = wc or changed
                
                imgui.tree_pop()
            end
            
            if changed or wc then
                weaponData.isUpdated = true
            end
            imgui.separator()
        end
    imgui.end_rect(1)
    imgui.end_window()
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: RE8
local cached_weapon_GameObjects_RE8 = {}
local RE8_Cache = {
    ItemModifier = sdk.typeof("app.ItemModifier"),
    ItemCore = "get_itemCore",
    Spec = "<spec>k__BackingField",
    Work = "<work>k__BackingField",
    CustomParam = "getCustomParameter",
}

local function dump_default_weapon_params_RE8(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWFWeapons.RE8.Weapon_Params[weapon.ID]
        
        if weaponParams then
            json.dump_file("AWF/AWF_Weapons/".. weapon.Name .. "/" .. weapon.Name .. " Default".. ".json", weaponParams)
            log.info("AWF Default Weapon Params Dumped")
        end
    end
end
local function cache_weapon_gameobjects_RE8(weaponData)
    for _, weapon in pairs(weaponData) do
        if weapon.isUpdated then
            local Weapon_GameObject_RE8 = scene:call("findGameObject(System.String)", weapon.ID)

            if Weapon_GameObject_RE8 then
                cached_weapon_GameObjects_RE8[weapon.ID] = Weapon_GameObject_RE8
                log.info("Cached " .. weapon.Name .. " Game Object")
                
                -- Main Game
                local Weapon_Stats_RE8 = Weapon_GameObject_RE8:call("getComponent(System.Type)", RE8_Cache.ItemModifier)

                if Weapon_Stats_RE8 then
                    local Weapon_ItemCore_RE8 = Weapon_Stats_RE8:call(RE8_Cache.ItemCore)

                    if Weapon_ItemCore_RE8 then
                        local weaponParams = AWF_settings.RE8.Weapon_Params[weapon.ID]

                        if weaponParams then
                            for paramName, paramValue in pairs(weaponParams) do
                                local Weapon_Spec_RE8 = Weapon_ItemCore_RE8:get_field(RE8_Cache.Spec)
                                local Weapon_Work_RE8 = Weapon_ItemCore_RE8:get_field(RE8_Cache.Work)
                                local Weapon_CustomParams_RE8 = Weapon_ItemCore_RE8:call(RE8_Cache.CustomParam)

                                local paramMaps = {
                                    DMG = "power",
                                    ROF = "burstSpeed",
                                    RS = "chargeSpeed",
                                    AC = "countOfMaxStackSize",
                                }                                
                                for customParamName in pairs(paramMaps) do
                                    local levelMap = {}
                                    
                                    for i = 1, 6 do
                                        levelMap[i - 1] = {
                                            level = "Level_" .. i,
                                            subParam = "LVL" .. i .. "_" .. customParamName,
                                        }
                                    end
                                
                                    local levelInfo = levelMap[weaponParams["Level_" .. customParamName]]
                                
                                    if weaponParams.CustomParts.customizeBarrel then
                                        if customParamName == "DMG" then
                                            Weapon_ItemCore_RE8.AttackPower = weaponParams[levelInfo.level][levelInfo.subParam].Value + weaponParams.BaseStats.Params.optionPower
                                            weaponParams.BaseStats.Params.optionPower = weaponParams.CustomParts.CustomStats.CustomDMG
                                        end
                                    elseif not weaponParams.CustomParts.customizeBarrel then
                                        if customParamName == "DMG" then
                                            Weapon_ItemCore_RE8.AttackPower = weaponParams[levelInfo.level][levelInfo.subParam].Value
                                            weaponParams.BaseStats.Params.optionPower = 0.0
                                        end
                                    end
                                    if weaponParams.CustomParts.customizeGrip then
                                        if customParamName == "ROF" then
                                            Weapon_ItemCore_RE8.ShootableTime = weaponParams[levelInfo.level][levelInfo.subParam].Value + weaponParams.BaseStats.Params.optionBurstSpeed
                                            weaponParams.BaseStats.Params.optionBurstSpeed = weaponParams.CustomParts.CustomStats.CustomROF
                                        end
                                    elseif not weaponParams.CustomParts.customizeGrip then
                                        if customParamName == "ROF" then
                                            Weapon_ItemCore_RE8.ShootableTime = weaponParams[levelInfo.level][levelInfo.subParam].Value
                                            weaponParams.BaseStats.Params.optionBurstSpeed = 0.0
                                        end
                                    end
                                    if weaponParams.CustomParts.customizeStock then
                                        if customParamName == "RS" then
                                            Weapon_ItemCore_RE8:set_field("<chargeTime>k__BackingField", weaponParams[levelInfo.level][levelInfo.subParam].Value + weaponParams.BaseStats.Params.optionChargeSpeed)
                                            weaponParams.BaseStats.Params.optionChargeSpeed = weaponParams.CustomParts.CustomStats.CustomRS
                                        end
                                    elseif not weaponParams.CustomParts.customizeStock then
                                        if customParamName == "RS" then
                                            Weapon_ItemCore_RE8:set_field("<chargeTime>k__BackingField", weaponParams[levelInfo.level][levelInfo.subParam].Value)
                                            weaponParams.BaseStats.Params.optionChargeSpeed = 0.0
                                        end
                                    end
                                    if weaponParams.CustomParts.customizeMagazine then
                                        if customParamName == "AC" then
                                            weaponParams.BaseStats.Params.countOfOptionMaxStackSize = weaponParams.CustomParts.CustomStats.CustomAC
                                        end
                                    elseif not weaponParams.CustomParts.customizeMagazine then
                                        if customParamName == "AC" then
                                            weaponParams.BaseStats.Params.countOfOptionMaxStackSize = 0
                                        end
                                    end
                                end                                
                                if AWF_tool_settings.isDebug then
                                    weaponParams.CurrentStats.DMG = Weapon_ItemCore_RE8.AttackPower
                                    weaponParams.CurrentStats.ROF = Weapon_ItemCore_RE8.ShootableTime
                                    weaponParams.CurrentStats.RS = Weapon_ItemCore_RE8:get_field("<chargeTime>k__BackingField")
                                end                                
                                if paramName == "BaseStats" then
                                    for subParamName, subParamValue in pairs(paramValue) do
                                        if Weapon_CustomParams_RE8 then
                                            if subParamName == "Params" then
                                                local paramMaps2 = {
                                                    DMG = "power",
                                                    ROF = "burstSpeed",
                                                    RS = "chargeSpeed",
                                                    AC = "countOfMaxStackSize",
                                                }
                                                
                                                for customParamName2, funcName in pairs(paramMaps2) do
                                                    local levelMap = {}
                                                    
                                                    for i = 1, 6 do
                                                        levelMap[i - 1] = {
                                                            level = "Level_" .. i,
                                                            subParam = "LVL" .. i .. "_" .. customParamName2,
                                                        }
                                                    end
                                                
                                                    local levelInfo = levelMap[weaponParams["Level_" .. customParamName2]]
                                                    
                                                    if levelInfo then
                                                        Weapon_CustomParams_RE8[func.isBKF(funcName)] = weaponParams[levelInfo.level][levelInfo.subParam].Value
                                                        Weapon_CustomParams_RE8["<optionPower>k__BackingField"] = weaponParams.BaseStats.Params.optionPower
                                                        Weapon_CustomParams_RE8["<optionBurstSpeed>k__BackingField"] = weaponParams.BaseStats.Params.optionBurstSpeed
                                                        Weapon_CustomParams_RE8["<optionChargeSpeed>k__BackingField"] = weaponParams.BaseStats.Params.optionChargeSpeed
                                                        Weapon_CustomParams_RE8["<countOfOptionMaxStackSize>k__BackingField"] = weaponParams.BaseStats.Params.countOfOptionMaxStackSize
                                                    end
                                                end
                                            end
                                        end
                                        if Weapon_Spec_RE8 then
                                            local Weapon_Spec_TradeParams_RE8 = Weapon_Spec_RE8:get_field("Trade")
                                            local Weapon_Spec_WeaponParams_RE8 = Weapon_Spec_RE8:get_field("Weapon")

                                            if subParamName == "GunSpecs" then
                                                if Weapon_Spec_WeaponParams_RE8 then
                                                    local Weapon_Spec_WeaponParams_Gun_RE8 = Weapon_Spec_WeaponParams_RE8:get_field("Gun")

                                                    for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                        Weapon_Spec_WeaponParams_Gun_RE8[subParamName_2nd] = subParamValue_2nd
                                                    end
                                                end
                                            end
                                            if subParamName == "Trade" then
                                                if Weapon_Spec_TradeParams_RE8 then
                                                    for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                        Weapon_Spec_TradeParams_RE8[subParamName_2nd] = subParamValue_2nd
                                                    end
                                                end
                                            end
                                        end
                                        if (subParamName == "stunRate") or (subParamName == "isPenetration") then
                                            Weapon_ItemCore_RE8[func.isBKF(subParamName)] = subParamValue
                                        end
                                    end
                                end
                                if paramName == "CustomParts" then
                                    if Weapon_Work_RE8 then
                                        local Weapon_Work_CustomPartsWorks_RE8 = Weapon_Work_RE8:get_field("CustomPartsWorks")
    
                                        if Weapon_Work_CustomPartsWorks_RE8 then
                                            local Weapon_Work_CustomPartsWorks_Items_RE8  = Weapon_Work_CustomPartsWorks_RE8:get_field("mItems")
                                            Weapon_Work_CustomPartsWorks_Items_RE8 = Weapon_Work_CustomPartsWorks_Items_RE8 and Weapon_Work_CustomPartsWorks_Items_RE8:get_elements() or {}
    
                                            for y in ipairs(Weapon_Work_CustomPartsWorks_Items_RE8) do
                                                local isCustomPartActive = Weapon_Work_CustomPartsWorks_Items_RE8[y]:call("get_isActive")

                                                if weapon.ID == "ri3008_Inventory" then
                                                    local customPartsMap = { [1] = "customizeBarrel", [2] = "customizeMagazine" }
                                                    
                                                    for y = 1, 2 do
                                                        weaponParams.CustomParts[customPartsMap[y]] = isCustomPartActive and true or false
                                                    end
                                                end
                                                if weapon.ID == "ri3021_Inventory" then
                                                    local customPartsMap = { [1] = "customizeStock", [2] = "customizeGrip" }
                                                    
                                                    for y = 1, 2 do
                                                        weaponParams.CustomParts[customPartsMap[y]] = isCustomPartActive and true or false
                                                    end
                                                end
                                                if weapon.ID == "ri3036_Inventory" then
                                                    local customPartsMap = { [1] = "", [2] = "customizeGrip" }
                                                    
                                                    for y = 1, 2 do
                                                        weaponParams.CustomParts[customPartsMap[y]] = isCustomPartActive and true or false
                                                    end
                                                end
                                                if weapon.ID == "ri3040_Inventory" then
                                                    local customPartsMap = { [1] = "customizeGrip", [2] = "customizeMagazine" }
                                                    
                                                    for y = 1, 2 do
                                                        weaponParams.CustomParts[customPartsMap[y]] = isCustomPartActive and true or false
                                                    end
                                                end
                                                if weapon.ID == "ri3042_Inventory" then
                                                    local customPartsMap = { [1] = "", [2] = "customizeMagazine", [3] = "customizeStock", }
                                                    
                                                    for y = 1, 3 do
                                                        weaponParams.CustomParts[customPartsMap[y]] = isCustomPartActive and true or false
                                                    end
                                                end
                                                if weapon.ID == "ri3046_Inventory" then
                                                    local customPartsMap = { [1] = "customizeBarrel", [2] = "customizeMagazine" }
                                                    
                                                    for y = 1, 2 do
                                                        weaponParams.CustomParts[customPartsMap[y]] = isCustomPartActive and true or false
                                                    end
                                                end
                                                if weapon.ID == "ri3047_Inventory" then
                                                    local customPartsMap = { [1] = "customizeBarrel", [2] = "customizeMagazine", [3] = "customizeStock", }
                                                    
                                                    for y = 1, 3 do
                                                        weaponParams.CustomParts[customPartsMap[y]] = isCustomPartActive and true or false
                                                    end
                                                end
                                                if weapon.ID == "ri3048_Inventory" then
                                                    local customPartsMap = { [1] = "customizeBarrel", [2] = "customizeGrip", [3] = "customizeMagazine", }
                                                    
                                                    for y = 1, 3 do
                                                        weaponParams.CustomParts[customPartsMap[y]] = isCustomPartActive and true or false
                                                    end
                                                end
                                                if weapon.ID == "ri3049_Inventory" then
                                                    local customPartsMap = { [1] = "customizeBarrel", [2] = "customizeGrip", }
                                                    
                                                    for y = 1, 2 do
                                                        weaponParams.CustomParts[customPartsMap[y]] = isCustomPartActive and true or false
                                                    end
                                                end
                                                if weapon.ID == "ri3050_Inventory" then
                                                    local customPartsMap = { [1] = "customizeBarrel", [2] = "customizeMagazine" }
                                                    
                                                    for y = 1, 2 do
                                                        weaponParams.CustomParts[customPartsMap[y]] = isCustomPartActive and true or false
                                                    end
                                                end                                       
                                            end
                                        end
                                    end
                                end
                                if Weapon_CustomParams_RE8 then
                                    local Weapon_LevelTracker_RE8 = Weapon_CustomParams_RE8:get_field("<customizedLevel>k__BackingField")

                                    if Weapon_LevelTracker_RE8 then
                                        local Weapon_CurrentLevels_RE8 = Weapon_LevelTracker_RE8:get_field("mItems")
                                        Weapon_CurrentLevels_RE8 = Weapon_CurrentLevels_RE8 and Weapon_CurrentLevels_RE8:get_elements() or {}

                                        for k in pairs(Weapon_CurrentLevels_RE8) do
                                            if Weapon_CurrentLevels_RE8[1] then
                                                local Weapon_CurrentLevels_Value_RE8 = Weapon_CurrentLevels_RE8[1]:get_field("mValue")
                                                weaponParams.Level_DMG = Weapon_CurrentLevels_Value_RE8
                                            end
                                            if Weapon_CurrentLevels_RE8[2] then
                                                local Weapon_CurrentLevels_Value_RE8 = Weapon_CurrentLevels_RE8[2]:get_field("mValue")
                                                weaponParams.Level_ROF = Weapon_CurrentLevels_Value_RE8
                                            end
                                            if Weapon_CurrentLevels_RE8[3] then
                                                local Weapon_CurrentLevels_Value_RE8 = Weapon_CurrentLevels_RE8[3]:get_field("mValue")
                                                weaponParams.Level_RS = Weapon_CurrentLevels_Value_RE8
                                            end
                                            if Weapon_CurrentLevels_RE8[4] then
                                                local Weapon_CurrentLevels_Value_RE8 = Weapon_CurrentLevels_RE8[4]:get_field("mValue")
                                                weaponParams.Level_AC = Weapon_CurrentLevels_Value_RE8
                                            end
                                        end
                                    end
                                end
                                if Weapon_Spec_RE8 then
                                    local Weapon_Spec_WeaponParams_RE8 = Weapon_Spec_RE8:get_field("Weapon")
                                    
                                    if Weapon_Spec_WeaponParams_RE8 then
                                        local Weapon_Spec_PerformanceParams_RE8 = Weapon_Spec_WeaponParams_RE8:get_field("Performance")
                                        
                                        if Weapon_Spec_PerformanceParams_RE8 then
                                            local Weapon_Spec_CustomCostUnits_RE8 = Weapon_Spec_PerformanceParams_RE8:get_field("CustomCostUnits")
                                            
                                            if Weapon_Spec_CustomCostUnits_RE8 then
                                                local Weapon_Spec_PerformanceCustomCostUnits_RE8 = Weapon_Spec_CustomCostUnits_RE8:get_field("mItems")
                                                Weapon_Spec_PerformanceCustomCostUnits_RE8 = Weapon_Spec_PerformanceCustomCostUnits_RE8 and Weapon_Spec_PerformanceCustomCostUnits_RE8:get_elements() or {}

                                                for i in pairs(Weapon_Spec_PerformanceCustomCostUnits_RE8) do
                                                    local Weapon_Spec_Units_RE8 = Weapon_Spec_PerformanceCustomCostUnits_RE8[i]:get_field("Units")
                                                    
                                                    if Weapon_Spec_Units_RE8 then
                                                        local Weapon_Spec_PerformanceCustomCostUnits_Units_RE8 = Weapon_Spec_Units_RE8:get_field("mItems")
                                                        Weapon_Spec_PerformanceCustomCostUnits_Units_RE8 = Weapon_Spec_PerformanceCustomCostUnits_Units_RE8 and Weapon_Spec_PerformanceCustomCostUnits_Units_RE8:get_elements() or {}
                                                        
                                                        for j in pairs(Weapon_Spec_PerformanceCustomCostUnits_Units_RE8) do
                                                            if paramName:match("^Level_([2-9]%d*)$") then
                                                                local k = paramName:match("%d+$")
                                                                local subParamMap = {[1] = "LVL" .. k .."_DMG", [2] = "LVL" .. k .. "_ROF", [3] = "LVL" .. k .. "_RS", [4] = "LVL" .. k .. "_AC"}
                                                                local subParamName = subParamMap[i]
                                                                
                                                                if subParamName and k-1 == j then
                                                                    for subParam, subParamValue in pairs(paramValue) do
                                                                        if subParam == subParamName then
                                                                            for subParamName_2nd, subParamValue_2nd in pairs(subParamValue) do
                                                                                if (subParamName_2nd == "Cost") or (subParamName_2nd == "Info") then
                                                                                    Weapon_Spec_PerformanceCustomCostUnits_Units_RE8[j][subParamName_2nd] = subParamValue_2nd
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
                                end
                            end
                        end
                    end
                end
            end
        end
        weapon.isUpdated = false
    end
end
local function cache_json_files_RE8(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWF_settings.RE8.Weapon_Params[weapon.ID]
        
        if weaponParams then
            local json_names = AWF_settings.RE8.Weapon_Params[weapon.ID].Weapon_Presets or {}
            local json_filepaths = fs.glob([[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\.*.json]])
            
            if json_filepaths then
                for i, filepath in ipairs(json_filepaths) do
                    local name = filepath:match("^.+\\(.+)%.")
                    local nameExists = false
                    
                    for _, existingName in ipairs(json_names) do
                        if existingName == name then
                            nameExists = true
                            break
                        end
                    end
                    
                    if not nameExists then
                        log.info("Loaded " .. filepath .. " for " .. weapon.Name)
                        table.insert(json_names, 1, name)
                    end
                end
            else
                log.info("No JSON files found for " .. weapon.Name)
            end
        end
    end
end
if reframework.get_game_name() == "re8" then
    dump_default_weapon_params_RE8(AWFWeapons.RE8.Weapons)
    cache_json_files_RE8(AWF_settings.RE8.Weapons)
end
local function get_weapon_gameobject_RE8(weaponData)
    for _, weapon in pairs(weaponData) do
        local Weapon_GameObject_RE8 = cached_weapon_GameObjects_RE8[weapon.ID]
        
        if Weapon_GameObject_RE8 and weapon.isUpdated then
            log.info("Loaded " .. weapon.Name .. " Game Object from cache")
        end
    end
end
local function update_cached_weapon_gameobjects_RE8()
    if changed or wc or not cached_weapon_GameObjects_RE8 then
        changed = false
        wc = false
        AWF_Weapons_Found = true
        cache_weapon_gameobjects_RE8(AWF_settings.RE8.Weapons)
        get_weapon_gameobject_RE8(AWF_settings.RE8.Weapons)
        log.info("------------ AWF Weapon Data Updated!")
    end
end
local function draw_AWF_RE8Editor_GUI(weaponOrder)
    if imgui.begin_window("Advanced Weapon Framework") then
        imgui.begin_rect()
        imgui.button("[===============================| AWF WEAPON STAT EDITOR |===============================]")
        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF_settings.RE8.Weapons[weaponName]

            if weapon and imgui.tree_node(string.upper(weapon.Name)) then
                imgui.begin_rect()
                if imgui.button("Reset to Defaults") then
                    wc = true
                    AWF_settings.RE8.Weapon_Params[weapon.ID] = hk.recurse_def_settings({}, AWFWeapons.RE8.Weapon_Params[weapon.ID])
                    cache_json_files_RE8(AWF_settings.RE8.Weapons)
                end
                func.tooltip("Reset the parameters of " .. weapon.Name)
                
                imgui.same_line()
                imgui.button(" | ")

                imgui.same_line()
                if imgui.button("Update Preset List") then
                    cache_json_files_RE8(AWF_settings.RE8.Weapons)
                end

                if imgui.button("Save Preset") then
                    json.dump_file("AWF/AWF_Weapons/".. weapon.Name .. "/" .. weapon.Name .. " Custom".. ".json", AWF_settings.RE8.Weapon_Params[weapon.ID])
                    log.info("AWF Custom " .. weapon.Name ..  " Params Saved")
                end
                func.tooltip("Save the current parameters of the " .. weapon.Name .. " to a .json file found in [Resident Evil Village BIOHAZARD VILLAGE/reframework/data/AWF/AWF_Weapons/".. weapon.Name .. "]")

                imgui.same_line()
                changed, AWF_settings.RE8.Weapon_Params[weapon.ID].current_param_indx = imgui.combo("Preset", AWF_settings.RE8.Weapon_Params[weapon.ID].current_param_indx or 1, AWF_settings.RE8.Weapon_Params[weapon.ID].Weapon_Presets); wc = wc or changed
                func.tooltip("Select a file from the dropdown menu to load the weapon stats from that file.")
                if changed then
                    local selected_preset = AWF_settings.RE8.Weapon_Params[weapon.ID].Weapon_Presets[AWF_settings.RE8.Weapon_Params[weapon.ID].current_param_indx]
                    local json_filepath = [[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                    local temp_params = json.load_file(json_filepath)
                    
                    temp_params.Weapon_Presets = nil
                    temp_params.current_param_indx = nil

                    for key, value in pairs(temp_params) do
                        AWF_settings.RE8.Weapon_Params[weapon.ID][key] = value
                    end
                end

                if AWF_tool_settings.isDebug then
                    ui.button_n_colored_txt("Current DMG:", AWF_settings.RE8.Weapon_Params[weapon.ID].CurrentStats.DMG, 0xFF00FF00)
                    imgui.same_line()
                    ui.button_n_colored_txt("Current DMG LVL:", AWF_settings.RE8.Weapon_Params[weapon.ID].Level_DMG + 1, 0xFF00FF00)
                    
                    ui.button_n_colored_txt("Current ROF:", AWF_settings.RE8.Weapon_Params[weapon.ID].CurrentStats.ROF, 0xFF00FF00)
                    imgui.same_line()
                    ui.button_n_colored_txt("Current ROF LVL:", AWF_settings.RE8.Weapon_Params[weapon.ID].Level_ROF + 1, 0xFF00FF00)

                    ui.button_n_colored_txt("Current RS:", AWF_settings.RE8.Weapon_Params[weapon.ID].CurrentStats.RS, 0xFF00FF00)
                    imgui.same_line()
                    ui.button_n_colored_txt("Current RS LVL:", AWF_settings.RE8.Weapon_Params[weapon.ID].Level_RS + 1, 0xFF00FF00)
                end

                imgui.spacing()

                if AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats then
                    if imgui.button("Reset Level 1 Parameters") then
                        wc = true
                        AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats = hk.recurse_def_settings({}, AWFWeapons.RE8.Weapon_Params[weapon.ID].BaseStats)
                        AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts = hk.recurse_def_settings({}, AWFWeapons.RE8.Weapon_Params[weapon.ID].CustomParts)
                        AWF_settings.RE8.Weapon_Params[weapon.ID].Level_1 = hk.recurse_def_settings({}, AWFWeapons.RE8.Weapon_Params[weapon.ID].Level_1)
                    end

                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.isPenetration = imgui.checkbox("Piercing", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.isPenetration); wc = wc or changed
                    imgui.same_line()
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.IsDiffusion = imgui.checkbox("Diffusion", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.IsDiffusion); wc = wc or changed

                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].Level_1.LVL1_DMG.Value = imgui.drag_float("LVL-1 Power", AWF_settings.RE8.Weapon_Params[weapon.ID].Level_1.LVL1_DMG.Value, 1.0, 0.0, 10000.0); wc = wc or changed
                    func.tooltip("The weapon's base damage. Higher is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].Level_1.LVL1_ROF.Value = imgui.drag_float("LVL-1 Rate of Fire", AWF_settings.RE8.Weapon_Params[weapon.ID].Level_1.LVL1_ROF.Value, 0.01, -10.0, 10.0); wc = wc or changed
                    func.tooltip("The weapon's base fire rate. Lower is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].Level_1.LVL1_RS.Value = imgui.drag_float("LVL-1 Reload Speed", AWF_settings.RE8.Weapon_Params[weapon.ID].Level_1.LVL1_RS.Value, 0.1, -100.0, 100.0); wc = wc or changed
                    func.tooltip("The weapon's base reload speed. Lower is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].Level_1.LVL1_AC.Value = imgui.drag_int("LVL-1 Ammo Capacity", AWF_settings.RE8.Weapon_Params[weapon.ID].Level_1.LVL1_AC.Value, 1, 0, 1000); wc = wc or changed
                    func.tooltip("The weapon's base ammo capacity. Higher is better.")
                    
                    imgui.spacing()

                    if AWF_tool_settings.isDebug then
                        changed, AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.customizeBarrel = imgui.checkbox("Enable EX DMG", AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.customizeBarrel); wc = wc or changed
                        imgui.same_line()
                        changed, AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.customizeGrip = imgui.checkbox("Enable EX ROF", AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.customizeGrip); wc = wc or changed
                        imgui.same_line()
                        changed, AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.customizeStock = imgui.checkbox("Enable EX RS", AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.customizeStock); wc = wc or changed
                        imgui.same_line()
                        changed, AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.customizeMagazine = imgui.checkbox("Enable EX AC", AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.customizeMagazine); wc = wc or changed
                    end

                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.CustomStats.CustomDMG = imgui.drag_float("EX Power", AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.CustomStats.CustomDMG, 1.0, 0.0, 10000.0); wc = wc or changed
                    func.tooltip("The additional damage obtained from a Custom Part:. Higher is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.CustomStats.CustomROF = imgui.drag_float("EX Rate of Fire", AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.CustomStats.CustomROF, 0.01, -10.0, 10.0); wc = wc or changed
                    func.tooltip("The reduction in fire rate obtained from a Custom Part:. Lower is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.CustomStats.CustomRS = imgui.drag_float("EX Reload Speed", AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.CustomStats.CustomRS, 0.01, -100.0, 100.0); wc = wc or changed
                    func.tooltip("The reduction in reload speed obtained from a Custom Part:. Lower is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.CustomStats.CustomAC = imgui.drag_int("EX Ammo Capacity", AWF_settings.RE8.Weapon_Params[weapon.ID].CustomParts.CustomStats.CustomAC, 1, 0, 1000); wc = wc or changed
                    func.tooltip("The additional ammo capacity obtained from a Custom Part:. Higher is better.")
                    
                    imgui.spacing()

                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.stunRate = imgui.drag_float("Stopping Power", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.stunRate, 1.0, 0.0, 1000.0); wc = wc or changed
                    func.tooltip("The weapon's base stopping power. Higher is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.Range = imgui.drag_float("Range", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.Range, 1.0, 0.0, 1000.0); wc = wc or changed
                    func.tooltip("The effective range of the weapon. Higher is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.AttenuationStart = imgui.drag_float("Attenuation Start", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.AttenuationStart, 1.0, 0.0, 1000.0); wc = wc or changed
                    func.tooltip("Damage dropoff starts at this distance. Higher is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.AttenuationStunStart = imgui.drag_float("Attenuation Stun Start", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.AttenuationStunStart, 1.0, 0.0, 1000.0); wc = wc or changed
                    func.tooltip("Stopping Power dropoff starts at this distance. Higher is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.Radius = imgui.drag_float("Radius", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.Radius, 0.01, 0.0, 10.0); wc = wc or changed
                    func.tooltip("Weapon spread. Lower is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.DiffusionNum = imgui.drag_int("Diffusion Num", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.DiffusionNum, 1, 0, 100); wc = wc or changed
                    func.tooltip("The number of pellets fired by a shotgun. Higher is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.DiffusionRadius = imgui.drag_float("Diffusion Radius", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.DiffusionRadius, 0.01, 0.0, 10.0); wc = wc or changed
                    func.tooltip("Pellet spread for shotguns. Lower is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.RecoilXAngle = imgui.drag_float("Recoil X Axis", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.RecoilXAngle, 0.01, -10.0, 10.0); wc = wc or changed
                    func.tooltip("The amount the weapon recoils on the X axis. Lower is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.RecoilYAngle = imgui.drag_float("Recoil Y Axis", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.RecoilYAngle, 0.01, -10.0, 10.0); wc = wc or changed
                    func.tooltip("The amount the weapon recoils on the Y axis. Lower is better.")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.RecoilBurstInterval = imgui.drag_float("Recoil Burst Interval", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.RecoilBurstInterval, 0.1, 0.0, 10.0); wc = wc or changed
                    func.tooltip("TBD")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.RecoilBurstCount = imgui.drag_int("Recoil Burst Count", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.RecoilBurstCount, 1, 0, 100); wc = wc or changed
                    func.tooltip("TBD")
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.DistancePerFrame = imgui.drag_float("Speed", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.GunSpecs.DistancePerFrame, 1.0, 0.0, 100.0); wc = wc or changed
                    func.tooltip("The velocity of the bullet. Higher is better.")
                    
                    imgui.spacing()

                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.Trade.SellPrice = imgui.drag_int("Sell Price", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.Trade.SellPrice, 100, 0, 10000000); wc = wc or changed
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.Trade.SellFullPrice = imgui.drag_int("Full Sell Price", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.Trade.SellFullPrice, 100, 0, 10000000); wc = wc or changed
                    changed, AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.Trade.UsedPrice = imgui.drag_int("Buyback Price", AWF_settings.RE8.Weapon_Params[weapon.ID].BaseStats.Trade.UsedPrice, 100, 0, 10000000); wc = wc or changed
                end

                imgui.spacing()

                if AWF_settings.RE8.Weapon_Params[weapon.ID] then
                    local upgradeLVL = AWF_settings.RE8.Weapon_Params[weapon.ID]
                    local sortedKeys = {}

                    for i in pairs(upgradeLVL) do
                        table.insert(sortedKeys, i)
                    end
                    table.sort(sortedKeys)

                    for k, i in pairs(sortedKeys) do
                        if i:match("^Level_([2-9]%d*)$") then
                            local j = i:match("%d+$")
                            
                            imgui.spacing()

                            if imgui.button("Reset Level " .. j .." Parameters") then
                                wc = true
                                AWF_settings.RE8.Weapon_Params[weapon.ID][i] = hk.recurse_def_settings({}, AWFWeapons.RE8.Weapon_Params[weapon.ID][i])
                            end
                            
                            if AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_DMG"] then
                                changed, AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_DMG"].Value = imgui.drag_float("LVL-" .. j .. " Power", AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_DMG"].Value, 1.0, 0.0, 10000.0); wc = wc or changed
                            end
                            if AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_ROF"] then
                                changed, AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_ROF"].Value = imgui.drag_float("LVL-" .. j .. " Rate of Fire", AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_ROF"].Value, 0.01, -10.0, 10.0); wc = wc or changed
                            end
                            if AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_RS"] then
                                changed, AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_RS"].Value = imgui.drag_float("LVL-" .. j .. " Reload Speed", AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_RS"].Value, 0.1, -100.0, 100.0); wc = wc or changed
                            end
                            if AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_AC"] then
                                changed, AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_AC"].Value = imgui.drag_int("LVL-" .. j .. " Ammo Capacity", AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_AC"].Value, 1, 0, 1000); wc = wc or changed
                            end

                            imgui.spacing()

                            if AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_DMG"] then
                                changed, AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_DMG"].Cost = imgui.drag_int("LVL-" .. j .. " Power Price", AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_DMG"].Cost, 100, 0.0, 10000000); wc = wc or changed
                            end
                            if AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_ROF"] then
                                changed, AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_ROF"].Cost = imgui.drag_int("LVL-" .. j .. " Rate of Fire Price", AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_ROF"].Cost, 100, 0.0, 10000000); wc = wc or changed
                            end
                            if AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_RS"] then
                                changed, AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_RS"].Cost = imgui.drag_int("LVL-" .. j .. " Reload Speed Price", AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_RS"].Cost, 100, 0.0, 10000000); wc = wc or changed
                            end
                            if AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_AC"] then
                                changed, AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_AC"].Cost = imgui.drag_int("LVL-" .. j .. " Ammo Capacity Price", AWF_settings.RE8.Weapon_Params[weapon.ID][i]["LVL" .. j .."_AC"].Cost, 100, 0.0, 10000000); wc = wc or changed
                            end
                        end
                    end
                end

                if changed or wc then
                    weapon.isUpdated = true
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
--MARK: On Draw UI
re.on_draw_ui(function()
    if reframework.get_game_name() == "re2" then
        draw_AWF_RE2_GUI()
    end
    if reframework.get_game_name() == "re3" then
        if imgui.tree_node("Advanced Weapon Framework") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_settings.RE3.Weapon_Params = hk.recurse_def_settings({}, AWFWeapons.RE3.Weapon_Params)
                cache_json_files_RE3(AWF_settings.RE3.Weapons)
            end
            func.tooltip("Reset every parameter.")
            
            changed, show_AWF_editor = imgui.checkbox("Open AWF Weapon Stat Editor", show_AWF_editor)
            func.tooltip("Show/Hide the AWF Weapon Stat Editor.")

            if show_AWF_editor then
                draw_AWF_RE3Editor_GUI(AWF_settings.RE3.Weapon_Order)
            end

            if changed or wc or NowLoading then
                json.dump_file("AWF/AWF_Settings.json", AWF_settings)
            end
            
            ui.button_n_colored_txt("Current Version:", "v1.8.0 | 03/05/2024", 0xFF00FF00)
            imgui.same_line()
            imgui.text("| by SilverEzredes")
            
            imgui.end_rect(2)
            imgui.tree_pop()
        end
    end
    if reframework.get_game_name() == "re4" then
        draw_AWF_RE4_GUI()
    end
    if reframework.get_game_name() == "re7" then
        if imgui.tree_node("Advanced Weapon Framework") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_settings.RE7.Weapon_Params = hk.recurse_def_settings({}, AWFWeapons.RE7.Weapon_Params)
                cache_json_files_RE7(AWF_settings.RE7.Weapons)
            end
            func.tooltip("Reset every parameter.")

            changed, show_AWF_editor = imgui.checkbox("Open AWF Weapon Stat Editor", show_AWF_editor)
            func.tooltip("Show/Hide the AWF Weapon Stat Editor.")

            if show_AWF_editor then
                draw_AWF_RE7Editor_GUI(AWFWeapons.RE7.Weapon_Order)
            end

            if changed or wc or NowLoading then
                json.dump_file("AWF/AWF_Settings.json", AWF_settings)
            end

            ui.button_n_colored_txt("Current Version:", "v1.8.0 | 03/05/2024", 0xFF00FF00)
            imgui.same_line()
            imgui.text("| by SilverEzredes")
            imgui.end_rect(2)
            imgui.tree_pop()
        end
    end
    if reframework.get_game_name() == "re8" then
        if imgui.tree_node("Advanced Weapon Framework") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_settings.RE8.Weapon_Params = hk.recurse_def_settings({}, AWFWeapons.RE8.Weapon_Params)
                cache_json_files_RE8(AWF_settings.RE8.Weapons)
            end
            func.tooltip("Reset every parameter.")
            
            imgui.same_line()
            changed, AWF_tool_settings.isDebug = imgui.checkbox("AWF_tool_settings.isDebug", AWF_tool_settings.isDebug)
            func.tooltip("Enable/Disable Debug Mode.")

            changed, show_AWF_editor = imgui.checkbox("Open AWF Weapon Stat Editor", show_AWF_editor)
            func.tooltip("Show/Hide the AWF Weapon Stat Editor.")

            if show_AWF_editor then
                draw_AWF_RE8Editor_GUI(AWF_settings.RE8.Weapon_Order)
            end

            if changed or wc or NowLoading then
                json.dump_file("AWF/AWF_Settings.json", AWF_settings)
            end
            
            ui.button_n_colored_txt("Current Version:", "v1.8.0 | 03/05/2024", 0xFF00FF00)
            imgui.same_line()
            imgui.text("| by SilverEzredes")
            
            imgui.end_rect(2)
            imgui.tree_pop()
        end
    end
end)

--Functions that are accessible outside of this script
return {
    AWF_Master = AWFWeapons,
    AWF_settings = AWF_settings,

    get_WeaponData_RE2 = get_WeaponData_RE2,
    update_WeaponData_RE2 = update_WeaponData_RE2,
    check_if_WeaponDataIsCached_RE2 = check_if_WeaponDataIsCached_RE2,
    cache_AWF_json_files_RE2 = cache_AWF_json_files_RE2,
    
    update_cached_weapon_gameobjects_RE3 = update_cached_weapon_gameobjects_RE3,
    cache_weapon_gameobjects_RE3 = cache_weapon_gameobjects_RE3,
    get_weapon_gameobject_RE3 = get_weapon_gameobject_RE3,

    update_WeaponData_RE4 = update_WeaponData_RE4,
    get_WeaponData_RE4 = get_WeaponData_RE4,
    check_if_WeaponDataIsCached_RE4 = check_if_WeaponDataIsCached_RE4,
    cache_AWF_json_files_RE4 = cache_AWF_json_files_RE4,
    
    update_cached_weapon_gameobjects_RE7 = update_cached_weapon_gameobjects_RE7,
    cache_weapon_gameobjects_RE7 = cache_weapon_gameobjects_RE7,
    get_weapon_gameobject_RE7 = get_weapon_gameobject_RE7,

    update_cached_weapon_gameobjects_RE8 = update_cached_weapon_gameobjects_RE8,
    cache_weapon_gameobjects_RE8 = cache_weapon_gameobjects_RE8,
    get_weapon_gameobject_RE8 = get_weapon_gameobject_RE8,
}