--/////////////////////////////////////--
-- Advanced Weapon Framework Core

-- Author: SilverEzredes
-- Updated: 01/24/2024
-- Version: v1.4.45
-- Special Thanks to: praydog; alphaZomega; MrBoobieBuyer; Lotiuss

--/////////////////////////////////////--
local func = require("_SharedCore/Functions")
local hk = require("_SharedCore/Hotkeys")
local ui = require("_SharedCore/Imgui")

local show_AWF_editor = false
local isDEBUG = true
local scene = func.get_CurrentScene()
local changed = false
local wc = false
AWF_Weapons_Found = false

local cached_weapon_GameObjects_RE7 = {}
local cached_ammo_GameObjects_RE7 = {}
local cached_weapon_GameObjects_RE2 = {}
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

local AWFWeapons = {
    ---------------------------------------------------------------------------------------------RE7
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
        KNF_AXE = {ID = "wp0040_Axe_Item", Name = "Axe", Type = "KNF"},
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
            Weapon_Presets = {},
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
            Weapon_Presets = {},
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
            Weapon_Presets = {},
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
            Weapon_Presets = {},
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
            Weapon_Presets = {},
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
            Weapon_Presets = {},
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
            Weapon_Presets = {},
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
            Weapon_Presets = {},
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
            Weapon_Presets = {},
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
            Weapon_Presets = {},
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
            Weapon_Presets = {},
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
            Weapon_Presets = {},
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
            Weapon_Presets = {},
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
        },
        wp1011_HandgunBullet_Item = {
            MaxStackNum = 30,
        },
        wp1013_HandgunBulletStrong_Item = {
            MaxStackNum = 20,
        },
        wp1031_ShotgunBullet_Item = {
            MaxStackNum = 30,
        },
        wp1111_FlameBullet_Item = {
            MaxStackNum = 5,
        },
        wp1112_AcidBullet_Item = {
            MaxStackNum = 5,
        },
        wp1141_MagnumBullet_Item = {
            MaxStackNum = 20,
        },
        wp1161_MachineGunBullet_Item = {
            MaxStackNum = 300,
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
        "KNF_AXE",
        "HG_Ammo",
        "EX_HG_Ammo",
        "SG_Ammo",
        "MAG_Ammo",
        "SMG_Ammo",
        "GL_F_Ammo",
        "GL_A_Ammo",
        "FT_Ammo",
    },
    ---------------------------------------------------------------------------------------------RE2R
    RE2_Weapons = {
        VP70 = {ID = "wp0000", Name = "Matilda", Type = "HG"},
        M19 = {ID = "wp0100", Name = "M19", Type = "HG"},
        JMB = {ID = "wp0200", Name = "JMB Hp3", Type = "HG"},
        SAA = {ID = "wp0300", Name = "Quickdraw Army", Type = "HG"},
        MUP = {ID = "wp0600", Name = "MUP", Type = "HG"},
        HSC = {ID = "wp0700", Name = "Broom Hc", Type = "HG"},
        SLS60 = {ID = "wp0800", Name = "SLS 60", Type = "HG"},
        W870 = {ID = "wp1000", Name = "W-870", Type = "SG"},
        MQ11 = {ID = "wp2000", Name = "MQ 11", Type = "SMG"},
        LE5 = {ID = "wp2200", Name = "LE 5", Type = "SMG"},
        DE50 = {ID = "wp3000", Name = "Lightning Hawk", Type = "MAG"},
        GM79 = {ID = "wp4100", Name = "GM 79", Type = "GL"},
        CFT = {ID = "wp4200", Name = "Chemical Flamethrower", Type = "FT"},
        SPRK = {ID = "wp4300", Name = "Spark Shot", Type = "GL"},
        ATM4 = {ID = "wp4400", Name = "ATM-4", Type = "GL"},
        KNF = {ID = "wp4500", Name = "Combat Knife", Type = "KNF"},
        KNF_INF = {ID = "wp4500", Name = "Combat Knife - Unbreakable", Type = "KNF"},
        ATR = {ID = "wp4600", Name = "Anti-Tank Rocket", Type = "GL"},
        MINI = {ID = "wp4700", Name = "Minigun", Type = "SMG"},
        SE_OG = {ID = "wp7000", Name = "Samurai Edge - Original Model", Type = "HG"},
        SE_C = {ID = "wp7010", Name = "Samurai Edge - Chris Model", Type = "HG"},
        SE_J = {ID = "wp7020", Name = "Samurai Edge - Jill Model", Type = "HG"},
        SE_A = {ID = "wp7030", Name = "Samurai Edge - Albert Model", Type = "HG"},
        ATM4_2 = {ID = "wp8400", Name = "ATM-4 - Unlimited", Type = "GL"},
        MINI_2 = {ID = "wp8700", Name = "Minigun - Unlimited", Type = "SMG"},
    },
    RE2_Weapon_Params = {
        wp0000 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.05,
                RecoilRateRange = {
                    s = 0.9,
                    r = 0.1,
                },
            },
            Reticle = {
                _AddPoint = 150.0,
                _KeepPoint = 90.0,
                _ShootPoint = -50.0,
                _MovePoint = -1000.0,
                _WatchPoint = -150.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.017,
                },
                DeviatePitch = {
                    s = 0.014,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.03,
                    _SlurFit = 0.008,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 20.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 4,
                    },
                    FitCriticalRatio = {
                        _Ratio = 8,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 100.0,
                        },
                        Wince = {
                            _BaseValue = 30.0
                        },
                        Break = {
                            _BaseValue = 20.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 1.5,
                        Break = 1.5,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 1.5,
                        Break = 1.5,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 12,
                _NumberEX = 24,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {
                Gun = {
                    Reticle_LVL_02 = {
                        _AddPoint = 150.0,
                        _KeepPoint = 96.0,
                        _ShootPoint = -5.0,
                        _MovePoint = -1000.0,
                        _WatchPoint = 0.0,
                        PointRange = {
                            s = 0.0,
                            r = 100.0,
                        },
                    },
                    Recoil_LVL_02 = {
                        _RecoilRate = 0.1,
                        _RecoilDampRate = 0.1,
                        RecoilRateRange = {
                            s = 0.14,
                            r = 0.06,
                        },
                    },
                    Recoil_LVL_03 = {
                        _RecoilRate = 0.1,
                        _RecoilDampRate = 0.1,
                        RecoilRateRange = {
                            s = 0.4,
                            r = 0.2,
                        },
                    },
                    Recoil_LVL_04 = {
                        _RecoilRate = 0.03,
                        _RecoilDampRate = 0.2,
                        RecoilRateRange = {
                            s = 0.05,
                            r = 0.05,
                        },
                    },
                    RapidFire_LVL_01 = {
                        _Infinity = false,
                        _Number = 3,
                    },
                    Deviate_LVL_02 = {
                        DeviateYaw = {
                            s = 0.0,
                            r = 0.007,
                        },
                        DeviatePitch = {
                            s = 0.007,
                            r = 0.002,
                        },
                    },
                    Deviate_LVL_03 = {
                        DeviateYaw = {
                            s = -0.017,
                            r = 0.035,
                        },
                        DeviatePitch = {
                            s = 0.014,
                            r = 0.003,
                        },
                    },
                    Deviate_LVL_04 = {
                        DeviateYaw = {
                            s = -0.009,
                            r = 0.017,
                        },
                        DeviatePitch = {
                            s = 0.007,
                            r = 0.002,
                        },
                    },
                },
            },
        },
        wp0100 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 150.0,
                _KeepPoint = 90.0,
                _ShootPoint = -40.0,
                _MovePoint = -1000.0,
                _WatchPoint = -150.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = -0.035,
                    r = 0.003,
                },
                DeviatePitch = {
                    s = 0.009,
                    r = 0.009,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.02,
                    _SlurFit = 0.004,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 20.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 5,
                    },
                    FitCriticalRatio = {
                        _Ratio = 10,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 110.0,
                        },
                        Wince = {
                            _BaseValue = 30.0,
                        },
                        Break = {
                            _BaseValue = 20.0,
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.4,
                        },
                        Wince = {
                            _BaseValue = 1.2,
                        },
                        Break = {
                            _BaseValue = 1.2,
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 1.5,
                        Break = 1.5,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 3.0,
                        Break = 3.0,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 7,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp0200 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 150.0,
                _KeepPoint = 90.0,
                _ShootPoint = -40.0,
                _MovePoint = -1000.0,
                _WatchPoint = -150.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.017,
                },
                DeviatePitch = {
                    s = 0.021,
                    r = 0.005,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.025,
                    _SlurFit = 0.008,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 20.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 4,
                    },
                    FitCriticalRatio = {
                        _Ratio = 5,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 110.0,
                        },
                        Wince = {
                            _BaseValue = 25.0
                        },
                        Break = {
                            _BaseValue = 35.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 1.6,
                        Break = 1.2,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 1.6,
                        Break = 1.2,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 13,
                _NumberEX = 26,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {
                Gun = {
                    Reticle_LVL_02 = {
                        _AddPoint = 5000.0,
                        _KeepPoint = 0.0,
                        _ShootPoint = 0.0,
                        _MovePoint = -0.0,
                        _WatchPoint = 0.0,
                        PointRange = {
                            s = 0.0,
                            r = 100.0,
                        },
                    },
                    Deviate_LVL_02 = {
                        DeviateYaw = {
                            s = 0.0,
                            r = 0.017,
                        },
                        DeviatePitch = {
                            s = 0.014,
                            r = 0.003,
                        },
                    },
                },
            },
        },
        wp0300 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 100.0,
                _KeepPoint = 4.0,
                _ShootPoint = -16.0,
                _MovePoint = -1000.0,
                _WatchPoint = -100.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = -0.017,
                    r = 0.035,
                },
                DeviatePitch = {
                    s = -0.017,
                    r = 0.035,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.032,
                    _SlurFit = 0.008,
                    _HitNum = 4,
                    _HitNumBonusFit = 8,
                    _HitNumBonusCritical = 10,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 16.0,
                    _EffectiveRange = 13.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 6,
                    },
                    FitCriticalRatio = {
                        _Ratio = 9,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 300.0,
                        },
                        Wince = {
                            _BaseValue = 40.0
                        },
                        Break = {
                            _BaseValue = 30.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.8,
                        },
                        Wince = {
                            _BaseValue = 2.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 2.0,
                        Break = 1.5,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 2.5,
                        Break = 1.5,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 6,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp0600 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 150.0,
                _KeepPoint = 90.0,
                _ShootPoint = -15.0,
                _MovePoint = -1000.0,
                _WatchPoint = 0.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.0,
                },
                DeviatePitch = {
                    s = 0.014,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.04,
                    _SlurFit = 0.001,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 20.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 5,
                    },
                    FitCriticalRatio = {
                        _Ratio = 8,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 150.0,
                        },
                        Wince = {
                            _BaseValue = 5.0
                        },
                        Break = {
                            _BaseValue = 20.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 2.0,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 2.0,
                        Break = 1.5,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 16,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp0700 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.05,
                RecoilRateRange = {
                    s = 0.0,
                    r = 1.0,
                },
            },
            Reticle = {
                _AddPoint = 150.0,
                _KeepPoint = 90.0,
                _ShootPoint = 0.0,
                _MovePoint = -1000.0,
                _WatchPoint = -150.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = -0.009,
                    r = 0.044,
                },
                DeviatePitch = {
                    s = 0.028,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.032,
                    _SlurFit = 0.008,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 16.0,
                    _EffectiveRange = 13.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 5,
                    },
                    FitCriticalRatio = {
                        _Ratio = 10,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 90.0,
                        },
                        Wince = {
                            _BaseValue = 5.0
                        },
                        Break = {
                            _BaseValue = 20.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 0.75,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 1.5,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 4.0,
                        Wince = 2.0,
                        Break = 1.5,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 9,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp0800 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            custom_settings = true,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 150.0,
                _KeepPoint = 90.0,
                _ShootPoint = -60.0,
                _MovePoint = -60.0,
                _WatchPoint = -150.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.009,
                    r = 0.009,
                },
                DeviatePitch = {
                    s = 0.031,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.032,
                    _SlurFit = 0.008,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 20.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                BallisticSettingEx = {
                    _Slur = 0.032,
                    _SlurFit = 0.008,
                    _HitNum = 2,
                    _HitNumBonusFit = 1,
                    _HitNumBonusCritical = 1,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 18.0,
                    _EffectiveRange = 15.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 5,
                    },
                    FitCriticalRatio = {
                        _Ratio = 10,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 110.0,
                        },
                        Wince = {
                            _BaseValue = 40.0
                        },
                        Break = {
                            _BaseValue = 30.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.15,
                        },
                        Wince = {
                            _BaseValue = 1.15
                        },
                        Break = {
                            _BaseValue = 1.15
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.3,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 2.8,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                },
                AttackSettingEx = {
                    CriticalRatio = {
                        _Ratio = 5,
                    },
                    FitCriticalRatio = {
                        _Ratio = 10,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 110.0,
                        },
                        Wince = {
                            _BaseValue = 40.0
                        },
                        Break = {
                            _BaseValue = 30.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.2,
                        Wince = 1.2,
                        Break = 1.2,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.3,
                        Wince = 1.3,
                        Break = 1.3,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 5,
                _NumberEX = 5,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {
                Gun = {
                    Reticle_LVL_02 = {
                        _AddPoint = 200.0,
                        _KeepPoint = 90.0,
                        _ShootPoint = -100.0,
                        _MovePoint = -60.0,
                        _WatchPoint = -200.0,
                        PointRange = {
                            s = 0.0,
                            r = 100.0,
                        },
                    },
                    Recoil_LVL_02 = {
                        _RecoilRate = 0.4,
                        _RecoilDampRate = 0.1,
                        RecoilRateRange = {
                            s = 0.8,
                            r = 0.2,
                        },
                    },
                    Deviate_LVL_02 = {
                        DeviateYaw = {
                            s = 0.003,
                            r = 0.023,
                        },
                        DeviatePitch = {
                            s = 0.059,
                            r = 0.003,
                        },
                    },
                },
            },
        },
        wp1000 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 0.0,
                _KeepPoint = 100.0,
                _ShootPoint = -100.0,
                _MovePoint = -1000.0,
                _WatchPoint = 0.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.052,
                },
                DeviatePitch = {
                    s = 0.070,
                    r = 0.017,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.02,
                    _SlurFit = 0.01,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 150.0,
                    _FiringRange = 12.0,
                    _EffectiveRange = 8.0,
                    _Gravity = 0.0,
                },
                BallisticSettingEx = {
                    _Slur = 0.04,
                    _SlurFit = 0.02,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 150.0,
                    _FiringRange = 12.0,
                    _EffectiveRange = 8.0,
                    _Gravity = 9.8,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 40.0,
                        },
                        Wince = {
                            _BaseValue = 5.0
                        },
                        Break = {
                            _BaseValue = 20.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 4.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                },
                AttackSettingEx = {
                    CriticalRatio = {
                        _Ratio = 2,
                    },
                    FitCriticalRatio = {
                        _Ratio = 2,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 400.0,
                        },
                        Wince = {
                            _BaseValue = 200.0
                        },
                        Break = {
                            _BaseValue = 50.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 3.0,
                        Break = 2.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 4.0,
                        Wince = 2.0,
                        Break = 2.0,
                    },
                },
                Normal = {
                    AroundBulletNum = 8,
                    AroundBulletDegree = 2.5,
                    AroundBulletLength = 0.2
                },
                Fit = {
                    AroundBulletNum = 8,
                    AroundBulletDegree = 1.5,
                    AroundBulletLength = 0.1
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 4,
                _NumberEX = 8,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {
                Gun = {
                    Recoil_LVL_02 = {
                        _RecoilRate = 0.1,
                        _RecoilDampRate = 0.1,
                        RecoilRateRange = {
                            s = 0.590,
                            r = 0.2,
                        },
                    },
                    Deviate_LVL_02 = {
                        DeviateYaw = {
                            s = 0.000,
                            r = 0.026,
                        },
                        DeviatePitch = {
                            s = 0.024,
                            r = 0.003,
                        },
                    },
                },
            },
        },
        wp2000 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.05,
                _RecoilDampRate = 0.25,
                RecoilRateRange = {
                    s = 0.1,
                    r = 0.05,
                },
            },
            Reticle = {
                _AddPoint = 100.0,
                _KeepPoint = 99.0,
                _ShootPoint = -20.0,
                _MovePoint = -1000.0,
                _WatchPoint = -100.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.003,
                },
                DeviatePitch = {
                    s = 0.007,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.06,
                    _SlurFit = 0.01,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 18.0,
                    _EffectiveRange = 15.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 2,
                    },
                    FitCriticalRatio = {
                        _Ratio = 4,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 40.0,
                        },
                        Wince = {
                            _BaseValue = 7.0
                        },
                        Break = {
                            _BaseValue = 15.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 2.85,
                        Break = 1.3,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 24,
                _NumberEX = 50,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {
                Gun = {
                    Reticle_LVL_02 = {
                        _AddPoint = 75.0,
                        _KeepPoint = 99.0,
                        _ShootPoint = -5.0,
                        _MovePoint = -1000.0,
                        _WatchPoint = -75.0,
                        PointRange = {
                            s = 50.0,
                            r = 50.0,
                        },
                    },
                    Recoil_LVL_02 = {
                        _RecoilRate = 0.01,
                        _RecoilDampRate = 0.2,
                        RecoilRateRange = {
                            s = 0.0,
                            r = 0.1,
                        },
                    },
                    Deviate_LVL_02 = {
                        DeviateYaw = {
                            s = 0.0,
                            r = 0.0,
                        },
                        DeviatePitch = {
                            s = 0.003,
                            r = 0.003,
                        },
                    },
                },
            },
        },
        wp2200 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.45,
                _RecoilDampRate = 0.15,
                RecoilRateRange = {
                    s = 0.1,
                    r = 0.3,
                },
            },
            Reticle = {
                _AddPoint = 50.0,
                _KeepPoint = 99.0,
                _ShootPoint = -2.0,
                _MovePoint = -300.0,
                _WatchPoint = -50.0,
                PointRange = {
                    s = 75.0,
                    r = 25.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.002,
                },
                DeviatePitch = {
                    s = 0.005,
                    r = 0.000,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.04,
                    _SlurFit = 0.01,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 20.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 8,
                    },
                    FitCriticalRatio = {
                        _Ratio = 17,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 40.0,
                        },
                        Wince = {
                            _BaseValue = 15.0
                        },
                        Break = {
                            _BaseValue = 30.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 2.0,
                        Break = 1.3,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 3.0,
                        Break = 4.0,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = true,
                _Number = 32,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp3000 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 60.0,
                _KeepPoint = 21.0,
                _ShootPoint = -80.0,
                _MovePoint = -1000.0,
                _WatchPoint = -60.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.052,
                },
                DeviatePitch = {
                    s = 0.070,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.035,
                    _SlurFit = 0.00,
                    _HitNum = 2,
                    _HitNumBonusFit = 1,
                    _HitNumBonusCritical = 1,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 20.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 5,
                    },
                    FitCriticalRatio = {
                        _Ratio = 10,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 800.0,
                        },
                        Wince = {
                            _BaseValue = 150.0
                        },
                        Break = {
                            _BaseValue = 180.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 1.5,
                        Break = 1.5,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.3,
                        Wince = 1.3,
                        Break = 1.3,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 7,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {
                Gun = {
                    Reticle_LVL_02 = {
                        _AddPoint = 48.0,
                        _KeepPoint = 50.0,
                        _ShootPoint = -51.0,
                        _MovePoint = -1000.0,
                        _WatchPoint = -48.0,
                        PointRange = {
                            s = 80.0,
                            r = 20.0,
                        },
                    },
                    Deviate_LVL_02 = {
                        DeviateYaw = {
                            s = 0.0,
                            r = 0.026,
                        },
                        DeviatePitch = {
                            s = 0.035,
                            r = 0.007,
                        },
                    },
                    Deviate_LVL_03 = {
                        DeviateYaw = {
                            s = 0.0,
                            r = 0.052,
                        },
                        DeviatePitch = {
                            s = 0.070,
                            r = 0.003,
                        },
                    },
                    Deviate_LVL_04 = {
                        DeviateYaw = {
                            s = 0.0,
                            r = 0.026,
                        },
                        DeviatePitch = {
                            s = 0.035,
                            r = 0.007,
                        },
                    },
                },
            },
        },
        wp4100 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 0.0,
                _KeepPoint = 100.0,
                _ShootPoint = 0.0,
                _MovePoint = -1000.0,
                _WatchPoint = -0.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.0,
                },
                DeviatePitch = {
                    s = 0.035,
                    r = 0.000,
                },
            },
            ShellGenerator = {
                BallisticSettingAcid = {
                    _Slur = 0.0,
                    _SlurFit = 0.0,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 2,
                    _Speed = 50.0,
                    _FiringRange = 80.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 8.0,
                },
                BallisticSettingFire = {
                    _Slur = 0.0,
                    _SlurFit = 0.0,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 2,
                    _Speed = 50.0,
                    _FiringRange = 80.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 8.0,
                },
                AttackSettingAcid = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 0.0,
                        },
                        Wince = {
                            _BaseValue = 100.0
                        },
                        Break = {
                            _BaseValue = 0.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                },
                AttackSettingFire = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 0.0,
                        },
                        Wince = {
                            _BaseValue = 100.0
                        },
                        Break = {
                            _BaseValue = 0.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 1,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {
                Gun = {
                    Deviate_LVL_02 = {
                        DeviateYaw = {
                            s = 0.0,
                            r = 0.0,
                        },
                        DeviatePitch = {
                            s = 0.017,
                            r = 0.0,
                        },
                    },
                },
            },
        },
        wp4200 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            LoopFire = {
                _Interval = 0.4,
                _ReduceNumber = 4,
            },
            Reticle = {
                _AddPoint = 0.0,
                _KeepPoint = 100.0,
                _ShootPoint = 0.0,
                _MovePoint = -1000.0,
                _WatchPoint = -0.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = -0.005,
                    r = 0.010,
                },
                DeviatePitch = {
                    s = -0.005,
                    r = 0.010,
                },
            },
            ShellGenerator = {
                RadiateSettings = {
                    RadiateLength = 8.0,
                    Radius = {
                        _BaseValue = 1.0
                    },
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 0.0,
                        },
                        Wince = {
                            _BaseValue = 0.0
                        },
                        Break = {
                            _BaseValue = 0.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 400,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {
                Gun = {
                    LoopFire_LVL_02 = {
                        _Interval = 0.2,
                        _ReduceNumber = 2,
                    },
                },
            },
        },
        wp4300 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            LoopFire = {
                _Interval = 0.5,
                _ReduceNumber = 1,
            },
            Reticle = {
                _AddPoint = 0.0,
                _KeepPoint = 100.0,
                _ShootPoint = 0.0,
                _MovePoint = -1000.0,
                _WatchPoint = -0.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.0,
                },
                DeviatePitch = {
                    s = 0.035,
                    r = 0.000,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.0,
                    _SlurFit = 0.0,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 400.0,
                    _FiringRange = 10.0,
                    _EffectiveRange = 10.0,
                    _Gravity = 9.8,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 300.0,
                        },
                        Wince = {
                            _BaseValue = 10.0
                        },
                        Break = {
                            _BaseValue = 10.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 7,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp4400 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.2,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 0.0,
                _KeepPoint = 100.0,
                _ShootPoint = 0.0,
                _MovePoint = -1000.0,
                _WatchPoint = -0.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.0,
                },
                DeviatePitch = {
                    s = 0.052,
                    r = 0.000,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.02,
                    _SlurFit = 0.02,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 2,
                    _Speed = 20.0,
                    _FiringRange = 80.0,
                    _EffectiveRange = 20.0,
                    _Gravity = 0.5,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 0.0,
                        },
                        Wince = {
                            _BaseValue = 200.0
                        },
                        Break = {
                            _BaseValue = 280.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 1,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp4600 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.2,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 0.0,
                _KeepPoint = 100.0,
                _ShootPoint = 0.0,
                _MovePoint = -1000.0,
                _WatchPoint = -0.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.0,
                },
                DeviatePitch = {
                    s = 0.035,
                    r = 0.000,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.02,
                    _SlurFit = 0.02,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 2,
                    _Speed = 20.0,
                    _FiringRange = 80.0,
                    _EffectiveRange = 20.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 0.0,
                        },
                        Wince = {
                            _BaseValue = 0.0
                        },
                        Break = {
                            _BaseValue = 0.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 4,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp4700 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.06,
                _RecoilDampRate = 0.3,
                RecoilRateRange = {
                    s = 0.2,
                    r = 0.25,
                },
            },
            LoopFire = {
                _Interval = 0.1,
                _ReduceNumber = 1,
            },
            Reticle = {
                _AddPoint = 0.0,
                _KeepPoint = 100.0,
                _ShootPoint = 0.0,
                _MovePoint = -1000.0,
                _WatchPoint = -0.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.003,
                },
                DeviatePitch = {
                    s = 0.014,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.02,
                    _SlurFit = 0.02,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 1,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 30.0,
                    _EffectiveRange = 25.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 30,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 20.0,
                        },
                        Wince = {
                            _BaseValue = 20.0
                        },
                        Break = {
                            _BaseValue = 20.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.0,
                        Wince = 10.0,
                        Break = 10.0,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 1000,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp7000 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 150.0,
                _KeepPoint = 90.0,
                _ShootPoint = -20.0,
                _MovePoint = -1000.0,
                _WatchPoint = -150.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.0,
                },
                DeviatePitch = {
                    s = 0.014,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.03,
                    _SlurFit = 0.008,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 20.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 4,
                    },
                    FitCriticalRatio = {
                        _Ratio = 9,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 100.0,
                        },
                        Wince = {
                            _BaseValue = 30.0,
                        },
                        Break = {
                            _BaseValue = 20.0,
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 0.9,
                        },
                        Wince = {
                            _BaseValue = 1.0,
                        },
                        Break = {
                            _BaseValue = 1.0,
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 1.5,
                        Break = 1.5,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 1.5,
                        Break = 1.5,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = true,
                _Number = 15,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp7010 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 300.0,
                _KeepPoint = 90.0,
                _ShootPoint = -20.0,
                _MovePoint = -1000.0,
                _WatchPoint = -300.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.0,
                },
                DeviatePitch = {
                    s = 0.014,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.03,
                    _SlurFit = 0.008,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 20.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 4,
                    },
                    FitCriticalRatio = {
                        _Ratio = 9,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 100.0,
                        },
                        Wince = {
                            _BaseValue = 30.0,
                        },
                        Break = {
                            _BaseValue = 20.0,
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.1,
                        },
                        Wince = {
                            _BaseValue = 1.0,
                        },
                        Break = {
                            _BaseValue = 1.0,
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 1.5,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 1.5,
                        Break = 1.5,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 15,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp7020 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 90.0,
                _KeepPoint = 90.0,
                _ShootPoint = -20.0,
                _MovePoint = -1000.0,
                _WatchPoint = -300.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.0,
                },
                DeviatePitch = {
                    s = 0.014,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.03,
                    _SlurFit = 0.008,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 20.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 4,
                    },
                    FitCriticalRatio = {
                        _Ratio = 12,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 100.0,
                        },
                        Wince = {
                            _BaseValue = 30.0,
                        },
                        Break = {
                            _BaseValue = 20.0,
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 0.8,
                        },
                        Wince = {
                            _BaseValue = 1.0,
                        },
                        Break = {
                            _BaseValue = 1.0,
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 1.5,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 1.5,
                        Break = 1.5,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 15,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp7030 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 100.0,
                _KeepPoint = 90.0,
                _ShootPoint = -20.0,
                _MovePoint = -1000.0,
                _WatchPoint = 0.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.0,
                },
                DeviatePitch = {
                    s = 0.014,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.03,
                    _SlurFit = 0.008,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 20.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 4,
                    },
                    FitCriticalRatio = {
                        _Ratio = 9,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 100.0,
                        },
                        Wince = {
                            _BaseValue = 30.0,
                        },
                        Break = {
                            _BaseValue = 20.0,
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.1,
                        },
                        Wince = {
                            _BaseValue = 1.0,
                        },
                        Break = {
                            _BaseValue = 1.0,
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.5,
                        Wince = 1.5,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 1.5,
                        Break = 1.5,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 15,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp8400 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.2,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 0.0,
                _KeepPoint = 100.0,
                _ShootPoint = 0.0,
                _MovePoint = -1000.0,
                _WatchPoint = -0.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.0,
                },
                DeviatePitch = {
                    s = 0.052,
                    r = 0.000,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.02,
                    _SlurFit = 0.02,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 2,
                    _Speed = 20.0,
                    _FiringRange = 80.0,
                    _EffectiveRange = 20.0,
                    _Gravity = 0.5,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 0.0,
                        },
                        Wince = {
                            _BaseValue = 200.0
                        },
                        Break = {
                            _BaseValue = 280.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = true,
                _AlwaysReloadable = false,
                _Number = 1,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
        wp8700 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.06,
                _RecoilDampRate = 0.3,
                RecoilRateRange = {
                    s = 0.2,
                    r = 0.25,
                },
            },
            LoopFire = {
                _Interval = 0.1,
                _ReduceNumber = 1,
            },
            Reticle = {
                _AddPoint = 0.0,
                _KeepPoint = 100.0,
                _ShootPoint = 0.0,
                _MovePoint = -1000.0,
                _WatchPoint = -0.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.003,
                },
                DeviatePitch = {
                    s = 0.014,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.02,
                    _SlurFit = 0.02,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 1,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 30.0,
                    _EffectiveRange = 25.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 30,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 20.0,
                        },
                        Wince = {
                            _BaseValue = 20.0
                        },
                        Break = {
                            _BaseValue = 20.0
                        },
                    },
                    NormalRate = {
                        Damage = {
                            _BaseValue = 1.0,
                        },
                        Wince = {
                            _BaseValue = 1.0
                        },
                        Break = {
                            _BaseValue = 1.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.0,
                        Wince = 10.0,
                        Break = 10.0,
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = true,
                _AlwaysReloadable = false,
                _Number = 1000,
                AlwaysReloadableVariable = {
                    mData1 = 1880317623,
                    mData2 = 15414,
                    mData3 = 19646,
                    mData4_0 = 133,
                    mData4_1 = 67,
                    mData4_2 = 203,
                    mData4_3 = 46,
                    mData4_4 = 7,
                    mData4_5 = 146,
                    mData4_6 = 231,
                    mData4_7 = 125,
                    mData4L = 785073029,
                },
            },
            UserData = {},
        },
    },
    RE2_Weapon_Order = {
        "VP70",
        "M19",
        "JMB",
        "SAA",
        "MUP",
        "HSC",
        "SLS60",
        "SE_OG",
        "SE_C",
        "SE_J",
        "SE_A",
        "W870",
        "MQ11",
        "LE5",
        "DE50",
        "GM79",
        "CFT",
        "SPRK",
        "MINI",
        "MINI_2",
        "ATR",
        "ATM4",
        "ATM4_2",
    },
    ---------------------------------------------------------------------------------------------RE3R
    RE3 = {
        Weapons = {},
        Weapon_Params = {},
        Weapon_Order = {},
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

local function dump_default_weapon_params_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWFWeapons.RE2_Weapon_Params[weapon.ID]
        
        if weaponParams then
            json.dump_file("AWF/AWF_Weapons/".. weapon.Name .. "/" .. weapon.Name .. " Default".. ".json", weaponParams)
            log.info("AWF Default Weapon Params Dumped")
        end
    end
end

if reframework.get_game_name() == "re7" then
    dump_default_weapon_params_RE7(AWFWeapons.RE7_Weapons)
elseif reframework.get_game_name() == "re2" then
    dump_default_weapon_params_RE2(AWFWeapons.RE2_Weapons)
end

local AWF_settings = hk.merge_tables({}, AWFWeapons) and func.recurse_def_settings(json.load_file("AWF/AWF_Settings.json") or {}, AWFWeapons)

local function cache_weapon_gameobjects_RE7(weaponData)
    for _, weapon in pairs(weaponData) do
        if weapon.isUpdated then
            local Weapon_GameObject_RE7 = scene:call("findGameObject(System.String)", weapon.ID)
            
            --Here we exclude the all 'Ammo' and 'Knife' GameObjects. 
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
                        local weaponParams = AWF_settings.RE7_Weapon_Params[weapon.ID]

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
        weapon.isUpdated = false
    end
end

local function cache_weapon_gameobjects_RE2(weaponData)
    local Inventory_GameObject_RE2 = RE2_Cache.InventoryMaster

    for _, weapon in pairs(weaponData) do
        if weapon.isUpdated then
            local Weapon_GameObject_RE2 = scene:call("findGameObject(System.String)", weapon.ID)
            
            if Weapon_GameObject_RE2 then
                cached_weapon_GameObjects_RE2[weapon.ID] = Weapon_GameObject_RE2
                
                log.info("Cached " .. weapon.Name .. " Game Object")

                -- Main Game
                local Weapon_Stats_RE2 = Weapon_GameObject_RE2:call("getComponent(System.Type)", RE2_Cache.ImplementGunRE2)

                if Weapon_Stats_RE2 then
                    local weaponParams = AWF_settings.RE2_Weapon_Params[weapon.ID]
                    --TODO
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
                                        for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                            local Weapon_RecoilRangeParams_RE2 = Weapon_RecoilParams_RE2:get_field("_RecoilRateRange")

                                            if Weapon_RecoilRangeParams_RE2 then
                                                Weapon_RecoilRangeParams_RE2[SubParamName_2nd] = SubParamValue_2nd
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
                                        for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                            local Weapon_ReticleRangeParams_RE2 = Weapon_ReticleParams_RE2:get_field("_PointRange")

                                            if Weapon_ReticleRangeParams_RE2 then
                                                Weapon_ReticleRangeParams_RE2[SubParamName_2nd] = SubParamValue_2nd
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
                                            for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                local Weapon_DeviateYaw_RE2 = Weapon_DeviateParams_RE2:get_field("_TrainOffYaw")

                                                if Weapon_DeviateYaw_RE2 then
                                                    Weapon_DeviateYaw_RE2[SubParamName_2nd] = SubParamValue_2nd
                                                    func.write_valuetype(Weapon_DeviateParams_RE2, 0x60, Weapon_DeviateYaw_RE2)
                                                end
                                            end
                                        end
                                        if subParamName == "DeviatePitch" then
                                            for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                local Weapon_DeviatePitch_RE2 = Weapon_DeviateParams_RE2:get_field("_TrainOffPitch")

                                                if Weapon_DeviatePitch_RE2 then
                                                    Weapon_DeviatePitch_RE2[SubParamName_2nd] = SubParamValue_2nd
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
                                                        for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                            Weapon_ShellGenerator_Normal_RE2[SubParamName_2nd] = SubParamValue_2nd
                                                        end
                                                    end
                                                end
                                                if Weapon_ShellGenerator_Fit_RE2 then
                                                    if subParamName == "Fit" then
                                                        for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                            Weapon_ShellGenerator_Fit_RE2[SubParamName_2nd] = SubParamValue_2nd
                                                        end
                                                    end
                                                end
                                                for _, settingName in ipairs(RE2_Cache.shellPrefabSettings) do
                                                    local setting = Weapon_ShellGenerator_BulletGenerateSetting_RE2:get_field(settingName)
                                                    weaponShellUserData[settingName] = setting and setting:get_field("ShellUserData")

                                                    for i, shellUserData in pairs(weaponShellUserData) do
                                                        if shellUserData then
                                                            if (subParamName == "BallisticSettingNormal") or (subParamName == "BallisticSettingEx") or (subParamName == "BallisticSettingAcid") or (subParamName == "BallisticSettingFire")then
                                                                for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                                    local Weapon_ShellUserData_BallisticSettingNormal_RE2 =  shellUserData:get_field("BallisticSetting")
    
                                                                    if Weapon_ShellUserData_BallisticSettingNormal_RE2 then
                                                                        Weapon_ShellUserData_BallisticSettingNormal_RE2[SubParamName_2nd] = SubParamValue_2nd
                                                                    end
                                                                end
                                                            end
                                                            if (subParamName == "AttackSettingNormal") or (subParamName == "AttackSettingEx") or (subParamName == "AttackSettingAcid") or (subParamName == "AttackSettingFire") then
                                                                for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                                    local Weapon_ShellUserData_AttackSetting_RE2 = shellUserData:get_field("AttackSetting")
                                                                    
                                                                    if Weapon_ShellUserData_AttackSetting_RE2 then
                                                                        if SubParamName_2nd == "CriticalRatio" then
                                                                            for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingCriticalRatio_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("CriticalRatio")
            
                                                                                if Weapon_ShellUserData_AttackSettingCriticalRatio_RE2 then
                                                                                    Weapon_ShellUserData_AttackSettingCriticalRatio_RE2[SubParamName_3rd] = SubParamValue_3rd
                                                                                end
                                                                            end
                                                                        end
                                                                        if SubParamName_2nd == "FitCriticalRatio"then
                                                                            for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("FitCriticalRatio")
    
                                                                                if Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE2 then
                                                                                    Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE2[SubParamName_3rd] = SubParamValue_3rd
                                                                                end
                                                                            end
                                                                        end
                                                                        if SubParamName_2nd == "Normal" then
                                                                            for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingNormal_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("Normal")
                                                                                
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE2 and SubParamName_3rd == "Damage" then
                                                                                    for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Damage")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Damage_RE2[SubParamName_4th] = SubParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE2 and SubParamName_3rd == "Wince" then
                                                                                    for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Wince")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Wince_RE2[SubParamName_4th] = SubParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE2 and SubParamName_3rd == "Break" then
                                                                                    for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Break_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Break")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Break_RE2 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Break_RE2[SubParamName_4th] = SubParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                        if SubParamName_2nd == "NormalRate" then
                                                                            for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingNormal_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("NormalRate")
                                                                                
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE2 and SubParamName_3rd == "Damage" then
                                                                                    for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Damage")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Damage_RE2[SubParamName_4th] = SubParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE2 and SubParamName_3rd == "Wince" then
                                                                                    for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Wince")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Wince_RE2[SubParamName_4th] = SubParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                                if Weapon_ShellUserData_AttackSettingNormal_RE2 and SubParamName_3rd == "Break" then
                                                                                    for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                                        local Weapon_ShellUserData_AttackSettingNormal_Break_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Break")
            
                                                                                        if Weapon_ShellUserData_AttackSettingNormal_Break_RE2 then
                                                                                            Weapon_ShellUserData_AttackSettingNormal_Break_RE2[SubParamName_4th] = SubParamValue_4th
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                        if SubParamName_2nd == "FitRatioContainer"then
                                                                            for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingFitRatioContainer_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("FitRatioContainer")
    
                                                                                if Weapon_ShellUserData_AttackSettingFitRatioContainer_RE2 then
                                                                                    Weapon_ShellUserData_AttackSettingFitRatioContainer_RE2[SubParamName_3rd] = SubParamValue_3rd
                                                                                end
                                                                            end
                                                                        end
                                                                        if SubParamName_2nd == "CriticalRatioContainer"then
                                                                            for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                                local Weapon_ShellUserData_AttackSettingCritRatioContainer_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("CriticalRatioContainer")
    
                                                                                if Weapon_ShellUserData_AttackSettingCritRatioContainer_RE2 then
                                                                                    Weapon_ShellUserData_AttackSettingCritRatioContainer_RE2[SubParamName_3rd] = SubParamValue_3rd
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
                                                            for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                                local Weapon_ShellGenerator_ShellRadiateSettings_RE2 = Weapon_ShellGenerator_ShellUserData_RE2:get_field("radiateSettings")

                                                                if Weapon_ShellGenerator_ShellRadiateSettings_RE2 then
                                                                    local Weapon_ShellGenerator_ShellRadiateSettingsRadius_RE2 = Weapon_ShellGenerator_ShellRadiateSettings_RE2:get_field("Radius")
                                                                    
                                                                    if Weapon_ShellGenerator_ShellRadiateSettings_RE2 and SubParamName_2nd ~= "Radius" then
                                                                        Weapon_ShellGenerator_ShellRadiateSettings_RE2[SubParamName_2nd] = SubParamValue_2nd
                                                                    end

                                                                    if SubParamName_2nd == "Radius" then
                                                                        for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                            Weapon_ShellGenerator_ShellRadiateSettingsRadius_RE2[SubParamName_3rd] = SubParamValue_3rd
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                        if subParamName == "AttackSettingNormal" then
                                                            for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                                local Weapon_ShellUserData_AttackSetting_RE2 = Weapon_ShellGenerator_ShellUserData_RE2:get_field("AttackSetting")
                                                                
                                                                if Weapon_ShellUserData_AttackSetting_RE2 then
                                                                    if SubParamName_2nd == "CriticalRatio" then
                                                                        for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                            local Weapon_ShellUserData_AttackSettingCriticalRatio_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("CriticalRatio")
        
                                                                            if Weapon_ShellUserData_AttackSettingCriticalRatio_RE2 then
                                                                                Weapon_ShellUserData_AttackSettingCriticalRatio_RE2[SubParamName_3rd] = SubParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                    if SubParamName_2nd == "FitCriticalRatio"then
                                                                        for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                            local Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("FitCriticalRatio")

                                                                            if Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE2 then
                                                                                Weapon_ShellUserData_AttackSettingFitCriticalRatio_RE2[SubParamName_3rd] = SubParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                    if SubParamName_2nd == "Normal" then
                                                                        for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                            local Weapon_ShellUserData_AttackSettingNormal_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("Normal")
                                                                            
                                                                            if Weapon_ShellUserData_AttackSettingNormal_RE2 and SubParamName_3rd == "Damage" then
                                                                                for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                                    local Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Damage")
        
                                                                                    if Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 then
                                                                                        Weapon_ShellUserData_AttackSettingNormal_Damage_RE2[SubParamName_4th] = SubParamValue_4th
                                                                                    end
                                                                                end
                                                                            end
                                                                            if Weapon_ShellUserData_AttackSettingNormal_RE2 and SubParamName_3rd == "Wince" then
                                                                                for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                                    local Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Wince")
        
                                                                                    if Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 then
                                                                                        Weapon_ShellUserData_AttackSettingNormal_Wince_RE2[SubParamName_4th] = SubParamValue_4th
                                                                                    end
                                                                                end
                                                                            end
                                                                            if Weapon_ShellUserData_AttackSettingNormal_RE2 and SubParamName_3rd == "Break" then
                                                                                for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                                    local Weapon_ShellUserData_AttackSettingNormal_Break_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Break")
        
                                                                                    if Weapon_ShellUserData_AttackSettingNormal_Break_RE2 then
                                                                                        Weapon_ShellUserData_AttackSettingNormal_Break_RE2[SubParamName_4th] = SubParamValue_4th
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                    if SubParamName_2nd == "NormalRate" then
                                                                        for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                            local Weapon_ShellUserData_AttackSettingNormal_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("NormalRate")
                                                                            
                                                                            if Weapon_ShellUserData_AttackSettingNormal_RE2 and SubParamName_3rd == "Damage" then
                                                                                for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                                    local Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Damage")
        
                                                                                    if Weapon_ShellUserData_AttackSettingNormal_Damage_RE2 then
                                                                                        Weapon_ShellUserData_AttackSettingNormal_Damage_RE2[SubParamName_4th] = SubParamValue_4th
                                                                                    end
                                                                                end
                                                                            end
                                                                            if Weapon_ShellUserData_AttackSettingNormal_RE2 and SubParamName_3rd == "Wince" then
                                                                                for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                                    local Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Wince")
        
                                                                                    if Weapon_ShellUserData_AttackSettingNormal_Wince_RE2 then
                                                                                        Weapon_ShellUserData_AttackSettingNormal_Wince_RE2[SubParamName_4th] = SubParamValue_4th
                                                                                    end
                                                                                end
                                                                            end
                                                                            if Weapon_ShellUserData_AttackSettingNormal_RE2 and SubParamName_3rd == "Break" then
                                                                                for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                                    local Weapon_ShellUserData_AttackSettingNormal_Break_RE2 = Weapon_ShellUserData_AttackSettingNormal_RE2:get_field("Break")
        
                                                                                    if Weapon_ShellUserData_AttackSettingNormal_Break_RE2 then
                                                                                        Weapon_ShellUserData_AttackSettingNormal_Break_RE2[SubParamName_4th] = SubParamValue_4th
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                    if SubParamName_2nd == "FitRatioContainer"then
                                                                        for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                            local Weapon_ShellUserData_AttackSettingFitRatioContainer_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("FitRatioContainer")

                                                                            if Weapon_ShellUserData_AttackSettingFitRatioContainer_RE2 then
                                                                                Weapon_ShellUserData_AttackSettingFitRatioContainer_RE2[SubParamName_3rd] = SubParamValue_3rd
                                                                            end
                                                                        end
                                                                    end
                                                                    if SubParamName_2nd == "CriticalRatioContainer"then
                                                                        for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                            local Weapon_ShellUserData_AttackSettingCritRatioContainer_RE2 = Weapon_ShellUserData_AttackSetting_RE2:get_field("CriticalRatioContainer")

                                                                            if Weapon_ShellUserData_AttackSettingCritRatioContainer_RE2 then
                                                                                Weapon_ShellUserData_AttackSettingCritRatioContainer_RE2[SubParamName_3rd] = SubParamValue_3rd
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
                                                for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                    for i = 2, #Weapon_UserDataParams_Reticle_RE2 do
                                                        local Weapon_UserDataParams_ReticleParams_RE2 = Weapon_UserDataParams_Reticle_RE2[i]:get_field("_Param")
                                                        local matched_ParamName = "Reticle_LVL_" .. string.format("%02d", i)
                                                    
                                                        if Weapon_UserDataParams_ReticleParams_RE2 and SubParamName_2nd == matched_ParamName then
                                                            for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                if Weapon_UserDataParams_ReticleParams_RE2 and SubParamName_3rd ~= "PointRange" then
                                                                    Weapon_UserDataParams_ReticleParams_RE2[SubParamName_3rd] = SubParamValue_3rd
                                                                end
                                                                if Weapon_UserDataParams_ReticleParams_RE2 and SubParamName_3rd == "PointRange" then
                                                                    for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                        local Weapon_ReticleRangeParams_RE2 = Weapon_UserDataParams_ReticleParams_RE2:get_field("_PointRange")
                                
                                                                        if Weapon_ReticleRangeParams_RE2 then
                                                                            Weapon_ReticleRangeParams_RE2[SubParamName_4th] = SubParamValue_4th
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
                                                for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                    for i = 2, #Weapon_UserDataParams_Recoil_RE2 do
                                                        local Weapon_UserDataParams_RecoilParams_RE2 = Weapon_UserDataParams_Recoil_RE2[i]:get_field("_Param")
                                                        local matched_ParamName = "Recoil_LVL_" .. string.format("%02d", i)

                                                        if Weapon_UserDataParams_RecoilParams_RE2 and SubParamName_2nd == matched_ParamName then
                                                            for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                if Weapon_UserDataParams_RecoilParams_RE2 and SubParamName_3rd ~= "RecoilRateRange" then
                                                                    Weapon_UserDataParams_RecoilParams_RE2[SubParamName_3rd] = SubParamValue_3rd
                                                                end
                                                                if Weapon_UserDataParams_RecoilParams_RE2 and SubParamName_3rd == "RecoilRateRange" then
                                                                    for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                        local Weapon_RecoilRangeParams_RE2 = Weapon_UserDataParams_RecoilParams_RE2:get_field("_RecoilRateRange")
                                
                                                                        if Weapon_RecoilRangeParams_RE2 then
                                                                            Weapon_RecoilRangeParams_RE2[SubParamName_4th] = SubParamValue_4th
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
                                                for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                    for i = 1, #Weapon_UserDataParams_RapidFire_RE2 do
                                                        local Weapon_UserDataParams_RapidFireParams_RE2 = Weapon_UserDataParams_RapidFire_RE2[i]:get_field("_Param")
                                                        local matched_ParamName = "RapidFire_LVL_" .. string.format("%02d", i)

                                                        if Weapon_UserDataParams_RapidFireParams_RE2 and SubParamName_2nd == matched_ParamName then
                                                            for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                Weapon_UserDataParams_RapidFireParams_RE2[SubParamName_3rd] = SubParamValue_3rd
                                                            end
                                                        end
                                                    end
                                                end
                                            end

                                            if Weapon_UserDataParams_LoopFire_RE2 ~= nil then
                                                for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                    for i = 2, #Weapon_UserDataParams_LoopFire_RE2 do
                                                        local Weapon_UserDataParams_LoopFireParams_RE2 = Weapon_UserDataParams_LoopFire_RE2[i]:get_field("_Param")
                                                        local matched_ParamName = "LoopFire_LVL_" .. string.format("%02d", i)

                                                        if Weapon_UserDataParams_LoopFireParams_RE2 and SubParamName_2nd == matched_ParamName then
                                                            for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                Weapon_UserDataParams_LoopFireParams_RE2[SubParamName_3rd] = SubParamValue_3rd
                                                            end
                                                        end
                                                    end
                                                end
                                            end

                                            if Weapon_UserDataParams_Deviate_RE2 ~= nil then
                                                for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                    for i = 2, #Weapon_UserDataParams_Deviate_RE2 do
                                                        local Weapon_UserDataParams_DeviateParams_RE2 = Weapon_UserDataParams_Deviate_RE2[i]:get_field("_Param")
                                                        local matched_ParamName = "Deviate_LVL_" .. string.format("%02d", i)

                                                        if Weapon_UserDataParams_DeviateParams_RE2 and SubParamName_2nd == matched_ParamName then
                                                            for SubParamName_3rd, SubParamValue_3rd in pairs(SubParamValue_2nd) do
                                                                if Weapon_UserDataParams_DeviateParams_RE2 and SubParamName_3rd == "DeviateYaw" then
                                                                    for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                        local Weapon_UserDataParams_DeviateParamsYaw_RE2 = Weapon_UserDataParams_DeviateParams_RE2:get_field("_TrainOffYaw")
                                                                        

                                                                        if Weapon_UserDataParams_DeviateParamsYaw_RE2 then
                                                                            Weapon_UserDataParams_DeviateParamsYaw_RE2[SubParamName_4th] = SubParamValue_4th
                                                                            func.write_valuetype(Weapon_UserDataParams_DeviateParams_RE2, 0x60, Weapon_UserDataParams_DeviateParamsYaw_RE2)
                                                                        end
                                                                    end
                                                                end
                                                                if Weapon_UserDataParams_DeviateParams_RE2 and SubParamName_3rd == "DeviatePitch" then
                                                                    for SubParamName_4th, SubParamValue_4th in pairs(SubParamValue_3rd) do
                                                                        local Weapon_UserDataParams_DeviateParamsPitch_RE2 = Weapon_UserDataParams_DeviateParams_RE2:get_field("_TrainOffPitch")

                                                                        if Weapon_UserDataParams_DeviateParamsPitch_RE2 then
                                                                            Weapon_UserDataParams_DeviateParamsPitch_RE2[SubParamName_4th] = SubParamValue_4th
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
            end

            if Inventory_GameObject_RE2 then
                local EquipmentManager_RE2 = Inventory_GameObject_RE2:call("getComponent(System.Type)", sdk.typeof("app.ropeway.EquipmentManager"))
                
                if EquipmentManager_RE2 then
                    local weaponParams = AWF_settings.RE2_Weapon_Params[weapon.ID]

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
                                                        for SubParamName_2nd, SubParamValue_2nd in pairs(subParamValue) do
                                                            local AlwaysReloadableVariable_RE2 = PartSettings:get_field("_AlwaysReloadableVariable")

                                                            if AlwaysReloadableVariable_RE2 and weaponParams.Inventory._AlwaysReloadable == true then
                                                                AlwaysReloadableVariable_RE2[SubParamName_2nd] = weaponParams.Inventory.AlwaysReloadableVariable
                                                                func.write_valuetype(PartSettings, 0x38, AlwaysReloadableVariable_RE2)
                                                            elseif AlwaysReloadableVariable_RE2 and weaponParams.Inventory._AlwaysReloadable == false then
                                                                AlwaysReloadableVariable_RE2[SubParamName_2nd] = weaponParams.Inventory.AlwaysReloadableVariable.mData1 + 1
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
        weapon.isUpdated = false
    end
end

local function cache_json_files_RE7(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWF_settings.RE7_Weapon_Params[weapon.ID]
        
        if weaponParams then
            local json_names = AWF_settings.RE7_Weapon_Params[weapon.ID].Weapon_Presets or {}
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

local function cache_json_files_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWF_settings.RE2_Weapon_Params[weapon.ID]
        
        if weaponParams then
            local json_names = AWF_settings.RE2_Weapon_Params[weapon.ID].Weapon_Presets or {}
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
    cache_json_files_RE7(AWF_settings.RE7_Weapons)
elseif reframework.get_game_name() == "re2" then
    cache_json_files_RE2(AWF_settings.RE2_Weapons)
end

local function get_weapon_gameobject_RE7(weaponData)
    for _, weapon in pairs(weaponData) do
        local Weapon_GameObject_RE7 = cached_weapon_GameObjects_RE7[weapon.ID]
        
        if Weapon_GameObject_RE7 then
            log.info("Loaded " .. weapon.Name .. " Game Object from cache")
        end
    end
end

local function get_weapon_gameobject_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        local Weapon_GameObject_RE2 = cached_weapon_GameObjects_RE2[weapon.ID]
        
        if Weapon_GameObject_RE2 then
            log.info("Loaded " .. weapon.Name .. " Game Object from cache")
        end
    end
end

local function update_cached_weapon_gameobjects_RE7()
    if changed or wc or not cached_weapon_GameObjects_RE7 then
        changed = false
        wc = false
        AWF_Weapons_Found = true
        cache_weapon_gameobjects_RE7(AWF_settings.RE7_Weapons)
        get_weapon_gameobject_RE7(AWF_settings.RE7_Weapons)
        log.info("------------ AWF Weapon Data Updated!")
    end
end

local function update_cached_weapon_gameobjects_RE2()
    if changed or wc or not cached_weapon_GameObjects_RE2 then
        changed = false
        wc = false
        AWF_Weapons_Found = true
        cache_weapon_gameobjects_RE2(AWF_settings.RE2_Weapons)
        get_weapon_gameobject_RE2(AWF_settings.RE2_Weapons)
        log.info("------------ AWF Weapon Data Updated!")
    end
end

local function draw_AWF_RE7Editor_GUI(weaponOrder)
    if imgui.begin_window("Advanced Weapon Framework") then
        imgui.begin_rect()
        imgui.button("[===============================| AWF WEAPON STAT EDITOR |===============================]")
        for _, weaponName in ipairs(weaponOrder) do
            local weaponData = AWF_settings.RE7_Weapons[weaponName]
            
            if weaponData and (weaponData.Type ~= "Ammo") and (weaponData.Type ~= "KNF") and imgui.tree_node(string.upper(weaponData.Name)) then
                imgui.begin_rect()
                if imgui.button("Reset to Defaults") then
                    wc = true
                    AWF_settings.RE7_Weapon_Params[weaponData.ID] = func.recurse_def_settings({}, AWFWeapons.RE7_Weapon_Params[weaponData.ID])
                    cache_json_files_RE7(AWF_settings.RE7_Weapons)
                end
                func.tooltip("Reset the parameters of " .. weaponData.Name)

                imgui.same_line()
                imgui.button(" | ")

                imgui.same_line()
                if imgui.button("SAVE") then
                    json.dump_file("AWF/AWF_Weapons/".. weaponData.Name .. "/" .. weaponData.Name .. " Custom".. ".json", AWF_settings.RE7_Weapon_Params[weaponData.ID])
                    log.info("AWF Custom " .. weaponData.Name ..  " Params Saved")
                end
                func.tooltip("Save the current parameters of the " .. weaponData.Name .. " to a .json file found in [RESIDENT EVIL 7  BIOHAZARD/reframework/data/AWF/AWF_Weapons/".. weaponData.Name .. "]")

                imgui.same_line()
                imgui.button(" | ")

                imgui.same_line()
                if imgui.button("Update Preset List") then
                    cache_json_files_RE7(AWF_settings.RE7_Weapons)
                end                
                
                changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].current_param_indx = imgui.combo("Preset", AWF_settings.RE7_Weapon_Params[weaponData.ID].current_param_indx or 1, AWF_settings.RE7_Weapon_Params[weaponData.ID].Weapon_Presets); wc = wc or changed
                func.tooltip("Select a file from the dropdown menu to load the weapon stats from that file.")
                if changed then
                    local selected_profile = AWF_settings.RE7_Weapon_Params[weaponData.ID].Weapon_Presets[AWF_settings.RE7_Weapon_Params[weaponData.ID].current_param_indx]
                    local json_filepath = [[AWF\\AWF_Weapons\\]] .. weaponData.Name .. [[\\]] .. selected_profile .. [[.json]]
                    local temp_params = json.load_file(json_filepath)
                    
                    temp_params.Weapon_Presets = nil
                    temp_params.current_param_indx = nil

                    for key, value in pairs(temp_params) do
                        AWF_settings.RE7_Weapon_Params[weaponData.ID][key] = value
                    end
                end

                changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].IsLoadNumInfinity = imgui.checkbox("Unlimited Capacity", AWF_settings.RE7_Weapon_Params[weaponData.ID].IsLoadNumInfinity); wc = wc or changed
                func.tooltip("If enabled, the weapon does not need to be reloaded.")
                
                imgui.same_line()
                changed, AWF_settings.RE7_Weapon_Params[weaponData.ID].IsBulletStackNumInfinity = imgui.checkbox("Unlimited Ammo", AWF_settings.RE7_Weapon_Params[weaponData.ID].IsBulletStackNumInfinity); wc = wc or changed
                func.tooltip("If enabled, the weapon will never run out of ammo.")

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
                
                imgui.end_rect(2)
                imgui.tree_pop()
            end
            
            if weaponData and weaponData.Type == "Ammo" and imgui.tree_node(string.upper(weaponData.Name)) then
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
            
            if changed or wc then
                weaponData.isUpdated = true
            end
            imgui.separator()
        end
    imgui.end_rect(1)
    imgui.end_window()
    end
end

local function draw_AWF_RE2Editor_GUI(weaponOrder)
    if imgui.begin_window("Advanced Weapon Framework") then
        imgui.begin_rect()
        imgui.button("[===============================| AWF WEAPON STAT EDITOR |===============================]")
        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF_settings.RE2_Weapons[weaponName]

            if weapon and imgui.tree_node(string.upper(weapon.Name)) then
                imgui.begin_rect()
                if imgui.button("Reset to Defaults") then
                    wc = true
                    AWF_settings.RE2_Weapon_Params[weapon.ID] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID])
                    cache_json_files_RE2(AWF_settings.RE2_Weapons)
                end
                func.tooltip("Reset the parameters of " .. weapon.Name)
                
                imgui.same_line()
                imgui.button(" | ")

                imgui.same_line()
                if imgui.button("SAVE") then
                    json.dump_file("AWF/AWF_Weapons/".. weapon.Name .. "/" .. weapon.Name .. " Custom".. ".json", AWF_settings.RE2_Weapon_Params[weapon.ID])
                    log.info("AWF Custom " .. weapon.Name ..  " Params Saved")
                end
                func.tooltip("Save the current parameters of the " .. weapon.Name .. " to a .json file found in [RESIDENT EVIL 2  BIOHAZARD RE2/reframework/data/AWF/AWF_Weapons/".. weapon.Name .. "]")

                imgui.same_line()
                imgui.button(" | ")

                imgui.same_line()
                if imgui.button("Update Preset List") then
                    cache_json_files_RE2(AWF_settings.RE2_Weapons)
                end

                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].current_param_indx = imgui.combo("Preset", AWF_settings.RE2_Weapon_Params[weapon.ID].current_param_indx or 1, AWF_settings.RE2_Weapon_Params[weapon.ID].Weapon_Presets); wc = wc or changed
                func.tooltip("Select a file from the dropdown menu to load the weapon stats from that file.")
                if changed then
                    local selected_profile = AWF_settings.RE2_Weapon_Params[weapon.ID].Weapon_Presets[AWF_settings.RE2_Weapon_Params[weapon.ID].current_param_indx]
                    local json_filepath = [[AWF\\AWF_Weapons\\]] .. weapon.Name .. [[\\]] .. selected_profile .. [[.json]]
                    local temp_params = json.load_file(json_filepath)
                    
                    temp_params.Weapon_Presets = nil
                    temp_params.current_param_indx = nil

                    for key, value in pairs(temp_params) do
                        AWF_settings.RE2_Weapon_Params[weapon.ID][key] = value
                    end
                end

                if AWF_settings.RE2_Weapon_Params[weapon.ID].Inventory then
                    if isDEBUG then
                        changed, AWF_settings.RE2_Weapon_Params[weapon.ID].EnableExecuteFire = imgui.checkbox("[DEBUG] Enable Fire", AWF_settings.RE2_Weapon_Params[weapon.ID].EnableExecuteFire); wc = wc or changed
                        func.tooltip("[DEBUG] If disabled, the weapon can't fire. Also a debug option so if you see this IDK what you are doing.")

                        imgui.same_line()
                    end
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Inventory._Infinity = imgui.checkbox("Unlimited Capacity", AWF_settings.RE2_Weapon_Params[weapon.ID].Inventory._Infinity); wc = wc or changed
                    func.tooltip("If enabled, the weapon does not need to be reloaded.")

                    imgui.same_line()
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Inventory._AlwaysReloadable = imgui.checkbox("Unlimited Ammo", AWF_settings.RE2_Weapon_Params[weapon.ID].Inventory._AlwaysReloadable); wc = wc or changed
                    func.tooltip("If enabled, the weapon will never run out of ammo.")

                    imgui.spacing()

                    if imgui.button("Reset Inventory Parameters") then
                        wc = true
                        AWF_settings.RE2_Weapon_Params[weapon.ID].Inventory = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].Inventory)
                    end
                    
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Inventory._Number = imgui.drag_int("Ammo Capacity",AWF_settings.RE2_Weapon_Params[weapon.ID].Inventory._Number, 1, 0, 1000); wc = wc or changed
                    func.tooltip("The maximum number of rounds the weapon can hold. Higher is better.")
                    
                    if (weapon.ID == "wp0000") or (weapon.ID == "wp0200") or (weapon.ID == "wp0800") or (weapon.ID == "wp1000") or (weapon.ID == "wp2000") then
                        changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Inventory._NumberEX = imgui.drag_int("EX Ammo Capacity",AWF_settings.RE2_Weapon_Params[weapon.ID].Inventory._NumberEX, 1, 0, 1000); wc = wc or changed
                        func.tooltip("The maximum number of rounds the upgraded weapon can hold. Higher is better.")
                    end
                end

                imgui.spacing()

                if AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator then
                    local shellGenTypes = AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator
                    local sortedKeys = {}

                    for i in pairs(shellGenTypes) do
                        table.insert(sortedKeys, i)
                    end
                    table.sort(sortedKeys)

                    for k, i in pairs(sortedKeys) do
                        if i:match("^BallisticSettingNormal") then
                            if AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Slur = imgui.drag_float("Spread", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Slur, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread. Lower is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit = imgui.drag_float("Spread Fit", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum = imgui.drag_int("HitNum", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("Number of bullets on impact. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit = imgui.drag_int("HitNumBonusFit", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical = imgui.drag_int("HitNumBonusCritical", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue = imgui.drag_int("PerformanceValue", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue, 1, 0, 100); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Speed = imgui.drag_float("Speed", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Speed, 5.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The velocity of the bullet. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange = imgui.drag_float("FiringRange", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The maximum range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange = imgui.drag_float("EffectiveRange", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The effective range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity = imgui.drag_float("Gravity", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The strength of the gravitational force on the bullet.")
                            end
                        end

                        if i:match("^BallisticSettingEx") then
                            if AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset EX Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                if weapon.ID == "wp0800" then
                                    imgui.text("In this case EX refers to the High-Powered Rounds.")
                                elseif weapon.ID == "wp1000" then
                                    imgui.text("In this case EX refers to the Center Pellet.")
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Slur = imgui.drag_float("EX Spread", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Slur, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread. Lower is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit = imgui.drag_float("EX Spread Fit", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum = imgui.drag_int("EX HitNum", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("Number of bullets on impact. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit = imgui.drag_int("EX HitNumBonusFit", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical = imgui.drag_int("EX HitNumBonusCritical", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue = imgui.drag_int("EX PerformanceValue", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue, 1, 0, 100); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Speed = imgui.drag_float("EX Speed", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Speed, 5.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The velocity of the bullet. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange = imgui.drag_float("EX FiringRange", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The maximum range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange = imgui.drag_float("EX EffectiveRange", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The effective range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity = imgui.drag_float("EX Gravity", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The strength of the gravitational force on the bullet.")
                            end
                        end

                        if i:match("^BallisticSettingAcid") then
                            if AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Acid Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                if weapon.ID == "wp4100" then
                                    imgui.text("In this case Acid refers to the Acid Rounds.")
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Slur = imgui.drag_float("Acid Spread", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Slur, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread. Lower is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit = imgui.drag_float("Acid Spread Fit", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum = imgui.drag_int("Acid HitNum", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("Number of bullets on impact. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit = imgui.drag_int("Acid HitNumBonusFit", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical = imgui.drag_int("Acid HitNumBonusCritical", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue = imgui.drag_int("Acid PerformanceValue", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue, 1, 0, 100); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Speed = imgui.drag_float("Acid Speed", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Speed, 5.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The velocity of the bullet. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange = imgui.drag_float("Acid FiringRange", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The maximum range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange = imgui.drag_float("Acid EffectiveRange", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The effective range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity = imgui.drag_float("Acid Gravity", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The strength of the gravitational force on the bullet.")
                            end
                        end

                        if i:match("^BallisticSettingFire") then
                            if AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Fire Bullet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                if weapon.ID == "wp4100" then
                                    imgui.text("In this case Fire refers to the Fire Rounds.")
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Slur = imgui.drag_float("Fire Spread", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Slur, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread. Lower is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit = imgui.drag_float("Fire Spread Fit", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._SlurFit, 0.01, -10.0, 10.0); wc = wc or changed
                                func.tooltip("Weapon spread when the reticle is focused. Lower is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum = imgui.drag_int("Fire HitNum", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("Number of bullets on impact. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit = imgui.drag_int("Fire HitNumBonusFit", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusFit, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical = imgui.drag_int("Fire HitNumBonusCritical", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._HitNumBonusCritical, 1, 0, 100); wc = wc or changed
                                func.tooltip("The additional number of bullets on impact on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue = imgui.drag_int("Fire PerformanceValue", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._PerformanceValue, 1, 0, 100); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Speed = imgui.drag_float("Fire Speed", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Speed, 5.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The velocity of the bullet. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange = imgui.drag_float("Fire FiringRange", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._FiringRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The maximum range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange = imgui.drag_float("Fire EffectiveRange", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._EffectiveRange, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The effective range of the weapon. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity = imgui.drag_float("Fire Gravity", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i]._Gravity, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("The strength of the gravitational force on the bullet.")
                            end
                        end

                        if i:match("^AttackSettingNormal") then
                            if AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Attack Settings") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                if weapon.Type ~="FT" then
                                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio = imgui.drag_int("Critical Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                    func.tooltip("The chance of landing a critical hit. Higher is better.")
                                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio = imgui.drag_int("Fit Critical Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                    func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue = imgui.drag_float("Base Damage", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base damage. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue = imgui.drag_float("Base Wince", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base stopping power. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue = imgui.drag_float("Base Break", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base dismemberment power. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue = imgui.drag_float("Base Damage Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base damage multiplier. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue = imgui.drag_float("Base Wince Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base stopping power multiplier. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue = imgui.drag_float("Base Break Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base dismemberment power multiplier. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage = imgui.drag_float("Fit Damage Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince = imgui.drag_float("Fit Wince Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break = imgui.drag_float("Fit Break Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage = imgui.drag_float("Critical Damage Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince = imgui.drag_float("Critical Wince Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break = imgui.drag_float("Critical Break Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier on a critical hit. Higher is better.")
                            end
                        end

                        if i:match("^AttackSettingEx") then
                            if AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset EX Attack Settings") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                if weapon.ID == "wp0800" then
                                    imgui.text("In this case EX refers to the High-Powered Rounds.")
                                elseif weapon.ID == "wp1000" then
                                    imgui.text("In this case EX refers to the Center Pellet.")
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio = imgui.drag_int("EX Critical Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio = imgui.drag_int("EX Fit Critical Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")
                                
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue = imgui.drag_float("EX Base Damage", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base damage. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue = imgui.drag_float("EX Base Wince", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base stopping power. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue = imgui.drag_float("EX Base Break", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base dismemberment power. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue = imgui.drag_float("EX Base Damage Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base damage multiplier. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue = imgui.drag_float("EX Base Wince Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base stopping power multiplier. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue = imgui.drag_float("EX Base Break Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base dismemberment power multiplier. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage = imgui.drag_float("EX Fit Damage Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince = imgui.drag_float("EX Fit Wince Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break = imgui.drag_float("EX Fit Break Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage = imgui.drag_float("EX Critical Damage Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince = imgui.drag_float("EX Critical Wince Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break = imgui.drag_float("EX Critical Break Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier on a critical hit. Higher is better.")
                            end
                        end

                        if i:match("^AttackSettingAcid") then
                            if AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Acid Attack Settings") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio = imgui.drag_int("Acid Critical Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio = imgui.drag_int("Acid Fit Critical Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")

                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue = imgui.drag_float("Acid Base Damage", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base damage. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue = imgui.drag_float("Acid Base Wince", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base stopping power. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue = imgui.drag_float("Acid Base Break", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base dismemberment power. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue = imgui.drag_float("Acid Base Damage Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base damage multiplier. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue = imgui.drag_float("Acid Base Wince Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base stopping power multiplier. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue = imgui.drag_float("Acid Base Break Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base dismemberment power multiplier. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage = imgui.drag_float("Acid Fit Damage Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince = imgui.drag_float("Acid Fit Wince Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break = imgui.drag_float("Fit Break Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage = imgui.drag_float("Acid Critical Damage Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince = imgui.drag_float("Acid Critical Wince Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break = imgui.drag_float("Acid Critical Break Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier on a critical hit. Higher is better.")
                            end
                        end

                        if i:match("^AttackSettingFire") then
                            if AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Fire Attack Settings") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio = imgui.drag_int("Fire Critical Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio = imgui.drag_int("Fire Fit Critical Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitCriticalRatio._Ratio, 1, 0, 100); wc = wc or changed
                                func.tooltip("The chance of landing a critical hit when the reticle is focused. Higher is better.")

                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue = imgui.drag_float("Fire Base Damage", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Damage._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base damage. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue = imgui.drag_float("Fire Base Wince", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Wince._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base stopping power. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue = imgui.drag_float("Fire Base Break", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Normal.Break._BaseValue, 1.0, 0.0, 1000.0); wc = wc or changed
                                func.tooltip("The weapon's base dismemberment power. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue = imgui.drag_float("Fire Base Damage Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Damage._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base damage multiplier. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue = imgui.drag_float("Fire Base Wince Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Wince._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base stopping power multiplier. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue = imgui.drag_float("Fire Base Break Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].NormalRate.Break._BaseValue, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Base dismemberment power multiplier. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage = imgui.drag_float("Fire Fit Damage Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince = imgui.drag_float("Fire Fit Wince Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break = imgui.drag_float("Fire Fit Break Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].FitRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier when the reticle is focused. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage = imgui.drag_float("Fire Critical Damage Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Damage, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Damage multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince = imgui.drag_float("Fire Critical Wince Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Wince, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Stopping power multiplier on a critical hit. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break = imgui.drag_float("Fire Critical Break Multiplier", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].CriticalRatioContainer.Break, 1.0, 0.0, 100.0); wc = wc or changed
                                func.tooltip("Dismemberment power multiplier on a critical hit. Higher is better.")
                            end
                        end

                        if i:match("^Normal") then
                            if AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Around Pellet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletNum = imgui.drag_int("Around Pellet Count", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("The number of pellets fired by a shotgun. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletDegree = imgui.drag_float("Around Pellet Angle", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletDegree, 0.1, 0.0, 180.0); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletLength = imgui.drag_float("Around Pellet Length", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletLength, 0.1, 0.0, 100.0); wc = wc or changed
                                func.tooltip("TBD")
                            end
                        end

                        if i:match("^Fit") then
                            if AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Center Pellet Ballistic Parameters") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletNum = imgui.drag_int("Center Pellet Count", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletNum, 1, 0, 100); wc = wc or changed
                                func.tooltip("The number of pellets fired by a shotgun. Higher is better.")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletDegree = imgui.drag_float("Center Pellet Angle", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletDegree, 0.1, 0.0, 180.0); wc = wc or changed
                                func.tooltip("TBD")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletLength = imgui.drag_float("Center Pellet Length", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].AroundBulletLength, 0.1, 0.0, 100.0); wc = wc or changed
                                func.tooltip("TBD")
                            end
                        end

                        if i:match("^RadiateSettings") then
                            if AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] then
                                imgui.spacing()
                                if imgui.button("Reset Radiate Parameters") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].ShellGenerator[i])
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].RadiateLength = imgui.drag_float("Flame Jet Length", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].RadiateLength, 0.1, 0.0, 100.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Radius._BaseValue = imgui.drag_float("Flame Jet Radius", AWF_settings.RE2_Weapon_Params[weapon.ID].ShellGenerator[i].Radius._BaseValue, 0.1, 0.0, 100.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                            end
                        end
                    end
                end

                imgui.spacing()

                if AWF_settings.RE2_Weapon_Params[weapon.ID].Recoil then
                    if imgui.button("Reset Recoil Parameters") then
                        wc = true
                        AWF_settings.RE2_Weapon_Params[weapon.ID].Recoil = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].Recoil)
                    end
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Recoil._RecoilRate = imgui.drag_float("Recoil Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].Recoil._RecoilRate, 0.05, 0.0, 100.0); wc = wc or changed
                    func.tooltip("The strength of the visual recoil on the player. Lower is better.")
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Recoil._RecoilDampRate = imgui.drag_float("Recoil Damp Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].Recoil._RecoilDampRate, 0.01, 0.0, 100.0); wc = wc or changed
                    func.tooltip("The damping of the visual recoil on the player. Higher is better.")
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Recoil.RecoilRateRange.r = imgui.drag_float("Recoil Max", AWF_settings.RE2_Weapon_Params[weapon.ID].Recoil.RecoilRateRange.r, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("TBD")
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Recoil.RecoilRateRange.s = imgui.drag_float("Recoil Min", AWF_settings.RE2_Weapon_Params[weapon.ID].Recoil.RecoilRateRange.s, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("TBD")
                end
                
                imgui.spacing()

                if AWF_settings.RE2_Weapon_Params[weapon.ID].LoopFire then
                    if imgui.button("Reset Loop Fire Parameters") then
                        wc = true
                        AWF_settings.RE2_Weapon_Params[weapon.ID].LoopFire = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].LoopFire)
                    end
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].LoopFire._Interval = imgui.drag_float("Loop Fire Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].LoopFire._Interval, 0.1, 0.0, 100.0); wc = wc or changed
                    func.tooltip("The speed at which the weapon depletes ammo. Lower is better.")
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].LoopFire._ReduceNumber = imgui.drag_int("Loop Fire Ammo Cost", AWF_settings.RE2_Weapon_Params[weapon.ID].LoopFire._ReduceNumber, 1, 0, 1000); wc = wc or changed
                    func.tooltip("The quantity of ammo expended per iteration. Lower is better.")
                end

                imgui.spacing()

                if AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle then
                    if imgui.button("Reset Reticle Parameters") then
                        wc = true
                        AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].Reticle)
                    end
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._AddPoint = imgui.drag_float("Reticle Add Point", AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._AddPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points added over time by standing still while aiming.")
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._KeepPoint = imgui.drag_float("Reticle Keep Point", AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._KeepPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points required for the reticle to enter the focused state.")
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._ShootPoint = imgui.drag_float("Reticle Shoot Point", AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._ShootPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points subtracted for shooting.")
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._MovePoint = imgui.drag_float("Reticle Move Point", AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._MovePoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points subtracted for moving.")
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._WatchPoint = imgui.drag_float("Reticle Watch Point", AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle._WatchPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The amount of points added over time by while the reticle is focused.")
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle.PointRange.r = imgui.drag_float("Reticle Max", AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle.PointRange.r, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The maximum range of points.")
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle.PointRange.s = imgui.drag_float("Reticle Min", AWF_settings.RE2_Weapon_Params[weapon.ID].Reticle.PointRange.s, 1.0, -1000.0, 1000.0); wc = wc or changed
                    func.tooltip("The minimum range of points.")
                end

                imgui.spacing()

                if AWF_settings.RE2_Weapon_Params[weapon.ID].Deviate then
                    if imgui.button("Reset Deviate Parameters") then
                        wc = true
                        AWF_settings.RE2_Weapon_Params[weapon.ID].Deviate = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].Deviate)
                    end
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Deviate.DeviateYaw.r = imgui.drag_float("Deviate Yaw Max", AWF_settings.RE2_Weapon_Params[weapon.ID].Deviate.DeviateYaw.r, 0.01, -100.0, 100.0); wc = wc or changed
                    func.tooltip("Recoil maximum on the X axis.")
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Deviate.DeviateYaw.s = imgui.drag_float("Deviate Yaw Min", AWF_settings.RE2_Weapon_Params[weapon.ID].Deviate.DeviateYaw.s, 0.01, -100.0, 100.0); wc = wc or changed
                    func.tooltip("Recoil minimum on the X axis.")
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Deviate.DeviatePitch.r = imgui.drag_float("Deviate Pitch Max", AWF_settings.RE2_Weapon_Params[weapon.ID].Deviate.DeviatePitch.r, 0.01, -100.0, 100.0); wc = wc or changed
                    func.tooltip("Recoil maximum on the Y axis.")
                    changed, AWF_settings.RE2_Weapon_Params[weapon.ID].Deviate.DeviatePitch.s = imgui.drag_float("Deviate Pitch Min", AWF_settings.RE2_Weapon_Params[weapon.ID].Deviate.DeviatePitch.s, 0.01, -100.0, 100.0); wc = wc or changed
                    func.tooltip("Recoil minimum on the Y axis.")
                end

                imgui.spacing()

                if AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun then
                    local upgradeLVL = AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun
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
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].UserData.Gun[i])
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._AddPoint = imgui.drag_float("LVL-" .. j .. " Reticle Add Point", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._AddPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._KeepPoint = imgui.drag_float("LVL-" .. j .. " Reticle Keep Point", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._KeepPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._ShootPoint = imgui.drag_float("LVL-" .. j .. " Reticle Shoot Point", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._ShootPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._MovePoint = imgui.drag_float("LVL-" .. j .. " Reticle Move Point", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._MovePoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._WatchPoint = imgui.drag_float("LVL-" .. j .. " Reticle Watch Point", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._WatchPoint, 1.0, -1000.0, 1000.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].PointRange.r = imgui.drag_float("LVL-" .. j .. " Reticle Max", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].PointRange.r, 1.0, -1000.0, 1000.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].PointRange.s = imgui.drag_float("LVL-" .. j .. " Reticle Min", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].PointRange.s, 1.0, -1000.0, 1000.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                            end
                            if i:match("^Recoil_LVL_(%d+)$") then
                                local j = i:match("%d+$")

                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Recoil Parameters") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].UserData.Gun[i])
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._RecoilRate = imgui.drag_float("LVL-" .. j .. " Recoil Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._RecoilRate, 0.05, 0.0, 100.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._RecoilDampRate = imgui.drag_float("LVL-" .. j .. " Recoil Damp Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._RecoilDampRate, 0.01, 0.0, 100.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].RecoilRateRange.r = imgui.drag_float("LVL-" .. j .. " Recoil Max", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].RecoilRateRange.r, 1.0, -1000.0, 1000.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].RecoilRateRange.s = imgui.drag_float("LVL-" .. j .. " Recoil Min", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].RecoilRateRange.s, 1.0, -1000.0, 1000.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                            end
                            if i:match("^RapidFire_LVL_(%d+)$") then
                                local j = i:match("%d+$")

                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Rapid Fire Parameters") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].UserData.Gun[i])
                                end

                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._Number = imgui.drag_int("LVL-" .. j .. " Burst Count", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._Number, 1, 0, 1000); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._Infinity = imgui.checkbox("LVL-" .. j .. "_Infinity", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._Infinity); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                            end

                            if i:match("^LoopFire_LVL_(%d+)$") then
                                local j = i:match("%d+$")

                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Loop Fire Parameters") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].UserData.Gun[i])
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._Interval = imgui.drag_float("LVL-" .. j .. " Loop Fire Rate", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._Interval, 0.1, 0.0, 100.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._ReduceNumber = imgui.drag_int("LVL-" .. j .. " Loop Fire Ammo Cost", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i]._ReduceNumber, 1, 0, 1000); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                            end

                            if i:match("^Deviate_LVL_(%d+)$") then
                                local j = i:match("%d+$")

                                imgui.spacing()

                                if imgui.button("Reset Level-" .. j .. " Deviate Parameters") then
                                    wc = true
                                    AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i] = func.recurse_def_settings({}, AWFWeapons.RE2_Weapon_Params[weapon.ID].UserData.Gun[i])
                                end
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].DeviateYaw.r = imgui.drag_float("LVL-" .. j .. " Deviate Yaw Max", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].DeviateYaw.r, 0.01, -100.0, 100.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].DeviateYaw.s = imgui.drag_float("LVL-" .. j .. " Deviate Yaw Min", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].DeviateYaw.s, 0.01, -100.0, 100.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].DeviatePitch.r = imgui.drag_float("LVL-" .. j .. " Deviate Pitch Max", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].DeviatePitch.r, 0.01, -100.0, 100.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
                                changed, AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].DeviatePitch.s = imgui.drag_float("LVL-" .. j .. " Deviate Pitch Min", AWF_settings.RE2_Weapon_Params[weapon.ID].UserData.Gun[i].DeviatePitch.s, 0.01, -100.0, 100.0); wc = wc or changed
                                --func.tooltip("LOREM IPSUM")
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

re.on_draw_ui(function()
	if reframework.get_game_name() == "re7" then
        if imgui.tree_node("Advanced Weapon Framework") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_settings = func.recurse_def_settings({}, AWFWeapons)
                cache_json_files_RE7(AWF_settings.RE7_Weapons)
            end
            func.tooltip("Reset every parameter.")

            changed, show_AWF_editor = imgui.checkbox("Open AWF Weapon Stat Editor", show_AWF_editor)
            func.tooltip("Show/Hide the Weapon Stat Editor.")

            if show_AWF_editor then
                draw_AWF_RE7Editor_GUI(AWFWeapons.RE7_Weapon_Order)
            end

            if changed or wc or NowLoading then
                json.dump_file("AWF/AWF_Settings.json", AWF_settings)
            end

            ui.button_n_colored_txt("Current Version:", "v1.4.45 | 01/24/2024", 0xFF00FF00)
            imgui.same_line()
            imgui.text("| by SilverEzredes")
            imgui.end_rect(2)
            imgui.tree_pop()
        end
    end
    if reframework.get_game_name() == "re2" then
        if imgui.tree_node("Advanced Weapon Framework") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_settings = func.recurse_def_settings({}, AWFWeapons)
                cache_json_files_RE2(AWF_settings.RE2_Weapons)
            end
            func.tooltip("Reset every parameter.")
            
            changed, show_AWF_editor = imgui.checkbox("Open AWF Weapon Stat Editor", show_AWF_editor)
            func.tooltip("Show/Hide the AWF Weapon Stat Editor.")

            if show_AWF_editor then
                draw_AWF_RE2Editor_GUI(AWF_settings.RE2_Weapon_Order)
            end

            if changed or wc or NowLoading then
                json.dump_file("AWF/AWF_Settings.json", AWF_settings)
            end
            
            ui.button_n_colored_txt("Current Version:", "v1.4.43 | 01/24/2024", 0xFF00FF00)
            imgui.same_line()
            imgui.text("| by SilverEzredes")
            
            imgui.end_rect(2)
            imgui.tree_pop()
        end
    end
end)

return {
    AWF_Master = AWFWeapons,
    AWF_settings = AWF_settings,
    update_cached_weapon_gameobjects_RE7 = update_cached_weapon_gameobjects_RE7,
    cache_weapon_gameobjects_RE7 = cache_weapon_gameobjects_RE7,
    get_weapon_gameobject_RE7 = get_weapon_gameobject_RE7,
    update_cached_weapon_gameobjects_RE2 = update_cached_weapon_gameobjects_RE2,
    cache_weapon_gameobjects_RE2 = cache_weapon_gameobjects_RE2,
    get_weapon_gameobject_RE2 = get_weapon_gameobject_RE2,
}