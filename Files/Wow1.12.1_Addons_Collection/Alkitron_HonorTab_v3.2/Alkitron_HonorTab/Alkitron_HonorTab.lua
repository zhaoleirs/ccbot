--[[
	Alkitron Honor Tab
	Replaces the standard Honor tab with an enhanced version.
	
	by morganti@chogall, http://ui.worldofwar.net/users.php?name=morg
]]


local playerID;
HF_INFO = {};
hfsaved = {};
honor_last = 0;
--don't change these values
last_update = time();
scoreboardscan_interval = 1;

function HonorFrame_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_PVP_RANK_CHANGED");
	this:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN");
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF");
	this:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
	this:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
	this:RegisterEvent("UPDATE_WORLD_STATES");
end

function resethonor()
		local hky, dky, contributiony = GetPVPYesterdayStats();
		local hkt, dkt = GetPVPSessionStats();
		local hkw, contributionw = GetPVPThisWeekStats();
		local hklw, dklw, contributionlw, ranklw = GetPVPLastWeekStats();

		playerID = UnitName("player").." - "..GetRealmName();

		HF_INFO[playerID] = {
			["honor_yesterday"] = contributiony;
			["honor"]						= 0;
			["honor_bonus"] 		= 0;
			["kills_today"]			= hkt;
			["kills_yesterday"]  = hky;
			["honor_week"]			= contributionw;
			["faction"]					= checkfaction();
			["verbose"]					= 1;
			["honor_lastweek"]	= contributionlw;
			["honor_twoweeksago"]= 0;
			["kills_lastweek"]	= hklw;
			["kills_twoweeksago"]= 0;
			["standing_lastweek"]	= ranklw;
			["standing_twoweeksago"]= 0;
			["hk_list"]	= {};
		};
		
		hfsaved = HF_INFO[playerID];
		HonorFrame_Update();

		DEFAULT_CHAT_FRAME:AddMessage("[Alkitron Honor Tab] RESET: UnitFactionGroup returned " .. hfsaved.faction);
end

function checkfaction()
	local factiongroup = UnitFactionGroup("player");

		if (factiongroup == "Alliance") then 
			factiongroup = 1;
		elseif (factiongroup == "Horde") then
			factiongroup = 0;
		elseif (factiongroup == nil) then
			factiongroup = 2;
			DEFAULT_CHAT_FRAME:AddMessage("[Alkitron Honor Tab] ERROR: UnitFactionGroup() returned nil");
		end

	return factiongroup;
end

function HonorFrame_OnEvent(event)
	if (event == "VARIABLES_LOADED") then

		local hky, dky, contributiony = GetPVPYesterdayStats();
		local hkt, dkt = GetPVPSessionStats();
		local hkw, contributionw = GetPVPThisWeekStats();
		local hklw, dklw, contributionlw, ranklw = GetPVPLastWeekStats();

		playerID = UnitName("player").." - "..GetRealmName();
		
		if (not HF_INFO[playerID]) then
			HF_INFO[playerID] = {
				["honor_yesterday"] = contributiony;
				["honor"]						= 0;
				["honor_bonus"] 		= 0;
				["kills_today"]			= hkt;
				["kills_yesterday"]  = hky;
				["honor_week"]			= contributionw;
				["faction"]					= checkfaction();
				["verbose"]					= 1;
				["honor_lastweek"]	= contributionlw;
				["honor_twoweeksago"]= 0;
				["kills_lastweek"]	= hklw;
				["kills_twoweeksago"]= 0;
				["standing_lastweek"]	= ranklw;
				["standing_twoweeksago"]= 0;
				['hk_list'] = {};
			};
		end
		
		hfsaved = HF_INFO[playerID];

		if (hfsaved.kills_today == nil) then hfsaved.kills_today = hkt; end
		if (hfsaved.kills_yesterday == nil) then hfsaved.kills_yesterday = hky; end
		if (HF_INFO[playerID]['hk_list'] == nil) then HF_INFO[playerID]['hk_list'] = {}; end
		if (hfsaved.honor_week == nil) then hfsaved.honor_week = contributionw; end
		if (hfsaved.faction == nil) then hfsaved.faction = checkfaction(); end
		if (hfsaved.verbose == nil) then hfsaved.verbose = 1; end
		
		if (hfsaved.kills_lastweek == nil) then hfsaved.kills_lastweek = hklw; hfsaved.kills_twoweeksago = 0; end
		if (hfsaved.honor_lastweek == nil) then hfsaved.honor_lastweek = contributionlw; hfsaved.honor_twoweeksago = 0; end
		if (hfsaved.standing_lastweek == nil) then hfsaved.standing_lastweek = ranklw; hfsaved.standing_twoweeksago = 0; end
		

		HonorFrame_Update();
		DEFAULT_CHAT_FRAME:AddMessage("[Alkitron Honor Tab] Loaded for " .. playerID);
		
	elseif ( event == "PLAYER_PVP_KILLS_CHANGED" or event == "PLAYER_PVP_RANK_CHANGED") then
	
		HonorFrame_Update();
		
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
	
		HonorFrame_Update();
		
	elseif ( event == "CHAT_MSG_COMBAT_HONOR_GAIN") then

		if (arg1 == "You have been awarded 199 honor points.") then
			hfsaved.honor_bonus = hfsaved.honor_bonus + 199;
			HonorFrame_Update();
			if (hfsaved.verbose == 1) then
				DEFAULT_CHAT_FRAME:AddMessage("Bonus Honor gained: 199.", 1, 1, 0);
			end
			return;
		elseif (arg1 == "You have been awarded 189 honor points.") then
			hfsaved.honor_bonus = hfsaved.honor_bonus + 189;
			HonorFrame_Update();
			if (hfsaved.verbose == 1) then
				DEFAULT_CHAT_FRAME:AddMessage("Bonus Honor gained: 189.", 1, 1, 0);
			end
			return;
		end		
		
		local Pattern =  string.gsub(string.gsub(COMBATLOG_HONORGAIN, "([()])", "%%%1"), "%%[ds]", "([%%w ]+)");
		local s,e,hk_thisplayer,honor_thisplayer,honor_diminished,diminishing_return,ename,erank,ehonor;

		s, e, ename, erank, ehonor = string.find(arg1, Pattern);

		if (ename) and (erank) and (ehonor) then
		
			if (not HF_INFO[playerID]['hk_list'][ename]) then
				HF_INFO[playerID]['hk_list'][ename] = { ['killed'] = 1; ['honor_total'] = 0; };	
			else
				HF_INFO[playerID]['hk_list'][ename]['killed'] = HF_INFO[playerID]['hk_list'][ename]['killed'] + 1;
				--HF_INFO[playerID]['hk_list'][ename]['honor_total'] = HF_INFO[playerID]['hk_list'][ename]['honor_total'] + ehonor;
			end
			
			hk_thisplayer = HF_INFO[playerID]['hk_list'][ename]['killed'];
			honor_thisplayer = HF_INFO[playerID]['hk_list'][ename]['honor_total'];
			
			if (hk_thisplayer == 1) then
				diminishing_return = 1;
			elseif (hk_thisplayer == 2) then
				diminishing_return = .9;
			elseif (hk_thisplayer == 3) then
				diminishing_return = .8;
			elseif (hk_thisplayer == 4) then
				diminishing_return = .7;
			elseif (hk_thisplayer == 5) then
				diminishing_return = .6;
			elseif (hk_thisplayer == 6) then
				diminishing_return = .5;
			elseif (hk_thisplayer == 7) then
				diminishing_return = .4;
			elseif (hk_thisplayer == 8) then
				diminishing_return = .3;
			elseif (hk_thisplayer == 9) then
				diminishing_return = .2;
			elseif (hk_thisplayer == 10) then
				diminishing_return = .1;							
			else
				diminishing_return = 0;
			end
			
			honor_diminished = ehonor * diminishing_return;
			
			if (honor_diminished - floor(honor_diminished) > .5) then
				honor_diminished = ceil(honor_diminished);
			else
				honor_diminished = floor(honor_diminished);
			end

			HF_INFO[playerID]['hk_list'][ename]['honor_total'] = HF_INFO[playerID]['hk_list'][ename]['honor_total'] + honor_diminished;
      
			hfsaved.honor = honor_diminished + hfsaved.honor;
			hfsaved.kills_today = hfsaved.kills_today + 1;
			
			HonorFrame_Update();
			
			if (hfsaved.verbose == 1 and diminishing_return == 0) then
      	DEFAULT_CHAT_FRAME:AddMessage(ename .. " is no longer worth any honor (" .. hk_thisplayer .. " kills / " .. honor_thisplayer .. " honor)");
      end
      	
		end
		
	elseif ( event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF") then

		local bonushonortext = "begins to cast Honor Points %+(%d+)";
		local bonushonor = 0;
		
		for bonushonor in string.gfind(arg1, bonushonortext) do	
			hfsaved.honor_bonus = hfsaved.honor_bonus + tonumber(bonushonor);
			HonorFrame_Update();
			if(hfsaved.verbose == 1) then
				DEFAULT_CHAT_FRAME:AddMessage("Bonus Honor gained: " .. bonushonor .. ".", 1, 1, 0);
			end			
		end
		
	elseif (event == "UPDATE_BATTLEFIELD_STATUS") then

			RequestBattlefieldScoreData();
			
	elseif (event == "UPDATE_BATTLEFIELD_SCORE") then

		checkscoreboard();

  elseif (event == "UPDATE_WORLD_STATES") then
  
  	local temptime = time() - last_update;
  	
		if (temptime >= scoreboardscan_interval) then
			checkscoreboard();
    end

	end
end

function checkscoreboard()
	    local name, kills, killingBlows, deaths, honorGained, faction, rank, race, class, tempbonus, i, e;
	    
			RequestBattlefieldScoreData();
			e = GetNumBattlefieldScores();
			last_update = time();
			
    	for i=1, e do
				name, killingBlows, honorableKills, deaths, honorGained,
				faction, rank, race, class = GetBattlefieldScore(i);
				if (faction == hfsaved.faction) then
	        if (name == UnitName("player")) then
	        		if (honorGained == 0) then
	        			honor_last = 0;
	        		end
	        		if (honorGained > honor_last) then
	        				tempbonus = (honorGained - honor_last);
	        				honor_last = honorGained;
	   							hfsaved.honor_bonus = hfsaved.honor_bonus + tempbonus;
	        				HonorFrame_Update();
	        				
	        				if (hfsaved.verbose == 1) then
	        					DEFAULT_CHAT_FRAME:AddMessage("Adding " .. tempbonus .. " bonus honor.", 1, 1, 0);
	        				end
	        		end
	        		i = e;
	        end
	      else
	      	if (hfsaved.faction == 2) then
	      		DEFAULT_CHAT_FRAME:AddMessage("[Alkitron Honor Tab] Improper faction variable detected, attempting to fix...");
	      		hfsaved.faction = checkfaction();
	      		DEFAULT_CHAT_FRAME:AddMessage("[Alkitron Honor Tab] Faction set to: " .. hfsaved.faction .. " (1=Alliance,0=Horde,2=nil)");
					end
	      end
    	end
end

function checkrollover()
	local hkw, contributionw = GetPVPThisWeekStats();
	local hks, dks = GetPVPSessionStats();
	--local hky, dky, contributiony = GetPVPYesterdayStats();

		if (hfsaved.honor_week < contributionw) then

			hfsaved.kills_yesterday = hfsaved.kills_today;
			hfsaved.honor_yesterday = hfsaved.honor + hfsaved.honor_bonus;
			hfsaved.honor_bonus = 0;
			hfsaved.honor  = 0;
			hfsaved.kills_today = 0;
			hfsaved.honor_week = contributionw;
			HF_INFO[playerID]['hk_list'] = {};

			DEFAULT_CHAT_FRAME:AddMessage("[Alkitron Honor Tab] Just reset stats for the day. (1)");

		elseif (hfsaved.honor_week > contributionw and contributionw == 0) then
			
			local hklw, dklw, contributionlw, ranklw = GetPVPLastWeekStats();
	
				if (hfsaved.honor_week <= contributionlw) then

					hfsaved.kills_yesterday = hfsaved.kills_today;
					hfsaved.honor_yesterday = hfsaved.honor + hfsaved.honor_bonus;
					hfsaved.honor_bonus = 0;
					hfsaved.honor  = 0;
					hfsaved.kills_today = 0;
					hfsaved.honor_week = 0;
					
					hfsaved.standing_twoweeksago = hfsaved.standing_lastweek;
					hfsaved.standing_lastweek = ranklw;

					hfsaved.kills_twoweeksago = hfsaved.kills_lastweek;
					hfsaved.kills_lastweek = hklw;			

					hfsaved.honor_twoweeksago = hfsaved.honor_lastweek;		
					hfsaved.honor_lastweek = contributionlw;

					HF_INFO[playerID]['hk_list'] = {};

					DEFAULT_CHAT_FRAME:AddMessage("[Alkitron Honor Tab] Just reset stats for the week.");

				end

		end
end

function HonorFrame_Update()
	local hk, hky, dk, contribution, rank, highestRank, rankName, rankNumber, temptotal;

	checkrollover();

	hk = hfsaved.kills_today;
	temptotal = hfsaved.honor + hfsaved.honor_bonus;

	-- This session's values
	HonorFrameCurrentHKText:SetText("Kills");
	--HonorFrameCurrentSessionTitle:SetText("Today's Honor");
	HonorFrameCurrentHKValue:SetTextColor(1,1,1);
	HonorFrameCurrentHKValue:SetText("Estimated / Bonus / Total Honor");
	HonorFrameCurrentDKText:SetTextColor(0,1,0);	
	HonorFrameCurrentDKText:SetText(hk);
	HonorFrameCurrentDKValue:SetTextColor(0,1,0);
	if (hfsaved.honor == 0 and hfsaved.honor_bonus == 0) then
		HonorFrameCurrentDKValue:SetText("none");
	else
		HonorFrameCurrentDKValue:SetText(hfsaved.honor .. " + " .. hfsaved.honor_bonus .. " = " .. temptotal);	
	end
	
	
	-- Yesterday's values
	hk, dk, contribution = GetPVPYesterdayStats();
	hky = hfsaved.kills_yesterday;
	
	--HonorFrameYesterdayTitle:SetText("Yesterday's Honor");
	HonorFrameYesterdayHKText:SetText("Kills");
	HonorFrameYesterdayHKValue:SetTextColor(1,1,1);	
	HonorFrameYesterdayHKValue:SetText("Estimated / Actual Honor");	
	HonorFrameYesterdayContributionText:SetTextColor(0,1,0);
	HonorFrameYesterdayContributionText:SetText(hk);
	HonorFrameYesterdayContributionValue:SetTextColor(0,1,0);
	if (contribution == 0) then
		HonorFrameYesterdayContributionValue:SetText("none");	
	else
		HonorFrameYesterdayContributionValue:SetText(hfsaved.honor_yesterday .. " / " .. contribution);
	end


	-- This Week's values
	hk, contribution = GetPVPThisWeekStats();		
	local temptotal2 = contribution + temptotal;
	local temptotal3 = hk + hfsaved.kills_today;

	--HonorFrameThisWeekTitle:SetText("This Week's Honor");
	HonorFrameThisWeekHKText:SetTextColor(1,1,1);	
	HonorFrameThisWeekHKText:SetText("Kills");
	HonorFrameThisWeekContributionText:SetTextColor(0,1,0);
	HonorFrameThisWeekContributionText:SetText(temptotal3);	
	HonorFrameThisWeekHKValue:SetTextColor(1,1,1);	
	HonorFrameThisWeekHKValue:SetText("Today / This Week / Total Honor");
	HonorFrameThisWeekContributionValue:SetTextColor(0,1,0);
	if (contribution == 0 and temptotal == 0) then
		HonorFrameThisWeekContributionValue:SetText("none");		
	else
		if (temptotal == 0) then temptotal = "none"; end
		HonorFrameThisWeekContributionValue:SetText(temptotal .. " + " .. contribution .. " = " .. temptotal2);	
	end

	-- Last Week's values
	hk, dk, contribution, rank = GetPVPLastWeekStats();
	HonorFrameLastWeekTitle:SetText("History");
	HonorFrameLastWeekHKText:SetText("");
	HonorFrameLastWeekHKValue:SetTextColor(1,1,1);
	HonorFrameLastWeekHKValue:SetText("Standing / Kills / Honor");
	--HonorFrameLastWeekHKValue:SetText(hk);
	HonorFrameLastWeekContributionText:SetText("Last Week");
	HonorFrameLastWeekContributionValue:SetTextColor(1,.8,0);
	--HonorFrameLastWeekContributionValue:SetText(contribution);
	HonorFrameLastWeekContributionValue:SetText(rank .. " - " .. hk .. " - " .. contribution);
	HonorFrameLastWeekStandingText:SetText("Two Weeks Ago");
	HonorFrameLastWeekStandingValue:SetTextColor(1,.5,0);
	HonorFrameLastWeekStandingValue:SetText(hfsaved.standing_twoweeksago .. " - " .. hfsaved.kills_twoweeksago .. " - " .. hfsaved.honor_twoweeksago);

	--HonorFrameLastWeekStandingValue:SetText(rank);


	-- Lifetime stats
	hk, dk, highestRank = GetPVPLifetimeStats();
	HonorFrameLifeTimeHKValue:SetText(hk);
	HonorFrameLifeTimeDKValue:SetText(dk);
	rankName, rankNumber = GetPVPRankInfo(highestRank);
	if ( not rankName ) then
		rankName = NONE;
	end
	HonorFrameLifeTimeRankValue:SetText(rankName);

	-- Set rank name and number
	rankName, rankNumber = GetPVPRankInfo(UnitPVPRank("player"));
	if ( not rankName ) then
		rankName = NONE;
	end
	
	-- Calculate How far we are into current rank
	rankPercent = tostring(GetPVPRankProgress() * 100);
	rankPercent = string.sub(rankPercent, 1, 5);
	
	HonorFrameCurrentPVPTitle:SetText(rankName);
	HonorFrameCurrentPVPRank:SetText("("..RANK.." "..rankNumber..")   " .. rankPercent .. "%");
	
	-- Set icon
	if ( rankNumber > 0 ) then
		HonorFramePvPIcon:SetTexture(format("%s%02d","Interface\\PvPRankBadges\\PvPRank",rankNumber));
		HonorFramePvPIcon:Show();
	else
		HonorFramePvPIcon:Hide();
	end
	
	-- Set rank progress and bar color
	local factionGroup, factionName = UnitFactionGroup("player");
	if ( factionGroup == "Alliance" ) then
		HonorFrameProgressBar:SetStatusBarColor(0.05, 0.15, 0.36);
	else
		HonorFrameProgressBar:SetStatusBarColor(0.63, 0.09, 0.09);
	end
	HonorFrameProgressBar:SetValue(GetPVPRankProgress());

	-- Recenter rank text
	HonorFrameCurrentPVPTitle:SetPoint("TOP", "HonorFrame", "TOP", - HonorFrameCurrentPVPRank:GetWidth()/2, -83);
end

function showkills()
	local ename,kills,htotal;
	local i = 0;
	for ename in HF_INFO[playerID]['hk_list'] do
		i = i+ 1;
		kills = HF_INFO[playerID]['hk_list'][ename]['killed'];
		htotal = HF_INFO[playerID]['hk_list'][ename]['honor_total'];
		DEFAULT_CHAT_FRAME:AddMessage(ename .. " " ..  kills .. " " .. htotal);
	end
	DEFAULT_CHAT_FRAME:AddMessage(i .. " entries found");
end