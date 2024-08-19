local RE2R_WeaponData = { 
    Weapons = {
        VP70    = {ID = "wp0000",   Name = "Matilda",                             Type = "HG"},
        M19     = {ID = "wp0100",   Name = "M19",                                 Type = "HG"},
        JMB     = {ID = "wp0200",   Name = "JMB Hp3",                             Type = "HG"},
        SAA     = {ID = "wp0300",   Name = "Quickdraw Army",                      Type = "HG"},
        MUP     = {ID = "wp0600",   Name = "MUP",                                 Type = "HG"},
        HSC     = {ID = "wp0700",   Name = "Broom Hc",                            Type = "HG"},
        SLS60   = {ID = "wp0800",   Name = "SLS 60",                              Type = "HG"},
        W870    = {ID = "wp1000",   Name = "W-870",                               Type = "SG"},
        MQ11    = {ID = "wp2000",   Name = "MQ 11",                               Type = "SMG"},
        LE5     = {ID = "wp2200",   Name = "LE 5",                                Type = "SMG"},
        DE50    = {ID = "wp3000",   Name = "Lightning Hawk",                      Type = "MAG"},
        GM79    = {ID = "wp4100",   Name = "GM 79",                               Type = "GL"},
        CFT     = {ID = "wp4200",   Name = "Chemical Flamethrower",               Type = "FT"},
        SPRK    = {ID = "wp4300",   Name = "Spark Shot",                          Type = "GL"},
        ATM4    = {ID = "wp4400",   Name = "ATM-4",                               Type = "GL"},
        KNF     = {ID = "wp4500",   Name = "Combat Knife",                        Type = "KNF"},
        KNF_INF = {ID = "wp4510",   Name = "Combat Knife - Unbreakable",          Type = "KNF"},
        ATR     = {ID = "wp4600",   Name = "Anti-Tank Rocket",                    Type = "GL"},
        MINI    = {ID = "wp4700",   Name = "Minigun",                             Type = "SMG"},
        SE_OG   = {ID = "wp7000",   Name = "Samurai Edge - Original Model",       Type = "HG"},
        SE_C    = {ID = "wp7010",   Name = "Samurai Edge - Chris Model",          Type = "HG"},
        SE_J    = {ID = "wp7020",   Name = "Samurai Edge - Jill Model",           Type = "HG"},
        SE_A    = {ID = "wp7030",   Name = "Samurai Edge - Albert Model",         Type = "HG"},
        ATM4_2  = {ID = "wp8400",   Name = "ATM-4 - Unlimited",                   Type = "GL"},
        MINI_2  = {ID = "wp8700",   Name = "Minigun - Unlimited",                 Type = "SMG"},
    },
    Weapon_Params = {
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
    Weapon_Order = {
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
}

return RE2R_WeaponData