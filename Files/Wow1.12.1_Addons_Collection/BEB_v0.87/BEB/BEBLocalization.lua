
BEB_SELECTOR_LABELS = {
	BEBGeneralSelector =			"General",
	BEBColorsSelector =				"Colors",
	BEBPlacementSelector =			"Size/Position"
}

BEB_BUTTONLABELS = {
	BEBBackgroundColorButton =		"Background color.",
	BEBXpUnrestedColorButton =		"Unrested.",
	BEBXpRestedColorButton =			"Rested.",
	BEBXpMaxRestedColorButton =		"Fully rested.",
	BEBRestedBarColorButton =		"Rested.",
	BEBRestedBarMaxColorButton =		"Fully rested.",
	BEBMarkerUnrestColorButton =		"Unrested.",
	BEBMarkerRestColorButton =		"Rested.",
	BEBMarkerMaxrestColorButton =		"Fully rested.",
	BEBTickUnrestColorButton =		"Unrested.",
	BEBTickRestColorButton =			"Rested.",
	BEBTickMaxrestColorButton =		"Fully rested.",
	BEBRestedTickRestColorButton =	"Rested.",
	BEBRestedTickMaxrestColorButton =	"Fully rested.",
	BEBBarTextUnrestColorButton =		"Unrested.",
	BEBBarTextRestColorButton =		"Rested.",
	BEBBarTextMaxrestColorButton =	"Fully rested."
}

BEB_HEADINGS = {
	BEBXpBarHeading =				"Experience bar.",
	BEBRestedBarHeading =			"Rested experience bar.",
	BEBMarkerHeading =				"Marker artwork.",
	BEBTickHeading =				"Tick on the end of the experience bar.",
	BEBRestedTickHeading =			"Tick indicating where rested experience ends.",
	BEBBarTextHeading =				"Text that is shown on the bar.",
	BEBMainSizeHeading =			"Overall size.",
	BEBTickSizeHeading =			"Tick size.",
	BEBMainPositionControlsTitle =	"Overall Position.",
	BEBTickPositionControlsTitle =	"Tick Position.",
	BEB_MainAttachPointButton_Label =	"Bar's attach point",
	BEB_MainAttachToPointButton_Label ="Bar's relative point",
	BEB_MainAttachToFrame_Label =		"Attach to frame",
	BEB_TextStringFrame_Label =		"The text that will show on the bar."
}
BEB_CHECKBUTTONLABELS = {
	BEBEnabledButton =				"Enabled",
	BEBShowMarksButton =			"Show Marks",
	BEBShowXpTicksButton =			"Show tick at the end of the Xp bar.",
	BEBShowRestedXpTicksButton =		"Show tick where rested Xp will get you.",
	BEBShowBackgroundButton =		"Show a background behind the bar.",
	BEBShowXpTextButton	 =			"Show text on the bar.",
	BEBFlashHighlightButton =		"Flash the rested xp tick when resting.",
	BEBTextOnMouseoverButton =		"Show text only when moused over.",
	BEBShowRestedBarButton =			"Show the rested Xp bar.",
	BEBUnlockBarButton =			"Allow the bar to be dragged."
}



BEB_TEXT = {
	height =						"Height",
	width =						"Width",
	fontsize =					"Font Size",
	validcommands =				"Valid commands are /beb [defaults, enbale, disable, help]. /beb by itself will open the config screen.",
	invalidcommand =				"Invalid command, use ,/beb help, for a list of commands",
	xpnomatch1 =					"Table and in game Xp per level do not match, send an email to futrtrubl@hotmail.com with; BEB: LVL= ",
	xpnomatch2 =					", TableXp= ",
	xpnomatch3 =					", ActualXp = ",
	alreadyenabled =				"BEB is already enabled.",
	alreadydisabled =				"BEB is already disabled.",
	framelocked =					"The BEB frame is locked. Unlock it if you wish to move it",
	loaded =						"BEB Loaded",
	optionstextwasmouseover =		"BEB: Text was being shown on mouseover, this has been disabled",
	optionstextwashidden =			"BEB: Text was set to never show. Text is now enabled",
	framewasinvalid =				"BEB: The frame that BEB was attached to does not exist or is invalid. Please use /beb and change the frame BEB is attached to.",
	frameisinvalid =				"BEB: The frame you entered does not exist or is invalid.",
	rested =						"Rested",
	unrested =					"Unrested",
	fullyrested =					"Fully Rested",
	resting =						"Resting"
}

BEB_ATTACHPOINTS = {
	TOP =						"Top",
	BOTTOM =						"Bottom",
	LEFT =						"Left",
	RIGHT =						"Right",
	TOPLEFT =						"Top left",
	TOPRIGHT =					"Top right",
	BOTTOMLEFT =					"Bottom left",
	BOTTONRIGHT =					"Bottom right",
	CENTER =						"Center"
}

BEB_UIATTACHFRAMES = {
	UIParent =					"UI Parent",
	MainMenuExpBar =				"UI Experience bar",
	MainMenuBar =					"UI Main bar",
	ChatFrame1 =					"UI Chat frame",
	MinimapCluster =				"UI Minimap"
}

BEB_VARIABLE_FUNCTIONS_DESCIPTIONS = {
	["$plv"] =					"$plv Character's level.",
	["$cxp"] =					"$cxp Current xp for this level.",
	["$mxp"] =					"$mxp Total xp needed for this level.",
	["$rxp"] =					"$rxp Rested xp as reported by the game.",
	["$Rxp"] =					"$Rxp Actual current rested xp.",
	["$Cxp"] =					"$Cxp Total xp ever earned for this character.",
	["$Mxp"] =					"$Mxp Xp to go until you can earn no more.",
	["$txp"] =					"$txp Xp needed to level.",
	["$Txp"] =					"$Txp Xp needed to reach level 60.",
	["$pdl"] =					"$pdl Percent of the way through the current level.",
	["$Pdl"] =					"$Pdl Percent of the way to the end of level 60.",
	["$ptl"] =					"$ptl Percent of the level left to complete.",
	["$res"] =					"$res Shows 'Resting' if you are currently resting.",
	["$rst"] =					"$rst Shows 'Unrested', 'Rested' or 'Fully Rested'.",
	["$ptx"] =					"$ptx Pet's current xp for this level.",
	["$pty"] =					"$pty Pet's total xp needed for this level.",
	["$ppc"] =					"$ppc Pet's % of the way through the current level.",
	["$ppn"] =					"$ppn Pet's % of the level left to complete.",
	["$pxg"] =					"$pxg Pet's xp needed to level."
}
if (GetLocale() == "deDE") then
end

if (GetLocale() == "frFR") then
BEB_SELECTOR_LABELS = {
	BEBGeneralSelector =			"G�n�ral",
	BEBColorsSelector =				"Couleurs",
	BEBPlacementSelector =			"Calibre/Position"
}

BEB_BUTTONLABELS = {
	BEBBackgroundColorButton =		"Couleur de fond.",
	BEBXpUnrestedColorButton =		"Peu repos�.",
	BEBXpRestedColorButton =			"Repos�.",
	BEBXpMaxRestedColorButton =		"Enti�rement repos�.",
	BEBRestedBarColorButton =		"Repos�.",
	BEBRestedBarMaxColorButton =		"Enti�rement repos�.",
	BEBMarkerUnrestColorButton =		"Peu repos�.",
	BEBMarkerRestColorButton =		"Repos�.",
	BEBMarkerMaxrestColorButton =		"Enti�rement repos�.",
	BEBTickUnrestColorButton =		"Peu repos�.",
	BEBTickRestColorButton =			"RRepos�.",
	BEBTickMaxrestColorButton =		"Enti�rement repos�.",
	BEBRestedTickRestColorButton =	"Repos�.",
	BEBRestedTickMaxrestColorButton =	"Enti�rement repos�.",
	BEBBarTextUnrestColorButton =		"Peu repos�.",
	BEBBarTextRestColorButton =		"Repos�.",
	BEBBarTextMaxrestColorButton =	"Enti�rement repos�."
}

BEB_HEADINGS = {
	BEBXpBarHeading =				"Barre d'exp�rience.",
	BEBRestedBarHeading =			"Barre d'exp�rience repos�e.",
	BEBMarkerHeading =				"Travail d'art de borne.",
	BEBTickHeading =				"Tictaquer sur la fin de la barre d'exp�rience.",
	BEBRestedTickHeading =			"Tictaquer indiquer o� l'exp�rience repos�e termine.",
	BEBBarTextHeading =				"Le texte qui est montr� sur la barre.",
	BEBMainSizeHeading =			"Taille g�n�rale.",
	BEBTickSizeHeading =			"Tictaquer la taille.",
	BEBMainPositionControlsTitle =	"Position g�n�rale.",
	BEBTickPositionControlsTitle =	"Tictaquer la Position.",
	BEB_MainAttachPointButton_Label =	"Barre attache le point.",
	BEB_MainAttachToPointButton_Label ="Le point relatif de la barre.",
	BEB_MainAttachToFrame_Label =		"Attacher pour encadrer",
	BEB_TextStringFrame_Label =		"Le texte qui montrera sur la barre."
}
BEB_CHECKBUTTONLABELS = {
	BEBEnabledButton =				"Rendu capable",
	BEBShowMarksButton =			"Montrer les Marques",
	BEBShowXpTicksButton =			"Montrer le tictaquer � la fin du la barre Xp.",
	BEBShowRestedXpTicksButton =		"Montrer le tictaquer o� repos� Xp vous obtiendra.",
	BEBShowBackgroundButton =		"Montrer un fond derri�re la barre.",
	BEBShowXpTextButton	 =			"Montrer le texte sur la barre.",
	BEBFlashHighlightButton =		"Clignoter le tictaquer xp repos� en se reposant.",
	BEBTextOnMouseoverButton =		"Montrer le texte seulement quand moused par-dessus.",
	BEBShowRestedBarButton =			"Montrer la barre de Xp repos�.",
	BEBUnlockBarButton =			"Permettre � la barre �tre tra�n�."
}



BEB_TEXT = {
	height =						"Hauteur",
	width =						"Largeur",
	fontsize =					"Taille de texte",
	validcommands =				"Les ordres valides sont /beb [defaults, enbale, disable, help]. /beb ouvrira tout seul l'�cran de config.",
	invalidcommand =				"L'ordre nul, utiliser /beb help pour une liste d'ordres",
	xpnomatch1 =					"Ajourner et ingame Xp par ne nivelle pas l'allumette, envoyer un e-mail � futrtrubl@hotmail.com avec; BEB: LVL= ",
	xpnomatch2 =					", XpAjourner = ",
	xpnomatch3 =					", XpV�ritable = ",
	alreadyenabled =				"BEB d�j� est rendu capable.",
	alreadydisabled =				"BEB d�j� est rendu infirme.",
	framelocked =					"Le cadre de BEB est verrouill�. L'ouvrir si vous souhaitez le d�placer.",
	loaded =						"BEB est charg�",
	optionstextwasmouseover =		"BEB: Le texte �tait montr� sur mouseover, ceci a �t� rendu infirme.",
	optionstextwashidden =			"BEB: Le texte a �t� r�gl� pour ne jamais montrer. Le texte maintenant est rendu capable.",
	framewasinvalid =				"BEB: Le cadre que BEB a �t� attach� � n'existe pas ou est nul. S'il vous pla�t l'usage /beb et change le cadre que BEB est attach� �.",
	frameisinvalid =				"BEB: Le cadre que vous �tes entr� n'existe pas ou est nul.",
	rested =						"Repos�",
	unrested =					"Peu repos�",
	fullyrested =					"Enti�rement Repos�",
	resting =						"Reposant"
}

BEB_ATTACHPOINTS = {
	TOP =						"Superieur",
	BOTTOM =						"Inf�rieur",
	LEFT =						"Gauche",
	RIGHT =						"Droite",
	TOPLEFT =						"Superieur gauch",
	TOPRIGHT =					"Superieur droit",
	BOTTOMLEFT =					"Inf�rieur gauch",
	BOTTONRIGHT =					"Inf�rieur droit",
	CENTER =						"Centre"
}

BEB_UIATTACHFRAMES = {
	UIParent =					"UI Parent",
	MainMenuExpBar =				"UI Barre d'exp�rience",
	MainMenuBar =					"UI Barre principale",
	ChatFrame1 =					"UI Cadre de bavarder",
	MinimapCluster =				"UI Petite carte"
}

BEB_VARIABLE_FUNCTIONS_DESCIPTIONS = {
	["$plv"] =					"$plv Niveau du caract�re.",
	["$cxp"] =					"$cxp Le courant xp pour ce niveau.",
	["$mxp"] =					"$mxp Totaliser xp a eu besoin de pour ce niveau.",
	["$rxp"] =					"$rxp Repos� xp comme rapport� par le jeu.",
	["$Rxp"] =					"$Rxp Le v�ritable courant s'est repos� xp. ",
	["$Cxp"] =					"$Cxp Totaliser xp jamais a gagn� pour ce caract�re.",
	["$Mxp"] =					"$Mxp Xp aller jusqu'� ce que vous pouvez gagner non plus.",
	["$txp"] =					"$txp Xp a eu besoin de niveler.",
	["$Txp"] =					"$Txp Xp a eu besoin d'atteindre nivelle 60.",
	["$pdl"] =					"$pdl Le pourcent de la fa�on par le niveau actuel.",
	["$Pdl"] =					"$Pdl Le pourcent de la fa�on � la fin de niveau 60.",
	["$ptl"] =					"$ptl Le pourcent du niveau part compl�ter.",
	["$res"] =					"$res Les spectacles se 'Reposant' si vous vous reposez actuellement.",
	["$rst"] =					"$rst Les spectacles 'peu Repos�', 'Repos�' ou 'Repos� Enti�rement'.",
	["$ptx"] =					"$ptx Le courant de l'animal favori xp pour ce niveau.",
	["$pty"] =					"$pty Le total de l'animal favori xp a eu besoin de pour ce niveau.",
	["$ppc"] =					"$ppc Animal favori % de la fa�on par le niveau actuel.",
	["$ppn"] =					"$ppn Animal favori % du niveau part compl�ter.",
	["$pxg"] =					"$pxg Animal favori xp a eu besoin de niveler."
}
end

BEB_ARROWLEFT =					"<"
BEB_ARROWRIGHT =					">"

BEB_VARIABLE_FUNCTIONS = {
	["$plv"] = {
		func =	function() return UnitLevel("player") end,
		events =	{"PLAYER_LEVEL_UP"}
	},

	["$cxp"] = {
		func =	function()
					if (UnitXP("player")) then
						return UnitXP("player")
					else
						return 0
					end
				end,
		events =	{"PLAYER_LEVEL_UP", "PLAYER_XP_UPDATE"}
	},

	["$mxp"] = {
		func =	function() return UnitXPMax("player") end,
		events =	{"PLAYER_LEVEL_UP"}
	},

	["$rxp"] = {
		func =	function()
					if (GetXPExhaustion()) then
						return GetXPExhaustion()
					else
						return 0
					end
				end,
		events =	{"PLAYER_LEVEL_UP", "PLAYER_XP_UPDATE", "UPDATE_EXHAUSTION"}
	},

	["$Rxp"] = {
		func =	function()
					if (GetXPExhaustion()) then
						return (GetXPExhaustion()/2)
					else
						return 0
					end
				end,
		events =	{"PLAYER_LEVEL_UP", "PLAYER_XP_UPDATE", "UPDATE_EXHAUSTION"}
	},

	["$Cxp"] = {
		func =	function()
					local xpdone
					if (UnitXP("player")) then
						xpdone = UnitXP("player")
					else
						xpdone = 0
					end
					for i=1,(UnitLevel("player")-1) do
						xpdone = xpdone + BEBXpPerLvl[i]
					end
					return xpdone
				end,
		events =	{"PLAYER_LEVEL_UP", "PLAYER_XP_UPDATE"}
	},

	["$Mxp"] = {
		func =	function()
					local xptodo
					if (UnitXP("player")) then
						xptodo = UnitXPMax("player") - UnitXP("player")
					else
						xptodo = UnitXPMax("player")
					end
					for i=(UnitLevel("player")+1),60 do
						xptodo = xptodo + BEBXpPerLvl[i]
					end
					return xptodo
				end,
		events =	{"PLAYER_LEVEL_UP", "PLAYER_XP_UPDATE"}
	},

	["$txp"] = {
		func =	function()
					if (UnitXP("player")) then
						return UnitXPMax("player") - UnitXP("player")
					else
						return UnitXPMax("player")
					end
				end,
		events =	{"PLAYER_LEVEL_UP", "PLAYER_XP_UPDATE"}
	},

	["$Txp"] = {
		func =	function()
					local xptodo
					if (UnitXP("player")) then
						xptodo = UnitXPMax("player") - UnitXP("player")
					else
						xptodo = UnitXPMax("player")
					end
					for i=(UnitLevel("player")+1),59 do
						xptodo = xptodo + BEBXpPerLvl[i]
					end
					return xptodo
				end,
		events =	{"PLAYER_LEVEL_UP", "PLAYER_XP_UPDATE"}
	},

	["$pdl"] = {
		func =	function()
					if (UnitXP("player")) then
						return math.floor((UnitXP("player")/UnitXPMax("player"))*100)
					else
						return 0
					end
				end,
		events =	{"PLAYER_LEVEL_UP", "PLAYER_XP_UPDATE"}
	},

	["$Pdl"] = {
		func =	function()
					local xpdone
					if (UnitXP("player")) then
						xpdone = UnitXP("player")
					else
						xpdone = 0
					end
					for i=1,(UnitLevel("player")-1) do
						xpdone = xpdone + BEBXpPerLvl[i]
					end
					return math.floor((xpdone/4302200)*100)
				end,
		events =	{"PLAYER_LEVEL_UP", "PLAYER_XP_UPDATE"}
	},

	["$ptl"] = {
		func =	function()
					if (UnitXP("player")) then
						return math.floor(((UnitXPMax("player") - UnitXP("player"))/UnitXPMax("player"))*100)
					else
						return 0
					end
				end,
		events =	{"PLAYER_LEVEL_UP", "PLAYER_XP_UPDATE"}
	},

	["$res"] = {
		func =	function()
					if (IsResting() == 1) then
						return BEB_TEXT.resting
					else
						return ""
					end
				end,
		events =	{"PLAYER_UPDATE_RESTING"}
	},

	["$rst"] = {
		func =	function()
					if (GetRestState() == 1) then
						if (GetXPExhaustion() == (UnitXPMax("player")*1.5)) then
							return BEB_TEXT.fullyrested
						else
							return BEB_TEXT.rested
						end
					else
						return BEB_TEXT.unrested
					end
				end,
		events =	{"UPDATE_EXHAUSTION"}
	},
	-- Pet Current XP
	["$ptx"] = {
		func =	function()
					if (GetPetExperience()) then
						local x = GetPetExperience();
						return x
					else
						return ""
					end
				end,
		events = {"UNIT_PET_EXPERIENCE"}
	},
	-- Pet XP Needed to Level
	["$pty"] = {
		func =	function(text, unit)
					if (GetPetExperience()) then
						local _,x = GetPetExperience();
						return x
					else
						return ""
					end
				end,
		events = {"UNIT_PET_EXPERIENCE"}
	},
	-- Pet XP Percent Complete
	["$ppc"] = {
		func =	function()
					if (GetPetExperience()) then
						local min,max = GetPetExperience();
						if (max and min and max > 0) then
							return math.floor((min / max) * 100);
						else
							return ""
						end
					else
						return ""
					end
				end,
		events = {"UNIT_PET_EXPERIENCE"}
	},
	-- Pet XP Percent Needed
	["$ppn"] = {
		func =	function()
					if (GetPetExperience()) then
						local min,max = GetPetExperience();
						if (max and min and max > 0) then
							return math.floor(((max-min)/max)*100);
						else
							return ""
						end
					else
						return ""
					end
				end,
		events = {"UNIT_PET_EXPERIENCE"}
	},
	-- Pet XP To Go
	["$pxg"] = {
		func =	function(text, unit)
					if (GetPetExperience()) then
						local min,max = GetPetExperience();
						if (max and min and max > 0) then
							return (max - min);
						else
							return ""
						end
					else
						return ""
					end
				end,
		events = {"UNIT_PET_EXPERIENCE"}
	}
}