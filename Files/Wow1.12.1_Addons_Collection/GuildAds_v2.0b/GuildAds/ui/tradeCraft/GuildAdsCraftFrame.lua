----------------------------------------------------------------------------------
--
-- GuildAdsCraftFrame.lua
--
-- Author: Zarkan, Fka� of European Ner'zhul (Horde)
-- URL : http://guildads.sourceforge.net
-- Email : guildads@gmail.com
-- Licence: GPL version 2 (General Public License)
----------------------------------------------------------------------------------

local tradeskillPluginLoaded = false;
local craftPluginLoaded = false;

GuildAdsCraftFrame = {

	metaInformations = {
		name = "GuildAdsCraftFrame",
		guildadsCompatible = 100,
	};

	tradeskillPluginLoaded = false;
	craftPluginLoaded = false;

	onLoad = function()
		this:RegisterEvent("CRAFT_SHOW");
		this:RegisterEvent("TRADE_SKILL_SHOW");		
		GuildAdsPlugin.UIregister(GuildAdsCraftFrame);
	end;
	
	onEvent = function(event)
		if event=="CRAFT_SHOW" then
			if not craftPluginLoaded then
				GuildAdsCraftButton:ClearAllPoints();
				GuildAdsCraftButton:SetParent("CraftFrame");
				GuildAdsCraftButton:SetPoint("BOTTOMRIGHT", CraftCancelButton, "TOPRIGHT");
				GuildAdsCraftButton:Show();
				craftPluginLoaded = true;
			end
		elseif event=="TRADE_SKILL_SHOW" then
			if not tradeskillPluginLoaded then
				GuildAdsTradeskillButton:ClearAllPoints();
				GuildAdsTradeskillButton:SetParent("TradeSkillFrame");
				GuildAdsTradeskillButton:SetPoint("BOTTOMRIGHT", TradeSkillCancelButton, "TOPRIGHT");
				GuildAdsTradeskillButton:Show();
				tradeskillPluginLoaded = true;
			end
		end
	end;
	
    onChannelJoin = function()
		if tradeskillPluginLoaded then
			GuildAdsTradeskillButton:Show();
		end
		if craftPluginLoaded then
			GuildAdsCraftButton:Show();
		end
		
    end;

    onChannelLeave = function()
		if tradeskillPluginLoaded then
			GuildAdsTradeskillButton:Hide();
		end
		if craftPluginLoaded then
			GuildAdsCraftButton:Hide();
		end		
    end;
	
	askItem = function(item)
		if item and item.ref then
			local data = GuildAdsDB.channel[GuildAds.channelName].TradeNeed:get(GuildAds.playerName, item.ref);
			if data then
				data.q = data.q + item.count;
			else
				data = { q=item.count, _t=GuildAdsDB:GetCurrentTime() };
			end
			GuildAdsDB.channel[GuildAds.channelName].TradeNeed:set(GuildAds.playerName, item.ref, data);
		end
	end;
	
	onClickHave = function()
		local item = this.value;
		local data = GuildAdsDB.channel[GuildAds.channelName].TradeOffer:get(GuildAds.playerName, item.ref);
		if not data then
			GuildAdsDB.channel[GuildAds.channelName].TradeOffer:set(GuildAds.playerName, item.ref, { _t=GuildAdsDB:GetCurrentTime() });
		end
	end;
	
	onClickAskItem = function()
		local item = this.value;
		GuildAdsCraftFrame.askItem(item);
	end;
	
	onClickAskEverything = function()
		for k,item in this.value do
			GuildAdsCraftFrame.askItem(item);
		end
	end;
	
	buttons = {
		onClick = function(initializeMenu)
			HideDropDownMenu(1);
			GuildAdsCraftFrameMenu.initialize = initializeMenu;
			GuildAdsCraftFrameMenu.displayMode = "MENU";
			GuildAdsCraftFrameMenu.name = "Titre";
			ToggleDropDownMenu(1, nil, GuildAdsCraftFrameMenu, "cursor");	
		end;
		
		initializeTradeskillMenu = function(level)
			local id = TradeSkillFrame.selectedSkill;
			local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(id);
			local count = TradeSkillInputBox:GetNumber();
		
			------
			local composants = { };
			local menu = { };
		
			local count = TradeSkillInputBox:GetNumber();
			local numReagents = GetTradeSkillNumReagents(id);
			for i=1, numReagents, 1 do
				local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i);
				local link = GetTradeSkillReagentItemLink(id, i);
				local itemColor, itemRef, itemName = GuildAds_ExplodeItemRef(link);
				
				local info = {
					notCheckable = 1;
					func = GuildAdsCraftFrame.onClickAskItem;
					tooltipText = GUILDADS_TS_ASKITEMS_TT;
					value = {
						ref = itemRef;
						count = reagentCount
					}
				};
				if (count > 1) then
					info.value.count = (count*reagentCount)-playerReagentCount;
					info.text = GUILDADS_BUTTON_ADDREQUEST.." "..info.value.count.." "..reagentName;
					
				else
					info.text = GUILDADS_BUTTON_ADDREQUEST.." "..reagentName;
				end
				
				tinsert(composants, info.value);
				tinsert(menu, info);
			end
			
			---- Propose
			local link = GetTradeSkillItemLink(id);
			local itemColor, itemRef, itemName = GuildAds_ExplodeItemRef(link);
			
			info = {
				text = GUILDADS_BUTTON_ADDAVAILABLE.." "..skillName;
				notCheckable = 1;
				func = GuildAdsCraftFrame.onClickHave;
				value = { 
					ref=itemRef;
					count=count;
				};
			};
			UIDropDownMenu_AddButton(info, 1);
			
			---- Demande tous les composants
			info = {
				notCheckable = 1;
				text = string.format(GUILDADS_TS_ASKITEMS, count, skillName);
				tooltipTitle = skillName;
				tooltipText = GUILDADS_TS_ASKITEMS_TT;
				func = GuildAdsCraftFrame.onClickAskEverything;
				value = composants;
			};
			UIDropDownMenu_AddButton(info, 1);
			
			---- Demande un composant en particulier
			for k,info in menu do
				UIDropDownMenu_AddButton(info, 1);
			end
			
			PlaySound("igMainMenuOpen");
		end;
		
		-- by ElPico
		initializeCraftMenu = function(level)
			local id = GetCraftSelectionIndex();
			local craftName, craftSubSpellName, craftType, numAvailable, isExpanded = GetCraftInfo(id);
			local craftDesc = GetCraftDescription(id);
			local count = 1;
		
			------
			local composants = { };
			local menu = { };
	
			local numReagents = GetCraftNumReagents(id);
			for i=1, numReagents, 1 do
				local reagentName, reagentTexture, reagentCount, playerReagentCount = GetCraftReagentInfo(id, i);
				local link = GetCraftReagentItemLink(id, i);
				local itemColor, itemRef, itemName = GuildAds_ExplodeItemRef(link);
				
				local info = {
					value = { 
						ref = itemRef;
						count = reagentCount;
					};
					text = GUILDADS_BUTTON_ADDREQUEST.." "..reagentCount.." "..reagentName;
					notCheckable = 1;
					func = GuildAdsCraftFrame.onClickAskItem;
				};
				
				tinsert(composants, info.value);
				tinsert(menu, info);
			end
			
			
			local link = GetCraftItemLink(id);
			local itemColor, itemRef, itemName = GuildAds_ExplodeItemRef(link);
			info = {
				text = GUILDADS_BUTTON_ADDAVAILABLE.." "..craftName.." "..craftSubSpellName;
				notCheckable = 1;
				func = GuildAdsCraftFrame.onClickHave;
				value = { 
					ref = itemRef
				};
			};
			UIDropDownMenu_AddButton(info, 1);
			
			---- Demande tous les composants
			info = {
				notCheckable = 1;
				text = string.format(GUILDADS_TS_ASKITEMS, count, craftName);
				tooltipTitle = craftName;
				tooltipText = GUILDADS_TS_ASKITEMS_TT;
				func = GuildAdsCraftFrame.onClickAskEverything;
				value = composants;
			};
			UIDropDownMenu_AddButton(info, 1);
			
			---- Demande un composant en particulier
			for k,info in menu do
				UIDropDownMenu_AddButton(info, 1);
			end
			
			PlaySound("igMainMenuOpen");
		end;
		
	};
		
};