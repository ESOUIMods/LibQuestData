--[[

LibQuestData
by Sharlikran
https://sharlikran.github.io/

Convert fireundubh lists

^(\d{1,4}), "(.*)"
    \[\1] = "\2",

Other

(.*) = "(.*)" = "(.*), ",
"\2", = \{\3\,},

^"(.*)", = \{(.*)\},
    \["\1"] = \{\2 },

For renumbering new rebuilt tables

(.*)\[(\d{1,4})\] = "(.*)",
\2, "\3"


--]]
local lib = _G["LibQuestData"]

lib.quest_names["it"] = {
    [614] = "Uno sguardo allo specchio",
    [974] = "Un Duca in Esilio",
    [1568] = "Un Mezzo per un Fine",
    [1799] = "Una Città in Nero",
    [2488] = "Una Banda di Teppisti",
    [2561] = "Un Affare di Famiglia",
    [3000] = "Il Sangue e la Mezzaluna",
    [3006] = "Assassini della Spina Insanguinata",
    [3013] = "Lupi nell'Ovile",
    [3047] = "Un Passo Indietro nel Tempo",
    [3049] = "Il Soldato Senza Nome",
    [3063] = "Campione dei Guardiani",
    [3174] = "Una Speranza Duratura",
    [3648] = "Una Storia Raccontata dalle Impronte",
    [3662] = "Un po' di Sport",
    [3697] = "Un Raduno di Guar",
    [3824] = "Un Ultimo Promemoria",
    [3845] = "E Getta Via La Chiave",
    [3854] = "L'Affetto di un Goblin",
    [3856] = "Ancore dal Porto",
    [3880] = "Un Colpo per l'Ordine",
    [3885] = "Nucleo Prismatico",
    [3957] = "Dono del Verme",
    [3990] = "Un Inizio a Bleakrock",
    [4034] = "Un amico a Mead",
    [4055] = "Una cura per Droi",
    [4078] = "Un Consiglio di Thanes",
    [4133] = "Raccolta dell'Anima",
    [4140] = "Soldato a Terra",
    [4141] = "Uccidi il Messaggero",
    [4146] = "Una Famiglia Divisa",
    [4256] = "Una Situazione Ostile",
    [4301] = "Salva le Reliquie",
    [4302] = "Evocatore del Culto del Verme",
    [4336] = "Resti Antichi",
    [4339] = "Se i Morti Potessero Parlare",
    [4348] = "Un Cimitero di Navi",
    [4364] = "Una Spina nel Fianco",
    [4382] = "Momento della Verità",
    [4424] = "Un Debito è Dovuto",
    [4447] = "Yngrel il Sanguinario",
    [4453] = "Un Favore Restituito",
    [4454] = "Mascalzone Innocente",
    [4493] = "Un Giusto Avvertimento",
    [4494] = "Devi Romperne Alcune",
    [4495] = "Un Servizio per i Morti",
    [4519] = "Parole dai Morti",
    [4523] = "Il Complotto della Spina Insanguinata",
    [4529] = "Risorse dei Torre Rossa",
    [4531] = "Un Incontro con la Morte",
    [4538] = "Occhio del Ciclone",
    [4548] = "Vista Acuta",
    [4565] = "Fai Come Ti Dico",
    [4605] = "La Città Vuota",
    [4607] = "Castello del Verme",
    [4621] = "La Tempesta Scatenata",
    [4647] = "Un Piede nella Porta",
    [4675] = "Oscurità Consumante",
    [4689] = "Una Porta nel Chiaro di Luna",
    [4831] = "Il Rifugio",
    [4840] = "Antico Potere",
    [4864] = "Un Favore tra Re",
    [4894] = "Una Lettera per Deshaan",
    [4896] = "Il Grande Albero",
    [4929] = "Un Pugnale al Cuore",
    [4955] = "Una Pausa Fortunata",
    [4977] = "Pietre Antiche, Parole Antiche",
    [4980] = "Una Questione Grave",
    [4989] = "Una Manciata di Sogni Rubati",
    [4998] = "Argento di Cadwell",
    [5007] = "Tumulo del Focolare Velato",
    [5008] = "Un Diamante nella Radice",
    [5021] = "L'Amante",
    [5027] = "Un Ripensamento",
    [5033] = "Gli Osservatori Celesti",
    [5244] = "Incarico: Celle dell'Esilio I",
    [5247] = "Incarico: Grotta dei Funghi I",
    [5248] = "Incarico: Grotta dei Funghi II",
    [5249] = "Certificazione da Fabbro",
    [5259] = "Certificazione Artigianale",
    [5260] = "Incarico: Spindleclutch I",
    [5273] = "Incarico: Spindleclutch II",
    [5275] = "Incarico: Caverne Oscure II",
    [5276] = "Incarico: Profondità di Elden I",
    [5278] = "Incarico: Fogne di Wayrest",
    [5282] = "Incarico: Fogne di Wayrest II",
    [5284] = "Incarico: Cripta di Cuori II",
    [5288] = "Incarico: Arx Corinium",
    [5289] = "Certificazione da Fornitore di Cibi e Bevande",
    [5290] = "Incarico: Città della Cenere I",
    [5291] = "Incarico: Fortezza dei Direfrost",
    [5302] = "Certificazione da Falegname",
    [5305] = "Incarico: Baia di Blackheart",
    [5306] = "Incarico: Sfida Benedetta",
    [5307] = "Incarico: Tela di Selene",
    [5309] = "Incarico: Volte della Follia",
    [5310] = "Certificazione da Sarto",
    [5312] = "Ottenere gli Incarichi dei Temerari",
    [5314] = "Certificazione da Incantatore",
    [5315] = "Certificazione da Alchimista",
    [5316] = "Una Caduta Inaspettata",
    [5321] = "Un Cuore d'Ottone",
    [5329] = "Per il Re e la Gloria",
    [5337] = "Una Questione di Successione",
    [5340] = "Sangue e Parole Sacre",
    [5368] = "Commissione da Fabbro",
    [5374] = "Commissione da Sarto",
    [5377] = "Commissione da Fabbro",
    [5382] = "Incarico: Prigione della Città Imperiale",
    [5388] = "Commissione da Sarto",
    [5389] = "Commissione da Sarto",
    [5392] = "Commissione da Fabbro",
    [5394] = "Commissione da Falegname",
    [5395] = "Commissione da Falegname",
    [5396] = "Commissione da Falegname",
    [5400] = "Commissione da Incantatore",
    [5406] = "Commissione da Incantatore",
    [5407] = "Commissione da Incantatore",
    [5409] = "Ordine Cibi/Bevande",
    [5412] = "Ordine Cibi/Bevande",
    [5413] = "Ordine Cibi/Bevande",
    [5415] = "Commissione da Alchimista",
    [5416] = "Commissione da Alchimista",
    [5417] = "Commissione da Alchimista",
    [5418] = "Commissione da Alchimista",
    [5431] = "Incarico: Torre d'Oro Bianco",
    [5445] = "Un Tesoro che ha Bisogno di una Casa",
    [5447] = "Un Problema di Dimensioni-Reali",
    [5453] = "Storia di un Khajiit",
    [5470] = "Una Scelta Sana",
    [5472] = "Una Festa da Ricordare",
    [5481] = "Sangue sulle Mani di un Re",
    [5531] = "Complici",
    [5538] = "Voci nell'Oscurità",
    [5540] = "Firmato col Sangue",
    [5552] = "I Denti di Squalo",
    [5636] = "Incarico: Rovine di Mazzatun",
    [5733] = "Antichi Armamenti a Bangkorai",
    [5739] = "Perquisire Torre Rossa a Glenumbra",
    [5747] = "Gli Osservatori Celesti",
    [5774] = "Una Foglia nel Vento",
    [5780] = "Incarico: Culla delle Ombre",
    [5799] = "Un Mercenario di Casa Telvanni",
    [5802] = "Bracieri Infiammati del Rift",
    [5838] = "Giostra delle Palle di Fango",
    [5839] = "Fuoco di Segnalazione Rapido",
    [5865] = "Abbattendo lo Sciame",
    [5872] = "Un Errore Melodico",
    [5881] = "Un Raccolto Nascosto",
    [5889] = "Sangue chiama Sangue",
    [5904] = "La Maledizione di Salothan",
    [5906] = "Il Canto della Sirena",
    [5916] = "L'apprendista ansioso",
    [5950] = "Le Tombe Ancestrali",
    [5958] = "Sindacato Instabile",
    [5972] = "Un'Arma Magistrale",
    [5973] = "Un Glifo Magistrale",
    [5974] = "Un Piatto Magistrale",
    [5975] = "Un'Arma Magistrale",
    [5976] = "Uno Scudo Magistrale",
    [5977] = "Una Festa Magistrale",
    [5979] = "Abbigliamento in Pelle Magistrale",
    [5981] = "Una Miscela Magistrale",
    [5983] = "Una Miscela Magistrale",
    [5984] = "Una Miscela Magistrale",
    [5987] = "Una Miscela Magistrale",
    [5988] = "Una Miscela Magistrale",
    [5989] = "Una Miscela Magistrale",
    [5990] = "Una Miscela Magistrale",
    [6004] = "Una Consegna in Ritardo",
    [6007] = "Una Richiesta di Aiuto",
    [6016] = "Un'Arma Magistrale",
    [6017] = "Un Glifo Magistrale",
    [6018] = "Un Piatto Magistrale",
    [6019] = "Un'Arma Magistrale",
    [6020] = "Uno Scudo Magistrale",
    [6022] = "Abbigliamento in Pelle Magistrale",
    [6023] = "Di Coltelli e Ombre Lunghe",
    [6077] = "Un Nemico dalle Piume Sottili",
    [6098] = "Commissione da Alchimista",
    [6099] = "Commissione da Alchimista",
    [6100] = "Commissione da Alchimista",
    [6101] = "Commissione da Alchimista",
    [6102] = "Commissione da Alchimista",
    [6103] = "Commissione da Alchimista",
    [6104] = "Commissione da Alchimista",
    [6105] = "Commissione da Alchimista",
    [6112] = "Una Perla di Grande Valore",
    [6116] = "Un Racconto di Due Madri",
    [6121] = "Selvaggio e Scatenato",
    [6130] = "Stanza Disponibile",
    [6134] = "Il Festival della Nuova Vita",
    [6149] = "Disperso in mare",
    [6171] = "Certificazione da Gioelliere",
    [6172] = "La Chiamata degli Psijic",
    [6181] = "Squarci nella Baia",
    [6185] = "Squarci di Fuoco e Ghiaccio",
    [6190] = "Tempo di Fango e Funghi",
    [6194] = "Uno Squarcio tra gli Alberi",
    [6196] = "Un Squarcio oltre le Rupi",
    [6218] = "Commissione di Creazione da Gioielliere",
    [6227] = "Commissione di Creazione da Gioielliere",
    [6228] = "Commissione di Creazione da Gioielliere",
    [6296] = "La battaglia di Riverhold",
    [6297] = "L'Ordine Finale",
    [6303] = "In Salute e In Malattia",
    [6304] = "Due Regine",
    [6305] = "Cadwell il Traditore",
    [6311] = "Il Rapimento di Riverhold",
    [6315] = "Il Nucleo di Jode",
    [6326] = "La Tetra Dimora di un Animale",
    [6336] = "La Furia dei Draghi",
    [6343] = "Dimostrazione Lurcher",
    [6344] = "Dimostrazione Lamia",
    [6348] = "In Difesa di Elsweyr",
    [6349] = "Il Successore di Sanguine",
    [6351] = "La Sventura Azurra",
    [6353] = "Il Ritorno di Alkosh",
    [6355] = "Relativamente Parlando",
    [6356] = "Spegnendo la Fiamma Daedrica",
    [6357] = "Caccia al Drago",
    [6358] = "Malsana Preoccupazione",
    [6361] = "In Favore del Gatto InFame",
    [6363] = "Foglie di Tè Attorcigliate",
    [6364] = "Dolce Birra Rotmeth",
    [6366] = "Attenti al Felino Bugiardo",
    [6371] = "Confusione interculturale",
    [6373] = "La Magia del Caos",
    [6374] = "Amore e Guar",
    [6375] = "L'Intenditore",
    [6378] = "Il Terrore dei Commercianti",
    [6379] = "Un Risveglio da Incubo",
    [6382] = "Un Senche Rovinoso",
    [6384] = "Caccia al Drago",
    [6389] = "Recupero dai Ruddy Fangs",
    [6393] = "Rituale Oscuro",
    [6394] = "Alleanze Difficili",
    [6396] = "Incrocio Chiaroscuro",
    [6397] = "Luna Nuova Nascente",
    [6399] = "L'Ordine della Luna Nuova",
    [6400] = "Un'Infanzia in Fiamme",
    [6401] = "Covo del Drago",
    [6402] = "L'orgoglio di Elsweyr",
    [6404] = "La Guardia del Drago",
    [6405] = "Portandoli a Tusk",
    [6407] = "Capolavori",
    [6408] = "La Preda più Letale",
    [6409] = "Riforma",
    [6412] = "Effetto Skooma",
    [6413] = "Un'altra Storia Khajiti",
    [6418] = "Sogni dei Desolati",
    [6419] = "Tomi degli Tsaesci",
    [6420] = "In difesa di Pellitine",
    [6421] = "Aiutare i guaritori",
    [6427] = "Commisione del Festival delle Streghe",
    [6428] = "Bastoni ed Ossa",
    [6431] = "Cercando le Spade Incantate",
    [6434] = "Le Prede della Guardia del Drago",
    [6435] = "Le Prede della Guardia del Drago",
    [6441] = "Canzone della Balena della Sabbie",
    [6442] = "Piccolo Gatto Sperduto",
    [6445] = "La Pietra di J'saad",
    [6447] = "Fuori da Murkmire",
    [6448] = "Il Prodotto dell'Erborista",
    [6449] = "Dentro il Sacco",
    [6463] = "L'Enigma della Congrega",
    [6512] = "Ferma le Turbolenze",
    [6514] = "Circolo dell'Antiquario",
    [6515] = "L'arte dell'Antiquariato",
    [6528] = "Ferma le Turbolenze",
    [6549] = "L'inchiesta di Ravenwatch",
    [6555] = "Il Concilio Grigio",
    [6558] = "Ferma le Turbolenze",
    [6559] = "Ferma le Turbolenze",
}
