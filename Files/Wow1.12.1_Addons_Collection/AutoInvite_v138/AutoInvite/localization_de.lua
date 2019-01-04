-- � = \195\164 (z.B. J�ger = J\195\164ger)
-- � = \195\132 (z.B. �rger = \195\132rger)
-- � = \195\182 (z.B. sch�n = sch\195\182n)
-- � = \195\150 (z.B. �dipus = \195\150dipus)
-- � = \195\188 (z.B. R�stung = R\195\188stung)
-- � = \195\156 (z.B. �bung = \195\156bung)
-- � = \195\159 (z.B. Stra�e = Stra\195\159e) 

if ( GetLocale() == "deDE" ) then

AUTO_INVITE_COMPLETELIST="Komplette Liste (%d)";

AUTO_INVITE_CLASS = {
   DRUID	= "Druide",
   HUNTER	= "J\195\164ger",
   MAGE		= "Magier",
   PALADIN	= "Paladin",
   SHAMAN	= "Schamane",
   PRIEST	= "Priester",
   ROGUE	= "Schurke",
   WARRIOR	= "Krieger",
   WARLOCK	= "Hexenmeister"
};

AUTO_INVITE_DECLINES_YOUR_INVITATION="%a+ lehnt Eure Einladung in die Gruppe ab.";
AUTO_INVITE_DECLINES_YOUR_INVITATION_FIND="^(.+) lehnt Eure Einladung in die Gruppe ab.";
AUTO_INVITE_IGNORES_YOUR_INVITATION="%a+ ignoriert Euch.";
AUTO_INVITE_IGNORES_YOUR_INVITATION_FIND="^(.+) ignoriert Euch.";

AUTO_INVITE_IS_ALREADY_IN_GROUP="%w+ geh\195\182rt bereits zu einer Gruppe.";
AUTO_INVITE_IS_ALREADY_IN_GROUP_FIND="^(.+) geh\195\182rt bereits zu einer Gruppe.";
AUTO_INVITE_SEND_MESSAGE_ALREADY_IN_GROUP="Ich kann dich nicht einladen, da Du schon in einer Gruppe bist, verlasse die bitte";

AUTO_INVITE_GROUP_LEAVE="%w+ verl\195\164sst die Gruppe.";
AUTO_INVITE_GROUP_LEAVE_FIND="(.+) verl\195\164sst die Gruppe.";
AUTO_INVITE_RAID_LEAVE="%w+ hat die Schlachtgruppe verlassen.";
AUTO_INVITE_RAID_LEAVE_FIND="(.+) hat die Schlachtgruppe verlassen.";

AUTO_INVITE_INVITED="Ihr habt %w+ eingeladen, sich Eurer Gruppe anzuschlie\195\159en.";
AUTO_INVITE_INVITED_FIND="Ihr habt (.+) eingeladen, sich Eurer Gruppe anzuschlie\195\159en.";
AUTO_INVITE_GROUP_DISBANDED="Eure Gruppe wurde aufgel\195\182st.";
AUTO_INVITE_GROUP_DISBANDED2="Ihr verlasst die Gruppe.";
AUTO_INVITE_RAID_DISBANDED="Ihr habt die Schlachtgruppe verlassen.";

AUTO_INVITE_GONE_OFFLINE="%w+ has gone offline.";
AUTO_INVITE_IS_OFFLINE=".+ ist nicht auffindbar.";
AUTO_INVITE_IS_OFFLINE_FIND="'(.+)' ist nicht auffindbar.";
AUTO_INVITE_ADDMEMBER_LABEL="Spieler der in die Liste aufgenommen werden soll:";
AUTO_INVITE_SAVEDESCRPTION_LABEL="Beschreibung f\195\188r die aktuelle Gruppenzusammenstellung";

AUTO_INVITE_UNKNOWN_ENTITY="Unbekannte Entit\195\164t"
end
