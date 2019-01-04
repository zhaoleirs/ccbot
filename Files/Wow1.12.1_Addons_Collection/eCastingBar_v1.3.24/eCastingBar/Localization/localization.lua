-- Version : English
-- Last Update : 11/25/2005


-- Start Not Localized --
strTab = "	";
strWhite = "|cffffffff";
strYellow = "|cffffff00";
strGreen = "|cff00ff00";
-- End Not Localized --

CASTINGBAR_HEADER = strWhite.."eCastingBar v"..strGreen..CASTING_BAR_MAJOR_VERSION..strWhite.."."..strGreen..CASTING_BAR_MINOR_VERSION.."."..strGreen..CASTING_BAR_REVISION..strWhite;

CASTINGBAR_CHAT_C1				= "config";
CASTINGBAR_CHAT_C2				= "help";


-- Help Text
CASTINGBAR_LOADED = "Loaded."; 
CASTINGBAR_HELP = {

	strLine1 = strYellow.."--- "..CASTINGBAR_HEADER..strYellow.." --- ",
	strLine2 = strWhite..strTab..CASTINGBAR_CHAT_C1..strYellow.." - Shows the config window"..strWhite

};


-- genral buttons
CASTINGBAR_GENERAL_BUTTON               = "General"
CASITINGBARMIRROR_BUTTON                = "Mirror"
CASTINGBAR_COLOR_BUTTON                 = "Colors"
CASTINGBAR_DEFAULTS_BUTTON              = "Defaults"
CASTINGBAR_CLOSE_BUTTON                 = "Close"
CASTINGBAR_SAVE_BUTTON                  = "Save Settings"
CASTINGBAR_LOAD_BUTTON                  = "Load"
CASTINGBAR_DELETE_BUTTON                = "Delete"


-- options
CASTING_BAR_BUTTONS = {
  ["Locked"] = "Hide Outline",
  ["Enabled"] = "Enabled",
  ["UsePerlTexture"] = "Use Perl Texture",
  ["ShowTime"] = "Show Time",
  ["HideBorder"] = "Hide Border",
  ["ShowDelay"] = "Show Delay",
  ["ShowSpellRank"] = "Show Spell Rank",
  ["UseFriendlyEnemy"] = "Use Friendly/Enemy",
  ["MirrorLocked"] = "Hide Outline",
  ["MirrorEnabled"] = "Enabled",
  ["MirrorUsePerlTexture"] = "Use Perl Texture",
  ["MirrorShowTime"] = "Show Time",
  ["MirrorHideBorder"] = "Hide Border",
}


CASTINGBAR_SLIDER_WIDTH_TEXT            = "width"
CASTINGBAR_SLIDER_HEIGHT_TEXT           = "height"
CASTINGBAR_SLIDER_LEFT_TEXT             = "x"
CASTINGBAR_SLIDER_BOTTOM_TEXT           = "y"
CASTINGBAR_SLIDER_FONT_TEXT             = "font size"
CASTINGBAR_SPELL_LENGTH_TEXT            = "Spell Length"
CASTINGBAR_SPELL_JUSTIFY_TEXT           = "Spell Justify"
CASTINGBARMIRROR_SPELL_LENGTH_TEXT      = "Spell Length"
CASTINGBARMIRROR_SPELL_JUSTIFY_TEXT     = "Spell Justify"

-- color
CASTINGBAR_COLOR_LABEL = {
  ["SpellColor"] = "Spell",
  ["ChannelColor"] = "Channel",
  ["SuccessColor"] = "Success",
  ["FailedColor"] = "Failed",
  ["TimeColor"] = "Time",
  ["DelayColor"] = "Delay",
  ["FlashBorderColor"] = "Flash Border",
  ["FeignDeathColor"] = "Feign Death",
  ["ExhaustionColor"] = "Exhaustion",
  ["BreathColor"] = "Breath",
  ["MirrorTimeColor"] = "Mirror Time",
  ["MirrorFlashBorderColor"] = "Mirror Flash Border",
  ["FriendColor"] = "Friend",
  ["EnemyColor"] = "Enemy",
}

CASTINGBAR_SPELL_JUSTIFY = {
		{ text = "Left", value = "Left"},
		{ text = "Center", value = "Center"},
		{ text = "Right", value = "Right"}
	};