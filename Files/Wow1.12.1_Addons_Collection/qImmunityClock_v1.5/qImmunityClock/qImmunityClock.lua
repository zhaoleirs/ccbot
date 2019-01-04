--******************************************************************************************************
--[[
	Deathwing!Quel
	qwarlock@gmail.com
	2/11/2005 v1.5

	Detects when targets become immune to spell effects and displays a count down timer estimating
	the Immunity time remaining based on the target's class, level, and when the message was 
	captured.
--]]

--******************************************************************************************************
-- 

ICtimer=0; 	
ICimmunity=0;
IConesec=0;
ICicon=0;

ICcooldown=0;
ICduration=0;

ICMAXINDEX=5;	-- max number of targets to track
ICindex=0;	-- zero indicates no targets are being tracked
ICtarget= { {name="no target1", type="none", race="none", level=0, immune=0, timer=0, duration=0, cooldown=0, display="none"},
	    {name="no target2", type="none", race="none", level=0, immune=0, timer=0, duration=0, cooldown=0, display="none"},
	    {name="no target3", type="none", race="none", level=0, immune=0, timer=0, duration=0, cooldown=0, display="none"},
	    {name="no target4", type="none", race="none", level=0, immune=0, timer=0, duration=0, cooldown=0, display="none"},
	    {name="no target5", type="none", race="none", level=0, immune=0, timer=0, duration=0, cooldown=0, display="none"}  };

ICdebug=0;
ICverbose=0;

--****************************************************************************************************
-- Dragging code
-- Virtually no other add-on does this, but my window wouldn't drag until I added all this.

local lBeingDragged;

function ImmunityClockWindowFrame_OnDragStart()
	ImmunityClockWindowFrame:StartMoving()
	lBeingDragged = 1;
end

function ImmunityClockWindowFrame_OnDragStop()
	ImmunityClockWindowFrame:StopMovingOrSizing()
	lBeingDragged = nil;
end

--****************************************************************************************************
--Window Buttons
function ImmunityClockCloseButton_OnClick()
	ImmunityClockWindowFrame:Hide();
end

--*****************************************************************************************************
-- Debugging text messages
function ICmsg(msg)
	if (ICdebug == 1 or ICverbose == 1) then
		ChatFrame4:AddMessage(msg);
--		ImmunityClockTargetText:SetText(msg);
	end
end
--******************************************************************************************************
-- Looks up player stats
function pc_lookup(name, origname)
	
	local race;
	local class;
	local level;

	if (name ~= origname) then
		ICmsg(format("IC pc_lookup(): calling TargetByName("..name..")"));
		TargetByName(name);
	end

	race = UnitRace("target");
	class = UnitClass("target");
	level = UnitLevel("target");

	if (origname ~= name) then
		if (origname == nil) then
			ICmsg("IC pc_lookup(): calling ClearTarget()");
			ClearTarget();
		else
			ICmsg(format("IC pc_lookup(): calling TargetByName("..origname..")"));
			TargetByName(origname);
		end
	end
end

--******************************************************************************************************
-- adds a new name to the tracking list
function add_clock (name, type, duration, cooldown, buff)
	
	local k;
	local n;
	local indx;
	local disp_ptr;
	local ac_name;

	-- Is there already a clock running for it? If this is a buff, then overwrite that entry.
	-- if this is an fear-in-progress detection, then don't start a new clock.

	indx = 0;
	k=1;
	while (k <= ICMAXINDEX) do
		if (ICtarget[k].name == name and ICtarget[k].immune ~= 0) then
			if( buff == 0) then
				-- we're already tracking this event
				return;
			else
				-- this guy became immune again before we expected it. Reset clock
				indx = k;
			end
		end
		k=k+1;
	end

	-- which slot are we editing?
	if (indx == 0) then
		-- this is a new clock, find the next open slot
		ICindex=ICindex + 1;
		if (ICindex > ICMAXINDEX) then
			ICindex = 1;
		end
		indx = ICindex;
	end

	ICtarget[indx].name=name;
	ICtarget[indx].type=type;
	ICtarget[indx].cooldown=cooldown;
	ICtarget[indx].duration=duration;
	ICtarget[indx].immune=1;
	ICtarget[indx].timer=0;

	-- Display the counter. Buffs are detected for all characters, so make sure we're operating on the right
	-- person.
	if (buff == 1) then
		ac_name = UnitName("target");
		if (ac_name == name) then
			ImmunityClockTargetText:SetText(format("IMMUNE "..ICtarget[indx].duration.."/"..ICtarget[indx].duration));
			ImmunityClockTargetFrame:Show();
			PlaySoundFile("\\Interface\\Add-On\\qImmunityClock\\warning.wav");
		end
	end

	-- add the name to the separate window
	n = 1;
	while (n <= ICMAXINDEX ) do
		disp_ptr = getglobal("ImmunityClockWindowText"..n);

		if (disp_ptr:GetText() == " ") then
			ICmsg(format("IC add_clock(): found first open slot at: "..n));
			ICtarget[indx].display=disp_ptr;
			ICtarget[indx].display:SetText(format("|cffff0000 "..ICtarget[indx].name.." ("..ICtarget[indx].type.."): Immune "..ICtarget[indx].duration.."/"..ICtarget[indx].duration));
			ImmunityClockWindowFrame:SetHeight(30 + (13 * n) ); 
			n = ICMAXINDEX + 1;
		end
		n = n + 1;
	end
	ImmunityClockWindowFrame:Show();
end

--******************************************************************************************************
-- Initialization
function ImmunityClockFrame_OnLoad()
	
	-- Register for events
--	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterForDrag("LeftButton");

	-- UI Commands

	SLASH_ImmunityClock1 = "/Immunityclock";
	SLASH_ImmunityClock2 = "/ic";
	SlashCmdList["ImmunityClock"] = ImmunityClock_SlashHandler;

	ImmunityClockFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
	ImmunityClockFrame:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE");
	ImmunityClockFrame:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF");
	ImmunityClockFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS");
	ImmunityClockFrame:RegisterEvent("CHAT_MSG_SPELL_FRIENDLY_PLAYER_BUFF");
	ImmunityClockFrame:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH");
	ImmunityClockFrame:RegisterEvent("PLAYER_TARGET_CHANGED");


	ICicon=1;
	ICindex=0;

	ChatFrame1:AddMessage("|cffffff00 Immunity Clock Loaded.");
	UIErrorsFrame:AddMessage("Quel's Immunity Clock Loaded.", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);

--	message(format(ICtarget[1].name.." "..ICtarget[2].name));
--	message("Immunity Clock is activated");

end

function ImmunityClockWindowFrame_OnLoad()

	this:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
	this:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 0);

	ImmunityClockWindowText1:SetText(" ");
	ImmunityClockWindowText2:SetText(" ");
	ImmunityClockWindowText3:SetText(" ");
	ImmunityClockWindowText4:SetText(" ");
	ImmunityClockWindowText5:SetText(" ");
	
	ImmunityClockWindowFrame:SetHeight("30");
end
--******************************************************************************************************
-- Handles UI  commands
function ImmunityClock_SlashHandler(arg1)
	local str;
	local opt;

	if(arg1 == "") then
		ChatFrame1:AddMessage("--ImmunityClock Help--");
		ChatFrame1:AddMessage("/ImmunityClock <on|off>");
		ChatFrame1:AddMessage("/ic <on|off>");
		if (ICicon == 0) then
			ChatFrame1:AddMessage("Immunity Clock is currently OFF");
		else
			ChatFrame1:AddMessage("Immunity Clock is currently ON");
		end

		return;
	end

	opt=string.find(arg1,"debug");
	if (opt ~= nil) then
		if (ICdebug == 0) then
			ICdebug = 1;
			ChatFrame1:AddMessage("Immunity Clock debug messages enabled");
		else
			ICdebug = 0;
			ChatFrame1:AddMessage("Immunity Clock debug messages disabled");
		end
		return;
	end

	opt=string.find(arg1,"verbose");
	if (opt ~= nil) then
		if (ICverbose == 0) then
			ICverbose = 1;
			ChatFrame1:AddMessage("Immunity Clock verbose messages enabled");
		else
			ICverbose = 0;
			ChatFrame1:AddMessage("Immunity Clock verbose messages disabled");
		end
		return;
	end

	opt=string.find(arg1,"off");
	if (opt ~= nil) then
		ImmunityClockFrame:UnregisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
		ImmunityClockFrame:UnregisterEvent("CHAT_MSG_SPELL_PET_DAMAGE");
		ImmunityClockFrame:UnregisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF");
		ImmunityClockFrame:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS");
		ImmunityClockFrame:UnregisterEvent("CHAT_MSG_SPELL_FRIENDLY_PLAYER_BUFF");
		ImmunityClockFrame:UnregisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH");
		ImmunityClockFrame:UnregisterEvent("PLAYER_TARGET_CHANGED");


		ImmunityClockTargetFrame:Hide();
		ChatFrame1:AddMessage("Immunity Clock Deactivated");
		ChatFrame4:AddMessage("Immunity Clock Deactivated");

		ImmunityClockWindowFrame:Hide();
		ImmunityClockWindowText1:SetText(" ");
		ImmunityClockWindowText2:SetText(" ");
		ImmunityClockWindowText3:SetText(" ");
		ImmunityClockWindowText4:SetText(" ");
		ImmunityClockWindowText5:SetText(" ");

		ICindex=0;
		ICimmunity=0;

		ICicon=0;
		return;
	end

	opt=string.find(arg1,"on");
	if (opt ~= nil) then
		ImmunityClockFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
		ImmunityClockFrame:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE");
		ImmunityClockFrame:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF");
		ImmunityClockFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS");
		ImmunityClockFrame:RegisterEvent("CHAT_MSG_SPELL_FRIENDLY_PLAYER_BUFF");
		ImmunityClockFrame:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH");
		ImmunityClockFrame:RegisterEvent("PLAYER_TARGET_CHANGED");

		ChatFrame1:AddMessage("Immunity Clock Activated");
		ChatFrame4:AddMessage("Immunity Clock Activated");

		if (ICdebug == 1) then
			ImmunityClockTargetText:SetText(format("ImmunityClock On"));
			ImmunityClockTargetFrame:Show();
		end

		UIErrorsFrame:AddMessage("Immunity Clock Enabled.", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);

		ImmunityClockTitleText:SetText("Immunity Clock");
		ImmunityClockWindowFrame:SetHeight("30");	-- 30 + (15 * x)

		ICicon=1;
		ICindex=0;
		return;
	end
end

--******************************************************************************************************
-- Event handler 
-- variables: event = the event code, arg1= message shown to player upon that event, 
--	arg2= so far always blank

function ImmunityClockFrame_OnEvent(event,arg1)
ICmsg("OnEvent");
	local sub1;
	local sub2;
	local sub3;

	local name;
	local type;
	local duration;
	local cooldown;

	local immunity=0;
	local k;
	local n;

	if (ICicon == 0) then
		return;
	end

	flag = 0;

	if (arg1 ~= nil) then
		ICmsg(format("IC OnEvent(): "..event.." "..arg1));
	else
		ICmsg(format("IC OnEvent(): "..event));
	end

	-- store the target we already have, if we have one.
	origname=UnitName("target");
	
	if (event == "PLAYER_TARGET_CHANGED") then
		-- If we've switched targets, we may need to turn the window on or off
		k = 1;
		while (k <= ICMAXINDEX ) do
			if (origname == ICtarget[k].name and ICtarget[k].immune == 1) then
				ImmunityClockTargetFrame:Show();
				return;
			end
			k=k+1;
		end
		ImmunityClockTargetFrame:Hide();
		return;

	elseif (event == "PLAYER_DEAD") then
		-- I had thought about clearing the clock window, but I'd rather keep it up. Maybe
		-- my warlock wants to wait out the timer, then reincarnate.
		return;

	elseif (event == "CHAT_MSG_COMBAT_HOSTILE_DEATH") then
		-- I originally cleared the window when the target died. But, what if the target is a warlock
		-- about to reincarnate? or the fight is near a graveyard? I think we need to keep tracking
		-- because we may see them again before the cooldown runs out.
		return;

	elseif (event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF" or 
	        event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS" or
		event == "CHAT_MSG_SPELL_FRIENDYPLAYER_BUFF") then 

		-- find unit's name the hard way
		sub2=string.find(arg1," ");	-- "blah gains Will of the forsaken"                                    
		name=string.sub(arg1, 1, sub2 -1);

		if ( string.find(arg1,"gains Will of the Forsaken") ~= nil) then
			ICmsg("	IC OnEvent: Will of the Forsaken detected");
			cooldown=115;
			duration=5;
			type="undead";

		elseif (string.find(arg1,"gains Fearless") ~= nil) then
			ICmsg("	IC OnEvent: trinket use detected");
			cooldown=570; 
			duration=30;
			type="trinket";

		elseif (string.find(arg1,"gains Ice Block") ~= nil) then
			ICmsg( "IC OnEvent: Mage Ice Block detected");
			cooldown=290;
			duration=10;
			type="mage";

		elseif (string.find(arg1,"Sacrifice") ~= nil) then
			ICmsg("	IC OnEvent: Voidwalker Sacrifice detected");
			cooldown=.05; 
			duration=30;
			type="warlock";

		elseif (string.find(arg1,"gains Divine Protection") ~= nil) then
			ICmsg("	IC OnEvent: Divine Protection detected");
			race,class,level = pc_lookup(name, origname);
		
			if (level >= 18) then
				cooldown=292;
				duration=8;
			else
				cooldown=294;
				duration=6;
			end
			type="paladin";

		elseif (string.find(arg1,"gains Divine Shield") ~= nil) then
			ICmsg(" IC OnEvent: Divine Shield detected");
			race,class,level = pc_lookup(name, origname);
			
			if (level ~= nil) then
				if (level >= 50) then
					cooldown=288;
					duration=12;
				else
					cooldown=290;
					duration=10;
				end
			else
				-- if my level > 40, the target must be 50+
				level = UnitLevel("player");
				if (level > 40) then
					cooldown=288;
					duration=12;
				else
					cooldown=290;
					duration=10;
				end
			end

			type="paladin";

		elseif (string.find(arg1,"Grounding Totem") ~= nil) then
			ICmsg(" IC OnEvent: grounding totem detected");
			cooldown=.05
			duration=45;
			type="grnd totem";

		elseif (string.find(arg1,"Tremor Totem") ~= nil) then
			ICmsg(" IC OnEvent: Tremor totem detected");

			-- this one is a problem. It wakes all party members, which I 
			-- can't detect.
			cooldown=.05
			duration=90;
			type="totem";

		elseif (string.find(arg1,"Berserker Rage") ~= nil) then
			ICmsg(" IC OnEvent: Warrior Berserker Rage detected");
			cooldown=30;
			duration=10;
			type="warrior";

		elseif (string.find(arg1,"Death Wish") ~= nil) then
			ICmsg(" IC OnEvent: Warrior Death Wish detected");
			cooldown=180;
			duration=30;
			type="warrior";

		else
			-- no immunity buff detected. 
			ICmsg("	IC OnEvent: Not an immunity buff.");
			return;
		end


		add_clock(name, type, duration, cooldown, 1);
		return;

	elseif (event == "CHAT_MSG_SPELL_SELF_DAMAGE" or 
	        event == "CHAT_MSG_SPELL_PET_DAMAGE" ) then

		sub1=string.find(arg1,"is immune.");
		sub2=string.find(arg1,"Fear failed.");
		sub3=string.find(arg1,"Seduction fails.");

		if (sub1 == nil or (sub2 == nil and sub3 == nil) ) then
			-- this was not an immunity event, or not immune to fear/seduce
			ICmsg("IC OnEvent(): This was not a fear-immunity event");
			if (ICdebug == 0) then
				return;
			end
			-- otherwise, let the counter start anyway for debugging
		end
		
		if (UnitIsPlayer("target") ) then
			if (event == "CHAT_MSG_SPELL_PET_DAMAGE") then
				-- assist the pet
				ICmsg("IC OnEvent(): AssisUnit - I detected a pet spell dmg am assisting the pet.");
				AssistUnit("pet");
				name=UnitName("target");
				race,class,level = pc_lookup(name, origname);

			else --(event == "CHAT_MSG_SPELL_SELF_DAMAGE") then
				name = origname;
				race,class,level = pc_lookup(origname, origname);
			end
			
			-- we have to guesstimate what immunity this guy used.
			if (race == "Undead") then
				cooldown=100;
				duration=20;
				type="undead?";
			
			elseif (class == "Mage") then
				cooldown=290;
				duration=10;
				type="mage?";

			elseif (class == "Warlock") then
				cooldown=.05; 
				duration=30;
				type="warlock?";

			elseif (class == "Paladin") then
				-- we can only guess which spell the pally may have cast
				if (level >= 50) then
					cooldown=288;
					duration=30;
				elseif(level >= 34) then
					cooldown=290;
					duration=10;
				elseif(level >= 18) then
					cooldown=292;
					duration=8;
				else --(level >= 6) then
					cooldown=294;
					duration=6;
				end
				type="paladin?";

			elseif (class == "Shaman") then
				-- we'll never get here, because the message reports that the totem is immune
				-- not the player
				cooldown=.05;
				duration=45;
				type="totem?";

			else
				-- type could be trinket, or paladin cast this on someone else. We'll just
				-- guess that it's the trinket because in the heat of the battle, it seems
				-- less likely the pally is casting immunity on others.
				cooldown=.01; 
				duration=30;
				type="Dim returns?";
			end

			add_clock(name, type, duration, cooldown, 0);
			return;

		else
			-- we don't support tracking immunity on NPCs
			if (nil == origname) then
				-- sometimes we pick up an immunity message when someone else casts on an NPC
				-- but we don't have a target. In that case, just bail.
				return;
			end

			UIErrorsFrame:AddMessage("NPC is immune!", 1.0, 1.0, 1.0, 1.0, (UIERRORS_HOLD_TIME * 2) );
			if (ICdebug == 1) then
				-- allow any dmg spell to trigger a clock on this NPC for debugging
				type = "NPC-debug";
				cooldown=30;
				duration=20;	
				add_clock(name, type, duration, cooldown, 0);
			end
			return;
		end
	else
		-- unknown entry
		return;
	end

	-- Display the counter. 
end

--******************************************************************************************************
-- OnUpdate is called apparently everytime a new Frame is drawn, according to 
--	the sources on the web. arg1 = number of seconds since last time OnUpdate was called.

-- This function is responsible for updating the clock window and shutting it off when the
--	cooldown expires.

function ImmunityClockFrame_OnUpdate(arg1)
	local icou_name;
	local level;
	local m;
	local o;
	local p;

	if (ICicon == 0) then
		return;
	end

	IConesec=IConesec+arg1;	-- allow screen writes no more than 1 per second.
	icou_name=UnitName("target");

	m=1;
	while (m <= ICMAXINDEX) do
		-- Immunity values: 0=none detected; 1=Immunity detected; 2=ICcooldown period
		if (ICtarget[m].immune == 0) then
			-- this target does not have active immunity. If this is the currently selected target, the
			-- sure the TargetFrame got turned off.
			if (ICtarget[m].name == icou_name) then
				ImmunityClockTargetFrame:Hide();
			end

		elseif (ICtarget[m].immune == 1) then
			--Immunity has been detected on this unit.
			if (arg1 + ICtarget[m].timer < ICtarget[m].duration) then	
				-- The length of time since we detected Immunity is less than expected duration. Update the
				-- the counter and display the new value 
				if (IConesec >= .1) then
					ICtarget[m].display:SetText(format("|cffff0000 "..ICtarget[m].name.." ("..ICtarget[m].type..") Immune %.1f / %d", ICtarget[m].duration-ICtarget[m].timer-arg1, ICtarget[m].duration));

					if (ICtarget[m].name == icou_name ) then
						-- The target frame should already be shown. But, just in case...
						ImmunityClockTargetFrame:Show();
						ImmunityClockTargetText:SetText(format("IMMUNITY %.1f / %d", ICtarget[m].duration-ICtarget[m].timer-arg1, ICtarget[m].duration));
					end
				end

				ICtarget[m].timer=ICtarget[m].timer + arg1;
			else
				-- the Immunity has now lasted longer than the expected duration. Transistion to ICcooldown.
				ICtarget[m].timer=0;
				ICtarget[m].immune=2;
			end

		elseif (ICtarget[m].immune == 2) then
			--ICcooldown period has been detected
			if (arg1 + ICtarget[m].timer < ICtarget[m].cooldown) then
				-- The length of time since we detected Immunity stopped is less than the ICcooldown. Update the
				-- the counter and display the new value 
				if (IConesec >= .1) then
					ICtarget[m].display:SetText(format("|c0000ff00 "..ICtarget[m].name.." ("..ICtarget[m].type..") Cooling %.1f / %d",ICtarget[m].cooldown-ICtarget[m].timer-arg1, ICtarget[m].cooldown ));
					if (ICtarget[m].name == icou_name ) then
						-- the target frame should already be shown. But, just in case...
						ImmunityClockTargetFrame:Show();
						ImmunityClockTargetText:SetText(format("Cooldown %.1f / %d", ICtarget[m].cooldown-ICtarget[m].timer-arg1, ICtarget[m].cooldown));
					end
				end
				ICtarget[m].timer=ICtarget[m].timer + arg1;
			else
				-- the ICcooldown has now loasted longer than the expected duration. Clear everything.
				ICmsg(format("hiding slot "..m));
				if (ICtarget[m].name == icou_name ) then
					ImmunityClockTargetFrame:Hide();
				end
				ImmunityClockWindowFrame:SetHeight(ImmunityClockWindowFrame:GetHeight() - 13);
				ICtarget[m].display:SetText(" ");

				ICtarget[m].display="none";
				ICtarget[m].timer=0;
				ICtarget[m].immune=0;
				ICtarget[m].duration=0;
				ICtarget[m].cooldown=0;
				ICtarget[m].level=0;
				ICtarget[m].name="none";
				ICtarget[m].type="none";
				ICtarget[m].race="none";
			end
		else
			--unknown/bad ICimmunity value
			ICmsg(format("IC OnUpdate(): "..ICtarget[m].name.."has bad immunity value"));
		end

		m=m+1;

	end -- while (m <= ICMAXINDEX)

	-- condense the display as names fall off so there aren't holes.
	o=1;
	p=1
	while (o <= ICMAXINDEX) do
		if (ICtarget[o].display ~= "none") then
			ICtarget[p].display=ICtarget[o].display;
			ICtarget[p].timer=ICtarget[o].timer;
			ICtarget[p].immune=ICtarget[o].immune;
			ICtarget[p].duration=ICtarget[o].duration;
			ICtarget[p].cooldown=ICtarget[o].cooldown;
			ICtarget[p].level=ICtarget[o].level;
			ICtarget[p].name=ICtarget[o].name;
			ICtarget[p].type=ICtarget[o].type;
			ICtarget[p].race=ICtarget[o].race;
			
			if (o ~= p) then
				ICtarget[o].display ="none";
				ICtarget[o].timer=0;
				ICtarget[o].immune=0;
				ICtarget[o].duration=0;
				ICtarget[o].cooldown=0;
				ICtarget[o].level=0;
				ICtarget[o].name="none";
				ICtarget[o].type="none";
				ICtarget[o].race="none";
			end
			p=p+1
		end
		o = o + 1;
	end
	ICindex=p-1; -- ICindex always points to the last used slot.
	o = 1;
	p = 1;
	while (o <= ICMAXINDEX) do
		if (ICtarget[o].display ~= "none") then
			disp_ptr = getglobal("ImmunityClockWindowText"..p);
			text = ICtarget[o].display:GetText();
			ICtarget[o].display:SetText(" ");
			ICtarget[o].display=disp_ptr;
			ICtarget[o].display:SetText(text);
			p = p + 1;
		end
		o = o + 1;
	end

	-- if there's nobody being tracked, hide the window
	if (p == 1) then
		ImmunityClockWindowFrame:Hide()
	end

	-- allow screen writes no more than 1 per second
	if (IConesec >= .1) then
		IConesec=0;
	end
end