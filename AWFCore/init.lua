--/////////////////////////////////////--
-- Advanced Weapon Framework Core

-- Author: SilverEzredes
-- Updated: 12/25/2023
-- Version: v1.3.1
-- Special Thanks to: praydog; alphaZomega; MrBoobieBuyer; Lotiuss

--/////////////////////////////////////--
local func = require("_SharedCore/Functions")
local hk = require("_SharedCore/Hotkeys")

local show_AWF_editor = false
local scene = func.get_CurrentScene()
local changed = false
local wc = false

local cached_weapon_GameObjects_RE7 = {}
local cached_ammo_GameObjects_RE7 = {}
AWF_Weapons_Found = false

local AWFWeapons = {
    RE7_Weapons = {
        M19 = {ID = "wp1010_Handgun_Item", Name = "M19 Handgun", Type = "HG"},
        M21 = {ID = "wp1030_Shotgun_Item", Name = "M21 Shotgun", Type = "SG"},
        BR = {ID = "wp1000_GasBurner_Item", Name = "Burner", Type = "FT"},
        GL = {ID = "wp1110_PortableCannon_Item", Name = "Grenade Launcher", Type = "GL"},
        MAG44 = {ID = "wp1140_Magnum_Item", Name = "44 MAG", Type = "MAG"},
        P19 = {ID = "wp1160_MachineGun_Item", Name = "P19 Machine Gun", Type = "SMG"},
        G17 = {ID = "wp1210_Handgun_Item", Name = "G17 Handgun", Type = "HG"},
        M37 = {ID = "wp1230_PumpShotgun_Item", Name = "M37 Shotgun", Type = "SG"},
        MPM = {ID = "wp1240_MiaHandgun_Item", Name = "MPM Handgun", Type = "HG"},
        AW01 = {ID = "wp1340_ChrisHandgun_Item", Name = "Samurai Edge - AW Model-01", Type = "HG"},
        AW02 = {ID = "wp1330_ChrisShotgun_Item", Name = "Thor's Hammer - AW Model-02", Type = "SG"},
        AW01R = {ID = "wp1340_ChrisHandgun_Reward_Item", Name = "Albert-01R", Type = "HG"},
        M21EOZ = {ID = "wp1033_Shotgun_Item", Name = "M21 Shotgun - End of Zoe", Type = "SG"},
        ---------------------------------------------------------------------------------------------
        KNF_E = {ID = "wp1190_Knife_Item", Name = "Knife - Ethan", Type = "KNF"},
        KNF_M = {ID = "wp1360_MiaKnife_Item", Name = "Knife - Mia", Type = "KNF"},
        KNF_C = {ID = "wp1390_ChrisKnife_Item", Name = "Knife - Chris", Type = "KNF"},
        ---------------------------------------------------------------------------------------------
        FT_Ammo = {ID = "wp1001_GasCan_Item", Name = "Burner Fuel", Type = "Ammo"},
        HG_Ammo = {ID = "wp1011_HandgunBullet_Item", Name = "Handgun Ammo", Type = "Ammo"},
        EX_HG_Ammo = {ID = "wp1013_HandgunBulletStrong_Item", Name = "Enhanced Handgun Ammo", Type = "Ammo"},
        SG_Ammo = {ID = "wp1031_ShotgunBullet_Item", Name = "Shotgun Shells", Type = "Ammo"},
        GL_F_Ammo = {ID = "wp1111_FlameBullet_Item", Name = "Flame Rounds", Type = "Ammo"},
        GL_A_Ammo = {ID = "wp1112_AcidBullet_Item", Name = "Neuro Rounds", Type = "Ammo"},
        MAG_Ammo = {ID = "wp1141_MagnumBullet_Item", Name = "Magnum Ammo", Type = "Ammo"},
        SMG_Ammo = {ID = "wp1161_MachineGunBullet_Item", Name = "Machine Gun Ammo", Type = "Ammo"},
    },
    RE7_Weapon_Params = {
        wp1010_Handgun_Item = {
            Weapon_Profiles = {},
            current_param_indx = 1,
            LoadNum = 7,
            MaxLoadNum = 7,
            IsLoadNumInfinity = false,
            IsBulletStackNumInfinity = false,
            Range = 100.0,
            AttenuationStart = 30.0,
            AttenuationEnd = 50.0,
            MinAttenuationDamageRate = 0.5,
            Radius = 0.03,
            DiffusionNum = 0,
            DiffusionRadius = 0.0,
            AimDiffusionRadius = 0.0,
            RecoilBurstInterval = 0.1,
            RecoilBurstCount = 3,
            RecoilYAngle = 0.0,
            RecoilXAngle = 0.0,
        },
        wp1030_Shotgun_Item = {
            Weapon_Profiles = {},
            current_param_indx = 1,
            MaxLoadNum = 2,
            IsLoadNumInfinity = false,
            IsBulletStackNumInfinity = false,
            Range = 100.0,
            AttenuationStart = 20.0,
            AttenuationEnd = 30.0,
            MinAttenuationDamageRate = 0.5,
            Radius = 0.05,
            DiffusionNum = 7,
            DiffusionRadius = 0.08,
            AimDiffusionRadius = 0.05,
            RecoilBurstInterval = 0.5,
            RecoilBurstCount = 0,
            RecoilYAngle = 2.0,
            RecoilXAngle = 0.5
        },
        wp1000_GasBurner_Item = {
            Weapon_Profiles = {},
            current_param_indx = 1,
            MaxLoadNum = 150,
            IsLoadNumInfinity = false,
            IsBulletStackNumInfinity = false,
            Range = 5.0,
            AttenuationStart = 1.0,
            AttenuationEnd = 5.0,
            MinAttenuationDamageRate = 0.8,
            Radius = 0.2,
            DiffusionNum = 0,
            DiffusionRadius = 0.0,
            AimDiffusionRadius = 0.0,
            RecoilBurstInterval = 0.1,
            RecoilBurstCount = 3,
            RecoilYAngle = 0.0,
            RecoilXAngle = 0.0
        },
        wp1110_PortableCannon_Item = {
            Weapon_Profiles = {},
            current_param_indx = 1,
            MaxLoadNum = 1,
            IsLoadNumInfinity = false,
            IsBulletStackNumInfinity = false,
            Range = 100.0,
            AttenuationStart = 30.0,
            AttenuationEnd = 50.0,
            MinAttenuationDamageRate = 0.5,
            Radius = 0.05,
            DiffusionNum = 0,
            DiffusionRadius = 0.0,
            AimDiffusionRadius = 0.0,
            RecoilBurstInterval = 0.1,
            RecoilBurstCount = 3,
            RecoilYAngle = 0.0,
            RecoilXAngle = 0.0
        },
        wp1140_Magnum_Item = {
            Weapon_Profiles = {},
            current_param_indx = 1,
            MaxLoadNum = 7,
            IsLoadNumInfinity = false,
            IsBulletStackNumInfinity = false,
            Range = 100.0,
            AttenuationStart = 30.0,
            AttenuationEnd = 50.0,
            MinAttenuationDamageRate = 0.5,
            Radius = 0.15,
            DiffusionNum = 0,
            DiffusionRadius = 0.0,
            AimDiffusionRadius = 0.0,
            RecoilBurstInterval = 0.1,
            RecoilBurstCount = 3,
            RecoilYAngle = 0.0,
            RecoilXAngle = 0.0
        },
        wp1160_MachineGun_Item = {
            Weapon_Profiles = {},
            current_param_indx = 1,
            MaxLoadNum = 64,
            IsLoadNumInfinity = false,
            IsBulletStackNumInfinity = false,
            Range = 100.0,
            AttenuationStart = 30.0,
            AttenuationEnd = 50.0,
            MinAttenuationDamageRate = 0.5,
            Radius = 0.125,
            DiffusionNum = 0,
            DiffusionRadius = 0.0,
            AimDiffusionRadius = 0.0,
            RecoilBurstInterval = 0.3,
            RecoilBurstCount = 1,
            RecoilYAngle = 1.750,
            RecoilXAngle = 0.5
        },
        wp1210_Handgun_Item = {
            Weapon_Profiles = {},
            current_param_indx = 1,
            MaxLoadNum = 10,
            IsLoadNumInfinity = false,
            IsBulletStackNumInfinity = false,
            Range = 100.0,
            AttenuationStart = 30.0,
            AttenuationEnd = 50.0,
            MinAttenuationDamageRate = 0.5,
            Radius = 0.05,
            DiffusionNum = 0,
            DiffusionRadius = 0.0,
            AimDiffusionRadius = 0.0,
            RecoilBurstInterval = 0.01,
            RecoilBurstCount = 3,
            RecoilYAngle = 0.0,
            RecoilXAngle = 0.0
        },
        wp1230_PumpShotgun_Item = {
            Weapon_Profiles = {},
            current_param_indx = 1,
            MaxLoadNum = 4,
            IsLoadNumInfinity = false,
            IsBulletStackNumInfinity = false,
            Range = 100.0,
            AttenuationStart = 20.0,
            AttenuationEnd = 30.0,
            MinAttenuationDamageRate = 0.5,
            Radius = 0.05,
            DiffusionNum = 7,
            DiffusionRadius = 0.15,
            AimDiffusionRadius = 0.12,
            RecoilBurstInterval = 0.1,
            RecoilBurstCount = 1,
            RecoilYAngle = 0.0,
            RecoilXAngle = 0.0
        },
        wp1240_MiaHandgun_Item = {
            Weapon_Profiles = {},
            current_param_indx = 1,
            MaxLoadNum = 9,
            IsLoadNumInfinity = false,
            IsBulletStackNumInfinity = false,
            Range = 100.0,
            AttenuationStart = 30.0,
            AttenuationEnd = 50.0,
            MinAttenuationDamageRate = 0.5,
            Radius = 0.06,
            DiffusionNum = 0,
            DiffusionRadius = 0.0,
            AimDiffusionRadius = 0.0,
            RecoilBurstInterval = 0.1,
            RecoilBurstCount = 3,
            RecoilYAngle = 0.0,
            RecoilXAngle = 0.0
        },
        wp1330_ChrisShotgun_Item = {
            Weapon_Profiles = {},
            current_param_indx = 1,
            MaxLoadNum = 12,
            IsLoadNumInfinity = false,
            IsBulletStackNumInfinity = false,
            Range = 100.0,
            AttenuationStart = 5.0,
            AttenuationEnd = 30.0,
            MinAttenuationDamageRate = 0.5,
            Radius = 0.05,
            DiffusionNum = 4,
            DiffusionRadius = 0.2,
            AimDiffusionRadius = 0.2,
            RecoilBurstInterval = 0.5,
            RecoilBurstCount = 1,
            RecoilYAngle = 2.0,
            RecoilXAngle = 0.5
        },
        wp1340_ChrisHandgun_Item = {
            Weapon_Profiles = {},
            current_param_indx = 1,
            MaxLoadNum = 9,
            IsLoadNumInfinity = false,
            IsBulletStackNumInfinity = false,
            Range = 100.0,
            AttenuationStart = 30.0,
            AttenuationEnd = 50.0,
            MinAttenuationDamageRate = 0.5,
            Radius = 0.05,
            DiffusionNum = 0,
            DiffusionRadius = 0.5,
            AimDiffusionRadius = 0.0,
            RecoilBurstInterval = 0.1,
            RecoilBurstCount = 3,
            RecoilYAngle = 0.0,
            RecoilXAngle = 0.0
        },
        wp1340_ChrisHandgun_Reward_Item = {
            Weapon_Profiles = {},
            current_param_indx = 1,
            MaxLoadNum = 3,
            IsLoadNumInfinity = false,
            IsBulletStackNumInfinity = false,
            Range = 100.0,
            AttenuationStart = 30.0,
            AttenuationEnd = 50.0,
            MinAttenuationDamageRate = 0.5,
            Radius = 0.01,
            DiffusionNum = 0,
            DiffusionRadius = 0.0,
            AimDiffusionRadius = 0.0,
            RecoilBurstInterval = 0.1,
            RecoilBurstCount =3,
            RecoilYAngle = 0.0,
            RecoilXAngle = 0.0
        },
        wp1033_Shotgun_Item = {
            Weapon_Profiles = {},
            current_param_indx = 1,
            MaxLoadNum = 2,
            IsLoadNumInfinity = false,
            IsBulletStackNumInfinity = false,
            Range = 100.0,
            AttenuationStart = 20.0,
            AttenuationEnd = 30.0,
            MinAttenuationDamageRate = 0.5,
            Radius = 0.05,
            DiffusionNum = 7,
            DiffusionRadius = 0.08,
            AimDiffusionRadius = 0.05,
            RecoilBurstInterval = 0.5,
            RecoilBurstCount = 0,
            RecoilYAngle = 2.0,
            RecoilXAngle = 0.5
        },
    },
    RE7_Ammo_Params = {
        wp1001_GasCan_Item = {
            MaxStackNum = 500,
            --ItemStackNum = 0,
            --SlotSize = 1,
            --CanStoreItembox = true,
        },
        wp1011_HandgunBullet_Item = {
            MaxStackNum = 30,
            --ItemStackNum = 0,
            --SlotSize = 1,
            --CanStoreItembox = true,
        },
        wp1013_HandgunBulletStrong_Item = {
            MaxStackNum = 20,
            --ItemStackNum = 0,
            --SlotSize = 1,
            --CanStoreItembox = true,
        },
        wp1031_ShotgunBullet_Item = {
            MaxStackNum = 30,
            --ItemStackNum = 0,
            --SlotSize = 1,
            --CanStoreItembox = true,
        },
        wp1111_FlameBullet_Item = {
            MaxStackNum = 5,
            --ItemStackNum = 0,
            --SlotSize = 1,
            --CanStoreItembox = true,
        },
        wp1112_AcidBullet_Item = {
            MaxStackNum = 5,
            --ItemStackNum = 0,
            --SlotSize = 1,
            --CanStoreItembox = true,
        },
        wp1141_MagnumBullet_Item = {
            MaxStackNum = 20,
            --ItemStackNum = 0,
            --SlotSize = 1,
            --CanStoreItembox = true,
        },
        wp1161_MachineGunBullet_Item = {
            MaxStackNum = 300,
            --ItemStackNum = 0,
            --SlotSize = 1,
            --CanStoreItembox = true,
        },
    },
    RE7_Weapon_Order = {
        "G17",
        "M19",
        "MPM",
        "AW01R",
        "MAG44",
        "M21",
        "M21EOZ",
        "M37",
        "P19",
        "BR",
        "GL",
        "AW01",
        "AW02",
        "KNF_E",
        "KNF_M",
        "KNF_C",
        "HG_Ammo",
        "EX_HG_Ammo",
        "SG_Ammo",
        "MAG_Ammo",
        "SMG_Ammo",
        "GL_F_Ammo",
        "GL_A_Ammo",
        "FT_Ammo",
    },
}

local function dump_default_weapon_params_RE7(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWFWeapons.RE7_Weapon_Params[weapon.ID]
        
        if weaponParams then
            json.dump_file("AWF/AWF_Weapons/".. weapon.Name .. "/" .. weapon.Name .. " Default".. ".json", weaponParams)
            log.info("AWF Default Weapon Params Dumped")
        end
    end
end

dump_default_weapon_params_RE7(AWFWeapons.RE7_Weapons)

local AWF_settings = hk.merge_tables({}, AWFWeapons) and func.recurse_def_settings(json.load_file("AWF/AWF_Settings.json") or {}, AWFWeapons)

local function cache_weapon_gameobjects_RE7(weaponData)
    for _, weapon in pairs(weaponData) do
        local Weapon_GameObject_RE7 = scene:call("findGameObject(System.String)", weapon.ID)
       
        if weapon.Type ~= "Ammo" or weapon.Type ~= "KNF" then
            if Weapon_GameObject_RE7 then
                cached_weapon_GameObjects_RE7[weapon.ID] = Weapon_GameObject_RE7
                log.info("Cached " .. weapon.Name .. " Game Object")

                local Weapon_Stats_RE7 = Weapon_GameObject_RE7:call("getComponent(System.Type)", sdk.typeof("app.WeaponGun"))

                if not Weapon_Stats_RE7 then
                    Weapon_Stats_RE7 = Weapon_GameObject_RE7:call("getComponent(System.Type)", sdk.typeof("app.CH8WeaponGun"))
                end

                if not Weapon_Stats_RE7 then
                    Weapon_Stats_RE7 = Weapon_GameObject_RE7:call("getComponent(System.Type)", sdk.typeof("app.CH9WeaponGun"))
                end

                if Weapon_Stats_RE7 then
                    local weaponParams = AWF_settings.RE7_Weapon_Params[weapon.ID]

                    if weaponParams then
                        for paramName, paramValue in pairs(weaponParams) do
                            --Here we exclude the params that are not under WeaponGunParameter. 
                            if paramName ~= "Weapon_Profiles" and paramName ~= "current_param_indx" and paramName ~= "LoadNum" then
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
        
        if weapon.Type == "Ammo" then
            local Ammo_GameObject_RE7 = scene:call("findGameObject(System.String)", weapon.ID)
            
            if Ammo_GameObject_RE7 then
                cached_ammo_GameObjects_RE7[weapon.ID] = Ammo_GameObject_RE7
                log.info("Cached " .. weapon.Name .. " Game Object")

                local Ammo_Stats_RE7 = Ammo_GameObject_RE7:call("getComponent(System.Type)", sdk.typeof("app.Item"))

                if Ammo_Stats_RE7 then
                    local ammoParams = AWF_settings.RE7_Ammo_Params[weapon.ID]

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
end

local function cache_json_files_RE7(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWF_settings.RE7_Weapon_Params[weapon.ID]
        
        if weaponParams then
            local json_names = AWF_settings.RE7_Weapon_Params[weapon.ID].Weapon_Profiles or {}
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
                        table.insert(json_names, name)
                    end
                end
            else
                log.info("No JSON files found for " .. weapon.Name)
            end
        end
    end
end

cache_json_files_RE7(AWF_settings.RE7_Weapons)

local function get_weapon_gameobject_RE7(weaponData)
    for _, weapon in pairs(weaponData) do
        local Weapon_GameObject_RE7 = cached_weapon_GameObjects_RE7[weapon.ID]
        
        if Weapon_GameObject_RE7 then
            log.info("Loaded " .. weapon.Name .. " Game Object from cache")
        end
    end
end

local function update_cached_weapon_gameobjects_RE7()
    if changed or wc or not cached_weapon_GameObjects_RE7 or next(cached_weapon_GameObjects_RE7) == nil then
        changed = false
        wc = false
        AWF_Weapons_Found = true
        cache_weapon_gameobjects_RE7(AWF_settings.RE7_Weapons)
        get_weapon_gameobject_RE7(AWF_settings.RE7_Weapons)
        log.info("------------ AWF Weapon Data Updated!")
    end
end

local function draw_AWF_editor_GUI(weaponOrder)
    imgui.begin_rect()
    for _, weaponName in ipairs(weaponOrder) do
        local weaponData = AWF_settings.RE7_Weapons[weaponName]
        
        if weaponData and (weaponData.Type ~= "Ammo") and (weaponData.Type ~= "KNF") and imgui.tree_node(weaponData.Name) then
            if imgui.button("Reset to Defaults") then
                wc = true
                AWF_settings.RE7_Weapon_Params[weaponData.ID] = func.recurse_def_settings({}, AWFWeapons.RE7_Weapon_Params[weaponData.ID])
                cache_json_files_RE7(AWF_settings.RE7_Weapons)
            end
            func.tooltip("Reset the parameters of " .. weaponData.Name)

            imgui.same_line()
            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].IsLoadNumInfinity = imgui.checkbox("Unlimited Capacity", AWF_settings.RE7_Weapon_Params[weaponData.ID].IsLoadNumInfinity); wc = wc or changed
            func.tooltip("If enabled, the weapon does not need to be reloaded.")
            
            imgui.same_line()
            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].IsBulletStackNumInfinity = imgui.checkbox("Unlimited Ammo", AWF_settings.RE7_Weapon_Params[weaponData.ID].IsBulletStackNumInfinity); wc = wc or changed
            func.tooltip("If enabled, the weapon will never run out of ammo.")
            
            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].current_param_indx = imgui.combo("Preset", AWF_settings.RE7_Weapon_Params[weaponData.ID].current_param_indx or 1, AWF_settings.RE7_Weapon_Params[weaponData.ID].Weapon_Profiles); wc = wc or changed
            func.tooltip("Select a file from the dropdown menu to load the weapon stats from that file.")
            if changed then
                local selected_profile = AWF_settings.RE7_Weapon_Params[weaponData.ID].Weapon_Profiles[AWF_settings.RE7_Weapon_Params[weaponData.ID].current_param_indx]
                local json_filepath = [[AWF\\AWF_Weapons\\]] .. weaponData.Name .. [[\\]] .. selected_profile .. [[.json]]
                local temp_params = json.load_file(json_filepath)
                
                temp_params.Weapon_Profiles = nil
                temp_params.current_param_indx = nil

                for key, value in pairs(temp_params) do
                    AWF_settings.RE7_Weapon_Params[weaponData.ID][key] = value
                end
            end
            imgui.spacing()

            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].MaxLoadNum = imgui.drag_int("Ammo Capacity", AWF_settings.RE7_Weapon_Params[weaponData.ID].MaxLoadNum, 1, 0, 1000); wc = wc or changed
            func.tooltip("The maximum number of rounds of ammo the weapon can hold. Higher is better.")

            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].Range = imgui.drag_float("Range", AWF_settings.RE7_Weapon_Params[weaponData.ID].Range, 1.0, -1000.0, 1000.0); wc = wc or changed
            func.tooltip("The effective range of the weapon. Higher is better.")

            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].AttenuationStart = imgui.drag_float("Attenuation Start", AWF_settings.RE7_Weapon_Params[weaponData.ID].AttenuationStart, 1.0, 0.0, 1000.0); wc = wc or changed
            func.tooltip("Damage dropoff starts at this distance. Higher is better.")

            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].AttenuationEnd = imgui.drag_float("Attenuation End", AWF_settings.RE7_Weapon_Params[weaponData.ID].AttenuationEnd, 1.0, 0.0, 1000.0); wc = wc or changed
            func.tooltip("Damage dropoff ends at this distance. Higher is better.")

            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].MinAttenuationDamageRate = imgui.drag_float("Min Attenuation Damage Rate", AWF_settings.RE7_Weapon_Params[weaponData.ID].MinAttenuationDamageRate, 0.1, 0.0, 1000.0); wc = wc or changed
            func.tooltip("The minimum amount of damage that's dealt after damage dropoff. Higher is better.")

            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].Radius = imgui.drag_float("Radius", AWF_settings.RE7_Weapon_Params[weaponData.ID].Radius, 0.01, 0.0, 1000.0); wc = wc or changed
            func.tooltip("Weapon spread. Lower is better.")

            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].DiffusionNum = imgui.drag_int("Pellet Count", AWF_settings.RE7_Weapon_Params[weaponData.ID].DiffusionNum, 1, 0, 1000); wc = wc or changed
            func.tooltip("The number of pellets fired by a shotgun. Higher is better.")

            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].DiffusionRadius = imgui.drag_float("Diffusion Radius", AWF_settings.RE7_Weapon_Params[weaponData.ID].DiffusionRadius, 0.01, 0.0, 1000.0); wc = wc or changed
            func.tooltip("Pellet spread for shotguns - Hipfire. Lower is better.")

            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].AimDiffusionRadius = imgui.drag_float("Aim Diffusion Radius", AWF_settings.RE7_Weapon_Params[weaponData.ID].AimDiffusionRadius, 0.01, 0.0, 1000.0); wc = wc or changed
            func.tooltip("Pellet spread for shotguns - ADS. Lower is better.")

            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].RecoilBurstInterval = imgui.drag_float("Recoil Burst Interval", AWF_settings.RE7_Weapon_Params[weaponData.ID].RecoilBurstInterval, 0.01, 0.0, 1000.0); wc = wc or changed
            func.tooltip("TBD")

            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].RecoilBurstCount = imgui.drag_int("Recoil Burst Count", AWF_settings.RE7_Weapon_Params[weaponData.ID].RecoilBurstCount, 1, 0, 1000); wc = wc or changed
            func.tooltip("TBD")

            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].RecoilYAngle = imgui.drag_float("Recoil Y", AWF_settings.RE7_Weapon_Params[weaponData.ID].RecoilYAngle, 0.01, 0.0, 1000.0); wc = wc or changed
            func.tooltip("The amount the weapon recoils on the Y axis. Lower is better.")

            changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].RecoilXAngle = imgui.drag_float("Recoil X", AWF_settings.RE7_Weapon_Params[weaponData.ID].RecoilXAngle, 0.01, 0.0, 1000.0); wc = wc or changed
            func.tooltip("The amount the weapon recoils on the X axis. Lower is better.")

            imgui.tree_pop()
        end
        
        if weaponData and weaponData.Type == "Ammo" and imgui.tree_node(weaponData.Name) then
            if imgui.button("Reset to Defaults") then
                wc = true
                AWF_settings.RE7_Weapon_Params[weaponData.ID] = func.recurse_def_settings({}, AWFWeapons.RE7_Weapon_Params[weaponData.ID])
                cache_json_files_RE7(AWF_settings.RE7_Weapons)
            end
            func.tooltip("Reset the parameters of " .. weaponData.Name)
            
            imgui.spacing()
            changed, AWF_settings.RE7_Ammo_Params[weaponData.ID].MaxStackNum = imgui.drag_int("Max Stack Limit", AWF_settings.RE7_Ammo_Params[weaponData.ID].MaxStackNum, 1, 0, 9999); wc = wc or changed
            
            imgui.tree_pop()
        end
    end
    imgui.end_rect(1)
end

re.on_draw_ui(function()
	if imgui.tree_node("Advanced Weapon Framework") then
        imgui.begin_rect()
        if imgui.button("Reset to Defaults") then
            wc = true
            changed = true
            AWF_settings = func.recurse_def_settings({}, AWFWeapons)
            cache_json_files_RE7(AWF_settings.RE7_Weapons)
        end
        func.tooltip("Reset every parameter.")

        changed, show_AWF_editor = imgui.checkbox("Show AWF Weapon Stat Editor", show_AWF_editor)
        func.tooltip("Show/Hide the Weapon Stat Editor.")

        if show_AWF_editor then
            draw_AWF_editor_GUI(AWFWeapons.RE7_Weapon_Order)
        end

        if changed or wc then
            json.dump_file("AWF/AWF_Settings.json", AWF_settings)
        end

        imgui.text("				    v1.3.1 by SilverEzredes")
        imgui.end_rect(2)
        imgui.tree_pop()
    end
end)

return {
    AWF_settings = AWF_settings,
    update_cached_weapon_gameobjects_RE7 = update_cached_weapon_gameobjects_RE7,
    cache_weapon_gameobjects_RE7 = cache_weapon_gameobjects_RE7,
    get_weapon_gameobject_RE7 = get_weapon_gameobject_RE7,
}