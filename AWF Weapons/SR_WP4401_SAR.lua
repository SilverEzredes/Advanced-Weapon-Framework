--/////////////////////////////////////--
-- Advanced Weapon Framework - SAR Stats

-- Authors: SilverEzredes, alphaZomega
-- Updated: 04/17/2023
-- Version: v2.0.3
-- Special Thanks to: praydog

--/////////////////////////////////////--


local SAR = {
        --//////Attaché Case Size Guide//////--
    -- 1x1 = 0	-- 2x1 = 6	-- 3x1 = 14	-- 4x1 = 17
    -- 1x2 = 1	-- 2x2 = 7				-- 4x2 = 18		-- 6x2 = 19
    -- 1x3 = 2	-- 2x3 = 8	
    -- 1x4 = 3	-- 2x4 = 9
    -- 1x5 = 4	-- 2x5 = 10 -- 3x5 = 15
    -- 1x9 = 5	-- 2x6 = 11
	            -- 2x7 = 12 -- 3x7 = 16
	            -- 2x8 = 13	

    ItemSize = 12,					    --(12) The amount of space taken up by the item in the Attaché Case.

    	--//////Ammo Type Guide//////--
    -- Handgun Ammo = 			112800000
    -- Magnum Ammo =			112801600
    -- Shotgun Ammo = 			112803200
    -- Rifle Ammo =				112804800
    -- Submachine Gun Ammo =	112806400	

    AmmoType = 112804800,				--(112804800)
                                
            --//////Reticle Type Guide//////--
    -- Default =                100000
    -- Handgun Types =          0/1/2/3/4/5/6
    -- Shotgun Types =          100/101/102/103/104/105/106
    -- SMG Types =              200/201/202/203
    -- Rifle Types =            400/401
    -- Magnum Types =           500/501/502
    -- Bow Types =              600/601/602
    -- RPG Types =              900/901/902
    -- Unknown =                700/701/800/801/802/803/804/1000/1001/9000
    
    ReticleType = 400,                    --(400) --Experimental
                                
        --//////SAR Base Stats//////--

    HG_Time = 5.0,                      --(5.0)
    HG_Distance = 500.0,                --(500.0) This is probably effective range, not "ThinkRange (Range in previous versions)".
    HG_BulletSpeed = 600.0,				--(600.0) Speed of the bullet
    HG_BulletGravity = 0,				--(0) ???
    HG_BulletGravityIgnore = 500.0,		--(500.0) Range that ignores bullet drop?
    HG_BulletCol = 0.005,				--(0.005) Maybe the bullet's hitzone size?
    SMG_Random = 0.0,                   --(0.0) Spread. 
    SMG_RandomFit = 0.0,                --(0.0) Spread fully focused.

    HG_CritRate = 4.0,				    --(4.0) Default Critical Rate of the weapon.
    HG_CritRateEX = 4.0,			    --(4.0) Critical Rate when the weapon reticle is fully focused.
    HG_BaseDMG = 1.0,				    --(1.0) Base Damage Rate
    HG_BaseWINC = 1.0,				    --(1.0) Base Wince Rate
    HG_BaseBRK = 1.0,				    --(1.0) Base Break Rate
    HG_BaseSTOP = 1.0,				    --(1.0) Base Stopping Power Rate

    ReloadType = 0,					    --(0) 0 = At once // 1 = Every Single
    ShootType = 0,					    --(0) 0 = Semi Auto // 1 = Full Auto
    ReloadNum = -1,					    --(1) The number of shells/bullets loaded in at once for shotguns/rifles.
    ReloadSpeedRate = 1.00, 			--(1.00) Base Reload Speed
    FireRate = 2.00,					--(2.00) Base Rate of Fire
    FireRateFrame = -1.0,			    --(-1.0) Not sure, something with the frames between shots.
    PumpActionFireRate = 1.0, 		    --(1.0) Pump speed for shotguns.

    ThinkRange = 100.0,					--(100.0) Probably not the effective range. 
    
    Focus_HoldAdd = 10.0,			    --(10.0)
    Focus_MoveSub = 5000.0,			    --(5000.0)
    Focus_CamSub = 0.0,			        --(0.0)
    Focus_Limit = 0.0,				    --(0.0)
    Focus_ShootSub = 100.0,			    --(100.0)

    Recoil_YawMin = -0.3,               --(-0.3) Left/Right
    Recoil_YawMax = 0.4,                --(0.4) Left/Right
    Recoil_PitchMin = 0.4,              --(0.4) Up/Down
    Recoil_PitchMax = 0.8,              --(0.8) Up/Down

    HandShake_Time = 4.0,               --Experimental
    HandShake_Offset = 0.5,             --Experimental

    BaseAmmoNum = 10,				    --(5) Base Ammo count
    BaseAmmoCost = 1,				    --(1) Amount of ammo used per shot
    DurDEF_Max = 1000,				    --(1000) Max Item durability
    DurSLD_Max = 2000,				    --(2000) Not really sure something slider max durability?
    ItemStack = 1, 					    --(1) Item stack limit

        --//////SAR Upgrade Stats//////--
            
    --///DAMAGE///--
    DMG_LVL_01 = -1.0,					--(-1.0) Invalid don't change it. Change WPtype_BaseDMG above instead.
    DMG_LVL_01_INFO = "3.30",			--("3.30")
    DMG_LVL_01_COST = -1,				--(-1)
            
    DMG_LVL_02 = 1.12,					--(1.12)
    DMG_LVL_02_INFO = "3.70",			--("3.70")
    DMG_LVL_02_COST = 20000,			--(20000)
            
    DMG_LVL_03 = 1.24,					--(1.24)
    DMG_LVL_03_INFO = "4.10",			--("4.10")
    DMG_LVL_03_COST = 30000,			--(30000)
            
    DMG_LVL_04 = 1.36,					--(1.36)
    DMG_LVL_04_INFO = "4.50",			--("4.50")
    DMG_LVL_04_COST = 40000,			--(40000)
            
    DMG_LVL_05 = 1.48,					--(1.48)
    DMG_LVL_05_INFO = "4.90",			--("4.90")
    DMG_LVL_05_COST = 50000,			--(50000)
    --///WINCE///--
    WINC_LVL_01 = -1.0,					--(-1.0) Invalid don't change it. Change WPtype_BaseWINCE above instead.
    WINC_LVL_02 = 1.15,					--(1.15)
    WINC_LVL_03 = 1.30,					--(1.30)
    WINC_LVL_04 = 1.45,					--(1.45)
    WINC_LVL_05 = 1.60,					--(1.60)
    --///BREAK///--
    BRK_LVL_01 = -1.0,					--(-1.0) Invalid don't change it. Change WPtype_BaseBRK above instead.
    BRK_LVL_02 = 1.15,					--(1.15)
    BRK_LVL_03 = 1.30,					--(1.30)
    BRK_LVL_04 = 1.45,					--(1.45)
    BRK_LVL_05 = 1.60,					--(1.60)
    --///STOPPING POWER///--
    STOP_LVL_01 = -1.0,					--(-1.0) Invalid don't change it. Change WPtype_BaseSTOP above instead.
    STOP_LVL_02 = 1.15,					--(1.15)
    STOP_LVL_03 = 1.30,					--(1.30)
    STOP_LVL_04 = 1.45,					--(1.45)
    STOP_LVL_05 = 1.60,					--(1.60)
            
    --///AMMO CAPACITY///--
    AMMO_LVL_01 = -1,					--(-1.0) Invalid don't change it. Change WPtype_BaseAmmoNum above instead.
    AMMO_LVL_01_INFO = "10", 			--("10")
    AMMO_LVL_01_COST = -1,				--(-1)
            
    AMMO_LVL_02 = 12,					--(12)
    AMMO_LVL_02_INFO = "12", 			--("12")
    AMMO_LVL_02_COST = 10000,			--(10000)
            
    AMMO_LVL_03 = 14,					--(14)
    AMMO_LVL_03_INFO = "14", 			--("14")
    AMMO_LVL_03_COST = 15000,			--(15000)
            
    AMMO_LVL_04 = 16,					--(16)
    AMMO_LVL_04_INFO = "16",			--("16")
    AMMO_LVL_04_COST = 20000,			--(20000)
            
    AMMO_LVL_05 = 18,					--(18)
    AMMO_LVL_05_INFO = "18",			--("18")
    AMMO_LVL_05_COST = 25000,			--(25000)
            
    --///RELOAD SPEED///--
    RELOAD_LVL_01 = 1.0,				--(1.0)
    RELOAD_LVL_01_INFO = "0.84",		--("0.84")
    RELOAD_LVL_01_COST = 0,				--(0)
            
    RELOAD_LVL_02 = 1.10,				--(1.10)
    RELOAD_LVL_02_INFO = "0.93",		--("0.93")
    RELOAD_LVL_02_COST = 10000,			--(10000)
            
    RELOAD_LVL_03 = 1.20,				--(1.20)
    RELOAD_LVL_03_INFO = "1.01",		--("1.01")
    RELOAD_LVL_03_COST = 13000,			--(13000)
            
    RELOAD_LVL_04 = 1.30,				--(1.30)
    RELOAD_LVL_04_INFO = "1.09",		--("1.09")
    RELOAD_LVL_04_COST = 16000,			--(16000)
            
    RELOAD_LVL_05 = 1.40,				--(1.40)
    RELOAD_LVL_05_INFO = "1.18",		--("1.18")
    RELOAD_LVL_05_COST = 19000,			--(19000)

    --///RATE OF FIRE///--
    ROF_LVL_01 = 2.0,					--(2.0)
    ROF_LVL_01_INFO = "0.73",			--("0.73")
    ROF_LVL_01_COST = 0,				--(0)
                
    ROF_LVL_02 = 1.9,					--(1.9)
    ROF_LVL_02_INFO = "0.77",			--("0.77")
    ROF_LVL_02_COST = 15000,			--(15000)
                
    ROF_LVL_03 = 1.8,					--(1.8)
    ROF_LVL_03_INFO = "0.81",			--("0.81")
    ROF_LVL_03_COST = 18000,			--(18000)
                
    ROF_LVL_04 = 1.7,					--(1.7)
    ROF_LVL_04_INFO = "0.86",			--("0.86")
    ROF_LVL_04_COST = 25000	,			--(25000)
                
    ROF_LVL_05 = 1.6,					--(1.6)
    ROF_LVL_05_INFO = "0.92",			--("0.92")
    ROF_LVL_05_COST = 30000,			--(30000)
            
        --//////SAR Limit Break Stats//////--
            
    EX_ROF = 2.0,                       --(2.0)
    EX_COST = 60000,				    --(60000)

}
return SAR