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
local GPS = LibGPS3
local LMD = LibMapData

-- Default table
local quest_data_index_default = {
  -- [lib.quest_data_index.quest_name]   = "", Depreciated
  -- [lib.quest_data_index.quest_giver]  = "", Depreciated
  [lib.quest_data_index.quest_type] = -1, -- Undefined
  [lib.quest_data_index.quest_repeat] = -1, -- Undefined
  [lib.quest_data_index.game_api] = 100003, -- 100003 means unverified
  [lib.quest_data_index.quest_line] = 10000, -- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
  [lib.quest_data_index.quest_number] = 10000, -- Quest Number In QuestLine (10000 = not assigned/not verified)
  [lib.quest_data_index.quest_series] = 0, -- None = 0, Cadwell's Almanac = 1, Undaunted = 2, AD = 3, DC = 4, EP = 5
  [lib.quest_data_index.quest_display_type] = -1, -- INSTANCE_DISPLAY_TYPE_ZONE_STORY, INSTANCE_DISPLAY_TYPE_DUNGEON << -1 = Undefined >>
}

local quest_map_pin_index_default = {
  [lib.quest_map_pin_index.local_x] = -10, -- GetMapPlayerPosition() << -10 = Undefined >>
  [lib.quest_map_pin_index.local_y] = -10, -- GetMapPlayerPosition() << -10 = Undefined >>
  [lib.quest_map_pin_index.global_x] = -10, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
  [lib.quest_map_pin_index.global_y] = -10, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
  [lib.quest_map_pin_index.quest_id] = -1, -- -1 Unknown, Quest ID i.e. 6404 for "The Dragonguard"
  [lib.quest_map_pin_index.quest_giver] = -1, -- Arbitrary number pointing to an NPC Name 81004, "Abnur Tharn"  << -1 = Undefined >>
}

-------------------------------------------------
----- Helpers                                ----
-------------------------------------------------

function internal:has_vampirisum()
  -- Noxiphilic Sanguivoria 40360
  for index = 1, GetNumBuffs("player") do
    local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("player", index)
    if abilityId == 40360 then return true end
  end
  return false
end

function internal:has_lupinus()
  -- Sanies Lupinus 40521
  for index = 1, GetNumBuffs("player") do
    local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("player", index)
    if abilityId == 40521 then return true end
  end
  return false
end

-- Function to check for empty table
function internal:is_empty_or_nil(t)
  if t == nil or t == "" then return true end
  return type(t) == "table" and ZO_IsTableEmpty(t) or false
end

function internal:missing_gps_data(info)
  if info[lib.quest_map_pin_index.global_x] == -10 then
    --d("global_x was -10 so undefined")
    return true
  end
  return false
end

function internal:missing_quest_giver(info)
  if info[lib.quest_map_pin_index.quest_giver] == -1 then
    --d("quest_giver was -1 so undefined")
    return true
  end
  if type(info[lib.quest_map_pin_index.quest_giver]) == "string" then
    --d("Quest Giver was a string")
    return true
  end
  return false
end

function internal:has_undefined_data(info)
  if info[lib.quest_map_pin_index.global_x] == -10 then
    --d("global_x was -10 so undefined")
    return true
  end
  if info[lib.quest_map_pin_index.quest_giver] == -1 then
    --d("quest_giver was -1 so undefined")
    return true
  end
  if type(info[lib.quest_map_pin_index.quest_giver]) == "string" then
    --d("Quest Giver was a string")
    return true
  end
  return false
end

function internal:quest_in_range(map_data_quest, quest_data)
  local distance = zo_round(GPS:GetLocalDistanceInMeters(map_data_quest[lib.quest_map_pin_index.local_x],
    map_data_quest[lib.quest_map_pin_index.local_y], quest_data[lib.quest_map_pin_index.local_x],
    quest_data[lib.quest_map_pin_index.local_y]))
  if distance <= 25 then
    --internal.dm("Debug", "Distance was within range")
    return true
  else
    --internal.dm("Debug", "Distance outside of range")
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
  local quest_name_in_zone_list = {}
  -- get all the quetsts in the zone
  if internal:zone_has_quest_locations(zone) then
    all_zone_quests = internal:get_zone_quests(zone)
  end
  -- make a table of the questId values as a way to prevent them from duplicating maybe ??
  for key, quest_info in pairs(all_zone_quests) do
    local questId = quest_info[lib.quest_map_pin_index.quest_id]
    lib.quest_in_zone_list[questId] = true
  end
  internal.dm("Debug", "get_quest_list")
  --internal.dm("Debug", zone)
  if internal:subzone_has_conversions(zone) then
    -- all_zone_quests = internal:add_subzone_quests(zone)
    local subzone_list = internal.subzone_list[zone]
    --internal.dm("Debug", subzone_list)
    for subzone, conversion in pairs(subzone_list) do
      -- use the texture name as the zone and get the quests as if subzone = zone
      --internal.dm("Debug", subzone)
      local subzone_quests = internal:get_zone_quests(subzone)
      for i, quest in ipairs(subzone_quests) do
        --internal.dm("Debug", quest)
        local questId = quest[lib.quest_map_pin_index.quest_id]
        --[[If the quest info is not nil and the quest info from the subzone is not already in the list of quests
        then add the quest from the subzone. This will prevent adding a quest from the subzone with
        the subzone scale information to the map when there is already a fake pin.]]--
        if not internal:is_empty_or_nil(quest) and not lib.quest_in_zone_list[questId] then
          local new_element = ZO_DeepTableCopy(quest)
          --internal.dm("Verbose", quest[lib.quest_map_pin_index.local_x])
          --internal.dm("Verbose", quest[lib.quest_map_pin_index.local_y])
          new_element[lib.quest_map_pin_index.local_x] = (quest[lib.quest_map_pin_index.local_x] * conversion.zoom_factor) + conversion.x
          new_element[lib.quest_map_pin_index.local_y] = (quest[lib.quest_map_pin_index.local_y] * conversion.zoom_factor) + conversion.y
          --internal.dm("Verbose", new_element[lib.quest_map_pin_index.local_x])
          --internal.dm("Verbose", new_element[lib.quest_map_pin_index.local_y])
          table.insert(all_zone_quests, new_element)
          local questId = new_element[lib.quest_map_pin_index.quest_id]
          lib.quest_in_zone_list[questId] = true
        end
      end
    end
  end
  --internal.dm("Debug", all_zone_quests)

  local new_all_zone_quests = {}
  local displayName = GetDisplayName()
  local masterPlayer = displayName == "@Sharlikran"
  for key, quest_info in pairs(all_zone_quests) do
    local questId = quest_info[lib.quest_map_pin_index.quest_id]
    local questName = lib:get_quest_name(questId, lib.effective_lang)
    local questInfo = lib.quest_data[questId]
    local questSeries = nil
    if questInfo then
      questSeries = questInfo[lib.quest_data_index.quest_series]
    else
      questSeries = 0
    end
    local playerAlliance = GetUnitAlliance("player")
    local playerGuildRankData = nil
    local playerGuildQuestLevelRequirement = nil
    if questSeries >= lib.quest_series_type.quest_type_guild_mage or questSeries == lib.quest_series_type.quest_type_undaunted then
      -- this is set in function update_guild_skillline_data()
      playerGuildRankData = lib.quest_guild_rank_data[questSeries].rank
      if lib.guild_rank_quest_list[questSeries][questId] then
        playerGuildQuestLevelRequirement = lib.guild_rank_quest_list[questSeries][questId]
      end
    end
    local playerQualifies = true
    if playerGuildQuestLevelRequirement and playerGuildRankData then
      playerQualifies = playerGuildQuestLevelRequirement <= playerGuildRankData
    end

    local removedQuest = false
    if lib.known_removed_quest[questId] then
      removedQuest = true
    end
    --[[
    Pledges can be obtained from any location. Before this can be used All quests
    specific to an Alliance have to be manually reviewed. Otherwise Pledges
    will not show on the map.

    if questSeries >= 3 and questSeries <= 5 then
      playerQualifies = lib.playerAlliance[playerAlliance] == questSeries
    end
    ]]--
    if IsInImperialCity() or IsInCyrodiil() then
      --internal.dm("Debug", "The word cyrodiil was found.")
      if questSeries >= lib.quest_series_type.quest_type_ad and questSeries <= lib.quest_series_type.quest_type_ep then
        playerQualifies = lib.playerAlliance[playerAlliance] == questSeries
      end
    else
      --internal.dm("Debug", "The word cyrodiil was not found.")
    end
    local prerequisiteCompleted = internal:prerequisites_completed(questId)
    local showBreadcrumbQuest = internal:show_breadcrumb_quest(questId)
    local showCompanionQuest = true
    local showCertificationQuest = GetUnitLevel("player") >= 6 and lib.quest_certifications[questId]
    if lib:is_companion_quest(questId) then showCompanionQuest = internal:check_companion_rapport_requirements(questId) end

    --HasQuest(pinData.q)
    -- /script d(HasCompletedQuest(3686))
    if questSeries == lib.playerAlliance[playerAlliance] then
      internal.dm("Debug", string.format("[%s] %s : Completed(%s), Prerequisite (%s), Breadcrumb(%s), Companion(%s)", questId, GetQuestName(questId), tostring(HasCompletedQuest(questId)), tostring(prerequisiteCompleted), tostring(showBreadcrumbQuest), tostring(showCompanionQuest)))
    end

    if not quest_name_in_zone_list[questName] and playerQualifies and not removedQuest and prerequisiteCompleted and showBreadcrumbQuest and showCompanionQuest then
      -- name didn't exist keep it for sure
      quest_name_in_zone_list[questName] = questId
      table.insert(new_all_zone_quests, quest_info)
    else
      -- name exists already
      local questExists = questId == quest_name_in_zone_list[questName]
      local questUnknown = questName == lib.unknown_quest_name_string[lib.effective_lang]
      if questUnknown and playerQualifies and not removedQuest and prerequisiteCompleted and showBreadcrumbQuest and showCompanionQuest then
        --[[ the name of the quest in unknown because a localization
        has not been provided
        ]]--
        table.insert(new_all_zone_quests, quest_info)
      elseif questExists and playerQualifies and not removedQuest and prerequisiteCompleted and showBreadcrumbQuest and showCompanionQuest then
        --[[ the name is in the table, and the ID matches so keep it
        because it is another quest giver in a different place

        Otherwise it is a quest with the same name but a different
        Quest ID
        ]]--
        table.insert(new_all_zone_quests, quest_info)
      end
    end
  end

  -- clear quest_in_zone_list after everything is built
  lib.quest_in_zone_list = {}
  --internal.dm("Debug", all_zone_quests)
  return new_all_zone_quests
end

LMD:RegisterCallback(LMD.callbackType.EVENT_ZONE_CHANGED,
  function()
    lib.questGiverName = nil
    local zone = LMP:GetZoneAndSubzone(true, false, true)
    lib.zone_quests = lib:get_quest_list(zone)
  end)

LMD:RegisterCallback(LMD.callbackType.EVENT_LINKED_WORLD_POSITION_CHANGED,
  function()
    lib.questGiverName = nil
    local zone = LMP:GetZoneAndSubzone(true, false, true)
    lib.zone_quests = lib:get_quest_list(zone)
  end)

LMD:RegisterCallback(LMD.callbackType.OnWorldMapChanged,
  function()
    lib.questGiverName = nil
    local zone = LMP:GetZoneAndSubzone(true, false, true)
    lib.zone_quests = lib:get_quest_list(zone)
  end)

LMD:RegisterCallback(LMD.callbackType.WorldMapSceneStateChange,
  function()
    lib.questGiverName = nil
    local zone = LMP:GetZoneAndSubzone(true, false, true)
    lib.zone_quests = lib:get_quest_list(zone)
  end)

--[[ get whether or not it is a cadwell quest
return true if it is a cadwell quest
]]--
function lib:is_cadwell_quest(id)
  if type(id) == "number" then
    local c = lib.quest_cadwell[id] or false
    return c
  end
end

--[[ get whether or not it is a companion quest
return true if it is a companion quest
]]--
function lib:is_companion_quest(id)
  if type(id) == "number" then
    local c = lib.quest_companion[id] or false
    return c
  end
end

-------------------------------------------------
----- Assign Quest Flag                    ----
-------------------------------------------------
function lib:assign_quest_flag(questId, hidden_quest)
  local completed_quest = lib.completed_quests[questId] or false
  local started_quest = lib.started_quests[questId] or false
  local repeatable_type = lib:get_quest_repeat(questId)
  local skill_quest = lib.quest_rewards_skilpoint[questId] or false
  local cadwell_quest = lib:is_cadwell_quest(questId) or false
  local companion_quest = lib:is_companion_quest(questId) or false
  local quest_type_data = lib:get_quest_data(questId)
  local quest_type = quest_type_data[lib.quest_data_index.quest_type]
  local quest_display_type
  if quest_type_data[lib.quest_data_index.quest_display_type] then
    quest_display_type = quest_type_data[lib.quest_data_index.quest_display_type]
  else
    quest_display_type = INSTANCE_DISPLAY_TYPE_NONE
  end

  --internal.dm("Debug", completed_quest)
  --internal.dm("Debug", started_quest)
  --internal.dm("Debug", repeatable_type)
  --internal.dm("Debug", skill_quest)
  --internal.dm("Debug", cadwell_quest)
  --internal.dm("Debug", quest_type)
  --internal.dm("Debug", quest_display_type)

  local fcpq = false -- flag_completed_quest
  local fucq = false -- flag_uncompleted_quest
  local fhdq = false -- flag_hidden_quest
  local fstq = false -- flag_started_quest
  local fguq = false -- flag_guild_quest
  local fdaq = false -- flag_daily_quest
  local fskq = false -- flag_skill_quest
  local fcwq = false -- flag_cadwell_quest
  local fcaq = false -- flag_companion_quest
  local fduq = false -- flag_dungeon_quest
  local fhoq = false -- flag_holiday_quest
  local fwkq = false -- flag_weekly_quest
  local fzsq = false -- flag_zone_story_quest
  local fbgq = false -- flag_type_battleground
  local fprq = false -- flag_type_prologue
  local fpgq = false -- flag_type_pledge

  if completed_quest then fcpq = true end
  if not completed_quest then fucq = true end
  if hidden_quest then fhdq = true end
  if started_quest then fstq = true end
  if quest_type == lib.quest_data_type.quest_type_guild then fguq = true end
  if repeatable_type == lib.quest_data_repeat.quest_repeat_daily then fdaq = true end
  if skill_quest then fskq = true end
  if cadwell_quest then fcwq = true end
  if companion_quest then fcaq = true end
  if quest_type == lib.quest_data_type.quest_type_dungeon then fduq = true end
  if quest_type == lib.quest_data_type.quest_type_holiday_event then fhoq = true end
  if repeatable_type == lib.quest_data_repeat.quest_repeat_repeatable then fwkq = true end
  if quest_type == lib.quest_data_type.quest_type_battleground then fbgq = true end
  if quest_type == lib.quest_data_type.quest_type_prologue then fprq = true end
  if quest_type == lib.quest_data_type.quest_type_undaunted_pledge then fpgq = true end

  if quest_display_type == lib.quest_display_type.zone_story then fzsq = true end
  --[[ there needs to be a way to hide quests you can't repeat that are marked as
  battleground or some other uncommon type

  unsure if I want a global flag type and just use this to keep a battleground quest
  like For Glory from showing up if you did it already
  ]]--
  local fnrq = false
  if repeatable_type == lib.quest_data_repeat.quest_repeat_not_repeatable then fnrq = true end

  --[[
  holliday, daily, and WEEKLY quests are unique

  holliday happens only durring the event
  Weekly can be done once per week, like a trial quest
  daily can be done once per day
  ]]--
  if fhoq then
    return lib.flag_holiday_quest
  end
  if fwkq then
    return lib.flag_weekly_quest
  end
  if fpgq then
    return lib.flag_type_pledge
  end
  if fdaq and (not fhoq or not fwkq or not fpgq) then
    return lib.flag_daily_quest
  end
  -- battleground
  if fbgq and fnrq and not completed_quest then
    return lib.flag_daily_quest
  end
  --[[
  Completed takes precedence over other states
  ]]--
  if fcpq and (not fdaq or not fwkq or not fhoq) then
    return lib.flag_completed_quest
  end

  --[[
  Only Uncompleted quests can be hidden so check for
  hidden first since you can click them to unhide them.
  Hidden should take precedence over uncompleted.
  ]]--
  if fhdq then
    return lib.flag_hidden_quest
  end

  --[[
  Started quests should not be hidden and started
  at the same time. The event for on_quest_added
  should take care of this.
  ]]--
  if fstq then
    return lib.flag_started_quest
  end

  --[[
  Cadwell and Skill quests are sort of unique. Completed
  should take precedence and if uncompleted these should
  take precedence over uncompleted.
  ]]--
  if fskq then
    return lib.flag_skill_quest
  end
  if fcaq then
    return lib.flag_companion_quest
  end
  if fcwq then
    return lib.flag_cadwell_quest
  end

  --[[
  new quest types
  ]]--
  if fguq then
    return lib.flag_guild_quest
  end
  if fduq then
    return lib.flag_dungeon_quest
  end
  if fzsq then
    return lib.flag_zone_story_quest
  end
  if fprq then
    return lib.flag_type_prologue
  end
  --[[
  Hopefully this is last
  ]]--
  if (fucq) then
    return lib.flag_uncompleted_quest
  end

  --[[
  Only one flag per quest and I hope it never
  gets here and is set to 0
  ]]--
  return 0
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
  return lib.quest_givers[lang][id]
end

function lib:get_quest_name(id, lang)
  local unknown = lib.unknown_quest_name_string[lib.effective_lang]
  lang = lang or lib.effective_lang
  return lib.quest_names[lang][id] or unknown
end

-------------------------------------------------
----- Lookup By Name: returns table of IDs   ----
-------------------------------------------------
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

-- contains_id is a helper for building the lookup tables
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

  for index = 1, #lib.quest_has_skill_point do
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

--[[

Get a table of quest IDs when given a quest name

Use: Drawing a pin with a different color if the player has started the
quest and has not finished it yet. Loop over the table

example:
for _, id in ipairs(ids) do
    started_quests[id] = true
end
--]]

function lib:is_quest_started(quest_id)
  local started = lib.started_quests
  for id, state in pairs(started) do
    if id == quest_id then return true end
  end
  return false
end

local function build_completed_quests()
  lib.completed_quests = {}
  local fakeQuestId
  local apiQuestname
  for i = 0, 7500 do
    fakeQuestId = i
    apiQuestname = GetQuestName(fakeQuestId)
    if apiQuestname ~= "" then
      if HasCompletedQuest(fakeQuestId) then
        if lib.quest_names[lib.effective_lang][fakeQuestId] ~= apiQuestname then
          --internal.dm("Debug", "~= quest_name")
          LibQuestData_SavedVariables["quest_names"][fakeQuestId] = apiQuestname
        end
        if lib.quest_names[lib.effective_lang][fakeQuestId] == nil then
          --internal.dm("Debug", "== nil")
          LibQuestData_SavedVariables["quest_names"][fakeQuestId] = apiQuestname
        end
        lib.completed_quests[fakeQuestId] = true
        lib:set_conditional_quests(fakeQuestId)
      end
    end
  end
end

--[[ update the completed quest list without loop
when the player completes a quest
]]--
local function update_completed_quests(quest_id)
  lib.completed_quests[quest_id] = true
end

local function update_started_quests()
  -- Get names of started quests from quest journal, get quest ID from lookup table
  lib.started_quests = {}
  for i = 1, GetNumJournalQuests() do
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

local function update_guild_skillline_data()
  for i = 1, GetNumSkillLines(SKILL_TYPE_GUILD) do
    local skillLineName, skillLineLevel, _, skillLineId = GetSkillLineInfo(SKILL_TYPE_GUILD, i)
    for key, guild_name in pairs(lib.quest_guild_names) do
      if skillLineName == guild_name then
        lib.quest_guild_rank_data[key].name = skillLineName
        lib.quest_guild_rank_data[key].rank = skillLineLevel
      end
    end
  end
end

local function on_skill_rank_update(eventCode, skillType, skillLineIndex, rank)
  update_guild_skillline_data()
end
EVENT_MANAGER:RegisterForEvent(lib.libName .. "_skill_rank_updater", EVENT_SKILL_RANK_UPDATE, on_skill_rank_update)

local function on_quest_added(eventCode, journalIndex, questName, objectiveName)
  update_started_quests()
end
EVENT_MANAGER:RegisterForEvent(lib.libName .. "_quest_added_updater", EVENT_QUEST_ADDED, on_quest_added)

local function on_quest_removed(eventCode, isCompleted, journalIndex, questName, zoneIndex, poiIndex, questID)
  update_started_quests()
  if isCompleted then
    update_completed_quests(questID)
  end
end
EVENT_MANAGER:RegisterForEvent(lib.libName .. "_quest_removed_updater", EVENT_QUEST_REMOVED, on_quest_removed)

-- Event handler function for EVENT_PLAYER_ACTIVATED
local function update_quest_information()
  internal.dm("Debug", "update_quest_information")
  local eight_field_data = {
    quest_name = 1, -- Depreciated, use lib:get_quest_name(id, lang)
    quest_giver = 2, -- Depreciated, see quest_map_pin_index
    quest_type = 3, -- MAIN_STORY, DUNGEON << -1 = Undefined >>
    quest_repeat = 4, -- quest_repeat_daily, quest_repeat_not_repeatable = 0, quest_repeat_repeatable << -1 = Undefined >>
    game_api = 5, -- 100003 means unverified, 100030 or higher means recent quest data
    quest_line = 6, -- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
    quest_number = 7, -- Quest Number In QuestLine (10000 = not assigned/not verified)
    quest_series = 8, -- None = 0,    Cadwell's Almanac = 1,    Undaunted = 2, AD = 3, DC = 4, EP = 5.
  }
  local seven_field_data = {
    quest_name = 1, -- Depreciated, use lib:get_quest_name(id, lang)
    -- quest_giver     =    2,  Depreciated, see quest_map_pin_index
    quest_type = 2, -- MAIN_STORY, DUNGEON << -1 = Undefined >>
    quest_repeat = 3, -- quest_repeat_daily, quest_repeat_not_repeatable = 0, quest_repeat_repeatable << -1 = Undefined >>
    game_api = 4, -- 100003 means unverified, 100030 or higher means recent quest data
    quest_line = 5, -- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
    quest_number = 6, -- Quest Number In QuestLine (10000 = not assigned/not verified)
    quest_series = 7, -- None = 0,    Cadwell's Almanac = 1,    Undaunted = 2, AD = 3, DC = 4, EP = 5.
  }
  local five_field_location = {
    local_x = 1, -- GetMapPlayerPosition() << -10 = Undefined >>
    local_y = 2, -- GetMapPlayerPosition() << -10 = Undefined >>
    global_x = 3, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
    global_y = 4, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
    quest_id = 5, -- Number index of quest name i.e. 6404 for "The Dragonguard"  << -1 = Undefined >>
  }
  local nine_field_location = {
    local_x = 1, -- GetMapPlayerPosition() << -10 = Undefined >>
    local_y = 2, -- GetMapPlayerPosition() << -10 = Undefined >>
    global_x = 3, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
    global_y = 4, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
    quest_id = 5, -- Number index of quest name i.e. 6404 for "The Dragonguard"  << -1 = Undefined >>
    world_x = 6, -- Depreciated, WorldX 3D Location << -10 = Undefined >>
    world_y = 7, -- Depreciated, WorldY 3D Location << -10 = Undefined >>
    world_z = 8, -- Depreciated, WorldZ 3D Location << -10 = Undefined >>
    quest_giver = 9, -- Updated, was 9 now 6, Arbitrary number pointing to an NPC Name 81004, "Abnur Tharn"  << -1 = Undefined >>
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
  local currentQuestInfoFormat = false
  local quests_from_zone = {}

  for zone, zone_quests in pairs(all_locations) do
    for index, quest in pairs(zone_quests) do
      current_data = {}
      if #quest == 5 then
        current_data[lib.quest_map_pin_index.local_x] = quest[five_field_location.local_x]
        current_data[lib.quest_map_pin_index.local_y] = quest[five_field_location.local_y]
        current_data[lib.quest_map_pin_index.global_x] = quest[five_field_location.global_x]
        current_data[lib.quest_map_pin_index.global_y] = quest[five_field_location.global_y]
        current_data[lib.quest_map_pin_index.quest_id] = quest[five_field_location.quest_id]
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
        current_data[lib.quest_map_pin_index.local_x] = quest[nine_field_location.local_x]
        current_data[lib.quest_map_pin_index.local_y] = quest[nine_field_location.local_y]
        current_data[lib.quest_map_pin_index.global_x] = quest[nine_field_location.global_x]
        current_data[lib.quest_map_pin_index.global_y] = quest[nine_field_location.global_y]
        current_data[lib.quest_map_pin_index.quest_id] = quest[nine_field_location.quest_id]
        current_data[lib.quest_map_pin_index.quest_giver] = quest[nine_field_location.quest_giver]
        quest = current_data
      end
      if #quest == 6 then
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
    -- old data when the name was part of the data
    local oldSevenFieldData = type(data[seven_field_data.quest_name]) == "string"
    if #data == 7 and oldSevenFieldData then
      --internal.dm("Debug", "Old 7 field data")
      current_data[lib.quest_data_index.quest_type] = data[seven_field_data.quest_type]
      current_data[lib.quest_data_index.quest_repeat] = data[seven_field_data.quest_repeat]
      current_data[lib.quest_data_index.game_api] = data[seven_field_data.game_api]
      current_data[lib.quest_data_index.quest_line] = data[seven_field_data.quest_line]
      current_data[lib.quest_data_index.quest_number] = data[seven_field_data.quest_number]
      current_data[lib.quest_data_index.quest_series] = data[seven_field_data.quest_series]
    end
    if (#data == 6) or (#data == 7 and not oldSevenFieldData) then
      --internal.dm("Debug", "Previous 6 field data or New 7 field data")
      current_data = data
      currentQuestInfoFormat = true
    end

    if not lib.quest_data[index] then
      if rebuilt_data[index] == nil then rebuilt_data[index] = {} end
      rebuilt_data[index] = current_data
    elseif lib.quest_data[index] and not lib.quest_data[index][lib.quest_data_index.quest_display_type] and currentQuestInfoFormat then
      if rebuilt_data[index] == nil then rebuilt_data[index] = {} end
      rebuilt_data[index] = current_data
    else
      local newerAPI = false
      if current_data[lib.quest_data_index.game_api] > lib.quest_data[index][lib.quest_data_index.game_api] then newerAPI = true end
      local hasAva = false
      if current_data[lib.quest_data_index.quest_series] >= lib.quest_series_type.quest_type_ad and current_data[lib.quest_data_index.quest_series] <= lib.quest_series_type.quest_type_ep then
        hasAva = true
      end

      if newerAPI or hasAva then
        if rebuilt_data[index] == nil then rebuilt_data[index] = {} end
        rebuilt_data[index] = current_data
      end
    end
  end

  LibQuestData_SavedVariables["location_info"] = rebuilt_locations
  LibQuestData_SavedVariables["quest_info"] = rebuilt_data

  for index, data in pairs(all_quest_names) do
    if lib.quest_names[lib.effective_lang][index] then
      if LibQuestData_SavedVariables["quest_names"][index] == lib.quest_names[lib.effective_lang][index] then
        --internal.dm("Debug", "quest_name matched")
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
      -- when the value is 9
      if reward_data == REWARD_TYPE_PARTIAL_SKILL_POINTS then
        if not lib.quest_rewards_skilpoint[quest_id] then
          saved_reward_info[quest_id] = rewards
        end
      end
    end
  end
  LibQuestData_SavedVariables["reward_info"] = saved_reward_info

  current_data = {}
  local added = false
  local in_range_missing = false
  local in_range_good_data = false
  local in_range_missing_giver = false
  local quest_not_found
  local total_count = 0
  local count_added = 0
  local count_stashed = 0
  local strored_data = {}
  local the_quest_from_save = nil
  local the_quest_from_save_id = nil
  for zone, zone_quests in pairs(rebuilt_locations) do
    for index, quest_from_save in pairs(zone_quests) do
      total_count = total_count + 1
      quests_from_zone = internal:get_zone_quests(zone)
      in_range_missing = false
      in_range_good_data = false
      in_range_missing_giver = false
      quest_not_found = true
      the_quest_from_save = quest_from_save
      the_quest_from_save_id = the_quest_from_save[lib.quest_map_pin_index.quest_id]
      for quests_from_zone_index, quests_from_zone_data in pairs(quests_from_zone) do
        local quests_from_zone_data_id = quests_from_zone_data[lib.quest_map_pin_index.quest_id]
        if the_quest_from_save_id == quests_from_zone_data_id then
          if internal:quest_in_range(quests_from_zone_data, the_quest_from_save) then
            if internal:missing_gps_data(quests_from_zone_data) then
              --internal.dm("Debug", "[Found] Quest in range and missing GPS data")
              --internal.dm("Debug", quests_from_zone_data)
              --internal.dm("Debug", the_quest_from_save)
              in_range_missing = true
              quest_not_found = false
            end
            if not internal:missing_gps_data(quests_from_zone_data) and not internal:missing_quest_giver(quests_from_zone_data) then
              --internal.dm("Debug", "[Found] Quest in range and zone quest has good data")
              --internal.dm("Debug", quests_from_zone_data)
              --internal.dm("Debug", the_quest_from_save)
              in_range_good_data = true
              quest_not_found = false
            end
            if not internal:missing_gps_data(the_quest_from_save) and internal:missing_quest_giver(the_quest_from_save) then
              --internal.dm("Debug", "[Found] Quest in range with no giver so that needs to be looked at")
              --internal.dm("Debug", quests_from_zone_data)
              --internal.dm("Debug", the_quest_from_save)
              in_range_good_data = false
              in_range_missing = false
              in_range_missing_giver = true
              quest_not_found = false
            end
          end
        end
      end
      if in_range_missing then
        --internal.dm("Debug", "[Save] Flagged as in_range_missing")
        count_added = count_added + 1
        -- keep the_quest_from_save
        if current_data[zone] == nil then current_data[zone] = {} end
        table.insert(current_data[zone], the_quest_from_save)
        added = true
      end
      if in_range_good_data then
        --internal.dm("Debug", "[Stash] Flagged as in_range_good_data")
        if strored_data[zone] == nil then strored_data[zone] = {} end
        table.insert(strored_data[zone], the_quest_from_save)
        count_stashed = count_stashed + 1
      end
      if in_range_missing_giver then
        --internal.dm("Debug", "[Save] Flagged as in_range_missing_giver")
        count_added = count_added + 1
        -- keep the_quest_from_save
        if current_data[zone] == nil then current_data[zone] = {} end
        table.insert(current_data[zone], the_quest_from_save)
        added = true
      end
      if quest_not_found then
        --internal.dm("Debug", "[Save] Quest may not be in database, flagged as quest_not_found")
        count_added = count_added + 1
        -- keep the_quest_from_save
        if current_data[zone] == nil then current_data[zone] = {} end
        table.insert(current_data[zone], the_quest_from_save)
        added = true
      end
    end
  end
  if added then
    LibQuestData_SavedVariables["location_info"] = current_data
  end
  internal.dm("Debug", string.format("Quest total: %s", total_count))
  internal.dm("Debug", string.format("Quests added: %s", count_added))
  internal.dm("Debug", string.format("Quests stashed: %s", count_stashed))
  LibQuestData_SavedVariables["strored_data"] = strored_data

  -- set last so we can check this and not update old data
  LibQuestData_SavedVariables.libVersion = lib.libVersion
end

local function OnPlayerActivatedQuestBuild(eventCode, initial)
  internal.dm("Debug", "OnPlayerActivatedQuestBuild")
  build_completed_quests()
  update_started_quests()
  update_quest_information()

  EVENT_MANAGER:UnregisterForEvent(lib.libName .. "_BuildQuests", EVENT_PLAYER_ACTIVATED)
end
EVENT_MANAGER:RegisterForEvent(lib.libName .. "_BuildQuests", EVENT_PLAYER_ACTIVATED, OnPlayerActivatedQuestBuild)

-- Event handler function for EVENT_ADD_ON_LOADED
local function OnLoad(eventCode, addOnName)
  if addOnName ~= lib.libName then return end
  internal.dm("Debug", "OnLoad")

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
    LibQuestData_SavedVariables.effective_lang = lib.effective_lang
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
  if LibQuestData_SavedVariables.effective_lang == nil then LibQuestData_SavedVariables.effective_lang = lib.effective_lang end

  if lib.client_lang ~= LibQuestData_SavedVariables.client_lang then LibQuestData_SavedVariables.client_lang = lib.client_lang end

  lib:build_questid_table(lib.effective_lang) -- build name lookup table once
  lib:build_npcid_table(lib.effective_lang) -- build npc names lookup table once
  lib:build_questlist_skilpoint() -- build list of quests that reward a skill point
  update_guild_skillline_data()
  build_completed_quests()

  EVENT_MANAGER:UnregisterForEvent(lib.libName, EVENT_ADD_ON_LOADED)
end
EVENT_MANAGER:RegisterForEvent(lib.libName, EVENT_ADD_ON_LOADED, OnLoad)
