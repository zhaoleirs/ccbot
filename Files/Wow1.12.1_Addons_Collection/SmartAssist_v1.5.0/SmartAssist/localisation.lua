CLASSNAME_HUNTER 		= "Hunter";
CLASSNAME_WARLOCK 		= "Warlock";
CLASSNAME_MAGE	 		= "Mage";
CLASSNAME_ROGUE 		= "Rogue";
CLASSNAME_PRIEST 		= "Priest";
CLASSNAME_PALADIN 		= "Paladin";
CLASSNAME_DRUID 		= "Druid";
CLASSNAME_WARRIOR 		= "Warrior";
CLASSNAME_SHAMAN 		= "Shaman";

SPELL_AUTOSHOT			= "Auto Shot";

EMOTE_EVERYONE_ATTACK	= "tells everyone to attack"; -- this might not be even needed!?
EMOTE_ATTACK			= "tells you to attack";
EMOTE_HELP				= "cries out for help!";
EMOTE_OWN				= "You";

SA_HELP_STRINGS			= {	"Some addons may interfere with drag routines. If you experience weird behaviour try to drag without releasing mouse button.\n\nIf visible list gets disorted switch to different tab and then back to SmartActions. Sorry about inconvenience.",
							"Note: you can set both modifiers to be same key but then you will be unable to perform few tasks. Ie. select player unit and simultaneously cast auto assist spell."};

-- all known attacks that are usefull to be casted on enemy

AUTOCONF_ATTACKS = {};

--[[ hunter ]]--
AUTOCONF_ATTACKS["Auto Shot"] = 1;
AUTOCONF_ATTACKS["Arcane Shot"] = 1;
AUTOCONF_ATTACKS["Concussive Shot"] = 1;
AUTOCONF_ATTACKS["Aimed Shot"] = 1;
AUTOCONF_ATTACKS["Multi-Shot"] = 1;
AUTOCONF_ATTACKS["Serpent Sting"] = 1;
AUTOCONF_ATTACKS["Viper Sting"] = 1;
AUTOCONF_ATTACKS["Scorpid Sting"] = 1;
AUTOCONF_ATTACKS["Scatter Shot"] = 1;
AUTOCONF_ATTACKS["Hunter's Mark"] = 1;
--[[ druid ]]--
AUTOCONF_ATTACKS["Wrath"] = 1;
AUTOCONF_ATTACKS["Moonfire"] = 1;
AUTOCONF_ATTACKS["Starfire"] = 1;
AUTOCONF_ATTACKS["Entangling Roots"] = 1;
AUTOCONF_ATTACKS["Faerie Fire"] = 1;
AUTOCONF_ATTACKS["Hibernate"] = 1;
--[[ mage ]]--
AUTOCONF_ATTACKS["Fireball"] = 1;
AUTOCONF_ATTACKS["Frostbolt"] = 1;
AUTOCONF_ATTACKS["Arcane Missiles"] = 1;
AUTOCONF_ATTACKS["Polymorph"] = 1;
AUTOCONF_ATTACKS["Scorch"] = 1;
--[[ paladin ]]--
AUTOCONF_ATTACKS["Hammer of Wrath"] = 1;
--[[ priest ]]--
AUTOCONF_ATTACKS["Shadow Word: Pain"] = 1;
AUTOCONF_ATTACKS["Smite"] = 1;
AUTOCONF_ATTACKS["Starshards"] = 1;
AUTOCONF_ATTACKS["Holy Fire"] = 1;
AUTOCONF_ATTACKS["Silence"] = 1;
AUTOCONF_ATTACKS["Hex of Weakness"] = 1;
AUTOCONF_ATTACKS["Mana Burn"] = 1;
--[[ warlock ]]--
AUTOCONF_ATTACKS["Searing Pain"] = 1;
AUTOCONF_ATTACKS["Shadowburn"] = 1;
AUTOCONF_ATTACKS["Drain Soul"] = 1;
AUTOCONF_ATTACKS["Drain Life"] = 1;
AUTOCONF_ATTACKS["Curse of Weakness"] = 1;
AUTOCONF_ATTACKS["Shadow Bolt"] = 1;
AUTOCONF_ATTACKS["Immolate"] = 1;
AUTOCONF_ATTACKS["Siphon Life"] = 1;
AUTOCONF_ATTACKS["Conflagrate"] = 1;
AUTOCONF_ATTACKS["Curse of Doom"] = 1;
--[[ shaman ]]--
AUTOCONF_ATTACKS["Earth Shock"] = 1;
AUTOCONF_ATTACKS["Lightning Bolt"] = 1;
AUTOCONF_ATTACKS["Frost Shock"] = 1;
						
-- all known buffs that are usefull to be casted on players under attack

AUTOCONF_BUFFS = {};
--[[ druid ]]--
AUTOCONF_BUFFS["Healing Touch"] = 1;
AUTOCONF_BUFFS["Rejuvenation"] = 1;
AUTOCONF_BUFFS["Regrowth"] = 1;
AUTOCONF_BUFFS["Rebirth"] = 1;
--[[ paladin ]]--
AUTOCONF_BUFFS["Devotion Aura"] = 1;
AUTOCONF_BUFFS["Holy Light"] = 1;
AUTOCONF_BUFFS["Blessing of Salvation"] = 1;
AUTOCONF_BUFFS["Divine Intervention"] = 1;
AUTOCONF_BUFFS["Blessing of Light"] = 1;
AUTOCONF_BUFFS["Flash of Light"] = 1;
AUTOCONF_BUFFS["Blessing of Sanctuary"] = 1;
--[[ priest ]]--
AUTOCONF_BUFFS["Power Word: Shield"] = 1;
AUTOCONF_BUFFS["Power Word: Fortitude"] = 1;
AUTOCONF_BUFFS["Renew"] = 1;
AUTOCONF_BUFFS["Lesser Heal"] = 1;
AUTOCONF_BUFFS["Cure Disease"] = 1;
AUTOCONF_BUFFS["Heal"] = 1;
AUTOCONF_BUFFS["Desperate Prayer"] = 1;
AUTOCONF_BUFFS["Flash Heal"] = 1;
AUTOCONF_BUFFS["Dispel Magic"] = 1;
--[[ shaman ]]--
AUTOCONF_BUFFS["Healing Wave"] = 1;
AUTOCONF_BUFFS["Purge"] = 1;
AUTOCONF_BUFFS["Cure Poison"] = 1;
AUTOCONF_BUFFS["Chain Heal"] = 1;
					
-- simple localization, todo: move to external file ?

if (GetLocale() == "frFR") then
	-- CLASSNAME_HUNTER = "Chasseur";
elseif (GetLocale() == "deDE") then
	CLASSNAME_HUNTER 		= "J\195\164ger";
	CLASSNAME_WARLOCK 		= "Hexenmeister";
	CLASSNAME_MAGE	 		= "Magier";
	CLASSNAME_ROGUE 		= "Schurke";
	CLASSNAME_PRIEST 		= "Priester";
	CLASSNAME_PALADIN 		= "Paladin";
	CLASSNAME_DRUID 		= "Druide";
	CLASSNAME_WARRIOR 		= "Krieger";
	CLASSNAME_SHAMAN 		= "Schamane";
	
	SPELL_AUTOSHOT			= "Automatischer Schuss";
	
	EMOTE_EVERYONE_ATTACK	= "sagt allen, dass sie";
	EMOTE_ATTACK			= "sagt allen, dass sie";
	EMOTE_HELP				= "ruft um hilfe!";
	EMOTE_OWN				= "Ihr";
end

