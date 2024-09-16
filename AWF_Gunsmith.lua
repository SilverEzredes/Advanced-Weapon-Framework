--/////////////////////////////////////--
local modName = "Advanced Weapon Framework: Gunsmith"

local modAuthor = "SilverEzredes"
local modUpdated = "09/12/2024"
local modVersion = "v3.4.00"
local modCredits = "praydog; alphaZomega"

--/////////////////////////////////////--
local AWF = require("AWFCore")
local hk = require("Hotkeys/Hotkeys")
local func = require("_SharedCore/Functions")
local ui = require("_SharedCore/Imgui")

local scene = func.get_CurrentScene()
local changed = false
local wc = false
local last_time = 0.0
local tick_interval = 1.0 / 2.5
local AWFGS_MaterialParamUpdateHolder = {}
local AWFGS_MaterialParamDefaultsHolder = {}
local AWFGS_MaterialEditorParamHolder = {}
local AWFGS_MaterialEditorSubParamFloat4Holder = {}
local isLoadingScreenBypass = false
local isDefaultsDumped = false
local presetName = "[Enter Preset Name Here]"
local searchQuery = ""

local AWFGS_default_settings = {
    show_AWF_Gunsmith_editor = false,
    isDebug = true,
    showMeshName = true,
    showMaterialCount = true,
    showPresetPath = false,
    showMeshPath = true,
    showMDFPath = true,
    showConsole = true,
}

local AWFWeapons = {
    RE2_Gunsmith = {},
    RE3_Gunsmith = {},
    RE4_Gunsmith = {},
    RE7_Gunsmith = {},
    RE8_Gunsmith = {},
}
AWFWeapons.RE2_Gunsmith = require("AWFCore/AWFGS/RE2R_MaterialData")
AWFWeapons.RE3_Gunsmith = require("AWFCore/AWFGS/RE3R_MaterialData")
AWFWeapons.RE4_Gunsmith = require("AWFCore/AWFGS/RE4R_MaterialData")
AWFWeapons.RE7_Gunsmith = require("AWFCore/AWFGS/RE7_MaterialData")
AWFWeapons.RE8_Gunsmith = require("AWFCore/AWFGS/RE8_MaterialData")
AWFGS_RE4Comp = require("AWFCore/AWFGS/Compendium/RE4R_MaterialCompendium")

local AWFGS_settings = hk.merge_tables({}, AWFGS_default_settings) and hk.recurse_def_settings(json.load_file("AWF/AWF_Gunsmith/AWFGS_ToolSettings.json") or {}, AWFGS_default_settings)
local AWF_settings = hk.merge_tables({}, AWFWeapons) and hk.recurse_def_settings(json.load_file("AWF/AWF_Gunsmith/AWF_Gunsmith_Settings.json") or {}, AWFWeapons)

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: RE2R
local playerContext_RE2 = nil
local isPlayerInScene_RE2 = false
local consoleLoadFail_RE2 = ""
AWFGS_inventoryUpdater_RE2 = false

local function get_playerContext_RE2()
    local playerManager
    playerManager = sdk.get_managed_singleton(sdk.game_namespace("PlayerManager"))
    playerContext_RE2 = playerManager and playerManager:call("get_CurrentPlayer")
    return playerContext_RE2
end
local function check_if_playerIsInScene_RE2()
    get_playerContext_RE2()

    if playerContext_RE2 ~= nil then
        isPlayerInScene_RE2 = true
    elseif playerContext_RE2 == nil or {} then
        isPlayerInScene_RE2 = false
    end
end
local function get_MaterialParams_RE2(weaponData, WPM_table)
    for _, weapon in pairs(weaponData) do
        if WPM_table[weapon.ID] then
            local Weapon_GameObject_RE2 = scene:call("findGameObject(System.String)", weapon.ID)
            
            WPM_table[weapon.ID].Enabled = {}
            WPM_table[weapon.ID].Parts = {}
            WPM_table[weapon.ID].Materials = {}

            if Weapon_GameObject_RE2 and Weapon_GameObject_RE2:get_Valid() then
                WPM_table[weapon.ID].isInScene = true
                if AWFGS_settings.isDebug then
                    log.info("[AWF-GS] [ " .. weapon.ID .. " is in the scene AWF-GS data updated]")
                end
                local render_mesh = Weapon_GameObject_RE2:call("getComponent(System.Type)", sdk.typeof("via.render.Mesh"))
                
                if render_mesh then
                    local MatCount = render_mesh:call("get_MaterialNum")
                    local nativesMesh = render_mesh:getMesh()
                    local nativesMDF = render_mesh:get_Material()
                    nativesMesh = nativesMesh and nativesMesh:call("ToString()")
                    nativesMDF = nativesMDF and nativesMDF:call("ToString()")
                    if nativesMesh then
                        local meshPath = string.gsub(nativesMesh, "Resource%[", "natives/stm/")
                        local formattedMeshPath = string.gsub(meshPath, ".mesh%]", ".mesh")
                        WPM_table[weapon.ID].MeshPath = formattedMeshPath
                        if AWFGS_settings.isDebug then
                            log.info("[AWF-GS] [" .. formattedMeshPath .. "]")
                        end
                    end
                    nativesMesh = nativesMesh and nativesMesh:match("([^/]-)%.mesh]$")
                    if nativesMesh then
                        WPM_table[weapon.ID].MeshName = nativesMesh
                    end
                    if nativesMDF then
                        local mdfPath = string.gsub(nativesMDF, "Resource%[", "natives/stm/")
                        local formattedMDFPath = string.gsub(mdfPath, ".mdf2%]", ".mdf2")
                        WPM_table[weapon.ID].MDFPath = formattedMDFPath
                        if AWFGS_settings.isDebug then
                            log.info("[AWG-GS] [" .. formattedMDFPath .. "]")
                        end
                    end

                    for MatName, _ in pairs(WPM_table[weapon.ID].Materials) do
                        local found = false
                        for i = 0, MatCount - 1 do
                            if MatName == render_mesh:call("getMaterialName", i) then
                                found = true
                                break
                            end
                        end
                        if not found then
                            WPM_table[weapon.ID].Materials[MatName] = nil
                        end
                    end
    
                    local newPartNames = {}
                    for i = 0, MatCount - 1 do
                        local MatName = render_mesh:call("getMaterialName", i)
                        if MatName then
                            table.insert(newPartNames, MatName)
                        end
                    end
    
                    for PartIndex, PartName in ipairs(WPM_table[weapon.ID].Parts) do
                        if not func.table_contains(newPartNames, PartName) then
                            table.remove(WPM_table[weapon.ID].Parts, PartIndex)
                            table.remove(WPM_table[weapon.ID].Enabled, PartIndex)
                        end
                    end

                    if MatCount then
                        for i = 0, MatCount - 1 do
                            local MatName = render_mesh:call("getMaterialName", i)
                            local MatParam = render_mesh:call("getMaterialVariableNum", i)
                            local EnabledMat = render_mesh:call("getMaterialsEnableIndices", i)

                            if MatName then
                                --Main Table
                                if not WPM_table[weapon.ID].Materials[MatName] then
                                    WPM_table[weapon.ID].Materials[MatName] = {}
                                end
                                
                                if not func.table_contains(WPM_table[weapon.ID].Parts, MatName) then
                                    table.insert(WPM_table[weapon.ID].Parts, MatName)
                                end
                                
                                --Runtime Table
                                if not AWFGS_MaterialParamUpdateHolder[weapon.ID] then
                                    AWFGS_MaterialParamUpdateHolder[weapon.ID] = {}
                                end
                                if not func.table_contains(AWFGS_MaterialParamUpdateHolder, weapon.ID) then
                                    table.insert(AWFGS_MaterialParamUpdateHolder, weapon.ID)
                                end
                                if not AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName] then
                                    AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName] = {}
                                end
                                if not func.table_contains(AWFGS_MaterialParamUpdateHolder[weapon.ID], MatName) then
                                    table.insert(AWFGS_MaterialParamUpdateHolder[weapon.ID], MatName)
                                end

                                if EnabledMat then
                                    if WPM_table[weapon.ID].current_preset_indx >= 1 or nil then
                                        for k, _ in ipairs(WPM_table[weapon.ID].Parts) do
                                            WPM_table[weapon.ID].Enabled[k] = true
                                        end
                                    end
                                end

                                if MatParam then
                                    for j = 0, MatParam - 1 do
                                        local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                        local MatType = render_mesh:call("getMaterialVariableType", i, j)

                                        if MatParamNames then
                                            --Main Table
                                            if not WPM_table[weapon.ID].Materials[MatName][MatParamNames] then
                                                WPM_table[weapon.ID].Materials[MatName][MatParamNames] = {}
                                            end
                                            --Runtime Table
                                            if not AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName][MatParamNames] then
                                                AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName][MatParamNames] = {}
                                            end
                                            if not func.table_contains(AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName], MatParamNames) then
                                                table.insert(AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName], MatParamNames)
                                            end
                                            AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName][MatParamNames].isMaterialParamUpdated = false

                                            if MatType then
                                                if MatType == 1 then
                                                    local MatType_Float = render_mesh:call("getMaterialFloat", i, j)
                                                    if not func.table_contains(WPM_table[weapon.ID].Materials[MatName][MatParamNames], MatType_Float) then
                                                        table.insert(WPM_table[weapon.ID].Materials[MatName][MatParamNames], MatType_Float)
                                                    end
                                                elseif MatType == 4 then
                                                    local MatType_Float4 = render_mesh:call("getMaterialFloat4", i, j)
                                                    local MatType_Float4_New = {MatType_Float4.x, MatType_Float4.y, MatType_Float4.z, MatType_Float4.w}
                                                    local contains = false
                                                    for _, value in ipairs(WPM_table[weapon.ID].Materials[MatName][MatParamNames]) do
                                                        if #value == 4 then
                                                            value[1] = MatType_Float4_New[1]
                                                            value[2] = MatType_Float4_New[2]
                                                            value[3] = MatType_Float4_New[3]
                                                            value[4] = MatType_Float4_New[4]
                                                            contains = true
                                                            break
                                                        end
                                                    end
                                                
                                                    if not contains then
                                                        table.insert(WPM_table[weapon.ID].Materials[MatName][MatParamNames], MatType_Float4_New)
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
            elseif (not Weapon_GameObject_RE2) or (not Weapon_GameObject_RE2:get_Valid()) then
                WPM_table[weapon.ID].isInScene = false
            end
        end
    end
    json.dump_file("AWF/AWF_Gunsmith/_Holders/AWFGS_MaterialParamUpdateHolder.json", WPM_table)
    json.dump_file("AWF/AWF_Gunsmith/_Holders/AWFGS_MaterialParamDefaultsHolder.json", AWFGS_MaterialParamUpdateHolder)
end
local function dump_DefaultMaterialParam_json_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParts = AWF_settings.RE2_Gunsmith[weapon.ID]

        if weaponParts and weaponParts.isInScene and not isDefaultsDumped then
            json.dump_file("AWF/AWF_Gunsmith/" .. weapon.Name .. "/" .. weapon.Name .. " Default.json", weaponParts)
            
            if AWFGS_settings.isDebug then
                log.info("[AWF-GS] [" .. weapon.Name .. " Default Preset Updated]")
            end
        end
    end
end
local function dump_CurrentMaterialParam_json_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParts = AWF_settings.RE2_Gunsmith[weapon.ID]

        if weaponParts then
            json.dump_file("AWF/AWF_Gunsmith/" .. weapon.Name .. "/" .. weapon.Name .. " Current Preset.json", weaponParts)
            
            if AWFGS_settings.isDebug then
                log.info("[AWF-GS] [" .. weapon.Name .. " Current Preset Updated]")
            end
        end
    end
end
local function cache_AWFGS_json_files_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWF_settings.RE2_Gunsmith[weapon.ID]
        
        if weaponParams then
            local json_names = weaponParams.Presets or {}
            local json_filepaths = fs.glob([[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\.*.json]])
            
            if json_filepaths then
                local defaultName = weapon.Name .. " Default"
                local defaultNameInserted = false

                for i, filepath in ipairs(json_filepaths) do
                    local name = filepath:match("^.+\\(.+)%.")
                    local nameExists = false
                    
                    for j, existingName in ipairs(json_names) do
                        if existingName == name then
                            nameExists = true
                            break
                        end
                    end
                    
                    if not nameExists then
                        if name == defaultName then
                            table.insert(json_names, 1, name)
                            defaultNameInserted = true
                        else
                            table.insert(json_names, name)
                        end

                        if AWFGS_settings.isDebug then
                            log.info("[AWF-GS] [Loaded " .. filepath .. " for "  .. weapon.Name .. "]")
                        end
                    end
                end
                
                if not defaultNameInserted then
                    for i, name in ipairs(json_names) do
                        if name == defaultName then
                            table.remove(json_names, i)
                            table.insert(json_names, 1, name)
                            break
                        end
                    end
                end

                for i = #json_names, 1, -1 do
                    local nameExists = false
                    local name = json_names[i]
                    for _, filepath in ipairs(json_filepaths) do
                        if filepath:match("^.+\\(.+)%.") == name then
                            nameExists = true
                            break
                        end
                    end
                    if not nameExists then
                        if AWFGS_settings.isDebug then
                            log.info("[AWF-GS] [Removed " .. name .. " from " .. weapon.Name .. "]")
                        end
                        table.remove(json_names, i)
                    end
                end
            else
                if AWFGS_settings.isDebug then
                    log.info("[AWF-GS] [No AWF-GS JSON files found.]")
                end
            end
        end
    end
end
local function update_MaterialParams_RE2(weaponData, WPM_table)
    for _, weapon in pairs(weaponData) do
        if WPM_table[weapon.ID] and WPM_table[weapon.ID].isUpdated then
            local Weapon_GameObject_RE2 = scene:call("findGameObject(System.String)", weapon.ID)
            local Weapon_Inventory_GameObject_RE2 = scene:call("findGameObject(System.String)", string.upper(weapon.ID))

            if Weapon_GameObject_RE2 and Weapon_GameObject_RE2:get_Valid() then
                local render_mesh = Weapon_GameObject_RE2:call("getComponent(System.Type)", sdk.typeof("via.render.Mesh"))
                
                if render_mesh then
                    local MatCount = render_mesh:call("get_MaterialNum")
                    
                    if MatCount then
                        for i = 0, MatCount - 1 do
                            local MatName = render_mesh:call("getMaterialName", i)
                            local MatParam = render_mesh:call("getMaterialVariableNum", i)
                            local EnabledMat = render_mesh:call("getMaterialsEnableIndices", i)
                            
                            if MatName then
                                if MatParam then
                                    for k = 0, MatParam - 1 do
                                        local MatParamNames = render_mesh:call("getMaterialVariableName", i, k)
                                        local MatType = render_mesh:call("getMaterialVariableType", i, k)
                                        if MatParamNames then
                                            if MatType then
                                                if MatType == 1 then
                                                    render_mesh:call("setMaterialFloat", i, k,WPM_table[weapon.ID].Materials[MatName][MatParamNames][1])
                                                end
                                                if MatType == 4 then
                                                    local vec4 = WPM_table[weapon.ID].Materials[MatName][MatParamNames][1]
                                                    render_mesh:call("setMaterialFloat4", i, k, Vector4f.new(vec4[1], vec4[2], vec4[3], vec4[4]))
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if EnabledMat then
                                for j = 0, EnabledMat do
                                    render_mesh:call("setMaterialsEnable", j, WPM_table[weapon.ID].Enabled[j + 1])
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
                                    local MatName = render_mesh:call("getMaterialName", i)
                                    local MatParam = render_mesh:call("getMaterialVariableNum", i)
                                    local EnabledMat = render_mesh:call("getMaterialsEnableIndices", i)
                                    
                                    if MatName then
                                        if MatParam then
                                            for k = 0, MatParam - 1 do
                                                local MatParamNames = render_mesh:call("getMaterialVariableName", i, k)
                                                local MatType = render_mesh:call("getMaterialVariableType", i, k)
                                                if MatParamNames then
                                                    if MatType then
                                                        if MatType == 1 then
                                                            render_mesh:call("setMaterialFloat", i, k,WPM_table[weapon.ID].Materials[MatName][MatParamNames][1])
                                                        end
                                                        if MatType == 4 then
                                                            local vec4 = WPM_table[weapon.ID].Materials[MatName][MatParamNames][1]
                                                            render_mesh:call("setMaterialFloat4", i, k, Vector4f.new(vec4[1], vec4[2], vec4[3], vec4[4]))
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
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
            end
        end
        AWF_settings.RE2_Gunsmith[weapon.ID].isUpdated = true
    end
end
local function get_MasterMaterialData_RE2(weaponData)
    check_if_playerIsInScene_RE2()

    if isPlayerInScene_RE2 then
        --Initial loading screen check
        if NowLoading and not isDefaultsDumped then
            get_MaterialParams_RE2(AWF.AWF_settings.RE2.Weapons, AWF_settings.RE2_Gunsmith)
            dump_DefaultMaterialParam_json_RE2(AWF.AWF_settings.RE2.Weapons)
            cache_AWFGS_json_files_RE2(AWF.AWF_settings.RE2.Weapons)
            AWFGS_MaterialParamDefaultsHolder = func.deepcopy(AWF_settings)

            for _, weapon in pairs(weaponData) do
                AWF_settings.RE2_Gunsmith[weapon.ID].isUpdated = true

                local selected_preset = AWF_settings.RE2_Gunsmith[weapon.ID].Presets[AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx]
                if selected_preset ~= weapon.Name .. " Default" and selected_preset ~= nil then
                    wc = true
                    local json_filepath = [[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                    local temp_parts = json.load_file(json_filepath)

                    if temp_parts.Parts ~= nil then
                        if AWFGS_settings.isDebug then
                            log.info("[AWF-GS] [Auto Preset Loader: " .. weapon.Name .. " --- " .. #temp_parts.Parts .. " ]")

                            for _, part in ipairs(temp_parts.Parts) do
                                log.info("[AWF-GS] [Preset Part Name: " .. part .. " ]")
                            end
                            for _, part in ipairs(AWF_settings.RE2_Gunsmith[weapon.ID].Parts) do
                                log.info("[AWF-GS] Original Part Name: " .. part .. " ]")
                            end
                        end
                        
                        local partsMatch = #temp_parts.Parts == #AWF_settings.RE2_Gunsmith[weapon.ID].Parts

                        if partsMatch then
                            for _, part in ipairs(temp_parts.Parts) do
                                local found = false
                                for _, ogPart in ipairs(AWF_settings.RE2_Gunsmith[weapon.ID].Parts) do
                                    if part == ogPart then
                                        found = true
                                        break
                                    end
                                end
                
                                if not found then
                                    partsMatch = false
                                    break
                                end
                            end
                        end
                
                        if partsMatch then
                            temp_parts.Presets = nil
                            temp_parts.current_preset_indx = nil

                            for key, value in pairs(temp_parts) do
                                AWF_settings.RE2_Gunsmith[weapon.ID][key] = value
                            end
                        else
                            log.info("[AWF-GS] [Parts do not match, skipping the update.]")
                            AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx = 1
                        end
                    end
                elseif selected_preset == nil or {} then
                    AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx = 1
                end
                update_MaterialParams_RE2(AWF.AWF_settings.RE2.Weapons, AWF_settings.RE2_Gunsmith)
            end
            
            log.info("[AWF-GS] [Master Data defaults dumped.]")
            isDefaultsDumped = true
        end
        --Subsequent loading screen checks
        if NowLoading and isDefaultsDumped then
            get_MaterialParams_RE2(AWF.AWF_settings.RE2.Weapons, AWF_settings.RE2_Gunsmith)
            cache_AWFGS_json_files_RE2(AWF.AWF_settings.RE2.Weapons)

            for _, weapon in pairs(weaponData) do
                AWF_settings.RE2_Gunsmith[weapon.ID].isUpdated = true

                local selected_preset = AWF_settings.RE2_Gunsmith[weapon.ID].Presets[AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx]
                if selected_preset ~= weapon.Name .. " Default" and selected_preset ~= nil then
                    wc = true
                    local json_filepath = [[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                    local temp_parts = json.load_file(json_filepath)
            
                    if temp_parts.Parts ~= nil then
                        if AWFGS_settings.isDebug then
                            log.info("[AWF-GS] [Auto Preset Loader: " .. weapon.Name .. " --- " .. #temp_parts.Parts .. " ]")

                            for _, part in ipairs(temp_parts.Parts) do
                                log.info("[AWF-GS] [Preset Part Name: " .. part .. " ]")
                            end
                            for _, part in ipairs(AWF_settings.RE2_Gunsmith[weapon.ID].Parts) do
                                log.info("[AWF-GS] Original Part Name: " .. part .. " ]")
                            end
                        end
                        
                        local partsMatch = #temp_parts.Parts == #AWF_settings.RE2_Gunsmith[weapon.ID].Parts

                        if partsMatch then
                            for _, part in ipairs(temp_parts.Parts) do
                                local found = false
                                for _, ogPart in ipairs(AWF_settings.RE2_Gunsmith[weapon.ID].Parts) do
                                    if part == ogPart then
                                        found = true
                                        break
                                    end
                                end
                
                                if not found then
                                    partsMatch = false
                                    break
                                end
                            end
                        end
                
                        if partsMatch then
                            temp_parts.Presets = nil
                            temp_parts.current_preset_indx = nil

                            for key, value in pairs(temp_parts) do
                                AWF_settings.RE2_Gunsmith[weapon.ID][key] = value
                            end
                        else
                            log.info("[AWF-GS] [Parts do not match, skipping the update.]")
                            AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx = 1
                        end
                    end
                elseif selected_preset == nil or {} then
                    AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx = 1
                end
                update_MaterialParams_RE2(AWF.AWF_settings.RE2.Weapons, AWF_settings.RE2_Gunsmith)
            end
        end
        --Update data on opening the inventory
        if AWF_Inventory_Found and AWFGS_inventoryUpdater_RE2 then
            get_MaterialParams_RE2(AWF.AWF_settings.RE2.Weapons, AWF_settings.RE2_Gunsmith)
            dump_CurrentMaterialParam_json_RE2(AWF.AWF_settings.RE2.Weapons)
            AWFGS_MaterialParamDefaultsHolder = func.deepcopy(AWF_settings)
            update_MaterialParams_RE2(AWF.AWF_settings.RE2.Weapons, AWF_settings.RE2_Gunsmith)
            AWFGS_inventoryUpdater_RE2 = false
        end
    end
end
local function draw_AWFGSEditor_GUI_RE2(weaponOrder)
    if imgui.begin_window("Advanced Weapon Framework: Gunsmith Editor") then
        imgui.begin_rect()
        local textColor = {0,255,255,255}
        imgui.text_colored("  [ " .. ui.draw_line("=", 50) ..  " | " .. ui.draw_line("=", 50) .. " ] ", func.convert_rgba_to_AGBR(textColor))
        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF.AWF_settings.RE2.Weapons[weaponName]
            
            if weapon then
                if imgui.tree_node(weapon.Name) then
                    imgui.begin_rect()
                    imgui.spacing()
                    
                    imgui.text_colored("  " .. ui.draw_line("=", 100) .."  ", func.convert_rgba_to_AGBR(textColor))
                    imgui.indent(10)

                    if imgui.button("Update Preset List") then
                        wc = true
                        cache_AWFGS_json_files_RE2(AWF.AWF_settings.RE2.Weapons)
                    end

                    if AWFGS_settings.showMeshName then
                        imgui.same_line()
                        imgui.text("[ Mesh Name:")
                        imgui.same_line()
                        imgui.text_colored(AWF_settings.RE2_Gunsmith[weapon.ID].MeshName, 0xFF00BBFF)
                        imgui.same_line()
                        imgui.text("]")
                    end
    
                    if AWFGS_settings.showMaterialCount then
                        imgui.same_line()
                        imgui.text("[ Material Count:")
                        imgui.same_line()
                        imgui.text_colored(#AWF_settings.RE2_Gunsmith[weapon.ID].Parts, 0xFFDBFF00)
                        imgui.same_line()
                        imgui.text("]")
                    end

                    changed, AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx = imgui.combo("Preset", AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx or 1, AWF_settings.RE2_Gunsmith[weapon.ID].Presets); wc = wc or changed
                    func.tooltip("Select a file from the dropdown menu to load the weapon variant from that file.")
                    if changed then
                        local selected_preset = AWF_settings.RE2_Gunsmith[weapon.ID].Presets[AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx]
                        local json_filepath = [[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                        local temp_parts = json.load_file(json_filepath)
                        
                        if temp_parts.Parts ~= nil then
                            if AWFGS_settings.isDebug then
                                log.info("[AWF-GS] [Preset Loader: " .. weapon.Name .. " --- " .. #temp_parts.Parts .. " ]")
        
                                for _, part in ipairs(temp_parts.Parts) do
                                    log.info("[AWF-GS] [Preset Part Name: " .. part .. " ]")
                                end
                                for _, part in ipairs(AWF_settings.RE2_Gunsmith[weapon.ID].Parts) do
                                    log.info("[AWF-GS] Original Part Name: " .. part .. " ]")
                                end
                            end
                            
                            local partsMatch = #temp_parts.Parts == #AWF_settings.RE2_Gunsmith[weapon.ID].Parts
        
                            if partsMatch then
                                for _, part in ipairs(temp_parts.Parts) do
                                    local found = false
                                    for _, ogPart in ipairs(AWF_settings.RE2_Gunsmith[weapon.ID].Parts) do
                                        if part == ogPart then
                                            found = true
                                            break
                                        end
                                    end
                    
                                    if not found then
                                        partsMatch = false
                                        break
                                    end
                                end
                            end
                    
                            if partsMatch then
                                temp_parts.Presets = nil
                                temp_parts.current_preset_indx = nil
        
                                for key, value in pairs(temp_parts) do
                                    AWF_settings.RE2_Gunsmith[weapon.ID][key] = value
                                end
                            else
                                log.info("[AWF-GS] [" .. weapon.Name .. " Parts do not match, skipping the update.]")
                                AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx = 1
                                consoleLoadFail_RE2 = "[ERROR]\nCouldn't load the data from " .. selected_preset .. " for " .. weapon.Name .. ".\nThe material count of the preset doesn't match the material count of the " .. weapon.Name .. "."
                            end
                        end
                        update_MaterialParams_RE2(AWF.AWF_settings.RE2.Weapons, AWF_settings.RE2_Gunsmith)
                    end

                    imgui.push_id(_)
                    changed, presetName = imgui.input_text("", presetName); wc = wc or changed
                    imgui.pop_id()
                    imgui.same_line()
                    if imgui.button("Save Preset") then
                        json.dump_file("AWF/AWF_Gunsmith/".. weapon.Name .. "/" .. presetName .. ".json", AWF_settings.RE2_Gunsmith[weapon.ID])
                        log.info("[AWF-GS] [Preset with the name: " .. presetName .. " saved for " .. weapon.Name .. ".]")
                        cache_AWFGS_json_files_RE2(AWF.AWF_settings.RE2.Weapons)
                    end
                    func.tooltip("Save the current parameters of the " .. weapon.Name .. " to '[PresetName].json' found in [RESIDENT EVIL 2  BIOHAZARD RE2/reframework/data/AWF/AWF_Gunsmith/".. weapon.Name .. "]")

                    imgui.spacing()

                    if AWFGS_settings.showPresetPath and #AWF_settings.RE2_Gunsmith[weapon.ID].Parts > 0 then
                        imgui.input_text("Preset Path", "RESIDENT EVIL 2  BIOHAZARD RE2/reframework/data/AWF/AWF_Gunsmith/".. weapon.Name .. "/" .. presetName .. ".json")
                    end
    
                    if AWFGS_settings.showMeshPath then
                        imgui.push_id(AWF_settings.RE2_Gunsmith[weapon.ID].MeshPath)
                        imgui.input_text("Mesh Path", AWF_settings.RE2_Gunsmith[weapon.ID].MeshPath)
                        imgui.pop_id()
                    end
    
                    if AWFGS_settings.showMDFPath then
                        imgui.push_id(AWF_settings.RE2_Gunsmith[weapon.ID].MDFPath)
                        imgui.input_text("MDF Path", AWF_settings.RE2_Gunsmith[weapon.ID].MDFPath)
                        imgui.pop_id()
                    end

                    if imgui.tree_node("Mesh Editor") then
                        imgui.spacing()
                        imgui.text_colored(ui.draw_line("=", 78), func.convert_rgba_to_AGBR(255,255,255,255))
                        imgui.indent(15)

                        for i, partName in ipairs(AWF_settings.RE2_Gunsmith[weapon.ID].Parts) do
                            local enabledMeshPart =  AWF_settings.RE2_Gunsmith[weapon.ID].Enabled[i]
                            local defaultEnabledMeshPart = AWFGS_MaterialParamDefaultsHolder.RE2_Gunsmith[weapon.ID].Enabled[i]
            
                            if enabledMeshPart == defaultEnabledMeshPart or enabledMeshPart ~= defaultEnabledMeshPart then
                                changed, enabledMeshPart = imgui.checkbox(partName, enabledMeshPart); wc = wc or changed
                                AWF_settings.RE2_Gunsmith[weapon.ID].Enabled[i] = enabledMeshPart
                            end
                            if enabledMeshPart ~= defaultEnabledMeshPart then
                                imgui.same_line()
                                imgui.text_colored("*", 0xFF00BBFF)
                            end
                        end

                        imgui.indent(-15)
                        imgui.text_colored(ui.draw_line("=", 78), func.convert_rgba_to_AGBR(255,255,255,255))
                        imgui.tree_pop()
                    end
                    
                    if imgui.tree_node("Material Editor") then
                        imgui.spacing()
                        imgui.text_colored(ui.draw_line("=", 78), 0xFFDBFF00)
                        changed, searchQuery = imgui.input_text("Search", searchQuery); wc = wc or changed
                        imgui.indent(5)

                        for matName, matData in func.orderedPairs(AWF_settings.RE2_Gunsmith[weapon.ID].Materials) do
                            imgui.spacing()
                        
                            if imgui.tree_node(matName) then
                                imgui.push_id(matName)
                                imgui.spacing()
                                if imgui.begin_popup_context_item() then
                                    if imgui.menu_item("Reset") then
                                        for paramName, _ in pairs(matData) do
                                            AWF_settings.RE2_Gunsmith[weapon.ID].Materials[matName][paramName][1] = AWFGS_MaterialParamDefaultsHolder.RE2_Gunsmith[weapon.ID].Materials[matName][paramName][1]
                                            wc = true
                                        end
                                        changed = true
                                    end
                                    if imgui.menu_item("Copy") then
                                        AWFGS_MaterialEditorParamHolder = func.deepcopy(AWF_settings.RE2_Gunsmith[weapon.ID].Materials[matName])
                                        wc = true
                                    end
                                    if imgui.menu_item("Paste") then
                                        local copiedParams = AWFGS_MaterialEditorParamHolder
                                        local targetParams = AWF_settings.RE2_Gunsmith[weapon.ID].Materials[matName]
                                        
                                        for paramName, paramValue in pairs(copiedParams) do
                                            if targetParams[paramName] ~= nil then
                                                targetParams[paramName] = func.deepcopy(paramValue)
                                                wc = true
                                            end
                                        end
                                    end
                                    imgui.end_popup()
                                end
                                for paramName, paramValue in func.orderedPairs(matData) do
                                    local originalData = AWFGS_MaterialParamDefaultsHolder.RE2_Gunsmith[weapon.ID].Materials[matName][paramName]
    
                                    if searchQuery == "" then
                                        imgui.spacing()
                                    end
                                    
                                    if string.find(paramName, searchQuery) then
                                        imgui.begin_rect()
                                    

                                        if func.compareTables(paramValue, originalData) then
                                            if imgui.button("[ " .. tostring(paramName) .. " ]") then
                                                paramValue[1] = AWFGS_MaterialParamDefaultsHolder.RE2_Gunsmith[weapon.ID].Materials[matName][paramName][1] or nil
                                                wc = true
                                            end
                                            -- if AWFGS_RE2Comp[paramName] then
                                            --     func.tooltip(AWFGS_RE2Comp[paramName])
                                            -- end
                                            if imgui.begin_popup_context_item() then
                                                if imgui.menu_item("Reset") then
                                                    paramValue[1] =AWFGS_MaterialParamDefaultsHolder.RE2_Gunsmith[weapon.ID].Materials[matName][paramName][1]
                                                    wc = true
                                                end
                                                if imgui.menu_item("Copy") then
                                                    MDFXL_MaterialEditorSubParamFloat4Holder = paramValue[1]
                                                    wc = true
                                                end
                                                if imgui.menu_item("Paste") then
                                                    paramValue[1] = MDFXL_MaterialEditorSubParamFloat4Holder
                                                    wc = true
                                                end
                                                imgui.end_popup()
                                            end
                                        elseif not func.compareTables(paramValue, originalData) then
                                            imgui.indent(35)
                                            if imgui.button("[ " .. tostring(paramName) .. " ]") then
                                                paramValue[1] = AWFGS_MaterialParamDefaultsHolder.RE2_Gunsmith[weapon.ID].Materials[matName][paramName][1]
                                                wc = true
                                            end
                                            if imgui.begin_popup_context_item() then
                                                if imgui.menu_item("Reset") then
                                                    paramValue[1] = AWFGS_MaterialParamDefaultsHolder.RE2_Gunsmith[weapon.ID].Materials[matName][paramName][1]
                                                    wc = true
                                                end
                                                if imgui.menu_item("Copy") then
                                                    MDFXL_MaterialEditorSubParamFloat4Holder = paramValue[1]
                                                    wc = true
                                                end
                                                if imgui.menu_item("Paste") then
                                                    paramValue[1] = MDFXL_MaterialEditorSubParamFloat4Holder
                                                    wc = true
                                                end
                                                imgui.end_popup()
                                            end
                                            imgui.same_line()
                                            imgui.text_colored("*", 0xFFDBFF00)
                                        end

                                        if type(paramValue) == "table" then
                                            if type(paramValue[1]) == "table" then
                                                for i, value in ipairs(paramValue) do
                                                    imgui.push_id(tostring(paramName))
                                                    local newcolor = Vector4f.new(value[1], value[2], value[3], value[4])
                                                    changed, newcolor = imgui.color_edit4("", newcolor, nil); wc = wc or changed
                                                    paramValue[i] = {newcolor.x, newcolor.y, newcolor.z, newcolor.w}
                                                    imgui.pop_id()
                                                end
                                            else
                                                imgui.push_id(tostring(paramName))
                                                changed, paramValue[1] = imgui.drag_float("", paramValue[1], 0.001, 0.0, 100.0); wc = wc or changed
                                                imgui.pop_id()
                                            end
                                            
                                            if changed or wc then
                                                AWFGS_MaterialParamUpdateHolder[weapon.ID][matName][paramName].isMaterialParamUpdated = true
                                            end
                                        end
                                        imgui.end_rect(3)
                                        imgui.spacing()
                                    end
                                end
                                imgui.pop_id()
                                imgui.spacing()
                                imgui.tree_pop()
                            end
                        end
                        imgui.indent(-5)
                        imgui.text_colored(ui.draw_line("=", 78), 0xFFDBFF00)
                        imgui.tree_pop()
                    end

                    if changed or wc then
                        AWF_settings.RE2_Gunsmith[weapon.ID].isUpdated = true
                    end
                    imgui.indent(-10)
                    imgui.text_colored("  " .. ui.draw_line("=", 100) .."  ", func.convert_rgba_to_AGBR(textColor))

                    imgui.end_rect(2)
                    imgui.tree_pop()
                end
                imgui.text_colored("  " .. ui.draw_line("-", 150) .."  ", func.convert_rgba_to_AGBR(textColor))
            end
        end
        imgui.text_colored("  [ " .. ui.draw_line("=", 50) ..  " | " .. ui.draw_line("=", 50) .. " ] ", func.convert_rgba_to_AGBR(textColor))
        imgui.end_rect(1)
        imgui.end_window()
    end
end
local function draw_AWFGSPreset_GUI_RE2(weaponOrder)
    imgui.spacing()
    local textColor = {255,255,255,255}
    if AWFGS_settings.showConsole then
        imgui.begin_rect()
        imgui.text("[AWF-GS Console] " .. ui.draw_line("-", 40))
        if imgui.button("Clear Log") then
            consoleLoadFail_RE2 = ""
        end
        imgui.indent(5)
        imgui.spacing()

        imgui.text_colored(consoleLoadFail_RE2, func.convert_rgba_to_AGBR(255, 0, 0, 255))

        imgui.spacing()
        imgui.indent(-5)
        imgui.text(ui.draw_line("-", 66))
        imgui.end_rect(1)
    end
    imgui.text_colored(" " .. ui.draw_line("=", 60) ..  " ", func.convert_rgba_to_AGBR(textColor))
    for _, weaponName in ipairs(weaponOrder) do
        local weapon = AWF.AWF_settings.RE2.Weapons[weaponName]
        
        if weapon then
            changed, AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx = imgui.combo(weapon.Name, AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx or 1, AWF_settings.RE2_Gunsmith[weapon.ID].Presets); wc = wc or changed
            if changed then
                local selected_preset = AWF_settings.RE2_Gunsmith[weapon.ID].Presets[AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx]
                local json_filepath = [[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                local temp_parts = json.load_file(json_filepath)
                
                if temp_parts.Parts ~= nil then
                    if AWFGS_settings.isDebug then
                        log.info("[AWF-GS] [Preset Loader: " .. weapon.Name .. " --- " .. #temp_parts.Parts .. " ]")

                        for _, part in ipairs(temp_parts.Parts) do
                            log.info("[AWF-GS] [Preset Part Name: " .. part .. " ]")
                        end
                        for _, part in ipairs(AWF_settings.RE2_Gunsmith[weapon.ID].Parts) do
                            log.info("[AWF-GS] Original Part Name: " .. part .. " ]")
                        end
                    end
                    
                    local partsMatch = #temp_parts.Parts == #AWF_settings.RE2_Gunsmith[weapon.ID].Parts

                    if partsMatch then
                        for _, part in ipairs(temp_parts.Parts) do
                            local found = false
                            for _, ogPart in ipairs(AWF_settings.RE2_Gunsmith[weapon.ID].Parts) do
                                if part == ogPart then
                                    found = true
                                    break
                                end
                            end
            
                            if not found then
                                partsMatch = false
                                break
                            end
                        end
                    end
            
                    if partsMatch then
                        temp_parts.Presets = nil
                        temp_parts.current_preset_indx = nil

                        for key, value in pairs(temp_parts) do
                            AWF_settings.RE2_Gunsmith[weapon.ID][key] = value
                        end
                    else
                        log.info("[AWF-GS] [ERROR] [Parts do not match, skipping the update.]")
                        AWF_settings.RE2_Gunsmith[weapon.ID].current_preset_indx = 1
                        consoleLoadFail_RE2 = "[ERROR]\nCouldn't load the data from " .. selected_preset .. " for " .. weapon.Name .. ".\nThe material count of the preset doesn't match the material count of the " .. weapon.Name
                    end
                end
                AWF_settings.RE2_Gunsmith[weapon.ID].isUpdated = true
                update_MaterialParams_RE2(AWF.AWF_settings.RE2.Weapons, AWF_settings.RE2_Gunsmith)
            end
            imgui.spacing()
        end
    end
    imgui.text_colored(ui.draw_line("=", 60), 0xFFFFFFFF)
end
local function load_AWFGSEditorAndPreset_GUI_RE2()
    imgui.same_line()
    changed, AWFGS_settings.show_AWF_Gunsmith_editor = imgui.checkbox("Open AWF Gunsmith Editor", AWFGS_settings.show_AWF_Gunsmith_editor)
    func.tooltip("Show/Hide the AWF Gunsmith Editor.")
    if not AWFGS_settings.show_AWF_Gunsmith_editor or imgui.begin_window("Advanced Weapon Framework: Gunsmith Editor", true, 0) == false  then
        AWFGS_settings.show_AWF_Gunsmith_editor = false
    else
        imgui.spacing()
        imgui.indent()
        
        draw_AWFGSEditor_GUI_RE2(AWF.AWF_settings.RE2.Weapon_Order)
        
        imgui.unindent()
        imgui.end_window()
    end
    
    draw_AWFGSPreset_GUI_RE2(AWF.AWF_settings.RE2.Weapon_Order)
end
local function draw_AWFGS_GUI_RE2()
    if reframework.get_game_name() == "re2" then
        if imgui.tree_node(modName) then
            imgui.begin_rect()
            imgui.spacing()
            imgui.indent(5)
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_settings = hk.recurse_def_settings({}, AWFWeapons)
                get_MaterialParams_RE2(AWF.AWF_settings.RE2.Weapons, AWF_settings.RE2_Gunsmith)
                update_MaterialParams_RE2(AWF.AWF_settings.RE2.Weapons, AWF_settings.RE2_Gunsmith)
                cache_AWFGS_json_files_RE2(AWF.AWF_settings.RE2.Weapons)
            end
            func.tooltip("Reset every weapon part.")
            if isDefaultsDumped then
                load_AWFGSEditorAndPreset_GUI_RE2()
            end

            if imgui.tree_node("AWF:GS Settings") then
                imgui.begin_rect()
                imgui.spacing()
                imgui.indent(5)

                changed, AWFGS_settings.isDebug = imgui.checkbox("Debug Mode", AWFGS_settings.isDebug); wc = wc or changed
                func.tooltip("Enable/Disable debug mode. When enabled, AWF:GS will log significantly more information in the 're2_framework_log.txt' file, located in the game's root folder.\nLeave this on if you don't know what you are doing.")
                changed, AWFGS_settings.showMeshName = imgui.checkbox("Show Mesh Name", AWFGS_settings.showMeshName); wc = wc or changed
                changed, AWFGS_settings.showMaterialCount = imgui.checkbox("Show Material Count", AWFGS_settings.showMaterialCount); wc = wc or changed
                changed, AWFGS_settings.showPresetPath = imgui.checkbox("Show Preset Path", AWFGS_settings.showPresetPath); wc = wc or changed
                changed, AWFGS_settings.showMeshPath = imgui.checkbox("Show Mesh Path", AWFGS_settings.showMeshPath); wc = wc or changed
                changed, AWFGS_settings.showMDFPath = imgui.checkbox("Show MDF Path", AWFGS_settings.showMDFPath); wc = wc or changed
                changed, AWFGS_settings.showConsole = imgui.checkbox("Show Console", AWFGS_settings.showConsole); wc = wc or changed

                if imgui.tree_node("Credits") then
                    imgui.text(modCredits .. " ")
                    imgui.tree_pop()
                end

                imgui.indent(-5)
                imgui.spacing()
                imgui.end_rect(2)
                imgui.tree_pop()
            end

            if changed or wc then
                json.dump_file("AWF/AWF_Gunsmith/AWF_Gunsmith_Settings.json", AWF_settings)
                json.dump_file("AWF/AWF_Gunsmith/AWFGS_ToolSettings.json", AWFGS_settings)
                
            end
            if AWFGS_settings.show_AWF_Gunsmith_editor and (changed or wc) then
                update_MaterialParams_RE2(AWF.AWF_settings.RE2.Weapons, AWF_settings.RE2_Gunsmith)
                
            end
            ui.button_n_colored_txt("Current Version:", modVersion .. " | " .. modUpdated, func.convert_rgba_to_AGBR(0, 255, 0, 255))
            imgui.same_line()
            imgui.text("| by " .. modAuthor .. " ")
            
            imgui.indent(-5)
            imgui.spacing()
            imgui.end_rect(1)
            imgui.tree_pop()
        end
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: RE4R
local playerContext_RE4 = nil
local isPlayerInScene_RE4 = false
local consoleLoadFail_RE4 = ""
AWFGS_inventoryUpdater_RE4 = false

local function get_playerContext_RE4()
    local character_manager
    character_manager = sdk.get_managed_singleton(sdk.game_namespace("CharacterManager"))
    playerContext_RE4 = character_manager and character_manager:call("getPlayerContextRef")
    return playerContext_RE4
end
local function check_if_playerIsInScene()
    get_playerContext_RE4()
    if playerContext_RE4 ~= nil then
        isPlayerInScene_RE4 = true
    elseif playerContext_RE4 == nil or {} then
        isPlayerInScene_RE4 = false
    end
end
--Getter function for the material params it only returns the values for weapons that are in the scene
local function get_MaterialParams_RE4(weaponData, WPM_table)
    for _, weapon in pairs(weaponData) do
        if WPM_table[weapon.ID] then
            local Weapon_GameObject_RE4 = scene:call("findGameObject(System.String)", weapon.ID)
            
            WPM_table[weapon.ID].Enabled = {}
            WPM_table[weapon.ID].Parts = {}
            WPM_table[weapon.ID].Materials = {}

            if Weapon_GameObject_RE4 and Weapon_GameObject_RE4:get_Valid() then
                WPM_table[weapon.ID].isInScene = true
                if AWFGS_settings.isDebug then
                    log.info("[AWF-GS] [ " .. weapon.ID .. " is in the scene AWF-GS data updated]")
                end
                local render_mesh = Weapon_GameObject_RE4:call("getComponent(System.Type)", sdk.typeof("via.render.Mesh"))
                
                if render_mesh then
                    local MatCount = render_mesh:call("get_MaterialNum")
                    local nativesMesh = render_mesh:getMesh()
                    local nativesMDF = render_mesh:get_Material()
                    nativesMesh = nativesMesh and nativesMesh:call("ToString()")
                    nativesMDF = nativesMDF and nativesMDF:call("ToString()")
                    if nativesMesh then
                        local meshPath = string.gsub(nativesMesh, "Resource%[", "natives/stm/")
                        local formattedMeshPath = string.gsub(meshPath, ".mesh%]", ".mesh")
                        WPM_table[weapon.ID].MeshPath = formattedMeshPath
                        if AWFGS_settings.isDebug then
                            log.info("[AWF-GS] [" .. formattedMeshPath .. "]")
                        end
                    end
                    nativesMesh = nativesMesh and nativesMesh:match("([^/]-)%.mesh]$")
                    if nativesMesh then
                        WPM_table[weapon.ID].MeshName = nativesMesh
                    end
                    if nativesMDF then
                        local mdfPath = string.gsub(nativesMDF, "Resource%[", "natives/stm/")
                        local formattedMDFPath = string.gsub(mdfPath, ".mdf2%]", ".mdf2")
                        WPM_table[weapon.ID].MDFPath = formattedMDFPath
                        if AWFGS_settings.isDebug then
                            log.info("[AWG-GS] [" .. formattedMDFPath .. "]")
                        end
                    end

                    for MatName, _ in pairs(WPM_table[weapon.ID].Materials) do
                        local found = false
                        for i = 0, MatCount - 1 do
                            if MatName == render_mesh:call("getMaterialName", i) then
                                found = true
                                break
                            end
                        end
                        if not found then
                            WPM_table[weapon.ID].Materials[MatName] = nil
                        end
                    end
    
                    local newPartNames = {}
                    for i = 0, MatCount - 1 do
                        local MatName = render_mesh:call("getMaterialName", i)
                        if MatName then
                            table.insert(newPartNames, MatName)
                        end
                    end
    
                    for PartIndex, PartName in ipairs(WPM_table[weapon.ID].Parts) do
                        if not func.table_contains(newPartNames, PartName) then
                            table.remove(WPM_table[weapon.ID].Parts, PartIndex)
                            table.remove(WPM_table[weapon.ID].Enabled, PartIndex)
                        end
                    end

                    if MatCount then
                        for i = 0, MatCount - 1 do
                            local MatName = render_mesh:call("getMaterialName", i)
                            local MatParam = render_mesh:call("getMaterialVariableNum", i)
                            local EnabledMat = render_mesh:call("getMaterialsEnableIndices", i)

                            if MatName then
                                --Main Table
                                if not WPM_table[weapon.ID].Materials[MatName] then
                                    WPM_table[weapon.ID].Materials[MatName] = {}
                                end
                                
                                if not func.table_contains(WPM_table[weapon.ID].Parts, MatName) then
                                    table.insert(WPM_table[weapon.ID].Parts, MatName)
                                end
                                
                                --Runtime Table
                                if not AWFGS_MaterialParamUpdateHolder[weapon.ID] then
                                    AWFGS_MaterialParamUpdateHolder[weapon.ID] = {}
                                end
                                if not func.table_contains(AWFGS_MaterialParamUpdateHolder, weapon.ID) then
                                    table.insert(AWFGS_MaterialParamUpdateHolder, weapon.ID)
                                end
                                if not AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName] then
                                    AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName] = {}
                                end
                                if not func.table_contains(AWFGS_MaterialParamUpdateHolder[weapon.ID], MatName) then
                                    table.insert(AWFGS_MaterialParamUpdateHolder[weapon.ID], MatName)
                                end

                                if EnabledMat then
                                    if WPM_table[weapon.ID].current_preset_indx >= 1 or nil then
                                        for k, _ in ipairs(WPM_table[weapon.ID].Parts) do
                                            WPM_table[weapon.ID].Enabled[k] = true
                                        end
                                    end
                                end

                                if MatParam then
                                    for j = 0, MatParam - 1 do
                                        local MatParamNames = render_mesh:call("getMaterialVariableName", i, j)
                                        local MatType = render_mesh:call("getMaterialVariableType", i, j)

                                        if MatParamNames then
                                            --Main Table
                                            if not WPM_table[weapon.ID].Materials[MatName][MatParamNames] then
                                                WPM_table[weapon.ID].Materials[MatName][MatParamNames] = {}
                                            end
                                            --Runtime Table
                                            if not AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName][MatParamNames] then
                                                AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName][MatParamNames] = {}
                                            end
                                            if not func.table_contains(AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName], MatParamNames) then
                                                table.insert(AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName], MatParamNames)
                                            end
                                            AWFGS_MaterialParamUpdateHolder[weapon.ID][MatName][MatParamNames].isMaterialParamUpdated = false

                                            if MatType then
                                                if MatType == 1 then
                                                    local MatType_Float = render_mesh:call("getMaterialFloat", i, j)
                                                    if not func.table_contains(WPM_table[weapon.ID].Materials[MatName][MatParamNames], MatType_Float) then
                                                        table.insert(WPM_table[weapon.ID].Materials[MatName][MatParamNames], MatType_Float)
                                                    end
                                                elseif MatType == 4 then
                                                    local MatType_Float4 = render_mesh:call("getMaterialFloat4", i, j)
                                                    local MatType_Float4_New = {MatType_Float4.x, MatType_Float4.y, MatType_Float4.z, MatType_Float4.w}
                                                    local contains = false
                                                    for _, value in ipairs(WPM_table[weapon.ID].Materials[MatName][MatParamNames]) do
                                                        if #value == 4 then
                                                            value[1] = MatType_Float4_New[1]
                                                            value[2] = MatType_Float4_New[2]
                                                            value[3] = MatType_Float4_New[3]
                                                            value[4] = MatType_Float4_New[4]
                                                            contains = true
                                                            break
                                                        end
                                                    end
                                                
                                                    if not contains then
                                                        table.insert(WPM_table[weapon.ID].Materials[MatName][MatParamNames], MatType_Float4_New)
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
            elseif (not Weapon_GameObject_RE4) or (not Weapon_GameObject_RE4:get_Valid()) then
                WPM_table[weapon.ID].isInScene = false
            end
        end
    end
    json.dump_file("AWF/AWF_Gunsmith/_Holders/AWFGS_MaterialParamUpdateHolder.json", WPM_table)
    json.dump_file("AWF/AWF_Gunsmith/_Holders/AWFGS_MaterialParamDefaultsHolder.json", AWFGS_MaterialParamUpdateHolder)
end
--Dumps the default material params if the weapon is in the scene, this only runs once on the initial loading screen
local function dump_DefaultMaterialParam_json_RE4(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParts = AWF_settings.RE4_Gunsmith[weapon.ID]

        if weaponParts and weaponParts.isInScene and not isDefaultsDumped then
            json.dump_file("AWF/AWF_Gunsmith/" .. weapon.Name .. "/" .. weapon.Name .. " Default.json", weaponParts)
            
            if AWFGS_settings.isDebug then
                log.info("[AWF-GS] [" .. weapon.Name .. " Default Preset Updated]")
            end
        end
    end
end
local function dump_CurrentMaterialParam_json_RE4(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParts = AWF_settings.RE4_Gunsmith[weapon.ID]

        if weaponParts then
            json.dump_file("AWF/AWF_Gunsmith/" .. weapon.Name .. "/" .. weapon.Name .. " Current Preset.json", weaponParts)
            
            if AWFGS_settings.isDebug then
                log.info("[AWF-GS] [" .. weapon.Name .. " Current Preset Updated]")
            end
        end
    end
end
local function cache_AWFGS_json_files_RE4(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWF_settings.RE4_Gunsmith[weapon.ID]
        
        if weaponParams then
            local json_names = weaponParams.Presets or {}
            local json_filepaths = fs.glob([[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\.*.json]])
            
            if json_filepaths then
                local defaultName = weapon.Name .. " Default"
                local defaultNameInserted = false

                for i, filepath in ipairs(json_filepaths) do
                    local name = filepath:match("^.+\\(.+)%.")
                    local nameExists = false
                    
                    for j, existingName in ipairs(json_names) do
                        if existingName == name then
                            nameExists = true
                            break
                        end
                    end
                    
                    if not nameExists then
                        if name == defaultName then
                            table.insert(json_names, 1, name)
                            defaultNameInserted = true
                        else
                            table.insert(json_names, name)
                        end

                        if AWFGS_settings.isDebug then
                            log.info("[AWF-GS] [Loaded " .. filepath .. " for "  .. weapon.Name .. "]")
                        end
                    end
                end
                
                if not defaultNameInserted then
                    for i, name in ipairs(json_names) do
                        if name == defaultName then
                            table.remove(json_names, i)
                            table.insert(json_names, 1, name)
                            break
                        end
                    end
                end

                for i = #json_names, 1, -1 do
                    local nameExists = false
                    local name = json_names[i]
                    for _, filepath in ipairs(json_filepaths) do
                        if filepath:match("^.+\\(.+)%.") == name then
                            nameExists = true
                            break
                        end
                    end
                    if not nameExists then
                        if AWFGS_settings.isDebug then
                            log.info("[AWF-GS] [Removed " .. name .. " from " .. weapon.Name .. "]")
                        end
                        table.remove(json_names, i)
                    end
                end
            else
                if AWFGS_settings.isDebug then
                    log.info("[AWF-GS] [No AWF-GS JSON files found.]")
                end
            end
        end
    end
end
local function update_MaterialParams_RE4(weaponData, WPM_table)
    for _, weapon in pairs(weaponData) do
        if WPM_table[weapon.ID] and WPM_table[weapon.ID].isUpdated then
            local Weapon_GameObject_RE4 = scene:call("findGameObject(System.String)", weapon.ID)
            local weaponInventoryID = string.format("AC_ItemModel_wp" .. weapon.Enum)
            local Weapon_Inventory_GameObject_RE4 = scene:call("findGameObject(System.String)", weaponInventoryID)

            if Weapon_GameObject_RE4 and Weapon_GameObject_RE4:get_Valid() then
                local render_mesh = Weapon_GameObject_RE4:call("getComponent(System.Type)", sdk.typeof("via.render.Mesh"))
                
                if render_mesh then
                    local MatCount = render_mesh:call("get_MaterialNum")
                    
                    if MatCount then
                        for i = 0, MatCount - 1 do
                            local MatName = render_mesh:call("getMaterialName", i)
                            local MatParam = render_mesh:call("getMaterialVariableNum", i)
                            local EnabledMat = render_mesh:call("getMaterialsEnableIndices", i)
                            
                            if MatName then
                                if MatParam then
                                    for k = 0, MatParam - 1 do
                                        local MatParamNames = render_mesh:call("getMaterialVariableName", i, k)
                                        local MatType = render_mesh:call("getMaterialVariableType", i, k)
                                        if MatParamNames then
                                            if MatType then
                                                if MatType == 1 then
                                                    render_mesh:call("setMaterialFloat", i, k,WPM_table[weapon.ID].Materials[MatName][MatParamNames][1])
                                                end
                                                if MatType == 4 then
                                                    local vec4 = WPM_table[weapon.ID].Materials[MatName][MatParamNames][1]
                                                    render_mesh:call("setMaterialFloat4", i, k, Vector4f.new(vec4[1], vec4[2], vec4[3], vec4[4]))
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if EnabledMat then
                                for j = 0, EnabledMat do
                                    render_mesh:call("setMaterialsEnable", j, WPM_table[weapon.ID].Enabled[j + 1])
                                end
                            end
                        end
                    end
                end

                if Weapon_Inventory_GameObject_RE4 then
                    local ac_item = Weapon_Inventory_GameObject_RE4:call("getComponent(System.Type)", sdk.typeof("chainsaw.AcItemModelController"))
    
                    if ac_item then
                        local ac_mesh = ac_item:call("get_MeshController")
                        
                        if ac_mesh then
                            local render_mesh = ac_mesh:get_field("_Mesh")
    
                            if render_mesh then
                                local MatCount = render_mesh:call("get_MaterialNum")
                                
                                if MatCount then
                                    for i = 0, MatCount - 1 do
                                        local MatName = render_mesh:call("getMaterialName", i)
                                        local MatParam = render_mesh:call("getMaterialVariableNum", i)
                                        local EnabledMat = render_mesh:call("getMaterialsEnableIndices", i)
                                        
                                        if MatName then
                                            if MatParam then
                                                for k = 0, MatParam - 1 do
                                                    local MatParamNames = render_mesh:call("getMaterialVariableName", i, k)
                                                    local MatType = render_mesh:call("getMaterialVariableType", i, k)
                                                    if MatParamNames then
                                                        if MatType then
                                                            if MatType == 1 then
                                                                render_mesh:call("setMaterialFloat", i, k,WPM_table[weapon.ID].Materials[MatName][MatParamNames][1])
                                                            end
                                                            if MatType == 4 then
                                                                local vec4 = WPM_table[weapon.ID].Materials[MatName][MatParamNames][1]
                                                                render_mesh:call("setMaterialFloat4", i, k, Vector4f.new(vec4[1], vec4[2], vec4[3], vec4[4]))
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
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
                end
            end
        end
        AWF_settings.RE4_Gunsmith[weapon.ID].isUpdated = true
    end
end
local function get_MasterMaterialData_RE4(weaponData)
    check_if_playerIsInScene()

    if isPlayerInScene_RE4 then
        --Initial loading screen check
        if NowLoading and not isDefaultsDumped then
            get_MaterialParams_RE4(AWF.AWF_settings.RE4.Weapons, AWF_settings.RE4_Gunsmith)
            dump_DefaultMaterialParam_json_RE4(AWF.AWF_settings.RE4.Weapons)
            cache_AWFGS_json_files_RE4(AWF.AWF_settings.RE4.Weapons)
            AWFGS_MaterialParamDefaultsHolder = func.deepcopy(AWF_settings)

            for _, weapon in pairs(weaponData) do
                AWF_settings.RE4_Gunsmith[weapon.ID].isUpdated = true

                local selected_preset = AWF_settings.RE4_Gunsmith[weapon.ID].Presets[AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx]
                if selected_preset ~= weapon.Name .. " Default" and selected_preset ~= nil then
                    wc = true
                    local json_filepath = [[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                    local temp_parts = json.load_file(json_filepath)

                    if temp_parts.Parts ~= nil then
                        if AWFGS_settings.isDebug then
                            log.info("[AWF-GS] [Auto Preset Loader: " .. weapon.Name .. " --- " .. #temp_parts.Parts .. " ]")

                            for _, part in ipairs(temp_parts.Parts) do
                                log.info("[AWF-GS] [Preset Part Name: " .. part .. " ]")
                            end
                            for _, part in ipairs(AWF_settings.RE4_Gunsmith[weapon.ID].Parts) do
                                log.info("[AWF-GS] Original Part Name: " .. part .. " ]")
                            end
                        end
                        
                        local partsMatch = #temp_parts.Parts == #AWF_settings.RE4_Gunsmith[weapon.ID].Parts

                        if partsMatch then
                            for _, part in ipairs(temp_parts.Parts) do
                                local found = false
                                for _, ogPart in ipairs(AWF_settings.RE4_Gunsmith[weapon.ID].Parts) do
                                    if part == ogPart then
                                        found = true
                                        break
                                    end
                                end
                
                                if not found then
                                    partsMatch = false
                                    break
                                end
                            end
                        end
                
                        if partsMatch then
                            temp_parts.Presets = nil
                            temp_parts.current_preset_indx = nil

                            for key, value in pairs(temp_parts) do
                                AWF_settings.RE4_Gunsmith[weapon.ID][key] = value
                            end
                        else
                            log.info("[AWF-GS] [Parts do not match, skipping the update.]")
                            AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx = 1
                        end
                    end
                elseif selected_preset == nil or {} then
                    AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx = 1
                end
                update_MaterialParams_RE4(AWF.AWF_settings.RE4.Weapons, AWF_settings.RE4_Gunsmith)
            end
            
            log.info("[AWF-GS] [Master Data defaults dumped.]")
            isDefaultsDumped = true
        end
        --Subsequent loading screen checks
        if NowLoading and isDefaultsDumped then
            get_MaterialParams_RE4(AWF.AWF_settings.RE4.Weapons, AWF_settings.RE4_Gunsmith)
            cache_AWFGS_json_files_RE4(AWF.AWF_settings.RE4.Weapons)

            for _, weapon in pairs(weaponData) do
                AWF_settings.RE4_Gunsmith[weapon.ID].isUpdated = true

                local selected_preset = AWF_settings.RE4_Gunsmith[weapon.ID].Presets[AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx]
                if selected_preset ~= weapon.Name .. " Default" and selected_preset ~= nil then
                    wc = true
                    local json_filepath = [[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                    local temp_parts = json.load_file(json_filepath)
            
                    if temp_parts.Parts ~= nil then
                        if AWFGS_settings.isDebug then
                            log.info("[AWF-GS] [Auto Preset Loader: " .. weapon.Name .. " --- " .. #temp_parts.Parts .. " ]")

                            for _, part in ipairs(temp_parts.Parts) do
                                log.info("[AWF-GS] [Preset Part Name: " .. part .. " ]")
                            end
                            for _, part in ipairs(AWF_settings.RE4_Gunsmith[weapon.ID].Parts) do
                                log.info("[AWF-GS] Original Part Name: " .. part .. " ]")
                            end
                        end
                        
                        local partsMatch = #temp_parts.Parts == #AWF_settings.RE4_Gunsmith[weapon.ID].Parts

                        if partsMatch then
                            for _, part in ipairs(temp_parts.Parts) do
                                local found = false
                                for _, ogPart in ipairs(AWF_settings.RE4_Gunsmith[weapon.ID].Parts) do
                                    if part == ogPart then
                                        found = true
                                        break
                                    end
                                end
                
                                if not found then
                                    partsMatch = false
                                    break
                                end
                            end
                        end
                
                        if partsMatch then
                            temp_parts.Presets = nil
                            temp_parts.current_preset_indx = nil

                            for key, value in pairs(temp_parts) do
                                AWF_settings.RE4_Gunsmith[weapon.ID][key] = value
                            end
                        else
                            log.info("[AWF-GS] [Parts do not match, skipping the update.]")
                            AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx = 1
                        end
                    end
                elseif selected_preset == nil or {} then
                    AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx = 1
                end
                update_MaterialParams_RE4(AWF.AWF_settings.RE4.Weapons, AWF_settings.RE4_Gunsmith)
            end
        end
        --Update data on opening the inventory
        if AWF_Inventory_Found and AWFGS_inventoryUpdater_RE4 then
            get_MaterialParams_RE4(AWF.AWF_settings.RE4.Weapons, AWF_settings.RE4_Gunsmith)
            dump_CurrentMaterialParam_json_RE4(AWF.AWF_settings.RE4.Weapons)
            AWFGS_MaterialParamDefaultsHolder = func.deepcopy(AWF_settings)
            update_MaterialParams_RE4(AWF.AWF_settings.RE4.Weapons, AWF_settings.RE4_Gunsmith)
            AWFGS_inventoryUpdater_RE4 = false
        end
    end
end
local function draw_AWFGSEditor_GUI_RE4(weaponOrder)
    if imgui.begin_window("Advanced Weapon Framework: Gunsmith Editor") then
        imgui.begin_rect()
        local weaponsByGame = {}
        local lastGame = nil

        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF.AWF_settings.RE4.Weapons[weaponName]
            if weapon then
                local game = weapon.Game
                if not weaponsByGame[game] then
                    weaponsByGame[game] = {}
                end
                table.insert(weaponsByGame[game], weapon)
            end
        end
            
        local gameModeLabels = {
            Main = "Main Game",
            SW = "Separate Ways",
            Mercs = "Mercenaries"
        }

        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF.AWF_settings.RE4.Weapons[weaponName]
            
            if weapon then
                local textColor = {255,255,255,255}

                if weapon.Game == "Main" then
                    textColor = {255, 187, 0, 255}
                elseif weapon.Game == "SW" then
                    textColor = {245, 56, 81, 255}
                elseif weapon.Game == "Mercs" then
                    textColor = {0, 255, 219, 255}
                end

                if weapon.Game ~= lastGame then
                    imgui.text_colored("  [ " .. ui.draw_line("=", 50) .. " | " .. (gameModeLabels[weapon.Game] or weapon.Game) .. " | " .. ui.draw_line("=", 50) .. " ] ", func.convert_rgba_to_AGBR(textColor))
                    lastGame = weapon.Game
                end
                
                if imgui.tree_node(weapon.Name) then
                    imgui.begin_rect()
                    imgui.spacing()
                    
                    imgui.text_colored("  " .. ui.draw_line("=", 100) .."  ", func.convert_rgba_to_AGBR(textColor))
                    imgui.indent(10)

                    if imgui.button("Update Preset List") then
                        wc = true
                        cache_AWFGS_json_files_RE4(AWF.AWF_settings.RE4.Weapons)
                    end

                    if AWFGS_settings.showMeshName then
                        imgui.same_line()
                        imgui.text("[ Mesh Name:")
                        imgui.same_line()
                        imgui.text_colored(AWF_settings.RE4_Gunsmith[weapon.ID].MeshName, 0xFF00BBFF)
                        imgui.same_line()
                        imgui.text("]")
                    end
    
                    if AWFGS_settings.showMaterialCount then
                        imgui.same_line()
                        imgui.text("[ Material Count:")
                        imgui.same_line()
                        imgui.text_colored(#AWF_settings.RE4_Gunsmith[weapon.ID].Parts, 0xFFDBFF00)
                        imgui.same_line()
                        imgui.text("]")
                    end

                    changed, AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx = imgui.combo("Preset", AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx or 1, AWF_settings.RE4_Gunsmith[weapon.ID].Presets); wc = wc or changed
                    func.tooltip("Select a file from the dropdown menu to load the weapon variant from that file.")
                    if changed then
                        local selected_preset = AWF_settings.RE4_Gunsmith[weapon.ID].Presets[AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx]
                        local json_filepath = [[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                        local temp_parts = json.load_file(json_filepath)
                        
                        if temp_parts.Parts ~= nil then
                            if AWFGS_settings.isDebug then
                                log.info("[AWF-GS] [Preset Loader: " .. weapon.Name .. " --- " .. #temp_parts.Parts .. " ]")
        
                                for _, part in ipairs(temp_parts.Parts) do
                                    log.info("[AWF-GS] [Preset Part Name: " .. part .. " ]")
                                end
                                for _, part in ipairs(AWF_settings.RE4_Gunsmith[weapon.ID].Parts) do
                                    log.info("[AWF-GS] Original Part Name: " .. part .. " ]")
                                end
                            end
                            
                            local partsMatch = #temp_parts.Parts == #AWF_settings.RE4_Gunsmith[weapon.ID].Parts
        
                            if partsMatch then
                                for _, part in ipairs(temp_parts.Parts) do
                                    local found = false
                                    for _, ogPart in ipairs(AWF_settings.RE4_Gunsmith[weapon.ID].Parts) do
                                        if part == ogPart then
                                            found = true
                                            break
                                        end
                                    end
                    
                                    if not found then
                                        partsMatch = false
                                        break
                                    end
                                end
                            end
                    
                            if partsMatch then
                                temp_parts.Presets = nil
                                temp_parts.current_preset_indx = nil
        
                                for key, value in pairs(temp_parts) do
                                    AWF_settings.RE4_Gunsmith[weapon.ID][key] = value
                                end
                            else
                                log.info("[AWF-GS] [Parts do not match, skipping the update.]")
                                AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx = 1
                                consoleLoadFail_RE4 = "[ERROR]\nCouldn't load the data from " .. selected_preset .. " for " .. weapon.Name .. ".\nThe material count of the preset doesn't match the material count of the " .. weapon.Name
                            end
                        end
                        update_MaterialParams_RE4(AWF.AWF_settings.RE4.Weapons, AWF_settings.RE4_Gunsmith)
                    end

                    imgui.push_id(_)
                    changed, presetName = imgui.input_text("", presetName); wc = wc or changed
                    imgui.pop_id()
                    imgui.same_line()
                    if imgui.button("Save Preset") then
                        json.dump_file("AWF/AWF_Gunsmith/".. weapon.Name .. "/" .. presetName .. ".json", AWF_settings.RE4_Gunsmith[weapon.ID])
                        log.info("[AWF-GS] [Preset with the name: " .. presetName .. " saved for " .. weapon.Name .. ".]")
                        cache_AWFGS_json_files_RE4(AWF.AWF_settings.RE4.Weapons)
                    end
                    func.tooltip("Save the current parameters of the " .. weapon.Name .. " to '[PresetName].json' found in [RESIDENT EVIL 4  BIOHAZARD RE4/reframework/data/AWF/AWF_Gunsmith/".. weapon.Name .. "]")

                    imgui.spacing()

                    if AWFGS_settings.showPresetPath and #AWF_settings.RE4_Gunsmith[weapon.ID].Parts > 0 then
                        imgui.input_text("Preset Path", "RESIDENT EVIL 4  BIOHAZARD RE4/reframework/data/AWF/AWF_Gunsmith/".. weapon.Name .. "/" .. presetName .. ".json")
                    end
    
                    if AWFGS_settings.showMeshPath then
                        imgui.push_id(AWF_settings.RE4_Gunsmith[weapon.ID].MeshPath)
                        imgui.input_text("Mesh Path", AWF_settings.RE4_Gunsmith[weapon.ID].MeshPath)
                        imgui.pop_id()
                    end
    
                    if AWFGS_settings.showMDFPath then
                        imgui.push_id(AWF_settings.RE4_Gunsmith[weapon.ID].MDFPath)
                        imgui.input_text("MDF Path", AWF_settings.RE4_Gunsmith[weapon.ID].MDFPath)
                        imgui.pop_id()
                    end

                    if imgui.tree_node("Mesh Editor") then
                        imgui.spacing()
                        imgui.text_colored(ui.draw_line("=", 78), func.convert_rgba_to_AGBR(255,255,255,255))
                        imgui.indent(15)

                        for i, partName in ipairs(AWF_settings.RE4_Gunsmith[weapon.ID].Parts) do
                            local enabledMeshPart =  AWF_settings.RE4_Gunsmith[weapon.ID].Enabled[i]
                            local defaultEnabledMeshPart = AWFGS_MaterialParamDefaultsHolder.RE4_Gunsmith[weapon.ID].Enabled[i]
            
                            if enabledMeshPart == defaultEnabledMeshPart or enabledMeshPart ~= defaultEnabledMeshPart then
                                changed, enabledMeshPart = imgui.checkbox(partName, enabledMeshPart); wc = wc or changed
                                AWF_settings.RE4_Gunsmith[weapon.ID].Enabled[i] = enabledMeshPart
                            end
                            if enabledMeshPart ~= defaultEnabledMeshPart then
                                imgui.same_line()
                                imgui.text_colored("*", 0xFF00BBFF)
                            end
                        end

                        imgui.indent(-15)
                        imgui.text_colored(ui.draw_line("=", 78), func.convert_rgba_to_AGBR(255,255,255,255))
                        imgui.tree_pop()
                    end
                    
                    if imgui.tree_node("Material Editor") then
                        imgui.spacing()
                        imgui.text_colored(ui.draw_line("=", 78), 0xFFDBFF00)
                        changed, searchQuery = imgui.input_text("Search", searchQuery); wc = wc or changed
                        imgui.indent(5)

                        for matName, matData in func.orderedPairs(AWF_settings.RE4_Gunsmith[weapon.ID].Materials) do
                            imgui.spacing()
                        
                            if imgui.tree_node(matName) then
                                imgui.push_id(matName)
                                imgui.spacing()
                                if imgui.begin_popup_context_item() then
                                    if imgui.menu_item("Reset") then
                                        for paramName, _ in pairs(matData) do
                                            AWF_settings.RE4_Gunsmith[weapon.ID].Materials[matName][paramName][1] = AWFGS_MaterialParamDefaultsHolder.RE4_Gunsmith[weapon.ID].Materials[matName][paramName][1]
                                            wc = true
                                        end
                                        changed = true
                                    end
                                    if imgui.menu_item("Copy") then
                                        AWFGS_MaterialEditorParamHolder = func.deepcopy(AWF_settings.RE4_Gunsmith[weapon.ID].Materials[matName])
                                        wc = true
                                    end
                                    if imgui.menu_item("Paste") then
                                        local copiedParams = AWFGS_MaterialEditorParamHolder
                                        local targetParams = AWF_settings.RE4_Gunsmith[weapon.ID].Materials[matName]
                                        
                                        for paramName, paramValue in pairs(copiedParams) do
                                            if targetParams[paramName] ~= nil then
                                                targetParams[paramName] = func.deepcopy(paramValue)
                                                wc = true
                                            end
                                        end
                                    end
                                    imgui.end_popup()
                                end
                                for paramName, paramValue in func.orderedPairs(matData) do
                                    local originalData = AWFGS_MaterialParamDefaultsHolder.RE4_Gunsmith[weapon.ID].Materials[matName][paramName]
    
                                    if searchQuery == "" then
                                        imgui.spacing()
                                    end
                                    
                                    if string.find(paramName, searchQuery) then
                                        imgui.begin_rect()
                                    

                                        if func.compareTables(paramValue, originalData) then
                                            if imgui.button("[ " .. tostring(paramName) .. " ]") then
                                                paramValue[1] = AWFGS_MaterialParamDefaultsHolder.RE4_Gunsmith[weapon.ID].Materials[matName][paramName][1] or nil
                                                wc = true
                                            end
                                            if AWFGS_RE4Comp[paramName] then
                                                func.tooltip(AWFGS_RE4Comp[paramName])
                                            end
                                            if imgui.begin_popup_context_item() then
                                                if imgui.menu_item("Reset") then
                                                    paramValue[1] =AWFGS_MaterialParamDefaultsHolder.RE4_Gunsmith[weapon.ID].Materials[matName][paramName][1]
                                                    wc = true
                                                end
                                                if imgui.menu_item("Copy") then
                                                    MDFXL_MaterialEditorSubParamFloat4Holder = paramValue[1]
                                                    wc = true
                                                end
                                                if imgui.menu_item("Paste") then
                                                    paramValue[1] = MDFXL_MaterialEditorSubParamFloat4Holder
                                                    wc = true
                                                end
                                                imgui.end_popup()
                                            end
                                        elseif not func.compareTables(paramValue, originalData) then
                                            imgui.indent(35)
                                            if imgui.button("[ " .. tostring(paramName) .. " ]") then
                                                paramValue[1] = AWFGS_MaterialParamDefaultsHolder.RE4_Gunsmith[weapon.ID].Materials[matName][paramName][1]
                                                wc = true
                                            end
                                            if imgui.begin_popup_context_item() then
                                                if imgui.menu_item("Reset") then
                                                    paramValue[1] = AWFGS_MaterialParamDefaultsHolder.RE4_Gunsmith[weapon.ID].Materials[matName][paramName][1]
                                                    wc = true
                                                end
                                                if imgui.menu_item("Copy") then
                                                    MDFXL_MaterialEditorSubParamFloat4Holder = paramValue[1]
                                                    wc = true
                                                end
                                                if imgui.menu_item("Paste") then
                                                    paramValue[1] = MDFXL_MaterialEditorSubParamFloat4Holder
                                                    wc = true
                                                end
                                                imgui.end_popup()
                                            end
                                            imgui.same_line()
                                            imgui.text_colored("*", 0xFFDBFF00)
                                        end

                                        if type(paramValue) == "table" then
                                            if type(paramValue[1]) == "table" then
                                                for i, value in ipairs(paramValue) do
                                                    imgui.push_id(tostring(paramName))
                                                    local newcolor = Vector4f.new(value[1], value[2], value[3], value[4])
                                                    changed, newcolor = imgui.color_edit4("", newcolor, nil); wc = wc or changed
                                                    paramValue[i] = {newcolor.x, newcolor.y, newcolor.z, newcolor.w}
                                                    imgui.pop_id()
                                                end
                                            else
                                                imgui.push_id(tostring(paramName))
                                                changed, paramValue[1] = imgui.drag_float("", paramValue[1], 0.001, 0.0, 100.0); wc = wc or changed
                                                imgui.pop_id()
                                            end
                                            
                                            if changed or wc then
                                                AWFGS_MaterialParamUpdateHolder[weapon.ID][matName][paramName].isMaterialParamUpdated = true
                                            end
                                        end
                                        imgui.end_rect(3)
                                        imgui.spacing()
                                    end
                                end
                                imgui.pop_id()
                                imgui.spacing()
                                imgui.tree_pop()
                            end
                        end
                        imgui.indent(-5)
                        imgui.text_colored(ui.draw_line("=", 78), 0xFFDBFF00)
                        imgui.tree_pop()
                    end

                    if changed or wc then
                        AWF_settings.RE4_Gunsmith[weapon.ID].isUpdated = true
                    end
                    imgui.indent(-10)
                    imgui.text_colored("  " .. ui.draw_line("=", 100) .."  ", func.convert_rgba_to_AGBR(textColor))

                    imgui.end_rect(2)
                    imgui.tree_pop()
                end
                imgui.text_colored("  " .. ui.draw_line("-", 150) .."  ", func.convert_rgba_to_AGBR(255,255,255,255))
            end
        end
        imgui.end_rect(1)
        imgui.end_window()
    end
end
local function draw_AWFGSPreset_GUI_RE4(weaponOrder)
    imgui.spacing()
    local weaponsByGame = {}
    local lastGame = nil

    for _, weaponName in ipairs(weaponOrder) do
        local weapon = AWF.AWF_settings.RE4.Weapons[weaponName]
        if weapon then
            local game = weapon.Game
            if not weaponsByGame[game] then
                weaponsByGame[game] = {}
            end
            table.insert(weaponsByGame[game], weapon)
        end
    end
        
    local gameModeLabels = {
        Main = "Main Game",
        SW = "Separate Ways",
        Mercs = "Mercenaries"
    }
    
    if AWFGS_settings.showConsole then
        imgui.begin_rect()
        imgui.text("[AWF-GS Console] " .. ui.draw_line("-", 40))
        if imgui.button("Clear Log") then
            consoleLoadFail_RE4 = ""
        end
        imgui.indent(5)
        imgui.spacing()

        imgui.text_colored(consoleLoadFail_RE4, func.convert_rgba_to_AGBR(255, 0, 0, 255))

        imgui.spacing()
        imgui.indent(-5)
        imgui.text(ui.draw_line("-", 66))
        imgui.end_rect(1)
    end

    for _, weaponName in ipairs(weaponOrder) do
        local weapon = AWF.AWF_settings.RE4.Weapons[weaponName]
        local textColor = {255,255,255,255}

        if weapon.Game == "Main" then
            textColor = {255, 187, 0, 255}
        elseif weapon.Game == "SW" then
            textColor = {245, 56, 81, 255}
        elseif weapon.Game == "Mercs" then
            textColor = {0, 255, 219, 255}
        end
    
        if weapon.Game ~= lastGame then
            imgui.text_colored(" " .. ui.draw_line("=", 60) .. " | " .. (gameModeLabels[weapon.Game] or weapon.Game) .. " ", func.convert_rgba_to_AGBR(textColor))
            lastGame = weapon.Game
        end

        if weapon then
            changed, AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx = imgui.combo(weapon.Name, AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx or 1, AWF_settings.RE4_Gunsmith[weapon.ID].Presets); wc = wc or changed
            if changed then
                local selected_preset = AWF_settings.RE4_Gunsmith[weapon.ID].Presets[AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx]
                local json_filepath = [[AWF\\AWF_Gunsmith\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                local temp_parts = json.load_file(json_filepath)
                
                if temp_parts.Parts ~= nil then
                    if AWFGS_settings.isDebug then
                        log.info("[AWF-GS] [Preset Loader: " .. weapon.Name .. " --- " .. #temp_parts.Parts .. " ]")

                        for _, part in ipairs(temp_parts.Parts) do
                            log.info("[AWF-GS] [Preset Part Name: " .. part .. " ]")
                        end
                        for _, part in ipairs(AWF_settings.RE4_Gunsmith[weapon.ID].Parts) do
                            log.info("[AWF-GS] Original Part Name: " .. part .. " ]")
                        end
                    end
                    
                    local partsMatch = #temp_parts.Parts == #AWF_settings.RE4_Gunsmith[weapon.ID].Parts

                    if partsMatch then
                        for _, part in ipairs(temp_parts.Parts) do
                            local found = false
                            for _, ogPart in ipairs(AWF_settings.RE4_Gunsmith[weapon.ID].Parts) do
                                if part == ogPart then
                                    found = true
                                    break
                                end
                            end
            
                            if not found then
                                partsMatch = false
                                break
                            end
                        end
                    end
            
                    if partsMatch then
                        temp_parts.Presets = nil
                        temp_parts.current_preset_indx = nil

                        for key, value in pairs(temp_parts) do
                            AWF_settings.RE4_Gunsmith[weapon.ID][key] = value
                        end
                    else
                        log.info("[AWF-GS] [ERROR] [Parts do not match, skipping the update.]")
                        AWF_settings.RE4_Gunsmith[weapon.ID].current_preset_indx = 1
                        consoleLoadFail_RE4 = "[ERROR]\nCouldn't load the data from " .. selected_preset .. " for " .. weapon.Name .. ".\nThe material count of the preset doesn't match the material count of the " .. weapon.Name
                    end
                end
                AWF_settings.RE4_Gunsmith[weapon.ID].isUpdated = true
                update_MaterialParams_RE4(AWF.AWF_settings.RE4.Weapons, AWF_settings.RE4_Gunsmith)
            end
            imgui.spacing()
        end
    end
    imgui.text_colored(ui.draw_line("=", 60), 0xFFFFFFFF)
end
local function load_AWFGSEditorAndPreset_GUI_RE4()
    imgui.same_line()
    changed, AWFGS_settings.show_AWF_Gunsmith_editor = imgui.checkbox("Open AWF Gunsmith Editor", AWFGS_settings.show_AWF_Gunsmith_editor)
    func.tooltip("Show/Hide the AWF Gunsmith Editor.")
    if not AWFGS_settings.show_AWF_Gunsmith_editor or imgui.begin_window("Advanced Weapon Framework: Gunsmith Editor", true, 0) == false  then
        AWFGS_settings.show_AWF_Gunsmith_editor = false
    else
        imgui.spacing()
        imgui.indent()
        
        draw_AWFGSEditor_GUI_RE4(AWF.AWF_settings.RE4.Weapon_Order)
        
        imgui.unindent()
        imgui.end_window()
    end
    
    draw_AWFGSPreset_GUI_RE4(AWF.AWF_settings.RE4.Weapon_Order)
end
local function draw_AWFGS_GUI_RE4()
    if reframework.get_game_name() == "re4" then
        if imgui.tree_node("Advanced Weapon Framework: Gunsmith") then
            imgui.begin_rect()
            imgui.spacing()
            imgui.indent(5)
            if imgui.button("Reset to Defaults") then
                wc = true
                changed = true
                AWF_settings = hk.recurse_def_settings({}, AWFWeapons)
                get_MaterialParams_RE4(AWF.AWF_settings.RE4.Weapons, AWF_settings.RE4_Gunsmith)
                update_MaterialParams_RE4(AWF.AWF_settings.RE4.Weapons, AWF_settings.RE4_Gunsmith)
                cache_AWFGS_json_files_RE4(AWF.AWF_settings.RE4.Weapons)
            end
            func.tooltip("Reset every weapon part.")
            if isDefaultsDumped then
                load_AWFGSEditorAndPreset_GUI_RE4()
            end

            if imgui.tree_node("AWF:GS Settings") then
                imgui.begin_rect()
                imgui.spacing()
                imgui.indent(5)

                changed, AWFGS_settings.isDebug = imgui.checkbox("Debug Mode", AWFGS_settings.isDebug); wc = wc or changed
                func.tooltip("Enable/Disable debug mode. When enabled, AWF:GS will log significantly more information in the 're2_framework_log.txt' file, located in the game's root folder.\nLeave this on if you don't know what you are doing.")
                changed, AWFGS_settings.showMeshName = imgui.checkbox("Show Mesh Name", AWFGS_settings.showMeshName); wc = wc or changed
                changed, AWFGS_settings.showMaterialCount = imgui.checkbox("Show Material Count", AWFGS_settings.showMaterialCount); wc = wc or changed
                changed, AWFGS_settings.showPresetPath = imgui.checkbox("Show Preset Path", AWFGS_settings.showPresetPath); wc = wc or changed
                changed, AWFGS_settings.showMeshPath = imgui.checkbox("Show Mesh Path", AWFGS_settings.showMeshPath); wc = wc or changed
                changed, AWFGS_settings.showMDFPath = imgui.checkbox("Show MDF Path", AWFGS_settings.showMDFPath); wc = wc or changed
                changed, AWFGS_settings.showConsole = imgui.checkbox("Show Console", AWFGS_settings.showConsole); wc = wc or changed

                if imgui.tree_node("Credits") then
                    imgui.text(modCredits .. " ")
                    imgui.tree_pop()
                end

                imgui.indent(-5)
                imgui.spacing()
                imgui.end_rect(2)
                imgui.tree_pop()
            end

            if changed or wc then
                json.dump_file("AWF/AWF_Gunsmith/AWF_Gunsmith_Settings.json", AWF_settings)
                json.dump_file("AWF/AWF_Gunsmith/AWFGS_ToolSettings.json", AWFGS_settings)
                
            end
            if AWFGS_settings.show_AWF_Gunsmith_editor and (changed or wc) then
                update_MaterialParams_RE4(AWF.AWF_settings.RE4.Weapons, AWF_settings.RE4_Gunsmith)
                
            end
            ui.button_n_colored_txt("Current Version:", modVersion .. " | " .. modUpdated, func.convert_rgba_to_AGBR(0, 255, 0, 255))
            imgui.same_line()
            imgui.text("| by " .. modAuthor .. " ")
            
            imgui.indent(-5)
            imgui.spacing()
            imgui.end_rect(1)
            imgui.tree_pop()
        end
    end
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK:On Frame
re.on_frame(function()
    if reframework.get_game_name() == "re2" then
        if not NowLoading then
            get_MasterMaterialData_RE2(AWF.AWF_settings.RE2.Weapons)
            changed = false
            wc = false
        end
    end
    if reframework.get_game_name() == "re4" then
        if not NowLoading then
            get_MasterMaterialData_RE4(AWF.AWF_settings.RE4.Weapons)
            changed = false
            wc = false
        end
    end
end)

--MARK:On Draw UI
re.on_draw_ui(function()
    draw_AWFGS_GUI_RE2()
    draw_AWFGS_GUI_RE4()
end)

AWFGS = {
    AWFGS_Settings = AWF_settings,

    get_MaterialParams_RE2 = get_MaterialParams_RE2,
    cache_AWFGS_json_files_RE2 = cache_AWFGS_json_files_RE2,
    update_MaterialParams_RE2 = update_MaterialParams_RE2,
    dump_DefaultMaterialParam_json_RE2 = dump_DefaultMaterialParam_json_RE2,
    dump_CurrentMaterialParam_json_RE2 = dump_CurrentMaterialParam_json_RE2,
    get_MasterMaterialData_RE2 = get_MasterMaterialData_RE2,

    get_MaterialParams_RE4 = get_MaterialParams_RE4,
    cache_AWFGS_json_files_RE4 = cache_AWFGS_json_files_RE4,
    update_MaterialParams_RE4 = update_MaterialParams_RE4,
    dump_DefaultMaterialParam_json_RE4 = dump_DefaultMaterialParam_json_RE4,
    dump_CurrentMaterialParam_json_RE4 = dump_CurrentMaterialParam_json_RE4,
    get_MasterMaterialData_RE4 = get_MasterMaterialData_RE4,
}
return AWFGS