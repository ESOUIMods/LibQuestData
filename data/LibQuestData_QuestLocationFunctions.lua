--[[
-------------------------------------------------------------------------------
-- LibQuestData
-------------------------------------------------------------------------------
-- Original data sources: SnowmanDK (Destinations), CaptainBlagbird (Quest Map)
-- Initial integration and library creation by Sharlikran
-- LibQuestInfo created 2020-05-17, renamed to LibQuestData 2020-06-13
-- Maintained by Sharlikran since 2020-05-17
--
-------------------------------------------------------------------------------
-- License: MIT License
--   Permission is hereby granted, free of charge, to any person obtaining a copy
--   of this software and associated documentation files (the "Software"), to deal
--   in the Software without restriction, including without limitation the rights
--   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--   copies of the Software, and to permit persons to whom the Software is
--   furnished to do so, subject to the conditions in the LICENSE file.
--
-------------------------------------------------------------------------------
-- Data Integrity and Attribution Notice:
-- While quest information can be collected using the ESO API, the compiled
-- dataset in LibQuestData is the result of years of effort by multiple addon
-- projects and contributors. This includes legacy data from Quest Map and
-- Destinations, merged and maintained with continued contributions since 2020.
--
-- Reuse, redistribution, or repackaging of the quest data (in whole or part)
-- without permission is discouraged. Claiming authorship of derived works
-- without proper attribution violates the intent of open collaboration and
-- disrespects the extensive effort by past and present contributors.
-------------------------------------------------------------------------------
]]
function LibQuestData_GetLocations(zone)
  return LibQuestData_QuestLocationData[zone] or {}
end

function LibQuestData_GetZoneQuests(zone)
  local zone_data = LibQuestData_GetLocations(zone)
  return ZO_DeepTableCopy(zone_data)
end

function LibQuestData_GetAllZones()
  local zones = {}
  for zone, data in pairs(LibQuestData_QuestLocationData) do
    zones[zone] = ZO_DeepTableCopy(data)
  end
  return zones
end
