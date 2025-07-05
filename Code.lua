-- Code.lua: Steam Deck ElvUI Installer with CVars and Plater Import

local format = string.format
local ReloadUI = ReloadUI
local StopMusic = StopMusic
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata

local addon, ns = ...
local Version = GetAddOnMetadata(addon, "Version")
local MyPluginName = "Steam Deck Installer"

local E, L, V, P, G = unpack(ElvUI)
local EP = LibStub("LibElvUIPlugin-1.0")
local mod = E:NewModule(MyPluginName, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

-- Default toggle settings
E.db["steamDeckInstaller"] = E.db["steamDeckInstaller"] or {
    disableBags = true,
}

-- Function to import Plater profile from string
local function ImportPlaterProfile()
    if not Plater then
        print("|cffff0000Plater is not loaded.|r")
        return
    end

    local exportString = [[
^1^SPlaterDatabase^T^SsavedRevision^S54102^Sversion^SPlater-v54102-3-g7ac9ac3^Sprofiles^T^SSteamDeckPlater^T...
    ]]

    if Plater.ImportProfileFromString then
        Plater.ImportProfileFromString(exportString)
        print("|cff4beb2cPlater profile imported. Please /reload.|r")
    else
        print("|cffff0000Unable to import Plater profile.|r")
    end
end

-- Disable ElvUI bags if a conflicting addon is detected
local function DisableElvUIBagModule()
    if not E.db["steamDeckInstaller"].disableBags then return end

    local bagAddons = {"Baganator", "Bagnon", "AdiBags", "ArkInventory", "Inventorian", "Combuctor"}
    for _, addonName in ipairs(bagAddons) do
        if IsAddOnLoaded(addonName) or _G[addonName] then
            print(format("|cffff0000%s detected. Disabling ElvUI bags module.|r", addonName))
            E.private.bags.enable = false
            return
        end
    end

    -- Prefer ConsoleBags if present
    if IsAddOnLoaded("ConsoleBags") or _G["ConsoleBags"] then
        print("|cffff9900ConsoleBags detected. Disabling ElvUI bags module to ensure compatibility.|r")
        E.private.bags.enable = false
        return
    end
end

-- Apply ConsolePort settings if loaded
local function ApplyConsolePortTweaks()
    if not IsAddOnLoaded("ConsolePort") then return end

    -- Example tweak: widen unitframe clickable area for gamepad navigation
    if E.db.unitframe then
        E.db.unitframe.targetOnMouseDown = true
        E.db.unitframe.smartRaidFilter = false
    end

    -- Optional CVars or ElvUI settings optimized for ConsolePort users
    SetCVar("autoInteract", 1)
    print("|cff4beb2cConsolePort detected. Applying controller-friendly tweaks.|r")
end

-- Setup layout and apply settings
local function SetupLayout()
    E.data:SetProfile("SteamDeckProfile")

    -- Detect and handle bag addon conflicts
    DisableElvUIBagModule()

    -- ConsolePort tweaks
    ApplyConsolePortTweaks()

    -- Apply E.private settings
    E.private["actionbar"]["masque"]["actionbars"] = true
    E.private["actionbar"]["masque"]["petBar"] = true
    E.private["actionbar"]["masque"]["stanceBar"] = true

    -- (rest of your existing SetupLayout content remains unchanged)

    -- Import Plater
    ImportPlaterProfile()

    PluginInstallStepComplete.message = "Steam Deck Layout Applied"
    PluginInstallStepComplete:Show()
end

-- Add a config panel to ElvUI options
local function InsertOptions()
    E.Options.args[MyPluginName] = {
        order = 100,
        type = "group",
        name = format("|cff4beb2c%s|r", MyPluginName),
        args = {
            header1 = {
                order = 1,
                type = "header",
                name = "Steam Deck Installer",
            },
            description1 = {
                order = 2,
                type = "description",
                name = "This addon installs the Steam Deck layout for ElvUI and imports a Plater profile.",
            },
            installButton = {
                order = 4,
                type = "execute",
                name = "Reinstall Layout",
                desc = "Re-run the layout installer for this character.",
                func = function()
                    E:GetModule("PluginInstaller"):Queue(InstallerData)
                    E:ToggleOptions()
                end,
            },
            importPlater = {
                order = 5,
                type = "execute",
                name = "Reimport Plater Profile",
                desc = "Manually re-import the Plater profile if needed.",
                func = function()
                    ImportPlaterProfile()
                end,
            },
            toggleHeader = {
                order = 6,
                type = "header",
                name = "Conflict Detection Settings",
            },
            disableBags = {
                order = 7,
                type = "toggle",
                name = "Auto-disable Bags Module",
                get = function() return E.db.steamDeckInstaller.disableBags end,
                set = function(_, val) E.db.steamDeckInstaller.disableBags = val end,
            },
            version = {
                order = 20,
                type = "description",
                name = function()
                    return format("Addon Version: |cffffd200%s|r", Version or "unknown")
                end,
            },
        },
    }
end

-- Dummy installer setup (add real page steps if needed)
local InstallerData = { Pages = {}, StepTitles = {} }
function mod:Initialize() EP:RegisterPlugin(addon, function() end) end
    -- Register slash command
    SLASH_SDUI1 = "/sdui"
    SlashCmdList["SDUI"] = function(msg)
        msg = msg:lower()
        if msg == "install" then
            if E:GetModule("PluginInstaller") then
                E:GetModule("PluginInstaller"):Queue(InstallerData)
            end
        else
            print("|cff4beb2cSteam Deck UI|r: Type |cffffd200/sdui install|r to reinstall the layout.")
        end
    end

    EP:RegisterPlugin(addon, InsertOptions)
E:RegisterModule(mod:GetName())
