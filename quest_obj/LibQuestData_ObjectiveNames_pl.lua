--[[

LibQuestData
by Sharlikran
https://sharlikran.github.io/

^(\d{1,4}), "(.*)"
    \[\1] = "\2",

(.*) = "(.*)" = "(.*), ",
"\2", = \{\3\,},

^"(.*)", = \{(.*)\},
    \["\1"] = \{\2 },

For renumbering new rebuilt tables

(.*)\[(\d{1,4})\] = "(.*)",
\2, "\3"


--]]
local lib = _G["LibQuestData"]

lib.objective_names["pl"] = {
    [4255] = "Straż Vulkhel",
    [6045] = "Wieczne Źródło",
    [4664] = "Nora Hazaka",
    [4625] = "Świątynia Żałobnych Źródeł",
    [4673] = "Plantacja Łapacza Wiatru",
    [4692] = "Plantacja Figlarnych Księżyców",
    [4620] = "Trzaskająca Mielizna",
    [4693] = "Plantacja Kolorowej Muszli",
    [4624] = "Mistral",
    [4621] = "Molo Kociego Oka",
    [4208] = "Silsailen",
    [4361] = "Zamek Rilis",
    [4219] = "Południowa Strażnica",
    [3995] = "Nora Orkeya",
    [6480] = "Mroczna Kotlina",
    [6465] = "Świątynia Kilkret",
    [6468] = "Strażnica Karth",
    [6471] = "Osada Zmierzchu",
    [6472] = "Twierdza Szarego Wrzosowiska",
    [6459] = "Morthal",
    [6460] = "Srebrny Kormoran",
    [6461] = "Grota Ciemnego Księżyca",
    [6484] = "Mor Khazgur",
    [6473] = "Smoczymost",
    [6189] = "Marsz Ofiar",
    [5301] = "Loch: Wyspa Nawałnicy",
    [5275] = "Loch: Śniade Jaskinie I",
    [6497] = "Nchuthnkarst",
    [6162] = "Karnwasten",
    [4396] = "Przystań",
    [4329] = "Kolegium Aldmerskiej Poprawności",
    [4338] = "Zatoka Zielonej Wody",
    [4355] = "Jutrzenka",
    [4300] = "Torinaan",
    [4309] = "Północna Strażnica",
    [4295] = "Północna Strażnica",
    [4326] = "Quendeluun",
    [4220] = "Ezduiin",
    [4272] = "Błyszcząca Dolina",
    [4441] = "Wypłuczysko Zębomaczugi",
    [4293] = "Mathiisen",
    [4264] = "Phaer ",
    [4277] = "Strzaskany Gaj",
    [3999] = "Dom Halmaery",
    [3996] = "Obóz Mroźnej Grani",
    [3992] = "Kurhan Niebieskiego Całunu",
    [4016] = "Wioska Ponurej Skały",
    [4002] = "Wioska Ponurej Skały",
    [3987] = "Szaleństwo Hozzina",
    [3988] = "Obóz łowców",
    [3991] = "Wioska Ponurej Skały",
    [4023] = "Dhalmora",
}
