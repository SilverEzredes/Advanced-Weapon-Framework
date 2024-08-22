
--/////////////////////////////////////--
local modName =  "Advanced Weapon Framework - Holsters"

local modAuthor = "SilverEzredes"
local modUpdated = "08/22/2024"
local modVersion = "v1.0.0"
local modCredits = "praydog; alphaZomega"

--/////////////////////////////////////--
local hk = require("Hotkeys/Hotkeys")
local func = require("_SharedCore/Functions")

local changed = false
local wc = false

local playerContext = nil
local playerHead = nil
local isPlayerInScene = false
local playerEquipment = "chainsaw.PlayerEquipment"

local AWF_HOL_default_settings = {
    input_mode_idx =  1,
    option_mode_idx = 1,
    use_modifier = false,
    use_pad_modifier = false,
    hold_time = 1.50,
	hotkeys = {
		["Holster Modifier"] = "R Mouse",
		["Holster Switch"] = "H",
		["Pad Holster Modifier"] = "LT (L2)",
		["Pad Holster Switch"] = "X (Square)",
	},
    isHolsterRequest = false
}

local AWF_HOL_settings = hk.merge_tables({}, AWF_HOL_default_settings) and hk.recurse_def_settings(json.load_file("AWF/AWF_Holsters/AWF_Holster_Settings.json") or {}, AWF_HOL_default_settings)
hk.setup_hotkeys(AWF_HOL_settings.hotkeys)

local function get_playerContext()
    local character_manager
    character_manager = sdk.get_managed_singleton(sdk.game_namespace("CharacterManager"))
    playerContext = character_manager and character_manager:call("getPlayerContextRef")
    return playerContext
end

local function set_HolsterData()
    get_playerContext()

    if playerContext ~= nil then
        isPlayerInScene = true
        playerHead = playerContext and playerContext:get_HeadGameObject()

        if playerHead then
            local playerEquipmentComp = func.get_GameObjectComponent(playerHead, playerEquipment)

            if playerEquipmentComp then
                local playerInventory = playerEquipmentComp:get_InventoryController():get__CsInventory()

                if playerInventory then
                    if AWF_HOL_settings.isHolsterRequest then
                        playerInventory:call("unequip(chainsaw.EquipType)", 0)

                        local playerInventory_Shortcuts = playerInventory._ActiveShortcutInfos

                        for i in pairs(playerInventory_Shortcuts) do
                            playerInventory_Shortcuts[0]:set_CurrActiveDirection(4)
                        end

                        AWF_HOL_settings.isHolsterRequest = false
                    end
                end
            end
        end

    elseif playerContext == nil or {} then
        isPlayerInScene = false
    end
end

local function update_HolsterData()
    local KM_controls = ((not AWF_HOL_settings.use_modifier or hk.check_hotkey("Holster Modifier", false)) and hk.check_hotkey("Holster Switch")) or (hk.check_hotkey("Holster Modifier", true) and hk.check_hotkey("Holster Switch"))
    local PAD_controls = ((not AWF_HOL_settings.use_pad_modifier or hk.check_hotkey("Pad Holster Modifier", false)) and hk.check_hold("Pad Holster Switch", AWF_HOL_settings.hold_time)) or (hk.check_hotkey("Pad Holster Modifier", true) and hk.check_hold("Pad Holster Switch", AWF_HOL_settings.hold_time))

    if KM_controls or PAD_controls then
        AWF_HOL_settings.isHolsterRequest = true
        set_HolsterData()
    end
end

local function draw_AWF_RE4Holster_GUI()
    if imgui.tree_node("Advanced Weapon Framework: Holsters") then
        imgui.begin_rect()
        imgui.spacing()
        imgui.indent(5)
        if imgui.button("Reset to Defaults") then
            AWF_HOL_settings = hk.recurse_def_settings({}, AWF_HOL_default_settings); wc = wc or changed
            hk.reset_from_defaults_tbl(AWF_HOL_default_settings.hotkeys)
        end
        func.tooltip("Reset every parameter.")
        
        imgui.spacing()
    
        imgui.begin_rect()
        changed, AWF_HOL_settings.input_mode_idx = imgui.combo("Input Settings", AWF_HOL_settings.input_mode_idx, {"Default", "Custom"}); wc = wc or changed
        func.tooltip("Set the control scheme for the mod")
        if AWF_HOL_settings.input_mode_idx == 2 then
            if imgui.tree_node("Keyboard and Mouse Settings") then
                changed, AWF_HOL_settings.use_modifier = imgui.checkbox(" ", AWF_HOL_settings.use_modifier); wc = wc or changed
                func.tooltip("Require that you hold down this button")
                imgui.same_line()
                changed = hk.hotkey_setter("Holster Modifier"); wc = wc or changed
                changed = hk.hotkey_setter("Holster Switch", AWF_HOL_settings.use_modifier and "Holster Modifier"); wc = wc or changed
                imgui.tree_pop()
            end
            
            if imgui.tree_node("Gamepad Settings") then
                changed, AWF_HOL_settings.hold_time = imgui.drag_float("Hold Time", AWF_HOL_settings.hold_time, 0.01, 0.0, 5.0); wc = wc or changed
                func.tooltip("The required number of seconds you must hold down the Pad Holster Switch button to holster your current weapon.\nThis is always required on controllers.")
                changed, AWF_HOL_settings.use_pad_modifier = imgui.checkbox(" ", AWF_HOL_settings.use_pad_modifier); wc = wc or changed
                func.tooltip("Require that you hold down this button")
                imgui.same_line()
                changed = hk.hotkey_setter("Pad Holster Modifier"); wc = wc or changed
                changed = hk.hotkey_setter("Pad Holster Switch", AWF_HOL_settings.use_pad_modifier and "Pad Holster Modifier"); wc = wc or changed
                imgui.tree_pop()
            end
        end
        imgui.end_rect(2)
        
        ui.button_n_colored_txt("Current Version:", modVersion .. " | " .. modUpdated, func.convert_rgba_to_AGBR(0, 255, 0, 255))
        imgui.same_line()
        imgui.text("| by " .. modAuthor .. " ")
        
        if changed or wc then
            hk.update_hotkey_table(AWF_HOL_settings.hotkeys)
            json.dump_file("AWF/AWF_Holsters/AWF_Holster_Settings.json", AWF_HOL_settings)
            changed = false
            wc = false
        end
    
        imgui.indent(-5)
        imgui.spacing()
        imgui.end_rect(1)
        imgui.tree_pop()
    end
end

re.on_frame(function ()
    update_HolsterData()
end)

re.on_draw_ui(function ()
    draw_AWF_RE4Holster_GUI()
end)