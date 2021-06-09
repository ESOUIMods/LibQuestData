local libName, libVersion   = "LibQuestData", 226
local lib                   = {}
local internal              = {}
_G["LibQuestData"]          = lib
_G["LibQuestData_Internal"] = internal

-------------------------------------------------
----- Logger Function                       -----
-------------------------------------------------

local logger                = LibDebugLogger.Create(libName)
internal.logger             = logger
internal.show_log           = false
local SDLV                  = DebugLogViewer

local function create_log(log_type, log_content)
  if internal.logger and SDLV then
    if log_type == "Debug" then
      internal.logger:Debug(log_content)
    end
    if log_type == "Verbose" then
      internal.logger:Verbose(log_content)
    end
  else
    CHAT_ROUTER:AddSystemMessage(log_content)
  end
end

local function emit_message(log_type, text)
  if (text == "") then
    text = "[Empty String]"
  end
  create_log(log_type, text)
end

local function emit_table(log_type, t, indent, table_history)
  indent        = indent or "."
  table_history = table_history or {}

  for k, v in pairs(t) do
    local vType = type(v)

    emit_message(log_type, indent .. "(" .. vType .. "): " .. tostring(k) .. " = " .. tostring(v))

    if (vType == "table") then
      if (table_history[v]) then
        emit_message(log_type, indent .. "Avoiding cycle on table...")
      else
        table_history[v] = true
        emit_table(log_type, v, indent .. "  ", table_history)
      end
    end
  end
end

function internal.dm(log_type, ...)
  if not internal.show_log then return end
  for i = 1, select("#", ...) do
    local value = select(i, ...)
    if (type(value) == "table") then
      emit_table(log_type, value)
    else
      emit_message(log_type, tostring(value))
    end
  end
end

-------------------------------------------------
----- early helper                          -----
-------------------------------------------------

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
----- lib                                   -----
-------------------------------------------------

lib.quest_givers     = {}
lib.quest_names      = {}
lib.client_lang      = GetCVar("Language.2")
lib.effective_lang   = nil
local supported_lang = { "br", "de", "en", "es", "fr", "fx", "it", "jp", "kb", "kr", "pl", "ru", "tr", }
if internal:is_in(lib.client_lang, supported_lang) then
  lib.effective_lang = lib.client_lang
else
  lib.effective_lang = "en"
end
lib.supported_lang              = lib.client_lang == lib.effective_lang
--[[
    ALLIANCE_ALDMERI_DOMINION = 1
    ALLIANCE_EBONHEART_PACT = 2
    ALLIANCE_DAGGERFALL_COVENANT = 3
]]--
--[[ Reward Data from GetJournalQuestRewardInfo
    REWARD_TYPE_PARTIAL_SKILL_POINTS -- Skill Point
]]--
lib.player_alliance             = GetUnitAlliance("player")
lib.libName                     = libName
lib.libVersion                  = libVersion

lib.name_to_questid_table       = {}
lib.name_to_questid_table["br"] = {}
lib.name_to_questid_table["de"] = {}
lib.name_to_questid_table["en"] = {}
lib.name_to_questid_table["es"] = {}
lib.name_to_questid_table["fr"] = {}
lib.name_to_questid_table["fx"] = {}
lib.name_to_questid_table["it"] = {}
lib.name_to_questid_table["jp"] = {}
lib.name_to_questid_table["kb"] = {}
lib.name_to_questid_table["kr"] = {}
lib.name_to_questid_table["pl"] = {}
lib.name_to_questid_table["ru"] = {}
lib.name_to_questid_table["tr"] = {}

lib.name_to_npcid_table         = {}
lib.name_to_npcid_table["br"]   = {}
lib.name_to_npcid_table["de"]   = {}
lib.name_to_npcid_table["en"]   = {}
lib.name_to_npcid_table["es"]   = {}
lib.name_to_npcid_table["fr"]   = {}
lib.name_to_npcid_table["fx"]   = {}
lib.name_to_npcid_table["it"]   = {}
lib.name_to_npcid_table["jp"]   = {}
lib.name_to_npcid_table["kb"]   = {}
lib.name_to_npcid_table["kr"]   = {}
lib.name_to_npcid_table["pl"]   = {}
lib.name_to_npcid_table["ru"]   = {}
lib.name_to_npcid_table["tr"]   = {}

lib.quest_rewards_skilpoint     = {}
lib.started_quests              = {}
lib.completed_quests            = {}
lib.last_interaction_target     = ""

-- added 4/4/2021 to hold map information
lib.zone_quests                 = {}
lib.last_mapid                  = 0
lib.current_mapid               = 0
lib.last_zone                   = ""
lib.current_zone                = ""

if LibQuestData_SavedVariables == nil then LibQuestData_SavedVariables = {} end

if LibQuestData_SavedVariables.version == nil then LibQuestData_SavedVariables.version = LibQuestData_SavedVariables.version or 1 end
if LibQuestData_SavedVariables.libVersion == nil then LibQuestData_SavedVariables.libVersion = LibQuestData_SavedVariables.libVersion or lib.libVersion end
if LibQuestData_SavedVariables.quests == nil then LibQuestData_SavedVariables.quests = {} end
if LibQuestData_SavedVariables.quest_info == nil then LibQuestData_SavedVariables.quest_info = {} end
if LibQuestData_SavedVariables.location_info == nil then LibQuestData_SavedVariables.location_info = {} end
if LibQuestData_SavedVariables.quest_names == nil then LibQuestData_SavedVariables.quest_names = {} end
if LibQuestData_SavedVariables.reward_info == nil then LibQuestData_SavedVariables.reward_info = {} end
if LibQuestData_SavedVariables.giver_names == nil then LibQuestData_SavedVariables.giver_names = {} end

-- note only the "lib.client_lang" will contain data be default

lib.quest_data_index                             = {
  -- quest_name      =    1, Depreciated, use lib:get_quest_name(id, lang)
  -- quest_giver     =    2,  Depreciated, see quest_map_pin_index
  quest_type = 1, -- MAIN_STORY, DUNGEON << -1 = Undefined >>
  quest_repeat = 2, -- quest_repeat_daily, quest_repeat_not_repeatable = 0, quest_repeat_repeatable << -1 = Undefined >>
  game_api = 3, -- 100003 means unverified, 100030 or higher means recent quest data
  quest_line = 4, -- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
  quest_number = 5, -- Quest Number In QuestLine (10000 = not assigned/not verified)
  quest_series = 6, -- None = 0,    Cadwell's Almanac = 1,    Undaunted = 2, AD = 3, DC = 4, EP = 5.
}

lib.quest_map_pin_index                          = {
  local_x = 1, -- GetMapPlayerPosition() << -10 = Undefined >>
  local_y = 2, -- GetMapPlayerPosition() << -10 = Undefined >>
  global_x = 3, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
  global_y = 4, -- LocalToGlobal(GetMapPlayerPosition()) << -10 = Undefined >>
  quest_id = 5, -- Number index of quest name i.e. 6404 for "The Dragonguard"  << -1 = Undefined >>
  -- world_x     =    6, Depreciated, WorldX 3D Location << -10 = Undefined >>
  -- world_y     =    7, Depreciated, WorldY 3D Location << -10 = Undefined >>
  -- world_z     =    8, Depreciated, WorldZ 3D Location << -10 = Undefined >>
  -- quest_giver =    9, Updated, was 9 now 6
  quest_giver = 6, -- Arbitrary number pointing to an NPC Name 81004, "Abnur Tharn"  << -1 = Undefined >>
}

lib.quest_data_type                              = {
  -- ESO Values
  quest_type_none = 0,
  quest_type_group = 1, -- Qty 75
  quest_type_main_story = 2, -- Qty 16
  quest_type_guild = 3, -- Qty 111, (*) Various Skill Line Guild Quests
  quest_type_crafting = 4, -- Qty 82, Ignore these they are the crafting certifications
  quest_type_dungeon = 5, -- Qty 77
  quest_type_raid = 6, -- Qty 7
  quest_type_ava = 7, -- Qty 117, unsure if verified
  quest_type_class = 8, -- None in table
  -- quest_type_qa_test = 9, not in game as far as I know
  quest_type_ava_group = 10, -- None in table, in check
  quest_type_ava_grand = 11, -- None in table, in check
  quest_type_holiday_event = 12, -- Qty 22
  quest_type_battleground = 13, -- Qty 4
  quest_type_prologue = 14, -- Qty 14
  quest_type_undaunted_pledge = 15, -- Qty 42
}

lib.quest_series_type                            = {
  -- LibQuestData Values
  quest_type_none = 0,
  quest_type_cadwell = 1,
  quest_type_undaunted = 2,
  quest_type_ad = 3,
  quest_type_dc = 4,
  quest_type_ep = 5,
  quest_type_guild_mage = 6,
  quest_type_guild_fighter = 7,
  quest_type_guild_psijic = 8,
  quest_type_guild_thief = 9,
  quest_type_guild_dark = 10, -- Dark Brotherhood
}

lib.playerAlliance                               = {}
lib.playerAlliance[ALLIANCE_ALDMERI_DOMINION]    = lib.quest_series_type.quest_type_ad
lib.playerAlliance[ALLIANCE_DAGGERFALL_COVENANT] = lib.quest_series_type.quest_type_dc
lib.playerAlliance[ALLIANCE_EBONHEART_PACT]      = lib.quest_series_type.quest_type_ep

lib.quest_guild_names                            = {
  [lib.quest_series_type.quest_type_guild_mage] = "Mages Guild",
  [lib.quest_series_type.quest_type_guild_fighter] = "Fighters Guild",
  [lib.quest_series_type.quest_type_guild_psijic] = "Psijic Order",
  [lib.quest_series_type.quest_type_guild_thief] = "Thieves Guild",
  [lib.quest_series_type.quest_type_guild_dark] = "Dark Brotherhood",
  [lib.quest_series_type.quest_type_undaunted] = "Undaunted",
}

lib.quest_guild_rank_data                        = {
  [lib.quest_series_type.quest_type_undaunted] = { name = "", rank = 0, },
  [lib.quest_series_type.quest_type_guild_mage] = { name = "", rank = 0, },
  [lib.quest_series_type.quest_type_guild_fighter] = { name = "", rank = 0, },
  [lib.quest_series_type.quest_type_guild_psijic] = { name = "", rank = 0, },
  [lib.quest_series_type.quest_type_guild_thief] = { name = "", rank = 0, },
  [lib.quest_series_type.quest_type_guild_dark] = { name = "", rank = 0, },
}

lib.quest_data_repeat                            = {
  quest_repeat_not_repeatable = 0,
  quest_repeat_repeatable = 1,
  quest_repeat_daily = 2,
  quest_repeat_repeatable_per_duration = 3,
  quest_repeat_event_reset = 4,
}

lib.dest_quest_data_index                        = {
  quest_x = 1,
  quest_y = 2,
  questnpc = 3,
  questtype = 4,
  questrepeat = 5,
  questid = 6,
  questline = 7, -- QuestLine (10000 = not assigned/not verified. 10001 = not part of a quest line/verified)
  questnumber = 8, -- Quest Number In QuestLine (10000 = not assigned/not verified)
  questseries = 9, -- None = 0,	Cadwell's Almanac = 1,	Undaunted = 2, AD = 3, DC = 4, EP = 5.
}

lib.dest_quest_series_index                      = {
  quest_series_none = 0,
  quest_series_cadwell = 1,
  quest_series_undaunted = 2,
  quest_series_ad = 3,
  quest_series_dc = 4,
  quest_series_ep = 5,
}

lib.unknown_quest_name_string = {
  ["br"] = "Nome Desconhecido",
  ["de"] = "Unbekannter Name",
  ["en"] = "Unknown Name",
  ["es"] = "Nombre desconocido",
  ["fr"] = "Nom inconnu",
  ["fx"] = "Nieznane imię",
  ["it"] = "Nome sconosciuto",
  ["jp"] = "不明な名前",
  ["kb"] = "알 수없는 이름",
  ["kr"] = "알 수없는 이름",
  ["pl"] = "Nieznane imię",
  ["ru"] = "Неизвестное имя",
  ["tr"] = "알 수없는 이름",
}
