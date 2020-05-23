local lib = _G["LibQuestInfo"]

-- Local variables
local questGiverName = nil
local reward
local lastZone
-- Init saved variables table
local GPS = LibGPS2
local LMP = LibMapPins
local quest_shared
local quest_found

-- Check if zone is base zone
local function IsBaseZone(zoneAndSubzone)
    return (zoneAndSubzone:match("(.*)/") == zoneAndSubzone:match("/(.*)[%._]base"))
end

-- Check if both subzones are in the same zone
local function IsSameZone(zoneAndSubzone1, zoneAndSubzone2)
    return (zoneAndSubzone1:match("(.*)/") == zoneAndSubzone2:match("(.*)/"))
end

local function get_sv_quest_info(zone)
    --d(zone)
    -- if type(zone) ~= "string"
    if internal:is_empty_or_nil(LibQuestInfo_SavedVariables.quests[zone]) then
        --d("get_sv_quest_info it was nil")
        return {}
    else
        --d("get_sv_quest_info was not nil")
        return LibQuestInfo_SavedVariables.quests[zone]
    end
end

local function get_measurement_sv(zone)
    --d("Begin get_measurement_sv")
    --d(zone)
    -- if type(zone) == "string"
    if internal:is_empty_or_nil(LibQuestInfo_SavedVariables.map_info[zone]) then
        --d("get_measurement_sv was nil!!!!!!!!!!")
        --d("End get_measurement_sv")
        return {}
    else
        --d("get_measurement_sv was not nil---------")
        --d(LibQuestInfo_SavedVariables.map_info[zone])
        --d("End get_measurement_sv")
        return LibQuestInfo_SavedVariables.map_info[zone]
    end
end

local function get_giver_sv(name)
    --d(name)
    local obj_name = nil
    for count, value in pairs(LibQuestInfo_SavedVariables.giver_names) do
        if value == name then
            obj_name = value
        end
    end
    return obj_name
end

local function get_objective_sv(name)
    --d(name)
    local obj_name = nil
    for count, value in pairs(LibQuestInfo_SavedVariables.objective_info) do
        if value == name then
            obj_name = value
        end
    end
    return obj_name
end

local function get_questname_sv(name)
    --d(name)
    --[[Note to self:
    Originally I saved it with a ket for the name and realized
    it's faster to copy paste with an ID number.

    Since this is the save game information I don't have a
    lookup table for this nor should I make one. Converting
    the quest name to a quest ID is pointless. Just ensure
    I look at the tbale for quest names, return an empty
    table without an error

    Needs different way to handle this or leave it since
    the assignment overwrites the value each time regardless.
    ]]--
    if internal:is_empty_or_nil(LibQuestInfo_SavedVariables.quest_names[quest_id]) then
        --d("get_questname_sv it was nil")
        return {}
    else
        --d("get_questname_sv was not nil")
        --d(LibQuestInfo_SavedVariables.quest_names[quest_id])
        return LibQuestInfo_SavedVariables.quest_names[quest_id]
    end
end

local function get_quest_list_sv(zone)
    --d(zone)
    if type(zone) == "string" and LibQuestInfo_SavedVariables.location_info[zone] ~= nil then
        return LibQuestInfo_SavedVariables.location_info[zone]
    else
        return {}
    end
end

function get_measurement_info(zone)
    --d("Begin get_measurement_info")
    --d(zone)
    if internal:is_empty_or_nil(lib.map_info_data[zone]) then
        --d("get_measurement_info it was nil")
        --d("End get_measurement_info")
        return {}
    else
        --d("get_measurement_info was not nil")
        --d(lib.map_info_data[zone])
        --d("End get_measurement_info")
        return lib.map_info_data[zone]
    end
end

-- Event handler function for EVENT_QUEST_ADDED
local function OnQuestAdded(eventCode, journalIndex, questName, objectiveName)
    --d("OnQuestAdded")
    if quest_shared then
        quest_shared = false
        return
    end
    -- -1 for these means it is undefined since 0 is a valid value
    local quest_type = -1
    local repeat_type = -1
    local quest_id = -1
    -- -1 means it has not been completed. Once complete set it to the time stamp
    -- I am considering using this to see if I can calculate order for Zone quests

    -- Add quest to saved variables table in correct zone element

    local zone = LMP:GetZoneAndSubzone(true, false, true)
    if LibQuestInfo_SavedVariables.quests[zone] == nil then LibQuestInfo_SavedVariables.quests[zone] = {} end
    local normalizedX, normalizedY = GetMapPlayerPosition("player")
    local gpsx, gpsy, zoneMapIndex = GPS:LocalToGlobal(normalizedX, normalizedY)
    local measurement = GPS:GetCurrentMapMeasurements()
    if journalIndex then
        quest_type = GetJournalQuestType(journalIndex)
        repeat_type = GetJournalQuestRepeatType(journalIndex)
    end
    local quest = {
        ["quest_type"]  = quest_type,
        ["repeat_type"] = repeat_type,
        ["name"]        = questName,
        ["x"]           = normalizedX,
        ["y"]           = normalizedY,
        ["gpsx"]        = gpsx,
        ["gpsy"]        = gpsy,
        ["giver"]       = questGiverName,
        ["questID"]     = quest_id, -- assign this and get the ID when the quest is removed
        ["api"]         = GetAPIVersion(),
        ["lang"]        = GetCVar("language.2"),
        ["objective"]   = objectiveName,
    }

    local measurement_info = {
        ["mapIndex"] = measurement.mapIndex,
        ["offsetX"]  = measurement.offsetX,
        ["offsetY"]  = measurement.offsetY,
        ["scaleY"]   = measurement.scaleY,
        ["zoneId"]   = measurement.zoneId,
        ["scaleX"]   = measurement.scaleX,
    }

    --d("Begin Measurement collection")
    --d("the id: "..measurement.id)
    if internal:is_empty_or_nil(get_measurement_info(measurement.id)) then
        --d("the main database is nil")
        -- meaing I don't have it so look in the SavedVariables file
        if internal:is_empty_or_nil(get_measurement_sv(measurement.id)) then
            --d("is_empty_or_nil returned empty or nil!!!!!!!!!!")
            -- meaing I don't have it in the SavedVariables file, save it
            LibQuestInfo_SavedVariables.map_info[measurement.id] = measurement_info
        else
            --d("is_empty_or_nil returned did not return empty or nil--------")
            -- meaing I have it in the SavedVariables file, don't save it
        end
    else
        --d("the main database is not nil")
        --meaing I have it I don't need this information
    end
    --d("End Measurement collection")

    quest_found = false
    local QuestScout_zonelist = get_sv_quest_info(zone)
    for num_entry, quest_from_table in pairs(QuestScout_zonelist) do
        if quest_from_table.name == questName then
            quest_found = true
        end
    end
    if quest_found then
        --d("quest found")
    else
        --d("quest not found")
        table.insert(LibQuestInfo_SavedVariables.quests[zone], quest)
    end
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_QUEST_ADDED, OnQuestAdded) -- Verified

-- Event handler function for EVENT_CHATTER_END
local function OnChatterEnd(eventCode)
    --d("OnChatterEnd")
    questGiverName = nil
    reward = nil
    -- Stop listening for the quest added event because it would only be for shared quests
    -- Shar I added if EVENT_QUEST_SHARED to OnQuestAdded UnregisterForEvent EVENT_QUEST_ADDED
    -- EVENT_MANAGER:UnregisterForEvent(lib.idName, EVENT_QUEST_ADDED)
    EVENT_MANAGER:UnregisterForEvent(lib.idName, EVENT_CHATTER_END) -- Verified
end

local function OnQuestSharred(eventCode, questID)
    --d("OnQuestSharred")
    quest_shared = true
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_QUEST_SHARED, OnQuestSharred) -- Verified

-- Event handler function for EVENT_QUEST_OFFERED
-- Note runs when you click writ board
local function OnQuestOffered(eventCode)
    --d("OnQuestOffered")
    -- Get the name of the NPC or intractable object
    -- (This could also be done in OnQuestAdded directly, but it's saver here because we are sure the dialogue is open)
    questGiverName = GetUnitName("interact")
    -- Now that the quest has ben offered we can start listening for the quest added event
    -- Shar I added if EVENT_QUEST_SHARED to OnQuestAdded UnregisterForEvent EVENT_QUEST_ADDED
    -- EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_QUEST_ADDED, OnQuestAdded)
    EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_CHATTER_END, OnChatterEnd) -- Verified
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_QUEST_OFFERED, OnQuestOffered) -- Verified

-- Event handler function for EVENT_QUEST_COMPLETE_DIALOG
local function OnQuestCompleteDialog(eventCode, journalIndex)
    --d("OnQuestCompleteDialog")
    local numRewards = GetJournalQuestNumRewards(journalIndex)
    if numRewards <= 0 then return end
    reward = {}
    for i=1, numRewards do
        local rewardType = GetJournalQuestRewardInfo(journalIndex, i)
        table.insert(reward, rewardType)
    end
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_QUEST_COMPLETE_DIALOG, OnQuestCompleteDialog) -- Verified

-- Event handler function for EVENT_QUEST_REMOVED
local function OnQuestRemoved(eventCode, isCompleted, journalIndex, questName, zoneIndex, poiIndex, questID)
    --d(questName)
    --d("OnQuestRemoved")
    local quest_to_update = nil
    local the_zone
    local the_entry
    local giver_name_result
    local quest_info_changed = false
    local save_quest_location = true

    for zone, zone_quests in pairs(LibQuestInfo_SavedVariables.quests) do
        for num_entry, quest_from_table in pairs(zone_quests) do
            if quest_from_table.name == questName then
                the_zone = zone
                the_entry = num_entry
                quest_to_update = quest_from_table
                break
            end
        end
    end

    if quest_to_update == nil then
        return
    end

    if questID >= 1 then
        if quest_to_update.questID == -1 then
            quest_to_update.questID = questID
        end
    end

    --[[ set objective ]]--
    -- local objective_name = get_objective_sv(quest_to_update.objective)
    --d("objective")
    --d(quest_to_update.objective)
    local temp_obj = lib:get_objids_table(quest_to_update.objective)
    --d(temp_obj)
    if temp_obj == nil then
        --d("objective lookup table is nil")
        -- meaning not found look in saved vars
        if internal:is_nil(LibQuestInfo_SavedVariables.objective_info[quest_to_update.questID]) then
            --d("objective from saved vars is nil")
            -- meaing it's not there add it
            if internal:is_empty_or_nil(quest_to_update.objective) then
                --d("hey that's a rip off it was empty or nil")
            else
                --d("it wasn't empty or nil so lets see what it is")
                LibQuestInfo_SavedVariables.objective_info[quest_to_update.questID] = quest_to_update.objective
            end
        else
            --d("objective from saved vars is not nil")
            -- meaning it's there don't add it
        end

        -----------------------------------------
    else
        --d("objective lookup table is not nil")
        -- meaning we found it don't add it
    end

    --[[ set quest giver name ]]--
    giver_name_result = lib:get_npcids_table(quest_to_update.giver)
    --d("quest giver table was")
    --d(giver_name_result)
    --d(quest_to_update.giver)
    if giver_name_result == nil then
        if internal:is_empty_or_nil(quest_to_update.giver) then
            --d("hey for some reason the giver is nil or an empty string")
            -- meaning set it to something I can look into
            quest_to_update.giver = "Unknown Target"
            --d(quest_to_update.giver)
        else
            --d("not empty or nil so continue")
        end
        --d("quest giver lookup table is nil look in sv now")
        giver_name_result = get_giver_sv(quest_to_update.giver)
        --d(giver_name_result)
        if internal:is_nil(giver_name_result) then
            --d("giver from saved vars is nil save it and set the result to the npc name string")
            LibQuestInfo_SavedVariables.giver_names[quest_to_update.questID] = quest_to_update.giver
            giver_name_result = quest_to_update.giver
        else
            --d("giver from saved vars is not nil")
            -- meaning don't save it because it's there but
            -- the NPC name was not Lua file but was in the save vars
            -- and I need an arbitrary value, use the string for now
            giver_name_result = quest_to_update.giver
        end
    else
        --d("quest giver lookup table is not nil")
        -- meaning we found it don't add it but I need the number
        giver_name_result = lib:get_npcids_table(quest_to_update.giver)[1]
    end
    --d("end result was")
    --d(giver_name_result)

    --[[ set quest name ]]--
    --d(quest_to_update.questID)
    --d("Name Please")
    --d(lib:get_quest_name(quest_to_update.questID))
    if lib:get_quest_name(quest_to_update.questID) == "Unknown Name" then
        --d("quest name is Unknown Name - So not found")
        if internal:is_empty_or_nil(get_questname_sv(quest_to_update.name)) then
            --d("quest name empty")
            LibQuestInfo_SavedVariables.quest_names[quest_to_update.questID] = quest_to_update.name
        else
            --d("quest name not empty")
        end
    else
        -- get_questname_sv
        --d("quest name is not Unknown Name - So it was found")
        --d(lib:get_quest_name(quest_to_update.questID))
    end

    --[[ Add Quest Information
    Step 1: Use series of comparisons to see if values are different
            and if they are save the new quest information.
            At first they will all be different for API but check
            anyway.
    ]]--
    the_quest_info = {
        [lib.quest_data_index.QUEST_NAME] = quest_to_update.questID,
        [lib.quest_data_index.QUEST_GIVER]  = giver_name_result,
        [lib.quest_data_index.QUEST_TYPE]  = quest_to_update.quest_type,
        [lib.quest_data_index.QUEST_REPEAT]   = quest_to_update.repeat_type,
        [lib.quest_data_index.GAME_API]   = 100030,
        [lib.quest_data_index.QUEST_LINE]   = 10000,
        [lib.quest_data_index.QUEST_NUMBER]   = 10000,
        [lib.quest_data_index.QUEST_SERIES]   = 0,
    }

    local temp_quest_info = lib.quest_data[quest_to_update.questID]
    if temp_quest_info == nil then
        --d("quest information is nill")
        -- meaning I need to create it and save it, no compare
        LibQuestInfo_SavedVariables.quest_info[quest_to_update.questID] = the_quest_info
    else
        --d("quest information is not nill")
        -- meaning I need to compare things and save if different
        local compared_quest_info = {}
        if temp_quest_info[lib.quest_data_index.QUEST_NAME] ~= quest_to_update.questID then
            temp_quest_info [lib.quest_data_index.QUEST_NAME] = quest_to_update.questID
            quest_info_changed = true
        end
        if internal:is_in(quest_to_update.questID, lib.quest_giver_is_object) then
            --d("Hey that quest ID in in this special table")
            -- meaning keepl the value and don't touch it
        else
            -- meaning you can compare it
            --d("Hey that quest ID was not in this special table")
            if temp_quest_info[lib.quest_data_index.QUEST_GIVER] ~= giver_name_result then
                temp_quest_info [lib.quest_data_index.QUEST_GIVER] = giver_name_result
                quest_info_changed = true
            end
        end
        if temp_quest_info[lib.quest_data_index.QUEST_TYPE] ~= quest_to_update.quest_type then
            temp_quest_info [lib.quest_data_index.QUEST_TYPE] = quest_to_update.quest_type
            quest_info_changed = true
        end
        if temp_quest_info[lib.quest_data_index.QUEST_REPEAT] ~= quest_to_update.repeat_type then
            temp_quest_info [lib.quest_data_index.QUEST_REPEAT] = quest_to_update.repeat_type
            quest_info_changed = true
        end
        if temp_quest_info[lib.quest_data_index.GAME_API] ~= 100030 then
            temp_quest_info [lib.quest_data_index.GAME_API] = 100030
            quest_info_changed = true
        end
        -- QUEST_LINE is set manually
        -- QUEST_NUMBER is set manually
        -- QUEST_SERIES is set manually
        --d(temp_quest_info)
        if quest_info_changed then
            --d("save the table")
            LibQuestInfo_SavedVariables.quest_info[quest_to_update.questID] = temp_quest_info
        else
            --d("do not save the table")
        end
    end

    the_quest_loc_info = {
        [lib.quest_map_pin_index.X_LOCATION] = quest_to_update.x,
        [lib.quest_map_pin_index.Y_LOCATION]  = quest_to_update.y,
        [lib.quest_map_pin_index.X_LIBGPS]  = quest_to_update.gpsx,
        [lib.quest_map_pin_index.Y_LIBGPS]   = quest_to_update.gpsy,
        [lib.quest_map_pin_index.QUEST_ID]   = quest_to_update.questID,
    }

    -- check LibQuestInfo_QuestLocations.lua file
    regular_quest_list = lib:get_quest_list(the_zone)
    for num_entry, quest_entry_table in ipairs(regular_quest_list) do
        --d(num_entry)
        --d(quest_entry_table)
        if quest_entry_table[lib.quest_map_pin_index.QUEST_ID] == quest_to_update.questID then
            --d("Found an entry with the same quest ID so check LibGPS")
            if quest_entry_table[lib.quest_map_pin_index.X_LIBGPS] == -10 then
                --d("It is -10 so it should not be accurate")
                --meaning save it
                save_quest_location = true
                break
            else
                --d("It is not -10 so it should recent")
                -- meaing do not save it
                save_quest_location = false
                break
            end
        end
    end

    -- if we are going to save it check saved vars first
    if save_quest_location then
        -- the api changed so save the location regardless
        saved_vars_quest_list = get_quest_list_sv(the_zone)
        for num_entry, sv_quest_entry in ipairs(saved_vars_quest_list) do
            --d(num_entry)
            --d(sv_quest_entry)
            if sv_quest_entry[lib.quest_map_pin_index.QUEST_ID] == quest_to_update.questID then
                --d("found that the entry 5 was equal to the ID of this quest in the SV file")
                -- meaning it is in the saved vars file don't duplicate it
                save_quest_location = false
                break
            end
        end
    else
        --d("save_quest_location was false don't check SV file")
    end

    --[[ Save the qest location
    Somehow the quest was in the constants file and the LibGPS was -10
    so I determined I needed to save the updated location. Then after
    looking in the saved vars file for LibQuestInfo we did not see an
    entry for this quest in the zone so it needs to be saved.
    ]]--
    if save_quest_location then
        --d("save_quest_location is true saving")
        --d(the_zone)
        if LibQuestInfo_SavedVariables.location_info[the_zone] == nil then LibQuestInfo_SavedVariables.location_info[the_zone] = {} end
        table.insert(LibQuestInfo_SavedVariables.location_info[the_zone], the_quest_loc_info)
    end

    --d(the_zone)
    --d(the_entry)

    table.remove(LibQuestInfo_SavedVariables.quests[the_zone], the_entry)

    if not isCompleted  then
        return
    end

    if isCompleted then
        if not LibQuestInfo_SavedVariables.reward_info then LibQuestInfo_SavedVariables.reward_info = {} end
        if not LibQuestInfo_SavedVariables.reward_info[questID] then LibQuestInfo_SavedVariables.reward_info[questID] = {} end
        LibQuestInfo_SavedVariables.reward_info[questID] = reward
        reward = nil
    end
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_QUEST_REMOVED, OnQuestRemoved) -- Verified

-- Event handler function for EVENT_PLAYER_DEACTIVATED
local function OnPlayerDeactivated(eventCode)
    lastZone = LMP:GetZoneAndSubzone(true, false, true)
end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_PLAYER_DEACTIVATED, OnPlayerDeactivated) -- Verified

local function show_quests()
    for zone, zone_quests in pairs(LibQuestInfo_SavedVariables.quests) do
        d("zone: "..zone)
        for num_entry, quest_from_table in pairs(zone_quests) do
            quest_to_update = quest_from_table
            d("Quest Name: "..quest_to_update.name)
        end
    end
end

-- Event handler function for EVENT_PLAYER_ACTIVATED
local function OnPlayerActivated(eventCode)
    local zone = LMP:GetZoneAndSubzone(true, false, true)
    -- Check if leaving subzone (entering base zone)
    if lastZone and zone ~= lastZone and IsBaseZone(zone) and IsSameZone(zone, lastZone) then
        if LibQuestInfo_SavedVariables.subZones[zone] == nil then LibQuestInfo_SavedVariables.subZones[zone] = {} end
        if LibQuestInfo_SavedVariables.subZones[zone][lastZone] == nil then
            -- Save entrance position
            local x, y = GetMapPlayerPosition("player")
            local gpsx, gpsy, gpsm = GPS:LocalToGlobal(x, y)
            local measurement = GPS:GetCurrentMapMeasurements()
            LibQuestInfo_SavedVariables.subZones[zone][lastZone] = {
                -- previously this was reversed ?? GetMapPlayerPosition
                -- won't reverse that ??
                -- ["y"] = x,
                -- ["x"] = y,
                ["x"] = x,
                ["y"] = y,
                ["gpsx"] = gpsx,
                ["gpsy"] = gpsy,
                ["measurement"] = measurement,
            }
        end
    end
    lastZone = zone

    SLASH_COMMANDS["/lqilist"] = function() show_quests() end

end
EVENT_MANAGER:RegisterForEvent(lib.idName, EVENT_PLAYER_ACTIVATED, OnPlayerActivated) -- Verified
