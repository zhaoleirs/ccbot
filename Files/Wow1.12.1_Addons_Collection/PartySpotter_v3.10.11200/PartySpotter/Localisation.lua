


PSPOT_DELAY_SUFFIX = " second(s) delay between map updates";
PSPOT_OFF = "Disabled";

PSPOT_HELP_TEXT   = " ";
PSPOT_HELP_TEXT0  = "|cffffff00PartySpotter command help :|r";
PSPOT_HELP_TEXT1  = "|cff00ff00Use |r|cffffffff/pspot|r|cff00ff00 without any arguments to display the current number of Seconds between Map Updates, and these help instructions.|r";
PSPOT_HELP_TEXT2  = "|cff00ff00Use |r|cffffffff/pspot 0|r|cff00ff00 to Disable PartySpotter|r";
PSPOT_HELP_TEXT3  = "|cff00ff00Use |r|cffffffff/pspot 1|r|cff00ff00 to turn PartySpotter On and have a 1 second delay between Map Updates. 1 Second is the default value.|r";
PSPOT_HELP_TEXT4  = "|cff00ff00Use |r|cffffffff/pspot < 1 - 10 >|r|cff00ff00 to turn PartySpotter On and change the Map Update delay to any number of seconds between 1 and 10|r";
PSPOT_HELP_TEXT5  = "|cff00ff00Use |r|cffffffff/pspot showgroups icons / numbers / off|r|cff00ff00 toggle function to highlight each Raid Group with a different colour, or that group's number|r";
PSPOT_HELP_TEXT6  = "|cff00ff00Use |r|cffffffff/pspot showfriends|r|cff00ff00 to Toggle the highlighting of Friends|r";
PSPOT_HELP_TEXT7  = "|cff00ff00Use |r|cffffffff/pspot showignores|r|cff00ff00 to Toggle the highlighting of Ignores|r";
PSPOT_HELP_TEXT8  = "|cff00ff00Use |r|cffffffff/pspot showguild|r|cff00ff00 to Toggle the highlighting of Guild Members|r";
PSPOT_HELP_TEXT9  = "|cff00ff00Use |r|cffffffff/pspot -l|r|cff00ff00 to Toggle the highlighting of the Raid Leader|r";
PSPOT_HELP_TEXT10 = "|cff00ff00Use |r|cffffffff/pspot -t <Player Name>|r|cff00ff00 highlights an individual player|r";
PSPOT_HELP_TEXT11 = "|cff00ff00Use |r|cffffffff/pspot -t|r|cff00ff00 |r|cff00ff00 cancels highlighting of an individual";
PSPOT_HELP_TEXT12 = "|cff00ff00Use |r|cffffffff/pspot -c|r|cff00ff00 |r|cff00ff00 use Group Colours for Raid/BattleGround messages";		-- ??
PSPOT_HELP_TEXT13 = "|cff00ff00Use |r|cffffffff/pspot -n|r|cff00ff00 |r|cff00ff00 to Toggle Raid Group number prefixing of chat messages";	-- ??
PSPOT_HELP_TEXT14 = "|cff00ff00Use |r|cffffffff/pspot reset|r|cff00ff00 to restore defaults|r";

PSPOT_COLOUR_GROUPS = "Coloured Raid Groups";
PSPOT_NUMBER_GROUPS = "Numbered Raid Groups";
PSPOT_DFLT_GROUPS = "All Raid Groups Same Colour";
PSPOT_SHOW_FRIENDS = "Highlighting Friends";
PSPOT_SHOW_IGNORES = "Highlighting Ignores";
PSPOT_SHOW_GUILD = "Highlighting Guild Members";
PSPOT_NO_HLIGHTS = "No Friend/Ignore/Guild Highlighting";
PSPOT_LEADER = "Highlighting Raid Leader";
PSPOT_INDI = "Highlighting Individual Player";
PSPOT_COLOUR_CHAT = "Coloured Raid Chat";
PSPOT_NUMBERED_CHAT = "Raid Group Numbered Chat";


PSPOT_KEY_TITLE = "PartySpotter\nKey";   -- i.e. PartySpotter Map-Key, or Map-Legend

BINDING_HEADER_PSPOT = "PartySpotter";
BINDING_NAME_PSPOT_CYCLE_MODE = "Cycle PartySpotter Modes";
BINDING_NAME_PSPOT_CYCLE_HLIGHT = "Cycle PartySpotter Highlights";
BINDING_NAME_PSPOT_TOGGLE_KEY = "Toggle Map Key";	-- ??

PSPOT_SHOWING = "Showing";
PSPOT_HIDING  = "Hiding";

PSPOT_HIGHLIGHT = "Highlight";		-- ??



-- Data for Minimap Indicator
-- name does not NEED localisation - just a guide for people who want to re-map the list based on where their own Zones appear
--  on their Client. For example, if on the Spanish Client, Ashenvale is listed Third in the Zone Drop Down boxes on the map
--  and Darkshore is listed First, then the Spanish localised version would swap the values of [1][1] and [1][3] but the name
--  doesn't acually need to become Spanish ;)
-- Functionality shamelessly 'borrowed' from Gatherer, which shamelessly 'borrowed' it from MapNotes ;)

MINIMAP_SCALES[1][0]  = { name = "Kalimdor" };
MINIMAP_SCALES[1][1]  = { scale = 0.15670371525706, xoffset = 0.41757282062541, yoffset = 0.33126468682991, name = "Ashenvale" };
MINIMAP_SCALES[1][2]  = { scale = 0.13779501505279, xoffset = 0.55282036918049, yoffset = 0.30400571307545, name = "Aszhara" };
MINIMAP_SCALES[1][3]  = { scale = 0.17799008894522, xoffset = 0.38383175154516, yoffset = 0.18206216123156, name = "Darkshore" };
MINIMAP_SCALES[1][4]  = { scale = 0.02876626176374, xoffset = 0.38392150175204, yoffset = 0.10441296545475, name = "Darnassis" };
MINIMAP_SCALES[1][5]  = { scale = 0.12219839120669, xoffset = 0.34873187115693, yoffset = 0.50331046935371, name = "Desolace" };
MINIMAP_SCALES[1][6]  = { scale = 0.14368294970080, xoffset = 0.51709782709100, yoffset = 0.44802818134926, name = "Durotar" };
MINIMAP_SCALES[1][7]  = { scale = 0.14266384095509, xoffset = 0.49026338351379, yoffset = 0.60461876174686, name = "Dustwallow" };
MINIMAP_SCALES[1][8]  = { scale = 0.15625084006464, xoffset = 0.41995800144849, yoffset = 0.23097545880609, name = "Felwood" };
MINIMAP_SCALES[1][9]  = { scale = 0.18885970960818, xoffset = 0.31589651244686, yoffset = 0.61820581746798, name = "Feralas" };
MINIMAP_SCALES[1][10] = { scale = 0.06292695969921, xoffset = 0.50130287793373, yoffset = 0.17560823085517, name = "Moonglade" };
MINIMAP_SCALES[1][11] = { scale = 0.13960673216274, xoffset = 0.40811854919226, yoffset = 0.53286226907346, name = "Mulgore" };
MINIMAP_SCALES[1][12] = { scale = 0.03811449638057, xoffset = 0.56378554142668, yoffset = 0.42905218646258, name = "Ogrimmar" };
MINIMAP_SCALES[1][13] = { scale = 0.09468465888932, xoffset = 0.39731975488374, yoffset = 0.76460608512626, name = "Silithus" };
MINIMAP_SCALES[1][14] = { scale = 0.13272833611061, xoffset = 0.37556627748617, yoffset = 0.40285135292988, name = "StonetalonMountains" };
MINIMAP_SCALES[1][15] = { scale = 0.18750104661175, xoffset = 0.46971301480866, yoffset = 0.76120931364891, name = "Tanaris" };
MINIMAP_SCALES[1][16] = { scale = 0.13836131003639, xoffset = 0.36011098024729, yoffset = 0.03948322979210, name = "Teldrassil" };
MINIMAP_SCALES[1][17] = { scale = 0.27539211944292, xoffset = 0.39249347333450, yoffset = 0.45601063260257, name = "Barrens" };
MINIMAP_SCALES[1][18] = { scale = 0.11956582877920, xoffset = 0.47554411191734, yoffset = 0.68342356389650, name = "ThousandNeedles" };
MINIMAP_SCALES[1][19] = { scale = 0.02836291430658, xoffset = 0.44972878210917, yoffset = 0.55638479002362, name = "ThunderBluff" };
MINIMAP_SCALES[1][20] = { scale = 0.10054401185671, xoffset = 0.44927594451520, yoffset = 0.76494573629405, name = "UngoroCrater" };
MINIMAP_SCALES[1][21] = { scale = 0.19293573573141, xoffset = 0.47237382938446, yoffset = 0.17390990272233, name = "Winterspring" };
MINIMAP_SCALES[2][0]  = { name = "Azeroth" };
MINIMAP_SCALES[2][1]  = { scale = 0.07954563533736, xoffset = 0.43229874660542, yoffset = 0.25425926375262, name = "Alterac" };
MINIMAP_SCALES[2][2]  = { scale = 0.10227310921644, xoffset = 0.47916793249546, yoffset = 0.32386170078419, name = "Arathi" };
MINIMAP_SCALES[2][3]  = { scale = 0.07066771883566, xoffset = 0.51361415033147, yoffset = 0.56915717993261, name = "Badlands" };
MINIMAP_SCALES[2][4]  = { scale = 0.09517074521836, xoffset = 0.48982154167011, yoffset = 0.76846519986510, name = "BlastedLands" };
MINIMAP_SCALES[2][5]  = { scale = 0.08321525646393, xoffset = 0.04621224670174, yoffset = 0.61780780524905, name = "BurningSteppes" };
MINIMAP_SCALES[2][6]  = { scale = 0.07102298961531, xoffset = 0.47822105868635, yoffset = 0.73863555048516, name = "DeadwindPass" };
MINIMAP_SCALES[2][7]  = { scale = 0.13991525534426, xoffset = 0.40335096278072, yoffset = 0.48339696712179, name = "DunMorogh" };
MINIMAP_SCALES[2][8]  = { scale = 0.07670475476181, xoffset = 0.43087243362495, yoffset = 0.73224350550454, name = "Duskwood" };
MINIMAP_SCALES[2][9]  = { scale = 0.10996723642661, xoffset = 0.51663255550387, yoffset = 0.15624753972085, name = "EasternPlaguelands" };
MINIMAP_SCALES[2][10] = { scale = 0.09860350595046, xoffset = 0.41092682316676, yoffset = 0.65651531970162, name = "Elwynn" };
MINIMAP_SCALES[2][11] = { scale = 0.09090931690055, xoffset = 0.42424361247460, yoffset = 0.30113436864162, name = "Hilsbrad" };
MINIMAP_SCALES[2][12] = { scale = 0.02248317426784, xoffset = 0.47481923366335, yoffset = 0.51289242617182, name = "Ironforge" };
MINIMAP_SCALES[2][13] = { scale = 0.07839152145224, xoffset = 0.51118749188138, yoffset = 0.50940913489577, name = "LochModan" };
MINIMAP_SCALES[2][14] = { scale = 0.06170112311456, xoffset = 0.49917278340928, yoffset = 0.68359285304999, name = "Redridge" };
MINIMAP_SCALES[2][15] = { scale = 0.06338794005823, xoffset = 0.46372051266487, yoffset = 0.57812379382509, name = "SearingGorge" };
MINIMAP_SCALES[2][16] = { scale = 0.11931848806212, xoffset = 0.35653502290090, yoffset = 0.24715695496522, name = "Silverpine" };
MINIMAP_SCALES[2][17] = { scale = 0.03819701270887, xoffset = 0.41531450060561, yoffset = 0.67097280492581, name = "Stormwind" };
MINIMAP_SCALES[2][18] = { scale = 0.18128603034401, xoffset = 0.39145470225916, yoffset = 0.79412224886668, name = "Stranglethorn" };
MINIMAP_SCALES[2][19] = { scale = 0.06516347991404, xoffset = 0.51769795272070, yoffset = 0.72815974701615, name = "SwampOfSorrows" };
MINIMAP_SCALES[2][20] = { scale = 0.10937523495111, xoffset = 0.49929119700867, yoffset = 0.25567971676068, name = "Hinterlands" };
MINIMAP_SCALES[2][21] = { scale = 0.12837403412087, xoffset = 0.36837217317549, yoffset = 0.15464954319582, name = "Tirisfal" };
MINIMAP_SCALES[2][22] = { scale = 0.02727719546939, xoffset = 0.42973999245660, yoffset = 0.23815358517831, name = "Undercity" };
MINIMAP_SCALES[2][23] = { scale = 0.12215946583965, xoffset = 0.44270955019641, yoffset = 0.17471356786018, name = "WesternPlaguelands" };
MINIMAP_SCALES[2][24] = { scale = 0.09943208435841, xoffset = 0.36884571674582, yoffset = 0.71874918595783, name = "Westfall" };
MINIMAP_SCALES[2][25] = { scale = 0.11745423014662, xoffset = 0.46561438951659, yoffset = 0.40971063365152, name = "Wetlands" };