--[[

FilterKnown v1.2 Rev

by Zyph

All Copyrights to Merrem.

German Translation - dns13
French Translation - http://translate.google.com/ ^^

--]]

	FILTERKNOWN_HELPMSG = "Usage:\n \/fk green - Sets color to green \n \/fk blue - Sets color to blue \n \/fk red - Sets color to red \n \/fk gray - Sets Color to Dark Gray \n \/fk black - Sets color to Black";

if ( GetLocale() == "frFR" ) then

	FILTERKNOWN_HELPMSG = "Utilisation:\n \/fk green - Place la couleur au vert \n \/fk blue - Place la couleur au bleu \n \/fk red - Place la couleur au rouge";

elseif (GetLocale() == "deDE") then

	-- � - \195\188
	-- � - \195\156
	-- � - \195\182
	-- � - \195\150
	-- � - \195\164
	-- � - \195\134
	-- � - \195\159

	FILTERKNOWN_HELPMSG = "Benutzung:\n \/fk green - Setzt untermalung gr\195\188n \n \/fk blue - Setzt untermalung blau \n \/fk red - Setzt untermalung rot";

end