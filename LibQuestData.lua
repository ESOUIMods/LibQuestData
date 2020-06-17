--[[

LibQuestData
by Sharlikran
https://sharlikran.github.io/

--]]

-- Init
local lib = _G["LibQuestData"]

-- Libraries
local LMP = LibMapPins
local GPS = LibGPS2

-- Default table
local quest_data_index_default = {
    [lib.quest_data_index.quest_name]   = "",
    -- [lib.quest_data_index.quest_giver]  = "", Depreciated
    [lib.quest_data_index.quest_type]   = -1, -- Undefined
    [lib.quest_data_index.quest_repeat]  = -1, -- Undefined
    [lib.quest_data_index.game_api]     = 100003, -- 100003 means unverified
    [lib.quest_data_index.quest_line]    = 10000, -- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
    [lib.quest_data_index.quest_number]  = 10000, -- Quest Number In QuestLine (10000 = not assigned/not verified)
    [lib.quest_data_index.quest_series]  = 0, -- None = 0, Cadwell's Almanac = 1, Undaunted = 2, AD = 3, DC = 4, EP = 5
}

local quest_map_pin_index_default = {
    [lib.quest_map_pin_index.local_x] = -10, -- GetMapPlayerPosition() << -10 = Undefined >>
    [lib.quest_map_pin_index.local_y] = -10, -- GetMapPlayerPosition() << -10 = Undefined >>
    [lib.quest_map_pin_index.global_x]   = -10, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
    [lib.quest_map_pin_index.global_y]   = -10, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
    [lib.quest_map_pin_index.quest_id]   = -1, -- -1 Unknown, Quest ID i.e. 6404 for "The Dragonguard"
    [lib.quest_map_pin_index.world_x]     =    -10, -- WorldX 3D Location << -10 = Undefined >>
    [lib.quest_map_pin_index.world_y]     =    -10, -- WorldY 3D Location << -10 = Undefined >>
    [lib.quest_map_pin_index.world_z]     =    -10, -- WorldZ 3D Location << -10 = Undefined >>
    [lib.quest_map_pin_index.quest_giver] =    -1, -- Arbitrary number pointing to an NPC Name 81004, "Abnur Tharn"  << -1 = Undefined >>
}

-- Function to check for empty table
function internal:is_empty_or_nil(t)
    if not t then return true end
    if type(t) == "table" then
        if next(t) == nil then
            return true
        else
            return false
        end
    elseif type(t) == "string" then
        if t == nil then
            return true
        elseif t == "" then
            return true
        else
            return false
        end
    elseif type(t) == "nil" then
        return true
    end
end

function internal:is_nil(t)
    if t == nil then
        return true
    else
        return false
    end
end

function internal:is_in(search_value, search_table)
    for k, v in pairs(search_table) do
        if search_value == v then return true end
        if type(search_value) == "string" then
            if string.find(string.lower(v), string.lower(search_value)) then return true end
        end
    end
    return false
end

-------------------------------------------------
----- General Quest Info                     ----
-------------------------------------------------

function lib:get_quest_list(zone)
    if type(zone) == "string" and lib.quest_locations[zone] ~= nil then
        return lib.quest_locations[zone]
    else
        return {}
    end
end

function lib:get_quest_type(id)
    if type(id) == "number" then
        local s = lib.quest_skill_point[id] or false
        local c = lib.quest_cadwell[id] or false
        return s, c
    end
end

function lib:get_subzone_list(zone)
    if type(zone) == "string" and lib.subzone_list[zone] ~= nil then
        return lib.subzone_list[zone]
    else
        return {}
    end
end

-------------------------------------------------
----- Extended Quest Data                    ----
-------------------------------------------------

-- returns ID number only for use with lib.quest_givers[lang]
function lib:get_quest_npc_name(location, lang)
    if location[lib.quest_map_pin_index.quest_giver] then
        -- can return -1 if that value is in the table
        return location[lib.quest_map_pin_index.quest_giver]
    else
        return -1 -- undefined
    end
end

-------------------------------------------------
----- Lookup By ID: returns name             ----
-------------------------------------------------

-- I want this to be nil rather then unknown npc
function lib:get_quest_giver(id, lang)
    lang = lang or lib.client_lang
    return lib.quest_givers[lib.client_lang][id]
end

function lib:get_quest_name(id, lang)
    lang = lang or lib.client_lang
    return lib.quest_names[lib.client_lang][id] or "Unknown Name"
end

-- I want this to be nil rather then unknown objective
function lib:get_objective_name(id, lang)
    lang = lang or lib.client_lang
    return lib.objective_names[lib.client_lang][id]
end

-------------------------------------------------
----- Lookup By Name: returns table of IDs   ----
-------------------------------------------------
--[[

Get a table of quest IDs when given a quest name

Use: Drawing a pin with a different color if the player has started the
quest and has not finished it yet. Loop over the table

example:
for _, id in ipairs(ids) do
    started_quests[id] = true
end
--]]

function lib:get_questids_table(name, lang)
    local lang = lang or lib.client_lang
    if type(name) == "string" then
        return lib.name_to_questid_table[lang][name]
    end
end

function lib:get_npcids_table(name, lang)
    local lang = lang or lib.client_lang
    if type(name) == "string" then
        return lib.name_to_npcid_table[lang][name]
    end
end

function lib:get_objids_table(name, lang)
    local lang = lang or lib.client_lang
    if type(name) == "string" then
        return lib.name_to_objectiveid_table[lang][name]
    end
end
-------------------------------------------------
----- Generate QuestID Table By Language     ----
-------------------------------------------------

--[[
Build ID table is indexed by the quest name, only default language
is built by default. Author must build other languages as needed.
--]]

local function contains_id(quent_ids, id_to_find)
    local found_id = false
    for questname, quest_ids in pairs(quent_ids) do
        -- print(questname)
        for _, quest_id in pairs(quest_ids) do
            -- print(quest_id)
            if quest_id == id_to_find then
                found_id = true
            end
        end
    end
    return found_id
end

function lib:build_questid_table(lang)
    local lang = lang or lib.client_lang
    local built_table = {}

    for var1, var2 in pairs(lib.quest_names[lang]) do
        -- print(var2)
        -- print(var2)
        if built_table[var2] == nil then built_table[var2] = {} end
        if contains_id(built_table, var1) then
            -- print("Var 1 is in ids")
        else
            -- print("Var 1 is not in ids")
            table.insert(built_table[var2], var1)
        end
    end

    lib.name_to_questid_table[lang] = built_table

end

function lib:build_objectiveid_table(lang)
    local lang = lang or lib.client_lang
    local built_table = {}

    for var1, var2 in pairs(lib.objective_names[lang]) do
        -- print(var2)
        -- print(var2)
        if built_table[var2] == nil then built_table[var2] = {} end
        if contains_id(built_table, var1) then
            -- print("Var 1 is in ids")
        else
            -- print("Var 1 is not in ids")
            table.insert(built_table[var2], var1)
        end
    end

    lib.name_to_objectiveid_table[lang] = built_table

end

function lib:build_npcid_table(lang)
    local lang = lang or lib.client_lang
    local built_table = {}

    for var1, var2 in pairs(lib.quest_givers[lang]) do
        -- print(var2)
        -- print(var2)
        if built_table[var2] == nil then built_table[var2] = {} end
        if contains_id(built_table, var1) then
            -- print("Var 1 is in ids")
        else
            -- print("Var 1 is not in ids")
            table.insert(built_table[var2], var1)
        end
    end

    lib.name_to_npcid_table[lang] = built_table

end

-- Event handler function for EVENT_PLAYER_ACTIVATED
local function OnLoad(eventCode, addOnName)
    if LibQuestData_SavedVariables.version ~= 4 then
        -- d("ding not 4")
        local temp = nil
        if internal:is_empty_or_nil(LibQuestData_SavedVariables.quests) then
            --d("it is nil do nothing")
        else
            --d("it is not nil copy stuff")
            temp = LibQuestData_SavedVariables.quests
        end

        LibQuestData_SavedVariables = {}
        LibQuestData_SavedVariables.version = 4
        LibQuestData_SavedVariables.libVersion = lib.libVersion
        if temp == nil then
            LibQuestData_SavedVariables.quests = {}
        else
            LibQuestData_SavedVariables.quests = temp
        end
        LibQuestData_SavedVariables.subZones = {}

        LibQuestData_SavedVariables.quest_info = {}
        LibQuestData_SavedVariables.location_info = {}
        LibQuestData_SavedVariables.quest_names = {}
        LibQuestData_SavedVariables.objective_info = {}
        LibQuestData_SavedVariables.reward_info = {}
        LibQuestData_SavedVariables.map_info = {}
        LibQuestData_SavedVariables.giver_names = {}
    end
    LibQuestData_SavedVariables.libVersion = lib.libVersion
    lib:build_questid_table(lib.client_lang) -- build name lookup table once
    lib:build_npcid_table(lib.client_lang) -- build npc names lookup table once
    lib:build_objectiveid_table(lib.client_lang) -- build objective names lookup table once

    EVENT_MANAGER:UnregisterForEvent(lib.libName, EVENT_ADD_ON_LOADED)
end
EVENT_MANAGER:RegisterForEvent(lib.libName, EVENT_ADD_ON_LOADED, OnLoad)
