﻿--<< General Variables -- hey Chico I put icons in! ;) >>--
TITAN_COMBATINFO_ID = "CombatInfo";
TITAN_COMBATINFO_BUTTON_TEXT="%s";
TITAN_COMBATINFO_BUTTON_ICON="Interface\\Icons\\Ability_Rogue_FeignDeath.blp";
TITAN_COMBATINFO_TEXT="%d";
TITAN_COMBATINFO_ATKPWR_MAGIC = 14;
TITAN_COMBATINFO_RANGESPEED="%.3g";
TITAN_COMBATINFO_RANGEDMG="%d-%d";
TITAN_COMBATINFO_RANGEAVGDMG="%.1f";
TITAN_COMBATINFO_ARMOR="%.3g";
TITAN_COMBATINFO_ARMOR_ICON="";
TITAN_COMBATINFO_BLOCK="%.2f%%";
TITAN_COMBATINFO_BLOCK_ICON="Interface\\Icons\\Ability_Defend.blp";
TITAN_COMBATINFO_CRIT="%.2f%%";
TITAN_COMBATINFO_CRIT_ICON="Interface\\Icons\\Ability_CriticalStrike.blp";
TITAN_COMBATINFO_DODGE="%.2f%%";
TITAN_COMBATINFO_DODGE_ICON="Interface\\Icons\\Spell_Nature_Invisibilty.blp";
TITAN_COMBATINFO_PARRY="%.2f%%";
TITAN_COMBATINFO_PARRY_ICON="Interface\\Icons\\Ability_Parry.blp";
TITAN_COMBATINFO_MELEE_MAINSPEED="%.3g";
TITAN_COMBATINFO_MELEE_MAINAVGDMG="%.3g";
TITAN_COMBATINFO_MELEE_MAINDMG="%d-%d";
TITAN_COMBATINFO_MELEE_OFFHANDSPEED="%.3g";
TITAN_COMBATINFO_MELEE_OFFAVGDMG="%.3g";
TITAN_COMBATINFO_MELEE_OFFHANDDMG="%d-%d";

--<< English Localization >>--
if GetLocale()=="enUS" or GetLocale()=="enGB" then
	TITAN_COMBATINFO_BUTTON_LABEL="Combat Info";
	TITAN_COMBATINFO_TOOLTIP="Combat Info";
	TITAN_COMBATINFO_MENU_TEXT="Combat Info";
	TITAN_COMBATINFO_RANGE_TEXT="Ranged Attack";
	TITAN_COMBATINFO_RANGEDMG_TEXT="Ranged Damage:";
	TITAN_COMBATINFO_RANGEPWR_TEXT="Ranged Attack Power:";
	TITAN_COMBATINFO_RANGEPWR="%d (%d Base)";
	TITAN_COMBATINFO_RANGEATTACKSPEED="Attack Speed (seconds):";
	TITAN_COMBATINFO_RANGEAVGDMG_TEXT="Ranged DPS Average:";
	TITAN_COMBATINFO_ARMOR_TEXT="Armor";
	TITAN_COMBATINFO_BLOCK_TEXT="Chance to Block: ";
	TITAN_COMBATINFO_CRIT_ATTACKTEXT="Attack";
	TITAN_COMBATINFO_CRIT_TEXT="Chance to Crit: ";
	TITAN_COMBATINFO_DODGE_TEXT="Chance to Dodge: ";
	TITAN_COMBATINFO_PARRY_TEXT="Chance to Parry: "
	TITAN_COMBATINFO_MELEE_TEXT="Melee Attack";
	TITAN_COMBATINFO_MELEE_MAINSPEED_TEXT="Mainhand Speed (seconds): ";
	TITAN_COMBATINFO_MELEE_MAINAVGDMG_TEXT="Mainhand DPS Average: ";
	TITAN_COMBATINFO_MELEE_MAINDMG_TEXT="Mainhand Damage: ";
	TITAN_COMBATINFO_MELEE_OFFHANDSPEED_TEXT="Offhand Speed (seconds): ";
	TITAN_COMBATINFO_MELEE_OFFAVGDMG_TEXT="Offhand DPS Average: ";
	TITAN_COMBATINFO_MELEE_OFFHANDDMG_TEXT="Offhand Damage: ";
	TITAN_COMBATINFO_MELEE_POWER_TEXT="Melee Power:";
	TITAN_COMBATINFO_MELEE_POWER="%d (%d Base)";
	TITAN_COMBATINFO_MELEE_POWER="%d (%d Base)";
	TITAN_COMBATINFO_OPTIONS_SHOWBLOCK_TEXT="Show Block %";
	TITAN_COMBATINFO_OPTIONS_SHOWCRIT_TEXT="Show Crit %";
	TITAN_COMBATINFO_OPTIONS_SHOWDODGE_TEXT="Show Dodge %";
	TITAN_COMBATINFO_OPTIONS_SHOWPARRY_TEXT="Show Parry %";
	TITAN_COMBATINFO_OPTIONS_SHOWSTATLABEL_TEXT = "Show Stat Label";
	return
end

--<< French Localization (thanks Vorpale) >>--
if ( GetLocale() == "frFR" ) then
	TITAN_COMBATINFO_BUTTON_LABEL="Infos Combat";
	TITAN_COMBATINFO_TOOLTIP="Infos sur le combat";
	TITAN_COMBATINFO_MENU_TEXT="Infos sur le combat";
	TITAN_COMBATINFO_RANGE_TEXT="Attaque \195\160 distance";
	TITAN_COMBATINFO_RANGEDMG_TEXT="D\195\169gats \195\160 distance:";
	TITAN_COMBATINFO_RANGEPWR_TEXT="Puissance d'attaque \195\160 distance:";
	TITAN_COMBATINFO_RANGEPWR="%d (%d Base)";
	TITAN_COMBATINFO_RANGEATTACKSPEED="Vitesse d'attaque (secondes):";
	TITAN_COMBATINFO_RANGEAVGDMG_TEXT="Dommages moyens \195\169tendus par seconde:";
	TITAN_COMBATINFO_ARMOR_TEXT="Armor";
	TITAN_COMBATINFO_BLOCK_TEXT="Chances de bloquer: ";
	TITAN_COMBATINFO_CRIT_ATTACKTEXT="Attaque";
	TITAN_COMBATINFO_CRIT_TEXT="Chances de critique: ";
	TITAN_COMBATINFO_DODGE_TEXT="Chances d'\195\169viter: ";
	TITAN_COMBATINFO_PARRY_TEXT="Chance de parer: "
	TITAN_COMBATINFO_MELEE_TEXT="Attaques de M\195\170l\195\169e";
	TITAN_COMBATINFO_MELEE_MAINSPEED_TEXT="Vitesse main principale (secondes): ";
	TITAN_COMBATINFO_MELEE_MAINAVGDMG_TEXT="Dommages moyens par Seconde: ";
	TITAN_COMBATINFO_MELEE_MAINDMG_TEXT="D\195\169gats main principale: ";
	TITAN_COMBATINFO_MELEE_OFFHANDSPEED_TEXT="Vitesse main secondaire (secondes): ";
	TITAN_COMBATINFO_MELEE_OFFAVGDMG_TEXT="Dommages moyens par Seconde: ";
	TITAN_COMBATINFO_MELEE_OFFHANDDMG_TEXT="D\195\169gats main secondaire: ";
	TITAN_COMBATINFO_MELEE_POWER_TEXT="Puissance de m\195\170l\195\169e:";
	TITAN_COMBATINFO_MELEE_POWER="%d (%d Base)";
	TITAN_COMBATINFO_MELEE_POWER="%d (%d Base)";
	TITAN_COMBATINFO_OPTIONS_SHOWBLOCK_TEXT="Afficher % Blocage";
	TITAN_COMBATINFO_OPTIONS_SHOWCRIT_TEXT="Afficher % Critique";
	TITAN_COMBATINFO_OPTIONS_SHOWDODGE_TEXT="Afficher % Evasion";
	TITAN_COMBATINFO_OPTIONS_SHOWPARRY_TEXT="Afficher % Parade";
	TITAN_COMBATINFO_OPTIONS_SHOWSTATLABEL_TEXT = "Afficher le label des statistiques";
	return
end

--<< German Localization (thanks hrym) >>--
if ( GetLocale() == "deDE" ) then
	TITAN_COMBATINFO_BUTTON_LABEL="Combat Info";
	TITAN_COMBATINFO_TOOLTIP="Combat Info";
	TITAN_COMBATINFO_MENU_TEXT="Combat Info";
	TITAN_COMBATINFO_RANGE_TEXT="Distanzangriff";
	TITAN_COMBATINFO_RANGEDMG_TEXT="Distanz Schaden:";
	TITAN_COMBATINFO_RANGEPWR_TEXT="Distanzangriffskraft:";
	TITAN_COMBATINFO_RANGEPWR="%d (%d Basis)";
	TITAN_COMBATINFO_RANGEATTACKSPEED="Angriffstempo (Sekunden):";
	TITAN_COMBATINFO_RANGEAVGDMG_TEXT="Distanz Schaden pro Sekunde:";
	TITAN_COMBATINFO_ARMOR_TEXT="R\195\188stung";
	TITAN_COMBATINFO_BLOCK_TEXT="Chance zu blocken: ";
	TITAN_COMBATINFO_CRIT_ATTACKTEXT="Angreifen";
	TITAN_COMBATINFO_CRIT_TEXT="Chance auf kritischen Treffer: ";
	TITAN_COMBATINFO_DODGE_TEXT="Chance auszuweichen: ";
	TITAN_COMBATINFO_PARRY_TEXT="Chance zu parieren: "
	TITAN_COMBATINFO_MELEE_TEXT="Nahkampfangriff";
	TITAN_COMBATINFO_MELEE_MAINSPEED_TEXT="Waffenhand Angriffstempo (Sekunden): ";
	TITAN_COMBATINFO_MELEE_MAINAVGDMG_TEXT="Waffenhand Schaden pro Sekunde: ";
	TITAN_COMBATINFO_MELEE_MAINDMG_TEXT="Waffenhand Schaden: ";
	TITAN_COMBATINFO_MELEE_OFFHANDSPEED_TEXT="Schildhand Angriffstempo (Sekunden): ";
	TITAN_COMBATINFO_MELEE_OFFAVGDMG_TEXT="Schildhand Schaden pro Sekunde: ";
	TITAN_COMBATINFO_MELEE_OFFHANDDMG_TEXT="Schildhand Schaden: ";
	TITAN_COMBATINFO_MELEE_POWER_TEXT="Nahkampfangriffskraft:";
	TITAN_COMBATINFO_MELEE_POWER="%d (%d Basis)";
	TITAN_COMBATINFO_MELEE_POWER="%d (%d Basis)";
	TITAN_COMBATINFO_OPTIONS_SHOWBLOCK_TEXT="zeige block %";
	TITAN_COMBATINFO_OPTIONS_SHOWCRIT_TEXT="zeige krit. %";
	TITAN_COMBATINFO_OPTIONS_SHOWDODGE_TEXT="zeige ausweichen %";
	TITAN_COMBATINFO_OPTIONS_SHOWPARRY_TEXT="zeige parieren %";
	TITAN_COMBATINFO_OPTIONS_SHOWSTATLABEL_TEXT = "zeige Stat Name";
	return
end

--<< Traditional Chinese Localization (thanks icefish) >>--
if GetLocale()=="zhTW" then
	TITAN_COMBATINFO_BUTTON_LABEL="戰鬥資訊";
	TITAN_COMBATINFO_TOOLTIP="戰鬥資訊";
	TITAN_COMBATINFO_MENU_TEXT="戰鬥資訊";
	TITAN_COMBATINFO_RANGE_TEXT="遠程攻擊";
	TITAN_COMBATINFO_RANGEDMG_TEXT="遠程傷害:";
	TITAN_COMBATINFO_RANGEPWR_TEXT="遠程攻擊強度:";
	TITAN_COMBATINFO_RANGEPWR="%d (%d 基本值)";
	TITAN_COMBATINFO_RANGEATTACKSPEED="遠程攻擊速度(秒):";
	TITAN_COMBATINFO_RANGEAVGDMG_TEXT="遠程攻擊平均DPS:";
	TITAN_COMBATINFO_ARMOR_TEXT="護甲";
	TITAN_COMBATINFO_BLOCK_TEXT="格檔機率: ";
	TITAN_COMBATINFO_CRIT_ATTACKTEXT="戰鬥";
	TITAN_COMBATINFO_CRIT_TEXT="致命一擊機率: ";
	TITAN_COMBATINFO_DODGE_TEXT="躲閃機率: ";
	TITAN_COMBATINFO_PARRY_TEXT="招架機率: "
	TITAN_COMBATINFO_MELEE_TEXT="近戰攻擊";
	TITAN_COMBATINFO_MELEE_MAINSPEED_TEXT="主手攻擊速度(秒): ";
	TITAN_COMBATINFO_MELEE_MAINAVGDMG_TEXT="主手攻擊平均DPS: ";
	TITAN_COMBATINFO_MELEE_MAINDMG_TEXT="主手攻擊傷害: ";
	TITAN_COMBATINFO_MELEE_OFFHANDSPEED_TEXT="副手攻擊速度(秒): ";
	TITAN_COMBATINFO_MELEE_OFFAVGDMG_TEXT="副手攻擊平均DPS: ";
	TITAN_COMBATINFO_MELEE_OFFHANDDMG_TEXT="副手攻擊傷害: ";
	TITAN_COMBATINFO_MELEE_POWER_TEXT="近戰攻擊強度:";
	TITAN_COMBATINFO_MELEE_POWER="%d (%d 基本值)";
	TITAN_COMBATINFO_MELEE_POWER="%d (%d 基本值)";
	TITAN_COMBATINFO_OPTIONS_SHOWBLOCK_TEXT="顯示格擋百分比";
	TITAN_COMBATINFO_OPTIONS_SHOWCRIT_TEXT="顯示致命一擊百分比";
	TITAN_COMBATINFO_OPTIONS_SHOWDODGE_TEXT="顯示躲閃百分比";
	TITAN_COMBATINFO_OPTIONS_SHOWPARRY_TEXT="顯示招架百分比";
	TITAN_COMBATINFO_OPTIONS_SHOWSTATLABEL_TEXT = "顯示屬性標籤";
	return
end