-- Init
local lib = _G["LibQuestData"]
local internal = _G["LibQuestData_Internal"]

-- Libraries
local LMP = LibMapPins
local GPS = LibGPS3
local LMD = LibMapData

local prerequisite_table = {
  [143] = { -- Embracing the Darkness
    142, -- Peering Into Darkness
  },
  [465] = { -- The Blood-Splattered Shield
    4903, -- Dream-Walk Into Darkness
  },
  [467] = { -- Sir Hughes' Fate
    737, -- Retaking Firebrand Keep
    2576, -- Tracking Sir Hughes
  },
  [499] = { -- Pursuing the Shard
    1541, -- A Prison of Sleep
  },
  [521] = { -- Azura's Aid
    3637, -- Godrun's Dream
  },
  [575] = { -- Vaermina's Gambit
    521, -- Azura's Aid
  },
  [737] = { -- Retaking Firebrand Keep
    736, -- The Flame of Dissent
  },
  [973] = { -- Weller's Counter Offer
    974, -- A Duke in Exile
  },
  [1339] = { -- A Predator's Heart
    2536, -- Plowshares to Swords
  },
  [1346] = { -- Ending the Ogre Threat
    1437, -- General Godrun's Orders
  },
  [1437] = { -- General Godrun's Orders
    1639, -- Another Omen
  },
  [1527] = { -- The Sower Reaps
    1485, -- They Dragged Him Away
  },
  [1529] = { -- Azura's Guardian
    1536, -- Fire in the Fields
  },
  [1541] = { -- A Prison of Sleep
    1529, -- Azura's Guardian
  },
  [1568] = { -- A Means to an End
    1554, -- Blood Revenge
  },
  [1633] = { -- The Return of the Dream Shard
    2497, -- Saving Hosni
  },
  [1639] = { -- Another Omen
    1633, -- The Return of the Dream Shard
  },
  [1709] = { -- Rozenn's Dream
    1678, -- The Slumbering Farmer
  },
  [1735] = { -- Unanswered Questions
    467, -- Sir Hughes' Fate
  },
  [1834] = { -- Heart of Evil
    3280, -- Imperial Infiltration
  },
  [1839] = { -- Box Clicking For the Win!
    1815, -- Greg's Training Quest
  },
  [2017] = { -- The Lion's Den
    2016, -- Hallin's Burden
  },
  [2018] = { -- A Thirst for Revolution
    2017, -- The Lion's Den
  },
  [2047] = { -- The Gate to Quagmire
    2046, -- Dreams to Nightmares
  },
  [2146] = { -- The Impervious Vault
    2130, -- Rise of the Dead
  },
  [2184] = { -- Tu'whacca's Breath
    2146, -- The Impervious Vault
  },
  [2192] = { -- A Reckoning with Uwafa
    2184, -- Tu'whacca's Breath
  },
  [2193] = { -- The Scholar of Bergama
    2192, -- A Reckoning with Uwafa
  },
  [2222] = { -- Alasan's Plot
    2192, -- A Reckoning with Uwafa
  },
  [2240] = { -- Shiri's Research
    2222, -- Alasan's Plot
  },
  [2403] = { -- The Search for Shiri
    3296, -- Trials of the Hero
  },
  [2408] = { -- In Search of the Ash'abah
    2146, -- The Impervious Vault
  },
  [2450] = { -- A Woman Wronged
    2451, -- A Ransom for Miranda
  },
  [2495] = { -- The Signet Ring
    499, -- Pursuing the Shard
  },
  [2496] = { -- Evidence Against Adima
    2495, -- The Signet Ring
  },
  [2497] = { -- Saving Hosni
    2496, -- Evidence Against Adima
  },
  [2536] = { -- Plowshares to Swords
    1384, -- Old Adventurers
  },
  [2538] = { -- Gift from a Suitor
    614, -- A Look in the Mirror
  },
  [2564] = { -- Two Sides to Every Coin
    2552, -- Army at the Gates
  },
  [2566] = { -- Life of the Duchess
    2564, -- Two Sides to Every Coin
  },
  [2567] = { -- The Safety of the Kingdom
    2566, -- Life of the Duchess
  },
  [2576] = { -- Tracking Sir Hughes
    2567, -- The Safety of the Kingdom
  },
  [2578] = { -- Scamp Invasion
    2561, -- A Family Affair
  },
  [2608] = { -- The Elder Scroll of Ghartok
    4724, -- Reporting for Duty
  },
  [2609] = { -- The Elder Scroll of Chim
    4724, -- Reporting for Duty
  },
  [2610] = { -- The Elder Scroll of Altadoon
    4724, -- Reporting for Duty
  },
  [2611] = { -- The Elder Scroll of Mnem
    4724, -- Reporting for Duty
  },
  [2612] = { -- The Elder Scroll of Ni-Mohk
    4724, -- Reporting for Duty
  },
  [2613] = { -- The Elder Scroll of Alma Ruma
    4724, -- Reporting for Duty
  },
  [2634] = { -- The Elder Scroll of Ni-Mohk
    4727, -- Reporting for Duty
  },
  [2635] = { -- The Elder Scroll of Alma Ruma
    4727, -- Reporting for Duty
  },
  [2637] = { -- The Elder Scroll of Altadoon
    4727, -- Reporting for Duty
  },
  [2638] = { -- The Elder Scroll of Mnem
    4727, -- Reporting for Duty
  },
  [2639] = { -- The Elder Scroll of Ghartok
    4727, -- Reporting for Duty
  },
  [2640] = { -- The Elder Scroll of Chim
    4727, -- Reporting for Duty
  },
  [2655] = { -- The Elder Scroll of Altadoon
    4706, -- Reporting for Duty
  },
  [2656] = { -- The Elder Scroll of Mnem
    4706, -- Reporting for Duty
  },
  [2658] = { -- The Elder Scroll of Ghartok
    4706, -- Reporting for Duty
  },
  [2659] = { -- The Elder Scroll of Chim
    4706, -- Reporting for Duty
  },
  [2660] = { -- The Elder Scroll of Ni-Mohk
    4706, -- Reporting for Duty
  },
  [2661] = { -- The Elder Scroll of Alma Ruma
    4706, -- Reporting for Duty
  },
  [2672] = { -- Scout Fort Warden
    4706, -- Reporting for Duty
  },
  [2673] = { -- Scout Fort Rayles
    4706, -- Reporting for Duty
  },
  [2674] = { -- Scout Fort Glademist
    4706, -- Reporting for Duty
  },
  [2675] = { -- Scout Fort Ash
    4706, -- Reporting for Duty
  },
  [2676] = { -- Scout Fort Aleswell
    4706, -- Reporting for Duty
  },
  [2677] = { -- Scout Fort Dragonclaw
    4706, -- Reporting for Duty
  },
  [2678] = { -- Scout Chalman Keep
    4706, -- Reporting for Duty
  },
  [2679] = { -- Scout Arrius Keep
    4706, -- Reporting for Duty
  },
  [2680] = { -- Scout Kingscrest Keep
    4706, -- Reporting for Duty
  },
  [2682] = { -- Scout Farragut Keep
    4706, -- Reporting for Duty
  },
  [2683] = { -- Scout Blue Road Keep
    4706, -- Reporting for Duty
  },
  [2684] = { -- Scout Drakelowe Keep
    4706, -- Reporting for Duty
  },
  [2685] = { -- Scout Castle Alessia
    4706, -- Reporting for Duty
  },
  [2686] = { -- Scout Castle Faregyl
    4706, -- Reporting for Duty
  },
  [2688] = { -- Scout Castle Brindle
    4706, -- Reporting for Duty
  },
  [2690] = { -- Scout Castle Bloodmayne
    4706, -- Reporting for Duty
  },
  [2691] = { -- Scout Warden Mine
    4706, -- Reporting for Duty
  },
  [2692] = { -- Scout Rayles Mine
    4706, -- Reporting for Duty
  },
  [2693] = { -- Scout Glademist Mine
    4706, -- Reporting for Duty
  },
  [2694] = { -- Scout Ash Mine
    4706, -- Reporting for Duty
  },
  [2697] = { -- Scout Aleswell Mine
    4706, -- Reporting for Duty
  },
  [2698] = { -- Scout Dragonclaw Mine
    4706, -- Reporting for Duty
  },
  [2699] = { -- Scout Chalman Mine
    4706, -- Reporting for Duty
  },
  [2700] = { -- Scout Arrius Mine
    4706, -- Reporting for Duty
  },
  [2701] = { -- Scout Kingscrest Mine
    4706, -- Reporting for Duty
  },
  [2702] = { -- Scout Farragut Mine
    4706, -- Reporting for Duty
  },
  [2703] = { -- Scout Blue Road Mine
    4706, -- Reporting for Duty
  },
  [2704] = { -- Scout Drakelowe Mine
    4706, -- Reporting for Duty
  },
  [2705] = { -- Scout Alessia Mine
    4706, -- Reporting for Duty
  },
  [2706] = { -- Scout Faregyl Mine
    4706, -- Reporting for Duty
  },
  [2707] = { -- Scout Roebeck Mine
    4706, -- Reporting for Duty
  },
  [2708] = { -- Scout Brindle Mine
    4706, -- Reporting for Duty
  },
  [2709] = { -- Scout Black Boot Mine
    4706, -- Reporting for Duty
  },
  [2710] = { -- Scout Bloodmayne Mine
    4706, -- Reporting for Duty
  },
  [2721] = { -- Scout Warden Farm
    4706, -- Reporting for Duty
  },
  [2722] = { -- Scout Rayles Farm
    4706, -- Reporting for Duty
  },
  [2723] = { -- Scout Glademist Farm
    4706, -- Reporting for Duty
  },
  [2724] = { -- Scout Ash Farm
    4706, -- Reporting for Duty
  },
  [2726] = { -- Scout Aleswell Farm
    4706, -- Reporting for Duty
  },
  [2727] = { -- Scout Dragonclaw Farm
    4706, -- Reporting for Duty
  },
  [2728] = { -- Scout Chalman Farm
    4706, -- Reporting for Duty
  },
  [2729] = { -- Scout Arrius Farm
    4706, -- Reporting for Duty
  },
  [2730] = { -- Scout Kingscrest Farm
    4706, -- Reporting for Duty
  },
  [2731] = { -- Scout Farragut Farm
    4706, -- Reporting for Duty
  },
  [2732] = { -- Scout Blue Road Farm
    4706, -- Reporting for Duty
  },
  [2733] = { -- Scout Drakelowe Farm
    4706, -- Reporting for Duty
  },
  [2734] = { -- Scout Alessia Farm
    4706, -- Reporting for Duty
  },
  [2736] = { -- Scout Faregyl Farm
    4706, -- Reporting for Duty
  },
  [2737] = { -- Scout Roebeck Farm
    4706, -- Reporting for Duty
  },
  [2738] = { -- Scout Brindle Farm
    4706, -- Reporting for Duty
  },
  [2739] = { -- Scout Black Boot Farm
    4706, -- Reporting for Duty
  },
  [2740] = { -- Scout Bloodmayne Farm
    4706, -- Reporting for Duty
  },
  [2741] = { -- Scout Warden Lumbermill
    4706, -- Reporting for Duty
  },
  [2742] = { -- Scout Rayles Lumbermill
    4706, -- Reporting for Duty
  },
  [2743] = { -- Scout Glademist Lumbermill
    4706, -- Reporting for Duty
  },
  [2744] = { -- Scout Ash Lumbermill
    4706, -- Reporting for Duty
  },
  [2745] = { -- Scout Aleswell Lumbermill
    4706, -- Reporting for Duty
  },
  [2746] = { -- Scout Dragonclaw Lumbermill
    4706, -- Reporting for Duty
  },
  [2747] = { -- Scout Chalman Lumbermill
    4706, -- Reporting for Duty
  },
  [2748] = { -- Scout Arrius Lumbermill
    4706, -- Reporting for Duty
  },
  [2749] = { -- Scout Kingscrest Lumbermill
    4706, -- Reporting for Duty
  },
  [2750] = { -- Scout Farragut Lumbermill
    4706, -- Reporting for Duty
  },
  [2751] = { -- Scout Blue Road Lumbermill
    4706, -- Reporting for Duty
  },
  [2752] = { -- Scout Drakelowe Lumbermill
    4706, -- Reporting for Duty
  },
  [2753] = { -- Scout Alessia Lumbermill
    4706, -- Reporting for Duty
  },
  [2754] = { -- Scout Faregyl Lumbermill
    4706, -- Reporting for Duty
  },
  [2755] = { -- Scout Roebeck Lumbermill
    4706, -- Reporting for Duty
  },
  [2756] = { -- Scout Brindle Lumbermill
    4706, -- Reporting for Duty
  },
  [2757] = { -- Scout Black Boot Lumbermill
    4706, -- Reporting for Duty
  },
  [2758] = { -- Scout Bloodmayne Lumbermill
    4706, -- Reporting for Duty
  },
  [2759] = { -- Kill Enemy Players
    4727, -- Reporting for Duty
  },
  [2767] = { -- Scout Fort Warden
    4727, -- Reporting for Duty
  },
  [2768] = { -- Scout Fort Rayles
    4727, -- Reporting for Duty
  },
  [2769] = { -- Scout Fort Glademist
    4727, -- Reporting for Duty
  },
  [2770] = { -- Scout Fort Ash
    4727, -- Reporting for Duty
  },
  [2771] = { -- Scout Fort Aleswell
    4727, -- Reporting for Duty
  },
  [2772] = { -- Scout Fort Dragonclaw
    4727, -- Reporting for Duty
  },
  [2773] = { -- Scout Chalman Keep
    4727, -- Reporting for Duty
  },
  [2774] = { -- Scout Arrius Keep
    4727, -- Reporting for Duty
  },
  [2775] = { -- Scout Kingscrest Keep
    4727, -- Reporting for Duty
  },
  [2776] = { -- Scout Farragut Keep
    4727, -- Reporting for Duty
  },
  [2777] = { -- Scout Blue Road Keep
    4727, -- Reporting for Duty
  },
  [2778] = { -- Scout Drakelowe Keep
    4727, -- Reporting for Duty
  },
  [2779] = { -- Scout Castle Alessia
    4727, -- Reporting for Duty
  },
  [2780] = { -- Scout Castle Faregyl
    4727, -- Reporting for Duty
  },
  [2781] = { -- Scout Castle Roebeck
    4727, -- Reporting for Duty
  },
  [2782] = { -- Scout Castle Brindle
    4727, -- Reporting for Duty
  },
  [2783] = { -- Scout Castle Black Boot
    4727, -- Reporting for Duty
  },
  [2784] = { -- Scout Castle Bloodmayne
    4727, -- Reporting for Duty
  },
  [2786] = { -- Scout Warden Mine
    4727, -- Reporting for Duty
  },
  [2787] = { -- Scout Rayles Mine
    4727, -- Reporting for Duty
  },
  [2788] = { -- Scout Glademist Mine
    4727, -- Reporting for Duty
  },
  [2789] = { -- Scout Ash Mine
    4727, -- Reporting for Duty
  },
  [2790] = { -- Scout Aleswell Mine
    4727, -- Reporting for Duty
  },
  [2791] = { -- Scout Dragonclaw Mine
    4727, -- Reporting for Duty
  },
  [2793] = { -- Scout Chalman Mine
    4727, -- Reporting for Duty
  },
  [2794] = { -- Scout Arrius Mine
    4727, -- Reporting for Duty
  },
  [2795] = { -- Scout Kingscrest Mine
    4727, -- Reporting for Duty
  },
  [2796] = { -- Scout Farragut Mine
    4727, -- Reporting for Duty
  },
  [2797] = { -- Scout Blue Road Mine
    4727, -- Reporting for Duty
  },
  [2798] = { -- Scout Drakelowe Mine
    4727, -- Reporting for Duty
  },
  [2799] = { -- Scout Alessia Mine
    4727, -- Reporting for Duty
  },
  [2800] = { -- Scout Roebeck Mine
    4727, -- Reporting for Duty
  },
  [2801] = { -- Scout Brindle Mine
    4727, -- Reporting for Duty
  },
  [2802] = { -- Scout Black Boot Mine
    4727, -- Reporting for Duty
  },
  [2803] = { -- Scout Bloodmayne Mine
    4727, -- Reporting for Duty
  },
  [2804] = { -- Scout Warden Farm
    4727, -- Reporting for Duty
  },
  [2805] = { -- Scout Rayles Farm
    4727, -- Reporting for Duty
  },
  [2806] = { -- Scout Glademist Farm
    4727, -- Reporting for Duty
  },
  [2807] = { -- Scout Ash Farm
    4727, -- Reporting for Duty
  },
  [2808] = { -- Scout Aleswell Farm
    4727, -- Reporting for Duty
  },
  [2809] = { -- Scout Dragonclaw Farm
    4727, -- Reporting for Duty
  },
  [2810] = { -- Scout Chalman Farm
    4727, -- Reporting for Duty
  },
  [2811] = { -- Scout Arrius Farm
    4727, -- Reporting for Duty
  },
  [2812] = { -- Scout Kingscrest Farm
    4727, -- Reporting for Duty
  },
  [2813] = { -- Scout Farragut Farm
    4727, -- Reporting for Duty
  },
  [2814] = { -- Scout Blue Road Farm
    4727, -- Reporting for Duty
  },
  [2815] = { -- Scout Drakelowe Farm
    4727, -- Reporting for Duty
  },
  [2816] = { -- Scout Alessia Farm
    4727, -- Reporting for Duty
  },
  [2817] = { -- Scout Faregyl Farm
    4727, -- Reporting for Duty
  },
  [2818] = { -- Scout Roebeck Farm
    4727, -- Reporting for Duty
  },
  [2819] = { -- Scout Brindle Farm
    4727, -- Reporting for Duty
  },
  [2820] = { -- Scout Black Boot Farm
    4727, -- Reporting for Duty
  },
  [2821] = { -- Scout Bloodmayne Farm
    4727, -- Reporting for Duty
  },
  [2822] = { -- Scout Warden Lumbermill
    4727, -- Reporting for Duty
  },
  [2823] = { -- Scout Rayles Lumbermill
    4727, -- Reporting for Duty
  },
  [2824] = { -- Scout Glademist Lumbermill
    4727, -- Reporting for Duty
  },
  [2825] = { -- Scout Ash Lumbermill
    4727, -- Reporting for Duty
  },
  [2826] = { -- Scout Aleswell Lumbermill
    4727, -- Reporting for Duty
  },
  [2827] = { -- Scout Dragonclaw Lumbermill
    4727, -- Reporting for Duty
  },
  [2828] = { -- Scout Chalman Lumbermill
    4727, -- Reporting for Duty
  },
  [2829] = { -- Scout Arrius Lumbermill
    4727, -- Reporting for Duty
  },
  [2830] = { -- Scout Kingscrest Lumbermill
    4727, -- Reporting for Duty
  },
  [2831] = { -- Scout Farragut Lumbermill
    4727, -- Reporting for Duty
  },
  [2832] = { -- Scout Blue Road Lumbermill
    4727, -- Reporting for Duty
  },
  [2833] = { -- Scout Drakelowe Lumbermill
    4727, -- Reporting for Duty
  },
  [2834] = { -- Scout Alessia Lumbermill
    4727, -- Reporting for Duty
  },
  [2835] = { -- Scout Faregyl Lumbermill
    4727, -- Reporting for Duty
  },
  [2836] = { -- Scout Roebeck Lumbermill
    4727, -- Reporting for Duty
  },
  [2837] = { -- Scout Brindle Lumbermill
    4727, -- Reporting for Duty
  },
  [2838] = { -- Scout Black Boot Lumbermill
    4727, -- Reporting for Duty
  },
  [2839] = { -- Scout Bloodmayne Lumbermill
    4727, -- Reporting for Duty
  },
  [2840] = { -- Scout Fort Warden
    4724, -- Reporting for Duty
  },
  [2841] = { -- Scout Fort Rayles
    4724, -- Reporting for Duty
  },
  [2842] = { -- Scout Fort Glademist
    4724, -- Reporting for Duty
  },
  [2843] = { -- Scout Fort Ash
    4724, -- Reporting for Duty
  },
  [2844] = { -- Scout Fort Aleswell
    4724, -- Reporting for Duty
  },
  [2845] = { -- Scout Fort Dragonclaw
    4724, -- Reporting for Duty
  },
  [2846] = { -- Scout Chalman Keep
    4724, -- Reporting for Duty
  },
  [2847] = { -- Scout Arrius Keep
    4724, -- Reporting for Duty
  },
  [2848] = { -- Scout Kingscrest Keep
    4724, -- Reporting for Duty
  },
  [2849] = { -- Scout Farragut Keep
    4724, -- Reporting for Duty
  },
  [2850] = { -- Scout Blue Road Keep
    4724, -- Reporting for Duty
  },
  [2851] = { -- Scout Drakelowe Keep
    4724, -- Reporting for Duty
  },
  [2852] = { -- Scout Castle Alessia
    4724, -- Reporting for Duty
  },
  [2853] = { -- Scout Castle Faregyl
    4724, -- Reporting for Duty
  },
  [2854] = { -- Scout Castle Roebeck
    4724, -- Reporting for Duty
  },
  [2855] = { -- Scout Castle Brindle
    4724, -- Reporting for Duty
  },
  [2856] = { -- Scout Castle Black Boot
    4724, -- Reporting for Duty
  },
  [2857] = { -- Scout Castle Bloodmayne
    4724, -- Reporting for Duty
  },
  [2858] = { -- Scout Warden Mine
    4724, -- Reporting for Duty
  },
  [2859] = { -- Scout Rayles Mine
    4724, -- Reporting for Duty
  },
  [2860] = { -- Scout Glademist Mine
    4724, -- Reporting for Duty
  },
  [2861] = { -- Scout Ash Mine
    4724, -- Reporting for Duty
  },
  [2862] = { -- Scout Aleswell Mine
    4724, -- Reporting for Duty
  },
  [2863] = { -- Scout Dragonclaw Mine
    4724, -- Reporting for Duty
  },
  [2864] = { -- Scout Chalman Mine
    4724, -- Reporting for Duty
  },
  [2865] = { -- Scout Arrius Mine
    4724, -- Reporting for Duty
  },
  [2866] = { -- Scout Kingscrest Mine
    4724, -- Reporting for Duty
  },
  [2867] = { -- Scout Farragut Mine
    4724, -- Reporting for Duty
  },
  [2868] = { -- Scout Blue Road Mine
    4724, -- Reporting for Duty
  },
  [2869] = { -- Scout Drakelowe Mine
    4724, -- Reporting for Duty
  },
  [2870] = { -- Scout Alessia Mine
    4724, -- Reporting for Duty
  },
  [2871] = { -- Scout Faregyl Mine
    4724, -- Reporting for Duty
  },
  [2872] = { -- Scout Roebeck Mine
    4724, -- Reporting for Duty
  },
  [2873] = { -- Scout Brindle Mine
    4724, -- Reporting for Duty
  },
  [2874] = { -- Scout Black Boot Mine
    4724, -- Reporting for Duty
  },
  [2875] = { -- Scout Bloodmayne Mine
    4724, -- Reporting for Duty
  },
  [2876] = { -- Scout Warden Farm
    4724, -- Reporting for Duty
  },
  [2877] = { -- Scout Rayles Farm
    4724, -- Reporting for Duty
  },
  [2878] = { -- Scout Glademist Farm
    4724, -- Reporting for Duty
  },
  [2879] = { -- Scout Ash Farm
    4724, -- Reporting for Duty
  },
  [2880] = { -- Scout Aleswell Farm
    4724, -- Reporting for Duty
  },
  [2881] = { -- Scout Dragonclaw Farm
    4724, -- Reporting for Duty
  },
  [2882] = { -- Scout Chalman Farm
    4724, -- Reporting for Duty
  },
  [2883] = { -- Scout Arrius Farm
    4724, -- Reporting for Duty
  },
  [2884] = { -- Scout Faregyl Farm
    4724, -- Reporting for Duty
  },
  [2885] = { -- Scout Roebeck Farm
    4724, -- Reporting for Duty
  },
  [2886] = { -- Scout Brindle Farm
    4724, -- Reporting for Duty
  },
  [2887] = { -- Scout Black Boot Farm 4
    724, -- Reporting for Duty
  },
  [2888] = { -- Scout Bloodmayne Farm
    4724, -- Reporting for Duty
  },
  [2889] = { -- Scout Warden Lumbermill
    4724, -- Reporting for Duty
  },
  [2890] = { -- Scout Rayles Lumbermill
    4724, -- Reporting for Duty
  },
  [2891] = { -- Scout Glademist Lumbermill
    4724, -- Reporting for Duty
  },
  [2892] = { -- Scout Ash Lumbermill
    4724, -- Reporting for Duty
  },
  [2893] = { -- Scout Aleswell Lumbermill
    4724, -- Reporting for Duty
  },
  [2894] = { -- Scout Dragonclaw Lumbermill
    4724, -- Reporting for Duty
  },
  [2895] = { -- Scout Chalman Lumbermill
    4724, -- Reporting for Duty
  },
  [2896] = { -- Scout Arrius Lumbermill
    4724, -- Reporting for Duty
  },
  [2898] = { -- Scout Kingscrest Lumbermill
    4724, -- Reporting for Duty
  },
  [2899] = { -- Scout Farragut Lumbermill
    4724, -- Reporting for Duty
  },
  [2900] = { -- Scout Blue Road Lumbermill
    4724, -- Reporting for Duty
  },
  [2901] = { -- Scout Drakelowe Lumbermill
    4724, -- Reporting for Duty
  },
  [2902] = { -- Scout Alessia Lumbermill
    4724, -- Reporting for Duty
  },
  [2903] = { -- Scout Faregyl Lumbermill
    4724, -- Reporting for Duty
  },
  [2904] = { -- Scout Roebeck Lumbermill
    4724, -- Reporting for Duty
  },
  [2905] = { -- Scout Brindle Lumbermill
    4724, -- Reporting for Duty
  },
  [2906] = { -- Scout Black Boot Lumbermill
    4724, -- Reporting for Duty
  },
  [2907] = { -- Scout Bloodmayne Lumbermill
    4724, -- Reporting for Duty
  },
  [2915] = { -- Capture Fort Warden
    4706, -- Reporting for Duty
  },
  [2916] = { -- Capture Fort Rayles
    4706, -- Reporting for Duty
  },
  [2917] = { -- Capture Fort Glademist
    4706, -- Reporting for Duty
  },
  [2918] = { -- Capture Fort Ash
    4706, -- Reporting for Duty
  },
  [2919] = { -- Capture Fort Aleswell
    4706, -- Reporting for Duty
  },
  [2920] = { -- Capture Fort Dragonclaw
    4706, -- Reporting for Duty
  },
  [2921] = { -- Capture Chalman Keep
    4706, -- Reporting for Duty
  },
  [2922] = { -- Capture Arrius Keep
    4706, -- Reporting for Duty
  },
  [2923] = { -- Capture Kingscrest Keep
    4706, -- Reporting for Duty
  },
  [2924] = { -- Capture Farragut Keep
    4706, -- Reporting for Duty
  },
  [2925] = { -- Capture Blue Road Keep
    4706, -- Reporting for Duty
  },
  [2926] = { -- Capture Drakelowe Keep
    4706, -- Reporting for Duty
  },
  [2927] = { -- Capture Castle Alessia
    4706, -- Reporting for Duty
  },
  [2928] = { -- Capture Castle Faregyl
    4706, -- Reporting for Duty
  },
  [2929] = { -- Capture Castle Roebeck
    4706, -- Reporting for Duty
  },
  [2930] = { -- Capture Castle Brindle
    4706, -- Reporting for Duty
  },
  [2931] = { -- Capture Castle Black Boot
    4706, -- Reporting for Duty
  },
  [2932] = { -- Capture Castle Bloodmayne
    4706, -- Reporting for Duty
  },
  [2933] = { -- Capture Warden Mine
    4706, -- Reporting for Duty
  },
  [2934] = { -- Capture Rayles Mine
    4706, -- Reporting for Duty
  },
  [2935] = { -- Capture Glademist Mine
    4706, -- Reporting for Duty
  },
  [2936] = { -- Capture Ash Mine
    4706, -- Reporting for Duty
  },
  [2937] = { -- Capture Aleswell Mine
    4706, -- Reporting for Duty
  },
  [2938] = { -- Capture Dragonclaw Mine
    4706, -- Reporting for Duty
  },
  [2939] = { -- Capture Chalman Mine
    4706, -- Reporting for Duty
  },
  [2940] = { -- Capture Arrius Mine
    4706, -- Reporting for Duty
  },
  [2941] = { -- Capture Kingscrest Mine
    4706, -- Reporting for Duty
  },
  [2942] = { -- Capture Farragut Mine
    4706, -- Reporting for Duty
  },
  [2943] = { -- Capture Blue Road Mine
    4706, -- Reporting for Duty
  },
  [2944] = { -- Capture Drakelowe Mine
    4706, -- Reporting for Duty
  },
  [2945] = { -- Capture Alessia Mine
    4706, -- Reporting for Duty
  },
  [2946] = { -- Capture Faregyl Mine
    4706, -- Reporting for Duty
  },
  [2947] = { -- Capture Roebeck Mine
    4706, -- Reporting for Duty
  },
  [2950] = { -- Capture Brindle Mine
    4706, -- Reporting for Duty
  },
  [2951] = { -- Capture Black Boot Mine
    4706, -- Reporting for Duty
  },
  [2952] = { -- Capture Bloodmayne Mine
    4706, -- Reporting for Duty
  },
  [2953] = { -- Capture Warden Farm
    4706, -- Reporting for Duty
  },
  [2954] = { -- Capture Rayles Farm
    4706, -- Reporting for Duty
  },
  [2955] = { -- Capture Glademist Farm
    4706, -- Reporting for Duty
  },
  [2956] = { -- Capture Ash Farm
    4706, -- Reporting for Duty
  },
  [2957] = { -- Capture Aleswell Farm
    4706, -- Reporting for Duty
  },
  [2958] = { -- Capture Dragonclaw Farm
    4706, -- Reporting for Duty
  },
  [2959] = { -- Capture Chalman Farm
    4706, -- Reporting for Duty
  },
  [2960] = { -- Capture Arrius Farm
    4706, -- Reporting for Duty
  },
  [2961] = { -- Capture Kingscrest Farm
    4706, -- Reporting for Duty
  },
  [2962] = { -- Capture Farragut Farm
    4706, -- Reporting for Duty
  },
  [2963] = { -- Capture Blue Road Farm
    4706, -- Reporting for Duty
  },
  [2964] = { -- Capture Drakelowe Farm
    4706, -- Reporting for Duty
  },
  [2965] = { -- Capture Alessia Farm
    4706, -- Reporting for Duty
  },
  [2966] = { -- Capture Faregyl Farm
    4706, -- Reporting for Duty
  },
  [2967] = { -- Capture Roebeck Farm
    4706, -- Reporting for Duty
  },
  [2968] = { -- Capture Brindle Farm
    4706, -- Reporting for Duty
  },
  [2969] = { -- Capture Black Boot Farm
    4706, -- Reporting for Duty
  },
  [2970] = { -- Capture Bloodmayne Farm
    4706, -- Reporting for Duty
  },
  [2972] = { -- Capture Warden Lumbermill
    4706, -- Reporting for Duty
  },
  [2973] = { -- Capture Rayles Lumbermill
    4706, -- Reporting for Duty
  },
  [2974] = { -- Capture Glademist Lumbermill
    4706, -- Reporting for Duty
  },
  [2975] = { -- Capture Ash Lumbermill
    4706, -- Reporting for Duty
  },
  [2976] = { -- Capture Aleswell Lumbermill
    4706, -- Reporting for Duty
  },
  [2977] = { -- Capture Dragonclaw Lumbermill
    4706, -- Reporting for Duty
  },
  [2978] = { -- Capture Chalman Lumbermill
    4706, -- Reporting for Duty
  },
  [2979] = { -- Capture Arrius Lumbermill
    4706, -- Reporting for Duty
  },
  [2980] = { -- Capture Kingscrest Lumbermill
    4706, -- Reporting for Duty
  },
  [2981] = { -- Capture Farragut Lumbermill
    4706, -- Reporting for Duty
  },
  [2982] = { -- Capture Blue Road Lumbermill
    4706, -- Reporting for Duty
  },
  [2983] = { -- Capture Drakelowe Lumbermill
    4706, -- Reporting for Duty
  },
  [2984] = { -- Capture Alessia Lumbermill
    4706, -- Reporting for Duty
  },
  [2985] = { -- Capture Faregyl Lumbermill
    4706, -- Reporting for Duty
  },
  [2986] = { -- Capture Roebeck Lumbermill
    4706, -- Reporting for Duty
  },
  [2987] = { -- Capture Brindle Lumbermill
    4706, -- Reporting for Duty
  },
  [2989] = { -- Capture Bloodmayne Lumbermill
    4706, -- Reporting for Duty
  },
  [2997] = { -- Amputating the Hand
    2222, -- Alasan's Plot
  },
  [2998] = { -- Restoring the Ansei Wards
    2997, -- Amputating the Hand
  },
  [3003] = { -- Disorganized Crime
    3001, -- Farlivere's Gambit
  },
  [3004] = { -- Lady Eloise's Lockbox
    3001, -- Farlivere's Gambit
  },
  [3006] = { -- Bloodthorn Assassins
    3000, -- Blood and the Crescent Moon
  },
  [3013] = { -- Wolves in the Fold
    974, -- A Duke in Exile
  },
  [3016] = { -- The Wyrd Tree's Roots
    3009, -- Turning of the Trees
    2599, -- Ash and Reprieve
  },
  [3018] = { -- Lineage of Tooth and Claw
    3013, -- Wolves in the Fold
  },
  [3020] = { -- Memento Mori
    3019, -- The Ghosts of Westtry
  },
  [3026] = { -- The Wyrd Sisters
    3016, -- The Wyrd Tree's Roots
  },
  [3035] = { -- Wyrd and Coven
    3023, -- Wicked Trade
  },
  [3047] = { -- A Step Back in Time
    3027, -- Ripple Effect
  },
  [3049] = { -- The Nameless Soldier
    3047, -- A Step Back in Time
  },
  [3059] = { -- Servants of Ancient Kings
    3050, -- Cursed Treasure
  },
  [3063] = { -- Champion of the Guardians
    3060, -- Seeking the Guardians
  },
  [3083] = { -- Capture Fort Warden
    4724, -- Reporting for Duty
  },
  [3084] = { -- Capture Fort Rayles
    4724, -- Reporting for Duty
  },
  [3085] = { -- Capture Fort Glademist
    4724, -- Reporting for Duty
  },
  [3086] = { -- Capture Fort Ash
    4724, -- Reporting for Duty
  },
  [3087] = { -- Capture Fort Aleswell
    4724, -- Reporting for Duty
  },
  [3088] = { -- Capture Fort Dragonclaw
    4724, -- Reporting for Duty
  },
  [3089] = { -- Capture Chalman Keep
    4724, -- Reporting for Duty
  },
  [3090] = { -- Capture Arrius Keep
    4724, -- Reporting for Duty
  },
  [3091] = { -- Capture Kingscrest Keep
    4724, -- Reporting for Duty
  },
  [3092] = { -- Capture Farragut Keep
    4724, -- Reporting for Duty
  },
  [3093] = { -- Capture Blue Road Keep
    4724, -- Reporting for Duty
  },
  [3094] = { -- Capture Drakelowe Keep
    4724, -- Reporting for Duty
  },
  [3095] = { -- Capture Castle Alessia
    4724, -- Reporting for Duty
  },
  [3096] = { -- Capture Castle Faregyl
    4724, -- Reporting for Duty
  },
  [3097] = { -- Capture Castle Roebeck
    4724, -- Reporting for Duty
  },
  [3098] = { -- Capture Castle Brindle
    4724, -- Reporting for Duty
  },
  [3099] = { -- Capture Castle Black Boot
    4724, -- Reporting for Duty
  },
  [3100] = { -- Capture Castle Bloodmayne
    4724, -- Reporting for Duty
  },
  [3101] = { -- Capture Warden Farm
    4724, -- Reporting for Duty
  },
  [3102] = { -- Capture Rayles Farm
    4724, -- Reporting for Duty
  },
  [3103] = { -- Capture Glademist Farm
    4724, -- Reporting for Duty
  },
  [3104] = { -- Capture Ash Farm
    4724, -- Reporting for Duty
  },
  [3105] = { -- Capture Aleswell Farm
    4724, -- Reporting for Duty
  },
  [3106] = { -- Capture Dragonclaw Farm
    4724, -- Reporting for Duty
  },
  [3108] = { -- Capture Chalman Farm
    4724, -- Reporting for Duty
  },
  [3109] = { -- Capture Arrius Farm
    4724, -- Reporting for Duty
  },
  [3110] = { -- Capture Kingscrest Farm
    4724, -- Reporting for Duty
  },
  [3111] = { -- Capture Farragut Farm
    4724, -- Reporting for Duty
  },
  [3112] = { -- Capture Blue Road Farm
    4724, -- Reporting for Duty
  },
  [3113] = { -- Capture Drakelowe Farm
    4724, -- Reporting for Duty
  },
  [3114] = { -- Capture Alessia Farm
    4724, -- Reporting for Duty
  },
  [3115] = { -- Capture Faregyl Farm
    4724, -- Reporting for Duty
  },
  [3116] = { -- Capture Roebeck Farm
    4724, -- Reporting for Duty
  },
  [3117] = { -- Capture Brindle Farm
    4724, -- Reporting for Duty
  },
  [3118] = { -- Capture Black Boot Farm
    4724, -- Reporting for Duty
  },
  [3119] = { -- Capture Bloodmayne Farm
    4724, -- Reporting for Duty
  },
  [3120] = { -- Capture Warden Mine
    4724, -- Reporting for Duty
  },
  [3121] = { -- Capture Rayles Mine
    4724, -- Reporting for Duty
  },
  [3122] = { -- Capture Glademist Mine
    4724, -- Reporting for Duty
  },
  [3123] = { -- Capture Ash Mine
    4724, -- Reporting for Duty
  },
  [3124] = { -- Capture Aleswell Mine
    4724, -- Reporting for Duty
  },
  [3125] = { -- Capture Dragonclaw Mine
    4724, -- Reporting for Duty
  },
  [3126] = { -- Capture Chalman Mine
    4724, -- Reporting for Duty
  },
  [3127] = { -- Capture Arrius Mine
    4724, -- Reporting for Duty
  },
  [3128] = { -- Capture Kingscrest Mine
    4724, -- Reporting for Duty
  },
  [3130] = { -- Capture Farragut Mine
    4724, -- Reporting for Duty
  },
  [3131] = { -- Capture Blue Road Mine
    4724, -- Reporting for Duty
  },
  [3132] = { -- Capture Drakelowe Mine
    4724, -- Reporting for Duty
  },
  [3133] = { -- Capture Alessia Mine
    4724, -- Reporting for Duty
  },
  [3134] = { -- Capture Faregyl Mine
    4724, -- Reporting for Duty
  },
  [3135] = { -- Capture Roebeck Mine
    4724, -- Reporting for Duty
  },
  [3136] = { -- Capture Brindle Mine
    4724, -- Reporting for Duty
  },
  [3137] = { -- Capture Black Boot Mine
    4724, -- Reporting for Duty
  },
  [3138] = { -- Capture Bloodmayne Mine
    4724, -- Reporting for Duty
  },
  [3139] = { -- Capture Warden Lumbermill
    4724, -- Reporting for Duty
  },
  [3140] = { -- Capture Rayles Lumbermill
    4724, -- Reporting for Duty
  },
  [3141] = { -- Capture Glademist Lumbermill
    4724, -- Reporting for Duty
  },
  [3142] = { -- Capture Ash Lumbermill
    4724, -- Reporting for Duty
  },
  [3143] = { -- Capture Aleswell Lumbermill
    4724, -- Reporting for Duty
  },
  [3144] = { -- Capture Dragonclaw Lumbermill
    4724, -- Reporting for Duty
  },
  [3145] = { -- Capture Chalman Lumbermill
    4724, -- Reporting for Duty
  },
  [3146] = { -- Capture Arrius Lumbermill
    4724, -- Reporting for Duty
  },
  [3147] = { -- Capture Kingscrest Lumbermill
    4724, -- Reporting for Duty
  },
  [3148] = { -- Capture Farragut Lumbermill
    4724, -- Reporting for Duty
  },
  [3149] = { -- Capture Blue Road Lumbermill
    4724, -- Reporting for Duty
  },
  [3150] = { -- Capture Drakelowe Lumbermill
    4724, -- Reporting for Duty
  },
  [3151] = { -- Capture Alessia Lumbermill
    4724, -- Reporting for Duty
  },
  [3152] = { -- Capture Faregyl Lumbermill
    4724, -- Reporting for Duty
  },
  [3153] = { -- Capture Roebeck Lumbermill
    4724, -- Reporting for Duty
  },
  [3154] = { -- Capture Brindle Lumbermill
    4724, -- Reporting for Duty
  },
  [3155] = { -- Capture Black Boot Lumbermill
    4724, -- Reporting for Duty
  },
  [3156] = { -- Capture Bloodmayne Lumbermill
    4724, -- Reporting for Duty
  },
  [3157] = { -- Kill Enemy Players
    4724, -- Reporting for Duty
  },
  [3174] = { -- A Lingering Hope
    3064, -- Rally Cry
  },
  [3183] = { -- To the Wyrd Tree
    3063, -- Champion of the Guardians
  },
  [3184] = { -- The Glenumbra Moors
    3018, -- Lineage of Tooth and Claw
  },
  [3189] = { -- Hidden in Flames
    3064, -- Rally Cry
  },
  [3190] = { -- Ash'abah Rising
    4686, -- The Initiation
  },
  [3194] = { -- Capture Warden Farm
    4727, -- Reporting for Duty
  },
  [3195] = { -- Capture Rayles Farm
    4727, -- Reporting for Duty
  },
  [3196] = { -- Capture Glademist Farm
    4727, -- Reporting for Duty
  },
  [3197] = { -- Capture Ash Farm
    4727, -- Reporting for Duty
  },
  [3198] = { -- Capture Aleswell Farm
    4727, -- Reporting for Duty
  },
  [3199] = { -- Capture Dragonclaw Farm
    4727, -- Reporting for Duty
  },
  [3200] = { -- Capture Chalman Farm
    4727, -- Reporting for Duty
  },
  [3201] = { -- Capture Arrius Farm
    4727, -- Reporting for Duty
  },
  [3202] = { -- Capture Kingscrest Farm
    4727, -- Reporting for Duty
  },
  [3203] = { -- Capture Farragut Farm
    4727, -- Reporting for Duty
  },
  [3204] = { -- Capture Blue Road Farm
    4727, -- Reporting for Duty
  },
  [3205] = { -- Capture Drakelowe Farm
    4727, -- Reporting for Duty
  },
  [3206] = { -- Capture Alessia Farm
    4727, -- Reporting for Duty
  },
  [3207] = { -- Capture Faregyl Farm
    4727, -- Reporting for Duty
  },
  [3208] = { -- Capture Roebeck Farm
    4727, -- Reporting for Duty
  },
  [3209] = { -- Capture Brindle Farm
    4727, -- Reporting for Duty
  },
  [3210] = { -- Capture Black Boot Farm
    4727, -- Reporting for Duty
  },
  [3211] = { -- Capture Bloodmayne Farm
    4727, -- Reporting for Duty
  },
  [3212] = { -- Capture Fort Warden
    4727, -- Reporting for Duty
  },
  [3213] = { -- Capture Fort Rayles
    4727, -- Reporting for Duty
  },
  [3214] = { -- Capture Fort Glademist
    4727, -- Reporting for Duty
  },
  [3215] = { -- Capture Fort Ash
    4727, -- Reporting for Duty
  },
  [3216] = { -- Capture Fort Aleswell
    4727, -- Reporting for Duty
  },
  [3217] = { -- Capture Fort Dragonclaw
    4727, -- Reporting for Duty
  },
  [3218] = { -- Capture Chalman Keep
    4727, -- Reporting for Duty
  },
  [3219] = { -- Capture Arrius Keep
    4727, -- Reporting for Duty
  },
  [3220] = { -- Capture Kingscrest Keep
    4727, -- Reporting for Duty
  },
  [3221] = { -- Capture Farragut Keep
    4727, -- Reporting for Duty
  },
  [3222] = { -- Capture Blue Road Keep
    4727, -- Reporting for Duty
  },
  [3223] = { -- Capture Drakelowe Keep
    4727, -- Reporting for Duty
  },
  [3224] = { -- Capture Castle Alessia
    4727, -- Reporting for Duty
  },
  [3225] = { -- Capture Castle Faregyl
    4727, -- Reporting for Duty
  },
  [3226] = { -- Capture Castle Roebeck
    4727, -- Reporting for Duty
  },
  [3227] = { -- Capture Castle Brindle
    4727, -- Reporting for Duty
  },
  [3228] = { -- Capture Castle Black Boot
    4727, -- Reporting for Duty
  },
  [3229] = { -- Capture Castle Bloodmayne
    4727, -- Reporting for Duty
  },
  [3231] = { -- Capture Warden Lumbermill
    4727, -- Reporting for Duty
  },
  [3232] = { -- Capture Rayles Lumbermill
    4727, -- Reporting for Duty
  },
  [3233] = { -- Capture Glademist Lumbermill
    4727, -- Reporting for Duty
  },
  [3234] = { -- Capture Ash Lumbermill
    4727, -- Reporting for Duty
  },
  [3235] = { -- Purifying the Wyrd Tree
    3191, -- Reclaiming the Elements
  },
  [3236] = { -- Capture Aleswell Lumbermill
    4727, -- Reporting for Duty
  },
  [3237] = { -- Capture Dragonclaw Lumbermill
    4727, -- Reporting for Duty
  },
  [3238] = { -- Capture Chalman Lumbermill
    4727, -- Reporting for Duty
  },
  [3239] = { -- Capture Arrius Lumbermill
    4727, -- Reporting for Duty
  },
  [3240] = { -- Capture Kingscrest Lumbermill
    4727, -- Reporting for Duty
  },
  [3241] = { -- Capture Farragut Lumbermill
    4727, -- Reporting for Duty
  },
  [3242] = { -- Capture Blue Road Lumbermill
    4727, -- Reporting for Duty
  },
  [3243] = { -- Capture Drakelowe Lumbermill
    4727, -- Reporting for Duty
  },
  [3244] = { -- Capture Alessia Lumbermill
    4727, -- Reporting for Duty
  },
  [3245] = { -- Capture Faregyl Lumbermill
    4727, -- Reporting for Duty
  },
  [3246] = { -- Capture Roebeck Lumbermill
    4727, -- Reporting for Duty
  },
  [3247] = { -- Capture Brindle Lumbermill
    4727, -- Reporting for Duty
  },
  [3248] = { -- Capture Black Boot Lumbermill
    4727, -- Reporting for Duty
  },
  [3249] = { -- Capture Bloodmayne Lumbermill
    4727, -- Reporting for Duty
  },
  [3250] = { -- Capture Warden Mine
    4727, -- Reporting for Duty
  },
  [3251] = { -- Capture Rayles Mine
    4727, -- Reporting for Duty
  },
  [3252] = { -- Capture Glademist Mine
    4727, -- Reporting for Duty
  },
  [3253] = { -- Capture Ash Mine
    4727, -- Reporting for Duty
  },
  [3254] = { -- Capture Aleswell Mine
    4727, -- Reporting for Duty
  },
  [3255] = { -- Capture Dragonclaw Mine
    4727, -- Reporting for Duty
  },
  [3256] = { -- Capture Chalman Mine
    4727, -- Reporting for Duty
  },
  [3257] = { -- Capture Arrius Mine
    4727, -- Reporting for Duty
  },
  [3258] = { -- Capture Kingscrest Mine
    4727, -- Reporting for Duty
  },
  [3259] = { -- Capture Farragut Mine
    4727, -- Reporting for Duty
  },
  [3260] = { -- Capture Blue Road Mine
    4727, -- Reporting for Duty
  },
  [3261] = { -- Capture Drakelowe Mine
    4727, -- Reporting for Duty
  },
  [3262] = { -- Capture Alessia Mine
    4727, -- Reporting for Duty
  },
  [3263] = { -- Capture Faregyl Mine
    4727, -- Reporting for Duty
  },
  [3265] = { -- Capture Roebeck Mine
    4727, -- Reporting for Duty
  },
  [3266] = { -- Capture Brindle Mine
    4727, -- Reporting for Duty
  },
  [3267] = { -- The Fall of Faolchu
    3189, -- Hidden in Flames
    3174, -- A Lingering Hope
  },
  [3268] = { -- Capture Black Boot Mine
    4727, -- Reporting for Duty
  },
  [3269] = { -- Capture Bloodmayne Mine
    4727, -- Reporting for Duty
  },
  [3277] = { -- Mastering the Talisman
    3082, -- The Lion Guard's Stand
  },
  [3280] = { -- Imperial Infiltration
    1799, -- A City in Black
  },
  [3281] = { -- Leading the Stand
    3280, -- Imperial Infiltration
  },
  [3283] = { -- Werewolves to the North
    3235, -- Purifying the Wyrd Tree
  },
  [3296] = { -- Trials of the Hero
    2356, -- March of the Ra Gada
  },
  [3302] = { -- The Miners' Lament
    3337, -- Legitimate Interests
  },
  [3322] = { -- The Dresan Index
    3315, -- The Hidden Treasure
  },
  [3330] = { -- Retaking Camlorn
    3049, -- The Nameless Soldier
  },
  [3338] = { -- Mists of Corruption
    3277, -- Mastering the Talisman
  },
  [3343] = { -- Crosswych Reclaimed
    3302, -- The Miners' Lament
  },
  [3357] = { -- The Labyrinth
    3338, -- Mists of Corruption
  },
  [3379] = { -- Angof the Gravesinger
    3338, -- Mists of Corruption
  },
  [3431] = { -- Capture Any Three Keeps
    4724, -- Reporting for Duty
  },
  [3474] = { -- Scout Kingscrest Farm
    4724, -- Reporting for Duty
  },
  [3475] = { -- Scout Farragut Farm
    4724, -- Reporting for Duty
  },
  [3476] = { -- Scout Blue Road Farm
    4724, -- Reporting for Duty
  },
  [3477] = { -- Scout Drakelowe Farm
    4724, -- Reporting for Duty
  },
  [3478] = { -- Scout Alessia Farm
    4724, -- Reporting for Duty
  },
  [3481] = { -- Scout Faregyl Mine
    4727, -- Reporting for Duty
  },
  [3530] = { -- Destroying the Dark Witnesses
    4899, -- Beyond the Call
  },
  [3566] = { -- Kingdom in Mourning
    2998, -- Restoring the Ansei Wards
  },
  [3584] = { -- The Coral Heart
    3735, -- The Death of Balreth
  },
  [3587] = { -- Delaying the Daggers
    3585, -- Legacy of the Ancestors
  },
  [3588] = { -- City Under Siege
    3587, -- Delaying the Daggers
  },
  [3591] = { -- The Venom of Ahknara
    3583, -- Suspicious Silence
  },
  [3604] = { -- Challenge the Tide
    3600, -- Oath Breaker
  },
  [3615] = { -- Wake the Dead
    3588, -- City Under Siege
  },
  [3616] = { -- Rending Flames
    3615, -- Wake the Dead
  },
  [3617] = { -- Quieting a Heart
    3616, -- Rending Flames
  },
  [3618] = { -- To Ash Mountain
    3616, -- Rending Flames
  },
  [3622] = { -- The Brothers Will Rise
    3520, -- Window on the Past
  },
  [3624] = { -- The Saving of Silent Mire
    3620, -- The Ravaged Village
  },
  [3627] = { -- Kinsman's Revenge
    3626, -- Protecting the Hall
  },
  [3632] = { -- Breaking Fort Virak
    3584, -- The Coral Heart
  },
  [3633] = { -- Evening the Odds
    3632, -- Breaking Fort Virak
  },
  [3634] = { -- The General's Demise
    3633, -- Evening the Odds
  },
  [3635] = { -- City at the Spire
    3634, -- The General's Demise
  },
  [3637] = { -- Godrun's Dream
    1346, -- Ending the Ogre Threat
  },
  [3643] = { -- What Was Done Must Be Undone
    3642, -- The Curse of Heimlyn Keep
  },
  [3647] = { -- Shattering Mirror
    3646, -- An Unwanted Twin
  },
  [3650] = { -- Cold-Blooded Vengeance
    3620, -- The Ravaged Village
  },
  [3651] = { -- The Trial of the Ghost Snake
    4455, -- Trade Negotiations
  },
  [3652] = { -- Fighting Back
    3659, -- Unwanted Guests
  },
  [3659] = { -- Unwanted Guests
    3610, -- For Their Own Protection
  },
  [3660] = { -- Hiding in Plain Sight
    3658, -- A Timely Matter
    3653, -- Ratting Them Out
  },
  [3675] = { -- Last One Standing
    3674, -- Warm Welcome
  },
  [3676] = { -- A Pirate Parley
    3675, -- Last One Standing
  },
  [3679] = { -- Dreams From the Hist
    3678, -- Trials of the Burnished Scales
  },
  [3683] = { -- What Lies Beneath
    3666, -- Rules and Regulations
  },
  [3687] = { -- Getting to the Truth
    3686, -- Three Tender Souls
  },
  [3690] = { -- Scouring the Mire
    3687, -- Getting to the Truth
  },
  [3695] = { -- Aggressive Negotiations
    3634, -- The General's Demise
  },
  [3696] = { -- Saving the Son
    3695, -- Aggressive Negotiations
  },
  [3698] = { -- To the Tormented Spire
    3696, -- Saving the Son
  },
  [3705] = { -- Payback
    3673, -- Death Trap
  },
  [3709] = { -- The Bargain's End
    3685, -- The Thin Ones
  },
  [3715] = { -- Strange Guard Beasts
    3624, -- The Saving of Silent Mire
  },
  [3718] = { -- Into the Temple
    3717, -- King of Dust
  },
  [3724] = { -- Lost to the Mire
    3675, -- Last One Standing
  },
  [3729] = { -- A Stranger Uninvited
    3730, -- Whispers of the Wisps
  },
  [3731] = { -- Broken Apart
    3729, -- A Stranger Uninvited
  },
  [3732] = { -- Overrun
    3679, -- Dreams From the Hist
  },
  [3734] = { -- Restoring the Guardians
    3616, -- Rending Flames
  },
  [3735] = { -- The Death of Balreth
    3734, -- Restoring the Guardians
  },
  [3737] = { -- In With the Tide
    3735, -- The Death of Balreth
  },
  [3749] = { -- Into the Mouth of Madness
    3818, -- A Saint Asunder
  },
  [3752] = { -- A Storm Broken
    3751, -- Hunting Invaders
  },
  [3766] = { -- Dealing with the Dreadlord
    3744, -- Shattered Stones
  },
  [3788] = { -- Vengeance for House Dres
    3696, -- Saving the Son
  },
  [3794] = { -- Divine Favor
    3699, -- From the Wastes
  },
  [3797] = { -- Plague Bringer
    3705, -- Payback
  },
  [3802] = { -- What Happened at Murkwater
    3799, -- Scales of Retribution
  },
  [3806] = { -- Undermined
    3794, -- Divine Favor
  },
  [3815] = { -- Cracking the Egg
    4590, -- The Skin-Stealer's Lair
  },
  [3817] = { -- The Seal of Three
    4459, -- The Mournhold Underground
  },
  [3818] = { -- A Saint Asunder
    3817, -- The Seal of Three
  },
  [3820] = { -- Restless Spirits
    3817, -- The Seal of Three
  },
  [3826] = { -- Climbing the Spire
    3696, -- Saving the Son
  },
  [3831] = { -- The Judgment of Veloth
    3810, -- Motive for Heresy
  },
  [3837] = { -- Opening the Portal
    3826, -- Climbing the Spire
  },
  [3846] = { -- The Keystone
    3845, -- And Throw Away The Key
  },
  [3849] = { -- A Final Release
    3731, -- Broken Apart
  },
  [3852] = { -- Rescue and Revenge
    3820, -- Restless Spirits
  },
  [3858] = { -- The Dangerous Past
    3856, -- Anchors from the Harbour
  },
  [3868] = { -- Sadal's Final Defeat
    3837, -- Opening the Portal
  },
  [3874] = { -- The Light Fantastic
    3864, -- The Dungeon Delvers
  },
  [3885] = { -- The Prismatic Core
    3858, -- The Dangerous Past
  },
  [3889] = { -- The Fangs of Sithis
    3888, -- Buried in the Past
  },
  [3890] = { -- Pull the Last Fang
    3889, -- The Fangs of Sithis
  },
  [3898] = { -- Proving the Deed
    3885, -- The Prismatic Core
  },
  [3903] = { -- School Daze
    3893, -- By Invitation Only
  },
  [3905] = { -- Clarity
    3900, -- Into the Mire
  },
  [3908] = { -- Vision Quest
    3903, -- School Daze
  },
  [3909] = { -- The Dominion's Alchemist
    4606, -- Keepers of the Shell
  },
  [3910] = { -- The Dream of the Hist
    3909, -- The Dominion's Alchemist
  },
  [3914] = { -- Missing Son
    3900, -- Into the Mire
  },
  [3918] = { -- Circus of Cheerful Slaughter
    4435, -- Simply Misplaced
  },
  [3920] = { -- Unearthed
    3919, -- Beneath the Stone
  },
  [3945] = { -- Wreck Up the Place
    3933, -- Murder for Crystals
  },
  [3946] = { -- Killing Dreams
    3932, -- Stolen Dream Crystal
  },
  [3947] = { -- Kill the Leader
    3929, -- Shattered Realm
  },
  [3948] = { -- Stop the Dream
    3931, -- Eternal Quest
  },
  [3949] = { -- Kill Remelie
    3930, -- Slaying the Dreamers
  },
  [3953] = { -- Chateau of the Ravenous Rodent
    3918, -- Circus of Cheerful Slaughter
  },
  [3955] = { -- Tracking the Plague
    3660, -- Hiding in Plain Sight
  },
  [3956] = { -- Message to Mournhold
    3797, -- Plague Bringer
  },
  [3957] = { -- Gift of the Worm
    3928, -- Dangerous Union
  },
  [3958] = { -- The Llodos Plague
    5057, -- Bad Medicine
  },
  [3966] = { -- Chasing the Magistrix
    3817, -- The Seal of Three
  },
  [3968] = { -- Through the Shroud
    3957, -- Gift of the Worm
  },
  [3973] = { -- Will of the Council
    3898, -- Proving the Deed
  },
  [3974] = { -- Storming the Hall
    3919, -- Beneath the Stone
    3920, -- Unearthed
  },
  [3981] = { -- To Taarengrav
    3978, -- Tomb Beneath the Mountain
  },
  [3991] = { -- Escape from Bleakrock
    4002, -- Sparking the Flame
  },
  [3997] = { -- The Mad God's Bargain
    3953, -- Chateau of the Ravenous Rodent
  },
  [4002] = { -- Sparking the Flame
    4016, -- The Missing of Bleakrock
  },
  [4016] = { -- The Missing of Bleakrock
    3992, -- What Waits Beneath
    3987, -- Hozzin's Folly
    3995, -- The Frozen Man
  },
  [4023] = { -- If By Sea
    3991, -- Escape from Bleakrock
  },
  [4026] = { -- Zeren in Peril
    4041, -- Crossroads
  },
  [4028] = { -- Breaking the Tide
    4041, -- Crossroads
  },
  [4041] = { -- Crossroads
    4023, -- If By Sea
  },
  [4051] = { -- Warning Davon's Watch
    4026, -- Zeren in Peril
    4028, -- Breaking the Tide
  },
  [4056] = { -- For Kyne's Honor
    4030, -- Shrine of Corruption
    4055, -- A Cure For Droi
  },
  [4059] = { -- The Konunleikar
    4058, -- Shadows Over Windhelm
  },
  [4060] = { -- Windhelm's Champion
    4059, -- The Konunleikar
  },
  [4061] = { -- One Victor, One King
    4060, -- Windhelm's Champion
  },
  [4069] = { -- Making Amends
    4123, -- Gods Save the King
  },
  [4071] = { -- Sleep for the Dead
    4062, -- Blindsided
  },
  [4078] = { -- A Council of Thanes
    4069, -- Making Amends
  },
  [4087] = { -- Sneak Peak
    4078, -- A Council of Thanes
  },
  [4105] = { -- Kireth's Amazing Plan
    4104, -- In Search of Kireth Vanos
  },
  [4106] = { -- The Better of Two Evils
    4075, -- A Right to Live
  },
  [4108] = { -- The Tale of the Green Lady
    4089, -- The Hound's Men
  },
  [4112] = { -- Raise the Curtain
    4111, -- The Show Must Go On
  },
  [4115] = { -- Eternal Slumber
    4203, -- Lifeline
  },
  [4116] = { -- Snow and Flame
    4078, -- A Council of Thanes
  },
  [4117] = { -- Songs of Sovngarde
    4116, -- Snow and Flame
  },
  [4123] = { -- Gods Save the King
    4115, -- Eternal Slumber
  },
  [4124] = { -- The Prisoner of Jathsogur
    4456, -- The Hound's Plan
    4452, -- Reap What Is Sown
  },
  [4128] = { -- Mystery Metal
    4126, -- Labor Dispute
  },
  [4130] = { -- The Captain's Honor
    4129, -- Shipwrecked Sailors
  },
  [4131] = { -- The Maormer's Vessels
    4129, -- Shipwrecked Sailors
  },
  [4135] = { -- Pulled Under
    3927, -- In His Wake
  },
  [4139] = { -- Shattered Hopes
    3978, -- Tomb Beneath the Mountain
    4147, -- The Shackled Guardian
  },
  [4141] = { -- Do Kill the Messenger
    4128, -- Mystery Metal
  },
  [4143] = { -- Restore the Silvenar
    4477, -- A Wedding to Attend
    4124, -- The Prisoner of Jathsogur
  },
  [4151] = { -- A Bitter Pill
    4146, -- A Family Divided
  },
  [4152] = { -- Swamp to Snow
    3910, -- The Dream of the Hist
  },
  [4158] = { -- The Pride of a Prince
    4150, -- Sleeping on the Job
  },
  [4163] = { -- Onward to Shadowfen
    3831, -- The Judgment of Veloth
  },
  [4164] = { -- A Giant in Smokefrost Peaks
    4139, -- Shattered Hopes
  },
  [4165] = { -- The Dark Night of the Soul
    4142, -- Awakening
  },
  [4166] = { -- The War Council
    4158, -- The Pride of a Prince
  },
  [4169] = { -- Of Councils and Kings
    4123, -- Gods Save the King
  },
  [4171] = { -- The Rise of Sage Svari
    3974, -- Storming the Hall
  },
  [4173] = { -- The Thunder Breaks
    4160, -- Approaching Thunder
  },
  [4176] = { -- Breaking the Coven
    4174, -- Scouting the Mine
  },
  [4177] = { -- Victory at Morvunskar
    4062, -- Blindsided
    4071, -- Sleep for the Dead
  },
  [4184] = { -- To Pinepeak Caverns
    4147, -- The Shackled Guardian
  },
  [4185] = { -- To Honrich Tower
    4147, -- The Shackled Guardian
    3978, -- Tomb Beneath the Mountain
  },
  [4188] = { -- Stomping Sinmur
    4186, -- Securing the Pass
  },
  [4194] = { -- One Fell Swoop
    4193, -- House and Home
  },
  [4197] = { -- Sounds of Alarm
    4061, -- One Victor, One King
  },
  [4199] = { -- A Tangled Net
    4196, -- Enemy of My Enemy
  },
  [4203] = { -- Lifeline
    4166, -- The War Council
  },
  [4209] = { -- Teldur's End
    4208, -- Silsailen Rescue
    4210, -- Real Marines
  },
  [4211] = { -- To Tanzelwil
    4256, -- A Hostile Situation
  },
  [4217] = { -- In the Name of the Queen
    4256, -- A Hostile Situation
  },
  [4222] = { -- Rites of the Queen
    4217, -- In the Name of the Queen
  },
  [4225] = { -- To Nimalten
    3968, -- Through the Shroud
  },
  [4252] = { -- Save Your Voice
    4248, -- Geirmund's Guardian
  },
  [4256] = { -- A Hostile Situation
    4255, -- Ensuring Security
  },
  [4260] = { -- Breaking the Barrier
    4345, -- The Veil Falls
  },
  [4261] = { -- Sever All Ties
    4260, -- Breaking the Barrier
  },
  [4266] = { -- The First Patient
    4264, -- Plague of Phaer
  },
  [4278] = { -- A Village Awakened
    4277, -- Silent Village
  },
  [4294] = { -- The Unveiling
    4293, -- Putting the Pieces Together
  },
  [4306] = { -- Finding Winter's Hammer
    3974, -- Storming the Hall 2, --
    4171, -- The Rise of Sage Svari
  },
  [4307] = { -- Returning Winter's Bite
    4306, -- Finding Winter's Hammer
  },
  [4322] = { -- Lost Crown
    4316, -- On a Dare
  },
  [4330] = { -- Lifting the Veil
    4256, -- A Hostile Situation
    4294, -- The Unveiling
  },
  [4331] = { -- Wearing the Veil
    4330, -- Lifting the Veil
  },
  [4341] = { -- Cutting Off the Source
    4340, -- The White Mask of Merien
  },
  [4345] = { -- The Veil Falls
    4331, -- Wearing the Veil
  },
  [4349] = { -- Kill Enemy Players
    4706, -- Reporting for Duty
  },
  [4352] = { -- The Library of Dusk
    4351, -- Through the Daedric Lens
  },
  [4357] = { -- To Firsthold
    4355, -- Through the Ashes
    4345, -- The Veil Falls
  },
  [4358] = { -- Between Blood and Bone
    4348, -- A Graveyard of Ships
  },
  [4365] = { -- To Dawnbreak
    4345, -- The Veil Falls
  },
  [4366] = { -- To Mathiisen
    4222, -- Rites of the Queen
  },
  [4368] = { -- To Skywatch
    4294, -- The Unveiling
  },
  [4373] = { -- Export Business
    4378, -- Naval Intelligence
  },
  [4386] = { -- Heart of the Matter
    4385, -- Lost in Study
  },
  [4397] = { -- The Enemy Within
    4395, -- Enemies at the Gate
  },
  [4398] = { -- A Chief Concern
    4397, -- The Enemy Within
  },
  [4405] = { -- A Little on the Side
    4404, -- Lost Treasures
  },
  [4411] = { -- Final Blows
    4345, -- The Veil Falls
  },
  [4435] = { -- Simply Misplaced
    3916, -- Long Lost Lore
  },
  [4443] = { -- To Alcaire Castle
    2556, -- False Accusations
  },
  [4449] = { -- Carzog's Demise
    4523, -- The Bloodthorn Plot
  },
  [4452] = { -- Reap What Is Sown
    4458, -- The Drublog of Dra'bul
  },
  [4456] = { -- The Hound's Plan
    4452, -- Reap What Is Sown
  },
  [4458] = { -- The Drublog of Dra'bul
    4194, -- One Fell Swoop
  },
  [4459] = { -- The Mournhold Underground
    4453, -- A Favor Returned
  },
  [4461] = { -- Grimmer Still
    4460, -- Grim Situation
  },
  [4473] = { -- Revenge Against Rama
    1568, -- A Means to an End
  },
  [4474] = { -- Daughter of Giants
    4831, -- The Harborage
  },
  [4476] = { -- Tip of the Spearhead
    4466, -- The Broken Spearhead
    4510, -- The Spearhead's Captain
  },
  [4477] = { -- A Wedding to Attend
    4124, -- The Prisoner of Jathsogur
  },
  [4479] = { -- Motes in the Moonlight
    4712, -- The First Step
  },
  [4485] = { -- Loose Ends
    4482, -- Rat Problems
    4483, -- Ezzag's Bandits
    4484, -- Haunting of Kalari
  },
  [4486] = { -- Down the Skeever Hole
    4480, -- Oath of Excision
  },
  [4499] = { -- Baan Dar's Bash
    4440, -- Baan Dar's Boast
  },
  [4510] = { -- The Spearhead's Captain
    4454, -- Innocent Scoundrel
    4344, -- Like Moths to a Candle
    4431, -- Buried Secrets
  },
  [4514] = { -- The Spearhead's Crew
    4466, -- The Broken Spearhead
  },
  [4523] = { -- The Bloodthorn Plot
    4476, -- Tip of the Spearhead
  },
  [4544] = { -- The Dark Mane
    4143, -- Restore the Silvenar
  },
  [4546] = { -- Retaking the Pass
    4735, -- The Staff of Magnus
  },
  [4550] = { -- The Fires of Dune
    4479, -- Motes in the Moonlight
  },
  [4552] = { -- Chasing Shadows
    4474, -- Daughter of Giants
  },
  [4558] = { -- Taking the Fight to the Enemy
    3267, -- The Fall of Faolchu
  },
  [4566] = { -- On to Glenumbra
    4449, -- Carzog's Demise
  },
  [4574] = { -- Veil of Illusion
    4735, -- The Staff of Magnus
  },
  [4580] = { -- Double Jeopardy
    4574, -- Veil of Illusion
  },
  [4587] = { -- Trail of the Skin-Stealer
    3687, -- Getting to the Truth
  },
  [4590] = { -- The Skin-Stealer's Lair
    4587, -- Trail of the Skin-Stealer
  },
  [4593] = { -- Audience with the Wilderking
    4573, -- Frighten the Fearsome
  },
  [4602] = { -- Light from the Darkness
    4679, -- The Shadow's Embrace
    4654, -- An Unusual Circumstance
  },
  [4606] = { -- Keepers of the Shell
    4590, -- The Skin-Stealer's Lair
  },
  [4607] = { -- Castle of the Worm
    4552, -- Chasing Shadows
  },
  [4610] = { -- The Army of Meridia
    4605, -- The Hollow City
  },
  [4615] = { -- Lost in the Mist
    4611, -- Mist and Shadow
  },
  [4621] = { -- The Tempest Unleashed
    4624, -- The Perils of Diplomacy
  },
  [4646] = { -- The Mnemic Egg
    4606, -- Keepers of the Shell
  },
  [4648] = { -- The Summoner Division
    4647, -- A Foot in the Door
    4649, -- The Sorcerer Division
    4650, -- The Swordmaster Division
  },
  [4649] = { -- The Sorcerer Division
    4647, -- A Foot in the Door
  },
  [4650] = { -- The Swordmaster Division
    4647, -- A Foot in the Door
    4649, -- The Sorcerer Division
  },
  [4651] = { -- The Champion Division
    4647, -- A Foot in the Door
    4648, -- The Summoner Division
    4649, -- The Sorcerer Division
    4650, -- The Swordmaster Division
  },
  [4653] = { -- Stonefire Machinations
    4652, -- The Colovian Occupation
  },
  [4655] = { -- Hadran's Fall
    4598, -- Into the Vice Den
  },
  [4657] = { -- The Spinner's Tale
    4593, -- Audience with the Wilderking
  },
  [4665] = { -- Ezreba's Fate
    4599, -- On the Doorstep
  },
  [4668] = { -- Lizard Racing
    4655, -- Hadran's Fall
    4598, -- Into the Vice Den
  },
  [4669] = { -- Spikeball
    4655, -- Hadran's Fall
    4598, -- Into the Vice Den
  },
  [4670] = { -- Troll Arena
    4655, -- Hadran's Fall
    4598, -- Into the Vice Den
  },
  [4686] = { -- The Initiation
    4672, -- Morwha's Curse
  },
  [4689] = { -- A Door Into Moonlight
    4461, -- Grimmer Still
    4653, -- Stonefire Machinations
  },
  [4690] = { -- Striking at the Heart
    4546, -- Retaking the Pass
    4601, -- Right of Theft
    4608, -- The Blight of the Bosmer
  },
  [4697] = { -- To Rawl'kha
    4653, -- Stonefire Machinations
    4689, -- A Door Into Moonlight
    4461, -- Grimmer Still
  },
  [4701] = { -- Crossing the Chasm
    4610, -- The Army of Meridia
  },
  [4705] = { -- Siege Warfare
    4704, -- Welcome to Cyrodiil
  },
  [4706] = { -- Reporting for Duty
    4705, -- Siege Warfare
  },
  [4709] = { -- The Path to Moonmont
    4712, -- The First Step
  },
  [4710] = { -- Hallowed To Arenthia
    4689, -- A Door Into Moonlight
  },
  [4711] = { -- To Dune
    4479, -- Motes in the Moonlight
    4689, -- A Door Into Moonlight
  },
  [4712] = { -- The First Step
    4689, -- A Door Into Moonlight
    4653, -- Stonefire Machinations
    4461, -- Grimmer Still
  },
  [4715] = { -- The Harvest Heart
    4701, -- Crossing the Chasm
  },
  [4719] = { -- The Moonlit Path
    4550, -- The Fires of Dune
  },
  [4720] = { -- The Den of Lorkhaj
    4719, -- The Moonlit Path
  },
  [4723] = { -- Siege Warfare
    4722, -- Welcome to Cyrodiil
  },
  [4724] = { -- Reporting for Duty
    4723, -- Siege Warfare
  },
  [4726] = { -- Siege Warfare
    4725, -- Welcome to Cyrodiil
  },
  [4727] = { -- Reporting for Duty
    4726, -- Siege Warfare
  },
  [4730] = { -- Breaking the Shackle
    4626, -- Vanus Unleashed
  },
  [4739] = { -- A Storm Upon the Shore
    4580, -- Double Jeopardy
  },
  [4744] = { -- Before the Storm
    4580, -- Double Jeopardy
  },
  [4750] = { -- Throne of the Wilderking
    4593, -- Audience with the Wilderking
  },
  [4758] = { -- The Final Assault
    4774, -- The Citadel Must Fall
  },
  [4759] = { -- Hallowed to Rawl'kha
    4689, -- A Door Into Moonlight
    4653, -- Stonefire Machinations
    4461, -- Grimmer Still
  },
  [4761] = { -- Trouble at Tava's Blessing
    2192, -- A Reckoning with Uwafa
  },
  [4764] = { -- The Tharn Speaks
    4607, -- Castle of the Worm
  },
  [4765] = { -- Pelidil's End
    4739, -- A Storm Upon the Shore
  },
  [4774] = { -- The Citadel Must Fall
    4715, -- The Harvest Heart
  },
  [4780] = { -- Messages Across Tamriel
    4832, -- Council of the Five Companions
  },
  [4783] = { -- The Weight of Three Crowns
    4780, -- Messages Across Tamriel
  },
  [4785] = { -- The Senche
    4826, -- Hunting the Mammoth
    4827, -- Hunting the Troll
    4828, -- Hunting the Wasp
  },
  [4787] = { -- Mourning the Lost
    4546, -- Retaking the Pass
  },
  [4798] = { -- Eye on Arenthia
    4461, -- Grimmer Still
  },
  [4818] = { -- To Auridon
    4621, -- The Tempest Unleashed
  },
  [4821] = { -- Report to Marbruk
    4765, -- Pelidil's End
  },
  [4832] = { -- Council of the Five Companions
    4867, -- Shadow of Sancre Tor
  },
  [4836] = { -- Halls of Torment
    4764, -- The Tharn Speaks
  },
  [4837] = { -- Valley of Blades
    4836, -- Halls of Torment
  },
  [4847] = { -- God of Schemes
    4832, -- Council of the Five Companions
    4758, -- The Final Assault
  },
  [4850] = { -- Shades of Green
    4546, -- Retaking the Pass
    4608, -- The Blight of the Bosmer
    4601, -- Right of Theft
  },
  [4853] = { -- Woodhearth
    4750, -- Throne of the Wilderking
  },
  [4857] = { -- The Concealing Veil
    465, -- The Blood-Splattered Shield
  },
  [4867] = { -- Shadow of Sancre Tor
    4837, -- Valley of Blades
  },
  [4884] = { -- The Lightless Remnant
    5024, -- Puzzle of the Pass
  },
  [4891] = { -- The Parley
    1834, -- Heart of Evil
  },
  [4896] = { -- The Great Tree
    4261, -- Sever All Ties
  },
  [4901] = { -- The Road to Rivenspire
    575, -- Vaermina's Gambit
  },
  [4903] = { -- Dream-Walk Into Darkness
    4902, -- Shornhelm Divided
  },
  [4912] = { -- Storming the Garrison
    4891, -- The Parley
  },
  [4918] = { -- The Shifting Sands of Fate
    2018, -- A Thirst for Revolution
  },
  [4922] = { -- The Orrery of Elden Root
    4951, -- Fit to Rule
  },
  [4926] = { -- Assassin Hunter
    4945, -- A Spy in Shornhelm
  },
  [4927] = { -- The Assassin's List
    4926, -- Assassin Hunter
  },
  [4928] = { -- Threat of Death
    4927, -- The Assassin's List
  },
  [4929] = { -- A Dagger to the Heart
    4928, -- Threat of Death
  },
  [4936] = { -- The Crown of Shornhelm
    4884, -- The Lightless Remnant
  },
  [4937] = { -- The Sanctifying Flames
    465, -- The Blood-Splattered Shield
  },
  [4945] = { -- A Spy in Shornhelm
    4903, -- Dream-Walk Into Darkness
  },
  [4949] = { -- Favor for the Queen
    4936, -- The Crown of Shornhelm
  },
  [4951] = { -- Fit to Rule
    4943, -- The Honor of the Queen
  },
  [4952] = { -- Dearly Departed
    3286, -- Under Siege
  },
  [4958] = { -- Northpoint in Peril
    4857, -- The Concealing Veil
  },
  [4959] = { -- Trials and Tribulations
    4912, -- Storming the Garrison
  },
  [4960] = { -- To Walk on Far Shores
    4959, -- Trials and Tribulations
  },
  [4965] = { -- Children of Yokuda
    4449, -- Carzog's Demise
    4476, -- Tip of the Spearhead
  },
  [4971] = { -- The Arch-Mage's Boon
    3997, -- The Mad God's Bargain
  },
  [4972] = { -- The Liberation of Northpoint
    4958, -- Northpoint in Peril
  },
  [4978] = { -- Striking Back
    4912, -- Storming the Garrison
  },
  [4979] = { -- Publish or Perish
    4911, -- Present in Memory
  },
  [4988] = { -- Rendezvous at the Pass
    4891, -- The Parley
  },
  [4993] = { -- Report to Evermore
    1834, -- Heart of Evil
  },
  [4998] = { -- Cadwell's Silver
    4847, -- God of Schemes
  },
  [5000] = { -- Cadwell's Gold
    4998, -- Cadwell's Silver
  },
  [5006] = { -- To Velyn Harbor
    4690, -- Striking at the Heart
  },
  [5015] = { -- Eyes of the Enemy
    3687, -- Getting to the Truth
  },
  [5016] = { -- Children of the Hist
    4590, -- The Skin-Stealer's Lair
  },
  [5018] = { -- Fell's Justice
    4931, -- Frightened Folk
  },
  [5021] = { -- The Lover
    5022, -- The Bandit
  },
  [5022] = { -- The Bandit
    5020, -- The Wayward Son
  },
  [5024] = { -- Puzzle of the Pass
    4972, -- The Liberation of Northpoint
  },
  [5025] = { -- The Corrupted Stone
    5033, -- The Star-Gazers
  },
  [5034] = { -- A Grave Situation
    5035, -- Calling Hakra
    3978, -- Tomb Beneath the Mountain
  },
  [5036] = { -- Honrich Tower
    3978, -- Tomb Beneath the Mountain
    4147, -- The Shackled Guardian
  },
  [5051] = { -- The Last of Them
    4972, -- The Liberation of Northpoint
  },
  [5068] = { -- Quest for the Cure
    5057, -- Bad Medicine
    5067, -- Proprietary Formula
  },
  [5069] = { -- The Warrior's Call
    5033, -- The Star-Gazers
  },
  [5088] = { -- Naemon's Return
    4821, -- Report to Marbruk
  },
  [5091] = { -- Hallowed To Grimwatch
    4689, -- A Door Into Moonlight
  },
  [5092] = { -- The Champions at Rawl'kha
    4653, -- Stonefire Machinations
    4689, -- A Door Into Moonlight
    4461, -- Grimmer Still
  },
  [5093] = { -- Moons Over Grimwatch
    4799, -- To Saifa in Rawl'kha
  },
  [5110] = { -- Gem of the Stars
    5079, -- The Seeker's Archive
  },
  [5111] = { -- Strange Lexicon
    5079, -- The Seeker's Archive
  },
  [5112] = { -- Message Unknown
    5079, -- The Seeker's Archive
  },
  [5115] = { -- The Missing Guardian
    5033, -- The Star-Gazers
    5025, -- The Corrupted Stone
    5069, -- The Warrior's Call
    5116, -- Elemental Army
    5130, -- The Shattered and the Lost
  },
  [5116] = { -- Elemental Army
    5033, -- The Star-Gazers
  },
  [5130] = { -- The Shattered and the Lost
    5033, -- The Star-Gazers
  },
  [5220] = { -- Kill Enemy Templars
    4706, -- Reporting for Duty
  },
  [5221] = { -- Kill Enemy Templars
    4727, -- Reporting for Duty
  },
  [5222] = { -- Kill Enemy Templars
    4724, -- Reporting for Duty
  },
  [5226] = { -- Kill Enemy Dragonknights
    4706, -- Reporting for Duty
  },
  [5227] = { -- Kill Enemy Dragonknights
    4727, -- Reporting for Duty
  },
  [5228] = { -- Kill Enemy Dragonknights
    4724, -- Reporting for Duty
  },
  [5229] = { -- Kill Enemy Nightblades
    4706, -- Reporting for Duty
  },
  [5230] = { -- Kill Enemy Nightblades
    4727, -- Reporting for Duty
  },
  [5231] = { -- Kill Enemy Nightblades
    4724, -- Reporting for Duty
  },
  [5232] = { -- Kill Enemy Sorcerers
    4706, -- Reporting for Duty
  },
  [5233] = { -- Kill Enemy Sorcerers
    4727, -- Reporting for Duty
  },
  [5234] = { -- Kill Enemy Sorcerers
    4724, -- Reporting for Duty
  },
  [5239] = { -- Dawn of the Exalted Viper
    5194, -- Slithering Brood
    5203, -- The Serpent's Fang
    5115, -- The Missing Guardian
  },
  [5243] = { -- A Leaf in the Wind
    5194, -- Slithering Brood
  },
  [5245] = { -- Holding Court
    5203, -- The Serpent's Fang
  },
  [5249] = { -- Blacksmith Certification
    5259, -- Crafting Certification
  },
  [5258] = { -- The Time-Lost Warrior
    5239, -- Dawn of the Exalted Viper
    5115, -- The Missing Guardian
  },
  [5289] = { -- Provisioner Certification
    5259, -- Crafting Certification
  },
  [5302] = { -- Woodworker Certification
    5259, -- Crafting Certification
  },
  [5310] = { -- Clothier Certification
    5259, -- Crafting Certification
  },
  [5314] = { -- Enchanter Certification
    5259, -- Crafting Certification
  },
  [5315] = { -- Alchemist Certification
    5259, -- Crafting Certification
    5314, -- Enchanter Certification
  },
  [5329] = { -- For King and Glory
    5450, -- Invitation to Orsinium
  },
  [5348] = { -- To Save a Chief
    5458, -- In the Name of the King
  },
  [5349] = { -- The King's Gambit
    5468, -- The Anger of a King
  },
  [5368] = { -- Blacksmith Writ
    5249, -- Blacksmith Certification
  },
  [5374] = { -- Clothier Writ
    5310, -- Clothier Certification
  },
  [5377] = { -- Blacksmith Writ
    5249, -- Blacksmith Certification
  },
  [5388] = { -- Clothier Writ
    5310, -- Clothier Certification
  },
  [5389] = { -- Clothier Writ
    5310, -- Clothier Certification
  },
  [5392] = { -- Blacksmith Writ
    5249, -- Blacksmith Certification
  },
  [5394] = { -- Woodworker Writ
    5302, -- Woodworker Certification
  },
  [5395] = { -- Woodworker Writ
    5302, -- Woodworker Certification
  },
  [5396] = { -- Woodworker Writ
    5302, -- Woodworker Certification
  },
  [5400] = { -- Enchanter Writ
    5314, -- Enchanter Certification
  },
  [5406] = { -- Enchanter Writ
    5314, -- Enchanter Certification
  },
  [5407] = { -- Enchanter Writ
    5314, -- Enchanter Certification
  },
  [5409] = { -- Provisioner Writ
    5289, -- Provisioner Certification
  },
  [5412] = { -- Provisioner Writ
    5289, -- Provisioner Certification
  },
  [5413] = { -- Provisioner Writ
    5289, -- Provisioner Certification
  },
  [5414] = { -- Provisioner Writ
    5289, -- Provisioner Certification
  },
  [5415] = { -- Alchemist Writ
    5315, -- Alchemist Certification
  },
  [5416] = { -- Alchemist Writ
    5315, -- Alchemist Certification
  },
  [5417] = { -- Alchemist Writ
    5315, -- Alchemist Certification
  },
  [5418] = { -- Alchemist Writ
    5315, -- Alchemist Certification
  },
  [5447] = { -- A King-Sized Problem
    5329, -- For King and Glory
  },
  [5458] = { -- In the Name of the King
    5447, -- A King-Sized Problem
  },
  [5466] = { -- Tinker Trouble
    5316, -- An Unexpected Fall
  },
  [5468] = { -- The Anger of a King
    5348, -- To Save a Chief
  },
  [5469] = { -- Blood Price
    5337, -- A Question of Succession
  },
  [5470] = { -- A Healthy Choice
    5454, -- Kindred Spirits
  },
  [5471] = { -- Thicker Than Water
    5470, -- A Healthy Choice
  },
  [5472] = { -- A Feast To Remember
    5471, -- Thicker Than Water
  },
  [5473] = { -- Of Brands and Bones
    5496, -- City on the Brink
    5487, -- City on the Brink
    5493, -- City on the Brink
    5602, -- City on the Brink
  },
  [5477] = { -- The Watcher in the Walls
    5496, -- City on the Brink
    5487, -- City on the Brink
    5493, -- City on the Brink
    5602, -- City on the Brin
  },
  [5479] = { -- A Cold Wind From the Mountain
    5476, -- Awaken the Past
  },
  [5480] = { -- The Bleeding Temple
    5496, -- City on the Brink
    5487, -- City on the Brink
    5493, -- City on the Brink
    5602, -- City on the Brink
  },
  [5481] = { -- Blood on a King's Hands
    5349, -- The King's Gambit
  },
  [5482] = { -- The Sublime Brazier
    5473, -- Of Brands and Bones
    5490, -- Knowledge is Power
    5489, -- The Lock and the Legion
    5483, -- The Imperial Standard
    5480, -- The Bleeding Temple
    5477, -- The Watcher in the Walls
  },
  [5483] = { -- The Imperial Standard
    5496, -- City on the Brink
    5487, -- City on the Brink
    5493, -- City on the Brink
    5602, -- City on the Brink
  },
  [5489] = { -- The Lock and the Legion
    5496, -- City on the Brink
    5487, -- City on the Brink
    5493, -- City on the Brink
    5602, -- City on the Brink
  },
  [5490] = { -- Knowledge is Power
    5496, -- City on the Brink
    5487, -- City on the Brink
    5493, -- City on the Brink
    5602, -- City on the Brink
  },
  [5494] = { -- Long Live the King
    5481, -- Blood on a King's Hands
  },
  [5505] = { -- Fire in the Hold
    5317, -- Broken Promises
  },
  [5506] = { -- Scouting the Memorial District
    5487, -- City on the Brink
    5493, -- City on the Brink
    5496, -- City on the Brink
    5602, -- City on the Brink
  },
  [5508] = { -- Scouting the Arboretum
    5487, -- City on the Brink
    5493, -- City on the Brink
    5496, -- City on the Brink
    5602, -- City on the Brink
  },
  [5509] = { -- Parts of the Whole
    5316, -- An Unexpected Fall
    5466, -- Tinker Trouble
  },
  [5510] = { -- Scouting the Arena District
    5487, -- City on the Brink
    5493, -- City on the Brink
    5496, -- City on the Brink
    5602, -- City on the Brink
  },
  [5511] = { -- Scouting the Elven Gardens
    5487, -- City on the Brink
    5493, -- City on the Brink
    5496, -- City on the Brink
    5602, -- City on the Brink
  },
  [5512] = { -- Scouting the Nobles District
    5487, -- City on the Brink
    5493, -- City on the Brink
    5496, -- City on the Brink
    5602, -- City on the Brink
  },
  [5513] = { -- Scouting the Temple District
    5487, -- City on the Brink
    5493, -- City on the Brink
    5496, -- City on the Brink
    5602, -- City on the Brink
  },
  [5529] = { -- Sacrament: Trader's Cove
    5595, -- A Lesson in Silence
  },
  [5532] = { -- The Long Game
    5534, -- Cleaning House
  },
  [5534] = { -- Cleaning House
    5531, -- Partners in Crime
  },
  [5535] = { -- A Double Life
    5534, -- Cleaning House
  },
  [5536] = { -- Heist: Deadhollow Halls
    5582, -- Master of Heists
  },
  [5537] = { -- His Greatest Treasure
    5535, -- A Double Life
    5556, -- A Flawless Plan
  },
  [5540] = { -- Signed in Blood
    5538, -- Voices in the Dark
  },
  [5542] = { -- Welcome Home
    5540, -- Signed in Blood
  },
  [5543] = { -- Shell Game
    5532, -- The Long Game
  },
  [5545] = { -- Prison Break
    5549, -- Forever Hold Your Peace
  },
  [5549] = { -- Forever Hold Your Peace
    5556, -- A Flawless Plan
  },
  [5553] = { -- The One That Got Away
    5545, -- Prison Break
  },
  [5556] = { -- A Flawless Plan
    5532, -- The Long Game
  },
  [5566] = { -- A Faded Flower
    5532, -- The Long Game
  },
  [5567] = { -- Dark Revelations
    5596, -- A Special Request
  },
  [5569] = { -- A Cordial Collaboration
    5596, -- A Special Request
  },
  [5570] = { -- Everyone Has A Price
    5543, -- Shell Game
    5556, -- A Flawless Plan
  },
  [5572] = { -- Heist: The Hideaway
    5582, -- Master of Heists
  },
  [5573] = { -- Heist: Underground Sepulcher
    5582, -- Master of Heists
  },
  [5575] = { -- Heist: Glittering Grotto
    5582, -- Master of Heists
  },
  [5577] = { -- Heist: Secluded Sewers
    5582, -- Master of Heists
  },
  [5581] = { -- That Which Was Lost
    5549, -- Forever Hold Your Peace
    5566, -- A Faded Flower
  },
  [5582] = { -- Master of Heists
    5532, -- The Long Game
  },
  [5584] = { -- The Covetous Countess
    5531, -- Partners in Crime
  },
  [5586] = { -- The Lost Pearls
    5589, -- The Sailor's Pipe
  },
  [5587] = { -- Thrall Cove
    5589, -- The Sailor's Pipe
  },
  [5588] = { -- Memories of Youth
    5589, -- The Sailor's Pipe
  },
  [5589] = { -- The Sailor's Pipe
    5531, -- Partners in Crime
  },
  [5590] = { -- Contract: Glenumbra
    5708, -- Contract: Kvatch
  },
  [5591] = { -- Contract: Glenumbra
    5708, -- Contract: Kvatch
  },
  [5592] = { -- Contract: Glenumbra
    5708, -- Contract: Kvatch
  },
  [5593] = { -- Contract: Glenumbra
    5708, -- Contract: Kvatch
  },
  [5594] = { -- Contract: Glenumbra
    5708, -- Contract: Kvatch
  },
  [5595] = { -- A Lesson in Silence
    5708, -- Contract: Kvatch
  },
  [5596] = { -- A Special Request
    5599, -- Questions of Faith
  },
  [5597] = { -- A Ghost from the Past
    5567, -- Dark Revelations
  },
  [5598] = { -- The Wrath of Sithis
    5597, -- A Ghost from the Past
  },
  [5599] = { -- Questions of Faith
    5595, -- A Lesson in Silence
  },
  [5600] = { -- Filling the Void
    5598, -- The Wrath of Sithis
  },
  [5609] = { -- Plucking Fingers
    5531, -- Partners in Crime
  },
  [5610] = { -- Idle Hands
    5531, -- Partners in Crime
  },
  [5614] = { -- Contract: Stormhaven
    5540, -- Signed in Blood
  },
  [5616] = { -- Contract: Rivenspire
    5708, -- Contract: Kvatch
  },
  [5617] = { -- Contract: Rivenspire
    5708, -- Contract: Kvatch
  },
  [5618] = { -- Contract: Stormhaven
    5708, -- Contract: Kvatch
  },
  [5619] = { -- Contract: Stormhaven
    5708, -- Contract: Kvatch
  },
  [5620] = { -- Contract: Stormhaven
    5708, -- Contract: Kvatch
  },
  [5621] = { -- Contract: Stormhaven
    5708, -- Contract: Kvatch
  },
  [5622] = { -- Contract: Alik'r Desert
    5708, -- Contract: Kvatch
  },
  [5623] = { -- Brotherhood Contract
    5540, -- Signed in Blood
  },
  [5624] = { -- Contract: Alik'r Desert
    5708, -- Contract: Kvatch
  },
  [5625] = { -- Contract: Alik'r Desert
    5708, -- Contract: Kvatch
  },
  [5626] = { -- Contract: Rivenspire
    5708, -- Contract: Kvatch
  },
  [5627] = { -- Contract: Alik'r Desert
    5708, -- Contract: Kvatch
  },
  [5629] = { -- Contract: Rivenspire
    5540, -- Signed in Blood
  },
  [5630] = { -- Contract: Bangkorai
    5708, -- Contract: Kvatch
  },
  [5631] = { -- Contract: Bangkorai
    5708, -- Contract: Kvatch
  },
  [5632] = { -- Contract: Bangkorai
    5708, -- Contract: Kvatch
  },
  [5633] = { -- Contract: Bangkorai
    5708, -- Contract: Kvatch
  },
  [5634] = { -- Litany of Blood
    5529, -- Sacrament: Trader's Cove
    5713, -- Sacrament: Trader's Cove
    5714, -- Sacrament: Trader's Cove
    5718, -- Sacrament: Smuggler's Den
    5719, -- Sacrament: Smuggler's Den
    5720, -- Sacrament: Smuggler's Den
    5724, -- Sacrament: Sewer Tenement
    5725, -- Sacrament: Sewer Tenement
    5726, -- Sacrament: Sewer Tenement
  },
  [5638] = { -- Under Our Thumb
    5531, -- Partners in Crime
  },
  [5639] = { -- Idle Hands
    5531, -- Partners in Crime
  },
  [5640] = { -- Idle Hands
    5531, -- Partners in Crime
  },
  [5641] = { -- Plucking Fingers
    5531, -- Partners in Crime
  },
  [5642] = { -- Plucking Fingers
    5531, -- Partners in Crime
  },
  [5643] = { -- Under Our Thumb
    5531, -- Partners in Crime
  },
  [5644] = { -- Under Our Thumb
    5531, -- Partners in Crime
  },
  [5649] = { -- Contract: Deshaan
    5708, -- Contract: Kvatch
  },
  [5650] = { -- Contract: Deshaan
    5708, -- Contract: Kvatch
  },
  [5651] = { -- Contract: Deshaan
    5708, -- Contract: Kvatch
  },
  [5652] = { -- Contract: Deshaan
    5708, -- Contract: Kvatch
  },
  [5653] = { -- Contract: Eastmarch
    5708, -- Contract: Kvatch
  },
  [5654] = { -- Contract: Auridon
    5708, -- Contract: Kvatch
  },
  [5655] = { -- Contract: Auridon
    5708, -- Contract: Kvatch
  },
  [5656] = { -- Contract: Auridon
    5708, -- Contract: Kvatch
  },
  [5657] = { -- Contract: Auridon
    5708, -- Contract: Kvatch
  },
  [5658] = { -- Contract: Auridon
    5708, -- Contract: Kvatch
  },
  [5659] = { -- Contract: Grahtwood
    5708, -- Contract: Kvatch
  },
  [5660] = { -- Contract: Grahtwood
    5708, -- Contract: Kvatch
  },
  [5661] = { -- Contract: Grahtwood
    5708, -- Contract: Kvatch
  },
  [5662] = { -- Contract: Malabal Tor
    5708, -- Contract: Kvatch
  },
  [5663] = { -- Contract: Malabal Tor
    5708, -- Contract: Kvatch
  },
  [5664] = { -- The Sweetroll Killer
    5548, -- Debts of War
    5569, -- A Cordial Collaboration
    5596, -- A Special Request
  },
  [5665] = { -- Contract: Malabal Tor
    5708, -- Contract: Kvatch
  },
  [5666] = { -- Contract: Malabal Tor
    5708, -- Contract: Kvatch
  },
  [5667] = { -- Contract: Eastmarch
    5708, -- Contract: Kvatch
  },
  [5668] = { -- The Cutpurse's Craft
    5531, -- Partners in Crime
  },
  [5669] = { -- Contract: Eastmarch
    5708, -- Contract: Kvatch
  },
  [5670] = { -- Contract: Eastmarch
    5708, -- Contract: Kvatch
  },
  [5671] = { -- Contract: Grahtwood
    5708, -- Contract: Kvatch
  },
  [5672] = { -- Contract: Grahtwood
    5708, -- Contract: Kvatch
  },
  [5673] = { -- Contract: Greenshade
    5708, -- Contract: Kvatch
  },
  [5674] = { -- Contract: Greenshade
    5708, -- Contract: Kvatch
  },
  [5675] = { -- Contract: Reaper's March
    5708, -- Contract: Kvatch
  },
  [5676] = { -- Contract: Greenshade
    5708, -- Contract: Kvatch
  },
  [5677] = { -- Contract: Greenshade
    5708, -- Contract: Kvatch
  },
  [5678] = { -- Contract: Reaper's March
    5708, -- Contract: Kvatch
  },
  [5679] = { -- Contract: Reaper's March
    5708, -- Contract: Kvatch
  },
  [5680] = { -- Contract: Reaper's March
    5708, -- Contract: Kvatch
  },
  [5681] = { -- Contract: Shadowfen
    5708, -- Contract: Kvatch
  },
  [5682] = { -- Contract: Shadowfen
    5708, -- Contract: Kvatch
  },
  [5683] = { -- Contract: Shadowfen
    5708, -- Contract: Kvatch
  },
  [5684] = { -- Contract: Shadowfen
    5708, -- Contract: Kvatch
  },
  [5685] = { -- Contract: Stonefalls
    5708, -- Contract: Kvatch
  },
  [5687] = { -- Contract: Stonefalls
    5708, -- Contract: Kvatch
  },
  [5688] = { -- Contract: Gold Coast Spree
    5708, -- Contract: Kvatch
  },
  [5689] = { -- Contract: Stonefalls
    5708, -- Contract: Kvatch
  },
  [5690] = { -- Contract: Stonefalls
    5708, -- Contract: Kvatch
  },
  [5691] = { -- Contract: The Rift
    5708, -- Contract: Kvatch
  },
  [5692] = { -- Contract: The Rift
    5708, -- Contract: Kvatch
  },
  [5693] = { -- Contract: Alik'r Desert Spree
    5708, -- Contract: Kvatch
  },
  [5694] = { -- Contract: Auridon Spree
    5708, -- Contract: Kvatch
  },
  [5695] = { -- Contract: The Rift
    5708, -- Contract: Kvatch
  },
  [5696] = { -- Contract: Bangkorai Spree
    5708, -- Contract: Kvatch
  },
  [5697] = { -- Contract: The Rift
    5708, -- Contract: Kvatch
  },
  [5698] = { -- Contract: Deshaan Spree
    5708, -- Contract: Kvatch
  },
  [5699] = { -- Contract: Eastmarch Spree
    5708, -- Contract: Kvatch
  },
  [5700] = { -- Contract: Glenumbra Spree
    5708, -- Contract: Kvatch
  },
  [5701] = { -- Contract: Grahtwood Spree
    5708, -- Contract: Kvatch
  },
  [5703] = { -- Contract: Greenshade Spree
    5708, -- Contract: Kvatch
  },
  [5704] = { -- Contract: Malabal Tor Spree
    5708, -- Contract: Kvatch
  },
  [5705] = { -- Contract: Reaper's March Spree
    5708, -- Contract: Kvatch
  },
  [5706] = { -- Contract: Rivenspire Spree
    5708, -- Contract: Kvatch
  },
  [5707] = { -- Contract: Shadowfen Spree
    5708, -- Contract: Kvatch
  },
  [5708] = { -- Contract: Kvatch
    5542, -- Welcome Home
  },
  [5709] = { -- Contract: Stonefalls Spree
    5708, -- Contract: Kvatch
  },
  [5710] = { -- Contract: Stormhaven Spree
    5708, -- Contract: Kvatch
  },
  [5711] = { -- Contract: The Rift Spree
    5708, -- Contract: Kvatch
  },
  [5713] = { -- Sacrament: Trader's Cove
    5595, -- A Lesson in Silence
  },
  [5714] = { -- Sacrament: Trader's Cove
    5595, -- A Lesson in Silence
  },
  [5718] = { -- Sacrament: Smuggler's Den
    5595, -- A Lesson in Silence
  },
  [5719] = { -- Sacrament: Smuggler's Den
    5595, -- A Lesson in Silence
  },
  [5720] = { -- Sacrament: Smuggler's Den
    5595, -- A Lesson in Silence
  },
  [5724] = { -- Sacrament: Sewer Tenement
    5595, -- A Lesson in Silence
  },
  [5725] = { -- Sacrament: Sewer Tenement
    5595, -- A Lesson in Silence
  },
  [5726] = { -- Sacrament: Sewer Tenement
    5595, -- A Lesson in Silence
  },
  [5746] = { -- The Corrupted Stone
    5747, -- The Star-Gazers
  },
  [5748] = { -- The Warrior's Call
    5747, -- The Star-Gazers
  },
  [5757] = { -- Gem of the Stars
    5749, -- The Seeker's Archive
  },
  [5758] = { -- Strange Lexicon
    5749, -- The Seeker's Archive
  },
  [5759] = { -- Message Unknown
    5749, -- The Seeker's Archive
  },
  [5760] = { -- The Missing Guardian
    5747, -- The Star-Gazers
    5748, -- The Warrior's Call
    5761, -- Elemental Army
  },
  [5761] = { -- Elemental Army
    5747, -- The Star-Gazers
  },
  [5763] = { -- The Shattered and the Lost
    5747, -- The Star-Gazers
  },
  [5771] = { -- Dawn of the Exalted Viper
    5768, -- Slithering Brood
    5769, -- The Serpent's Fang
    5760, -- The Missing Guardian
  },
  [5774] = { -- A Leaf in the Wind
    5768, -- Slithering Brood
  },
  [5775] = { -- Holding Court
    5769, -- The Serpent's Fang
  },
  [5776] = { -- The Time-Lost Warrior
    5771, -- Dawn of the Exalted Viper
    5760, -- The Missing Guardian
  },
  [5811] = { -- Snow Bear Plunge
    6134, -- The New Life Festival
  },
  [5834] = { -- The Trial of Five-Clawed Guile
    6134, -- The New Life Festival
  },
  [5837] = { -- Lava Foot Stomp
    6134, -- The New Life Festival
  },
  [5838] = { -- Mud Ball Merriment
    6134, -- The New Life Festival
  },
  [5839] = { -- Signal Fire Sprint
    6134, -- The New Life Festival
  },
  [5841] = { -- At Any Cost
    5840, -- Reclaiming Vos
  },
  [5845] = { -- Castle Charm Challenge
    6134, -- The New Life Festival
  },
  [5852] = { -- War Orphan's Sojourn
    6134, -- The New Life Festival
  },
  [5855] = { -- Fish Boon Feast
    6134, -- The New Life Festival
  },
  [5856] = { -- Stonetooth Bash
    6134, -- The New Life Festival
  },
  [5859] = { -- Rising to Retainer
    5799, -- A Hireling of House Telvanni
  },
  [5880] = { -- Divine Inquiries
    5803, -- Divine Conundrum
  },
  [5883] = { -- Hatching a Plan
    5872, -- A Melodic Mistake
  },
  [5888] = { -- Divine Delusions
    5880, -- Divine Inquiries
  },
  [5893] = { -- Divine Intervention
    5888, -- Divine Delusions
  },
  [5901] = { -- Objections and Obstacles
    5859, -- Rising to Retainer
  },
  [5902] = { -- Divine Disaster
    5893, -- Divine Intervention
  },
  [5905] = { -- Divine Restoration
    5902, -- Divine Disaster
  },
  [5907] = { -- Great Zexxin Hunt
    6008, -- Ashlander Relations
  },
  [5908] = { -- Tarra-Suj Hunt
    6008, -- Ashlander Relations
  },
  [5909] = { -- Writhing Sveeth Hunt
    6008, -- Ashlander Relations
  },
  [5910] = { -- Mother Jagged-Claw Hunt
    6008, -- Ashlander Relations
  },
  [5911] = { -- Ash-Eater Hunt
    6008, -- Ashlander Relations
  },
  [5912] = { -- Old Stomper Hunt
    6008, -- Ashlander Relations
  },
  [5913] = { -- King Razor-Tusk Hunt
    6008, -- Ashlander Relations
  },
  [5914] = { -- The Magister Makes a Move
    5901, -- Objections and Obstacles
  },
  [5919] = { -- Of Faith and Family
    5887, -- Fleeing the Past
  },
  [5921] = { -- Springtime Flair
    5941, -- The Jester's Festival
  },
  [5922] = { -- The Heart of a Telvanni
    5914, -- The Magister Makes a Move
  },
  [5924] = { -- Relics of Yasammidan
    6008, -- Ashlander Relations
  },
  [5925] = { -- Relics of Assarnatamat
    6008, -- Ashlander Relations
  },
  [5926] = { -- Relics of Maelkashishi
    6008, -- Ashlander Relations
  },
  [5927] = { -- Relics of Ashurnabitashpi
    6008, -- Ashlander Relations
  },
  [5928] = { -- Relics of Ebernanit
    6008, -- Ashlander Relations
  },
  [5929] = { -- Relics of Dushariran
    6008, -- Ashlander Relations
  },
  [5930] = { -- Relics of Ashalmawia
    6008, -- Ashlander Relations
  },
  [5931] = { -- A Noble Guest
    5941, -- The Jester's Festival
  },
  [5933] = { -- A Purposeful Writ
    5919, -- Of Faith and Family
  },
  [5937] = { -- Royal Revelry
    5941, -- The Jester's Festival
  },
  [5948] = { -- Family Reunion
    5933, -- A Purposeful Writ
  },
  [5952] = { -- To the Victor
    5949, -- For Glory
  },
  [5953] = { -- Let the Games Begin
    5949, -- For Glory
  },
  [5954] = { -- Test of Mettle
    5949, -- For Glory
  },
  [6003] = { -- Divine Blessings
    5905, -- Divine Restoration
  },
  [6004] = { -- A Late Delivery
    5803, -- Divine Conundrum
  },
  [6008] = { -- Ashlander Relations
    5885, -- Ancestral Ties
  },
  [6010] = { -- Kill Enemy Wardens
    4706, -- Reporting for Duty
  },
  [6011] = { -- Kill Enemy Wardens
    4724, -- Reporting for Duty
  },
  [6012] = { -- Kill Enemy Wardens
    4727, -- Reporting for Duty
  },
  [6024] = { -- Glitter and Gleam
    6052, -- Lost in the Gloam
  },
  [6025] = { -- Deepening Shadows
    6063, -- The Strangeness of Seht
  },
  [6046] = { -- Unto the Dark
    6052, -- Lost in the Gloam
  },
  [6047] = { -- Where Shadows Lie
    6046, -- Unto the Dark
  },
  [6048] = { -- The Light of Knowledge
    6047, -- Where Shadows Lie
  },
  [6052] = { -- Lost in the Gloam
    6025, -- Deepening Shadows
  },
  [6057] = { -- In Search of a Sponsor
    6050, -- To The Clockwork City
  },
  [6060] = { -- Tasty Tongue Varnish
    6059, -- Tarnished Truffles
  },
  [6061] = { -- A Matter of Tenderness
    6060, -- Tasty Tongue Varnish
  },
  [6063] = { -- The Strangeness of Seht
    6057, -- In Search of a Sponsor
  },
  [6070] = { -- Nibbles and Bits
    6052, -- Lost in the Gloam
  },
  [6071] = { -- Morsels and Pecks
    6052, -- Lost in the Gloam
  },
  [6072] = { -- A Matter of Respect
    6052, -- Lost in the Gloam
  },
  [6073] = { -- A Shadow Misplaced
    6049, -- The Shadow Cleft
  },
  [6075] = { -- The Oscillating Son
    6066, -- The Precursor
  },
  [6078] = { -- Family Feud
    6063, -- The Strangeness of Seht
  },
  [6079] = { -- Again Into the Shadows
    6049, -- The Shadow Cleft
  },
  [6080] = { -- A Shadow Malfunction
    6049, -- The Shadow Cleft
  },
  [6081] = { -- Oiling the Fans
    6058, -- The Halls of Regulation
  },
  [6088] = { -- Changing the Filters
    6058, -- The Halls of Regulation
  },
  [6089] = { -- Replacing the Commutators
    6058, -- The Halls of Regulation
  },
  [6092] = { -- The Merchant's Heirloom
    6050, -- To The Clockwork City
  },
  [6098] = { -- Alchemist Writ
    5315, -- Alchemist Certification
  },
  [6099] = { -- Alchemist Writ
    5315, -- Alchemist Certification
  },
  [6100] = { -- Alchemist Writ
    5315, -- Alchemist Certification
  },
  [6101] = { -- Alchemist Writ
    5315, -- Alchemist Certification
  },
  [6102] = { -- Alchemist Writ
    5315, -- Alchemist Certification
  },
  [6103] = { -- Alchemist Writ
    5315, -- Alchemist Certification
  },
  [6104] = { -- Alchemist Writ
    5315, -- Alchemist Certification
  },
  [6105] = { -- Alchemist Writ
    5315, -- Alchemist Certification
  },
  [6106] = { -- A Matter of Tributes
    6052, -- Lost in the Gloam
  },
  [6107] = { -- A Matter of Leisure
    6052, -- Lost in the Gloam
  },
  [6109] = { -- The Dreaming Cave
    6142, -- The Tower Sentinels
  },
  [6110] = { -- Glitter and Gleam
    6052, -- Lost in the Gloam
  },
  [6112] = { -- A Pearl of Great Price
    6096, -- The Queen's Decree
  },
  [6113] = { -- Lost in Translation
    6109, -- The Dreaming Cave
  },
  [6125] = { -- A Necessary Alliance
    6113, -- Lost in Translation
  },
  [6126] = { -- The Crystal Tower
    6125, -- A Necessary Alliance
  },
  [6132] = { -- Buried Memories
    6112, -- A Pearl of Great Price
  },
  [6140] = { -- Bantering with Bandits
    6139, -- The Hulkynd's Heart
  },
  [6142] = { -- The Tower Sentinels
    6132, -- Buried Memories
    6112, -- A Pearl of Great Price
    6096, -- The Queen's Decree
  },
  [6153] = { -- A New Alliance
    6126, -- The Crystal Tower
  },
  [6165] = { -- The Abyssal Cabal
    6132, -- Buried Memories
  },
  [6166] = { -- Sinking Summerset
    6165, -- The Abyssal Cabal
  },
  [6172] = { -- The Psijics' Calling
    6096, -- The Queen's Decree
  },
  [6181] = { -- Breaches On the Bay
    6172, -- The Psijics' Calling
  },
  [6185] = { -- Breaches of Frost and Fire
    6181, -- Breaches On the Bay
  },
  [6190] = { -- A Time for Mud and Mushrooms
    6194, -- A Breach Amid the Trees
  },
  [6194] = { -- A Breach Amid the Trees
    6197, -- The Shattered Staff
  },
  [6195] = { -- Time in Doomcrag's Shadow
    6198, -- The Towers' Remains
  },
  [6196] = { -- A Breach Beyond the Crags
    6195, -- Time in Doomcrag's Shadow
  },
  [6197] = { -- The Shattered Staff
    6185, -- Breaches of Frost and Fire
  },
  [6198] = { -- The Towers' Remains
    6190, -- A Time for Mud and Mushrooms
  },
  [6199] = { -- The Towers' Fall
    6196, -- A Breach Beyond the Crags
  },
  [6202] = { -- Sinking Summerset
    6165, -- The Abyssal Cabal
  },
  [6203] = { -- High Rock Gate Crashing
    4724, -- Reporting for Duty
  },
  [6206] = { -- Elsweyr Gate Crasher
    4724, -- Reporting for Duty
  },
  [6207] = { -- Capture All 3 Towns
    4724, -- Reporting for Duty
  },
  [6208] = { -- Capture Any Nine Resources
    4724, -- Reporting for Duty
  },
  [6209] = { -- Kill 40 Enemy Players
    4724, -- Reporting for Duty
  },
  [6210] = { -- Capture Any Three Keeps
    4706, -- Reporting for Duty
  },
  [6211] = { -- Capture Any Nine Resources
    4706, -- Reporting for Duty
  },
  [6212] = { -- Capture All 3 Towns
    4706, -- Reporting for Duty
  },
  [6213] = { -- Kill 40 Enemy Players
    4706, -- Reporting for Duty
  },
  [6214] = { -- Capture Any Three Keeps
    4727, -- Reporting for Duty
  },
  [6215] = { -- Capture Any Nine Resources
    4727, -- Reporting for Duty
  },
  [6216] = { -- Capture All 3 Towns
    4727, -- Reporting for Duty
  },
  [6217] = { -- Kill 40 Enemy Players
    4727, -- Reporting for Duty
  },
  [6218] = { -- Jewelry Crafting Writ
    6171, -- Jewelry Crafting Certification
  },
  [6219] = { -- High Rock Gate Crashing
    4706, -- Reporting for Duty
  },
  [6220] = { -- Elsweyr Gate Crasher
    4727, -- Reporting for Duty
  },
  [6221] = { -- Morrowind Gate Crashing
    4727, -- Reporting for Duty
  },
  [6222] = { -- Morrowind Gate Crasher
    4706, -- Reporting for Duty
  },
  [6223] = { -- Morrowind Gate Reclaimation
    4724, -- Reporting for Duty
  },
  [6224] = { -- High Rock Gate Reclaimation
    4727, -- Reporting for Duty
  },
  [6225] = { -- Elsweyr Gate Reclaimation
    4706, -- Reporting for Duty
  },
  [6227] = { -- Jewelry Crafting Writ
    6171, -- Jewelry Crafting Certification
  },
  [6228] = { -- Jewelry Crafting Writ
    6171, -- Jewelry Crafting Certification
  },
  [6241] = { -- Whispers in the Wood
    6266, -- Missing in Murkmire
  },
  [6242] = { -- The Cursed Skull
    6226, -- Ruthless Competition
  },
  [6243] = { -- The Swamp and the Serpent
    6259, -- Death and Dreaming
  },
  [6244] = { -- The Remnant of Argon
    6243, -- The Swamp and the Serpent
  },
  [6245] = { -- By River and Root
    6244, -- The Remnant of Argon
  },
  [6256] = { -- Reeling in Recruits
    6242, -- The Cursed Skull
  },
  [6257] = { -- Bug Off!
    6226, -- Ruthless Competition
    6242, -- The Cursed Skull
  },
  [6259] = { -- Death and Dreaming
    6241, -- Whispers in the Wood
  },
  [6263] = { -- A Taste for Toxins
    6226, -- Ruthless Competition
    6242, -- The Cursed Skull
  },
  [6265] = { -- The Sounds of Home
    6246, -- Sunken Treasure
  },
  [6266] = { -- Missing in Murkmire
    6246, -- Sunken Treasure
  },
  [6271] = { -- Ritual of Change
    6270, -- Monument of Change
  },
  [6279] = { -- The Skin Taker
    6266, -- Missing in Murkmire
    6241, -- Whispers in the Wood
  },
  [6281] = { -- Swamp Jelly Sonata
    6245, -- By River and Root
  },
  [6287] = { -- Mushrooms That Nourish
    6245, -- By River and Root
  },
  [6288] = { -- Envoys Who Cower
    6245, -- By River and Root
  },
  [6289] = { -- Offerings That Hide
    6245, -- By River and Root
  },
  [6290] = { -- Leather That Protects
    6245, -- By River and Root
  },
  [6293] = { -- Unsuitable Suitors
    6258, -- Empty Nest
  },
  [6296] = { -- The Battle for Riverhold
    6338, -- The Usurper Queen
  },
  [6297] = { -- The Final Order
    6304, -- Two Queens
  },
  [6304] = { -- Two Queens
    6296, -- The Battle for Riverhold
  },
  [6305] = { -- Cadwell the Betrayer
    6297, -- The Final Order
  },
  [6306] = { -- The Halls of Colossus
    6299, -- The Demon Weapon
  },
  [6315] = { -- Jode's Core
    6305, -- Cadwell the Betrayer
  },
  [6318] = { -- Dark Souls, Mighty Weapons
    6306, -- The Halls of Colossus
  },
  [6320] = { -- The Singing Crystal
    6319, -- The Song of Kingdoms
  },
  [6322] = { -- Path of the Hidden Moon
    6321, -- The Witch of Azurah
  },
  [6323] = { -- The Moonlight Blade
    6322, -- Path of the Hidden Moon
  },
  [6328] = { -- The Heir of Anequina
    6315, -- Jode's Core
  },
  [6329] = { -- Spider Demonstration
    6306, -- The Halls of Colossus
  },
  [6338] = { -- The Usurper Queen
    6336, -- A Rage of Dragons
  },
  [6341] = { -- Skeleton Demonstration
    6306, -- The Halls of Colossus
  },
  [6342] = { -- Goblin Demonstration
    6306, -- The Halls of Colossus
  },
  [6343] = { -- Lurcher Demonstration
    6306, -- The Halls of Colossus
  },
  [6344] = { -- Lamia Demonstration
    6306, -- The Halls of Colossus
  },
  [6345] = { -- Dragon Lore: Stormcrag Crypt
    6306, -- The Halls of Colossus
  },
  [6346] = { -- Dragon Lore: Icehammer's Vault
    6306, -- The Halls of Colossus
  },
  [6347] = { -- Dragon Lore: Shroud Hearth
    6306, -- The Halls of Colossus
  },
  [6365] = { -- The Jewel of Baan Dar
    6338, -- The Usurper Queen
  },
  [6390] = { -- Kill Enemy Necromancers
    4727, -- Reporting for Duty
  },
  [6391] = { -- Kill Enemy Necromancers
    4724, -- Reporting for Duty
  },
  [6392] = { -- Kill Enemy Necromancers
    4706, -- Reporting for Duty
  },
  [6393] = { -- The Dark Aeon
    6404, -- The Dragonguard
    6328, -- The Heir of Anequina
    6401, -- The Dragon's Lair
    6394, -- Uneasy Alliances
    6399, -- Order of the New Moon
    6403, -- The Pride of Alkosh
    6409, -- Reformation
  },
  [6394] = { -- Uneasy Alliances
    6409, -- Reformation
  },
  [6397] = { -- New Moon Rising
    6393, -- The Dark Aeon
    6401, -- The Dragon's Lair
    6394, -- Uneasy Alliances
    6399, -- Order of the New Moon
    6403, -- The Pride of Alkosh
    6404, -- The Dragonguard
    6409, -- Reformation
  },
  [6398] = { -- The Horn of Ja'darri
    6395, -- The Dragonguard's Legacy
  },
  [6399] = { -- Order of the New Moon
    6394, -- Uneasy Alliances
  },
  [6402] = { -- The Pride of Elsweyr
    6397, -- New Moon Rising
    6401, -- The Dragon's Lair
    6394, -- Uneasy Alliances
    6399, -- Order of the New Moon
    6403, -- The Pride of Alkosh
    6404, -- The Dragonguard
    6409, -- Reformation
  },
  [6403] = { -- The Pride of Alkosh
    6399, -- Order of the New Moon
    6401, -- The Dragon's Lair
    6409, -- Reformation
    6394, -- Uneasy Alliances
  },
  [6404] = { -- The Dragonguard
    6403, -- The Pride of Alkosh
  },
  [6405] = { -- Taking Them to Tusk
    6409, -- Reformation
  },
  [6406] = { -- A Lonely Grave
    6409, -- Reformation
  },
  [6409] = { -- Reformation
    6401, -- The Dragon's Lair
  },
  [6428] = { -- Sticks and Bones
    6409, -- Reformation
  },
  [6429] = { -- Digging Up the Garden
    6409, -- Reformation
  },
  [6430] = { -- File Under D
    6409, -- Reformation
  },
  [6433] = { -- Rude Awakening
    6409, -- Reformation
  },
  [6434] = { -- The Dragonguard's Quarry
    6409, -- Reformation
  },
  [6435] = { -- The Dragonguard's Quarry
    6409, -- Reformation
  },
  [6453] = { -- The Good Bits
    6401, -- The Dragon's Lair
    6409, -- Reformation
  },
  [6456] = { -- The Gray Host
    6466, -- The Vampire Scholar
    6462, -- Danger in the Holds
    6476, -- Dark Clouds Over Solitude
    6467, -- The Gathering Storm
  },
  [6462] = { -- Danger in the Holds
    6476, -- Dark Clouds Over Solitude
  },
  [6463] = { -- The Coven Conundrum
    6454, -- The Coven Conspiracy
  },
  [6464] = { -- Greymoor Rising
    6456, -- The Gray Host
  },
  [6466] = { -- The Vampire Scholar
    6462, -- Danger in the Holds
    6476, -- Dark Clouds Over Solitude
    6467, -- The Gathering Storm
  },
  [6476] = { -- Dark Clouds Over Solitude
    6467, -- The Gathering Storm
  },
  [6481] = { -- Daughter of the Wolf
    6464, -- Greymoor Rising
  },
  [6482] = { -- A Salskap to Remember
    6469, -- Orchestrations
  },
  [6515] = { -- The Antiquarian's Art
    6514, -- The Antiquarian Circle
  },
  [6547] = { -- The Study of Souls
    6551, -- Blood of the Reach
  },
  [6548] = { -- The Awakening Darkness
    6547, -- The Study of Souls
  },
  [6551] = { -- Blood of the Reach
    6550, -- The Despot of Markarth
  },
  [6552] = { -- The End of Eternity
    6481, -- Daughter of the Wolf
    6566, -- A Feast of Souls
  },
  [6554] = { -- The Dark Heart
    6547, -- The Study of Souls
    6548, -- The Awakening Darkness
  },
  [6555] = { -- The Gray Council
    6549, -- The Ravenwatch Inquiry
  },
  [6560] = { -- Kingdom of Ash
    6552, -- The End of Eternity
  },
  [6566] = { -- A Feast of Souls
    6554, -- The Dark Heart
  },
  [6570] = { -- Second Chances
    6560, -- Kingdom of Ash
  },
  [6589] = { -- Red Eagle's Song
    6566, -- A Feast of Souls
    6481, -- Daughter of the Wolf
  },
  [6609] = { -- The Symbol of Uricanbeg
    6599, -- The Symbol of Storihbeg
    6598, -- The Symbol of Gulibeg
    6596, -- The Symbol of Hrokkibeg
  },
  [6614] = { -- Pyre of Ambition
    6617, -- Weapons of Destruction
  },
  [6616] = { -- An Unexpected Adversary
    6615, -- A Deadly Secret
  },
  [6617] = { -- Weapons of Destruction
    6619, -- A Mysterious Event
  },
  [6619] = { -- A Mysterious Event
    6630, -- A Hidden Vault
  },
  [6627] = { -- The Emperor's Secret
    6612, -- A Mortal's Touch
  },
  [6630] = { -- A Hidden Vault
    6616, -- An Unexpected Adversary
  },
  [6660] = { -- Heroes of Blackwood
    6614, -- Pyre of Ambition
  },
  [6662] = { -- Things Lost, Things Found
    6626, -- Competition and Contracts
  },
  [6664] = { -- Family Secrets
    6662, -- Things Lost, Things Found
  },
  [6666] = { -- A Mother's Obsession
    6648, -- Shattered and Scattered
  },
  [6667] = { -- Dead Weight
    6666, -- A Mother's Obsession
  },
  [6672] = { -- Love Among the Fire
    6619, -- A Mysterious Event
  },
  [6693] = { -- Hope Springs Eternal
    6697, -- Ambition's End
  },
  [6696] = { -- The Last Ambition
    6700, -- Against All Hope
    6660, -- Heroes of Blackwood
  },
  [6697] = { -- Ambition's End
    6696, -- The Last Ambition
  },
  [6699] = { -- Deadlight
    6708, -- Born of Grief
  },
  [6700] = { -- Against All Hope
    6699, -- Deadlight
  },
  [6703] = { -- The Key and the Cataclyst
    6701, -- An Apocalyptic Situation
  },
  [6707] = { -- The Durance Vile
    6724, -- Destruction Incarnate
    6723, -- The Celestial Palanquin
  },
  [6708] = { -- Born of Grief
    6707, -- The Durance Vile
    6724, -- Destruction Incarnate
    6723, -- The Celestial Palanquin
  },
  [6724] = { -- Destruction Incarnate
    6723, -- The Celestial Palanquin
  },
  [6732] = { -- Uxark's Treasure
    6728, -- A Gem of a Mystery
    6730, -- Courier's Folly
    6731, -- Robhir's Final Delivery
  },
  [6750] = { -- Honest Toil
    6749, -- The Unrefusable Offer
  },
  [6753] = { -- People of Import
    6752, -- Of Knights and Knaves
  },
  [6754] = { -- Deadly Investigations
    6753, -- People of Import
  },
  [6761] = { -- A King's Retreat
    6751, -- Ascending Doubt
  },
  [6764] = { -- Escape from Amenos
    6754, -- Deadly Investigations
  },
  [6765] = { -- To Catch a Magus
    6764, -- Escape from Amenos
  },
  [6766] = { -- The Ascendant Storm
    6765, -- To Catch a Magus
  },
  [6781] = { -- A Chance for Peace
    6766, -- The Ascendant Storm
  },
  [6785] = { -- Cold Trail
    6771, -- Tower Full of Trouble
  },
  [6786] = { -- Cold Blood, Old Pain
    6771, -- Tower Full of Trouble
    6785, -- Cold Trail
  },
  [6787] = { -- Green with Envy
    6771, -- Tower Full of Trouble
    6786, -- Cold Blood, Old Pain
    6785, -- Cold Trail
  },
  [6789] = { -- The Lost Symbol
    6760, -- Tournament of the Heart
  },
  [6790] = { -- A Mother's Request
    6760, -- Tournament of the Heart
    6789, -- The Lost Symbol
  },
  [6791] = { -- The Princess Detective
    6760, -- Tournament of the Heart
    6789, -- The Lost Symbol
    6790, -- A Mother's Request
  },
  [6795] = { -- The Long Way Home
    6792, -- Balki's Map Fragment
    6793, -- Ferone's Map Fragment
    6794, -- Rhadh's Map Fragment
  },
  [6800] = { -- Cards Across the Continent
    6804, -- A New Venture
  },
  [6801] = { -- Dueling Tributes
    6804, -- A New Venture
  },
  [6804] = { -- A New Venture
    6799, -- Tales of Tribute
  },
  [6806] = { -- The Tournament Begins
    6804, -- A New Venture
  },
  [6824] = { -- Challenges of the Past
    6806, -- The Tournament Begins
  },
  [6829] = { -- The Final Round
    6824, -- Challenges of the Past
  },
  [6831] = { -- Cards Across the Continent
    6804, -- A New Venture
  },
  [6832] = { -- Dueling Tributes
    6804, -- A New Venture
  },
  [6847] = { -- The Hidden Lord
    6853, -- Guardian of Y'ffelon
    6766, -- The Ascendant Storm
  },
  [6848] = { -- The Ivy Throne
    6847, -- The Hidden Lord
  },
  [6850] = { -- Tides of Ruin
    6849, -- A Sea of Troubles
  },
  [6852] = { -- The Dream of Kasorayn
    6859, -- City Under Siege
  },
  [6853] = { -- Guardian of Y'ffelon
    6852, -- The Dream of Kasorayn
  },
  [6855] = { -- Seeds of Destruction
    6850, -- Tides of Ruin
  },
  [6859] = { -- The Siege of Vastyr
    6855, -- Seeds of Destruction
  },
  [6894] = { -- And Now, Perhaps, Peace
    6848, -- The Ivy Throne
  },
  [6975] = { -- A Hidden Fate
    6971, -- Fate's Proxy
  },
  [6976] = { -- Conclave of Fate
    6975, -- A Hidden Fate
  },
  [6977] = { -- Chronicle of Fate
    6991, -- An Unhealthy Fate
  },
  [6991] = { -- An Unhealthy Fate
    7025, -- A Calamity of Fate
  },
  [7018] = { -- Between a Rock and a Whetstone
    7017, -- The Double Edge
  },
  [7019] = { -- Dim and Distant Pasts
    7017, -- The Double Edge
    7018, -- Between a Rock and a Whetstone
  },
  [7020] = { -- Light the Way to Freedom
    7019, -- Dim and Distant Pasts
    7018, -- Between a Rock and a Whetstone
    7017, -- The Double Edge
  },
  [7022] = { -- Paths Unwalked
    7021, -- The Fateweaver Key
  },
  [7023] = { -- Adversarial Adventures
    7022, -- Paths Unwalked
    7021, -- The Fateweaver Key
  },
  [7024] = { -- Tempting Fates
    7023, -- Adversarial Adventures
    7022, -- Paths Unwalked
    7021, -- The Fateweaver Key
  },
  [7025] = { -- A Calamity of Fate
    6976, -- Conclave of Fate
  },
  [7051] = { -- Akacirn the Deathless
    7048, -- Numinous Grimoire, Volume 1
    7049, -- Numinous Grimoire, Volume 2
    7050, -- Numinous Grimoire, Volume 3
  },
  -- [7066] = { -- Kill Enemy Arcanists 4706, -- Reporting for Duty },
  -- [7067] = { -- Kill Enemy Arcanists 4727, -- Reporting for Duty },
  -- [7068] = { -- Kill Enemy Arcanists 4724, -- Reporting for Duty },
}

local breadcrumb_table = {
  [701] = { -- Queen's Emissary - Isque
    702, -- Queen's Emissary - Orrery
    703, -- Queen's Emissary - Dusk
  },
  [702] = { -- Queen's Emissary - Orrery
    701, -- Queen's Emissary - Isque
    703, -- Queen's Emissary - Dusk
  },
  [703] = { -- Queen's Emissary - Dusk
    701, -- Queen's Emissary - Isque
    702, -- Queen's Emissary - Orrery
  },
  [1735] = { -- Unanswered Questions
    1536, -- Fire in the Fields
  },
  [2193] = { -- The Scholar of Bergama
    2251, -- Gone Missing
    2222, -- Alasan's Plot
  },
  [2240] = { -- Shiri's Research
    2997, -- Amputating the Hand
  },
  [2403] = { -- The Search for Shiri
    2997, -- Amputating the Hand
  },
  [3026] = { -- The Wyrd Sisters
    3060, -- Seeking the Guardians
  },
  [3183] = { -- To the Wyrd Tree
    3191, -- Reclaiming the Elements
  },
  [3184] = { -- The Glenumbra Moors
    3027, -- Ripple Effect
  },
  [3281] = { -- Leading the Stand
    4899, -- Beyond the Call
  },
  [3283] = { -- Werewolves to the North
    974, -- A Duke in Exile
  },
  [3330] = { -- Retaking Camlorn
    3064, -- Rally Cry
  },
  [3345] = { -- The End of Extortion
    3302, -- The Miners' Lament
  },
  [3530] = { -- Destroying the Dark Witnesses
    1834, -- Heart of Evil
  },
  [3566] = { -- Kingdom in Mourning
    1799, -- A City in Black
  },
  [3589] = { -- Quiet the Ringing Bell
    3734, -- Restoring the Guardians
  },
  [3618] = { -- To Ash Mountain
    3734, -- Restoring the Guardians
  },
  [3635] = { -- City at the Spire
    3642, -- The Curse of Heimlyn Keep
  },
  [3698] = { -- To the Tormented Spire
    3826, -- Climbing the Spire
  },
  [3732] = { -- Overrun
    3799, -- Scales of Retribution
  },
  [3802] = { -- What Happened at Murkwater
    3678, -- Trials of the Burnished Scales
  },
  [3815] = { -- Cracking the Egg
    4606, -- Keepers of the Shell
  },
  [3855] = { -- Mystery of Othrenis
    3615, -- Wake the Dead
  },
  [3955] = { -- Tracking the Plague
    3673, -- Death Trap
  },
  [3956] = { -- Message to Mournhold
    4453, -- A Favor Returned
  },
  [3958] = { -- The Llodos Plague
    3659, -- Unwanted Guests
  },
  [3966] = { -- Chasing the Magistrix
    3820, -- Restless Spirits
    3831, -- The Judgment of Veloth
  },
  [3981] = { -- To Taarengrav
    4147, -- The Shackled Guardian
  },
  [3982] = { -- Bound to the Bog
    3840, -- Saving the Relics
  },
  [3990] = { -- A Beginning at Bleakrock
    3992, -- What Waits Beneath
    3995, -- The Frozen Man
    3987, -- Hozzin's Folly
    4016, -- The Missing of Bleakrock
  },
  [4026] = { -- Zeren in Peril
    4028, -- Breaking the Tide
  },
  [4028] = { -- Breaking the Tide
    4026, -- Zeren in Peril
  },
  [4051] = { -- Warning Davon's Watch
    3585, -- Legacy of the Ancestors
  },
  [4087] = { -- Sneak Peak
    4116, -- Snow and Flame
    4117, -- Songs of Sovngarde
  },
  [4163] = { -- Onward to Shadowfen
    3686, -- Three Tender Souls
  },
  [4169] = { -- Of Councils and Kings
    4069, -- Making Amends
  },
  [4177] = { -- Victory at Morvunskar
    4166, -- The War Council
  },
  [4184] = { -- To Pinepeak Caverns
    3978, -- Tomb Beneath the Mountain
  },
  [4197] = { -- Sounds of Alarm
    4062, -- Blindsided
  },
  [4210] = { -- Real Marines
    4209, -- Teldur's End
  },
  [4211] = { -- To Tanzelwil
    4217, -- In the Name of the Queen
  },
  [4273] = { -- To the King
    4186, -- Securing the Pass
  },
  [4357] = { -- To Firsthold
    4260, -- Breaking the Barrier
  },
  [4365] = { -- To Dawnbreak
    4355, -- Through the Ashes
  },
  [4366] = { -- To Mathiisen
    4293, -- Putting the Pieces Together
  },
  [4443] = { -- To Alcaire Castle
    2552, -- Army at the Gates
  },
  [4466] = { -- The Broken Spearhead
    4510, -- The Spearhead's Captain
    4344, -- Like Moths to a Candle
    4454, -- Innocent Scoundrel
    4431, -- Buried Secrets
  },
  [4510] = { -- The Spearhead's Captain
    4466, -- The Broken Spearhead
  },
  [4514] = { -- The Spearhead's Crew
    4510, -- The Spearhead's Captain
  },
  [4549] = { -- Back to Skywatch
    4330, -- Lifting the Veil
  },
  [4558] = { -- Taking the Fight to the Enemy
    3082, -- The Lion Guard's Stand
  },
  [4646] = { -- The Mnemic Egg
    3909, -- The Dominion's Alchemist
  },
  [4656] = { -- Tharayya's Trail
    4432, -- Blood and Sand
  },
  [4657] = { -- The Spinner's Tale
    4586, -- The Witch of Silatar
  },
  [4689] = { -- A Door Into Moonlight
    4689, -- A Door Into Moonlight
  },
  [4694] = { -- Word from the Throne
    2146, -- The Impervious Vault
  },
  [4697] = { -- To Rawl'kha
    4479, -- Motes in the Moonlight
    4759, -- Hallowed to Rawl'kha
    4712, -- The First Step
  },
  [4709] = { -- The Path to Moonmont
    4802, -- To Moonmont
  },
  [4710] = { -- Hallowed To Arenthia
    4652, -- The Colovian Occupation
    4653, -- Stonefire Machinations
  },
  [4711] = { -- To Dune
    4550, -- The Fires of Dune
  },
  [4744] = { -- Before the Storm
    4739, -- A Storm Upon the Shore
  },
  [4759] = { -- Hallowed to Rawl'kha
    4697, -- To Rawl'kha
    4712, -- The First Step
  },
  [4761] = { -- Trouble at Tava's Blessing
    2222, -- Alasan's Plot
  },
  [4767] = { -- One of the Undaunted
    4967, -- One of the Undaunted
    4997, -- One of the Undaunted
  },
  [4790] = { -- Breaking the Ward
    4546, -- Retaking the Pass
    4601, -- Right of Theft
    4608, -- The Blight of the Bosmer
  },
  [4798] = { -- Eye on Arenthia
    4652, -- The Colovian Occupation
  },
  [4799] = { -- To Saifa in Rawl'kha
    4712, -- The First Step
  },
  [4802] = { -- To Moonmont
    4479, -- Motes in the Moonlight
  },
  [4809] = { -- Nirnroot Wine
    4810, -- Nirnroot Wine
    4811, -- Nirnroot Wine
  },
  [4810] = { -- Nirnroot Wine
    4809, -- Nirnroot Wine
    4811, -- Nirnroot Wine
  },
  [4811] = { -- Nirnroot Wine
    4809, -- Nirnroot Wine
    4810, -- Nirnroot Wine
  },
  [4817] = { -- Tracking the Hand
    2222, -- Alasan's Plot
  },
  [4818] = { -- To Auridon
    4255, -- Ensuring Security
  },
  [4821] = { -- Report to Marbruk
    4690, -- Striking at the Heart
  },
  [4850] = { -- Shades of Green
    4690, -- Striking at the Heart
  },
  [4853] = { -- Woodhearth
    4574, -- Veil of Illusion
  },
  [4901] = { -- The Road to Rivenspire
    4902, -- Shornhelm Divided
  },
  [4949] = { -- Favor for the Queen
    3333, -- Risen From the Depths
    2130, -- Rise of the Dead
  },
  [4951] = { -- Fit to Rule
    4922, -- The Orrery of Elden Root
  },
  [4967] = { -- One of the Undaunted
    4767, -- One of the Undaunted
    4997, -- One of the Undaunted
  },
  [4974] = { -- Brackenleaf's Briars
    4833, -- Bosmer Insight
  },
  [4978] = { -- Striking Back
    4959, -- Trials and Tribulations
    4960, -- To Walk on Far Shores
  },
  [4988] = { -- Rendezvous at the Pass
    4912, -- Storming the Garrison
  },
  [4991] = { -- Dark Wings
    3280, -- Imperial Infiltration
  },
  [4992] = { -- Searching for the Searchers
    1834, -- Heart of Evil
  },
  [4993] = { -- Report to Evermore
    4891, -- The Parley
  },
  [4994] = { -- Imperial Curiosity
    4912, -- Storming the Garrison
  },
  [4997] = { -- One of the Undaunted
    4767, -- One of the Undaunted
    4967, -- One of the Undaunted
  },
  [5006] = { -- To Velyn Harbor
    4193, -- House and Home
  },
  [5009] = { -- The Siege of Velyn Harbor
    4193, -- House and Home
    4194, -- One Fell Swoop
  },
  [5013] = { -- Hushed Whispers
    3687, -- Getting to the Truth
    3686, -- Three Tender Souls
  },
  [5015] = { -- Eyes of the Enemy
    4587, -- Trail of the Skin-Stealer
  },
  [5016] = { -- Children of the Hist
    4606, -- Keepers of the Shell
  },
  [5034] = { -- A Grave Situation
    4147, -- The Shackled Guardian
    4139, -- Shattered Hopes
  },
  [5035] = { -- Calling Hakra
    3978, -- Tomb Beneath the Mountain
    4139, -- Shattered Hopes
  },
  [5040] = { -- Taking Precautions
    3634, -- The General's Demise
  },
  [5041] = { -- To Aid Davon's Watch
    3585, -- Legacy of the Ancestors
    5042, -- Assisting Davon's Watch
  },
  [5042] = { -- Assisting Davon's Watch
    3585, -- Legacy of the Ancestors
    5041, -- To Aid Davon's Watch
  },
  [5043] = { -- A Higher Priority
    3584, -- The Coral Heart
  },
  [5044] = { -- To the Mountain
    3735, -- The Death of Balreth
  },
  [5050] = { -- Waiting for Word
    1639, -- Another Omen
  },
  [5052] = { -- An Offering to Azura
    1541, -- A Prison of Sleep
  },
  [5053] = { -- The Lost Patrol
    3082, -- The Lion Guard's Stand
  },
  [5055] = { -- Missive to the Queen
    4256, -- A Hostile Situation
    5058, -- All the Fuss
  },
  [5058] = { -- All the Fuss
    4256, -- A Hostile Situation
    5055, -- Missive to the Queen
  },
  [5071] = { -- Curinure's Invitation
    3997, -- The Mad God's Bargain
    3953, -- Chateau of the Ravenous Rodent
    3916, -- Long Lost Lore
    4435, -- Simply Misplaced
    3918, -- Circus of Cheerful Slaughter
  },
  [5072] = { -- Aid for Bramblebreach
    4593, -- Audience with the Wilderking
  },
  [5073] = { -- Aicessar's Invitation
    3973, -- Will of the Council
    3898, -- Proving the Deed
    3885, -- The Prismatic Core
    3858, -- The Dangerous Past
    3856, -- Anchors from the Harbour
  },
  [5074] = { -- Rudrasa's Invitation
    5071, -- Curinure's Invitation
  },
  [5076] = { -- Nemarc's Invitation
    5071, -- Curinure's Invitation
  },
  [5091] = { -- Hallowed To Grimwatch
    4461, -- Grimmer Still
    4460, -- Grim Situation
  },
  [5092] = { -- The Champions at Rawl'kha
    4479, -- Motes in the Moonlight
  },
  [5093] = { -- Moons Over Grimwatch
    4460, -- Grim Situation
    5091, -- Hallowed To Grimwatch
  },
  [5103] = { -- Mournhold Market Misery
    3817, -- The Seal of Three
  },
  [5104] = { -- The Shards of Wuuthrad
    4139, -- Shattered Hopes
  },
  [5243] = { -- A Leaf in the Wind
    5203, -- The Serpent's Fang
  },
  [5245] = { -- Holding Court
    5194, -- Slithering Brood
  },
  [5487] = { -- City on the Brink
    5602, -- City on the Brink
    5493, -- City on the Brink
    5496, -- City on the Brink
  },
  [5493] = { -- City on the Brink
    5602, -- City on the Brink
    5487, -- City on the Brink
    5496, -- City on the Brink
  },
  [5496] = { -- City on the Brink
    5602, -- City on the Brink
    5487, -- City on the Brink
    5493, -- City on the Brink
  },
  [5506] = { -- Scouting the Memorial District
    5473, -- Of Brands and Bones
  },
  [5508] = { -- Scouting the Arboretum
    5490, -- Knowledge is Power
  },
  [5510] = { -- Scouting the Arena District
    5477, -- The Watcher in the Walls
  },
  [5511] = { -- Scouting the Elven Gardens
    5489, -- The Lock and the Legion
  },
  [5512] = { -- Scouting the Nobles District
    5483, -- The Imperial Standard
  },
  [5513] = { -- Scouting the Temple District
    5480, -- The Bleeding Temple
  },
  [5602] = { -- City on the Brink
    5496, -- City on the Brink
    5487, -- City on the Brink
    5493, -- City on the Brink
  },
  [5774] = { -- A Leaf in the Wind
    5769, -- The Serpent's Fang
  },
  [5775] = { -- Holding Court
    5768, -- Slithering Brood
  },
  [5920] = { -- Breaking Through the Fog
    5804, -- Broken Bonds
  },
}

--[[given: table
returns true/false
intent: if the breadcrumb quest is not marked as completed,
mark it completed because the main quest is complete

Take the questId and loop over quests. If completed then
the breadcrumb quest is no longer available.
]]--
function internal:show_breadcrumb_quest(questId)
  local showBreadcrumb = true
  if not breadcrumb_table[questId] then return showBreadcrumb end
  for _, value in pairs(breadcrumb_table[questId]) do
    if lib.completed_quests[value] then showBreadcrumb = false end
  end
  return showBreadcrumb
end

--[[given: table
returns true/false
intent: check if the quest requires other quests to be completed first
]]--
function internal:prerequisites_completed(questId)
  if not prerequisite_table[questId] then return true end
  for _, value in pairs(prerequisite_table[questId]) do
    if not lib.completed_quests[value] then return false end
  end
  return true
end

--[[given: table
returns true/false
intent: check if the quest requires a specific guild rank for the player to qualify for the quest
Summary: This is not needed since they are covered by prerequisite_table or breadcrumb_table

internal:check_guild_quest(questId)
]]--

--[[given: table
returns true/false
intent: check the players alliance for the specified quest

Alliance was not added until version 237
]]--
function internal:check_quest_alliance(quest)
end

--[[given: table
returns true/false
intent: check the players companion rapport against the questId
]]--
function internal:check_companion_rapport_requirements(questId)
  local rapportLevel = GetActiveCompanionRapportLevel()
  if questId == 6662 and rapportLevel >= 4 then return true end -- Things Lost, Things Found
  if questId == 6664 and rapportLevel >= 5 then return true end -- Family Secrets
  if questId == 6666 and rapportLevel >= 4 then return true end -- A Mother's Obsession
  if questId == 6667 and rapportLevel >= 5 then return true end -- Dead Weight
  if questId == 6785 and rapportLevel >= 4 then return true end -- Cold Trail
  if questId == 6786 and rapportLevel >= 5 then return true end -- Cold Blood, Old Pain
  if questId == 6787 and rapportLevel >= 6 then return true end -- Green with Envy
  if questId == 6789 and rapportLevel >= 4 then return true end -- The Lost Symbol
  if questId == 6790 and rapportLevel >= 5 then return true end -- A Mother's Request
  if questId == 6791 and rapportLevel >= 6 then return true end -- The Princess Detective
  if questId == 7018 and rapportLevel >= 4 then return true end -- Between a Rock and a Whetstone
  if questId == 7019 and rapportLevel >= 5 then return true end -- Dim and Distant Pasts
  if questId == 7020 and rapportLevel >= 6 then return true end -- Light the Way to Freedom
  if questId == 7022 and rapportLevel >= 4 then return true end -- Paths Unwalked
  if questId == 7023 and rapportLevel >= 5 then return true end -- Adversarial Adventures
  if questId == 7024 and rapportLevel >= 6 then return true end -- Tempting Fates
  return false
end

--[[given: table
returns true/false
intent: check if the quest is in the zone already by name and questId.

there are times when the same quest has the same name and questId,
and in those cases don't duplicate it.

there are times when a quest has the same name but a different questId,
which with the addition of alliance for check_quest_alliance will help since
this is probably AVA mostly. Alliance was not added until version 237
]]--
function internal:check_quest_in_zone(quest)
end

--[[given: table
returns true/false
intent: check if the texture map is a string and if there are quests in the zone
]]--
function internal:zone_has_quest_locations(zone)

  local function quest_locations_nil(zone)
    return internal.quest_locations[zone] == nil
  end

  local function zone_has_quests(zone)
    if quest_locations_nil(zone) then
      return false
    end
    return NonContiguousCount(internal.quest_locations[zone]) > 0
  end

  if type(zone) == "string" and zone_has_quests(zone) then
    return true
  end
  return false
end

function internal:subzone_has_conversions(zone)

  local function subzone_location_nil(zone)
    return internal.subzone_list[zone] == nil
  end

  local function zone_has_conversions(zone)
    if subzone_location_nil(zone) then
      return false
    end
    return NonContiguousCount(internal.subzone_list[zone]) > 0
  end

  if type(zone) == "string" and zone_has_conversions(zone) then
    return true
  end
  return false
end

function internal:add_subzone_quests(zone)
end

function internal:is_master_player()
  local displayName = GetDisplayName()
  local masterPlayer = displayName == "@Sharlikran"
  local masterModeActive = false
  if masterPlayer and masterModeActive then
    return true
  end
  return false
end
