--/////////////////////////////////////--
-- Advanced Weapon Framework

-- Author: SilverEzredes
-- Updated: 12/20/2023
-- Version: v1.3.0
-- Special Thanks to: praydog; alphaZomega; MrBoobieBuyer; Lotiuss

--/////////////////////////////////////--
local AWF = require("AWFCore")
local func = require("_SharedCore/Functions")

local scene = func.get_CurrentScene()
local AWF_inventory_found = false
NowLoading = false

local function check_for_player_inventory_RE7()
    local inventory_GameObject_RE7 = scene:call("findGameObject(System.String)", "InventoryMenu")
   
    if inventory_GameObject_RE7 then
        local inventory = inventory_GameObject_RE7:call("get_DrawSelf")
        
        if inventory and not AWF_inventory_found then
            AWF.cache_weapon_gameobjects_RE7(AWF.AWF_settings.RE7_Weapons)
            AWF.get_weapon_gameobject_RE7(AWF.AWF_settings.RE7_Weapons)
            AWF_inventory_found = true
            log.info("--------------------- Inventory found, AWF data updated!")
        elseif not inventory then
            AWF_inventory_found = false
        end
    end
end

local function check_for_loading_tip_RE7()
    local loading_tip_GameObject_RE7 = scene:call("findGameObject(System.String)", "TipsGUI")

    if loading_tip_GameObject_RE7 then
        local loading_tip_on_screen = loading_tip_GameObject_RE7:call("get_DrawSelf")

        if loading_tip_on_screen and not NowLoading then
            log.info("--------------------- Loading... All AWF Data Updated!")
            check_for_player_inventory_RE7()
            NowLoading = true
        elseif not loading_tip_on_screen then
            NowLoading = false
        end
    end
end

re.on_frame(function()
    AWF.update_cached_weapon_gameobjects_RE7()
    check_for_loading_tip_RE7()
end)