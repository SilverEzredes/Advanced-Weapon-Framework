--/////////////////////////////////////--
local modName =  "Advanced Weapon Framework: Language Manager"

local modAuthor = "SilverEzredes"
local modUpdated = "10/05/2024"
local modVersion = "v3.4.60"
local modCredits = "praydog; alphaZomega"

--/////////////////////////////////////--
local AWF = require("AWFCore")
local hk = require("Hotkeys/Hotkeys")
local func = require("_SharedCore/Functions")
local ui = require("_SharedCore/Imgui")
local changed = false
local wc = false

local debugTable = {
    A_Name = "",
    B_Category = "",
    C_Detail = "",
}

local GUIMaster = sdk.get_managed_singleton("app.ropeway.gui.GUIMaster")
local InventoryManager = sdk.get_managed_singleton("app.ropeway.gamemastering.InventoryManager")
local InventoryBehavior = "app.ropeway.gui.NewInventoryBehavior"
local cached_AWFTXT_jsonPaths_RE2 = {}
local playerContext_RE2 = nil
local isPlayerInScene_RE2 = false
local presetName = "[Enter Preset Name Here]"
local font = imgui.load_font('NotoSansSC-Bold.otf', imgui.get_default_font_size()+2, {
    0x0020, 0x00FF, -- Basic Latin + Latin Supplement
    0x0400, 0x052F, -- Cyrillic + Cyrillic Supplement
    0x2000, 0x206F, -- General Punctuation
    0x3000, 0x30FF, -- CJK Symbols and Punctuations, Hiragana, Katakana
    0x31F0, 0x31FF, -- Katakana Phonetic Extensions
    0xFF00, 0xFFEF, -- Half-width characters
    0x4e00, 0x9FAF, -- CJK Ideograms
    0,
})
local font2 = imgui.load_font('NotoSansKR-Medium.ttf', imgui.get_default_font_size()+2, {
    0x0020, 0x00FF, -- Basic Latin + Latin Supplement
    0x1100, 0x11FF, -- Hangul Jamo
    0x2000, 0x206F, -- General Punctuation
    0x3130, 0x318F, -- Hangul Compatibility Jamo
    0xAC00, 0xD7AF, -- Hangul Syllables
    0,
})
local font3 = imgui.load_font('NotoKufiArabic-Medium.ttf', imgui.get_default_font_size()+5, {
    0x0020, 0x00FF, -- Basic Latin + Latin Supplement
    0x0600, 0x06FF, -- Arabic
    0x2000, 0x206F, -- General Punctuation
    0,
})
local font4 = imgui.load_font('NotoSansThai-Medium.ttf', imgui.get_default_font_size()+2, {
    0x0020, 0x00FF, -- Basic Latin + Latin Supplement
    0x0E00, 0x0E7F, -- Thai
    0x2000, 0x206F, -- General Punctuation
    0,
})
local GameLanguages = {
    [0]="JA",
    [1]="EN",
    [2]="FR",
    [3]="IT",
    [4]="DE",
    [5]="ES",
    [6]="RU",
    [7]="PL",
    [8]="NL",
    [9]="PT",
    [10]="PTBR",
    [11]="KO",
    [12]="ZHTW",
    [13]="ZHCN",
    [14]="FI",
    [15]="SV",
    [16]="DA",
    [17]="NO",
    [18]="CS",
    [19]="HU",
    [20]="SK",
    [21]="AR",
    [22]="TR",
    [23]="BG",
    [24]="EL",
    [25]="RO",
    [26]="TH",
    [27]="UK",
    [28]="VI",
    [29]="ID",
    [30]="Fiction",
    [31]="HI",
    [32]="ESLATAM",
    [33]="Max",
    [34]="Unknown",
}

local AWFTXT_default_settings = {
    show_AWFTXT_Editor = false,
    show_DetailTextType = true,
    isAutoDetectLanguage = true,
    isAutoUpdateDatabase = true,
    isInheritPresetName = false,
    currentSelectedLanguage = 0,
    isDebug = true,
    version = modVersion,
    databaseCountRE2R = RE2R_WeaponDataCount,
}

local AWFWeapons = {
    RE2_TextData = {},
}
AWFWeapons.RE2_TextData = require("AWFCore/AWFTXT/RE2R_LanguageData")

local AWFTXT_settings = hk.merge_tables({}, AWFTXT_default_settings) and hk.recurse_def_settings(json.load_file("AWF/AWF_Text/AWF_Text_ToolSettings.json") or {}, AWFTXT_default_settings)
local AWF_settings = hk.merge_tables({}, AWFWeapons) and hk.recurse_def_settings(json.load_file("AWF/AWF_Text/AWF_Text_Settings.json") or {}, AWFWeapons)

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: RE2R
local fontSlots_RE2 = {
    [0] = "Font Style-0",
    [1] = "Font Style-1",
    [2] = "Font Style-2",
    [3] = "Font Style-3",
    [4] = "Font Style-4",
    [5] = "Font Style-5",
    [6] = "Font Style-6",
    [7] = "Font Style-7",
    [8] = "Font Style-8",
    [9] = "Font Style-9",
    [10] = "Font Style-10",
    [11] = "Font Style-11",
    [12] = "Font Style-12",
    [13] = "Font Style-13",
    [14] = "Font Style-14",
    [15] = "Font Style-15",
    [16] = "Font Style-16",
}
local alignmentTypes_RE2 = {
    [0] = "Left Top [0]",
    [1] = "Center Top [1]",
    [2] = "Right Top [2]",
    [4] = "Left Center [4]",
    [5] = "Center Center [5]",
    [6] = "Right Center [6]",
    [8] = "Left Bottom [8]",
    [9] = "Center Bottom [9]",
    [10] = "Right Bottom [10]",
}
local regionTypes_RE2 = {
    [0] = "None [0]",
    [1] = "Horizontal [1]",
    [2] = "Vertical [2]",
    [3] = "Both [3]",
}
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
local function dump_Default_WeaponTextData_json_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponTextData = AWFWeapons.RE2_TextData[weapon.ID]
        
        if weaponTextData then
            json.dump_file("AWF/AWF_Text/".. weapon.Name .. "/" .. weapon.Name .. " Default".. ".json", weaponTextData)
            if AWFTXT_settings.isDebug then
                log.info("[AWF-TXT] [Default Text Data for " .. weapon.Name .. " dumped.]")
            end
        end
    end
end
local function clear_AWFTXT_json_cache_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        if AWF_settings.RE2_TextData[weapon.ID].isUpdated then
            local cacheKey = "AWF\\AWF_Text\\" .. weapon.Name
            cached_AWFTXT_jsonPaths_RE2[cacheKey] = nil

            if AWFTXT_settings.isDebug then
                log.info("[AWF-TXT] [Text Preset path cache cleared for " .. weapon.Name .. " | " .. weapon.ID .. " ]")
            end
        end
    end
end
local function cache_AWFTXT_json_files_RE2(weaponData)
    for _, weapon in pairs(weaponData) do
        local weaponParams = AWF_settings.RE2_TextData[weapon.ID]
        
        if weaponParams then
            local json_names = weaponParams.Presets or {}
            local cacheKey = "AWF\\AWF_Text\\" .. weapon.Name

            if not cached_AWFTXT_jsonPaths_RE2[cacheKey] then
                local path = [[AWF\\AWF_Text\\]] .. weapon.Name .. [[\\.*.json]]
                cached_AWFTXT_jsonPaths_RE2[cacheKey] =  fs.glob(path)
            end

            local json_filepaths = cached_AWFTXT_jsonPaths_RE2[cacheKey]
            
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

                        if AWFTXT_settings.isDebug then
                            log.info("[AWF-TXT] [Loaded " .. filepath .. " for "  .. weapon.Name .. "]")
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
                        if AWFTXT_settings.isDebug then
                            log.info("[AWF-TXT] [Removed " .. name .. " from " .. weapon.Name .. "]")
                        end
                        table.remove(json_names, i)
                    end
                end
            else
                if AWFTXT_settings.isDebug then
                    log.info("[AWF-TXT] [No AWF-TXT JSON files found.]")
                end
            end
        end
    end
end
local function set_TextStyle_RE2(textField, styleTable)
    local textColor = ValueType.new(sdk.find_type_definition("via.Color"))
    textField:set_Position(Vector3f.new(styleTable._Position[1], styleTable._Position[2], styleTable._Position[3]))
    textField:set_Rotation(Vector3f.new(styleTable._Rotation[1], styleTable._Rotation[2], styleTable._Rotation[3]))
    textField:set_FontSlot(styleTable._FontSlot)
    textField:set_FontSize(Vector2f.new(styleTable._FontSize.w, styleTable._FontSize.h))
    textField:set_PageAlignment(styleTable._PageAlignment)
    textField:set_LetterAlignment(styleTable._LetterAlignment)
    textField:set_LetterSpace(styleTable._LetterSpace)
    textField:set_LineSpace(styleTable._LineSpace)
    textField:set_AutoWrap(styleTable._AutoWrap)
    textField:set_ForceAutoWrap(styleTable._ForceAutoWrap)
    textField:set_AutoEraseHeadSpace(styleTable._AutoEraseHeadSpace)
    textField:set_AutoRegionFit(styleTable._AutoRegionFit)
    textField:set_AutoRTL(styleTable._AutoRTL)
    textField:set_AutoArabicLayout(styleTable._AutoArabicLayout)
    textField:set_Kerning(styleTable._Kerning)
    textField:set_Monospace(styleTable._Monospace)
    textField:set_VerticalLayout(styleTable._VerticalLayout)
    textField:set_Bold(styleTable._Bold)
    textField:set_Italic(styleTable._Italic)
    textColor.rgba = func.convert_rgba_to_AGBR(styleTable._Color)
    textField:set_Color(textColor)
    if styleTable.isInheritMainColor then
        textField:set_ColorTop(textColor)
        textField:set_ColorBottom(textColor)
    elseif not styleTable.isInheritMainColor then
        textColor.rgba = func.convert_rgba_to_AGBR(styleTable._ColorTop)
        textField:set_ColorTop(textColor)
        textColor.rgba = func.convert_rgba_to_AGBR(styleTable._ColorBottom)
        textField:set_ColorBottom(textColor)
    end
    textField:set_GlowEnable(styleTable._GlowEnable)
    textField:set_GlowInner(styleTable._GlowInner)
    textField:set_GlowKnockout(styleTable._GlowKnockout)
    textField:set_GlowBlurSize(Vector2f.new(styleTable._GlowBlurSize.w, styleTable._GlowBlurSize.h))
    textField:set_GlowStrength(styleTable._GlowStrength)
    textColor.rgba = func.convert_rgba_to_AGBR(styleTable._GlowColor)
    textField:set_GlowColor(textColor)
    textField:set_ShadowEnable(styleTable._ShadowEnable)
    textField:set_ShadowBlurSize(Vector2f.new(styleTable._ShadowBlurSize.w, styleTable._ShadowBlurSize.h))
    textField:set_ShadowStrength(styleTable._ShadowStrength)
    textField:set_ShadowRotation(styleTable._ShadowRotation)
    textField:set_ShadowDistance(styleTable._ShadowDistance)
    textField:set_ShadowDistanceZ(styleTable._ShadowDistanceZ)
    textColor.rgba = func.convert_rgba_to_AGBR(styleTable._ShadowColor)
    textField:set_ShadowColor(textColor)
end
local function manage_TextStyleAndMessage_RE2(guiElement, textData, textType)
    local languageIndex = AWF_settings.RE2_TextData.Languages[textData.current_language_indx]
    local text = textData[textType].Language[languageIndex]
    if textType == "Detail" then
        if func.table_contains(textData.custom_text_indx, textData.current_custom_indx) then
            text = textData[textType].Language_2[languageIndex]
        end
    end
    
    if AWFTXT_settings.isAutoDetectLanguage then
        text = textData[textType].Language[GameLanguages[AWFTXT_settings.currentSelectedLanguage]]
    end

    if ((text == nil) or (text == "")) or textData.isForceEN then
        text = textData[textType].Language.EN
    end

    guiElement:set_Message(text)
    set_TextStyle_RE2(guiElement, textData[textType].Style)
end
local function manage_InventoryGUIData_RE2(weaponData)
    if reframework.get_game_name() == "re2" then
        check_if_playerIsInScene_RE2()

        if isPlayerInScene_RE2 then
            local inventoryGUI = GUIMaster and GUIMaster:get_field("RefInventoryUI")
            
            if inventoryGUI then
                local isInventoryGUIDrawn = inventoryGUI:get_DrawSelf()

                if isInventoryGUIDrawn then
                    local playerInventorySlots = InventoryManager and InventoryManager:get_CurrentInventory()._Slots
                    playerInventorySlots = func.lua_get_array(playerInventorySlots, false)

                    local inventoryGUIComp = func.get_GameObjectComponent(inventoryGUI, InventoryBehavior)
                    local inventoryGUICurrentSlot = inventoryGUIComp:get_SlotBehavior().SelectSlotNo
                    local inventoryGUICaptionGUI_Name = inventoryGUIComp:get_CaptionBehavior():get_field("NameText")
                    local inventoryGUICaptionGUI_Category = inventoryGUIComp:get_CaptionBehavior():get_field("CategoryText")
                    local inventoryGUICaptionGUI_Detail = inventoryGUIComp:get_CaptionBehavior():get_field("DetailText")

                    -- if AWFTXT_settings.isDebug then
                    --     debugTable.A_Name = inventoryGUICaptionGUI_Name:get_Message()
                    --     debugTable.B_Category = inventoryGUICaptionGUI_Category:get_Message()
                    --     debugTable.C_Detail = inventoryGUICaptionGUI_Detail:get_Message()
                    --     json.dump_file("DEBUG/LanguageText.json", debugTable)
                    -- end

                    for _, weapon in pairs(weaponData) do
                        for i, slot in ipairs(playerInventorySlots) do
                            local slotIndex = slot:get_Index()
                            
                            if inventoryGUICurrentSlot == slotIndex then
                                local slotWeaponEnum = slot:get_WeaponType()
                                local slotWeaponCustom = slot:get_WeaponParts()
                                
                                if weapon.Enum == slotWeaponEnum then
                                    local textData = AWF_settings.RE2_TextData[weapon.ID]
                                    AWF_settings.RE2_TextData[weapon.ID].current_custom_indx = slotWeaponCustom
                                    --print(AWF_settings.RE2_TextData[weapon.ID].current_custom_indx)
                                    manage_TextStyleAndMessage_RE2(inventoryGUICaptionGUI_Name, textData, "Name")
                                    manage_TextStyleAndMessage_RE2(inventoryGUICaptionGUI_Category, textData, "Category")
                                    manage_TextStyleAndMessage_RE2(inventoryGUICaptionGUI_Detail, textData, "Detail")
                                end
                            end
                        end
                    end
                elseif not isInventoryGUIDrawn then
                    for _, weapon in pairs(weaponData) do
                        AWF_settings.RE2_TextData[weapon.ID].isUpdated = false
                    end
                end
            end
        end
    end
end
local function draw_AWFTXT_StyleEditor_GUI_RE2(textData, textType)
    imgui.begin_rect()
    imgui.spacing()
    imgui.indent(5)

    changed, textData[textType].Style._Bold = imgui.checkbox("Bold", textData[textType].Style._Bold); wc = wc or changed
    imgui.same_line()
    changed, textData[textType].Style._Italic = imgui.checkbox("Italic", textData[textType].Style._Italic); wc = wc or changed
    imgui.same_line()
    changed, textData[textType].Style._Monospace = imgui.checkbox("Monospace", textData[textType].Style._Monospace); wc = wc or changed
    imgui.same_line()
    changed, textData[textType].Style._Kerning = imgui.checkbox("Kerning", textData[textType].Style._Kerning); wc = wc or changed
    imgui.same_line()
    changed, textData[textType].Style._VerticalLayout = imgui.checkbox("Vertical", textData[textType].Style._VerticalLayout); wc = wc or changed
    changed, textData[textType].Style._FontSlot = imgui.combo("Font Style", textData[textType].Style._FontSlot, fontSlots_RE2); wc = wc or changed
    local fontSize = Vector2f.new(textData[textType].Style._FontSize.w, textData[textType].Style._FontSize.h)
    changed, fontSize = imgui.drag_float2("Font Size", fontSize, 1.0, 0.0, 200.0); wc = wc or changed
    textData[textType].Style._FontSize.w = fontSize.x
    textData[textType].Style._FontSize.h = fontSize.y
    imgui.spacing()

    changed, textData[textType].Style.isInheritMainColor = imgui.checkbox("Inherit Main Color", textData[textType].Style.isInheritMainColor); wc = wc or changed
    local textTypeMainColor = func.convert_rgba_to_vector4f(textData[textType].Style._Color[1], textData[textType].Style._Color[2], textData[textType].Style._Color[3], textData[textType].Style._Color[4])
    changed, textTypeMainColor = imgui.color_edit4("Main Color", textTypeMainColor); wc = wc or changed
    local R0, G0, B0, A0 = func.convert_vector4f_to_rgba(textTypeMainColor)
    textData[textType].Style._Color[1] = R0
    textData[textType].Style._Color[2] = G0
    textData[textType].Style._Color[3] = B0
    textData[textType].Style._Color[4] = A0
    local textTypeTopColor = func.convert_rgba_to_vector4f(textData[textType].Style._ColorTop[1], textData[textType].Style._ColorTop[2], textData[textType].Style._ColorTop[3], textData[textType].Style._ColorTop[4])
    changed, textTypeTopColor = imgui.color_edit4("Top Color", textTypeTopColor); wc = wc or changed
    local R1, G1, B1, A1 = func.convert_vector4f_to_rgba(textTypeTopColor)
    textData[textType].Style._ColorTop[1] = R1
    textData[textType].Style._ColorTop[2] = G1
    textData[textType].Style._ColorTop[3] = B1
    textData[textType].Style._ColorTop[4] = A1
    local textTypeBottomColor = func.convert_rgba_to_vector4f(textData[textType].Style._ColorBottom[1], textData[textType].Style._ColorBottom[2], textData[textType].Style._ColorBottom[3], textData[textType].Style._ColorBottom[4])
    changed, textTypeBottomColor = imgui.color_edit4("Bottom Color", textTypeBottomColor); wc = wc or changed
    local R2, G2, B2, A2 = func.convert_vector4f_to_rgba(textTypeBottomColor)
    textData[textType].Style._ColorBottom[1] = R2
    textData[textType].Style._ColorBottom[2] = G2
    textData[textType].Style._ColorBottom[3] = B2
    textData[textType].Style._ColorBottom[4] = A2
    
    imgui.spacing()
    
    changed, textData[textType].Style._PageAlignment = imgui.combo("Page Alignment", textData[textType].Style._PageAlignment, alignmentTypes_RE2); wc = wc or changed
    changed, textData[textType].Style._LetterAlignment = imgui.combo("Letter Alignment", textData[textType].Style._LetterAlignment, alignmentTypes_RE2); wc = wc or changed
    local position = Vector3f.new(textData[textType].Style._Position[1], textData[textType].Style._Position[2], textData[textType].Style._Position[3])
    changed, position = imgui.drag_float3("Position", position, 0.1, -200.0, 200.0); wc = wc or changed
    textData[textType].Style._Position[1] = position.x
    textData[textType].Style._Position[2] = position.y
    textData[textType].Style._Position[3] = position.z
    local rotation = Vector3f.new(textData[textType].Style._Rotation[1], textData[textType].Style._Rotation[2], textData[textType].Style._Rotation[3])
    changed, rotation = imgui.drag_float3("Rotation", rotation, 0.1, -200.0, 200.0); wc = wc or changed
    textData[textType].Style._Rotation[1] = rotation.x
    textData[textType].Style._Rotation[2] = rotation.y
    textData[textType].Style._Rotation[3] = rotation.z
    
    imgui.spacing()
    
    changed, textData[textType].Style._AutoWrap = imgui.checkbox("Auto Wrap", textData[textType].Style._AutoWrap); wc = wc or changed
    imgui.same_line()
    changed, textData[textType].Style._ForceAutoWrap = imgui.checkbox("Force Auto Wrap", textData[textType].Style._ForceAutoWrap); wc = wc or changed
    imgui.same_line()
    changed, textData[textType].Style._AutoEraseHeadSpace = imgui.checkbox("Auto Erase Head Space", textData[textType].Style._AutoEraseHeadSpace); wc = wc or changed
    changed, textData[textType].Style._AutoRTL = imgui.checkbox("Auto RTL  ", textData[textType].Style._AutoRTL); wc = wc or changed
    imgui.same_line()
    changed, textData[textType].Style._AutoArabicLayout = imgui.checkbox("Auto Arabic Layout", textData[textType].Style._AutoArabicLayout); wc = wc or changed
    changed, textData[textType].Style._AutoRegionFit = imgui.combo("Auto Region Fit", textData[textType].Style._AutoRegionFit, regionTypes_RE2); wc = wc or changed
    changed, textData[textType].Style._LetterSpace = imgui.drag_float("Letter Space", textData[textType].Style._LetterSpace, 0.01, 0.0, 20.0)
    changed, textData[textType].Style._LineSpace = imgui.drag_float("Line Space", textData[textType].Style._LineSpace, 0.01, 0.0, 20.0)

    imgui.spacing()

    changed, textData[textType].Style._GlowEnable = imgui.checkbox("Enable Glow", textData[textType].Style._GlowEnable); wc = wc or changed
    imgui.same_line()
    changed, textData[textType].Style._GlowInner = imgui.checkbox("Inner Glow", textData[textType].Style._GlowInner); wc = wc or changed
    imgui.same_line()
    changed, textData[textType].Style._GlowKnockout = imgui.checkbox("Knockout Glow", textData[textType].Style._GlowKnockout); wc = wc or changed
    changed, textData[textType].Style._GlowStrength = imgui.drag_float("Glow Strength", textData[textType].Style._GlowStrength, 0.01, 0.0, 20.0)
    local glowBlurSize = Vector2f.new(textData[textType].Style._GlowBlurSize.w, textData[textType].Style._GlowBlurSize.h)
    changed, glowBlurSize = imgui.drag_float2("Glow Blur Size", glowBlurSize, 1.0, 0.0, 200.0); wc = wc or changed
    textData[textType].Style._GlowBlurSize.w = glowBlurSize.x
    textData[textType].Style._GlowBlurSize.h = glowBlurSize.y
    local textTypeGlowColor = func.convert_rgba_to_vector4f(textData[textType].Style._GlowColor[1], textData[textType].Style._GlowColor[2], textData[textType].Style._GlowColor[3], textData[textType].Style._GlowColor[4])
    changed, textTypeGlowColor = imgui.color_edit4("Glow Color", textTypeGlowColor); wc = wc or changed
    local R3, G3, B3, A3 = func.convert_vector4f_to_rgba(textTypeGlowColor)
    textData[textType].Style._GlowColor[1] = R3
    textData[textType].Style._GlowColor[2] = G3
    textData[textType].Style._GlowColor[3] = B3
    textData[textType].Style._GlowColor[4] = A3

    imgui.spacing()

    changed, textData[textType].Style._ShadowEnable = imgui.checkbox("Enable Shadow", textData[textType].Style._ShadowEnable); wc = wc or changed
    changed, textData[textType].Style._ShadowStrength = imgui.drag_float("Shadow Strength", textData[textType].Style._ShadowStrength, 0.01, 0.0, 20.0)
    local shadowBlurSize = Vector2f.new(textData[textType].Style._ShadowBlurSize.w, textData[textType].Style._ShadowBlurSize.h)
    changed, shadowBlurSize = imgui.drag_float2("Shadow Blur Size", shadowBlurSize, 1.0, 0.0, 200.0); wc = wc or changed
    textData[textType].Style._ShadowBlurSize.w = shadowBlurSize.x
    textData[textType].Style._ShadowBlurSize.h = shadowBlurSize.y
    changed, textData[textType].Style._ShadowRotation = imgui.drag_float("Shadow Rotation", textData[textType].Style._ShadowRotation, 0.01, 0.0, 180.0)
    changed, textData[textType].Style._ShadowDistance = imgui.drag_float("Shadow Distance", textData[textType].Style._ShadowDistance, 0.01, 0.0, 200.0)
    changed, textData[textType].Style._ShadowDistanceZ = imgui.drag_float("Shadow Z Distance", textData[textType].Style._ShadowDistanceZ, 0.01, 0.0, 200.0)
    local textTypeShadowColor = func.convert_rgba_to_vector4f(textData[textType].Style._ShadowColor[1], textData[textType].Style._ShadowColor[2], textData[textType].Style._ShadowColor[3], textData[textType].Style._ShadowColor[4])
    changed, textTypeShadowColor = imgui.color_edit4("Shadow Color", textTypeShadowColor); wc = wc or changed
    local R4, G4, B4, A4 = func.convert_vector4f_to_rgba(textTypeShadowColor)
    textData[textType].Style._ShadowColor[1] = R4
    textData[textType].Style._ShadowColor[2] = G4
    textData[textType].Style._ShadowColor[3] = B4
    textData[textType].Style._ShadowColor[4] = A4

    imgui.indent(-5)
    imgui.spacing()
    imgui.end_rect(1)
end
local function draw_AWFTXTEditor_GUI_RE2(weaponOrder)
    if imgui.begin_window("Advanced Weapon Framework: Text Editor") then
        imgui.begin_rect()
        local textColor = {0, 255, 255, 255}
        local textColor2 = {255, 0, 0, 255}
        imgui.text_colored("  [ " .. ui.draw_line("=", 35) ..  " | " .. ui.draw_line("=", 35) .. " ] ", func.convert_rgba_to_AGBR(textColor))
        for _, weaponName in ipairs(weaponOrder) do
            local weapon = AWF.AWF_settings.RE2.Weapons[weaponName]
            
            if imgui.tree_node(weapon.Name) then
                imgui.begin_rect()
                imgui.spacing()
                imgui.indent(5)
                if imgui.button("Reset to Defaults") then
                    AWF_settings.RE2_TextData[weapon.ID] = hk.recurse_def_settings({}, AWFWeapons.RE2_TextData[weapon.ID]); wc = wc or changed
                    clear_AWFTXT_json_cache_RE2(AWF.AWF_settings.RE2.Weapons)
                    cache_AWFTXT_json_files_RE2(AWF.AWF_settings.RE2.Weapons)
                end
                if AWFTXT_settings.show_DetailTextType then
                    imgui.same_line()
                    if func.table_contains(AWF_settings.RE2_TextData[weapon.ID].custom_text_indx, AWF_settings.RE2_TextData[weapon.ID].current_custom_indx) then
                        imgui.text("[ Detail Text Type: ")
                        imgui.same_line()
                        imgui.text_colored("2", func.convert_rgba_to_AGBR(textColor))
                        imgui.same_line()
                        imgui.text(" ]")
                    elseif not func.table_contains(AWF_settings.RE2_TextData[weapon.ID].custom_text_indx, AWF_settings.RE2_TextData[weapon.ID].current_custom_indx) then
                        imgui.text("[ Detail Text Type:")
                        imgui.same_line()
                        imgui.text_colored("1", func.convert_rgba_to_AGBR(textColor2))
                        imgui.same_line()
                        imgui.text("]")
                    end
                end
                changed, AWF_settings.RE2_TextData[weapon.ID].current_param_indx = imgui.combo("Preset", AWF_settings.RE2_TextData[weapon.ID].current_param_indx or 1, AWF_settings.RE2_TextData[weapon.ID].Presets); wc = wc or changed
                func.tooltip("Select a file from the dropdown menu to load the text settings from that file.")
                if changed then
                    local selected_preset = AWF_settings.RE2_TextData[weapon.ID].Presets[AWF_settings.RE2_TextData[weapon.ID].current_param_indx]
                    local json_filepath = [[AWF\\AWF_Text\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                    local temp_params = json.load_file(json_filepath)
                    
                    if AWFTXT_settings.isDebug then
                        log.info("[AWF-TXT] [--------------------- [Manual Preset Loader] Loaded '" .. selected_preset .. "' for " .. weapon.ID .. "]")
                    end
    
                    if AWFTXT_settings.isInheritPresetName then
                        presetName = selected_preset
                    end
    
                    temp_params.Weapon_Presets = nil
                    temp_params.current_param_indx = nil
    
                    for key, value in pairs(temp_params) do
                        AWF_settings.RE2_TextData[weapon.ID][key] = value
                    end
                    clear_AWFTXT_json_cache_RE2(AWF.AWF_settings.RE2.Weapons)
                    cache_AWFTXT_json_files_RE2(AWF.AWF_settings.RE2.Weapons)
                end
                imgui.push_id(_)
                changed, presetName = imgui.input_text("", presetName); wc = wc or changed
                imgui.pop_id()
                imgui.same_line()
                if imgui.button("Save Preset") then
                    json.dump_file("AWF/AWF_Text/".. weapon.Name .. "/" .. presetName .. ".json", AWF_settings.RE2_TextData[weapon.ID])
                    log.info("[AWF-TXT] [Custom " .. weapon.Name ..  " text settings saved with the preset name " .. presetName .. " ]")
                    AWF_settings.RE2_TextData[weapon.ID].isUpdated = true
                    clear_AWFTXT_json_cache_RE2(AWF.AWF_settings.RE2.Weapons)
                    cache_AWFTXT_json_files_RE2(AWF.AWF_settings.RE2.Weapons)
                end
                func.tooltip("Save the current parameters of the " .. weapon.Name .. " to " .. presetName .. ".json found in [RESIDENT EVIL 2  BIOHAZARD RE2/reframework/data/AWF/AWF_Text/".. weapon.Name .. "]")

                imgui.spacing()

                changed, AWF_settings.RE2_TextData[weapon.ID].current_language_indx = imgui.combo("Language", AWF_settings.RE2_TextData[weapon.ID].current_language_indx or 1, AWF_settings.RE2_TextData.Languages); wc = wc or changed
                changed, AWF_settings.RE2_TextData[weapon.ID].isForceEN = imgui.checkbox("Force English", AWF_settings.RE2_TextData[weapon.ID].isForceEN); wc = wc or changed
                
                imgui.spacing()

                if AWF_settings.RE2_TextData[weapon.ID].current_language_indx == 12 then
                    imgui.push_font(font2)
                elseif AWF_settings.RE2_TextData[weapon.ID].current_language_indx == 13 then
                    imgui.push_font(font3)
                elseif AWF_settings.RE2_TextData[weapon.ID].current_language_indx == 14 then
                    imgui.push_font(font4)
                else
                    imgui.push_font(font)
                end

                changed, AWF_settings.RE2_TextData[weapon.ID].Name.Language[AWF_settings.RE2_TextData.Languages[AWF_settings.RE2_TextData[weapon.ID].current_language_indx]] = imgui.input_text("Name", AWF_settings.RE2_TextData[weapon.ID].Name.Language[AWF_settings.RE2_TextData.Languages[AWF_settings.RE2_TextData[weapon.ID].current_language_indx]]); wc = wc or changed
                changed, AWF_settings.RE2_TextData[weapon.ID].Category.Language[AWF_settings.RE2_TextData.Languages[AWF_settings.RE2_TextData[weapon.ID].current_language_indx]] = imgui.input_text("Category", AWF_settings.RE2_TextData[weapon.ID].Category.Language[AWF_settings.RE2_TextData.Languages[AWF_settings.RE2_TextData[weapon.ID].current_language_indx]]); wc = wc or changed
                changed, AWF_settings.RE2_TextData[weapon.ID].Detail.Language[AWF_settings.RE2_TextData.Languages[AWF_settings.RE2_TextData[weapon.ID].current_language_indx]] = imgui.input_text_multiline("Detail Type-1", AWF_settings.RE2_TextData[weapon.ID].Detail.Language[AWF_settings.RE2_TextData.Languages[AWF_settings.RE2_TextData[weapon.ID].current_language_indx]]); wc = wc or changed
                if AWF_settings.RE2_TextData[weapon.ID].Detail.Language_2 then
                    changed, AWF_settings.RE2_TextData[weapon.ID].Detail.Language_2[AWF_settings.RE2_TextData.Languages[AWF_settings.RE2_TextData[weapon.ID].current_language_indx]] = imgui.input_text_multiline("Detail Type-2", AWF_settings.RE2_TextData[weapon.ID].Detail.Language_2[AWF_settings.RE2_TextData.Languages[AWF_settings.RE2_TextData[weapon.ID].current_language_indx]]); wc = wc or changed
                end
                imgui.pop_font()
                if imgui.tree_node("Name Style Editor") then
                    draw_AWFTXT_StyleEditor_GUI_RE2(AWF_settings.RE2_TextData[weapon.ID], "Name")
                    imgui.tree_pop()
                end
                if imgui.tree_node("Category Style Editor") then
                    draw_AWFTXT_StyleEditor_GUI_RE2(AWF_settings.RE2_TextData[weapon.ID], "Category")
                    imgui.tree_pop()
                end
                if imgui.tree_node("Detail Style Editor") then
                    draw_AWFTXT_StyleEditor_GUI_RE2(AWF_settings.RE2_TextData[weapon.ID], "Detail")
                    imgui.tree_pop()
                end

                imgui.indent(-5)
                imgui.spacing()
                imgui.end_rect(2)
                imgui.tree_pop()
            end
            
            imgui.text_colored("  " .. ui.draw_line("-", 100) .."  ", func.convert_rgba_to_AGBR(textColor))
        end
        imgui.text_colored("  [ " .. ui.draw_line("=", 35) ..  " | " .. ui.draw_line("=", 35) .. " ] ", func.convert_rgba_to_AGBR(textColor))
        imgui.end_rect(1)
        imgui.end_window()
    end
end
local function draw_AWFTXTPreset_GUI_RE2(weaponOrder)
    imgui.spacing()
    local textColor = {255,255,255,255}
    imgui.text_colored(" " .. ui.draw_line("=", 60), func.convert_rgba_to_AGBR(textColor))

    for _, weaponName in ipairs(weaponOrder) do
        local weapon = AWF.AWF_settings.RE2.Weapons[weaponName]
        
        if weapon then
            changed, AWF_settings.RE2_TextData[weapon.ID].current_param_indx = imgui.combo(weapon.Name, AWF_settings.RE2_TextData[weapon.ID].current_param_indx or 1, AWF_settings.RE2_TextData[weapon.ID].Presets); wc = wc or changed
            func.tooltip("Select a file from the dropdown menu to load the text settings from that file.")
            if changed then
                local selected_preset = AWF_settings.RE2_TextData[weapon.ID].Presets[AWF_settings.RE2_TextData[weapon.ID].current_param_indx]
                local json_filepath = [[AWF\\AWF_Text\\]] .. weapon.Name .. [[\\]] .. selected_preset .. [[.json]]
                local temp_params = json.load_file(json_filepath)
                
                if AWFTXT_settings.isDebug then
                    log.info("[AWF-TXT] [--------------------- [Manual Preset Loader] Loaded '" .. selected_preset .. "' for " .. weapon.ID .. "]")
                end

                if AWFTXT_settings.isInheritPresetName then
                    presetName = selected_preset
                end

                temp_params.Weapon_Presets = nil
                temp_params.current_param_indx = nil

                for key, value in pairs(temp_params) do
                    AWF_settings.RE2_TextData[weapon.ID][key] = value
                end
                clear_AWFTXT_json_cache_RE2(AWF.AWF_settings.RE2.Weapons)
                cache_AWFTXT_json_files_RE2(AWF.AWF_settings.RE2.Weapons)
            end
            imgui.spacing()
        end
    end
    if changed or wc then
        json.dump_file("AWF/AWF_Text/AWF_Text_ToolSettings.json", AWFTXT_settings)
        json.dump_file("AWF/AWF_Text/AWF_Text_Settings.json", AWF_settings)
    end
    imgui.text_colored(ui.draw_line("=", 60), func.convert_rgba_to_AGBR(textColor))
end
local function draw_AWFTXT_GUI_RE2(weaponData)
    if reframework.get_game_name() == "re2" then
        if imgui.tree_node(modName) then
            imgui.begin_rect()
            imgui.spacing()
            imgui.indent(5)
            if imgui.button("Reset to Defaults") then
                AWFTXT_settings = hk.recurse_def_settings({}, AWFTXT_default_settings); wc = wc or changed
                AWF_settings = hk.recurse_def_settings({}, AWFWeapons); wc = wc or changed
                for _, weapon in pairs(weaponData) do
                    AWF_settings.RE2_TextData[weapon.ID].isUpdated = true
                end
                clear_AWFTXT_json_cache_RE2(AWF.AWF_settings.RE2.Weapons)
                cache_AWFTXT_json_files_RE2(AWF.AWF_settings.RE2.Weapons)
            end
            func.tooltip("Reset every parameter.")
            imgui.same_line()
            changed, AWFTXT_settings.show_AWFTXT_Editor = imgui.checkbox("Open AWF Text Editor", AWFTXT_settings.show_AWFTXT_Editor)
            func.tooltip("Show/Hide the AWF Text Editor.")

            if not AWFTXT_settings.show_AWFTXT_Editor or imgui.begin_window("Advanced Weapon Framework: Text Editor", true, 0) == false  then
                AWFTXT_settings.show_AWFTXT_Editor = false
            else
                imgui.spacing()
                imgui.indent()
    
                draw_AWFTXTEditor_GUI_RE2(AWF.AWF_settings.RE2.Weapon_Order)
    
                imgui.unindent()
                imgui.end_window()
            end
            
            draw_AWFTXTPreset_GUI_RE2(AWF.AWF_settings.RE2.Weapon_Order)

            if imgui.tree_node("AWF:TXT Settings") then
                imgui.begin_rect()
                imgui.spacing()
                imgui.indent(5)

                changed, AWFTXT_settings.isDebug = imgui.checkbox("Debug Mode", AWFTXT_settings.isDebug); wc = wc or changed
                func.tooltip("Enable/Disable debug mode. When enabled, AWF:TXT will log significantly more information in the 're2_framework_log.txt' file, located in the game's root folder.\nLeave this on if you don't know what you are doing.")
                changed, AWFTXT_settings.isAutoUpdateDatabase = imgui.checkbox("Auto Update Database", AWFTXT_settings.isAutoUpdateDatabase); wc = wc or changed
                func.tooltip("If enabled AWF:TXT will automatically use the 'Reset to Defaults' option, when the AWF database is updated.")
                changed, AWFTXT_settings.isAutoDetectLanguage = imgui.checkbox("Auto Detect Language", AWFTXT_settings.isAutoDetectLanguage); wc = wc or changed
                func.tooltip("If enabled AWF:TXT will auto detect the current display language.")
                changed, AWFTXT_settings.isInheritPresetName = imgui.checkbox("Inherit Preset Name", AWFTXT_settings.isInheritPresetName); wc = wc or changed
                func.tooltip("If enabled the '[Enter Preset Name Here]' text in the Text Editor will be replaced by the name of the last loaded preset.")

                if imgui.tree_node("Credits") then
                    imgui.text(modCredits .. " ")
                    imgui.tree_pop()
                end

                imgui.indent(-5)
                imgui.spacing()
                imgui.end_rect(2)
                imgui.tree_pop()
            end

            imgui.spacing()
            ui.button_n_colored_txt("Current Version:", modVersion .. " | " .. modUpdated, func.convert_rgba_to_AGBR(0, 255, 0, 255))
            imgui.same_line()
            imgui.text("| by " .. modAuthor .. " ")
            
            if changed or wc then
                json.dump_file("AWF/AWF_Text/AWF_Text_ToolSettings.json", AWFTXT_settings)
                json.dump_file("AWF/AWF_Text/AWF_Text_Settings.json", AWF_settings)
            end

            imgui.indent(-5)
            imgui.spacing()
            imgui.end_rect(1)
            imgui.tree_pop()
        end
    end
end
local function auto_DatabaseUpdater_RE2(currModVersion, savedModVersion, isAutoUpdate, currCount, savedCount, weaponData)
    if currCount ~= savedCount and isAutoUpdate then
        AWFTXT_settings = hk.recurse_def_settings({}, AWFTXT_default_settings)
        AWF_settings = hk.recurse_def_settings({}, AWFWeapons)
        json.dump_file("AWF/AWF_Text/AWF_Text_ToolSettings.json", AWFTXT_default_settings)
        json.dump_file("AWF/AWF_Text/AWF_Text_Settings.json", AWFWeapons)
        for _, weapon in pairs(weaponData) do
            AWF_settings.RE2_TextData[weapon.ID].isUpdated = true
        end
        clear_AWFTXT_json_cache_RE2(AWF.AWF_settings.RE2.Weapons)
        cache_AWFTXT_json_files_RE2(AWF.AWF_settings.RE2.Weapons)
        log.info("[Auto Updater] [ " .. modName .. " database updated from (" .. savedModVersion .. ") to (" .. currModVersion .. ") | Database Count Changed from (" .. savedCount .. ") to (" .. currCount .. ") ]")
    end
end

if reframework.get_game_name() == "re2" then
    dump_Default_WeaponTextData_json_RE2(AWF.AWF_settings.RE2.Weapons)
    cache_AWFTXT_json_files_RE2(AWF.AWF_settings.RE2.Weapons)
    sdk.hook(sdk.find_type_definition("via.gui.GUISystem"):get_method("get_MessageLanguage()"),
    function(args)
    end,
    function (retval)
        AWFTXT_settings.currentSelectedLanguage = sdk.to_int64(retval)
        return retval
    end)
end
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: On Frame
re.on_frame(function ()
    if reframework.get_game_name() == "re2" then
        changed = false
        wc = false
        auto_DatabaseUpdater_RE2(modVersion, AWFTXT_settings.version, AWFTXT_settings.isAutoUpdateDatabase, RE2R_WeaponDataCount, AWFTXT_settings.databaseCountRE2R, AWF.AWF_settings.RE2.Weapons)
        manage_InventoryGUIData_RE2(AWF.AWF_settings.RE2.Weapons)
    end
end)

--MARK: On Draw UI
re.on_draw_ui(function ()
    if reframework.get_game_name() == "re2" then
        draw_AWFTXT_GUI_RE2(AWF.AWF_settings.RE2.Weapons)
    end
end)