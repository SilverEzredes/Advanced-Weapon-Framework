local RE3R_WeaponData = {
    Weapons = {
        G19     =   {ID = "wp0000",   Name = "G19 Handgun",                     Type = "HG"},
        G18B    =   {ID = "wp0100",   Name = "G18 Handgun - Burst",             Type = "HG"},
        G18     =   {ID = "wp0200",   Name = "G18 Handgun",                     Type = "HG"},
        SE      =   {ID = "wp0300",   Name = "Samurai Edge",                    Type = "HG"},
        MUP     =   {ID = "wp0600",   Name = "MUP Handgun - Infinite",          Type = "HG"},
        M3      =   {ID = "wp1000",   Name = "M3 Shotgun",                      Type = "SG"},
        CQBR    =   {ID = "wp2000",   Name = "CQBR Assault Rifle",              Type = "AR"},
        CQBR2   =   {ID = "wp2100",   Name = "CQBR Assault Rifle - Infinite",   Type = "AR"},
        DE44    =   {ID = "wp3000",   Name = ".44 AE Lightning Hawk",           Type = "MAG"},
        RAID    =   {ID = "wp3100",   Name = "RAI-DEN",                         Type = "MAG"},
        MGL     =   {ID = "wp4100",   Name = "MGL Grenade Launcher",            Type = "GL"},
        ATM4    =   {ID = "wp4400",   Name = "Rocket Launcher - Infinite",      Type = "GL"},
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
                _AddPoint = 84.0,
                _KeepPoint = 90.0,
                _ShootPoint = -12.0,
                _MovePoint = -1000.0,
                _WatchPoint = 0.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = -0.0035,
                    r = 0.0087,
                },
                DeviatePitch = {
                    s = 0.017,
                    r = 0.007,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.02,
                    _SlurFit = 0.008,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 40.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 3,
                    },
                    FitCriticalRatio = {
                        _Ratio = 6,
                    },
                    SlowCriticalRatio = {
                        _Ratio = 20,
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
                        Accumulate = {
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
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.1,
                        Break = 1.1,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 4.0,
                        Wince = 10000.0,
                        Break = 10000.0,
                        Accumulate = 1.0,
                    },
                },
            },
            UserData = {
                Gun = {
                    Reticle_LVL_02 = {
                        _AddPoint = 50.0,
                        _KeepPoint = 100.0,
                        _ShootPoint = -25.0,
                        _MovePoint = -1000.0,
                        _WatchPoint = 0.0,
                        PointRange = {
                            s = 0.0,
                            r = 100.0,
                        },
                    },
                    Reticle_LVL_03 = {
                        _AddPoint = 350.0,
                        _KeepPoint = 96.0,
                        _ShootPoint = -8.0,
                        _MovePoint = -1000.0,
                        _WatchPoint = 0.0,
                        PointRange = {
                            s = 0.0,
                            r = 100.0,
                        },
                    },
                    Reticle_LVL_04 = {
                        _AddPoint = 180.0,
                        _KeepPoint = 96.0,
                        _ShootPoint = -18.0,
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
                            s = 0.6,
                            r = 0.1,
                        },
                    },
                    Deviate_LVL_02 = {
                        DeviateYaw = {
                            s = -0.009,
                            r = 0.019,
                        },
                        DeviatePitch = {
                            s = 0.038,
                            r = 0.009,
                        },
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 15,
                _NumberEX = 18,
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
        },
        wp0100 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 3,
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
                    s = -0.003,
                    r = 0.007,
                },
                DeviatePitch = {
                    s = 0.005,
                    r = 0.002,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.01,
                    _SlurFit = 0.008,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 40.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 2,
                    },
                    FitCriticalRatio = {
                        _Ratio = 4,
                    },
                    SlowCriticalRatio = {
                        _Ratio = 10,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 110.0,
                        },
                        Wince = {
                            _BaseValue = 30.0
                        },
                        Break = {
                            _BaseValue = 20.0
                        },
                        Accumulate = {
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
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.6,
                        Break = 1.2,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 10000.0,
                        Break = 10000.0,
                        Accumulate = 1.0,
                    },
                },
            },
            UserData = {},
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 33,
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
                _AddPoint = 77.0,
                _KeepPoint = 90.0,
                _ShootPoint = -15.0,
                _MovePoint = -1000.0,
                _WatchPoint = -150.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = -0.005,
                    r = 0.012,
                },
                DeviatePitch = {
                    s = 0.014,
                    r = 0.007,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.023,
                    _SlurFit = 0.008,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 40.0,
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
                    SlowCriticalRatio = {
                        _Ratio = 18,
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
                        Accumulate = {
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
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.6,
                        Break = 1.2,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 10000.0,
                        Break = 10000.0,
                        Accumulate = 1.0,
                    },
                },
            },
            UserData = {},
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 18,
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
                _AddPoint = 550.0,
                _KeepPoint = 96.0,
                _ShootPoint = -10.0,
                _MovePoint = -700.0,
                _WatchPoint = 0.0,
                PointRange = {
                    s = 10.0,
                    r = 90.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = -0.003,
                    r = 0.010,
                },
                DeviatePitch = {
                    s = 0.014,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.015,
                    _SlurFit = 0.008,
                    _HitNum = 1,
                    _HitNumBonusFit = 1,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 40.0,
                    _EffectiveRange = 13.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 6,
                    },
                    FitCriticalRatio = {
                        _Ratio = 10,
                    },
                    SlowCriticalRatio = {
                        _Ratio = 30,
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
                        Accumulate = {
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
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.2,
                        Break = 1.2,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 10000.0,
                        Break = 10000.0,
                        Accumulate = 1.0,
                    },
                },
            },
            UserData = {},
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
                _ShootPoint = -12.0,
                _MovePoint = -1000.0,
                _WatchPoint = 0.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = -0.005,
                    r = 0.012,
                },
                DeviatePitch = {
                    s = 0.009,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.01,
                    _SlurFit = 0.001,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 40.0,
                    _EffectiveRange = 13.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 4,
                    },
                    FitCriticalRatio = {
                        _Ratio = 6,
                    },
                    SlowCriticalRatio = {
                        _Ratio = 15,
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
                        Accumulate = {
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
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.5,
                        Break = 1.2,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 10000.0,
                        Break = 10000.0,
                        Accumulate = 1.0,
                    },
                },
            },
            UserData = {},
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = true,
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
                    r = 0.047,
                },
                DeviatePitch = {
                    s = 0.079,
                    r = 0.017,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.02,
                    _SlurFit = 0.01,
                    _HitNum = 2,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 1,
                    _Speed = 150.0,
                    _FiringRange = 10.0,
                    _EffectiveRange = 10.0,
                    _Gravity = 0.0,
                },
                BallisticSettingEx = {
                    _Slur = 0.02,
                    _SlurFit = 0.01,
                    _HitNum = 2,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 1,
                    _Speed = 160.0,
                    _FiringRange = 10.0,
                    _EffectiveRange = 10.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    SlowCriticalRatio = {
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
                        Accumulate = {
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
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 4.0,
                        Wince = 1.0,
                        Break = 1.0,
                        Accumulate = 1.0,
                    },
                },
                AttackSettingEx = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    SlowCriticalRatio = {
                        _Ratio = 0,
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
                        Accumulate = {
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
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 3.0,
                        Break = 2.0,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 4.0,
                        Wince = 2.0,
                        Break = 2.0,
                        Accumulate = 1.0,
                    },
                },
                Normal = {
                    AroundBulletNum = 30,
                    AroundBulletDegree = 12.0,
                    AroundBulletLength = 0.2
                },
                Fit = {
                    AroundBulletNum = 30,
                    AroundBulletDegree = 12.0,
                    AroundBulletLength = 0.1
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
                            s = 0.035,
                            r = 0.017,
                        },
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 4,
                _NumberEX = 6,
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
        },
        wp2000 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.3,
                RecoilRateRange = {
                    s = 0.0,
                    r = 0.1,
                },
            },
            Reticle = {
                _AddPoint = 50.0,
                _KeepPoint = 99.0,
                _ShootPoint = -5.0,
                _MovePoint = -300.0,
                _WatchPoint = -50.0,
                PointRange = {
                    s = 50.0,
                    r = 50.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.0,
                },
                DeviatePitch = {
                    s = 0.01,
                    r = 0.0,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.12,
                    _SlurFit = 0.0,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 1,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 40.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 2,
                    },
                    FitCriticalRatio = {
                        _Ratio = 2,
                    },
                    SlowCriticalRatio = {
                        _Ratio = 10,
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
                        Accumulate = {
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
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 2.0,
                        Break = 1.3,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 10000.0,
                        Break = 10000.0,
                        Accumulate = 1.0,
                    },
                },
            },
            UserData = {
                Gun = {
                    Reticle_LVL_02 = {
                        _AddPoint = 75.0,
                        _KeepPoint = 99.0,
                        _ShootPoint = -1.0,
                        _MovePoint = -1000.0,
                        _WatchPoint = -75.0,
                        PointRange = {
                            s = 75.0,
                            r = 25.0,
                        },
                    },
                    Recoil_LVL_02 = {
                        _RecoilRate = 0.07,
                        _RecoilDampRate = 0.3,
                        RecoilRateRange = {
                            s = 0.0,
                            r = 0.07,
                        },
                    },
                    Deviate_LVL_02 = {
                        DeviateYaw = {
                            s = 0.0,
                            r = 0.0,
                        },
                        DeviatePitch = {
                            s = 0.003,
                            r = 0.002,
                        },
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
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
        },
        wp2100 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 0.1,
                _RecoilDampRate = 0.3,
                RecoilRateRange = {
                    s = 0.0,
                    r = 0.1,
                },
            },
            Reticle = {
                _AddPoint = 50.0,
                _KeepPoint = 99.0,
                _ShootPoint = -3.0,
                _MovePoint = -300.0,
                _WatchPoint = -50.0,
                PointRange = {
                    s = 50.0,
                    r = 50.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = 0.0,
                    r = 0.0,
                },
                DeviatePitch = {
                    s = 0.01,
                    r = 0.0,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.05,
                    _SlurFit = 0.0,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 40.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 2,
                    },
                    FitCriticalRatio = {
                        _Ratio = 2,
                    },
                    SlowCriticalRatio = {
                        _Ratio = 10,
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
                        Accumulate = {
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
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 2.0,
                        Break = 1.3,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 3.0,
                        Wince = 10000.0,
                        Break = 10000.0,
                        Accumulate = 1.0,
                    },
                },
            },
            UserData = {
                Gun = {
                    Reticle_LVL_02 = {
                        _AddPoint = 75.0,
                        _KeepPoint = 99.0,
                        _ShootPoint = -1.0,
                        _MovePoint = -1000.0,
                        _WatchPoint = -75.0,
                        PointRange = {
                            s = 75.0,
                            r = 25.0,
                        },
                    },
                    Recoil_LVL_02 = {
                        _RecoilRate = 0.07,
                        _RecoilDampRate = 0.3,
                        RecoilRateRange = {
                            s = 0.0,
                            r = 0.07,
                        },
                    },
                    Deviate_LVL_02 = {
                        DeviateYaw = {
                            s = 0.0,
                            r = 0.0,
                        },
                        DeviatePitch = {
                            s = 0.003,
                            r = 0.002,
                        },
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
                    s = 0.07,
                    r = 0.003,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.035,
                    _SlurFit = 0.0,
                    _HitNum = 2,
                    _HitNumBonusFit = 1,
                    _HitNumBonusCritical = 1,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 40.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    SlowCriticalRatio = {
                        _Ratio = 0,
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
                        Accumulate = {
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
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.5,
                        Break = 1.5,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.3,
                        Wince = 1.3,
                        Break = 1.3,
                        Accumulate = 1.0,
                    },
                },
            },
            UserData = {
                Gun = {
                    Reticle_LVL_02 = {
                        _AddPoint = 65.0,
                        _KeepPoint = 65.0,
                        _ShootPoint = -40.0,
                        _MovePoint = -1000.0,
                        _WatchPoint = -65.0,
                        PointRange = {
                            s = 50.0,
                            r = 50.0,
                        },
                    },
                    Deviate_LVL_02 = {
                        DeviateYaw = {
                            s = 0.0,
                            r = 0.026,
                        },
                        DeviatePitch = {
                            s = 0.052,
                            r = 0.009,
                        },
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = false,
                _AlwaysReloadable = false,
                _Number = 8,
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
        },
        wp3100 = {
            Weapon_Presets = {},
            current_param_indx = 1,
            EnableExecuteFire = true,
            EnableRapidFireNumber = 0,
            Recoil = {
                _RecoilRate = 1.0,
                _RecoilDampRate = 0.1,
                RecoilRateRange = {
                    s = 0.8,
                    r = 0.2,
                },
            },
            Reticle = {
                _AddPoint = 900.0,
                _KeepPoint = 21.0,
                _ShootPoint = -100.0,
                _MovePoint = -1000.0,
                _WatchPoint = -900.0,
                PointRange = {
                    s = 0.0,
                    r = 100.0,
                },
            },
            Deviate = {
                DeviateYaw = {
                    s = -0.01,
                    r = 0.028,
                },
                DeviatePitch = {
                    s = 0.105,
                    r = 0.017,
                },
            },
            ShellGenerator = {
                BallisticSettingNormal = {
                    _Slur = 0.05,
                    _SlurFit = 0.004,
                    _HitNum = 1,
                    _HitNumBonusFit = 1,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 0,
                    _Speed = 300.0,
                    _FiringRange = 40.0,
                    _EffectiveRange = 40.0,
                    _Gravity = 0.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    SlowCriticalRatio = {
                        _Ratio = 0,
                    },
                    Normal = {
                        Damage = {
                            _BaseValue = 1000.0,
                        },
                        Wince = {
                            _BaseValue = 200.0
                        },
                        Break = {
                            _BaseValue = 200.0
                        },
                        Accumulate = {
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
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 2.0,
                        Wince = 1.0,
                        Break = 1.15,
                        Accumulate = 1.0,
                    },
                },
            },
            UserData = {
                Gun = {
                    Reticle_LVL_02 = {
                        _AddPoint = 65.0,
                        _KeepPoint = 65.0,
                        _ShootPoint = -40.0,
                        _MovePoint = -1000.0,
                        _WatchPoint = -65.0,
                        PointRange = {
                            s = 50.0,
                            r = 50.0,
                        },
                    },
                    Deviate_LVL_02 = {
                        DeviateYaw = {
                            s = 0.0,
                            r = 0.026,
                        },
                        DeviatePitch = {
                            s = 0.052,
                            r = 0.009,
                        },
                    },
                },
            },
            Inventory = {
                _OverwriteNumber = true,
                _Infinity = true,
                _AlwaysReloadable = false,
                _Number = 3,
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
                BallisticSettingNormal = {
                    _Slur = 0.0,
                    _SlurFit = 0.0,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 2,
                    _Speed = 20.0,
                    _FiringRange = 80.0,
                    _EffectiveRange = 4.0,
                    _Gravity = 10.0,
                },
                BallisticSettingAcid = {
                    _Slur = 0.0,
                    _SlurFit = 0.0,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 2,
                    _Speed = 20.0,
                    _FiringRange = 80.0,
                    _EffectiveRange = 4.0,
                    _Gravity = 10.0,
                },
                BallisticSettingFire = {
                    _Slur = 0.0,
                    _SlurFit = 0.0,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 2,
                    _Speed = 20.0,
                    _FiringRange = 80.0,
                    _EffectiveRange = 4.0,
                    _Gravity = 10.0,
                },
                BallisticSettingMine = {
                    _Slur = 0.0,
                    _SlurFit = 0.0,
                    _HitNum = 1,
                    _HitNumBonusFit = 0,
                    _HitNumBonusCritical = 0,
                    _PerformanceValue = 8,
                    _Speed = 30.0,
                    _FiringRange = 80.0,
                    _EffectiveRange = 16.0,
                    _Gravity = 4.0,
                },
                AttackSettingNormal = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    SlowCriticalRatio = {
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
                        Accumulate = {
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
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                        Accumulate = 1.0,
                    },
                },
                AttackSettingAcid = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    SlowCriticalRatio = {
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
                        Accumulate = {
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
                            _BaseValue = 0.0
                        },
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                        Accumulate = 1.0,
                    },
                },
                AttackSettingFire = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    SlowCriticalRatio = {
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
                        Accumulate = {
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
                            _BaseValue = 0.0
                        },
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                        Accumulate = 1.0,
                    },
                },
                AttackSettingMine = {
                    CriticalRatio = {
                        _Ratio = 0,
                    },
                    FitCriticalRatio = {
                        _Ratio = 0,
                    },
                    SlowCriticalRatio = {
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
                        Accumulate = {
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
                            _BaseValue = 0.0
                        },
                        Accumulate = {
                            _BaseValue = 0.0
                        },
                    },
                    FitRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                        Accumulate = 1.0,
                    },
                    CriticalRatioContainer = {
                        Damage = 1.0,
                        Wince = 1.0,
                        Break = 1.0,
                        Accumulate = 1.0,
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
    },
    Weapon_Order = {
        "G19",
        "G18",
        "G18B",
        "SE",
        "MUP",
        "M3",
        "CQBR",
        "CQBR2",
        "DE44",
        "RAID",
        "MGL",
        "ATM4",
    },
}

return RE3R_WeaponData