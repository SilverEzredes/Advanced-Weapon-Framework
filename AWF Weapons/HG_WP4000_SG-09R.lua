--/////////////////////////////////////--
-- Advanced Weapon Framework - SG09R Stats

-- Author: SilverEzredes
-- Updated: 04/17/2023
-- Version: v2.0.3
-- Special Thanks to: praydog, alphaZomega

--/////////////////////////////////////--


local SG09R = {
        --//////Attaché Case Size Guide//////--
    -- 1x1 = 0	-- 2x1 = 6	-- 3x1 = 14	-- 4x1 = 17
    -- 1x2 = 1	-- 2x2 = 7				-- 4x2 = 18		-- 6x2 = 19
    -- 1x3 = 2	-- 2x3 = 8	
    -- 1x4 = 3	-- 2x4 = 9
    -- 1x5 = 4	-- 2x5 = 10 -- 3x5 = 15
    -- 1x9 = 5	-- 2x6 = 11
	            -- 2x7 = 12 -- 3x7 = 16
	            -- 2x8 = 13	

    ItemSize = 8,					    --(8) The amount of space taken up by the item in the Attaché Case.

    	--//////Ammo Type Guide//////--
    -- Handgun Ammo = 			112800000
    -- Magnum Ammo =			112801600
    -- Shotgun Ammo = 			112803200
    -- Rifle Ammo =				112804800
    -- Submachine Gun Ammo =	112806400	

    AmmoType = 112800000,				--(112800000)

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
    
    ReticleType = 4,                    --(4) --Experimental
                                
        --//////SG09R Base Stats//////--

    HG_Time = 5.0,                      --(5.0)
    HG_Distance = 100.0,                --(100.0) This is probably effective range, not "ThinkRange (Range in previous versions)".
    HG_BulletSpeed = 300,				--(300) Speed of the bullet
    HG_BulletGravity = 0,				--(0) ???
    HG_BulletGravityIgnore = 20,		--(20) Range that ignores bullet drop?
    HG_BulletCol = 0.005,				--(0.005) Maybe the bullet's hitzone size?
    SMG_Random = 0.007,                 --(0.007) Spread. 
    SMG_RandomFit = 0.004,              --(0.004) Spread fully focused.

    HG_CritRate = 5.0,				    --(5.0) Default Critical Rate of the weapon.
    HG_CritRateEX = 7.0,			    --(7.0) Critical Rate when the weapon reticle is fully focused.
    HG_BaseDMG = 1.0,				    --(1.0) Base Damage Rate
    HG_BaseWINC = 1.0,				    --(1.0) Base Wince Rate
    HG_BaseBRK = 1.0,				    --(1.0) Base Break Rate
    HG_BaseSTOP = 1.0,				    --(1.0) Base Stopping Power Rate

    ReloadType = 0,					    --(0) 0 = At once // 1 = Every Single
    ShootType = 0,					    --(0) 0 = Semi Auto // 1 = Full Auto
    ReloadNum = -1,					    --(-1) The number of shells loaded in at once for shotguns.
    ReloadSpeedRate = 1.0, 			    --(1.0) Base Reload Speed
    FireRate = 2.3,					    --(2.3) Base Rate of Fire
    FireRateFrame = 0.21,			    --(0.21) Not sure, something with the frames between shots.
    PumpActionFireRate = 1.0, 		    --(1.0) Pump speed for shotguns.

    ThinkRange = 15.0,					    --(15.0) Probably not the effective range. 
    
    Focus_HoldAdd = 120.0,			    --(120.0)
    Focus_MoveSub = 1000.0,			    --(1000.0)
    Focus_CamSub = 123.0,			    --(123.0)
    Focus_Limit = 99.0,				    --(99.0)
    Focus_ShootSub = 100.0,			    --(100.0)

    Recoil_YawMin = 0.0,                --(0.0) Left/Right
    Recoil_YawMax = 2.0,                --(2.0) Left/Right
    Recoil_PitchMin = 3.2,              --(3.2) Up/Down
    Recoil_PitchMax = 0.6,              --(0.6) Up/Down

    HandShake_Time = 6.0,               --Experimental
    HandShake_Offset = 0.5,             --Experimental

    BaseAmmoNum = 10,				    --(10) Base Ammo count
    BaseAmmoCost = 1,				    --(1) Amount of ammo used per shot
    DurDEF_Max = 1000,				    --(1000) Max Item durability
    DurSLD_Max = 2000,				    --(2000) Not really sure something slider max durability?
    ItemStack = 1, 					    --(1) Item stack limit.

        --//////SG09R Upgrade Stats//////--
            
    --///DAMAGE///--
    DMG_LVL_01 = -1.0,					--(-1.0) Invalid don't change it. Change WPtype_BaseDMG above instead.
    DMG_LVL_01_INFO = "1.00",			--("1.00")
    DMG_LVL_01_COST = -1,				--(-1)
            
    DMG_LVL_02 = 1.3,					--(1.3)
    DMG_LVL_02_INFO = "1.30",			--("1.30")
    DMG_LVL_02_COST = 9000,				--(9000)
            
    DMG_LVL_03 = 1.6,					--(1.6)
    DMG_LVL_03_INFO = "1.60",			--("1.60")
    DMG_LVL_03_COST = 18000,			--(18000)
            
    DMG_LVL_04 = 1.8,					--(1.8)
    DMG_LVL_04_INFO = "1.80",			--("1.80")
    DMG_LVL_04_COST = 36000,			--(36000)
            
    DMG_LVL_05 = 2.0,					--(2.0)
    DMG_LVL_05_INFO = "2.00",			--("2.00")
    DMG_LVL_05_COST = 51000,			--(51000)
    --///WINCE///--
    WINC_LVL_01 = -1.0,					--(-1.0) Invalid don't change it. Change WPtype_BaseWINCE above instead.
    WINC_LVL_02 = 1.15,					--(1.15)
    WINC_LVL_03 = 1.3,					--(1.3)
    WINC_LVL_04 = 1.45,					--(1.45)
    WINC_LVL_05 = 1.7,					--(1.7)
    --///BREAK///--
    BRK_LVL_01 = -1.0,					--(-1.0) Invalid don't change it. Change WPtype_BaseBRK above instead.
    BRK_LVL_02 = 1.2,					--(1.2)
    BRK_LVL_03 = 1.5,					--(1.5)
    BRK_LVL_04 = 1.8,					--(1.8)
    BRK_LVL_05 = 2.0,					--(2.0)
    --///STOPPING POWER///--
    STOP_LVL_01 = -1.0,					--(-1.0) Invalid don't change it. Change WPtype_BaseSTOP above instead.
    STOP_LVL_02 = 1.2,					--(1.2)
    STOP_LVL_03 = 1.5,					--(1.5)
    STOP_LVL_04 = 1.8,					--(1.8)
    STOP_LVL_05 = 2.0,					--(2.0)
            
    --///AMMO CAPACITY///--
    AMMO_LVL_01 = -1,					--(-1.0) Invalid don't change it. Change WPtype_BaseAmmoNum above instead.
    AMMO_LVL_01_INFO = "10",			--("10")
    AMMO_LVL_01_COST = -1,				--(-1)
            
    AMMO_LVL_02 = 12,					--(12)
    AMMO_LVL_02_INFO = "12",			--("12")
    AMMO_LVL_02_COST = 4000,			--(4000)
            
    AMMO_LVL_03 = 14,					--(14)
    AMMO_LVL_03_INFO = "14",			--("14")
    AMMO_LVL_03_COST = 6000,			--(6000)
            
    AMMO_LVL_04 = 16,					--(16)
    AMMO_LVL_04_INFO = "16",			--("16")
    AMMO_LVL_04_COST = 9000,			--(9000)
            
    AMMO_LVL_05 = 18,					--(18)
    AMMO_LVL_05_INFO = "18",			--("18")
    AMMO_LVL_05_COST = 12000,			--(12000)
            
    --///RELOAD SPEED///--
    RELOAD_LVL_01 = 1.0,				--(1.0)
    RELOAD_LVL_01_INFO = "1.00",		--("1.00")
    RELOAD_LVL_01_COST = 0,				--(0)
            
    RELOAD_LVL_02 = 1.1,				--(1.1)
    RELOAD_LVL_02_INFO = "1.10",		--("1.10")
    RELOAD_LVL_02_COST = 4000,			--(4000)
            
    RELOAD_LVL_03 = 1.2,				--(1.2)
    RELOAD_LVL_03_INFO = "1.20",		--("1.20")
    RELOAD_LVL_03_COST = 6000,			--(6000)
            
    RELOAD_LVL_04 = 1.3,				--(1.3)
    RELOAD_LVL_04_INFO = "1.30",		--("1.30")
    RELOAD_LVL_04_COST = 9000,			--(9000)
            
    RELOAD_LVL_05 = 1.4,				--(1.4)
    RELOAD_LVL_05_INFO = "1.40",		--("1.40")
    RELOAD_LVL_05_COST = 12000,			--(12000)
            
    --///RATE OF FIRE///--
    ROF_LVL_01 = 2.3,					--(2.3)
    ROF_LVL_01_INFO = "1.00",			--("1.00")
    ROF_LVL_01_COST = 0,				--(0)
            
    ROF_LVL_02 = 2.1,					--(2.1)
    ROF_LVL_02_INFO = "1.10",			--("1.10")
    ROF_LVL_02_COST = 7000,				--(7000)
            
    ROF_LVL_03 = 1.9,					--(1.9)
    ROF_LVL_03_INFO = "1.19",			--("1.19")
    ROF_LVL_03_COST = 9000,				--(9000)
            
    ROF_LVL_04 = 1.7,					--(1.7)
    ROF_LVL_04_INFO = "1.33",			--("1.33")
    ROF_LVL_04_COST = 14000	,			--(14000)
            
    ROF_LVL_05 = 1.5,					--(1.5)
    ROF_LVL_05_INFO = "1.52",			--("1.52")
    ROF_LVL_05_COST = 18000	,			--(18000)
            
        --//////SG09R Limit Break Stats//////--
            
    EX_CRIT = 5.0,						--(5.0) Crit Rate multiplier.
    EX_CRIT_FIT = 5.0,                  --(5.0) Crit Rate multiplier for fully focused reticle.
    EX_COST = 80000,				    --(80000)

}
return SG09R