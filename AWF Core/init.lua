--/////////////////////////////////////--
-- Advanced Weapon Framework Core

-- Authors: SilverEzredes; alphaZomega
-- Updated: 04/21/2023
-- Version: v2.1.1
-- Special Thanks to: praydog; MrBoobieBuyer

--/////////////////////////////////////--
local scene_manager = sdk.get_native_singleton("via.SceneManager")
local scene = nil
local PlayerItems = {}
WeaponDetailStages = {}
local WeaponDataTables = {}
local WeaponStages = {}

--////////////AWF Tables////////////--
local WeaponData = {
	SG09R = require("../AWF Weapons/HG_WP4000_SG-09R"),
	PUN = require("../AWF Weapons/HG_WP4001_Punisher"),
	RED9 = require("../AWF Weapons/HG_WP4002_Red9"),
	BT = require("../AWF Weapons/HG_WP4003_Blacktail"),
	VP70 = require("../AWF Weapons/HG_WP4004_Matilda"),
	SEN9 = require("../AWF Weapons/HG_WP6000_SentinelNine"),
	M870 = require("../AWF Weapons/SG_WP4100_M870"),
	BM4 = require("../AWF Weapons/SG_WP4101_RiotShotgun"),
	STKR = require("../AWF Weapons/SG_WP4102_Striker"),
	SKUL = require("../AWF Weapons/SG_WP6001_SkullShaker"),
	TMP = require("../AWF Weapons/SMG_WP4200_TMP"),
	CTW = require("../AWF Weapons/SMG_WP4201_CTW"),
	LE5 = require("../AWF Weapons/SMG_WP4202_LE5"),
	M1G = require("../AWF Weapons/SR_WP4400_M1G"),
	SAR = require("../AWF Weapons/SR_WP4401_SAR"),
	CQBR = require("../AWF Weapons/SR_WP4402_CQBR"),
	BRB = require("../AWF Weapons/MAG_WP4500_BRB"),
	KIL7 = require("../AWF Weapons/MAG_WP4501_KIL7"),
	HNDC = require("../AWF Weapons/MAG_WP4502_HNDC"),
}

WeaponIDs = {
	SG09R_id = "wp4000",
	PUN_id = "wp4001",
	RED9_id = "wp4002",
	BT_id = "wp4003",
	VP70_id = "wp4004",
	SEN9_id = "wp6000",
	M870_id = "wp4100",
	BM4_id = "wp4101",
	STKR_id = "wp4102",
	SKUL_id = "wp6001",
	TMP_id = "wp4200",
	CTW_id = "wp4201",
	LE5_id = "wp4202",
	M1G_id = "wp4400",
	SAR_id = "wp4401",
	CQBR_id = "wp4402",
	BRB_id	= "wp4500",
	KIL7_id = "wp4501",
	HNDC_id = "wp4502",
}

weapons_enum = {
	[4000] = "wp4000",
	[4001] = "wp4001",
	[4002] = "wp4002",
	[4003] = "wp4003",
	[4004] = "wp4004",
	[4100] = "wp4100",
	[4101] = "wp4101",
	[4102] = "wp4102",
	[4200] = "wp4200",
	[4201] = "wp4201",
	[4202] = "wp4202",
	[4400] = "wp4400",
	[4401] = "wp4401",
	[4402] = "wp4402",
	[4500] = "wp4500",
	[4501] = "wp4501",
	[4502] = "wp4502",
	[4600] = "wp4600",
	[5000] = "wp5000",
	[6000] = "wp6000",
	[6001] = "wp6001",
	["wp4000"] = 4000,
	["wp4001"] = 4001,
	["wp4002"] = 4002,
	["wp4003"] = 4003,
	["wp4004"] = 4004,
	["wp4100"] = 4100,
	["wp4101"] = 4101,
	["wp4102"] = 4102,
	["wp4200"] = 4200,
	["wp4201"] = 4201,
	["wp4202"] = 4202,
	["wp4400"] = 4400,
	["wp4401"] = 4401,
	["wp4402"] = 4402,
	["wp4500"] = 4500,
	["wp4501"] = 4501,
	["wp4502"] = 4502,
	["wp4600"] = 4600,
	["wp5000"] = 5000,
	["wp6000"] = 6000,
	["wp6001"] = 6001,
}

CustomCategory_enums = {
	[0] = "AttackUp",
	[2] = "AmmoMaxUp",
	["AttackUp"] = 0,
	["AmmoMaxUp"] = 2,
}

IndividualCategory_enums = {
	[7] = "ReloadSpeed",
	[8] = "Rapid",
	["ReloadSpeed"] = 7,
	["Rapid"] = 8,
}

LimitBreakCategory_enums = {
	[0] = "CriticalRate",
	[1] = "AttackUp",
	[2] = "ShotGunAroundAttackUp",
	[3] = "ThroughNum",
	[4] = "AmmoMaxUp",
	[5] = "Rapid",
	[6] = "Strength",
	[7] = "OKReload",
	[8] = "CombatSpeed",
	[9] = "Unbreakable",
	["CriticalRate"] = 0,
	["AttackUp"] = 1,
	["ShotGunAroundAttackUp"] =2,
	["ThroughNum"] = 3,
	["AmmoMaxUp"] = 4,
	["Rapid"] = 5,
	["Strength"] = 6,
	["OKReload"] = 7,
	["CombatSpeed"] = 8,
	["Unbreakable"] = 9
}

AttachmentCategory_enums = {
	[101] = "RandomRadius_Fit",
	[103] = "ReticleFitParam",
	[400] = "MeshPartsNums",
	[501] = "ReticleGuiType",
	["RandomRadius_Fit"] = 101,
	["ReticleFitParam"] = 103,
	["MeshPartsNums"] = 400,
	["ReticleGuiType"] = 501,
}

GameObjectsTable = {
	"WeaponCustomCatalog",
	"PlayerInventoryObserver",
	"WeaponCatalog",
}

--////////////AWF Functions////////////--

local function create_resource(resource_path, resource_type)
    local new_resource = sdk.create_resource(resource_type, resource_path)
    if new_resource then 
        new_resource:add_ref()
        local holder = sdk.create_instance(resource_type .. "Holder")
        if sdk.is_managed_object(holder) then 
            holder:call(".ctor")
            holder:write_qword(0x10, new_resource:get_address())
            holder:add_ref()
            return holder
        end
    end
end

local function write_valuetype(parent_obj, offset, value)
    for i=0, value.type:get_valuetype_size()-1 do
        parent_obj:write_byte(offset+i, value:read_byte(i))
    end
end

local REMgdObj = {
    o,
    new = function(self, obj, o)
        o = o or {}
        self.__index = self
        o._ = {}
        o._.obj = obj
        if not obj or type(obj) == "number" or not obj.get_type_definition then return end
        o._.type = obj:get_type_definition()
        o._.name = o._.type:get_name()
        o._.Name = o._.type:get_full_name()
        o._.fields = {}
        for i, field in ipairs(o._.type:get_fields()) do 
            local field_name = field:get_name()
            local try, value = pcall(field.get_data, field, obj)
            o._.fields[field_name] = field
            o[field_name] = value
        end
        o._.methods = {}
        for i, method in ipairs(o._.type:get_methods()) do 
            local method_name = method:get_name()
            o._.methods[method_name] = method
            o[method_name] = function(self, args)
                if args then 
                    return self._.obj:call(method_name, table.unpack(args))
                end
                return self._.obj:call(method_name)
            end
        end
        return setmetatable(o, self)
    end,
    update = function(self)
        if sdk.is_managed_object(obj) then--is_valid_obj(self._.obj) then 
            for field_name, field in pairs(self._.fields) do 
                self[field_name] = field:get_data(self._.obj)
            end
        else
            self = nil
        end
    end,
}

metadata = {}

local function generate_statics(typename)
    local t = sdk.find_type_definition(typename)
    if not t then return {} end

    local fields = t:get_fields()
    local enum = {}
    local enum_string = "\ncase \"" .. typename .. "\":" .. "\n    enum {"
    
    for i, field in ipairs(fields) do
        if field:is_static() then
            local name = field:get_name()
            local raw_value = field:get_data(nil)
            enum_string = enum_string .. "\n        " .. name .. " = " .. tostring(raw_value) .. ","
            enum[name] = raw_value
        end
    end
    
    --log.info(enum_string .. "\n    }" .. typename:gsub("%.", "_") .. ";\n    break;\n") --enums for RSZ template

    return enum
end

local function generate_statics_global(typename)
    local parts = {}
    for part in typename:gmatch("[^%.]+") do
        table.insert(parts, part)
    end
    local global = _G
    for i, part in ipairs(parts) do
        if not global[part] then
            global[part] = {}
        end
        global = global[part]
    end
    if global ~= _G then
        local static_class = generate_statics(typename)

        for k, v in pairs(static_class) do
            global[k] = v
            global[v] = k
        end
    end
    return global
end

local wanted_static_classes = {
    "via.hid.GamePadButton",
    "via.hid.MouseButton",
    "via.hid.KeyboardKey",
}

for i, typename in ipairs(wanted_static_classes) do
    generate_statics_global(typename)
end

local function get_kb_device()
    return sdk.call_native_func(sdk.get_native_singleton("via.hid.Keyboard"), sdk.find_type_definition("via.hid.Keyboard"), "get_Device")
end

local function get_mouse_device()
    return sdk.call_native_func(sdk.get_native_singleton("via.hid.Mouse"), sdk.find_type_definition("via.hid.Mouse"), "get_Device")
end

local kb_state = {
    down = {
		[via.hid.KeyboardKey.Q] = false,
		[via.hid.KeyboardKey.E] = false,
		[via.hid.KeyboardKey.Z] = false,
		[via.hid.KeyboardKey.X] = false,

    },
    released = {
		[via.hid.KeyboardKey.Q] = false,
		[via.hid.KeyboardKey.E] = false,
		[via.hid.KeyboardKey.Z] = false,
		[via.hid.KeyboardKey.X] = false, 
    },
}

local mouse_state = {
    down = {
        [via.hid.MouseButton.L] = false,
        [via.hid.MouseButton.R] = false,
    },
    released = {
        [via.hid.MouseButton.L] = false,
        [via.hid.MouseButton.R] = false,
    },
}

local function update_keyboard_state()
    local kb = get_kb_device()
    if not kb then return end
    for button, state in pairs(kb_state.down) do
        kb_state.down[button] = kb:call("isDown", button)
    end
    for button, state in pairs(kb_state.released) do
        kb_state.released[button] = kb:call("isRelease", button)
    end
end

local function update_mouse_state()
    local mouse = get_mouse_device()
    if not mouse then return end

    for button, state in pairs(mouse_state.down) do
        mouse_state.down[button] = mouse:call("isDown", button)
    end
    for button, state in pairs(mouse_state.released) do
        mouse_state.released[button] = mouse:call("isRelease", button)
    end
end

function get_gp_device()
    return sdk.call_native_func(sdk.get_native_singleton("via.hid.GamePad"), sdk.find_type_definition("via.hid.GamePad"), "get_Device")
end

local gamepad_state = {
    down = {},
    released = {}
}

for k, v in pairs(via.hid.GamePadButton) do
    if type(v) == "number" then
        gamepad_state.down[v] = false
        gamepad_state.released[v] = false
    end
end

local function update_gamepad_state()
    local gp = get_gp_device()
	if not gp then return end
	
    for button, prev_state in pairs(gamepad_state.down) do
        if gp ~= nil then
            gamepad_state.down[button] = (gp:call("get_Button") & button) ~= 0
            -- manually calculate the released state because VR does not set the buttonUp flag
            gamepad_state.released[button] = not gamepad_state.down[button] and prev_state
        else
            gamepad_state.down[button] = false
            gamepad_state.released[button] = false
        end
    end
end

local function getGameObject(scene, GameObjectName)
    return scene:call("findGameObject(System.String)", GameObjectName)
end

local function get_localplayer_context()
    local character_manager = sdk.get_managed_singleton(sdk.game_namespace("CharacterManager"))
    local player_context = character_manager and character_manager:call("getPlayerContextRef")
    return player_context
end


local AWFWeaponRE4 = {
	new = function(self, args, o)
		o = o or {}
		self.__index = self
		
		o.name = args.name or o.name
		o.WP_ID = args.WP_ID or o.WP_ID
		o.WPtype = args.WPtype or o.WPtype
		o.data = WeaponData[o.name]
		o.setPlayerItems = false
		o.setPlayerCatalog = false
		o.setGun = false
		
		return setmetatable(o, self)
	end,
	
	update = function(self)
		local d = self.data
		
		--Setup Catalog part:
		if not self.setPlayerCatalog or d.Changed then
			log.info("AWF Catalog")
			for i, ItemID in ipairs(WeaponStages) do
				local WeaponID = ItemID:call("get_WeaponID")
				local WeaponIDName = weapons_enum[WeaponID]
				
				if WeaponIDName and WeaponIDName:find(self.WP_ID) then
					local Custom = ItemID:get_field("_WeaponCustom")
					
					if Custom then
						local Custom_Commons = Custom:get_field("_Commons")
						local Custom_Commons = Custom_Commons and Custom_Commons:get_elements() or {}
						
						local Custom_Individuals = Custom:get_field("_Individuals")
						local Custom_Individuals = Custom_Individuals and Custom_Individuals:get_elements() or {}
						
						local Custom_LimitBreak = Custom:get_field("_LimitBreak")
						local Custom_LimitBreak = Custom_LimitBreak and Custom_LimitBreak:get_elements() or {}
						
						if Custom_Commons then
							for i, CommonCategories in ipairs(Custom_Commons) do
								local Custom_CategoryID = CommonCategories:call("get_CommonCustomCategory")
								local Custom_Category_Name = CustomCategory_enums[Custom_CategoryID]
								
								if Custom_Category_Name and Custom_Category_Name:find("AttackUp") then
									local Custom_CustomAttackUp = CommonCategories:get_field("_CustomAttackUp")
									
									if Custom_CustomAttackUp then 
										local Custom_CustomAttackUp_Stages = Custom_CustomAttackUp:get_field("_AttackUpCustomStages")
										local Custom_CustomAttackUp_Stages = Custom_CustomAttackUp_Stages and Custom_CustomAttackUp_Stages:get_elements() or {}
										
										if Custom_CustomAttackUp_Stages then
											Custom_CustomAttackUp_Stages[1]._Info = d.DMG_LVL_01_INFO
											Custom_CustomAttackUp_Stages[2]._Info = d.DMG_LVL_02_INFO
											Custom_CustomAttackUp_Stages[3]._Info = d.DMG_LVL_03_INFO
											Custom_CustomAttackUp_Stages[4]._Info = d.DMG_LVL_04_INFO
											Custom_CustomAttackUp_Stages[5]._Info = d.DMG_LVL_05_INFO
											
											Custom_CustomAttackUp_Stages[1]._Cost = d.DMG_LVL_01_COST
											Custom_CustomAttackUp_Stages[2]._Cost = d.DMG_LVL_02_COST
											Custom_CustomAttackUp_Stages[3]._Cost = d.DMG_LVL_03_COST
											Custom_CustomAttackUp_Stages[4]._Cost = d.DMG_LVL_04_COST
											Custom_CustomAttackUp_Stages[5]._Cost = d.DMG_LVL_05_COST
										end
									end
								end
								
								if Custom_Category_Name and Custom_Category_Name:find("AmmoMaxUp") then
									local Custom_CustomAmmoMaxUp = CommonCategories:get_field("_CustomAmmoMaxUp")
									
									if Custom_CustomAmmoMaxUp then 
										local Custom_CustomAmmoMaxUp_Stages = Custom_CustomAmmoMaxUp:get_field("_AmmoMaxUpCustomStages")
										local Custom_CustomAmmoMaxUp_Stages = Custom_CustomAmmoMaxUp_Stages and Custom_CustomAmmoMaxUp_Stages:get_elements() or {}
										
										if Custom_CustomAmmoMaxUp_Stages then
											Custom_CustomAmmoMaxUp_Stages[1]._Info = d.AMMO_LVL_01_INFO
											Custom_CustomAmmoMaxUp_Stages[2]._Info = d.AMMO_LVL_02_INFO
											Custom_CustomAmmoMaxUp_Stages[3]._Info = d.AMMO_LVL_03_INFO
											Custom_CustomAmmoMaxUp_Stages[4]._Info = d.AMMO_LVL_04_INFO
											Custom_CustomAmmoMaxUp_Stages[5]._Info = d.AMMO_LVL_05_INFO
											
											Custom_CustomAmmoMaxUp_Stages[1]._Cost = d.AMMO_LVL_01_COST
											Custom_CustomAmmoMaxUp_Stages[2]._Cost = d.AMMO_LVL_02_COST
											Custom_CustomAmmoMaxUp_Stages[3]._Cost = d.AMMO_LVL_03_COST
											Custom_CustomAmmoMaxUp_Stages[4]._Cost = d.AMMO_LVL_04_COST
											Custom_CustomAmmoMaxUp_Stages[5]._Cost = d.AMMO_LVL_05_COST
										end
									end
								end
							end
						end
						
						if Custom_Individuals then
							for i, IndividualCategories in ipairs(Custom_Individuals) do
								local Custom_CategoryID = IndividualCategories:call("get_IndividualCustomCategory")
								local Custom_Category_Name = IndividualCategory_enums[Custom_CategoryID]
								
								if Custom_Category_Name and Custom_Category_Name:find("ReloadSpeed") then
									local Custom_CustomReloadSpeed = IndividualCategories:get_field("_CustomReloadSpeed") 
									
									if Custom_CustomReloadSpeed then 
										local Custom_CustomReloadSpeed_Stages = Custom_CustomReloadSpeed:get_field("_ReloadSpeedCustomStages")
										local Custom_CustomReloadSpeed_Stages = Custom_CustomReloadSpeed_Stages and Custom_CustomReloadSpeed_Stages:get_elements() or {}
										
										if Custom_CustomReloadSpeed_Stages then
											Custom_CustomReloadSpeed_Stages[1]._Info = d.RELOAD_LVL_01_INFO
											Custom_CustomReloadSpeed_Stages[2]._Info = d.RELOAD_LVL_02_INFO
											Custom_CustomReloadSpeed_Stages[3]._Info = d.RELOAD_LVL_03_INFO
											Custom_CustomReloadSpeed_Stages[4]._Info = d.RELOAD_LVL_04_INFO
											Custom_CustomReloadSpeed_Stages[5]._Info = d.RELOAD_LVL_05_INFO
											
											Custom_CustomReloadSpeed_Stages[1]._Cost = d.RELOAD_LVL_01_COST
											Custom_CustomReloadSpeed_Stages[2]._Cost = d.RELOAD_LVL_02_COST
											Custom_CustomReloadSpeed_Stages[3]._Cost = d.RELOAD_LVL_03_COST
											Custom_CustomReloadSpeed_Stages[4]._Cost = d.RELOAD_LVL_04_COST
											Custom_CustomReloadSpeed_Stages[5]._Cost = d.RELOAD_LVL_05_COST
										end
									end
								end
								
								if Custom_Category_Name and Custom_Category_Name:find("Rapid") then
									local Custom_CustomRapid = IndividualCategories:get_field("_CustomRapid") 
									
									if Custom_CustomRapid then 
										local Custom_CustomRapid_Stages = Custom_CustomRapid:get_field("_RapidCustomStages")
										local Custom_CustomRapid_Stages = Custom_CustomRapid_Stages and Custom_CustomRapid_Stages:get_elements() or {}
										
										if Custom_CustomRapid_Stages then
											Custom_CustomRapid_Stages[1]._Info = d.ROF_LVL_01_INFO
											Custom_CustomRapid_Stages[2]._Info = d.ROF_LVL_02_INFO
											Custom_CustomRapid_Stages[3]._Info = d.ROF_LVL_03_INFO
											Custom_CustomRapid_Stages[4]._Info = d.ROF_LVL_04_INFO
											Custom_CustomRapid_Stages[5]._Info = d.ROF_LVL_05_INFO
											
											Custom_CustomRapid_Stages[1]._Cost = d.ROF_LVL_01_COST
											Custom_CustomRapid_Stages[2]._Cost = d.ROF_LVL_02_COST
											Custom_CustomRapid_Stages[3]._Cost = d.ROF_LVL_03_COST
											Custom_CustomRapid_Stages[4]._Cost = d.ROF_LVL_04_COST
											Custom_CustomRapid_Stages[5]._Cost = d.ROF_LVL_05_COST
										end
									end
								end
							end
						end
						
						if Custom_LimitBreak then
							for i, LimitBreakCategories in ipairs(Custom_LimitBreak) do
								local Custom_CategoryID = LimitBreakCategories:call("get_LimitBreakCustomCategory")
								local Custom_Category_Name = LimitBreakCategory_enums[Custom_CategoryID]
								
								if Custom_Category_Name then
									local Custom_CustomLimitBreak = LimitBreakCategories:get_field("_CustomLimitBreak")
									
									if Custom_CustomLimitBreak then
										local Custom_CustomLimitBreak_Stages = Custom_CustomLimitBreak:get_field("_LimitBreakCustomStages")
										local Custom_CustomLimitBreak_Stages = Custom_CustomLimitBreak_Stages and Custom_CustomLimitBreak_Stages:get_elements() or {}
										
										if Custom_CustomLimitBreak_Stages then
											Custom_CustomLimitBreak_Stages[1]._Cost = d.EX_COST
										end
									end
								end
							end
						end
					end
					break
				end
			end
			
			for i, ItemID in ipairs(WeaponDetailStages) do
				local WeaponID = ItemID:call("get_WeaponID")
				local WeaponIDName = weapons_enum[WeaponID]
				
				if WeaponIDName and WeaponIDName:find(self.WP_ID) then
					local Custom = ItemID:get_field("_WeaponDetailCustom")
					
					if Custom then
						local Custom_CommonCustoms = Custom:get_field("_CommonCustoms")
						Custom_CommonCustoms = Custom_CommonCustoms and Custom_CommonCustoms:get_elements() or {}
						
						local Custom_IndividualCustoms = Custom:get_field("_IndividualCustoms")
						Custom_IndividualCustoms = Custom_IndividualCustoms and Custom_IndividualCustoms:get_elements() or {}
						
						local Custom_LimitBreakCustoms = Custom:get_field("_LimitBreakCustoms")
						Custom_LimitBreakCustoms = Custom_LimitBreakCustoms and Custom_LimitBreakCustoms:get_elements() or {}

						local Custom_AttachmentCustoms = Custom:get_field("_AttachmentCustoms")
						Custom_AttachmentCustoms = Custom_AttachmentCustoms and Custom_AttachmentCustoms:get_elements() or {}
						
						if Custom_CommonCustoms then
							for i, CommonCategories in ipairs(Custom_CommonCustoms) do
								local Custom_CategoryID = CommonCategories:call("get_CommonCustomCategory")
								local Custom_Category_Name = CustomCategory_enums[Custom_CategoryID]
							
								if Custom_Category_Name and Custom_Category_Name:find("AttackUp") then
									local Custom_AttackUp = CommonCategories:get_field("_AttackUp")
									
									if Custom_AttackUp then											
										local Custom_DamageRate = Custom_AttackUp:get_field("_DamageRates")
										Custom_DamageRate = Custom_DamageRate and Custom_DamageRate:get_elements() or {}
										
										local Custom_WinceRate = Custom_AttackUp:get_field("_WinceRates")
										Custom_WinceRate = Custom_WinceRate and Custom_WinceRate:get_elements() or {}
										
										local Custom_BreakRate = Custom_AttackUp:get_field("_BreakRates")
										Custom_BreakRate = Custom_BreakRate and Custom_BreakRate:get_elements() or {}
										
										local Custom_StoppingRate = Custom_AttackUp:get_field("_StoppingRates")
										Custom_StoppingRate = Custom_StoppingRate and Custom_StoppingRate:get_elements() or {}
										
										if Custom_DamageRate and Custom_DamageRate[5] then
											Custom_DamageRate[1]:set_field("_BaseValue", d.DMG_LVL_01)
											Custom_DamageRate[2]:set_field("_BaseValue", d.DMG_LVL_02)
											Custom_DamageRate[3]:set_field("_BaseValue", d.DMG_LVL_03)
											Custom_DamageRate[4]:set_field("_BaseValue", d.DMG_LVL_04)
											Custom_DamageRate[5]:set_field("_BaseValue", d.DMG_LVL_05)
										end
										
										if Custom_WinceRate and Custom_WinceRate[5] then
											Custom_WinceRate[1]:set_field("_BaseValue", d.WINC_LVL_01)
											Custom_WinceRate[2]:set_field("_BaseValue", d.WINC_LVL_02)
											Custom_WinceRate[3]:set_field("_BaseValue", d.WINC_LVL_03)
											Custom_WinceRate[4]:set_field("_BaseValue", d.WINC_LVL_04)
											Custom_WinceRate[5]:set_field("_BaseValue", d.WINC_LVL_05)
										end
										
										if Custom_BreakRate and Custom_BreakRate[5] then
											Custom_BreakRate[1]:set_field("_BaseValue", d.BRK_LVL_01)
											Custom_BreakRate[2]:set_field("_BaseValue", d.BRK_LVL_02)
											Custom_BreakRate[3]:set_field("_BaseValue", d.BRK_LVL_03)
											Custom_BreakRate[4]:set_field("_BaseValue", d.BRK_LVL_04)
											Custom_BreakRate[5]:set_field("_BaseValue", d.BRK_LVL_05)
										end
										
										if Custom_StoppingRate and Custom_StoppingRate[5] then
											Custom_StoppingRate[1]:set_field("_BaseValue", d.STOP_LVL_01)
											Custom_StoppingRate[2]:set_field("_BaseValue", d.STOP_LVL_02)
											Custom_StoppingRate[3]:set_field("_BaseValue", d.STOP_LVL_03)
											Custom_StoppingRate[4]:set_field("_BaseValue", d.STOP_LVL_04)
											Custom_StoppingRate[5]:set_field("_BaseValue", d.STOP_LVL_05)
										end
									end
								end
								
								if Custom_Category_Name and Custom_Category_Name:find("AmmoMaxUp") then
									local Custom_AmmoMaxUp = CommonCategories:get_field("_AmmoMaxUp")
									
									if Custom_AmmoMaxUp then
										Custom_AmmoMaxUp._AmmoMaxs[0] = d.AMMO_LVL_01
										Custom_AmmoMaxUp._AmmoMaxs[1] = d.AMMO_LVL_02
										Custom_AmmoMaxUp._AmmoMaxs[2] = d.AMMO_LVL_03
										Custom_AmmoMaxUp._AmmoMaxs[3] = d.AMMO_LVL_04
										Custom_AmmoMaxUp._AmmoMaxs[4] = d.AMMO_LVL_05
									end
								end
							end
						end
						
						if Custom_IndividualCustoms then
							for i, IndividualCategories in ipairs(Custom_IndividualCustoms) do
								local Custom_CategoryID = IndividualCategories:call("get_IndividualCustomCategory")
								local Custom_Category_Name = IndividualCategory_enums[Custom_CategoryID]
								
								if Custom_Category_Name and Custom_Category_Name:find("ReloadSpeed") then
									local Custom_ReloadSpeed = IndividualCategories:get_field("_ReloadSpeed")

									if Custom_ReloadSpeed then
										if (self.WPtype == "HG") or (self.WPtype == "SMG") or (self.WPtype == "SR") or (self.WPtype == "MAG_SEMI") then
											Custom_ReloadSpeed._ReloadSpeedRates[0] = d.RELOAD_LVL_01
											Custom_ReloadSpeed._ReloadSpeedRates[1] = d.RELOAD_LVL_02
											Custom_ReloadSpeed._ReloadSpeedRates[2] = d.RELOAD_LVL_03
											Custom_ReloadSpeed._ReloadSpeedRates[3] = d.RELOAD_LVL_04
											Custom_ReloadSpeed._ReloadSpeedRates[4] = d.RELOAD_LVL_05
										end

										if (self.WPtype == "SG") or (self.WPtype == "SG_PUMP") or (self.WPtype == "SR_PUMP") or (self.WPtype == "MAG") then
											Custom_ReloadSpeed._ReloadNums[0] = d.RELOAD_LVL_01
											Custom_ReloadSpeed._ReloadNums[1] = d.RELOAD_LVL_02
											Custom_ReloadSpeed._ReloadNums[2] = d.RELOAD_LVL_03
											Custom_ReloadSpeed._ReloadNums[3] = d.RELOAD_LVL_04
											Custom_ReloadSpeed._ReloadNums[4] = d.RELOAD_LVL_05
										end
									end
								end
								
								if Custom_Category_Name and Custom_Category_Name:find("Rapid") then
									local Custom_RateOfFire = IndividualCategories:get_field("_Rapid")
									
									if Custom_RateOfFire then
										Custom_RateOfFire._RapidSpeed[0] = d.ROF_LVL_01
										Custom_RateOfFire._RapidSpeed[1] = d.ROF_LVL_02
										Custom_RateOfFire._RapidSpeed[2] = d.ROF_LVL_03
										Custom_RateOfFire._RapidSpeed[3] = d.ROF_LVL_04
										Custom_RateOfFire._RapidSpeed[4] = d.ROF_LVL_05
										
										if (self.WPtype == "SG_PUMP") or (self.WPtype == "SR_PUMP") then
											Custom_RateOfFire._PumpActionRapidSpeed[0] = d.PUMP_LVL_01
											Custom_RateOfFire._PumpActionRapidSpeed[1] = d.PUMP_LVL_02
											Custom_RateOfFire._PumpActionRapidSpeed[2] = d.PUMP_LVL_03
											Custom_RateOfFire._PumpActionRapidSpeed[3] = d.PUMP_LVL_04
											Custom_RateOfFire._PumpActionRapidSpeed[4] = d.PUMP_LVL_05
										end
									end
								end
							end
						end
						
						if Custom_LimitBreakCustoms then
							for i, LimitBreakCategories in ipairs(Custom_LimitBreakCustoms) do
								local Custom_CategoryID = LimitBreakCategories:call("get_LimitBreakCustomCategory")
								local Custom_Category_Name = LimitBreakCategory_enums[Custom_CategoryID]
							
								if Custom_Category_Name and Custom_Category_Name:find("CriticalRate") then
									local Custom_CriticalRateEX = LimitBreakCategories:get_field("_LimitBreakCriticalRate")
								
									if Custom_CriticalRateEX then
										Custom_CriticalRateEX._CriticalRateNormalScale = d.EX_CRIT
										Custom_CriticalRateEX._CriticalRateFitScale = d.EX_CRIT_FIT
									end
								end

								if Custom_Category_Name and Custom_Category_Name:find("AttackUp") then
									local Custom_AttackUpEX = LimitBreakCategories:get_field("_LimitBreakAttackUp")
								
									if Custom_AttackUpEX then
										Custom_AttackUpEX._DamageRateScale = d.EX_DMG
										Custom_AttackUpEX._WinceRateScale = d.EX_WINCE
										Custom_AttackUpEX._BreakRateScale = d.EX_BRK
										Custom_AttackUpEX._StoppingRateScale = d.EX_STOP
									end
								end

								if Custom_Category_Name and Custom_Category_Name:find("ShotGunAroundAttackUp") then
									local Custom_SGAttackUpEX = LimitBreakCategories:get_field("_LimitBreakShotGunAroundAttackUp")
								
									if Custom_SGAttackUpEX then
										Custom_SGAttackUpEX._DamageRateScale = d.EX_SG_DMG
										Custom_SGAttackUpEX._WinceRateScale = d.EX_SG_WINCE
										Custom_SGAttackUpEX._BreakRateScale = d.EX_SG_BRK
										Custom_SGAttackUpEX._StoppingRateScale = d.EX_SG_STOP
									end
								end

								if Custom_Category_Name and Custom_Category_Name:find("ThroughNum") then
									local Custom_ThroughNumEX = LimitBreakCategories:get_field("_LimitBreakThroughNum")
								
									if Custom_ThroughNumEX then
										Custom_ThroughNumEX._ThroughNumNormal = d.EX_PIRC
										Custom_ThroughNumEX._ThroughNumFit = d.EX_PIRC_FIT
									end
								end

								if Custom_Category_Name and Custom_Category_Name:find("AmmoMaxUp") then
									local Custom_AmmoMaxUpEX = LimitBreakCategories:get_field("_LimitBreakAmmoMaxUp")
								
									if Custom_AmmoMaxUpEX then
										Custom_AmmoMaxUpEX._AmmoMaxScale = d.EX_AMMO
										Custom_AmmoMaxUpEX._ReloadNumScale = d.EX_SG_RELOAD
									end
								end

								if Custom_Category_Name and Custom_Category_Name:find("Rapid") then
									local Custom_RapidEX = LimitBreakCategories:get_field("_LimitBreakRapid")
								
									if Custom_RapidEX then
										Custom_RapidEX._RapidSpeedScale = d.EX_ROF
									end
								end

								if Custom_Category_Name and Custom_Category_Name:find("Strength") then
									local Custom_StrengthEX = LimitBreakCategories:get_field("_LimitBreakStrength")
								
									if Custom_StrengthEX then
										Custom_StrengthEX._DurabilityMaxScale = d.EX_DUR
									end
								end

								if Custom_Category_Name and Custom_Category_Name:find("OKReload") then
									local Custom_OKEX = LimitBreakCategories:get_field("_LimitBreakOKReload")
								
									if Custom_OKEX then
										Custom_OKEX._IsOKReload = d.EX_OK --THIS IS A BOOLEAN
									end
								end

								if Custom_Category_Name and Custom_Category_Name:find("CombatSpeed") then
									local Custom_CombatSpeedEX = LimitBreakCategories:get_field("_LimitBreakCombatSpeed")
								
									if Custom_CombatSpeedEX then
										Custom_CombatSpeedEX._CombatSpeed = d.EX_SPEED
									end
								end

								if Custom_Category_Name and Custom_Category_Name:find("Unbreakable") then
									local Custom_UnbreakableEX = LimitBreakCategories:get_field("_LimitBreakUnbreakable")
								
									if Custom_UnbreakableEX then
										Custom_UnbreakableEX._IsUnbreakable = d.EX_UNBRK --THIS IS ALSO A BOOLEAN
									end
								end
							end
						end
						
						-- if Custom_AttachmentCustoms then
						-- 	for i, AttachmentCategories in ipairs(Custom_AttachmentCustoms) do
						-- 		local Custom_CategoryID = AttachmentCategories:call("get_AttachmentParams")
						-- 		local Custom_Category_Name = AttachmentCategory_enums[Custom_CategoryID]
						-- 		re.msg("Got Custom_AttachmentCustoms")--This returns so TODO from here

						-- 		if Custom_Category_Name and Custom_Category_Name:find("MeshPartsNums") then
						-- 			local Custom_ATT_MeshPartsNums = AttachmentCategories:get_field("_MeshPartsNums")
									
						-- 			if Custom_ATT_MeshPartsNums then
						-- 				re.msg("Got ATT MeshPartsNums")
						-- 				Custom_ATT_MeshPartsNums._Items[0] = d.ATT_MeshPart
						-- 				Custom_ATT_MeshPartsNums._Items[1] = d.ATT_MeshPart_EX
						-- 			end
						-- 		end

						-- 		if Custom_Category_Name and Custom_Category_Name:find("RandomRadius_Fit") then
						-- 			re.msg("Got ATT RandomRadius_Fit")
						-- 			AttachmentCategories._RandomRadius_Normal = d.ATT_RandomRadius
						-- 			AttachmentCategories._RandomRadius_Fit = d.ATT_RandomRadius_Fit
						-- 		end
						-- 	end
						-- end
					end
					break
				end
			end

			for i, ItemID in ipairs(WeaponDataTables) do
				local WeaponID = ItemID:call("get_WeaponID")
				local WeaponIDName = weapons_enum[WeaponID]

				if WeaponIDName and WeaponIDName:find(self.WP_ID) then
					local RecoilParam = ItemID:get_field("_CameraRecoilParam")
					local ReticleParam = ItemID:get_field("_ReticleFitParamTable")
					local HandShakeParam = ItemID:get_field("_HandShakeParam")
					
					if RecoilParam then
						local YawRangeDeg = RecoilParam:get_field("_YawRangeDeg")
						local PitchRangeDeg = RecoilParam:get_field("_PitchRangeDeg")

						if YawRangeDeg then
							YawRangeDeg.s = d.Recoil_YawMin
							YawRangeDeg.r = d.Recoil_YawMax
							write_valuetype(RecoilParam, 0x18, YawRangeDeg)
						end

						if PitchRangeDeg then
							PitchRangeDeg.s = d.Recoil_PitchMin
							PitchRangeDeg.r = d.Recoil_PitchMax
							write_valuetype(RecoilParam, 0x20, PitchRangeDeg)
						end
					end

					if ReticleParam then
						ReticleParam._ReticleShape = d.ReticleType
					end
					
					if HandShakeParam then
						HandShakeParam.Time = d.HandShake_Time
						HandShakeParam.RStickOffset = d.HandShake_Offset
					end
				end
			end
			self.setPlayerCatalog = true
		end
		
		--Setup GameObject part:
		if not self.setGun or d.Changed then
			if (not self.Gun or not sdk.is_managed_object(self.Gun) or not self.Gun:get_Valid()) or d.Changed then
				log.info("AWF GameObject")

				self.setPlayerItems = false
				self.gameObject = getGameObject(scene, self.WP_ID)
				if self.gameObject then
					self.Gun = self.gameObject:call("getComponent(System.Type)", sdk.typeof("chainsaw.Gun"))

					if self.Gun then
						local Shell = self.Gun:get_field("<ShellGenerator>k__BackingField")
						local WPstructParams = self.Gun:get_field("WeaponStructureParam")
						local ThinkPlayerParam = self.Gun:get_field("<ThinkPlayerParam>k__BackingField")
						local Focus = self.Gun:get_field("<ReticleFitParam>k__BackingField")
					
						if Shell then
							local Shell_UserData = Shell:get_field("_UserData")
							-- Shell.AroundShellBufCapa = d.SG_AroundShellBufCapa
							-- Shell.AroundShellBufCount = d.SG_AroundShellBufCount
						
							if Shell_UserData then
								local Shell_HG_SMG_SR_MAG = Shell_UserData:get_field("_ShellInfoUserData")
								local ShellSG_CenterUserData = Shell_UserData:get_field("_CenterShellInfoUserData")
								local ShellSG_AroundUserData = Shell_UserData:get_field("_AroundShellInfoUserData")
								local ShellSG_AroundSettings = Shell_UserData:get_field("_AroundShellSetting")

								if (self.WPtype == "SG") or (self.WPtype == "SG_PUMP") then
									if ShellSG_CenterUserData then
										local ShellSG_CenterUserData_Life = ShellSG_CenterUserData:get_field("_LifeInfo")
										local ShellSG_CenterUserData_Move = ShellSG_CenterUserData:get_field("_MoveInfo")
										local ShellSG_CenterUserData_Attack = ShellSG_CenterUserData:get_field("_AttackInfo")
								
										if ShellSG_CenterUserData_Life then
											ShellSG_CenterUserData_Life._Time = d.SG_CenterLife_Time
											ShellSG_CenterUserData_Life._Distance = d.SG_CenterLife_Distance
										end
									
										if ShellSG_CenterUserData_Move then
											ShellSG_CenterUserData_Move._RandomRadius = d.SG_Center_Random
											ShellSG_CenterUserData_Move._RandomRadius_Fit = d.SG_Center_RandomFit
											ShellSG_CenterUserData_Move._Speed = d.SG_CenterMove_Speed
											ShellSG_CenterUserData_Move._Gravity = d.SG_CenterMove_Gravity
											ShellSG_CenterUserData_Move._IgnoreGravityDistance = d.SG_CenterMove_IGD
										end
								
										if ShellSG_CenterUserData_Attack then
											local ShellSG_CenterUserData_Attack_DamgeRate = ShellSG_CenterUserData_Attack:get_field("_DamageRate")
											local ShellSG_CenterUserData_Attack_WinceRate = ShellSG_CenterUserData_Attack:get_field("_WinceRate")
											local ShellSG_CenterUserData_Attack_BreakRate = ShellSG_CenterUserData_Attack:get_field("_BreakRate")
											local ShellSG_CenterUserData_Attack_StopRate = ShellSG_CenterUserData_Attack:get_field("_StoppingRate")
										
											ShellSG_CenterUserData_Attack._ColliderRadius = d.SG_Center_BulletCol
											ShellSG_CenterUserData_Attack._CriticalRate = d.SG_Center_CritRate
											ShellSG_CenterUserData_Attack._CriticalRate_Fit = d.SG_Center_CritRate_EX
										
											if ShellSG_CenterUserData_Attack_DamgeRate then
												ShellSG_CenterUserData_Attack_DamgeRate._BaseValue = d.SG_Center_BaseDMG
											end
										
											if ShellSG_CenterUserData_Attack_WinceRate then
												ShellSG_CenterUserData_Attack_WinceRate._BaseValue = d.SG_Center_BaseWINC
											end
										
											if ShellSG_CenterUserData_Attack_BreakRate then
												ShellSG_CenterUserData_Attack_BreakRate._BaseValue = d.SG_Center_BaseBRK
											end
											
											if ShellSG_CenterUserData_Attack_StopRate then
												ShellSG_CenterUserData_Attack_StopRate._BaseValue = d.SG_Center_BaseSTOP
											end
										end
									end

									if ShellSG_AroundUserData then
										local ShellSG_AroundUserData_Life = ShellSG_AroundUserData:get_field("_LifeInfo")
										local ShellSG_AroundUserData_Move = ShellSG_AroundUserData:get_field("_MoveInfo")
										local ShellSG_AroundUserData_Attack = ShellSG_AroundUserData:get_field("_AttackInfo")
								
										if ShellSG_AroundUserData_Life then
											ShellSG_AroundUserData_Life._Time = d.SG_AroundLife_Time
											ShellSG_AroundUserData_Life._Distance = d.SG_AroundLife_Distance
										end
								
										if ShellSG_AroundUserData_Move then
											ShellSG_AroundUserData_Move._RandomRadius = d.SG_Around_Random
											ShellSG_AroundUserData_Move._RandomRadius_Fit = d.SG_Around_RandomFit
											ShellSG_AroundUserData_Move._Speed = d.SG_AroundMove_Speed
											ShellSG_AroundUserData_Move._Gravity = d.SG_AroundMove_Gravity
											ShellSG_AroundUserData_Move._IgnoreGravityDistance = d.SG_AroundMove_IGD
										end
								
										if ShellSG_AroundUserData_Attack then
											local ShellSG_AroundUserData_Attack_DamgeRate = ShellSG_AroundUserData_Attack:get_field("_DamageRate")
											local ShellSG_AroundUserData_Attack_WinceRate = ShellSG_AroundUserData_Attack:get_field("_WinceRate")
											local ShellSG_AroundUserData_Attack_BreakRate = ShellSG_AroundUserData_Attack:get_field("_BreakRate")
											local ShellSG_AroundUserData_Attack_StopRate = ShellSG_AroundUserData_Attack:get_field("_StoppingRate")
										
											ShellSG_AroundUserData_Attack._ColliderRadius = d.SG_Around_BulletCol
											ShellSG_AroundUserData_Attack._CriticalRate = d.SG_Around_CritRate
											ShellSG_AroundUserData_Attack._CriticalRate_Fit = d.SG_Around_CritRate_EX
										
											if ShellSG_AroundUserData_Attack_DamgeRate then
												ShellSG_AroundUserData_Attack_DamgeRate._BaseValue = d.SG_Around_BaseDMG
											end
										
											if ShellSG_AroundUserData_Attack_WinceRate then
												ShellSG_AroundUserData_Attack_WinceRate._BaseValue = d.SG_Around_BaseWINC
											end
										
											if ShellSG_AroundUserData_Attack_BreakRate then
												ShellSG_AroundUserData_Attack_BreakRate._BaseValue = d.SG_Around_BaseBRK
											end
											
											if ShellSG_AroundUserData_Attack_StopRate then
												ShellSG_AroundUserData_Attack_StopRate._BaseValue = d.SG_Around_BaseSTOP
											end
										end
									end

									if ShellSG_AroundSettings then
										local SG_AroundScatterParam = ShellSG_AroundSettings:get_field("_AroundScatterParam")

										ShellSG_AroundSettings._AroundBulletCount = d.SG_AroundBulletCount
										ShellSG_AroundSettings._CenterBulletCount = d.SG_CenterBulletCount
										ShellSG_AroundSettings._InnerRadius = d.SG_InnerRadius
										ShellSG_AroundSettings._OuterRadius = d.SG_OuterRadius

										if SG_AroundScatterParam then
											local SG_VertScatterRange = SG_AroundScatterParam:get_field("_VerticalScatterDegreeRange")
											local SG_HorScatterRange = SG_AroundScatterParam:get_field("_HorizontalScatterDegreeRange")
												
											if SG_VertScatterRange then
												SG_VertScatterRange.s = d.SG_AroundVertMin
												SG_VertScatterRange.r = d.SG_AroundVertMax
												write_valuetype(SG_AroundScatterParam, 0x10, SG_VertScatterRange)
											end
											
											if SG_HorScatterRange then 
												SG_HorScatterRange.s = d.SG_AroundHorMin
												SG_HorScatterRange.r = d.SG_AroundHorMax
												write_valuetype(SG_AroundScatterParam, 0x18, SG_HorScatterRange)
											end
										end
									end
								end

								if (self.WPtype == "HG") or (self.WPtype == "SMG") or (self.WPtype == "SR") or (self.WPtype == "SR_PUMP") or (self.WPtype == "MAG") or (self.WPtype == "MAG_SEMI") then
									if Shell_HG_SMG_SR_MAG then
										local ShellHG_UserData_Life = Shell_HG_SMG_SR_MAG:get_field("_LifeInfo")
										local ShellHG_UserData_Move = Shell_HG_SMG_SR_MAG:get_field("_MoveInfo")
										local ShellHG_UserData_Attack = Shell_HG_SMG_SR_MAG:get_field("_AttackInfo")
								
										if ShellHG_UserData_Life then
											ShellHG_UserData_Life._Time = d.HG_Time
											ShellHG_UserData_Life._Distance = d.HG_Distance
										end
								
										if ShellHG_UserData_Move then
											ShellHG_UserData_Move._Speed = d.HG_BulletSpeed
											ShellHG_UserData_Move._Gravity = d.HG_BulletGravity
											ShellHG_UserData_Move._IgnoreGravityDistance = d.HG_BulletGravityIgnore
											ShellHG_UserData_Move._RandomRadius = d.SMG_Random
											ShellHG_UserData_Move._RandomRadius_Fit = d.SMG_RandomFit
										end
							
										if ShellHG_UserData_Attack then
											local ShellHG_UserData_Attack_DamageRate = ShellHG_UserData_Attack:get_field("_DamageRate")
											local ShellHG_UserData_Attack_WinceRate = ShellHG_UserData_Attack:get_field("_WinceRate")
											local ShellHG_UserData_Attack_BreakRate = ShellHG_UserData_Attack:get_field("_BreakRate")
											local ShellHG_UserData_Attack_StopRate = ShellHG_UserData_Attack:get_field("_StoppingRate")
									
											ShellHG_UserData_Attack._ColliderRadius = d.HG_BulletCol
											ShellHG_UserData_Attack._CriticalRate = d.HG_CritRate
											ShellHG_UserData_Attack._CriticalRate_Fit = d.HG_CritRateEX
									
											if ShellHG_UserData_Attack_DamageRate then
												ShellHG_UserData_Attack_DamageRate._BaseValue = d.HG_BaseDMG
											end
											if ShellHG_UserData_Attack_WinceRate then
												ShellHG_UserData_Attack_WinceRate._BaseValue = d.HG_BaseWINC
											end
											if ShellHG_UserData_Attack_BreakRate then
												ShellHG_UserData_Attack_BreakRate._BaseValue = d.HG_BaseBRK
											end
											if ShellHG_UserData_Attack_StopRate then
												ShellHG_UserData_Attack_StopRate._BaseValue = d.HG_BaseSTOP
											end
										end
									end
								end
							end
						end
					
						if WPstructParams then
							WPstructParams.TypeOfReload = d.ReloadType
							WPstructParams.TypeOfShoot = d.ShootType
							WPstructParams.ReloadNum = d.ReloadNum
							WPstructParams._ReloadSpeedRate = d.ReloadSpeedRate
							WPstructParams._RapidSpeed = d.FireRate
							WPstructParams._RapidBaseFrame = d.FireRateFrame
							WPstructParams._PumpActionRapidSpeed = d.PumpActionFireRate
						end
					
						if ThinkPlayerParam then
							ThinkPlayerParam.RangeDistance = d.ThinkRange
						end
					
						if Focus then
							Focus._HoldAddPoint = d.Focus_HoldAdd
							Focus._MoveSubPoint = d.Focus_MoveSub
							Focus._CameraSubPoint = d.Focus_CamSub
							Focus._KeepFitLimitPoint = d.Focus_Limit
							Focus._ShootSubPoint = d.Focus_ShootSub
						end
					end
				end
			end
			self.setGun = true
		end
	
		--Setup Inventory part:
		if (not self.setPlayerItems and PlayerItems[1]) or d.Changed then
			log.info("AWF Inventory")
			for i, ItemID in ipairs(PlayerItems) do
				local WeaponID = ItemID:call("get_WeaponId")
				local WeaponIDName = weapons_enum[WeaponID]
				if WeaponIDName and WeaponIDName:find(self.WP_ID) then
					local Item = ItemID:get_field("<Item>k__BackingField")
					if Item then
						local ItemDEF = Item:get_field("<_DefaultWeaponDefine>k__BackingField")

                        Item._CurrentAmmo = d.AmmoType

						if ItemDEF then
							ItemDEF._AmmoMax = d.BaseAmmoNum
							ItemDEF._AmmoCost = d.BaseAmmoCost
							ItemDEF._ItemSize = d.ItemSize
							ItemDEF.DefaultDurabilityMaxValue = d.DurDEF_Max
							ItemDEF._SliderDurabilityMaxValue = d.DurSLD_Max
							ItemDEF._DefaultDurabilityMax = d.DurDEF_Max
							ItemDEF._StackMax = d.ItemStack
						end
					end
					break
				end
			end
			self.setPlayerItems = true
		end

		if d.Changed then
			d.Changed = false
		end
	end,

	display_imgui = function(self)
		if EMV then
        	if imgui.tree_node(self.name) then
            	for key, value in EMV.orderedPairs(self.data) do
                	local changed
                	local newValue = value
                	if type(value) == "string" and tonumber(value) then
                    	newValue = tonumber(value)
                	end
                	if type(newValue) == "number" then
                    	if tostring(newValue):find("%.") then
                        	changed, newValue = imgui.drag_float(key, newValue, 0.01, -10000000, 10000000)
                    	else
                        	changed, newValue = imgui.drag_int(key, newValue, 1, -100000000, 100000000)
                    	end
                	elseif type(newValue) == "string" then
                    	changed, newValue = imgui.input_text(key, newValue)
                	end
                	if type(value)=="string" and tostring(newValue) then
                    	newValue = tostring(newValue)
                	end
                	if changed then
                 		self.setPlayerCatalog, self.setPlayerItems, self.Gun = false, false, nil
                    	self.data[key] = newValue
                	end
            	end
            	imgui.tree_pop()
			end
    	end
	end,
}

local AWFWeapons = {
	SG09R = AWFWeaponRE4:new{name="SG09R", WP_ID="wp4000", WPtype="HG"},
	PUN = AWFWeaponRE4:new{name="PUN", WP_ID="wp4001", WPtype="HG"},
    RED9 = AWFWeaponRE4:new{name="RED9", WP_ID="wp4002", WPtype="HG"},
    BT = AWFWeaponRE4:new{name="BT", WP_ID="wp4003", WPtype="HG"},
    VP70 = AWFWeaponRE4:new{name="VP70", WP_ID="wp4004", WPtype="HG"},
    SEN9 = AWFWeaponRE4:new{name="SEN9", WP_ID="wp6000", WPtype="HG"},
    M870 = AWFWeaponRE4:new{name="M870", WP_ID="wp4100", WPtype="SG_PUMP"},
    BM4 = AWFWeaponRE4:new{name="BM4", WP_ID="wp4101", WPtype="SG"},
	STKR = AWFWeaponRE4:new{name="STKR", WP_ID="wp4102", WPtype="SG"},
	SKUL = AWFWeaponRE4:new{name="SKUL", WP_ID="wp6001", WPtype="SG"},
	TMP = AWFWeaponRE4:new{name="TMP", WP_ID="wp4200", WPtype="SMG"},
	CTW = AWFWeaponRE4:new{name="CTW", WP_ID="wp4201", WPtype="SMG"},
	LE5 = AWFWeaponRE4:new{name="LE5", WP_ID="wp4202", WPtype="SMG"},
	M1G = AWFWeaponRE4:new{name="M1G", WP_ID="wp4400", WPtype="SR_PUMP"},
	SAR = AWFWeaponRE4:new{name="SAR", WP_ID="wp4401", WPtype="SR"},
	CQBR = AWFWeaponRE4:new{name="CQBR", WP_ID="wp4402", WPtype="SR"},
	BRB = AWFWeaponRE4:new{name="BRB", WP_ID="wp4500", WPtype="MAG"},
	KIL7 = AWFWeaponRE4:new{name="KIL7", WP_ID="wp4501", WPtype="MAG_SEMI"},
	HNDC = AWFWeaponRE4:new{name="HNDC", WP_ID="wp4502", WPtype="MAG"},
}

local function find_weapons_lists()
	
	if not WeaponDetailStages[1] then
		local WeaponCustomCatalog = getGameObject(scene, GameObjectsTable[1])

		if WeaponCustomCatalog then
			local WeaponCustomCatalogRegister = WeaponCustomCatalog:call("getComponent(System.Type)", sdk.typeof("chainsaw.WeaponCustomCatalogRegister"))

			if WeaponCustomCatalogRegister then
				local WeaponCustomUserdata = WeaponCustomCatalogRegister:call("get_WeaponCustomUserdata")
				local WeaponDetailCustomUserdata = WeaponCustomCatalogRegister:call("get_WeaponDetailCustomUserdata")

				if WeaponCustomUserdata then
					WeaponStages = WeaponCustomUserdata:get_field("_WeaponStages")
					WeaponStages = WeaponStages and WeaponStages:get_elements() or {}
				end
				if WeaponDetailCustomUserdata then
					WeaponDetailStages = WeaponDetailCustomUserdata:get_field("_WeaponDetailStages")
					WeaponDetailStages = WeaponDetailStages and WeaponDetailStages:get_elements() or {}
				end
			end
		end

		
	end
	
	if not PlayerItems[1] then
		local PlayerInventoryObserver = getGameObject(scene, GameObjectsTable[2])
		if PlayerInventoryObserver then
			local InventoryObserver = PlayerInventoryObserver:call("getComponent(System.Type)", sdk.typeof("chainsaw.PlayerInventoryObserver"))
			if InventoryObserver then
				local Observer = InventoryObserver:get_field("_Observer")
				if Observer then
					local InventoryController = Observer:get_field("_InventoryController")
					
					if InventoryController then
						local CS_Inventory = InventoryController:get_field("<_CsInventory>k__BackingField")
						
						
						if CS_Inventory then
							local InventoryItems = CS_Inventory:get_field("_InventoryItems")
							
							if InventoryItems then
								PlayerItems = InventoryItems:get_field("_items")
								PlayerItems = PlayerItems and PlayerItems:get_elements() or {}
							end
						end
					end
				end
			end
		end
	end

	if not WeaponDataTables[1] then
		local WeaponCatalog = getGameObject(scene, GameObjectsTable[3])

		if WeaponCatalog then
			local WeaponCatalogRegister = WeaponCatalog:call("getComponent(System.Type)", sdk.typeof("chainsaw.WeaponCatalogRegister"))

			if WeaponCatalogRegister then
				local WeaponEquipParamCatalogUserData = WeaponCatalogRegister:call("get_WeaponEquipParamCatalogUserData")

				if WeaponEquipParamCatalogUserData then
					WeaponDataTables = WeaponEquipParamCatalogUserData:get_field("_DataTable")
					WeaponDataTables = WeaponDataTables and WeaponDataTables:get_elements() or {}
				end
			end
		end
	end
end

re.on_frame(function()
	if scene_manager then 
       	scene = sdk.call_native_func(scene_manager, sdk.find_type_definition("via.SceneManager"), "get_CurrentScene")
   	 end
	
	if not scene then return end
	
	local player = get_localplayer_context()
	
	if not player then 
		PlayerItems = {} --PlayerItems is reset when the player is not found, resetting the Inventory parts of every AWFWeapon
		return nil
	end
	
	find_weapons_lists()
	
	for WP_ID, AWFWeapon in pairs(AWFWeapons) do
		AWFWeapon:update()
	end
end)

AWF = {
	scene_manager = scene_manager,
	scene = scene,
	create_resource = create_resource,
	REMgdObj = REMgdObj,
	get_kb_device = get_kb_device,
	get_mouse_device = get_mouse_device,
	get_gp_device = get_gp_device,
	kb_state = kb_state,
	mouse_state = mouse_state,
	gamepad_state = gamepad_state,
	update_keyboard_state = update_keyboard_state,
	update_mouse_state = update_mouse_state,
	update_gamepad_state = update_gamepad_state,
	show_AWF_window = show_AWF_window,
	AWF_window = AWF_window,
	weapons_enum = weapons_enum,
	CustomCategory_enums = CustomCategory_enums,
	IndividualCategory_enums = IndividualCategory_enums,
	LimitBreakCategory_enums = LimitBreakCategory_enums,
	getGameObject = getGameObject,
	WeaponIDs = WeaponIDs,
	AWFWeapons = AWFWeapons,
	WeaponData = WeaponData,
}

return AWF