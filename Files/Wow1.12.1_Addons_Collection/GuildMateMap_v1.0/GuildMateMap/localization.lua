-- **
-- *  Version Info
-- **
GuildMateMap_VERSION = "1.0";
GuildMateMap_LOADED_TEXT = "GuildMateMap Version "..GuildMateMap_VERSION.." Loaded.\nType /gmm or /guildmatemap for parameters";

-- **
-- *	User messages
-- **
GuildMateMap_Updating = "Updating...";
GuildMateMap_LevelMessage = "GuildMate: Ding!!! %s has reached level %s";
GuildMateMap_OptionsTitle = "GuildMateMap";

-- **
-- * Parameters for our slash command
-- **
GuildMateMap_DEBUG_PARAM 		= "debug";
GuildMateMap_PRINT_LIST_PARAM	= "print";
GuildMateMap_CLEAR_LIST_PARAM	= "clear";
GuildMateMap_Enabled_PARAM		= "enable";
GuildMateMap_Mates_PARAM 	    = "mates";
GuildMateMap_Reload_PARAM	    = "reload";
GuildMateMap_MsgOnLevel_PARAM	= "msglvl";


-- **
-- * Names of major cities that have their own map
-- **
GuildMateMapMajorCities = {
					[1] = "Orgrimmar",
					[2] = "Undercity",
					[3] = "Thunder Bluff",
					[4] = "Stormwind",
					[5] = "Ironforge",
					[6] = "Darnassus"
				};

-- **
-- * Character classes to localize change the class name on the left
-- **
GuildMateMapClasses	= {
					["Hunter"]	= "Hunter",
					["Shaman"]	= "Shaman",
					["Paladin"] = "Paladin",
					["Druid"]	= "Druid",
					["Rogue"]	= "Rogue",
					["Warrior"]	= "Warrior",
					["Warlock"]	= "Warlock",
					["Mage"]	= "Mage",
					["Priest"]	= "Priest"
				};

-- **
-- * Strings used for the slash command info/help
-- **
GuildMateMapIntro		= "Guild Addon to display your guildmates on your map.";
GuildMateMapClickInfo	= "Left click on worldmap icon to pst, right click to invite\nLeft click on minimap icon to target, rigt click to open menu\n\n";
GuildMateMapParameters	= "Parameters:";
GuildMateMapDebug		= "     "..GuildMateMap_DEBUG_PARAM.." [on/off]";
GuildMateMapEnable		= "     "..GuildMateMap_Enabled_PARAM.." [true/false] Enables or Disables GuildMateMap";
GuildMateMapMsgLvl		= "     "..GuildMateMap_MsgOnLevel_PARAM.." [on/off] Turn on/off sending a guild chat message when you level";
GuildMateMapPrint		= "     "..GuildMateMap_PRINT_LIST_PARAM.." Prints the list of guild mates currently being tracked";
GuildMateMapClear		= "     "..GuildMateMap_CLEAR_LIST_PARAM.." Clears out the list of guild mates being tracked";
GuildMateMapMates		= "     "..GuildMateMap_Mates_PARAM.." Debug method to add false guild mates for testing";

-- ** 
-- * Colors used for classes Don't need to localize...
-- **				
GuildMateMapClassColor = {
	["Warrior"] = { r = 1.0, g = 0.0, b = 0.0 },
	["Hunter"] = { r = 0.0, g = 1.0, b = 0.0 },
	["Warlock"] = { r = 0.0, g = 0.0, b = 1.0 },
	["Priest"] = { r = 1.0, g = 1.0, b = 1.0 },
	["Shaman"] = { r = 1.0, g = 0.0, b = 1.0 },
	["Rogue"] = { r = 1.0, g = 1.0, b = 0.0 },
	["Mage"] = { r = 0.0, g = 1.0, b = 1.0 },
	["Paladin"] = { r = 0.7, g = 0.7, b = 0.7 },
	["Druid"] = { r = 1.0, g = 0.6, b = 0.0 }
	};

GuildMateMapMiniMapPopupButtons = { [1]="Invite", [2]="Whisper", [3]="Follow" };


if ( GetLocale() == "deDE" ) then
	--[[
	   � : \195\160    � : \195\168    � : \195\172    � : \195\178    � : \195\185   � : \195\132
	   � : \195\161    � : \195\169    � : \195\173    � : \195\179    � : \195\186   � : \195\150
	   � : \195\162    � : \195\170    � : \195\174    � : \195\180    � : \195\187   � : \195\156
	   � : \195\163    � : \195\171    � : \195\175    � : \195\181    � : \195\188   � : \195\159
	   � : \195\164                    � : \195\177    � : \195\182
	   � : \195\166                                    � : \195\184
	   � : \195\167
	--]]
	
	-- **
	-- *  Version
	-- **
	GuildMateMap_LOADED_TEXT = "GuildMateMap Version "..GuildMateMap_VERSION.." Geladen.\nSchreiben Sie /gmm or /guildmatemap f\195\198r parameter";
	
	-- **
	-- *	Benutzeranzeigen
	-- **
	GuildMateMap_Updating = "Aktualisierung...";
	GuildMateMap_LevelMessage = "GuildMate: Ding!!! %s hat %s erreicht";
	
	
	-- **
	-- * Parameter f�r Schr�gstrichbefehl
	-- **
	GuildMateMap_DEBUG_PARAM 		= "debug";
	GuildMateMap_PRINT_LIST_PARAM	= "druck";
	GuildMateMap_CLEAR_LIST_PARAM	= "leeren";
	GuildMateMap_Enabled_PARAM		= "aktivieren";
	GuildMateMap_Mates_PARAM 	    = "freunde";
	GuildMateMap_Reload_PARAM	    = "laden";
	GuildMateMap_MsgOnLevel_PARAM	= "msglvl";
	
	-- **
	-- * Character classes to localize change the class name on the left
	-- **
	GuildMateMapClasses			= {
							["J\195\164ger"]	= "Hunter",
							["Schamane"]		= "Shaman",
							["Paladin"]			= "Paladin",
							["Druide"]			= "Druid",
							["Schurke"]			= "Rogue",
							["Krieger"]			= "Warrior",
							["Hexenmeister"]	= "Warlock",
							["Magier"]			= "Mage",
							["Priester"]		= "Priest"
							};
							
	
	-- **
	-- * Names of major cities that have their own map (Same in German)
	-- **
	GuildMateMapMajorCities = {
						[1] = "Orgrimmar",
						[2] = "Undercity",
						[3] = "Thunder Bluff",
						[4] = "Stormwind",
						[5] = "Ironforge",
						[6] = "Darnassus"
					};
	
	-- **
	-- * Strings used for the slash command info/help
	-- **
	GuildMateMapIntro		= "Addon um die Gildenmitglieder auf der Weltkarte anzuzeigen";
	GuildMateMapClickInfo	= "Left click on worldmap icon to pst, right click to invite\nLeft click on minimap to target, rigt click to open menu\n\n";
	GuildMateMapParameters	= "Optionen:";
	GuildMateMapDebug		= "     "..GuildMateMap_DEBUG_PARAM.." [on/off]";
	GuildMateMapEnable		= "     "..GuildMateMap_Enabled_PARAM.." [true/false] Schaltet GuildMateMap ein oder aus.";
	GuildMateMapMsgLvl		= "     "..GuildMateMap_MsgOnLevel_PARAM.." [on/off] Levelbenachrichtigung im Gildenchat (de)aktivieren.";
	GuildMateMapPrint		= "     "..GuildMateMap_PRINT_LIST_PARAM.." Zeigt die Liste der derzeit verfolgten Gildenmitglieder.";
	GuildMateMapClear		= "     "..GuildMateMap_CLEAR_LIST_PARAM.." Leert die Liste der verfolgten Gildenmitglieder";
	GuildMateMapMates		= "     "..GuildMateMap_Mates_PARAM.." Debug Methode um fiktive Gildenmitglieder zum Testen hinzuzuf\195\188gen.";

end


