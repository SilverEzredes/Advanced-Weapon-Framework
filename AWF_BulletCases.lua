--/////////////////////////////////////--
local modName =  "Advanced Weapon Framework: Bullet Cases"

local modAuthor = "SilverEzredes"
local modUpdated = "09/08/2024"
local modVersion = "v3.3.40"
local modCredits = "praydog; alphaZomega"

--/////////////////////////////////////--
local hk = require("Hotkeys/Hotkeys")
local func = require("_SharedCore/Functions")
local ui = require("_SharedCore/Imgui")
local changed = false
local wc = false

local scene = func.get_CurrentScene()
local bulletCaseManager = sdk.get_managed_singleton(sdk.game_namespace("BulletCaseManager"))
local bulletCaseCatalog = "BulletCaseCatalog"
local bulletCaseCatalogRegister = "chainsaw.BulletCaseCatalogRegister"

local AWFBC_default_settings = {
    isUpdated = false,
    RE4 = {
        caseLifeTime = 5.0,
        caseHandgun = {
            poolCap = 15,
        },
        caseShotgun = {
            poolCap = 10,
        },
        caseRifle = {
            poolCap = 20,
        },
        caseMag = {
            poolCap = 6,
        },
    },
}

local AWFBC_settings = hk.merge_tables({}, AWFBC_default_settings) and hk.recurse_def_settings(json.load_file("AWF/AWFBC_Settings.json") or {}, AWFBC_default_settings)
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--MARK: RE4R
local function manage_bulletCaseData_RE4()
    bulletCaseManager.BulletCase_LifeTime = AWFBC_settings.RE4.caseLifeTime
    if AWFBC_settings.isUpdated then
        local bc_Catalog = scene:call("findGameObject(System.String)", bulletCaseCatalog)

        if bc_Catalog then
            local bulletCaseCatalogRegisterComp = func.get_GameObjectComponent(bc_Catalog, bulletCaseCatalogRegister)

            if bulletCaseCatalogRegisterComp then
                local bulletCaseCatalog_Data = bulletCaseCatalogRegisterComp._BulletCaseCatalogUserData._DataTable

                for i, bulletCaseTypes in pairs (bulletCaseCatalog_Data) do
                    if i == 0 then
                        bulletCaseTypes._PoolCapacity = AWFBC_settings.RE4.caseHandgun.poolCap
                    elseif i == 1 then
                        bulletCaseTypes._PoolCapacity = AWFBC_settings.RE4.caseShotgun.poolCap
                    elseif i == 2 then
                        bulletCaseTypes._PoolCapacity = AWFBC_settings.RE4.caseRifle.poolCap
                    elseif i == 3 then
                        bulletCaseTypes._PoolCapacity = AWFBC_settings.RE4.caseMag.poolCap
                    end
                end
                bulletCaseCatalogRegisterComp:registerCatalog()
            end
        end
        AWFBC_settings.isUpdated = false
    end
end

local function draw_AWFBC_GUI_RE4()
    if imgui.tree_node(modName) then
        imgui.begin_rect()
        imgui.spacing()
        imgui.indent(5)
        if imgui.button("Reset to Defaults") then
            wc = true
            AWFBC_settings = hk.recurse_def_settings({}, AWFBC_default_settings); wc = wc or changed
        end
        func.tooltip("Reset every parameter.")
        
        changed, AWFBC_settings.RE4.caseLifeTime = imgui.drag_float("Bullet Case Life Time ", AWFBC_settings.RE4.caseLifeTime, 1.0, 0.0, 10000.0); wc = wc or changed
        func.tooltip("The in-game time until the cases disappear. This affects all case types.")
        imgui.spacing()
        changed, AWFBC_settings.RE4.caseHandgun.poolCap = imgui.drag_int("Handgun Case Limit", AWFBC_settings.RE4.caseHandgun.poolCap, 1, 0, 1000); wc = wc or changed
        changed, AWFBC_settings.RE4.caseShotgun.poolCap = imgui.drag_int("Shotgun Case Limit", AWFBC_settings.RE4.caseShotgun.poolCap, 1, 0, 1000); wc = wc or changed
        changed, AWFBC_settings.RE4.caseRifle.poolCap = imgui.drag_int("Rifle Case Limit", AWFBC_settings.RE4.caseRifle.poolCap, 1, 0, 1000); wc = wc or changed
        changed, AWFBC_settings.RE4.caseMag.poolCap = imgui.drag_int("Magnum Case Limit", AWFBC_settings.RE4.caseMag.poolCap, 1, 0, 1000); wc = wc or changed

        ui.button_n_colored_txt("Current Version:", modVersion .. " | " .. modUpdated, func.convert_rgba_to_AGBR(0, 255, 0, 255))
        imgui.same_line()
        imgui.text("| by " .. modAuthor .. " ")
        
        if changed or wc then
            json.dump_file("AWF/AWFBC_Settings.json", AWFBC_settings)
            AWFBC_settings.isUpdated = true
            changed = false
            wc = false
        end

        imgui.spacing()
        imgui.indent(-5)
        imgui.spacing()
        imgui.end_rect(1)
        imgui.tree_pop()
    end
end
--MARK:On Frame
re.on_frame(function ()
    manage_bulletCaseData_RE4()
end)
--MARK:On UI Draw
re.on_draw_ui(function ()
    draw_AWFBC_GUI_RE4()
end)