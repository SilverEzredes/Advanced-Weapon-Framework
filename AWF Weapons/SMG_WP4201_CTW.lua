--/////////////////////////////////////--
-- Advanced Weapon Framework - CTW Stats

-- Authors: SilverEzredes, alphaZomega
-- Updated: 04/17/2023
-- Version: v2.0.3
-- Special Thanks to: praydog

--Note: I don't have the Chicago Typewriter unlocked. That's why some of the stats are commented out.

--/////////////////////////////////////--


local CTW = {
        --//////Attaché Case Size Guide//////--
    -- 1x1 = 0	-- 2x1 = 6	-- 3x1 = 14	-- 4x1 = 17
    -- 1x2 = 1	-- 2x2 = 7				-- 4x2 = 18		-- 6x2 = 19
    -- 1x3 = 2	-- 2x3 = 8	
    -- 1x4 = 3	-- 2x4 = 9
    -- 1x5 = 4	-- 2x5 = 10 -- 3x5 = 15
    -- 1x9 = 5	-- 2x6 = 11
	            -- 2x7 = 12 -- 3x7 = 16
	            -- 2x8 = 13	

    ItemSize = 16,					    --(16) The amount of space taken up by the item in the Attaché Case.

    	--//////Ammo Type Guide//////--
    -- Handgun Ammo = 			112800000
    -- Magnum Ammo =			112801600
    -- Shotgun Ammo = 			112803200
    -- Rifle Ammo =				112804800
    -- Submachine Gun Ammo =	112806400	

    AmmoType = 112806400,				--(112806400)
                                
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
    
    ReticleType = 201,                    --(201) --Experimental
                                
        --//////CTW Base Stats//////--

    HG_Time = 5.0,                      --(5.0)
    HG_Distance = 100.0,                --(100.0) This is probably effective range, not "ThinkRange (Range in previous versions)".
    HG_BulletSpeed = 300,				--(300) Speed of the bullet
    HG_BulletGravity = 0,				--(0) ???
    HG_BulletGravityIgnore = 20,		--(20) Range that ignores bullet drop?
    HG_BulletCol = 0.005,				--(0.005) Maybe the bullet's hitzone size?
    SMG_Random = 0.04,                  --(0.04) Spread. 
    SMG_RandomFit = 0.01,               --(0.01) Spread fully focused.

    HG_CritRate = 4.0,				    --(4.0) Default Critical Rate of the weapon.
    HG_CritRateEX = 6.0,			    --(6.0) Critical Rate when the weapon reticle is fully focused.
    HG_BaseDMG = 1.0,				    --(1.0) Base Damage Rate
    HG_BaseWINC = 1.0,				    --(1.0) Base Wince Rate
    HG_BaseBRK = 1.0,				    --(1.0) Base Break Rate
    HG_BaseSTOP = 1.0,				    --(1.0) Base Stopping Power Rate

    ReloadType = 0,					    --(0) 0 = At once // 1 = Every Single
    ShootType = 1,					    --(1) 0 = Semi Auto // 1 = Full Auto
    ReloadNum = -1,					    --(-1) The number of shells loaded in at once for shotguns.
    ReloadSpeedRate = 0.78, 			--(0.78) Base Reload Speed
    FireRate = 1.00,					--(1.00) Base Rate of Fire
    FireRateFrame = -1.0,			    --(-1.0) Not sure, something with the frames between shots.
    PumpActionFireRate = 1.0, 		    --(1.0) Pump speed for shotguns.

    ThinkRange = 12.0,					--(12.0) Probably not the effective range. 
    
    Focus_HoldAdd = 100.0,			    --(100.0)
    Focus_MoveSub = 360.0,			    --(360.0)
    Focus_CamSub = 360.0,			    --(360.0)
    Focus_Limit = 99.0,				    --(99.0)
    Focus_ShootSub = 20.0,			    --(20.0)

    Recoil_YawMin = -0.4,               --(-0.4) Left/Right
    Recoil_YawMax = 0.8,                --(0.8) Left/Right
    Recoil_PitchMin = -0.6,             --(-0.6) Up/Down
    Recoil_PitchMax = 1.8,              --(1.8) Up/Down

    HandShake_Time = 8.0,               --Experimental
    HandShake_Offset = 0.5,             --Experimental

    BaseAmmoNum = 50,				    --(50) Base Ammo count
    BaseAmmoCost = 1,				    --(1) Amount of ammo used per shot
    DurDEF_Max = 1000,				    --(1000) Max Item durability
    DurSLD_Max = 2000,				    --(2000) Not really sure something slider max durability?
    ItemStack = 1, 					    --(1) Item stack limit

        --//////CTW Upgrade Stats//////--
            
    --///DAMAGE///--
    DMG_LVL_01 = 1.0,					--(1.0) Invalid don't change it. Change WPtype_BaseDMG above instead.
    DMG_LVL_01_INFO = "0.40",			--("0.40")
    DMG_LVL_01_COST = -1,				--(-1)
            
    DMG_LVL_02 = 2.0,					--(2.0)
    DMG_LVL_02_INFO = "0.80",			--("0.80")
    DMG_LVL_02_COST = 50000,			--(50000)
            
    DMG_LVL_03 = 3.0,					--(3.0)
    DMG_LVL_03_INFO = "1.20",			--("1.20")
    DMG_LVL_03_COST = 100000,			--(100000)
            
    DMG_LVL_04 = 4.0,					--(4.0)
    DMG_LVL_04_INFO = "1.60",			--("1.60")
    DMG_LVL_04_COST = 150000,			--(150000)
            
    DMG_LVL_05 = 5.0,					--(5.0)
    DMG_LVL_05_INFO = "2.00",			--("2.00")
    DMG_LVL_05_COST = 200000,			--(200000)
    --///WINCE///--
    WINC_LVL_01 = 1.00,					--(1.0) Invalid don't change it. Change WPtype_BaseWINCE above instead.
    WINC_LVL_02 = 1.50,					--(1.50)
    WINC_LVL_03 = 2.00,					--(2.00)
    WINC_LVL_04 = 2.50,					--(2.50)
    WINC_LVL_05 = 3.00,					--(3.00)
    --///BREAK///--
    BRK_LVL_01 = 1.00,					--(1.0) Invalid don't change it. Change WPtype_BaseBRK above instead.
    BRK_LVL_02 = 1.50,					--(1.50)
    BRK_LVL_03 = 2.00,					--(2.00)
    BRK_LVL_04 = 2.50,					--(2.50)
    BRK_LVL_05 = 3.00,					--(3.00)
    --///STOPPING POWER///--
    STOP_LVL_01 = 1.00,					--(1.0) Invalid don't change it. Change WPtype_BaseSTOP above instead.
    STOP_LVL_02 = 1.50,					--(1.50)
    STOP_LVL_03 = 2.00,					--(2.00)
    STOP_LVL_04 = 2.50,					--(2.50)
    STOP_LVL_05 = 3.00,					--(3.00)
            
    --///AMMO CAPACITY///--
    AMMO_LVL_01 = -1,					--(-1.0) Invalid don't change it. Change WPtype_BaseAmmoNum above instead.
    AMMO_LVL_01_INFO = "50",			--("50")
    AMMO_LVL_01_COST = -1,				--(-1)
            
    AMMO_LVL_02 = 55,					--(55)
    AMMO_LVL_02_INFO = "55",			--("55")
    AMMO_LVL_02_COST = 10000,			--(10000)
            
    AMMO_LVL_03 = 60,					--(60)
    AMMO_LVL_03_INFO = "60",			--("60")
    AMMO_LVL_03_COST = 15000,			--(15000)
            
    AMMO_LVL_04 = 65,					--(65)
    AMMO_LVL_04_INFO = "65",			--("65")
    AMMO_LVL_04_COST = 25000,			--(25000)
            
    AMMO_LVL_05 = 70,					--(70)
    AMMO_LVL_05_INFO = "70",			--("70")
    AMMO_LVL_05_COST = 30000,			--(30000)
            
    --///RELOAD SPEED///--
    RELOAD_LVL_01 = 0.78,				--(0.78)
    RELOAD_LVL_01_INFO = "0.78",		--("0.78")
    RELOAD_LVL_01_COST = 0,				--(0)
            
    RELOAD_LVL_02 = 0.82,				--(0.82)
    RELOAD_LVL_02_INFO = "0.82",		--("0.82")
    RELOAD_LVL_02_COST = 10000,			--(10000)
            
    RELOAD_LVL_03 = 0.86,				--(0.86)
    RELOAD_LVL_03_INFO = "0.86",		--("0.86")
    RELOAD_LVL_03_COST = 15000,			--(15000)
            
    RELOAD_LVL_04 = 0.89,				--(0.89)
    RELOAD_LVL_04_INFO = "0.89",		--("0.89")
    RELOAD_LVL_04_COST = 20000,			--(20000)
            
    RELOAD_LVL_05 = 0.93,				--(0.93)
    RELOAD_LVL_05_INFO = "0.93",		--("0.93")
    RELOAD_LVL_05_COST = 25000,			--(25000)
            
        --//////CTW Limit Break Stats//////--
            
    EX_OK = true,                       --(True) I have no idea what does OKReload means. But it is true for sure. 
    EX_COST = 10000,				    --(10000)

}
return CTW