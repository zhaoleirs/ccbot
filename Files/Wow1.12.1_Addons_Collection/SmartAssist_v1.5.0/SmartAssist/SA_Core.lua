-- AUTHOR: Paranoidi

-- $LastChangedDate: 2006-10-08 15:35:22 +0300 (Sun, 08 Oct 2006) $
-- $LastChangedBy: marko $
-- $Rev: 333 $

-- integration to myAddons
SmartAssistDetails = {
		name = "SmartAssist",
		description = "SmartAssist is an addon which improves default assisting system in groups.",
		version = "beta r335",
		releaseDate = string.sub("$LastChangedDate: 2006-10-08 15:35:22 +0300 (Sun, 08 Oct 2006) $", 18, 28),
		author = "paranoidi",
		email = "paranoidi@gmx.net",
		category = MYADDONS_CATEGORY_COMBAT,
		frame = "SmartAssistFrame"
};

-- compost
SA_COMPOST = AceLibrary:GetInstance("Compost-2.0");

-- theme data
SA_THEME = {};

-- options
SA_OPTIONS_WRAPPER = {};
SA_OPTIONS = nil;

SA_MARKEDCACHE = SA_COMPOST:Acquire();
SA_PASSIVECACHE = SA_COMPOST:Acquire();

ASSIST_EMOTES = {};
PREVIOUS_ASSISTS = SA_COMPOST:Acquire();
PREVIOUS_NEAREST = false;
PREVIOUS_FALLBACK = false;
PREVIOUS_ASSIST_TIME = 0;
PREVIOUS_NEAREST_TIME = 0;
TARGET_CHANGED = false;

SMARTASSIST_CORE_REV = tonumber(string.sub("$Rev: 333 $", 7, -3));
BINDING_HEADER_SMARTASSIST = "SmartAssist";
BINDING_NAME_SASET = "Set puller";
BINDING_NAME_SAASSIST = "Assist";

SA_RUNNING = false; 		-- used to disable sounds and detect target changes
PASSIVE_WARN_FLAG = false;	-- is passive warning visible

COLOR_DEFAULT = {r=0, g=0.8, b=1};
COLOR_ALERT = {r=0.9, g=0, b=0};

StaticPopupDialogs["SA_NO_BINDINGS"] = {
	text = TEXT("You must bind SmartAssist key before being able to use this addon!"),
	button1 = TEXT(ACCEPT),
	OnAccept = function()
		printInfo("Tip: Press ESC key and go to 'bind keys' options. SmartAssist keys should be there at somewhere near bottom of the list.");
	end,
	timeout = 0,
	whileDead = 1,
};

StaticPopupDialogs["SA_UPGRADE_RESETPOS"] = {
	text = TEXT("SmartAssist will need to reset frame positons due changes in the way scaling is used."),
	button1 = TEXT(ACCEPT),
	OnAccept = function()
		SA_ResetFramePos();		
	end,
	timeout = 0,
	whileDead = 1,
};

StaticPopupDialogs["SA_AUTOCONF"] = {
	text = TEXT("Auto configure Smart Actions?"),
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		local loaded, message = LoadAddOn("SmartAssistOptions");
		if (loaded) then
			SA_AutoConfigureSmartActions();
			printInfo("You should see SmartAssist options and verify detected settings. Use command /sa to access configuration.");
		else
			PlaySound("TellMessage");
			printInfo("ERROR: Unable to load SmartAssistOptions (Load On Demand) !");
		end
	end,
	timeout = 0,
	whileDead = 1,
};

StaticPopupDialogs["SA_DISABLE_ATTACK"] = {
	text = TEXT("You have 'attack on assist' enabled in interface options which will cause problems with SmartAssist.\n\nAllow SmartAssist to turn it off (recommended) ?"),
	button1 = TEXT(YES),
	button2 = TEXT(NO),
	OnAccept = function()
		SetCVar("assistAttack", "0");
	end,
	OnCancel = function()
		SA_OPTIONS.AutoAttackWhineIgnored = true;
	end,
	timeout = 0,
	whileDead = 1,
};

function SA_OnLoad()
	SLASH_SMARTASSIST1 = "/smartassist";
	SLASH_SMARTASSIST2 = "/sa";
	SlashCmdList["SMARTASSIST"] = function(msg)
		SA_Command(msg);
	end
	
	-- register events
    this:RegisterEvent("VARIABLES_LOADED"); 
	this:RegisterEvent("CHAT_MSG_TEXT_EMOTE");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");
end

function SA_OnEvent(event)
    if (event == "VARIABLES_LOADED") then 
    	SA_VariablesLoaded(); 
	elseif (event == "CHAT_MSG_TEXT_EMOTE") then
        SA_EmoteAssist(arg1);
	elseif (event == "UNIT_HEALTH") then
		SA_UnitHealth(arg1);
	elseif (event == "PLAYER_TARGET_CHANGED") then
		SA_PlayerTargetChanged();
	end
end

------------------------------------------------------------------------------
-- event: variables loaded
------------------------------------------------------------------------------

function SA_VariablesLoaded()
	-- Register the addon in myAddOns
	if(myAddOnsFrame_Register) then
		myAddOnsFrame_Register(SmartAssistDetails);
	end
	printInfo("SmartAssist "..SmartAssistDetails.version.." loaded.")

	-- add item to every possible context menu	
	table.insert(UnitPopupMenus["PARTY"], "PULLER");
	table.insert(UnitPopupMenus["PLAYER"], "PULLER");
	table.insert(UnitPopupMenus["RAID"], "PULLER");
	
	UnitPopupButtons["PULLER"] = { text = TEXT("Set as puller"), dist = 0 };
		
	SA_Init();
end

function SA_InitOption(option, value)
	if (SA_OPTIONS[option]==nil) then SA_OPTIONS[option]=value; end;
end

function SA_Init() 

	-- load realm & char specific configs
	local id = SA_GetAccountID();
	if (SA_OPTIONS_WRAPPER[id]==nil) then
		printInfo("SmartAssist created new default settings for "..id);
		SA_OPTIONS_WRAPPER[id] = {};
	end
	SA_OPTIONS = SA_OPTIONS_WRAPPER[id];
		
	-- set default values to option variables if they do not exist

	-- before rev 66 we had no stored rev number so we need to make sure it's in such cases atleast zero
	SA_InitOption("Rev", 0);

	-- special cases where we need to reset variables when upgrading the addon from older version
	if (SA_OPTIONS.Rev<240 and SA_OPTIONS.Rev>0) then
		StaticPopup_Show("SA_UPGRADE_RESETPOS");	
	end
	
	-- basic options
	SA_InitOption("VisualWarning", true);
	SA_InitOption("AssistOnEmote", true);
	SA_InitOption("PriorizeHealth", true);
	SA_InitOption("PriorizeHealthValue", 35);
	SA_InitOption("FallbackTargetNearest", true);
	SA_InitOption("CheckNearest", false);
	SA_InitOption("NearestMustBePvP", false);
	SA_InitOption("NearestMustBeTargetting", true);
	SA_InitOption("AssistOnlyNearest", false);
	-- target list
	SA_InitOption("ShowAvailable", true);
	SA_InitOption("PreserveOrder", false);
	SA_InitOption("OutOfCombat", false);
	SA_InitOption("TankMode", false); -- todo: class based defaults
	
	SA_InitOption("AddMyTarget", false);
	SA_InitOption("ListWidth", 150);
	SA_InitOption("ListScale", 1.0);
	SA_InitOption("ListOOCAlpha", 0.4);
	SA_InitOption("ListHorizontal", false);
	SA_InitOption("ListTwoRow", false);
	SA_InitOption("LockList", false);
	SA_InitOption("HideTBY", false);
	SA_InitOption("HideTitle", false);
	SA_InitOption("IntelligentSplit", false);
	-- set default theme on first run, or restore if selected theme is not present
	if (not SA_OPTIONS.Theme or not SA_THEME[SA_OPTIONS.Theme]) then
		SA_Theme_ChangeTheme("Elegant");
	end
	-- set icon pos to 1 if it doesn't exist in theme
	local function validateIconPos(name)
		local theme = SA_THEME[SA_OPTIONS.Theme];
		local mode = SA_OPTIONS[name];
		if (not theme.icons.positions[mode]) then
			SA_OPTIONS[name] = 1;
			SA_Debug("ERROR: Invalid icon mode for "..name, 1);
		end
	end
	validateIconPos("ClassIconMode");
	validateIconPos("TargetIconMode");
	validateIconPos("HuntersMarkIconMode");
	
	-- messages
	SA_InitOption("VerboseAssist", true);
	SA_InitOption("VerboseIncoming", false);
	SA_InitOption("VerboseNearest", true);
	SA_InitOption("VerboseUnableToAssist", false);
	
	SA_InitOption("AudioWarning", true); -- todo: class based defaults
	SA_InitOption("LostAudioWarning", false); -- todo: class based defaults
	SA_InitOption("IncomingWBAudioWarning", true);
	
	SA_InitOption("VerboseAcquiredAggro", true);
	SA_InitOption("VerboseLostAggro", false);
	SA_InitOption("VerboseIncomingWB", true);
	-- advanced
	SA_InitOption("DisableSliderValue", 15);
	SA_InitOption("DisableTargetNearest", true);
	SA_InitOption("DisablePriorityHealth", true);
	SA_InitOption("AssistKeyMode", 1);
	SA_InitOption("DisableAutoCastKeyMode", 2);
	SA_InitOption("AssistMAOnlyMode", 1);
	SA_InitOption("AssistResetMode", 3);
	SA_InitOption("DisableAssistWithoutPuller", false);
	SA_InitOption("PauseResetsOrder", false);
	-- smart actions
	SA_InitOption("AssistSpells", {});
	SA_InitOption("TriggerAssist", true);
	SA_InitOption("TriggerAssistPreventOOC", true);
	-- geek (not in options)
	SA_InitOption("SoundLoseAggro", "Sound\\Spells\\EyeOfKilroggDeath.wav");
	SA_InitOption("SoundIncomingWoldBoss", "Sound\\Spells\\PVPFlagTaken.wav");
	SA_InitOption("SoundGainAggro", "AuctionWindowClose");
	-- development
	SA_InitOption("DebugLevel", 0);
	
	-- display auto configuration dialog on first run
	SA_InitOption("AutoConfiguredV2", false);
	if (not SA_OPTIONS.AutoConfiguredV2) then
		SA_OPTIONS.AutoConfiguredV2 = true;
		StaticPopup_Show("SA_AUTOCONF");
	end
		
	-- init auto cast on assist defaults for hunters
	if (SA_OPTIONS["AutoAssist"]==nil and UnitClass("player") == CLASSNAME_HUNTER) then
		SA_OPTIONS.AutoAssist = true;
		SA_OPTIONS.FallbackOnBusy = true;
		SA_OPTIONS.AutoAssistTexture = "Interface\\Icons\\INV_Weapon_Rifle_08";
		SA_OPTIONS.AutoAssistName = SPELL_AUTOSHOT;
	end
	SA_InitOption("AutoAssist", false);
	SA_InitOption("AutoPetAttack", false);
	SA_InitOption("AutoPetAttackBusy", false);

	-- check if should display 'attack on assist' disable dialog if not ignored
	SA_InitOption("AutoAttackWhineIgnored", false);
	SA_CheckForAssistAttack();
	
	-- prefered assitance order (just a guess, got better one?)
	SA_InitOption("ClassOrder",{	CLASSNAME_WARRIOR, CLASSNAME_HUNTER, 
									CLASSNAME_ROGUE, CLASSNAME_PALADIN, 
									CLASSNAME_DRUID, CLASSNAME_SHAMAN, CLASSNAME_MAGE, 
									CLASSNAME_WARLOCK, CLASSNAME_PRIEST } );
									
	-- store revision number to configuration, this can be used to detect some special cases where we need to reset
	-- exsisting options (ie. bug in assistance order list) in new releases
	SA_OPTIONS.Rev = SMARTASSIST_CORE_REV;
	
	ASSIST_EMOTES = { EMOTE_EVERYONE_ATTACK, EMOTE_ATTACK, EMOTE_HELP };
	
	if (SA_OPTIONS.ShowAvailable) then
		SAListFrame:Show();
	else
		SAListFrame:Hide();
	end
end

-- check if assist attack is enabled
function SA_CheckForAssistAttack()
	if (not SA_OPTIONS.AutoAttackWhineIgnored) then
		if (GetCVar("assistAttack")~="0" and SA_OPTIONS.AutoAssist and SA_OPTIONS.AutoAssistName) then
			StaticPopup_Show("SA_DISABLE_ATTACK");
		end
	end
end

-------------------------------------------------------------------------------
-- WARNING ICON EVENTS
-------------------------------------------------------------------------------

SA_WARN_SPEED = 0.07;
SA_WARN_REFRESH = SA_WARN_SPEED;
SA_WARN_ALPHA = 0.4;
SA_WARN_ALPHA_UP = true;

function SA_WarnOnUpdate(elapsed)
	if (not PASSIVE_WARN_FLAG) then return; end;
	SA_WARN_REFRESH = SA_WARN_REFRESH - elapsed;
	if (SA_WARN_REFRESH > 0) then
		return;
	end
	SA_WARN_REFRESH = SA_WARN_SPEED;
	
	-- if target target is != nil (attacking someone) then REMOVE the icon
	if (UnitName("targettarget")~=nil) then
		SA_Debug("target target != nil .. remove the warning", 1);
		SA_ResetWarning();
		SA_AggroedTargetMsg();
		return;
	end

	if (SA_WARN_ALPHA_UP) then
		SA_WARN_ALPHA = SA_WARN_ALPHA + 0.1;
	else
		SA_WARN_ALPHA = SA_WARN_ALPHA - 0.1;
	end
	if (SA_WARN_ALPHA<0.4) then
		SA_WARN_ALPHA_UP = true;
		SA_WARN_ALPHA = 0.5;
	end
	if (SA_WARN_ALPHA>1.0) then
		SA_WARN_ALPHA_UP = false;
		SA_WARN_ALPHA = 0.9;
	end
	SAWarningFrame:SetAlpha(SA_WARN_ALPHA);
end

-------------------------------------------------------------------------------
-- handles smart assist slash commands
-------------------------------------------------------------------------------

function SA_Command(msg)
	local words = SA_StringSplit(msg)
	local _,_,value = string.find(msg, "debug (%d)");
	if (value) then
		SA_OPTIONS.DebugLevel = tonumber(value);
		printInfo("Setting debug level to "..tostring(SA_OPTIONS.DebugLevel));
	elseif (msg=="available") then
		SA_ToggleAvailable();
	elseif (msg=="assist") then
		DoSmartAssist();
	elseif (msg=="reset" or msg=="reset all") then
		-- resets frame positions
		SA_ResetFramePos();
		-- clears this character settings and initializes defaults
		if (msg=="reset all") then
			printInfo("Reseting SmartAssist settings for all characters");
			SA_OPTIONS_WRAPPER = {};
		else
			printInfo("Reseting SmartAssist settings for this character");
			local id = SA_GetAccountID();
			SA_OPTIONS_WRAPPER[id] = {};
		end
		SA_Init();
	elseif (msg=="profile") then
		if (not SA_PROFILE) then
			SA_PROFILE=true
		else
			SA_PROFILE=false
		end
	elseif (msg=="rev" or msg=="ver") then
		if (SmartAssistDetails.version ~= "beta r335") then
			printInfo("SmartAssist version: "..SmartAssistDetails.version);
		else
			printInfo("Unofficial or broken build! Revision number missing! Core rev "..SA_OPTIONS.Rev);
		end
	elseif (msg=="dump") then
		if (not DevTools_Dump) then
			printInfo("Requires devtools");
		else
			printInfo("Dumping internal variables:");
			printInfo("PREVIOUS_ASSISTS: ");
			DevTools_Dump(PREVIOUS_ASSISTS);
			printInfo("PREVIOUS_NEAREST: "..tostring(PREVIOUS_NEAREST));
			printInfo("TARGET_CHANGED: "..tostring(TARGET_CHANGED));
			printInfo("SA_RUNNING: "..tostring(SA_RUNNING));
		end
	elseif (words[1]=="compost") then
		if (not words[2]) then
			printInfo("Use: Compost [on/off]");
			return
		end
		if (words[2]=="on") then
			SA_COMPOST.var.disabled=false
			printInfo("Compost ON")
		elseif (words[2]=="off") then
			SA_COMPOST.var.disabled=true
			printInfo("Compost OFF")
		else
			printInfo("Unknown parameter")
		end
	elseif (words[1]=="theme") then
		if (not words[2]) then
			printInfo("Use: theme <mode to preview>");
			return
		end
		local add = SA_THEME[SA_OPTIONS.Theme].colors[words[2]];
		if (not add) then
			printInfo("Entry does not exist")
			return
		end
		local tc = {}
		SA_AddTargetTheme(tc, SA_THEME[SA_OPTIONS.Theme].colors.normal)
		SA_AddTargetTheme(tc, add)
		SA_List_ApplyTargetColors(SA_TARGET_FRAMES[5], tc);
		printInfo("Applied "..words[2].." to entry 5");
	elseif (msg=="test") then
		-- theme test
		printInfo("Checking theme data integrity ...");
		if (not SA_THEME) then
			printInfo("ERROR: Themedata completely missing", COLOR_ALERT);
		end
		if (not SA_OPTIONS.Theme) then
			printInfo("ERROR: Selected theme not set", COLOR_ALERT);
		end
		if (not SA_THEME[SA_OPTIONS.Theme]) then
			printInfo("ERROR: Selected theme missing", COLOR_ALERT);
		end
		printInfo("Theme check completed!");
		-- smart actions test
		printInfo("Checking SmartActions integration hooks ...");
		local getok=false;
		for i=0, 120 do
			if (SA_GetSlotName(i)) then
				getok=true;
			end
		end
		if (not getok) then
			printInfo("ERROR: SmartAssist is unable to get ANY slot names! This may be because of tooltip mod or heavy actionbar mod.");
		end
		printInfo("Hook check completed!");
	else
		printInfo("Available parameters:");
		printInfo("ver - Display addon version information.");
		printInfo("assist - Execute SmartAssist for macros. Or call DoSmartAssist()");
		printInfo("reset - Reset character settings and frame positions.");
		printInfo("reset all - Reset all characters settings and frame positions.");
		SA_ShowOptions();
	end
end

function SA_ResetFramePos()
	SAListFrame:ClearAllPoints();
	SAListFrame:SetPoint("TOP", "UIParent", "TOP", 0, -20);
	SAListFrame:StopMovingOrSizing();
	SAWarningFrame:ClearAllPoints();
	SAWarningFrame:SetPoint("TOP", "UIParent", "TOP", 5, -25);
	SAWarningFrame:StopMovingOrSizing();
	local loaded, _ = LoadAddOn("SmartAssistOptions");
	if (loaded) then
		SAOptionsFrame:ClearAllPoints();
		SAOptionsFrame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0);
		SAOptionsFrame:StopMovingOrSizing();
	end
end

function SA_ShowOptions()
	-- open config, or warn about key bindings
	local key1, key2 = GetBindingKey("SAASSIST");
	if (key1==nil and key2==nil) then
		StaticPopup_Show("SA_NO_BINDINGS");
	else
		local loaded, message = LoadAddOn("SmartAssistOptions");
		if (loaded) then
			SAOptionsFrame:Show();
		else
			PlaySound("TellMessage");
			printInfo("ERROR: Unable to load SmartAssistOptions (Load On Demand) !");
		end
	end
end

-------------------------------------------------------------------------------
-- implements shift click assist
-- should work with ANYWHERE where you can select unit
-------------------------------------------------------------------------------

local SA_PREV_ASSIST_TIME = 0;
function SA_PlayerTargetChanged()
	TARGET_CHANGED = true;

	-- target lost, or switched to friendly
	if (not UnitExists("target") or UnitIsFriend("player", "target")) then
		SA_ResetWarning();
		if (not SA_RUNNING) then
			PREVIOUS_ASSISTS = SA_COMPOST:Erase(PREVIOUS_ASSISTS);
			PREVIOUS_NEAREST = false;
		end
		SA_List_Refresh();
		return; -- fixes issue when we have target already (fires two events, on lost and on gain)
	end	
	
	-- asisst by unit selection & modifier key
	if ( (IsShiftKeyDown() and SA_OPTIONS.AssistKeyMode==1) or 
	     (IsControlKeyDown() and SA_OPTIONS.AssistKeyMode==2) or
	     (IsAltKeyDown() and SA_OPTIONS.AssistKeyMode==3) and not SA_RUNNING) 
	then
		-- this time check (hoax) removes looping, when selecting player that has friendly taget. Without this 
		-- it goes there and starts to assist him
		-- todo: this can be done better .. if we check what's the target!
		
		local now = time();
		local dif = now - SA_PREV_ASSIST_TIME;
		if (dif == 0) then return; end
		SA_PREV_ASSIST_TIME = now;

		if (UnitCanAssist("player", "target") and
			UnitCanAttack("player", "targettarget"))
		then
			SAMsgFrame:AddMessage("Assisting "..UnitName("target"), 0.0, 0.8, 0.0, 1, 2.5);
			AssistUnit("target");
			SA_PostAssist();
		else
			if (UnitExists("target") and not UnitIsDead("target")) then
				UIErrorsFrame:AddMessage("Unable to assist", 1.0, 0, 0, 1.0, 1.5);
			end
		end
	end
	
	SA_List_Refresh();
end

------------------------------------------------------------------------------
-- credits to popup assist author, refactored a bit tough :)
------------------------------------------------------------------------------

local old_UnitPopup_OnClick = UnitPopup_OnClick;
function UnitPopup_OnClick(index)
	local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local unit = dropdownFrame.unit;
	if ( this.value == "PULLER" ) then
		SA_SetPuller(unit);
	end
	return old_UnitPopup_OnClick(index);
end

------------------------------------------------------------------------------
-- param: unit - ID to be set as puller
-- set unit as puller
------------------------------------------------------------------------------

function SA_SetPuller(unit)
	if (UnitIsFriend(unit, "player")) then
		local candidates,_ = SA_GetCandidates(true);
		-- check that current puller exists in party, if not clear
		if (not candidates[UnitName(unit)]) then
			SAMsgFrame:AddMessage("Puller must be in party / raid", 1.0, 1.0, 1.0, 1, 3);
		else
			SA_OPTIONS["puller"] = UnitName(unit);
			SAMsgFrame:AddMessage("The assigned puller is now "..SA_OPTIONS["puller"], 1.0, 1.0, 1.0, 1, 1.5);
		end
		SA_COMPOST:Reclaim(candidates);
		candidates=nil;
	else
		SA_OPTIONS["puller"] = nil;
		SAMsgFrame:AddMessage("Assigned puller cleared", 1.0, 1.0, 1.0, 1, 1.5);
	end
	-- just incase that option window is visible, update the text. Only if options loaded tough!
	if (SAOptionsFrame) then
		SA_Options_UpdatePullerText();
	end
end

------------------------------------------------------------------------------
-- credits to mozz
-- this is used to disable some anying unit deselect sounds while assisting 
-- (we have to clear the selected unit in some cases)
------------------------------------------------------------------------------

local old_PlaySound = PlaySound;
function PlaySound(name)
    if (not SA_RUNNING) then
    	return old_PlaySound(name);
    end
	if (name ~= "INTERFACESOUND_LOSTTARGETUNIT" and name ~= "igCharacterNPCSelect" ) then
		return old_PlaySound(name);
	end
end

------------------------------------------------------------------------------
-- main method, this is called when smartassist does its thing
------------------------------------------------------------------------------

function DoSmartAssist()
    SA_RUNNING = true;
    
    -- refresh puller
    local candidates, members = SA_GetCandidates(false);
    SA_RefreshPuller(candidates);

    -- reset assist order if modifier
	if ( ((IsShiftKeyDown() and SA_OPTIONS.AssistResetMode==1) or 
	      (IsControlKeyDown() and SA_OPTIONS.AssistResetMode==2) or
	      (IsAltKeyDown() and SA_OPTIONS.AssistResetMode==3)) ) 
	then
		SA_Debug("Reset assist order due modifier", 1);
		PREVIOUS_ASSISTS = SA_COMPOST:Erase(PREVIOUS_ASSISTS);
		PREVIOUS_NEAREST = false;
	end
        
    -- if limiting to configured pulled modifier
	if ( ((IsShiftKeyDown() and SA_OPTIONS.AssistMAOnlyMode==1) or 
	      (IsControlKeyDown() and SA_OPTIONS.AssistMAOnlyMode==2) or
	      (IsAltKeyDown() and SA_OPTIONS.AssistMAOnlyMode==3)) ) 
	then
    	SA_Debug("Assisting only puller", 1);
    	if (SA_OPTIONS["puller"]) then
    		AssistByName(SA_OPTIONS["puller"]);
    		SA_Verbose("Assisting "..SA_OPTIONS["puller"]);
    	else
    		SA_Verbose("No puller set");
    	end
    else
	    -- if has friendly target, straight assist it
	    local f = true;
	    if (UnitExists("target")) then
		    if (UnitIsFriend("player", "target")) then
		    	-- check that player has valid target
		    	if (isValidTarget("targettarget")) then
			    	if (SA_OPTIONS.VerboseAssist) then
			    		SA_Verbose("Assisting selected player "..UnitName("target"));
			    	end
			    	AssistUnit("target");
			    	f = false;
			    end
		    end
		end
		if (f) then
			FindTarget(candidates, true, false);
		end
	end
	
	SA_COMPOST:Reclaim(candidates);
	candidates=nil;
	SA_RUNNING = false;
	SA_PostAssist();
	SA_List_Refresh();
end

------------------------------------------------------------------------------
-- post assist logic (after target has been selected)
------------------------------------------------------------------------------

function SA_PostAssist()
	-- auto-assist, disable if certain modifier key is down
	if ( ((not IsShiftKeyDown() and SA_OPTIONS.DisableAutoCastKeyMode==1) or 
	      (not IsControlKeyDown() and SA_OPTIONS.DisableAutoCastKeyMode==2) or
	      (not IsAltKeyDown() and SA_OPTIONS.DisableAutoCastKeyMode==3)) and 
	      UnitExists("target") and 
		  SA_UnitIsInCombat("target") ) 
	then
		if (SA_OPTIONS.AutoAssist and SA_OPTIONS.AutoAssistName) 
		then
			SA_Debug("Target already in combat, assisting with "..SA_OPTIONS.AutoAssistName, 3);
			CastSpellByName(SA_OPTIONS.AutoAssistName); -- casts highest level
		end
		if ((SA_OPTIONS.AutoPetAttack and UnitExists("pet") and not UnitIsDead("pet") and not UnitExists("pettarget")) or
			(SA_OPTIONS.AutoPetAttack and UnitExists("pet") and not UnitIsDead("pet") and SA_OPTIONS.AutoPetAttackBusy))
		then
			SA_Debug("Attacking with pet", 3);
			PetAttack();
		end
	end
	-- visual alert, if needed
	SA_ShowWarning();
end

------------------------------------------------------------------------------
-- receives all emote events, implements assist by emote
------------------------------------------------------------------------------

function SA_EmoteAssist(arg1)
	if (not SA_OPTIONS.AssistOnEmote) then
		return;
	end
	-- todo idea: hitting assist key should go back to previous target (if possible)
	-- parse emotes
	for k,v in ASSIST_EMOTES do
		local sp, ep, name = string.find(arg1, "(%w+) "..v);
		if (name ~= nil) then
			SA_Debug("assist emote detected, name="..name, 1);
		end
		-- if name exists, we have a match
		if name and name ~= EMOTE_OWN then
			local candidates,_ = SA_GetCandidates(true);
			if (candidates[name]~=nil) then
				SAMsgFrame:AddMessage("Assisting "..name, 0.0, 0.8, 0.0, 1, 2.5);
				AssistUnit(candidates[name].unitId);
				return true;
			end
			SA_COMPOST:Reclaim(candidates);
			candidates=nil;
			SA_Debug("not assisting "..name..", not in party/raid", 1);
		end
	end
end

function SA_UnitHealth(arg1)
	-- flag is used to reduce overheading, this gets called a lot ..
	if (not PASSIVE_WARN_FLAG) then
		return;
	end
	if (arg1=="target") then
		SA_ResetWarning();
		-- if someone else attacked the target, show another text saying its ok to start blasting
		-- this is not idiot proof check, seems to work fine tough
		if (not UnitIsUnit("targettarget", "pet") and not UnitIsUnit("targettarget", "player")) then
			SA_Debug("Someone else has attacked our target, show notification", 4);
			SA_AggroedTargetMsg();
		else
			SA_Debug("player has most likelly attacked the target", 4);
			-- todo: perhaps send pull message to party?
		end
	end
	-- todo idea: we could watch other players health here and suggest assist
end

------------------------------------------------------------------------------
-- show warning if target is not in combat and feature is enabled
------------------------------------------------------------------------------

function SA_ShowWarning()
	if (not UnitAffectingCombat("target") and UnitExists("target") and 
		UnitName("targettarget")==nil and SA_OPTIONS.VisualWarning and
		not UnitPlayerControlled("target")) 
	then
		PASSIVE_WARN_FLAG = true;
		SAWarningFrame:Show();
		return true;
	end
end

function SA_ResetWarning()
	PASSIVE_WARN_FLAG = false;
	SAWarningFrame:Hide();
end

function SA_AggroedTargetMsg()
	-- todo: add as option!
	SA_Verbose("Target engaged!", COLOR_DEFAULT, true, true);
end

-----------------------------------------------------------------------------------------
-- construct and return one candidate
-- if unit has invalid flag it should not be used because it does not contain all fields
-- for example pets that are very far away do not have all fields present
-----------------------------------------------------------------------------------------

function SA_GetCandidate(unit, i)
	local candidate = SA_COMPOST:Acquire();
	candidate["unitName"] = UnitName(unit..i);
	candidate["unitId"] = unit..i;
	candidate["target"] = unit..i.."target";
	candidate["health"] = ceil( UnitHealth( unit..i ) / UnitHealthMax( unit..i ) * 100 );
	candidate["class"] = UnitClass(unit..i);
	candidate["dead"] = UnitIsDead(unit..i);
	if (string.find(unit, "pet") ~= nil) then
		candidate["pet"] = true;
	end
	if (candidate.unitName == nil) then 
		candidate["invalid"] = true; 
	end
	if (candidate.class == nil) then
		candidate["invalid"] = true; 
	end
	if (candidate.health == nil) then
		candidate["invalid"] = true; 
		--SA_DebugCandidate(candidate);
	end
	return candidate;
end

function SA_GetPlayerAsCandidate()
	local candidate = SA_COMPOST:Acquire();
	candidate["unitName"] = UnitName("player");
	candidate["unitId"] = "player";
	candidate["target"] = "target";
	candidate["health"] = ceil( UnitHealth( "player" ) / UnitHealthMax( "player" ) * 100 );
	candidate["class"] = UnitClass("player");
	candidate["dead"] = UnitIsDead("player");
	return candidate;
end

------------------------------------------------------------------
-- return iteration info: is this party or raid, how many members
------------------------------------------------------------------

function SA_GetIterInfo()
	local mode, members = nil;
	if (GetNumRaidMembers()>0) then
		mode = "raid";
		members = GetNumRaidMembers();
	elseif (GetNumPartyMembers()>0) then
		mode = "party";
		members = GetNumPartyMembers();
	end
	return mode, members;
end

-------------------------------------------------------------
-- params: if map is true then as a map where key is unitName
--         if map is false then as list
-- return list of possible assistable units
-------------------------------------------------------------

local UNIQUE_WARNED = false;
function SA_GetCandidates(map)
	local candidates = SA_COMPOST:Acquire();
	local mode, members = SA_GetIterInfo();
	local pullerAdded = false;

	-- for soloing and party, add our pet
	if (UnitExists("pet")) then
		local op = SA_GetCandidate("pet", "");
		if (not op.invalid and not op.dead) then 
			-- fixes problem when there are multiple pets with same name
			if (SA_OPTIONS["puller"] == op.unitName) then
				pullerAdded = true;
			end
			
			if (map) then
				candidates[op.unitName] = op;
			else
				table.insert(candidates, op);
			end
		end
	end
	
	-- if no party/raid, abort here
	if (members==nil) then return candidates, 0; end;

	local myname = UnitName("player");

	for i = 1, members do
		local candidate = SA_GetCandidate(mode, i);
		-- do not add invalid, dead or myself
		if (not candidate.invalid and not candidate.dead and candidate["unitName"] ~= myname) then
			if (map) then
				candidates[candidate.unitName] = candidate;
			else
				table.insert(candidates, candidate);
			end
		
			-- add pet to list if has one
			if (UnitExists(mode.."pet"..i)) then
				local pcandidate = SA_GetCandidate(mode.."pet", i);
				if (not pcandidate.invalid and not pcandidate.dead) then
					-- hotfix for unique pet puller problem
					-- players are unique by server so we don't have to worry about them
					if (SA_OPTIONS["puller"] == pcandidate.unitName and pullerAdded) then
						if (not UNIQUE_WARNED) then
							printInfo("SMARTASSIST PROBLEM: Puller is not unique!");
							UNIQUE_WARNED = true;
						end
					else
						if (map) then
							candidates[pcandidate.unitName] = pcandidate;
						else
							table.insert(candidates, pcandidate);
						end
						
						-- if added puller unit, set flag that no other unit with same name can be added
						if SA_OPTIONS["puller"] == pcandidate.unitName then
							pullerAdded = true;
						end
					end				
				end
			end
		end
	end
	
	return candidates, members;
end

------------------------------------------------------------------------------
-- if we have enabled filtering targets, remove those candidates who have 
-- something else. It was much more convient to implement this way rather 
-- than to modify get candidates and gazillion other places
------------------------------------------------------------------------------

function SA_FilterCandidates(candidates, map)
	local filtered = {};
	for key,candidate in candidates do
		if (UnitExists(candidate.target) and string.find(string.lower(UnitName(candidate.target)), SA_OPTIONS.Filter)) then
			if (map) then
				filtered[key] = candidate;
			else
				table.insert(filtered, candidate);
			end
		end
	end
	return filtered;
end

function SA_FilterCandidatesByDistance(candidates, map)
	local filtered = {};
	for key,candidate in candidates do
		if (CheckInteractDistance(candidate.unitId, 4)) then
			if (map) then
				filtered[key] = candidate;
			else
				table.insert(filtered, candidate);
			end
		end
	end
	return filtered;
end

------------------------------------------------------------------------------
-- sort method for candidates
------------------------------------------------------------------------------

local detected_bug = false;
function SA_SortCandidate(a, b, members)
	-- TODO: INVESTIGATE, but HOW?
	-- this is added to debug odd behaviour in molten core where crash occured (b was nil, crashed at priorize health)
	-- OKAY: found out the cause, if there are two units with same name (pet. ie. Cat) and your own is set as puller, 
	-- this should be fixed in getCandidates but is UNTESTED, remove this when tested
	-- Update 20.6.2006 - still bugs on VERY rare occasions!
	if (detected_bug==false and (a==nil or b==nil)) then
		printInfo("?? BUG IN SMARTASSIST:");
		local cand,_ = SA_GetCandidates(false);
		local old_state = SA_OPTIONS.Debug;
		SA_OPTIONS.Debug = true;
		SA_DebugCandidates(cand);
		SA_OPTIONS.Debug = old_state;
		detected_bug = true;
	end
	
	-- priority health always first
	local priorize = SA_OPTIONS.PriorizeHealth;
	-- disable health priorizing in large raids (configurable)
	if (members > SA_OPTIONS.DisableSliderValue and SA_OPTIONS.DisablePriorityHealth) then
		priorize = false;
	end
	if (priorize) then
		if (a.health < SA_OPTIONS.PriorizeHealthValue or b.health < SA_OPTIONS.PriorizeHealthValue)
		then
			return a.health < b.health;
		end
	end
	
	-- depriorize players having passive target
	if (SA_PASSIVECACHE[a.unitName] and not SA_PASSIVECACHE[b.unitName]) then return false; end;
	if (SA_PASSIVECACHE[b.unitName] and not SA_PASSIVECACHE[a.unitName]) then return true; end;
	
	-- our puller should be always top priority
	if (a.unitName == SA_OPTIONS["puller"]) then return true; end
	if (b.unitName == SA_OPTIONS["puller"]) then return false; end
	
	-- priorize players whose target is marked
	if (SA_MARKEDCACHE[a.unitName] and not SA_MARKEDCACHE[b.unitName]) then return true; end;
	if (SA_MARKEDCACHE[b.unitName] and not SA_MARKEDCACHE[a.unitName]) then return false; end;
	
	-- de-priorize pets
	if (a.pet and not b.pet) then return false; end;
	if (b.pet and not a.pet) then return true; end;
	
	-- CT RaidAssist support, if we have main tanks set in CT RaidAssist prefer them
	if (CT_RA_MainTanks ~= nil) then
		local a_tank, b_tank = false;
		for _,v in CT_RA_MainTanks do
			if (a.unitName == v) then a_tank=true; end
			if (b.unitName == v) then b_tank=true; end
		end
		-- if both are CTRA tanks, sort by priority (mt first!) -- TODO: perhaps put OT first ?
		if (a_tank and b_tank) then 
			return SA_TableIndex(CT_RA_MainTanks, a.unitName) < SA_TableIndex(CT_RA_MainTanks, b.unitName); 
		end
		
		if (a_tank) then return true; end
		if (b_tank) then return false; end
	end
	
	-- if we have same class, sort secondary by health if priorization enabled, otherwise by name (static order is more useful in larger raids)
	if (a.class == b.class) then
		if (priorize) then
			return a.health < b.health;
		else
			return a.unitName < b.unitName;
		end
	end
	
	-- and last, teh normal case where sorted by class
	return SA_TableIndex(SA_OPTIONS.ClassOrder, a.class) < SA_TableIndex(SA_OPTIONS.ClassOrder, b.class);
end

------------------------------------------------------------------------------
-- Makes sure that the puller is in the party and if not clear / set to pet.
-- This gets called everytime assist is used
------------------------------------------------------------------------------

function SA_RefreshPuller(candidates)
	-- check that current puller exists in party, if not clear
	local exists = false;
	for i,c in pairs(candidates) do
		if (c.unitName==SA_OPTIONS["puller"]) then
			exists = true;
		end
	end
	if (not exists) then
		SA_Debug("Puller does not exist in candidates, clearing", 3);
		SA_OPTIONS["puller"]=nil;
	end
	-- if there is no puller and we have pet, set it as one
	if (SA_OPTIONS["puller"]==nil and UnitExists("pet") and not UnitIsDead("pet")) then
		SA_Debug("no puller set, pet exists -> setting it as one", 3);
		SA_OPTIONS["puller"] = UnitName("pet");
	end
end

------------------------------------------------------------------------------------------
-- params:
-- candidates = list of candidates in list (non-map) format !
-- allowNearest = allow fallback to target nearest
-- recursive = is this recursive call, if it is we cannot add outside targets to skip list
-- preventOOC = disallow selecting out of combat targets
-- Todo: better way for recursive?
------------------------------------------------------------------------------------------

function FindTarget(candidates, allowNearest, recursive, preventOOC)
	-- set variables based on candidates being present or not
	local members;
	if (not candidates) then
		candidates, members = SA_GetCandidates(false);
	end
	if (not members) then
		members = table.getn(candidates);
	end

	-- reset PREVIOUS_FALLBACK, store real value in local variable. Easier this way than to handle all returns ...
	local previous_fallback = PREVIOUS_FALLBACK;
	PREVIOUS_FALLBACK = false;

	-- reset order if target is kept over 3s
	if (time() - PREVIOUS_ASSIST_TIME > 3 and SA_OPTIONS.PauseResetsOrder) then
		SA_Debug("over 3s since last assist, reseting PREVIOUS_ASSISTS", 2);
		PREVIOUS_ASSISTS = SA_COMPOST:Erase(PREVIOUS_ASSISTS);
		PREVIOUS_ASSIST_TIME = time();
	end
	
	-- allow targeting nearest attacking again
	if (time() - PREVIOUS_NEAREST_TIME > 5) then
		SA_Debug("over 5s since last assist, reseting PREVIOUS_NEAREST", 2);
		PREVIOUS_NEAREST = false;
		PREVIOUS_NEAREST_TIME = time();
	end
	
	if (SA_OPTIONS.Filter) then
		SA_Debug("filtering with "..tostring(SA_OPTIONS.Filter), 2);
		candidates = SA_FilterCandidates(candidates, false);
	end
	
	-- filter out candidates out of range if assisting only members nearby
	if (SA_OPTIONS.AssistOnlyNearest) then
		candidates = SA_FilterCandidatesByDistance(candidates, false);
	end
	
	-- if we should not assist anyone from raid without puller, clear the candidates list
	if (SA_OPTIONS.DisableAssistWithoutPuller and SA_OPTIONS["puller"]==nil) then
		SA_Debug("DisableAssistWithoutPuller and no puller -> clearing candidates list", 2);
		SA_COMPOST:Reclaim(candidates);
		candidates = SA_COMPOST:Acquire();
	end
	
	-- try to target nearest before going to assist from raid, note that this is different from allowNearest
	if (SA_OPTIONS.CheckNearest and not PREVIOUS_NEAREST and not recursive) then
		--local pre_valid = isValidTarget("target");
		-- okei, eli jos target nearest ei vaiha targettia niin se tuo my�hempi else palauttaa edellisen assistauksen targetin -> bug bug!
		TARGET_CHANGED = false;
		TargetNearestEnemy();
		SA_Debug("check nearest got = "..tostring(UnitName("target")),1);
		local valid = isValidTarget("target", true);
		if (SA_OPTIONS.NearestMustBePvP) then
			if (not UnitPlayerControlled("target")) then 
				valid = false;
			end
		end
		if (SA_OPTIONS.NearestMustBeTargetting) then
			--if (UnitIsUnit("targettarget", "player")) then
			if (UnitName("targettarget") ~= UnitName("player")) then
				valid = false;
			end
		end
		if (valid) then
			SA_Debug("*** found good target from check nearest target="..tostring(UnitName("target")),1);
			if (SA_OPTIONS.VerboseNearest) then
				SA_Verbose("Targeted nearest", ALERT_COLOR);
			end
			PREVIOUS_NEAREST = true;
			return;
		else
			if (TARGET_CHANGED) then
				SA_Debug("invalid check nearest, restored target = "..tostring(UnitName("target")),1);
				TargetLastTarget();
			end
		end
	end
	PREVIOUS_NEAREST = false;

	-- store table size to variable because iterating it multiple times is no good
	table.sort(candidates, function(a,b) return SA_SortCandidate(a,b,members) end);
	
	for _,candidate in candidates do
		-- this is ingenious loop which determines if current candidate target has been targetted on previous assists
		-- not a idiot proof check since previous party members might have changed target since then, but works amazingly well
		-- atleast preventing situation where multiple members have same target and you press assist key multiple times
		
		-- 18.1.2006 - changed to show already targetted msg to test if its futile
		-- 21.1.2006 - this is triggered _multiple_ times per assist on some occasions, seems to be when there is only one target..
		
		local previously_targetted = false;
		for assisted,_ in PREVIOUS_ASSISTS do
			if (UnitExists(assisted)) then
				if (UnitIsUnit(candidate.target, assisted.."target")) then
					--SA_Debug("** already targetted once "..tostring(UnitName(assisted)));
					previously_targetted = true;
					break;
				end
			end
		end
		
		-- if current target is same as our candidate, consider it "assisted" (in other words: skip it)
		-- added 24.1.2006 - this should make cycling trough enemies work more smoothly
		if (UnitExists("target") and UnitIsUnit(candidate.target, "target")) then
			SA_Debug(tostring(candidate.unitId).." has same target as we ("..tostring(UnitName("target")).."), consider this unit as assisted", 3);
			PREVIOUS_ASSISTS[candidate.unitId] = true;
		end
		
		-- test each candidate, skips previously assisted UNLESS it has health below critical value
		local priority_health = candidate.health < SA_OPTIONS.PriorizeHealthValue and SA_OPTIONS.PriorizeHealth;
		
		if (members > SA_OPTIONS.DisableSliderValue and SA_OPTIONS.DisablePriorityHealth) then
			priority_health = false;
		end
		
		if ( (PREVIOUS_ASSISTS[candidate.unitId]==nil or priority_health) and (not previously_targetted) ) 
		then
			-- test if candidate (partyN, pet, raidN etc) has valid target
			if (UnitCanAssist("player", candidate.unitId) and 
				isValidTarget(candidate.target, preventOOC)) 
			then
				if (SA_OPTIONS.VerboseAssist) then
					if (priority_health) then
						SA_Verbose("Priority assisting "..candidate.unitName.." ("..candidate.health.."%)", COLOR_ALERT);
					else
						SA_Verbose("Assisting "..candidate.unitName);
					end
				end
				SA_Debug("Found a good target from "..candidate.unitName.." ("..candidate.unitId..")", 3);
				AssistUnit(candidate["unitId"]);
				PREVIOUS_ASSISTS[candidate.unitId] = true;
				return;
			end
		else
			SA_Debug("** Skipping "..candidate.unitName.." ("..candidate.unitId..") - not valid target", 4);
		end
	end
	
	-- if we have skiplist, now is good time to clear it and try again with all members, recursive call is only made once
	if (SA_TableSize(PREVIOUS_ASSISTS)>0 and not recursive) then
		SA_Debug("** Unable to assist anyone but we have skiplist ("..SA_TableSize(PREVIOUS_ASSISTS)..") -> clearing it and trying again..", 3);
		PREVIOUS_ASSISTS = SA_COMPOST:Erase(PREVIOUS_ASSISTS);
		return FindTarget(candidates, members, allowNearest, true, preventOOC);
	end
	
	-- we might had good target already when assist was used, if there are no other targets available we must exit now
	-- falling back to target nearest in that case would be idiotic
	-- 29.7.2006 - do not abort on good target if previously acquired target using fallback to nearest, 
	-- this allows toggling targets using smartassist key like TAB key.
	if (isValidTarget("target") and not previous_fallback) then
		SA_Debug("had already good target", 3);
		return;
	end
	
	if (SA_OPTIONS.FallbackTargetNearest and allowNearest) then
		if (SA_OPTIONS.DisableTargetNearest and members > SA_OPTIONS.DisableSliderValue) then
			if (SA_OPTIONS.VerboseUnableToAssist) then
				printInfo("Unable to assist anyone. Targetting nearest is suspended in groups this large.");
			end
			return;
		end
		if (SA_OPTIONS.VerboseUnableToAssist) then
			printInfo("Unable to assist anyone. Trying to target nearest enemy.");
		end
		TargetNearestEnemy();
		if (not isValidTarget("target", preventOOC)) then
			ClearTarget();
		else
			PREVIOUS_FALLBACK = true;
			SA_Debug("fallback to target nearest found good target", 2);
		end
	end	
end
