local TOCNAME,GBB=...

function GBB.GetDungeonNames()
	local DefaultEnGB={
		["RFC"] = 	"Ragefire Chasm",
		["DM"] = 	"The Deadmines",
		["WC"] = 	"Wailing Caverns",	
		["SFK"] = 	"Shadowfang Keep",
		["STK"] = 	"The Stockade",
		["BFD"] = 	"Blackfathom Deeps",
		["GNO"] = 	"Gnomeregan",
		["RFK"] = 	"Razorfen Kraul",
		["SM2"] =	"Scarlet Monastery",
		["SMG"] = 	"Scarlet Monastery: Graveyard",
		["SML"] = 	"Scarlet Monastery: Library",
		["SMA"] = 	"Scarlet Monastery: Armory",
		["SMC"] = 	"Scarlet Monastery: Cathedral",
		["RFD"] = 	"Razorfen Downs",
		["ULD"] = 	"Uldaman",
		["ZF"] = 	"Zul'Farrak",
		["MAR"] = 	"Maraudon",
		["ST"] = 	"The Sunken Temple",
		["BRD"] = 	"Blackrock Depths",
		["DM2"] = 	"Dire Maul",
		["DME"] = 	"Dire Maul: East",
		["DMN"] = 	"Dire Maul: North",
		["DMW"] = 	"Dire Maul: West",
		["STR"] = 	"Stratholme",
		["SCH"] = 	"Scholomance",
		["LBRS"] = 	"Lower Blackrock Spire",
		["UBRS"] = 	"Upper Blackrock Spire (10)",
		["ONY"] = 	"Onyxia's Lair (40)",
		["MC"] = 	"Molten Core (40)",
		["ZG"] = 	"Zul'Gurub (20)",
		["AQ20"] = 	"Ruins of Ahn'Qiraj (20)",
		["BWL"] = 	"Blackwing Lair (40)",
		["AQ40"] = 	"Temple of Ahn'Qiraj (40)",
		["NAX"] = 	"Naxxramas (40)",
		["WSG"] = 	"Warsong Gulch (PvP)",
		["AB"] = 	"Arathi Basin (PvP)",
		["AV"] = 	"Alterac Valley (PvP)",
		["MISC"] = 	"Miscellaneous",
		["TRADE"] =	"Trade",
		["DEBUG"] = "DEBUG INFO",
		["BAD"] =	"DEBUG BAD WORDS - REJECTED",
		}
		
	local dungeonNamesLocales={ 
		deDE ={
			["RFC"] = 	"Ragefireabgrund",
			["DM"] = 	"Die Todesminen",
			["WC"] = 	"Die Höhlen des Wehklagens",		
			["SFK"] = 	"Burg Shadowfang",
			["STK"] = 	"Das Verlies",
			["BFD"] = 	"Blackfathom-Tiefe",
			["GNO"] = 	"Gnomeregan",
			["RFK"] = 	"Der Kral von Razorfen",
			["SM2"] =	"Scharlachrotes Kloster",
			["SMG"] = 	"Scharlachrotes Kloster: Friedhof",
			["SML"] = 	"Scharlachrotes Kloster: Bibliothek",
			["SMA"] = 	"Scharlachrotes Kloster: Waffenkammer",
			["SMC"] = 	"Scharlachrotes Kloster: Kathedrale",
			["RFD"] = 	"Die Hügel von Razorfen",
			["ULD"] = 	"Uldaman",
			["ZF"] = 	"Zul'Farrak",
			["MAR"] = 	"Maraudon",
			["ST"] = 	"Versunkener Tempel",
			["BRD"] = 	"Blackrocktiefen",
			["DM2"] = 	"Düsterbruch",
			["DME"] = 	"Düsterbruch: Ost",
			["DMN"] = 	"Düsterbruch: Nord",
			["DMW"] = 	"Düsterbruch: West",
			["STR"] = 	"Stratholme",
			["SCH"] = 	"Scholomance",
			["LBRS"] = 	"Untere Blackrockspitze",
			["UBRS"] = 	"Obere Blackrockspitze (10)",
			["ONY"] = 	"Onyxias Hort (40)",
			["MC"] = 	"Geschmolzener Kern (40)",
			["ZG"] = 	"Zul'Gurub (20)",
			["AQ20"] = 	"Ruinen von Ahn'Qiraj (20)",
			["BWL"] = 	"Pechschwingenhort (40)",
			["AQ40"] = 	"Tempel von Ahn'Qiraj (40)",
			["NAX"] = 	"Naxxramas (40)",
			["WSG"] = 	"Warsongschlucht (PVP)",
			["AV"] = 	"Alteractal (PVP)",
			["AB"] = 	"Arathibecken (PVP)",
			["MISC"] = 	"Verschiedenes",
			["TRADE"] =	"Handel",
			
		},
		frFR ={
			["RFC"] = 	"Gouffre de Ragefeu",
			["DM"] = 	"Les Mortemines",
			["WC"] = 	"Cavernes des lamentations",	
			["SFK"] = 	"Donjon d'Ombrecroc",
			["STK"] = 	"La Prison",
			["BFD"] = 	"Profondeurs de Brassenoire",
			["GNO"] = 	"Gnomeregan",
			["RFK"] = 	"Kraal de Tranchebauge",
			["SM2"] =	"Monastère écarlate",
			["SMG"] = 	"Monastère écarlate: Graveyard",
			["SML"] = 	"Monastère écarlate: Library",
			["SMA"] = 	"Monastère écarlate: Armory",
			["SMC"] = 	"Monastère écarlate: Cathedral",
			["RFD"] = 	"Souilles de Tranchebauge",
			["ULD"] = 	"Uldaman",
			["ZF"] = 	"Zul'Farrak",
			["MAR"] = 	"Maraudon",
			["ST"] = 	"Le temple d'Atal'Hakkar",
			["BRD"] = 	"Profondeurs de Blackrock",
			["DM2"] = 	"Hache-tripes",
			["DME"] = 	"Hache-tripes: East",
			["DMN"] = 	"Hache-tripes: North",
			["DMW"] = 	"Hache-tripes: West",
			["STR"] = 	"Stratholme",
			["SCH"] = 	"Scholomance",
			["LBRS"] = 	"Pic Blackrock",
			["UBRS"] = 	"Pic Blackrock (10)",
			["ONY"] = 	"Repaire d'Onyxia (40)",
			["MC"] = 	"Cœur du Magma (40)",
			["ZG"] = 	"Zul'Gurub (20)",
			["AQ20"] = 	"Ruines d'Ahn'Qiraj (20)",
			["BWL"] = 	"Repaire de l'Aile noire (40)",
			["AQ40"] = 	"Ahn'Qiraj (40)",
			["NAX"] = 	"Naxxramas (40)",
		
		},
		esMX ={
			["RFC"] = 	"Sima Ígnea",
			["DM"] = 	"Las Minas de la Muerte",
			["WC"] = 	"Cuevas de los Lamentos",		
			["SFK"] = 	"Castillo de Colmillo Oscuro",
			["STK"] = 	"Las Mazmorras",
			["BFD"] = 	"Cavernas de Brazanegra",
			["GNO"] = 	"Gnomeregan",
			["RFK"] = 	"Horado Rajacieno",
			["SM2"] =	"Monasterio Escarlata",
			["SMG"] = 	"Monasterio Escarlata: Friedhof",
			["SML"] = 	"Monasterio Escarlata: Bibliothek",
			["SMA"] = 	"Monasterio Escarlata: Waffenkammer",
			["SMC"] = 	"Monasterio Escarlata: Kathedrale",
			["RFD"] = 	"Zahúrda Rojocieno",
			["ULD"] = 	"Uldaman",
			["ZF"] = 	"Zul'Farrak",
			["MAR"] = 	"Maraudon",
			["ST"] = 	"El Templo de Atal'Hakkar",
			["BRD"] = 	"Profundidades de Roca Negra	",
			["DM2"] = 	"La Masacre",
			["DME"] = 	"La Masacre: Ost",
			["DMN"] = 	"La Masacre: Nord",
			["DMW"] = 	"La Masacre: West",
			["STR"] = 	"Stratholme",
			["SCH"] = 	"Scholomance",
			["LBRS"] = 	"Cumbre de Roca Negra",
			["UBRS"] = 	"Cumbre de Roca Negra (10)",
			["ONY"] = 	"Guarida de Onyxia (40)",
			["MC"] = 	"Núcleo de Magma (40)",
			["ZG"] = 	"Zul'Gurub (20)",
			["AQ20"] = 	"Ruinas de Ahn'Qiraj (20)",
			["BWL"] = 	"Guarida Alanegra (40)",
			["AQ40"] = 	"Ahn'Qiraj (40)",
			["NAX"] = 	"Naxxramas (40)",

		},
		ruRU = {
			["AB"] = "Низина Арати (PvP)",
			["AQ20"] = "Руины Ан'Киража (20)",
			["AQ40"] = "Ан'Кираж (40)",
			["AV"] = "Альтеракская Долина (PvP)",
			["BAD"] = "ОТЛАДКА ПЛОХИЕ СЛОВА - ОТКЛОНЕН",
			["BFD"] = "Непроглядная Пучина",
			["BRD"] = "Глубины Черной горы",
			["BWL"] = "Логово Крыла Тьмы (40)",
			["DEBUG"] = "ИНФОРМАЦИЯ О ОТЛАДКАХ",
			["DM"] = "Мертвые копи",
			["DM2"] = "Забытый Город",
			["DME"] = "Забытый Город: Восток",
			["DMN"] = "Забытый Город: Север",
			["DMW"] = "Забытый Город: Запад",
			["GNO"] = "Гномреган",
			["LBRS"] = "Низ Вершины Черной горы",
			["MAR"] = "Мародон",
			["MC"] = "Огненные Недра (40)",
			["MISC"] = "Прочее",
			["NAX"] = "Наксрамас (40)",
			["ONY"] = "Логово Ониксии (40)",
			["RFC"] = "Огненная пропасть",
			["RFD"] = "Курганы Иглошкурых",
			["RFK"] = "Лабиринты Иглошкурых",
			["SCH"] = "Некроситет",
			["SFK"] = "Крепость Темного Клыка",
			["SM2"] = "Монастырь Алого ордена",
			["SMA"] = "Монастырь Алого ордена: Оружейная",
			["SMC"] = "Монастырь Алого ордена: Собор",
			["SMG"] = "Монастырь Алого ордена: Кладбище",
			["SML"] = "Монастырь Алого ордена: Библиотека",
			["ST"] = "Затонувший Храм",
			["STK"] = "Тюрьма",
			["STR"] = "Стратхольм",
			["TRADE"] = "Торговля",
			["UBRS"] = "Верх Вершины Черной горы (10)",
			["ULD"] = "Ульдаман",
			["WC"] = "Пещеры Стенаний",
			["WSG"] = "Ущелье Песни Войны (PvP)",
			["ZF"] = "Зул'Фаррак",
			["ZG"] = "Зул'Гуруб (20)",
		},
	}

	
	
	local dungeonNames = dungeonNamesLocales[GetLocale()] or {}
	
	if GroupBulletinBoardDB and GroupBulletinBoardDB.CustomLocalesDungeon and type(GroupBulletinBoardDB.CustomLocalesDungeon) == "table" then
		for key,value in pairs(GroupBulletinBoardDB.CustomLocalesDungeon) do
			if value~=nil and value ~="" then
				dungeonNames[key.."_org"]=dungeonNames[key] or DefaultEnGB[key]
				dungeonNames[key]=value				
			end
		end
	end
	
	
	setmetatable(dungeonNames, {__index = DefaultEnGB})
	
	dungeonNames["DEADMINES"]=dungeonNames["DM"]
	
	return dungeonNames
end

GBB.dungeonLevel ={
		["RFC"] = 	{13,18}, ["DM"] = 	{18,23}, ["WC"] = 	{15,25}, ["SFK"] = 	{22,30}, ["STK"] = 	{22,30}, ["BFD"] = 	{24,32},
		["GNO"] = 	{29,38}, ["RFK"] = 	{30,40}, ["SMG"] = 	{28,38}, ["SML"] = 	{29,39}, ["SMA"] = 	{32,42}, ["SMC"] = 	{35,45},
		["RFD"] = 	{40,50}, ["ULD"] = 	{42,52}, ["ZF"] = 	{44,54}, ["MAR"] = 	{46,55}, ["ST"] = 	{50,60}, ["BRD"] = 	{52,60},
		["LBRS"] = 	{55,60}, ["DME"] = 	{58,60}, ["DMN"] = 	{58,60}, ["DMW"] = 	{58,60}, ["STR"] = 	{58,60}, ["SCH"] = 	{58,60},
		["UBRS"] = 	{58,60}, ["ONY"] = 	{60,60}, ["MC"] = 	{60,60}, ["ZG"] = 	{60,60}, ["AQ20"]= 	{60,60}, ["BWL"] = 	{60,60},
		["AQ40"] = 	{60,60}, ["NAX"] = 	{60,60}, ["WSG"] = 	{10,60}, ["AB"] = 	{20,60}, ["AV"] = 	{51,60}, ["MISC"]= 	{0,100},
		["DEBUG"] = {0,100}, ["BAD"] =	{0,100}, ["TRADE"]=	{0,100},
		["SM2"] = {28,42}, ["DM2"] =	{58,60}, ["DEADMINES"]={18,23},
	}
	
function GBB.GetDungeonSort()
	local tmp_dsort = { 
		["RFC"] = 1,	["WC"]  = 2,	["DM"]  = 3,	["SFK"] = 4,	["STK"] = 5,	["BFD"] = 6,	["GNO"] = 7,
		["RFK"] = 8,	["SMG"] = 9,	["SML"] = 10,	["SMA"] = 11,	["SMC"] = 12,	 ["RFD"] = 13,	["ULD"] = 14,
		["ZF"] = 15,	["MAR"] = 16,	["ST"]  = 17,	["BRD"] = 18,	["LBRS"] = 19,	["DME"] = 20,	["DMN"] = 22,
		["DMW"] = 21,	["STR"] = 23,	["SCH"] = 24,	["UBRS"] = 25,	["ONY"] = 26,	["MC"] = 27,	["ZG"] = 28,
		["AQ20"] = 29,	["BWL"] = 30,	["AQ40"] = 31,	["NAX"] = 32,	["WSG"] = 33,	["AB"] = 34,	["AV"] = 35,
		["MISC"] = 36,	["TRADE"] = 37,	["DEBUG"] = 38,	["BAD"] = 39,	["NIL"] = 99,
		["SM2"] = 10.5,	["DM2"] = 19.5,	["DEADMINES"]=99,
	}	
	local dungeonSort = {}
	for dungeon,nb in pairs(tmp_dsort) do
		dungeonSort[nb]=dungeon
		dungeonSort[dungeon]=nb
	end
	--dungeonSort["SM2"]=dungeonSort["SMA"]
	--dungeonSort["DM2"]=dungeonSort["DME"]
	
	return dungeonSort
end




