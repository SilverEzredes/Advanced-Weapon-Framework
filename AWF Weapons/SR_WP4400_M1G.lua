--/////////////////////////////////////--
-- Advanced Weapon Framework - M1G Stats

-- Authors: SilverEzredes, alphaZomega
-- Updated: 04/17/2023
-- Version: v2.0.3
-- Special Thanks to: praydog

--/////////////////////////////////////--


local M1G = {
        --//////Attaché Case Size Guide//////--
    -- 1x1 = 0	-- 2x1 = 6	-- 3x1 = 14	-- 4x1 = 17
    -- 1x2 = 1	-- 2x2 = 7				-- 4x2 = 18		-- 6x2 = 19
    -- 1x3 = 2	-- 2x3 = 8	
    -- 1x4 = 3	-- 2x4 = 9
    -- 1x5 = 4	-- 2x5 = 10 -- 3x5 = 15
    -- 1x9 = 5	-- 2x6 = 11
	            -- 2x7 = 12 -- 3x7 = 16
	            -- 2x8 = 13	

    ItemSize = 5,					    --(5) The amount of space taken up by the item in the Attaché Case.

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
                                
        --//////M1G Base Stats//////--

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

    ReloadType = 1,					    --(1) 0 = At once // 1 = Every Single
    ShootType = 0,					    --(0) 0 = Semi Auto // 1 = Full Auto
    ReloadNum = 1,					    --(1) The number of shells/bullets loaded in at once for shotguns/rifles.
    ReloadSpeedRate = 1.25, 			--(1.25) Base Reload Speed
    FireRate = 3.00,					--(3.00) Base Rate of Fire
    FireRateFrame = 30.0,			    --(30.0) Not sure, something with the frames between shots.
    PumpActionFireRate = 1.0, 		    --(1.0) Pump speed for shotguns.

    ThinkRange = 100.0,					--(100.0) Probably not the effective range. 
    
    Focus_HoldAdd = 8.0,			    --(8.0)
    Focus_MoveSub = 5000.0,			    --(5000.0)
    Focus_CamSub = 120.0,			    --(120.0)
    Focus_Limit = 90.0,				    --(90.0)
    Focus_ShootSub = 100.0,			    --(100.0)

    Recoil_YawMin = -0.3,               --(-0.3) Left/Right
    Recoil_YawMax = 0.4,                --(0.4) Left/Right
    Recoil_PitchMin = 0.4,              --(0.4) Up/Down
    Recoil_PitchMax = 0.8,              --(0.8) Up/Down

    HandShake_Time = 4.0,               --Experimental
    HandShake_Offset = 0.5,             --Experimental

    BaseAmmoNum = 5,				    --(5) Base Ammo count
    BaseAmmoCost = 1,				    --(1) Amount of ammo used per shot
    DurDEF_Max = 1000,				    --(1000) Max Item durability
    DurSLD_Max = 2000,				    --(2000) Not really sure something slider max durability?
    ItemStack = 1, 					    --(1) Item stack limit

        --//////M1G Upgrade Stats//////--
            
    --///DAMAGE///--
    DMG_LVL_01 = -1.0,					--(-1.0) Invalid don't change it. Change WPtype_BaseDMG above instead.
    DMG_LVL_01_INFO = "2.50",			--("2.50")
    DMG_LVL_01_COST = -1,				--(-1)
            
    DMG_LVL_02 = 1.28,					--(1.28)
    DMG_LVL_02_INFO = "3.20",			--("3.20")
    DMG_LVL_02_COST = 10000,			--(10000)
            
    DMG_LVL_03 = 1.56,					--(1.56)
    DMG_LVL_03_INFO = "3.90",			--("3.90")
    DMG_LVL_03_COST = 20000,			--(20000)
            
    DMG_LVL_04 = 1.84,					--(1.84)
    DMG_LVL_04_INFO = "4.60",			--("4.60")
    DMG_LVL_04_COST = 35000,			--(35000)
            
    DMG_LVL_05 = 2.12,					--(2.12)
    DMG_LVL_05_INFO = "5.30",			--("5.30")
    DMG_LVL_05_COST = 50000,			--(50000)
    --///WINCE///--
    WINC_LVL_01 = -1.0,					--(-1.0) Invalid don't change it. Change WPtype_BaseWINCE above instead.
    WINC_LVL_02 = 1.40,					--(1.40)
    WINC_LVL_03 = 1.80,					--(1.80)
    WINC_LVL_04 = 2.20,					--(2.20)
    WINC_LVL_05 = 2.60,					--(2.60)
    --///BREAK///--
    BRK_LVL_01 = -1.0,					--(-1.0) Invalid don't change it. Change WPtype_BaseBRK above instead.
    BRK_LVL_02 = 1.40,					--(1.40)
    BRK_LVL_03 = 1.80,					--(1.80)
    BRK_LVL_04 = 2.20,					--(2.20)
    BRK_LVL_05 = 2.60,					--(2.60)
    --///STOPPING POWER///--
    STOP_LVL_01 = -1.0,					--(-1.0) Invalid don't change it. Change WPtype_BaseSTOP above instead.
    STOP_LVL_02 = 1.40,					--(1.40)
    STOP_LVL_03 = 1.80,					--(1.80)
    STOP_LVL_04 = 2.20,					--(2.20)
    STOP_LVL_05 = 2.60,					--(2.60)
            
    --///AMMO CAPACITY///--
    AMMO_LVL_01 = -1,					--(-1.0) Invalid don't change it. Change WPtype_BaseAmmoNum above instead.
    AMMO_LVL_01_INFO = "5", 			--("5")
    AMMO_LVL_01_COST = -1,				--(-1)
            
    AMMO_LVL_02 = 7,					--(7)
    AMMO_LVL_02_INFO = "7", 			--("7")
    AMMO_LVL_02_COST = 6000,			--(6000)
            
    AMMO_LVL_03 = 9,					--(9)
    AMMO_LVL_03_INFO = "9", 			--("9")
    AMMO_LVL_03_COST = 8000,			--(8000)
            
    AMMO_LVL_04 = 11,					--(11)
    AMMO_LVL_04_INFO = "11",			--("11")
    AMMO_LVL_04_COST = 10000,			--(10000)
            
    AMMO_LVL_05 = 13,					--(13)
    AMMO_LVL_05_INFO = "13",			--("13")
    AMMO_LVL_05_COST = 12000,			--(12000)
            
    --///RELOAD SPEED///--
    RELOAD_LVL_01 = 1,				    --(1)
    RELOAD_LVL_01_INFO = "1",		    --("1")
    RELOAD_LVL_01_COST = 0,				--(0)
            
    RELOAD_LVL_02 = 2,				    --(2)
    RELOAD_LVL_02_INFO = "2",		    --("2")
    RELOAD_LVL_02_COST = 8000,			--(8000)
            
    RELOAD_LVL_03 = 3,				    --(3)
    RELOAD_LVL_03_INFO = "3",		    --("3")
    RELOAD_LVL_03_COST = 10000,			--(10000)
            
    RELOAD_LVL_04 = 4,				    --(4)
    RELOAD_LVL_04_INFO = "4",		    --("4")
    RELOAD_LVL_04_COST = 12000,			--(12000)
            
    RELOAD_LVL_05 = 5,				    --(05)
    RELOAD_LVL_05_INFO = "5",		    --("5")
    RELOAD_LVL_05_COST = 14000,			--(14000)

    --///RATE OF FIRE///--
    ROF_LVL_01 = 3.0,					--(3.0)
    ROF_LVL_01_INFO = "0.42",			--("0.42")
    ROF_LVL_01_COST = 0,				--(0)
                
    ROF_LVL_02 = 2.5,					--(2.5)
    ROF_LVL_02_INFO = "0.45",			--("0.45")
    ROF_LVL_02_COST = 10000,			--(10000)
                
    ROF_LVL_03 = 2.0,					--(2.0)
    ROF_LVL_03_INFO = "0.48",			--("0.48")
    ROF_LVL_03_COST = 12000,			--(12000)
                
    ROF_LVL_04 = 1.5,					--(1.5)
    ROF_LVL_04_INFO = "0.51",			--("0.51")
    ROF_LVL_04_COST = 14000	,			--(14000)
                
    ROF_LVL_05 = 1.0,					--(1.0)
    ROF_LVL_05_INFO = "0.53",			--("0.53")
    ROF_LVL_05_COST = 16000	,			--(16000)
    
    --///PUMP ACTION SPEED///--
    PUMP_LVL_01 = 1.0,                  --(1.0) Linked to _PumpActionFireRate. Higher is better.
    PUMP_LVL_02 = 1.1,                  --(1.1)
    PUMP_LVL_03 = 1.2,                  --(1.2)
    PUMP_LVL_04 = 1.3,                  --(1.3)
    PUMP_LVL_05 = 1.4,                  --(2.4)
            
        --//////M1G Limit Break Stats//////--
            
    EX_DMG = 2.0,                       --(2.0) Damage Rate multiplier.
    EX_WINCE = 2.0,                      --(2.0) Wince Rate multiplier.
    EX_BRK = 2.0,                       --(2.0) Break Rate multiplier.
    EX_STOP = 2.0,                      --(2.0) Stopping Power Rate multiplier.
    EX_COST = 100000,				    --(100000)

}
return M1G