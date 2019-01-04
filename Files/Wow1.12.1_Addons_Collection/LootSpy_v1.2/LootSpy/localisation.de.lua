-- LootSpy Localisation
-- By: Tehl of Defias Brotherhood (Thanks to: Ooso)
-- Language: deDE
-- Updated: 21/11/06

if ( GetLocale() == "deDE" ) then

-- Slash Command Feedback
LS_ENABLED		=	"LootSpy enabled.";
LS_DISABLED		=	"LootSpy disabled.";
LS_LOCKED		=	"LootSpy locked.";
LS_UNLOCKED		=	"LootSpy unlocked.";
LS_SPAMOFF		=	"LootSpy will display all loot information.";
LS_SPAMON		=	"LootSpy will hide 'x has selected y for [Item]' messages.";
LS_NEWFADE		=	"LootSpy frame fade set to: ";
LS_FADEWRONG	=	"Error: Fade value should be 0 or a time in seconds.";

-- Frame Text
LS_NEED			=	"Bedarf";
LS_GREED		=	"Gier";
LS_PASSED		=	"Passt";
LS_NEEDERS		=	"Bedarf:";

-- Chat String Identification
LS_NEEDSTRING	=	" /'Bedarf/' ausgew�hlt";
LS_GREEDSTRING	=	" /'Gier/' ausgew�hlt";
LS_PASSEDSTRING	=	" passt f�r ";
LS_ALLPASSED	=	"Jeder passt f�r ";
LS_ITEMWON1		=	" gewinnt:";
LS_ITEMWON2		=	"UNUSED_IN_THIS_LOCALE";

LootSpy_GetLootData = function(arg) 
		arg = string.gsub(arg," hat f�r ",":");
		arg = string.gsub(arg," habt f�r ",":");
		arg = string.gsub(arg," passt f�r ",":");
		arg = string.gsub(arg,"' ausgew�hlt","");
		arg = string.gsub(arg,"/'","|");
		arg = string.gsub(arg,"Ihr",UnitName("player"));
		local playerName = string.sub(arg,1,strfind(arg,":")-1);
		local itemName = string.sub(arg,strfind(arg,":")+1,strfind(arg,"|")-1);
		local rollType = string.sub(arg,strfind(arg,"|")+1,string.len(arg));
		return itemName,playerName,rollType;
end

end