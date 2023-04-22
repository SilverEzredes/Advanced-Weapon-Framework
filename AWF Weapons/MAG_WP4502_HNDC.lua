--/////////////////////////////////////--
-- Advanced Weapon Framework - HNDC Stats

-- Author: SilverEzredes
-- Updated: 04/18/2023
-- Version: v2.0.3
-- Special Thanks to: praydog, alphaZomega, MrBoobieBuyer

--/////////////////////////////////////--


local HNDC = {
        --//////Attaché Case Size Guide//////--
    -- 1x1 = 0	-- 2x1 = 6	-- 3x1 = 14	-- 4x1 = 17
    -- 1x2 = 1	-- 2x2 = 7				-- 4x2 = 18		-- 6x2 = 19
    -- 1x3 = 2	-- 2x3 = 8	
    -- 1x4 = 3	-- 2x4 = 9
    -- 1x5 = 4	-- 2x5 = 10 -- 3x5 = 15
    -- 1x9 = 5	-- 2x6 = 11
	            -- 2x7 = 12 -- 3x7 = 16
	            -- 2x8 = 13	

    ItemSize = 9,					    --(9) The amount of space taken up by the item in the Attaché Case.

    	--//////Ammo Type Guide//////--
    -- Handgun Ammo = 			112800000
    -- Magnum Ammo =			112801600
    -- Shotgun Ammo = 			112803200
    -- Rifle Ammo =				112804800
    -- Submachine Gun Ammo =	112806400	

    AmmoType = 112801600,				--(112801600)
                                
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
    
    ReticleType = 501,                    --(501) --Experimental
                                
        --//////HNDC Base Stats//////--

    HG_Time = 5.0,                      --(5.0)
    HG_Distance = 100.0,                --(100.0) This is probably effective range, not "ThinkRange (Range in previous versions)".
    HG_BulletSpeed = 300,				--(300) Speed of the bullet
    HG_BulletGravity = 0,				--(0) ???
    HG_BulletGravityIgnore = 20,		--(20) Range that ignores bullet drop?
    HG_BulletCol = 0.005,				--(0.005) Maybe the bullet's hitzone size?
    SMG_Random = 0.04,                  --(0.004) Spread. 
    SMG_RandomFit = 0.004,              --(0.004) Spread fully focused.

    HG_CritRate = 4.0,				    --(6.0) Default Critical Rate of the weapon.
    HG_CritRateEX = 6.0,			    --(6.0) Critical Rate when the weapon reticle is fully focused.
    HG_BaseDMG = 1.0,				    --(1.0) Base Damage Rate
    HG_BaseWINC = 1.0,				    --(1.0) Base Wince Rate
    HG_BaseBRK = 1.0,				    --(1.0) Base Break Rate
    HG_BaseSTOP = 1.0,				    --(1.0) Base Stopping Power Rate

    ReloadType = 1,					    --(1) 0 = At once // 1 = Every Single
    ShootType = 0,					    --(0) 0 = Semi Auto // 1 = Full Auto
    ReloadNum = 1,					    --(1) The number of shells loaded in at once for shotguns.
    ReloadSpeedRate = 1.0, 			    --(1.0) Base Reload Speed
    FireRate = 2.1,					    --(2.1) Base Rate of Fire
    FireRateFrame = 20.0,			    --(20.0) Not sure, something with the frames between shots.
    PumpActionFireRate = 1.0, 		    --(1.0) Pump speed for shotguns.

    ThinkRange = 15.0,					--(15.0) Probably not the effective range. 
    
    Focus_HoldAdd = 100.0,			    --(100.0)
    Focus_MoveSub = 600.0,			    --(600.0)
    Focus_CamSub = 500.0,			    --(500.0)
    Focus_Limit = 99.0,				    --(99.0)
    Focus_ShootSub = 100.0,			    --(100.0)

    Recoil_YawMin = 0.0,                --(0.0) Left/Right
    Recoil_YawMax = 1.0,                --(1.0) Left/Right
    Recoil_PitchMin = 7.0,              --(7.0) Up/Down
    Recoil_PitchMax = 2.0,              --(2.0) Up/Down

    HandShake_Time = 10.0,               --Experimental
    HandShake_Offset = 0.5,             --Experimental

    BaseAmmoNum = 5,				    --(5) Base Ammo count
    BaseAmmoCost = 1,				    --(1) Amount of ammo used per shot
    DurDEF_Max = 1000,				    --(1000) Max Item durability
    DurSLD_Max = 2000,				    --(2000) Not really sure something slider max durability?
    ItemStack = 1, 					    --(1) Item stack limit

        --//////HNDC Upgrade Stats//////--
            
    --///DAMAGE///--
    DMG_LVL_01 = -1.0,					--(-1.0) Invalid don't change it. Change WPtype_BaseDMG above instead.
    DMG_LVL_01_INFO = "12.0",			--("12.0")
    DMG_LVL_01_COST = -1,				--(-1)
            
    DMG_LVL_02 = 1.5,					--(1.5)
    DMG_LVL_02_INFO = "18.0",			--("18.0")
    DMG_LVL_02_COST = 40000,		    --(40000)
            
    DMG_LVL_03 = 2.0,					--(2.0)
    DMG_LVL_03_INFO = "24.0",			--("24.0")
    DMG_LVL_03_COST = 50000,			--(50000)
            
    DMG_LVL_04 = 2.5,					--(2.5)
    DMG_LVL_04_INFO = "30.0",			--("30.0")
    DMG_LVL_04_COST = 90000,			--(90000)
            
    DMG_LVL_05 = 3.0,					--(3.0)
    DMG_LVL_05_INFO = "36.0",			--("36.0")
    DMG_LVL_05_COST = 120000,			--(120000)
    --///WINCE///--
    WINC_LVL_01 = 1.0,					--(1.0) Invalid don't change it. Change WPtype_BaseWINCE above instead.
    WINC_LVL_02 = 1.2,					--(1.2)
    WINC_LVL_03 = 1.4,					--(1.4)
    WINC_LVL_04 = 1.6,					--(1.6)
    WINC_LVL_05 = 1.8,					--(1.8)
    --///BREAK///--
    BRK_LVL_01 = 1.0,					--(1.0) Invalid don't change it. Change WPtype_BaseBRK above instead.
    BRK_LVL_02 = 1.2,					--(1.2)
    BRK_LVL_03 = 1.4,					--(1.4)
    BRK_LVL_04 = 1.6,					--(1.6)
    BRK_LVL_05 = 1.8,					--(1.8)
    --///STOPPING POWER///--
    STOP_LVL_01 = 1.0,					--(1.0) Invalid don't change it. Change WPtype_BaseSTOP above instead.
    STOP_LVL_02 = 1.2,					--(1.2)
    STOP_LVL_03 = 1.4,					--(1.4)
    STOP_LVL_04 = 1.6,					--(1.6)
    STOP_LVL_05 = 1.8,					--(1.8)
            
    --///AMMO CAPACITY///--
    AMMO_LVL_01 = -1,					--(-1.0) Invalid don't change it. Change WPtype_BaseAmmoNum above instead.
    AMMO_LVL_01_INFO = "5",			    --("5")
    AMMO_LVL_01_COST = -1,				--(-1)
            
    AMMO_LVL_02 = 6,					--(6)
    AMMO_LVL_02_INFO = "6",			    --("6")
    AMMO_LVL_02_COST = 12000,			--(12000)
            
    AMMO_LVL_03 = 7,					--(7)
    AMMO_LVL_03_INFO = "7",				--("7")
    AMMO_LVL_03_COST = 14000,			--(14000)
            
    AMMO_LVL_04 = 8,					--(8)
    AMMO_LVL_04_INFO = "8",				--("8")
    AMMO_LVL_04_COST = 16000,			--(16000)
            
    AMMO_LVL_05 = 9,					--(9)
    AMMO_LVL_05_INFO = "9",				--("9")
    AMMO_LVL_05_COST = 18000,			--(18000)
            
    --///RELOAD SPEED///--
    RELOAD_LVL_01 = -1,  				--(-1)
    RELOAD_LVL_01_INFO = "1",			--("1")
    RELOAD_LVL_01_COST = 0,				--(0)
            
    RELOAD_LVL_02 = 2,					--(2)
    RELOAD_LVL_02_INFO = "2",			--("2")
    RELOAD_LVL_02_COST = 15000,			--(15000)
            
    RELOAD_LVL_03 = 3,					--(3)
    RELOAD_LVL_03_INFO = "3",			--("3")
    RELOAD_LVL_03_COST = 20000,			--(20000)
            
    RELOAD_LVL_04 = 4,					--(4)
    RELOAD_LVL_04_INFO = "4",			--("4")
    RELOAD_LVL_04_COST = 25000,			--(25000)
            
    RELOAD_LVL_05 = 5,					--(5)
    RELOAD_LVL_05_INFO = "5",			--("5")
    RELOAD_LVL_05_COST = 30000,			--(30000)
            
    --///RATE OF FIRE///--
    ROF_LVL_01 = 2.1,					--(2.1)
    ROF_LVL_01_INFO = "0.52",			--("0.52")
    ROF_LVL_01_COST = 0,				--(0)
            
    ROF_LVL_02 = 2.00,					--(0.55)
    ROF_LVL_02_INFO = "0.55",			--("0.55")
    ROF_LVL_02_COST = 15000,			--(15000)
            
    ROF_LVL_03 = 1.90,					--(0.58)
    ROF_LVL_03_INFO = "0.58",			--("0.58")
    ROF_LVL_03_COST = 20000,			--(20000)
            
    ROF_LVL_04 = 1.80,					--(0.61)
    ROF_LVL_04_INFO = "0.61",			--("0.61")
    ROF_LVL_04_COST = 25000	,			--(25000)
            
    ROF_LVL_05 = 1.70,					--(0.65)
    ROF_LVL_05_INFO = "0.65",			--("0.65")
    ROF_LVL_05_COST = 25000	,			--(25000)
            
        --//////HNDC Limit Break Stats//////--
            
    EX_OK = true,						--(true) Crit Rate multiplier.
    EX_COST = 10000,				    --(10000)

}
return HNDC