--[[

LibQuestData
by Sharlikran
https://sharlikran.github.io/

--]]

-- Init
local lib = _G["LibQuestData"]
local internal = _G["LibQuestData_Internal"]

-- Libraries
local LMP = LibMapPins
local GPS = LibGPS2

-- Default table
local quest_data_index_default = {
    -- [lib.quest_data_index.quest_name]   = "", Depreciated
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
    if not t then return true else return false end
    if t == nil then
        return true
    else
        return false
    end
end

-------------------------------------------------
----- General Quest Info                     ----
-------------------------------------------------

function lib:get_quest_list(zone)
    local all_zone_quests = {}
    local subzone_quests = {}
    local new_element = {}
    lib.quest_in_zone_list = {}
    if type(zone) == "string" and internal.quest_locations[zone] ~= nil then
        all_zone_quests = internal:get_zone_quests(zone)
    end
    for key, quest_info in pairs(all_zone_quests) do
        lib.quest_in_zone_list[quest_info[lib.quest_map_pin_index.quest_id]] = true
    end
    --internal.dm("Debug", "get_quest_list")
    --internal.dm("Debug", zone)
    if type(zone) == "string" and lib.subzone_list[zone] ~= nil then
        local subzone_list = lib.subzone_list[zone]
        --internal.dm("Debug", subzone_list)
        for subzone, conversion in pairs(subzone_list) do
            local subzone_quests = internal:get_zone_quests(subzone)
            --internal.dm("Debug", subzone)
            --internal.dm("Debug", subzone_quests)
            for i, quest in ipairs(subzone_quests) do
                --internal.dm("Debug", quest)
                if not internal:is_empty_or_nil(quest) and not lib.quest_in_zone_list[quest[lib.quest_map_pin_index.quest_id]] then
                    local new_element = ZO_DeepTableCopy(quest)
                    --internal.dm("Verbose", quest[lib.quest_map_pin_index.local_x])
                    --internal.dm("Verbose", quest[lib.quest_map_pin_index.local_y])
                    new_element[lib.quest_map_pin_index.local_x] = (quest[lib.quest_map_pin_index.local_x] * conversion.zoom_factor) + conversion.x
                    new_element[lib.quest_map_pin_index.local_y] = (quest[lib.quest_map_pin_index.local_y] * conversion.zoom_factor) + conversion.y
                    --internal.dm("Verbose", new_element[lib.quest_map_pin_index.local_x])
                    --internal.dm("Verbose", new_element[lib.quest_map_pin_index.local_y])
                    table.insert(all_zone_quests, new_element)
                end
            end
        end
    end
    --internal.dm("Debug", all_zone_quests)
    return all_zone_quests
end

function lib:get_qm_quest_type(id)
    if type(id) == "number" then
        local c = lib.quest_cadwell[id] or false
        return c
    end
end

function lib:is_holiday_quest(id)
  local c = lib:get_quest_type(id)
  if c == lib.quest_data_type.quest_type_holiday_event then return true else return false end
end
-------------------------------------------------
----- Extended Quest Data                    ----
-------------------------------------------------

-- returns ID number only for use with lib.quest_givers[lang]
function lib:get_quest_npc_id(location)
    if location[lib.quest_map_pin_index.quest_giver] then
        -- can return -1 if that value is in the table
        return location[lib.quest_map_pin_index.quest_giver]
    else
        return -1 -- undefined
    end
end

--[[
returns number of lib.quest_data_type. ZOS API does not
specify whether or not it is a Writ or daily. First 13 values are
ZOS Constant Values https://wiki.esoui.com/Constant_Values

14 through 25 must be manually assigned to lib.quest_data[quest_id].
]]--
function lib:get_quest_type(quest_id)
    if type(quest_id) == "number" and lib.quest_data[quest_id] then
        -- can return -1 if that value is in the table
        return lib.quest_data[quest_id][lib.quest_data_index.quest_type]
    else
        return -1 -- undefined
    end
end

--[[
returns number of lib.quest_data_repeat. ZOS API does not
specify whether or not it is a Writ or daily.
]]--
function lib:get_quest_repeat(quest_id)
    if type(quest_id) == "number" and lib.quest_data[quest_id] then
        -- can return -1 if that value is in the table
        return lib.quest_data[quest_id][lib.quest_data_index.quest_repeat]
    else
        return -1 -- undefined
    end
end

--[[
returns the the API the information was gathered with. 100003 means
unverified. 100030 or higher means data collected just prior to Greymoor
]]--
function lib:get_game_api(quest_id)
    if type(quest_id) == "number" and lib.quest_data[quest_id] then
        -- can return -1 if that value is in the table
        return lib.quest_data[quest_id][lib.quest_data_index.game_api]
    else
        return -1 -- undefined
    end
end

--[[
Arbitrary number for Quest Line used with Destinations.
]]--
function lib:get_quest_line(quest_id)
    if type(quest_id) == "number" and lib.quest_data[quest_id] then
        -- can return -1 if that value is in the table
        return lib.quest_data[quest_id][lib.quest_data_index.quest_line]
    else
        return 10000 -- undefined
    end
end

--[[
Arbitrary number for Quest Number used with Destinations.
]]--
function lib:get_quest_number(quest_id)
    if type(quest_id) == "number" and lib.quest_data[quest_id] then
        -- can return -1 if that value is in the table
        return lib.quest_data[quest_id][lib.quest_data_index.quest_number]
    else
        return 10000 -- undefined
    end
end

--[[
Returne number from lib.dest_quest_series_index
]]--
function lib:get_quest_series(quest_id)
    if type(quest_id) == "number" and lib.quest_data[quest_id] then
        -- can return -1 if that value is in the table
        return lib.quest_data[quest_id][lib.quest_data_index.quest_series]
    else
        return 0 -- None
    end
end

-------------------------------------------------
----- Lookup By ID: returns name             ----
-------------------------------------------------

-- I want this to be nil rather then unknown npc
function lib:get_quest_giver(id, lang)
    lang = lang or lib.effective_lang
    return lib.quest_givers[lib.effective_lang][id]
end

function lib:get_quest_name(id, lang)
    lang = lang or lib.effective_lang
    return lib.quest_names[lib.effective_lang][id] or "Unknown Name"
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
    local lang = lang or lib.effective_lang
    if type(name) == "string" then
        return lib.name_to_questid_table[lang][name]
    end
end

function lib:get_npcids_table(name, lang)
    local lang = lang or lib.effective_lang
    if type(name) == "string" then
        return lib.name_to_npcid_table[lang][name]
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
    local lang = lang or lib.effective_lang
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

function lib:build_npcid_table(lang)
    local lang = lang or lib.effective_lang
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

function lib:build_questlist_skilpoint()
    local built_table = {}

    for index=1,#lib.quest_has_skill_point do
        built_table[lib.quest_has_skill_point[index]] = true
    end
    lib.quest_rewards_skilpoint = built_table
end

function lib:set_conditional_quests(quest_id)
    if lib.conditional_quest_list[quest_id] then
        for key, conditional_quest_id in pairs(lib.conditional_quest_list[quest_id]) do
            lib.completed_quests[conditional_quest_id] = true
        end
    end
end

function lib:set_achievement_quests(quest_id)
    if lib.achievement_quest_list[quest_id] then
        local _, _, _, _, completed, _, _ = GetAchievementInfo(lib.achievement_quest_list[quest_id])
        if not completed then
          lib.completed_quests[quest_id] = true
        end
    end
end

local function build_completed_quests()
    -- Set up list of completed quests
    lib.completed_quests = {}
    local id
    -- There currently are < 6000 quests, but some can be completed multiple times.
    -- 10000 should be more than enough to get all completed quests and still avoid an endless loop.
    for i=0, 10000 do
        -- Get next completed quest. If it was the last, break loop
        id = GetNextCompletedQuestId(i)
        if id == nil then break end
        -- Add the quest to the list
        quest_name, quest_type = GetCompletedQuestInfo(id)
        if not internal:is_empty_or_nil(quest_name) then
            if lib.quest_names[lib.effective_lang][id] ~= quest_name then
                LibQuestData_SavedVariables["quest_names"][id] = quest_name
            end
            if lib.quest_names[lib.effective_lang][id] == nil then
                LibQuestData_SavedVariables["quest_names"][id] = quest_name
            end
        end
        lib.completed_quests[id] = true
        lib:set_conditional_quests(id)
    end
end

local function update_completed_quests(quest_id)
    lib.completed_quests[quest_id] = true
end

local function update_started_quests()
    -- Get names of started quests from quest journal, get quest ID from lookup table
    lib.started_quests = {}
    for i=1, MAX_JOURNAL_QUESTS do
        if IsValidQuestIndex(i) then
            local name = GetJournalQuestName(i)
            local ids = lib:get_questids_table(name)
            if ids ~= nil then
                -- Add all IDs for that quest name to list
                for _, id in ipairs(ids) do
                    lib.started_quests[id] = true
                end
            end
        end
    end
end

local function on_quest_added(eventCode, journalIndex, questName, objectiveName)
    update_started_quests()
end
EVENT_MANAGER:RegisterForEvent(lib.libName.."_updater", EVENT_QUEST_ADDED,      on_quest_added)

local function on_quest_removed(eventCode, isCompleted, journalIndex, questName, zoneIndex, poiIndex, questID)
    update_started_quests()
    if isCompleted then
        update_completed_quests(questID)
    end
end
EVENT_MANAGER:RegisterForEvent(lib.libName.."_updater", EVENT_QUEST_REMOVED,    on_quest_removed)


-- Event handler function for EVENT_PLAYER_ACTIVATED
local function OnPlayerActivatedQuestBuild(eventCode)
    build_completed_quests()
    update_started_quests()

    EVENT_MANAGER:UnregisterForEvent(lib.libName.."_BuildQuests", EVENT_PLAYER_ACTIVATED)
end
EVENT_MANAGER:RegisterForEvent(lib.libName.."_BuildQuests", EVENT_PLAYER_ACTIVATED, OnPlayerActivatedQuestBuild)

local function update_quest_information()
    local eight_field_data = {
        quest_name      = 1, -- Depreciated, use lib:get_quest_name(id, lang)
        quest_giver     = 2, -- Depreciated, see quest_map_pin_index
        quest_type      = 3, -- MAIN_STORY, DUNGEON << -1 = Undefined >>
        quest_repeat    = 4, -- quest_repeat_daily, quest_repeat_not_repeatable = 0, quest_repeat_repeatable << -1 = Undefined >>
        game_api        = 5, -- 100003 means unverified, 100030 or higher means recent quest data
        quest_line      = 6,    -- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
        quest_number    = 7,    -- Quest Number In QuestLine (10000 = not assigned/not verified)
        quest_series    = 8,    -- None = 0,    Cadwell's Almanac = 1,    Undaunted = 2, AD = 3, DC = 4, EP = 5.
    }
    local seven_field_data = {
        quest_name      = 1, -- Depreciated, use lib:get_quest_name(id, lang)
        -- quest_giver     =    2,  Depreciated, see quest_map_pin_index
        quest_type      = 2, -- MAIN_STORY, DUNGEON << -1 = Undefined >>
        quest_repeat    = 3, -- quest_repeat_daily, quest_repeat_not_repeatable = 0, quest_repeat_repeatable << -1 = Undefined >>
        game_api        = 4, -- 100003 means unverified, 100030 or higher means recent quest data
        quest_line      = 5,    -- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
        quest_number    = 6,    -- Quest Number In QuestLine (10000 = not assigned/not verified)
        quest_series    = 7,    -- None = 0,    Cadwell's Almanac = 1,    Undaunted = 2, AD = 3, DC = 4, EP = 5.
    }
    local five_field_location = {
        local_x     =    1, -- GetMapPlayerPosition() << -10 = Undefined >>
        local_y     =    2, -- GetMapPlayerPosition() << -10 = Undefined >>
        global_x    =    3, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
        global_y    =    4, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
        quest_id    =    5, -- Number index of quest name i.e. 6404 for "The Dragonguard"  << -1 = Undefined >>
    }

    local all_locations = LibQuestData_SavedVariables["location_info"]
    local all_quest_data = ZO_DeepTableCopy(LibQuestData_SavedVariables["quest_info"])
    local all_quest_names = LibQuestData_SavedVariables["quest_names"]
    local all_objectives = LibQuestData_SavedVariables["objective_info"]
    local all_quest_givers = LibQuestData_SavedVariables["giver_names"]
    local all_reward_info = LibQuestData_SavedVariables["reward_info"]
    local rebuilt_data = {}
    local rebuilt_locations = {}
    local current_data = {}
    local givername
    local npc_id
    local saved_reward_info

    for zone, zone_quests in pairs(all_locations) do
        for index, quest in pairs(zone_quests) do
            current_data = {}
            if #quest == 5 then
                current_data[lib.quest_map_pin_index.local_x] = quest[five_field_location.local_x]
                current_data[lib.quest_map_pin_index.local_y] = quest[five_field_location.local_y]
                current_data[lib.quest_map_pin_index.global_x] = quest[five_field_location.global_x]
                current_data[lib.quest_map_pin_index.global_y] = quest[five_field_location.global_y]
                current_data[lib.quest_map_pin_index.quest_id] = quest[five_field_location.quest_id]
                current_data[lib.quest_map_pin_index.world_x] = -10
                current_data[lib.quest_map_pin_index.world_y] = -10
                current_data[lib.quest_map_pin_index.world_z] = -10
                givername = -1
                --internal.dm("Debug", quest[five_field_location.quest_id])
                if all_quest_data[quest[five_field_location.quest_id]] then
                    if #all_quest_data[quest[five_field_location.quest_id]] == 8 then
                        givername = all_quest_data[quest[five_field_location.quest_id]][eight_field_data.quest_giver]
                    end
                end
                current_data[lib.quest_map_pin_index.quest_giver] = givername
            end
            if #quest == 9 then
                current_data = quest
                if type(current_data[lib.quest_map_pin_index.quest_giver]) == "string" then
                    npc_id = lib:get_npcids_table(current_data[lib.quest_map_pin_index.quest_giver])
                    if npc_id then
                        current_data[lib.quest_map_pin_index.quest_giver] = npc_id[1]
                    end
                end
                if (type(current_data[lib.quest_map_pin_index.quest_giver]) == "string") or (current_data[lib.quest_map_pin_index.quest_giver] == -1) then
                    npc_id = lib:get_giver_when_object(current_data[lib.quest_map_pin_index.quest_id])
                    if not internal:is_empty_or_nil(npc_id) then
                        current_data[lib.quest_map_pin_index.quest_giver] = npc_id
                    end
                end
            end
            if rebuilt_locations[zone] == nil then rebuilt_locations[zone] = {} end
            table.insert(rebuilt_locations[zone], current_data)
        end
    end

    for index, data in pairs(all_quest_data) do
        current_data = {}
        if #data == 8 then
            current_data[lib.quest_data_index.quest_type] = data[eight_field_data.quest_type]
            current_data[lib.quest_data_index.quest_repeat] = data[eight_field_data.quest_repeat]
            current_data[lib.quest_data_index.game_api] = data[eight_field_data.game_api]
            current_data[lib.quest_data_index.quest_line] = data[eight_field_data.quest_line]
            current_data[lib.quest_data_index.quest_number] = data[eight_field_data.quest_number]
            current_data[lib.quest_data_index.quest_series] = data[eight_field_data.quest_series]
        end
        if #data == 7 then
            current_data[lib.quest_data_index.quest_type] = data[seven_field_data.quest_type]
            current_data[lib.quest_data_index.quest_repeat] = data[seven_field_data.quest_repeat]
            current_data[lib.quest_data_index.game_api] = data[seven_field_data.game_api]
            current_data[lib.quest_data_index.quest_line] = data[seven_field_data.quest_line]
            current_data[lib.quest_data_index.quest_number] = data[seven_field_data.quest_number]
            current_data[lib.quest_data_index.quest_series] = data[seven_field_data.quest_series]
        end
        if #data == 6 then
            current_data = data
        end

        if rebuilt_data[index] == nil then rebuilt_data[index] = {} end
        rebuilt_data[index] = current_data
    end

    LibQuestData_SavedVariables["location_info"] = rebuilt_locations
    LibQuestData_SavedVariables["quest_info"] = rebuilt_data

    for index, data in pairs(all_quest_names) do
        if lib.quest_names[lib.effective_lang][index] then
            if LibQuestData_SavedVariables["quest_names"][index] == lib.quest_names[lib.effective_lang][index] then
                LibQuestData_SavedVariables["quest_names"][index] = nil
            end
        end
    end
    for index, data in pairs(all_quest_givers) do
        npc_id = lib:get_npcids_table(data)
        if npc_id then
            if lib.quest_givers[lib.effective_lang][npc_id[1]] == data then
                LibQuestData_SavedVariables["giver_names"][index] = nil
            end
        end
    end

    saved_reward_info = {}
    for quest_id, rewards in pairs(all_reward_info) do
        for index, reward_data in pairs(rewards) do
            npc_id = lib:get_npcids_table(data)
            if reward_data == REWARD_TYPE_PARTIAL_SKILL_POINTS then
                if not lib.quest_rewards_skilpoint[quest_id] then
                    saved_reward_info[quest_id] = rewards
                end
            end
        end
    end
    LibQuestData_SavedVariables["reward_info"] = saved_reward_info
end

-- Event handler function for EVENT_ADD_ON_LOADED
local function OnLoad(eventCode, addOnName)
    if addOnName ~= lib.libName then return end

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
        LibQuestData_SavedVariables.client_lang = lib.client_lang
        LibQuestData_SavedVariables.version = 4
        LibQuestData_SavedVariables.libVersion = lib.libVersion
        if temp == nil then
            LibQuestData_SavedVariables.quests = {}
        else
            LibQuestData_SavedVariables.quests = temp
        end

        LibQuestData_SavedVariables.quest_info = {}
        LibQuestData_SavedVariables.location_info = {}
        LibQuestData_SavedVariables.quest_names = {}
        LibQuestData_SavedVariables.reward_info = {}
        LibQuestData_SavedVariables.giver_names = {}
    end
    if LibQuestData_SavedVariables.map_info ~= nil then LibQuestData_SavedVariables.map_info = nil end
    if LibQuestData_SavedVariables.objective_info ~= nil then LibQuestData_SavedVariables.objective_info = nil end
    if LibQuestData_SavedVariables.subZones ~= nil then LibQuestData_SavedVariables.subZones = nil end
    if LibQuestData_SavedVariables.client_lang == nil then LibQuestData_SavedVariables.client_lang = lib.client_lang end
    LibQuestData_SavedVariables.libVersion = lib.libVersion
    lib:build_questid_table(lib.effective_lang) -- build name lookup table once
    lib:build_npcid_table(lib.effective_lang) -- build npc names lookup table once
    lib:build_questlist_skilpoint() -- build list of quests that reward a skill point
    update_quest_information()

    EVENT_MANAGER:UnregisterForEvent(lib.libName, EVENT_ADD_ON_LOADED)
end
EVENT_MANAGER:RegisterForEvent(lib.libName, EVENT_ADD_ON_LOADED, OnLoad)
