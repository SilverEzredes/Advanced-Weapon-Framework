--/////////////////////////////////////--
-- Advanced Weapon Framework - Gunsmith

-- Author: SilverEzredes
-- Updated: 01/27/2024
-- Version: v1.4.50
-- Special Thanks to: praydog; alphaZomega

--/////////////////////////////////////--
local AWF = require("AWFCore")
local hk = require("_SharedCore/Hotkeys")
local func = require("_SharedCore/Functions")
local ui = require("_SharedCore/Imgui")

local scene = func.get_CurrentScene()
local changed = false
local wc = false

local AWF_WPM_default_settings = {
    show_AWF_Gunsmith_editor = false
}

local AWFWeapons = {
    RE7_Gunsmith = {
        wp1000_GasBurner_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1010_Handgun_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1030_Shotgun_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1033_Shotgun_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1110_PortableCannon_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1140_Magnum_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1160_MachineGun_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1190_Knife_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1210_Handgun_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1230_PumpShotgun_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1240_MiaHandgun_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1330_ChrisShotgun_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1340_ChrisHandgun_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1340_ChrisHandgun_Reward_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1360_MiaKnife_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1390_ChrisKnife_Item = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
    },
    RE2_Gunsmith = {
        wp0000 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp0100 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp0200 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp0300 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp0600 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp0700 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp0800 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp1000 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp2000 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp2200 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp3000 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp4100 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp4200 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp4300 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp4400 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp4600 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp4700 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp7000 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp7010 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp7020 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp7030 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp8400 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
        wp8700 = {
            Presets = {},
            current_preset_indx = 1,
            Parts = {},
            Enabled = {},
        },
    },
}

local AWF_WPM_settings = hk.merge_tables({}, AWF_WPM_default_settings) and func.recurse_def_settings(json.load_file("AWF/AWF_WeaponManager_Settings.json") or {}, AWF_WPM_default_settings)
local AWF_settings = hk.merge_tables({}, AWFWeapons) and func.recurse_def_settings(json.load_file("AWF/AWF_Gunsmith/AWF_Gunsmith_Settings.json") or {}, AWFWeapons)

local function weapon_parts_Manager_RE7(weaponData, WPM_table)
    for _, weapon in pairs(weaponData) do
        if WPM_table[weapon.ID] then
            local Weapon_GameObject_RE7 = scene:call("findGameObject(System.String)", weapon.ID)

            if weapon.Type ~= "Ammo" and Weapon_GameObject_RE7 then
                local render_mesh = Weapon_GameObject_RE7:call("getComponent(System.Type)", sdk.typeof("via.render.Mesh"))
                
                if render_mesh then
                    --log.info("------------------------------------Got " .. weapon.Name .. " Render Mesh component!")

                    local MatCount = render_mesh:call("get_MaterialNum")
                    
                    if MatCount then
                        WPM_table[weapon.ID].Enabled = {}
                        WPM_table[weapon.ID].Parts = {}
                        --log.info("---------------------------Got [" .. MatCount .. "] Materials")

                        for i = 0, MatCount - 1 do
                            local MatName = render_mesh:call("getMaterialName", i)
                            local EnabledMat = render_mesh:call("getMaterialsEnableIndices", i)

                            if MatName then
                                --log.info("-------------Got " .. MatName)
                                if not func.table_contains(WPM_table[weapon.ID].Parts, MatName) then
                                    table.insert(WPM_table[weapon.ID].Parts, MatName)
                                end
                                
                                if EnabledMat then
                                    --log.info("-------" .. EnabledMat .. " is Enabled")
                                    --Here we check if current_preset_indx is 1 or nil if either then we just enable all materials for that weapon.
                                    if WPM_table[weapon.ID].current_preset_indx == 1 or nil then
                                        for k, _ in ipairs(WPM_table[weapon.ID].Parts) do
                                            WPM_table[weapon.ID].Enabled[k] = true
                                        end
                                        --If current_preset_indx is greater than 1 then we load the selected preset.
                                    elseif  WPM_table[weapon.ID].current_preset_indx > 1 then
                                        --We get the selected preset by matching the current_preset_indx with the Presets table.
                                        local selected_preset = AWF_settings.RE7_Gunsmith[weapon.ID].Presets[AWF_settings.RE7_Gunsmith[weapon.ID].current_preset_indx]
                                        local json_filepath = [[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                                        local temp_parts = json.load_file(json_filepath)
                                        
                                        temp_parts.Presets = nil
                                        temp_parts.current_preset_indx = nil

                                        for key, value in pairs(temp_parts) do
                                            --log.info("------------------------------------Set " .. weapon.Name .. " Custom Preset")
                                            AWF_settings.RE7_Gunsmith[weapon.ID][key] = value
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function weapon_parts_Manager_RE2(weaponData, WPM_table)
    for _, weapon in pairs(weaponData) do
        if WPM_table[weapon.ID] then
            local Weapon_GameObject_RE2 = scene:call("findGameObject(System.String)", weapon.ID)

            if Weapon_GameObject_RE2 then
                local render_mesh = Weapon_GameObject_RE2:call("getComponent(System.Type)", sdk.typeof("via.render.Mesh"))
                
                if render_mesh then
                    local MatCount = render_mesh:call("get_MaterialNum")
                    
                    if MatCount then
                        WPM_table[weapon.ID].Enabled = {}
                        WPM_table[weapon.ID].Parts = {}

                        for i = 0, MatCount - 1 do
                            local MatName = render_mesh:call("getMaterialName", i)
                            local EnabledMat = render_mesh:call("getMaterialsEnableIndices", i)

                            if MatName then
                                if not func.table_contains(WPM_table[weapon.ID].Parts, MatName) then
                                    table.insert(WPM_table[weapon.ID].Parts, MatName)
                                end
                                
                                if EnabledMat then
                                    if WPM_table[weapon.ID].current_preset_indx == 1 or nil then
                                        for k, _ in ipairs(WPM_table[weapon.ID].Parts) do
                                            WPM_table[weapon.ID].Enabled[k] = true
                                        end
                                    elseif  WPM_table[weapon.ID].current_preset_indx > 1 then
                                        local selected_preset = AWF_settings.RE2_Gunsmith[weapon.ID].Presets[AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx]
                                        local json_filepath = [[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                                        local temp_parts = json.load_file(json_filepath)
                                        
                                        temp_parts.Presets = nil
                                        temp_parts.current_preset_indx = nil

                                        for key, value in pairs(temp_parts) do
                                            AWF_settings.RE2_Gunsmith[weapon.ID][key] = value
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

if reframework.get_game_name() == "re7" then
    weapon_parts_Manager_RE7(AWF.AWF_settings.RE7_Weapons, AWF_settings.RE7_Gunsmith)
elseif reframework.get_game_name() == "re2" then
    weapon_parts_Manager_RE2(AWF.AWF_settings.RE2_Weapons, AWF_settings.RE2_Gunsmith)
end

local function update_weapon_parts_Manager_RE7(weaponData, WPM_table)
    for _, weapon in pairs(weaponData) do
        if WPM_table[weapon.ID] then
            local Weapon_GameObject_RE7 = scene:call("findGameObject(System.String)", weapon.ID)

            if weapon.Type ~= "Ammo" then
                if Weapon_GameObject_RE7 then
                    local render_mesh = Weapon_GameObject_RE7:call("getComponent(System.Type)", sdk.typeof("via.render.Mesh"))
                    
                    if render_mesh then
                        local MatCount = render_mesh:call("get_MaterialNum")
                        
                        if MatCount then
                            for i = 0, MatCount - 1 do
                                local EnabledMat = render_mesh:call("getMaterialsEnableIndices", i)
                                
                                if EnabledMat then
                                    for j = 0, EnabledMat do
                                        render_mesh:call("setMaterialsEnable", j, WPM_table[weapon.ID].Enabled[j + 1])
                                    end
                                end
                            end
                        end
                    end
                end
            end
            WPM_table[weapon.ID].isUpdated = false
        end
    end
end

local function update_weapon_parts_Manager_RE2(weaponData, WPM_table)
    for _, weapon in pairs(weaponData) do
        if WPM_table[weapon.ID] then
            local Weapon_GameObject_RE2 = scene:call("findGameObject(System.String)", weapon.ID)
            local Weapon_Inventory_GameObject_RE2 = scene:call("findGameObject(System.String)", string.upper(weapon.ID))

            if Weapon_GameObject_RE2 then
                local render_mesh = Weapon_GameObject_RE2:call("getComponent(System.Type)", sdk.typeof("via.render.Mesh"))
                
                if render_mesh then
                    local MatCount = render_mesh:call("get_MaterialNum")
                    
                    if MatCount then
                        for i = 0, MatCount - 1 do
                            local EnabledMat = render_mesh:call("getMaterialsEnableIndices", i)
                            
                            if EnabledMat then
                                for j = 0, EnabledMat do
                                    render_mesh:call("setMaterialsEnable", j, WPM_table[weapon.ID].Enabled[j + 1])
                                end
                            end
                        end
                    end
                end
            end
            if Weapon_Inventory_GameObject_RE2 then
                local set_item = Weapon_Inventory_GameObject_RE2:call("getComponent(System.Type)", sdk.typeof("app.ropeway.gimmick.action.SetItem"))

                if set_item then
                    local render_mesh = set_item:call("get_MeshComponent")

                    if render_mesh then
                        local MatCount = render_mesh:call("get_MaterialNum")
                    
                        if MatCount then
                            for i = 0, MatCount - 1 do
                                local EnabledMat = render_mesh:call("getMaterialsEnableIndices", i)
                                
                                if EnabledMat then
                                    for j = 0, EnabledMat do
                                        render_mesh:call("setMaterialsEnable", j, WPM_table[weapon.ID].Enabled[j + 1])
                                    end
                                end
                            end
                        end
                    end
                end
            end
            WPM_table[weapon.ID].isUpdated = false
        end
    end
end

local function dump_weapon_parts_json_RE7(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParts = AWF_settings.RE7_Gunsmith[weapon.ID]

        if weaponParts and weaponParts.isUpdated then
            json.dump_file("AWF/AWF_Gunsmith/" .. weapon.Name .. "/" .. weapon.Name .. " Base" .. ".json", weaponParts)
            log.info("AWF Gunsmith Parts Dumped!")
        end
    end
end

local function dump_weapon_parts_json_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParts = AWF_settings.RE2_Gunsmith[weapon.ID]

        if weaponParts and weaponParts.isUpdated then
            json.dump_file("AWF/AWF_Gunsmith/" .. weapon.Name .. "/" .. weapon.Name .. " Base" .. ".json", weaponParts)
            log.info("AWF Gunsmith " .. weapon.Name .. " Parts Dumped!")
        end
    end
end

local function cache_WPM_json_files_RE7(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParts = AWF_settings.RE7_Gunsmith[weapon.ID]

        if weaponParts then
            local json_names = AWF_settings.RE7_Gunsmith[weapon.ID].Presets or {}
            local json_filepaths = fs.glob([[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\.*.json]])

            if json_filepaths then
                for i, filepath in ipairs(json_filepaths) do
                    local name = filepath:match("^.+\\(.+)%.")
                    local nameExists = false
                    
                    for _, existingName in ipairs(json_names) do
                        if existingName == name then
                            nameExists = true
                            break
                        end
                    end
                    
                    if not nameExists then
                        log.info("Loaded " .. filepath .. " for " .. weapon.Name)
                        table.insert(json_names, name)
                    end
                end
            else
                log.info("No WPM JSON files found for " .. weapon.Name)
            end
        end
    end
end

local function cache_WPM_json_files_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParts = AWF_settings.RE2_Gunsmith[weapon.ID]

        if weaponParts then
            local json_names = AWF_settings.RE2_Gunsmith[weapon.ID].Presets or {}
            local json_filepaths = fs.glob([[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\.*.json]])

            if json_filepaths then
                for i, filepath in ipairs(json_filepaths) do
                    local name = filepath:match("^.+\\(.+)%.")
                    local nameExists = false
                    
                    for _, existingName in ipairs(json_names) do
                        if existingName == name then
                            nameExists = true
                            break
                        end
                    end
                    
                    if not nameExists then
                        log.info("Loaded " .. filepath .. " for " .. weapon.Name)
                        table.insert(json_names, name)
                    end
                end
            else
                log.info("No WPM JSON files found for " .. weapon.Name)
            end
        end
    end
end

if reframework.get_game_name() == "re7" then
    cache_WPM_json_files_RE7(AWF.AWF_settings.RE7_Weapons)
elseif reframework.get_game_name() == "re2" then
    cache_WPM_json_files_RE2(AWF.AWF_settings.RE2_Weapons)
end

re.on_frame(function()
    if reframework.get_game_name() == "re7" then
        if AWF_WPM_settings.show_AWF_Gunsmith_editor and (changed or wc) then
            changed = false
            wc = false
            AWF_Weapons_Found = false
            dump_weapon_parts_json_RE7(AWF.AWF_settings.RE7_Weapons)
            update_weapon_parts_Manager_RE7(AWF.AWF_settings.RE7_Weapons, AWF_settings.RE7_Gunsmith)
            log.info("--------------------- AWF Gunsmith Data Updated!")
        end
    end
    if reframework.get_game_name() == "re2" then
        if AWF_WPM_settings.show_AWF_Gunsmith_editor and (changed or wc) then
            changed = false
            wc = false
            AWF_Weapons_Found = false
            dump_weapon_parts_json_RE2(AWF.AWF_settings.RE2_Weapons)
            update_weapon_parts_Manager_RE2(AWF.AWF_settings.RE2_Weapons, AWF_settings.RE2_Gunsmith)
            log.info("--------------------- AWF Gunsmith Data Updated!")
        end
    end
end)

local function draw_AWF_Gunsmith_GUI_RE7(weaponOrder)
    if imgui.begin_window("AWF Gunsmith Editor") then
        imgui.begin_rect()
        imgui.button("[===================| AWF GUNSMITH EDITOR |===================]")
        
        for _, weaponName in ipairs(weaponOrder) do
            local weaponData = AWF.AWF_settings.RE7_Weapons[weaponName]

            if weaponData and weaponData.Type ~= "Ammo" and imgui.tree_node(string.upper(weaponData.Name)) then
                imgui.begin_rect()
                if imgui.button("Update Preset List") then
                    wc = true
                    cache_WPM_json_files_RE7(AWF.AWF_settings.RE7_Weapons)
                end
                
                changed, AWF_settings.RE7_Gunsmith[weaponData.ID].current_preset_indx = imgui.combo("Preset", AWF_settings.RE7_Gunsmith[weaponData.ID].current_preset_indx or 1, AWF_settings.RE7_Gunsmith[weaponData.ID].Presets); wc = wc or changed
                func.tooltip("Select a file from the dropdown menu to load the weapon variant from that file.")
                if changed then
                    local selected_preset = AWF_settings.RE7_Gunsmith[weaponData.ID].Presets[AWF_settings.RE7_Gunsmith[weaponData.ID].current_preset_indx]
                    local json_filepath = [[AWF\\AWF_Gunsmith\\]] .. weaponData.Name .. [[\\]] .. selected_preset .. [[.json]]
                    local temp_parts = json.load_file(json_filepath)
                    
                    temp_parts.Presets = nil
                    temp_parts.current_preset_indx = nil

                    for key, value in pairs(temp_parts) do
                        AWF_settings.RE7_Gunsmith[weaponData.ID][key] = value
                    end
                end

                imgui.spacing()

                if imgui.button("Update Weapon Parts List") then
                    wc = true
                    weapon_parts_Manager_RE7(AWF.AWF_settings.RE7_Weapons, AWF_settings.RE7_Gunsmith)
                    update_weapon_parts_Manager_RE7(AWF.AWF_settings.RE7_Weapons, AWF_settings.RE7_Gunsmith)
                end

                imgui.same_line()
                func.colored_TextSwitch("Total Parts Count:", #AWF_settings.RE7_Gunsmith[weaponData.ID].Parts, #AWF_settings.RE7_Gunsmith[weaponData.ID].Parts, 0xFF00FF00, #AWF_settings.RE7_Gunsmith[weaponData.ID].Parts, 0xFF0000FF)

                for i, partName in ipairs(AWF_settings.RE7_Gunsmith[weaponData.ID].Parts) do
                    changed, AWF_settings.RE7_Gunsmith[weaponData.ID].Enabled[i] = imgui.checkbox(partName, AWF_settings.RE7_Gunsmith[weaponData.ID].Enabled[i]); wc = wc or changed
                end

                if changed or wc then
                    AWF_settings.RE7_Gunsmith[weaponData.ID].isUpdated = true
                end
                imgui.end_rect(2)
                imgui.tree_pop()
            end
            imgui.separator()
        end
        imgui.end_rect(1)
        imgui.end_window()
    end
end

local function draw_AWF_Gunsmith_GUI_RE2(weaponOrder)
    if imgui.begin_window("AWF Gunsmith Editor") then
        imgui.begin_rect()
        imgui.button("[===================| AWF GUNSMITH EDITOR |===================]")
        
        for _, weaponName in ipairs(weaponOrder) do
            local weaponData = AWF.AWF_settings.RE2_Weapons[weaponName]

            if weaponData and imgui.tree_node(string.upper(weaponData.Name)) then
                imgui.begin_rect()
                if imgui.button("Update Preset List") then
                    wc = true
                    cache_WPM_json_files_RE2(AWF.AWF_settings.RE2_Weapons)
                end

                imgui.same_line()
                imgui.button(" | ")

                imgui.same_line()
                if imgui.button("Update Weapon Parts List") then
                    wc = true
                    weapon_parts_Manager_RE2(AWF.AWF_settings.RE2_Weapons, AWF_settings.RE2_Gunsmith)
                    update_weapon_parts_Manager_RE7(AWF.AWF_settings.RE2_Weapons, AWF_settings.RE2_Gunsmith)
                end

                imgui.same_line()
                imgui.button(" | ")

                

                imgui.same_line()
                func.colored_TextSwitch("Total Parts Count:", #AWF_settings.RE2_Gunsmith[weaponData.ID].Parts, #AWF_settings.RE2_Gunsmith[weaponData.ID].Parts, 0xFF00FF00, #AWF_settings.RE2_Gunsmith[weaponData.ID].Parts, 0xFF0000FF)
                                
                if imgui.button("Save Preset") then
                    json.dump_file("AWF/AWF_Gunsmith/".. weaponData.Name .. "/" .. weaponData.Name .. " NEW".. ".json", AWF_settings.RE2_Gunsmith[weaponData.ID])
                    log.info("AWF Custom " .. weaponData.Name ..  " Params Saved")
                end
                func.tooltip("Save the current preset of the " .. weaponData.Name .. " to a .json file found in [RESIDENT EVIL 2  BIOHAZARD RE2/reframework/data/AWF/AWF_Gunsmith/".. weaponData.Name .. "]")

                imgui.same_line()
                changed, AWF_settings.RE2_Gunsmith[weaponData.ID].current_preset_indx = imgui.combo("Preset", AWF_settings.RE2_Gunsmith[weaponData.ID].current_preset_indx or 1, AWF_settings.RE2_Gunsmith[weaponData.ID].Presets); wc = wc or changed
                func.tooltip("Select a file from the dropdown menu to load the weapon variant from that file.")
                if changed then
                    local selected_preset = AWF_settings.RE2_Gunsmith[weaponData.ID].Presets[AWF_settings.RE2_Gunsmith[weaponData.ID].current_preset_indx]
                    local json_filepath = [[AWF\\AWF_Gunsmith\\]] .. weaponData.Name .. [[\\]] .. selected_preset .. [[.json]]
                    local temp_parts = json.load_file(json_filepath)
                    
                    temp_parts.Presets = nil
                    temp_parts.current_preset_indx = nil

                    for key, value in pairs(temp_parts) do
                        AWF_settings.RE2_Gunsmith[weaponData.ID][key] = value
                    end
                end
                
                imgui.spacing()

                for i, partName in ipairs(AWF_settings.RE2_Gunsmith[weaponData.ID].Parts) do
                    changed, AWF_settings.RE2_Gunsmith[weaponData.ID].Enabled[i] = imgui.checkbox(partName, AWF_settings.RE2_Gunsmith[weaponData.ID].Enabled[i]); wc = wc or changed
                end

                if changed or wc then
                    AWF_settings.RE2_Gunsmith[weaponData.ID].isUpdated = true
                end
                imgui.end_rect(2)
                imgui.tree_pop()
            end
            imgui.separator()
        end
        imgui.end_rect(1)
        imgui.end_window()
    end
end

re.on_draw_ui(function()
    if reframework.get_game_name() == "re7" then
        if imgui.tree_node("AWF - Gunsmith") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_settings = func.recurse_def_settings({}, AWFWeapons)
                weapon_parts_Manager_RE7(AWF.AWF_settings.RE7_Weapons, AWF_settings.RE7_Gunsmith)
                cache_WPM_json_files_RE7(AWF.AWF_settings.RE7_Weapons)
            end
            func.tooltip("Reset every weapon part.")
            
            changed, AWF_WPM_settings.show_AWF_Gunsmith_editor = imgui.checkbox("Open AWF Gunsmith Editor", AWF_WPM_settings.show_AWF_Gunsmith_editor); wc = wc or changed
            func.tooltip("Show/Hide the Gunsmith Editor.")

            if AWF_WPM_settings.show_AWF_Gunsmith_editor then
                draw_AWF_Gunsmith_GUI_RE7(AWF.AWF_settings.RE7_Weapon_Order)
            end

            if AWF_WPM_settings.show_AWF_Gunsmith_editor and (changed or wc) then
                dump_weapon_parts_json_RE7(AWF.AWF_settings.RE7_Weapons)
                json.dump_file("AWF/AWF_Gunsmith/AWF_Gunsmith_Settings.json", AWF_settings)
            end

            ui.button_n_colored_txt("Current Version:", "v1.4.45 | 01/25/2024", 0xFF00FF00)
            imgui.same_line()
            imgui.text("| by SilverEzredes")

            imgui.end_rect(1)
            imgui.tree_pop()
        end
    end

    if reframework.get_game_name() == "re2" then
        if imgui.tree_node("AWF - Gunsmith") then
            imgui.begin_rect()
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_settings = func.recurse_def_settings({}, AWFWeapons)
                weapon_parts_Manager_RE7(AWF.AWF_settings.RE2_Weapons, AWF_settings.RE2_Gunsmith)
                cache_WPM_json_files_RE7(AWF.AWF_settings.RE2_Weapons)
            end
            func.tooltip("Reset every weapon part.")
            
            changed, AWF_WPM_settings.show_AWF_Gunsmith_editor = imgui.checkbox("Open AWF Gunsmith Editor", AWF_WPM_settings.show_AWF_Gunsmith_editor); wc = wc or changed
            func.tooltip("Show/Hide the AWF Gunsmith Editor.")

            if AWF_WPM_settings.show_AWF_Gunsmith_editor then
                draw_AWF_Gunsmith_GUI_RE2(AWF.AWF_settings.RE2_Weapon_Order)
            end

            if AWF_WPM_settings.show_AWF_Gunsmith_editor and (changed or wc) then
                dump_weapon_parts_json_RE2(AWF.AWF_settings.RE2_Weapons)
                json.dump_file("AWF/AWF_Gunsmith/AWF_Gunsmith_Settings.json", AWF_settings)
            end

            ui.button_n_colored_txt("Current Version:", "v1.4.50 | 01/27/2024", 0xFF00FF00)
            imgui.same_line()
            imgui.text("| by SilverEzredes")

            imgui.end_rect(1)
            imgui.tree_pop()
        end
    end
end)

AWFGS = {
    AWFGS_Settings = AWF_settings,
    weapon_parts_Manager_RE7 = weapon_parts_Manager_RE7,
    dump_weapon_parts_json_RE7 = dump_weapon_parts_json_RE7,
    cache_WPM_json_files_RE7 = cache_WPM_json_files_RE7,
    update_weapon_parts_Manager_RE7 = update_weapon_parts_Manager_RE7,
    weapon_parts_Manager_RE2 = weapon_parts_Manager_RE2,
    dump_weapon_parts_json_RE2 = dump_weapon_parts_json_RE2,
    cache_WPM_json_files_RE2 = cache_WPM_json_files_RE2,
    update_weapon_parts_Manager_RE2 = update_weapon_parts_Manager_RE2,
}
return AWFGS