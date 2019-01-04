
-- ************************************* Const / defines *************************************
TITAN_RUNEPORTALCOUNTER_ALERT = 5;


TITAN_RUNEPORTALCOUNTER_ITEMNAME = "Rune of Portals";
TITAN_RUNEPORTALCOUNTER_BUTTON_LABEL = TITAN_RUNEPORTALCOUNTER_ITEMNAME..": ";
TITAN_RUNEPORTALCOUNTER_TOOLTIP_COUNT = TITAN_RUNEPORTALCOUNTER_ITEMNAME..": ";
TITAN_RUNEPORTALCOUNTER_TOOLTIPTEXT= "Current count of "..TITAN_RUNEPORTALCOUNTER_ITEMNAME;
TITAN_RUNEPORTALCOUNTER_MENU_TEXT = "Mage: "..TITAN_RUNEPORTALCOUNTER_ITEMNAME;

if ( GetLocale() == "deDE" ) then
    TITAN_RUNEPORTALCOUNTER_ITEMNAME = "Rune der Portale";
    TITAN_RUNEPORTALCOUNTER_BUTTON_LABEL = TITAN_RUNEPORTALCOUNTER_ITEMNAME..": ";
    TITAN_RUNEPORTALCOUNTER_TOOLTIP_COUNT = TITAN_RUNEPORTALCOUNTER_ITEMNAME..": ";
    TITAN_RUNEPORTALCOUNTER_TOOLTIPTEXT= "Aktuelle Anzahl von"..TITAN_RUNEPORTALCOUNTER_ITEMNAME;
    TITAN_RUNEPORTALCOUNTER_MENU_TEXT = "Magier: "..TITAN_RUNEPORTALCOUNTER_ITEMNAME;
end

if ( GetLocale() == "frFR" ) then
TITAN_RUNEPORTALCOUNTER_ITEMNAME = "Rune des portails";
TITAN_RUNEPORTALCOUNTER_BUTTON_LABEL = TITAN_RUNEPORTALCOUNTER_ITEMNAME..": ";
TITAN_RUNEPORTALCOUNTER_TOOLTIP_COUNT = TITAN_RUNEPORTALCOUNTER_ITEMNAME..": ";
TITAN_RUNEPORTALCOUNTER_TOOLTIPTEXT= "Compte courant de "..TITAN_RUNEPORTALCOUNTER_ITEMNAME;
TITAN_RUNEPORTALCOUNTER_MENU_TEXT = "Mage: "..TITAN_RUNEPORTALCOUNTER_ITEMNAME;
end