
local frames = Nurfed_Frames:New();
local utility = Nurfed_Utility:New();
if (not Nurfed_Units) then
	Nurfed_Units = {};

	Nurfed_Units.class = {
		DRUID = { right = 0.75, left = 1, top = 0, bottom = 0.25, color = "|cffffffff" },
		HUNTER = { right = 0, left = 0.25, top = 0.25, bottom = 0.5, color = "|cffffffff" },
		MAGE = { right = 0.25, left = 0.5, top = 0, bottom = 0.25, color = "|cffffffff" },
		PALADIN = { right = 0, left = 0.25, top = 0.5, bottom = 0.75, color = "|cffffffff" },
		PRIEST = { right = 0.5, left = 0.75, top = 0.25, bottom = 0.5, color = "|cffffffff" },
		ROGUE = { right = 0.5, left = 0.75, top = 0, bottom = 0.25, color = "|cffffffff" },
		SHAMAN = { right = 0.25, left = 0.5, top = 0.25, bottom = 0.5, color = "|cffffffff" },
		WARLOCK = { right = 0.75, left = 1, top = 0.25, bottom = 0.5, color = "|cffffffff" },
		WARRIOR = { right = 0, left = 0.25, top = 0, bottom = 0.25, color = "|cffffffff" },
	};

	Nurfed_Units.cure = {
		["Magic"] = {
			PRIEST = true,
			PALADIN = true,
			WARLOCK = true,
		},
		["Curse"] = {
			DRUID = true,
			MAGE = true,
		},
		["Disease"] = {
			PRIEST = true,
			PALADIN = true,
			SHAMAN = true,
		},
		["Poison"] = {
			DRUID = true,
			SHAMAN = true,
			PALADIN = true,
		},
	};

	Nurfed_Units.damage = {
		{ (255/255), (255/255), (0/255) },
		{ (255/255), (0/255), (0/255) },
		{ (0/255), (102/255), (0/255) },
		{ (0/255), (102/255), (255/255) },
		{ (202/255), (76/255), (217/255) },
		{ (153/255), (204/255), (255/255) },
	};

	Nurfed_Units.classification = {
		["rareelite"] = ITEM_QUALITY3_DESC.."-"..ELITE,
		["rare"] = ITEM_QUALITY3_DESC,
		["elite"] = ELITE,
	};

	local tbl = {
		type = "Frame",
		events = {
			"PLAYER_ENTERING_WORLD",
			"PARTY_MEMBERS_CHANGED",
			"RAID_ROSTER_UPDATE",
		},
		OnEvent = function() this:SetScript("OnUpdate", Nurfed_Units_OnUpdate) this.update = GetTime() + 0.25 end,
	};

	frames:ObjectInit("Nurfed_UnitsFrame", tbl);
	tbl = nil;
end

function Nurfed_Units_OnUpdate()
	if (this.update and this.update <= GetTime()) then
		Nurfed_Units:UpdateUnits();
		this:SetScript("OnUpdate", nil);
		this.update = nil;
	end
end

function Nurfed_Units:New()
	local o = {};
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function Nurfed_Units:UpdateUnits()
	local i;
	self.unitlist = {};
	if (GetNumPartyMembers() > 0) then
		for i = 1, GetNumPartyMembers() do
			self.unitlist[UnitName("party"..i)] = { t = "Party", c = UnitClass("party"..i), u = "party"..i };
		end
	end
	if (GetNumRaidMembers() > 0) then
		for i = 1, GetNumRaidMembers() do
			local name, rank, subgroup, _, class, _, _, _, _ = GetRaidRosterInfo(i);
			if (name and rank and subgroup and class) then
				if (self.unitlist[name]) then
					self.unitlist[name].g = subgroup;
					self.unitlist[name].r = rank;
					self.unitlist[name].id = i;
				else
					self.unitlist[name] = { t = "Raid", c = class, g = subgroup, r = rank, u = "raid"..i, id = i };
				end
			end
		end
	end
end

function Nurfed_Units:GetUnit(name)
	if (self.unitlist and self.unitlist[name]) then
		return self.unitlist[name];
	end
	return nil;
end

function Nurfed_Units:Imbue(frame, noevent)
	frame.hp = {};
	frame.mp = {};
	frame.xp = {};
	frame.combo = {};
	frame.target = {};
	frame.feedback = {};

	local id, found = gsub(frame.unit, "party([1-4])", "%1");
	if (found == 1 and string.len(frame.unit) == 6) then
		frame:SetID(tonumber(id));
		frame:RegisterEvent("PARTY_MEMBERS_CHANGED");
		frame:RegisterEvent("RAID_ROSTER_UPDATE");
	end

	local name = frame:GetName();
	local function update(cframe)
		local objtype = cframe:GetObjectType();
		local childname = string.gsub(cframe:GetName(), name, "");
		if (string.find(childname, "^hp")) then
			table.insert(frame.hp, cframe);
		elseif (string.find(childname, "^mp")) then
			table.insert(frame.mp, cframe);
		elseif (string.find(childname, "^xp")) then
			table.insert(frame.xp, cframe);
		elseif (string.find(childname, "^combo")) then
			table.insert(frame.combo, cframe);
		elseif (string.find(childname, "^target") and objtype == "Button") then
			table.insert(frame.target, cframe);
			cframe.unit = frame.unit..childname;
			self:Imbue(cframe, true);
			frame.update = 0;
			frame:SetScript("OnUpdate", function() self:OnUpdateToT(arg1) end);
			cframe.update = 0;
			cframe:SetScript("OnUpdate", function() self:OnUpdateTarget(arg1) end);
			cframe:SetScript("OnClick", function() Nurfed_Unit_OnClick(arg1) end);
		elseif (objtype == "PlayerModel") then
			cframe:RegisterEvent("PLAYER_ENTERING_WORLD");
			cframe:RegisterEvent("DISPLAY_SIZE_CHANGED");
			cframe:RegisterEvent("UNIT_MODEL_CHANGED");
			if (frame.unit == "target") then
				cframe:RegisterEvent("PLAYER_TARGET_CHANGED");
			elseif (frame.unit == "pet") then
				cframe:RegisterEvent("UNIT_PET");
			elseif (found == 1) then
				cframe:RegisterEvent("PARTY_MEMBERS_CHANGED");
			end
			cframe:SetScript("OnEvent", function() if (event == "DISPLAY_SIZE_CHANGED") then this:RefreshUnit() elseif (this:GetParent().unit) then this:SetUnit(this:GetParent().unit) end end);
			if (not cframe.full) then
				cframe:SetScript("OnUpdate", function() this:SetCamera(0) end);
			end
		elseif (not noevent) then
			if (string.find(childname, "^name") or string.find(childname, "^class") or string.find(childname, "^race")) then
				frame:RegisterEvent("UNIT_NAME_UPDATE");
				if (frame.unit == "player") then
					frame:RegisterEvent("PLAYER_LEVEL_UP");
				else
					frame:RegisterEvent("UNIT_LEVEL");
				end
			elseif (string.find(childname, "^pvp")) then
				frame:RegisterEvent("UNIT_FACTION");
			elseif (string.find(childname, "^leader")) then
				frame:RegisterEvent("PARTY_LEADER_CHANGED");
			elseif (string.find(childname, "^master")) then
				frame:RegisterEvent("PARTY_LOOT_METHOD_CHANGED");
			elseif (string.find(childname, "^group")) then
				frame:RegisterEvent("RAID_ROSTER_UPDATE");
				frame:RegisterEvent("PARTY_MEMBERS_CHANGED");
			elseif (string.find(childname, "^status")) then
				frame:RegisterEvent("PLAYER_ENTER_COMBAT");
				frame:RegisterEvent("PLAYER_LEAVE_COMBAT");
				frame:RegisterEvent("PLAYER_REGEN_DISABLED");
				frame:RegisterEvent("PLAYER_REGEN_ENABLED");
				frame:RegisterEvent("PLAYER_UPDATE_RESTING");
			elseif ((string.find(childname, "^buff") or string.find(childname, "^debuff")) and objtype == "Button") then
				local border = getglobal(cframe:GetName().."Border");
				if (string.find(childname, "^debuff")) then
					local id, found = gsub(childname, "debuff([0-9]+)", "%1");
					border:ClearAllPoints();
					border:SetAllPoints(cframe);
					cframe:SetID(id);
					cframe.isdebuff = true;
				else
					local id, found = gsub(childname, "buff([0-9]+)", "%1");
					cframe:SetID(id);
					border:Hide();
				end
				frame:RegisterEvent("UNIT_AURA");
				if (frame:GetObjectType() == "Button") then
					cframe:SetScript("OnEnter", Nurfed_SetAuraTooltip);
				else
					cframe:SetScript("OnEnter", nil);
					cframe:SetScript("OnLeave", nil);
				end
			elseif (string.find(childname, "^level")) then
				if (frame.unit == "player") then
					frame:RegisterEvent("PLAYER_LEVEL_UP");
				else
					frame:RegisterEvent("UNIT_LEVEL");
				end
			elseif (string.find(childname, "^raidtarget")) then
				frame:RegisterEvent("RAID_TARGET_UPDATE");
			elseif (string.find(childname, "^pet") and objtype == "Button") then
				frame.pet = child;
				frame:RegisterEvent("UNIT_PET");
				cframe.unit = "partypet"..id;
				self:Imbue(cframe);
			elseif (string.find(childname, "^highlight")) then
				frame:RegisterEvent("PLAYER_TARGET_CHANGED");
			elseif (string.find(childname, "^feedback")) then
				frame:RegisterEvent("UNIT_COMBAT");
				table.insert(frame.feedback, cframe);
			elseif (string.find(childname, "^portrait")) then
				frame:RegisterEvent("UNIT_PORTRAIT_UPDATE");
				frame.portrait = cframe;
			end
		end
	end

	local children = { frame:GetChildren() };
	for _, child in ipairs(children) do
		update(child);
		local childregions = { child:GetRegions() };
		for _, region in ipairs(childregions) do
			if (region:GetName()) then
				update(region);
			end
		end
	end

	local regions = { frame:GetRegions() };
	for _, region in ipairs(regions) do
		if (region:GetName()) then
			update(region);
		end
	end

	if (not noevent) then
		frame:RegisterEvent("PLAYER_ENTERING_WORLD");
		if (frame.hp[1]) then
			frame:RegisterEvent("UNIT_HEALTH");
			frame:RegisterEvent("UNIT_MAXHEALTH");
		end
		if (frame.mp[1]) then
			frame:RegisterEvent("UNIT_MANA");
			frame:RegisterEvent("UNIT_MAXMANA");
			frame:RegisterEvent("UNIT_ENERGY");
			frame:RegisterEvent("UNIT_MAXENERGY");
			frame:RegisterEvent("UNIT_RAGE");
			frame:RegisterEvent("UNIT_MAXRAGE");
			frame:RegisterEvent("UNIT_FOCUS");
			frame:RegisterEvent("UNIT_MAXFOCUS");
			frame:RegisterEvent("UNIT_DISPLAYPOWER");
			self:UpdateManaColor(frame);
		end
		if (frame.xp[1]) then
			if (frame.unit == "player") then
				frame:RegisterEvent("PLAYER_XP_UPDATE");
				frame:RegisterEvent("PLAYER_LEVEL_UP");
				frame:RegisterEvent("UPDATE_EXHAUSTION");
				frame:RegisterEvent("UPDATE_FACTION");
				self:UpdateInfo("xp", frame);
			elseif (frame.unit == "pet") then
				frame:RegisterEvent("UNIT_PET_EXPERIENCE");
				self:UpdateInfo("xp", frame);
			end
		end
		if (frame.combo[1]) then
			frame:RegisterEvent("PLAYER_COMBO_POINTS");
		end
		if (frame.unit == "target") then
			frame:RegisterEvent("PLAYER_TARGET_CHANGED");
			frame:RegisterEvent("UNIT_DYNAMIC_FLAGS");
			frame:RegisterEvent("UNIT_CLASSIFICATION_CHANGED");
			frame:SetScript("OnHide", TargetFrame_OnHide);
			frame:SetScript("OnShow", TargetFrame_OnShow);
		end
		if (frame.unit == "pet") then
			frame:RegisterEvent("UNIT_PET");
			frame:RegisterEvent("UNIT_HAPPINESS");
		end
		if (frame.unit == "player") then
			frame:RegisterEvent("PLAYER_GUILD_UPDATE");
		end
		if (frame:GetObjectType() == "Button") then
			frame:SetScript("OnEnter", UnitFrame_OnEnter);
			frame:SetScript("OnLeave", UnitFrame_OnLeave);
			if (not frame:GetScript("OnClick")) then
				frame:SetScript("OnClick", function() Nurfed_Unit_OnClick(arg1) end);
			end
			frame:RegisterForClicks("LeftButtonUp", "MiddleButtonUp", "RightButtonUp", "Button4Up", "Button5Up");
		end
		frame:SetScript("OnEvent", function() self:OnEvent() end);
	end
	
end

----------------------------------------------------------------
--		Event Functions
----------------------------------------------------------------

function Nurfed_Units:OnEvent()
	if (not this.unit) then
		return;
	end
	if (UnitExists(this.unit)) then
		local id, found = gsub(this.unit, "party([1-4])", "%1");
		if (found == 1) then
			local hide = utility:GetOption("unitframes", "hideparty");
			if (hide == 1 and UnitInRaid("player")) then
				this:Hide();
				return;
			end
		end

		if (not this:IsShown()) then
			this:Show();
			self:UpdateFrame();
		end
	else
		this:Hide();
		return;
	end

	if (event == "PLAYER_ENTERING_WORLD") then
		this.incombat = nil;
		self:UpdateFrame();
		if (Nurfed_Hud_UpdateAlpha) then
			Nurfed_Hud_UpdateAlpha();
		end
	elseif (event == "PLAYER_TARGET_CHANGED") then
		if (this.unit == "target") then
			self:UpdateFrame();
		else
			self:UpdateHighlight();
		end
	elseif (event == "PLAYER_ENTER_COMBAT" or event == "PLAYER_REGEN_DISABLED") then
		this.incombat = true;
		self:UpdateStatus();
		if (Nurfed_Hud_UpdateAlpha) then
			Nurfed_Hud_UpdateAlpha(true);
		end
	elseif (event == "PLAYER_LEAVE_COMBAT" or event == "PLAYER_REGEN_ENABLED") then
		this.incombat = nil;
		self:UpdateStatus();
		if (Nurfed_Hud_UpdateAlpha) then
			Nurfed_Hud_UpdateAlpha();
		end
	elseif (event == "PLAYER_UPDATE_RESTING") then
		self:UpdateStatus();
	elseif (event == "PLAYER_COMBO_POINTS") then
		self:UpdateCombos();
	elseif (event == "PLAYER_XP_UPDATE" or event == "PLAYER_LEVEL_UP" or event == "UPDATE_FACTION") then
		self:UpdateInfo("xp");
		self:UpdateLevel();
	elseif (event == "UPDATE_EXHAUSTION") then
		self:UpdateInfo("xp");
	elseif (event == "RAID_TARGET_UPDATE") then
		self:UpdateRaidTarget();
	elseif (event == "PARTY_MEMBERS_CHANGED") then
		local id, found = gsub(this.unit, "party([1-4])", "%1");
		if (found == 1) then
			self:UpdateFrame();
			self:UpdateHighlight();
		else
			self:UpdateGroup();
			self:UpdateLeader();
			self:UpdateMaster();
		end
	elseif (event == "PARTY_LEADER_CHANGED") then
		self:UpdateLeader();
		self:UpdateMaster();
	elseif (event == "PARTY_LOOT_METHOD_CHANGED") then
		self:UpdateMaster();
	elseif (event == "RAID_ROSTER_UPDATE") then
		self:UpdateGroup();
	elseif (event == "PLAYER_GUILD_UPDATE") then
		self:UpdateFrame();
	elseif (arg1 == this.unit) then
		if (event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH") then
			self:UpdateInfo("hp");
		elseif (event == "UNIT_MANA" or event == "UNIT_ENERGY" or event == "UNIT_RAGE" or event == "UNIT_FOCUS" or event == "UNIT_MAXMANA" or event == "UNIT_MAXENERGY" or event == "UNIT_MAXRAGE" or event == "UNIT_MAXFOCUS") then
			self:UpdateInfo("mp");
		elseif (event == "UNIT_COMBAT") then
			self:UpdateDamageFeed(arg2, arg3, arg4, arg5);
		elseif (event == "UNIT_AURA") then
			self:UpdateAuras();
		elseif (event == "UNIT_DISPLAYPOWER") then
			self:UpdateManaColor();
		elseif (event == "UNIT_PORTRAIT_UPDATE") then
			SetPortraitTexture(this.portrait, this.unit);
		elseif (event == "UNIT_FACTION") then
			self:UpdatePvP();
		elseif (event == "UNIT_LEVEL") then
			self:UpdateInfo("xp");
			self:UpdateLevel();
			self:UpdateName();
		elseif (event == "UNIT_NAME_UPDATE") then
			self:UpdateName();
		elseif (event == "UNIT_DYNAMIC_FLAGS") then
			self:UpdateName();
		elseif (event == "UNIT_CLASSIFICATION_CHANGED") then
			self:UpdateLevel();
		elseif (event == "UNIT_HAPPINESS") then
			self:UpdateHappiness();
		elseif (event == "UNIT_PET" and arg1 ~= "pet") then
			self:UpdatePet();
		end
	end
end

function Nurfed_Units:UpdateFrame()
	self:UpdateName();
	self:UpdateInfo("hp");
	self:UpdateManaColor();
	self:UpdateCombos();
	self:UpdateStatus();
	self:UpdateRaidTarget();
	self:UpdateLevel();
	self:UpdateGroup();
	self:UpdateLeader();
	self:UpdateMaster();
	self:UpdatePvP();
	self:UpdatePet();
	self:UpdateAuras();
	self:UpdateRank();
	self:UpdateGuild();
	self:UpdateHighlight();
	if (this.unit == "pet") then
		self:UpdateHappiness();
	end
	if (this.unit == "player" or this.unit == "pet") then
		self:UpdateInfo("xp");
	end
end

function Nurfed_Units:UpdateDamageFeed(event, flags, amount, type)
	local text = "";
	local r, g, b = 1, 0.647, 0;

	if (event == "HEAL") then
		text = "+"..amount;
		r, g, b = 0, 1, 0;
	elseif ( event == "WOUND" ) then
		if ( amount ~= 0 ) then
			if ( type == 0 ) then
				r, g, b = 1, 0, 0;
			else
				local color = self.damage[type];
				r, g, b = color[1], color[2], color[3];
			end
			text = "-"..amount;
		elseif ( flags == "ABSORB" ) then
			text = CombatFeedbackText["ABSORB"];
		elseif ( flags == "BLOCK" ) then
			text = CombatFeedbackText["BLOCK"];
		elseif ( flags == "RESIST" ) then
			text = CombatFeedbackText["RESIST"];
		else
			text = CombatFeedbackText["MISS"];
		end
	elseif ( event == "IMMUNE" ) then
		text = CombatFeedbackText[event];
	elseif ( event == "BLOCK" ) then
		text = CombatFeedbackText[event];
	elseif ( event == "ENERGIZE" ) then
		text = amount;
		r, g, b = 0.41, 0.8, 0.94;
	else
		text = CombatFeedbackText[event];
	end

	for _, child in ipairs(this.feedback) do
		if (child.heal and event == "HEAL") then
			child:AddMessage(text, r, g, b, 1, 1);
		end
		if (child.damage and event ~= "HEAL") then
			child:AddMessage(text, r, g, b, 1, 1);
		end
		if (not child.damage and not child.heal) then
			child:AddMessage(text, r, g, b, 1, 1);
		end
	end
end

function Nurfed_Units:TextureCoord(texture, size, fill, value)
	if (fill == "top") then
		texture:SetHeight(size);
		texture:SetTexCoord(0, 1, value, 1);
	elseif (fill == "bottom") then
		texture:SetHeight(size);
		texture:SetTexCoord(0, 1, 1, value);
	elseif (fill == "left") then
		texture:SetWidth(size);
		texture:SetTexCoord(value, 1, 0, 1);
	elseif (fill == "right") then
		texture:SetWidth(size);
		texture:SetTexCoord(1, value, 0, 1);
	elseif (fill == "vertical") then
		texture:SetHeight(size);
		texture:SetTexCoord(0, 1, 0 + (value / 2), 1 - (value / 2));
	elseif (fill == "horizontal") then
		texture:SetWidth(size);
		texture:SetTexCoord(0 + (value / 2), 1 - (value / 2), 0, 1);
	end
end

function Nurfed_Units:UpdateInfo(infotype, frame)
	if (frame) then
		this = frame;
	end
	if (not UnitExists(this.unit)) then
		return;
	end
	local curr, max, perc, color;
	if (infotype == "hp") then
		curr, max, perc, color = self:GetHealth(this.unit);
	elseif (infotype == "mp") then
		curr, max, perc = self:GetMana(this.unit);
	else
		curr, max, perc, color = self:GetXP(this.unit);
	end
	local missing = curr - max;
	local maxtext, missingtext = max, missing;

	for _, child in ipairs(this[infotype]) do
		local objtype = child:GetObjectType();
		if (objtype == "StatusBar") then
			if (max == 0 or this["no"..infotype]) then
				child:Hide();
			else
				if (not string.find(this.unit, "^raid")) then
					child:Show();
				end
				if (this["max"..infotype] ~= max) then
					child:SetMinMaxValues(0, max);
				end
				if (color) then
					child:SetStatusBarColor(color.r, color.g, color.b);
				end
				if (child.ani) then
					if (child.ani == "glide") then
						child.endvalue = curr;
						child.fade = 0.4;
						if (not child:GetScript("OnUpdate")) then
							child.startvalue = 0;
							child:SetScript("OnUpdate", function() self:StatusBarUpdate(arg1) end);
						end
					end
				else
					child:SetValue(curr);
				end
				child:Show();
			end
		elseif (objtype == "FontString") then
			if (infotype == "hp") then
				if (max >= 1000000) then
					maxtext = format("%.2fm", max/1000000);
				elseif (max >= 100000) then
					maxtext = format("%.1fk", max/1000);
				end
				if (missing <= -1000000) then
					missingtext = format("%.2fm", missing/1000000);
				elseif (missing <= -100000) then
					missingtext = format("%.1fk", missing/1000);
				end
			end
			local text = child.format;
			if (infotype == "hp") then
				if (UnitIsDead(this.unit) and not UnitIsGhost(this.unit)) then
					text = DEAD;
				elseif (UnitIsGhost(this.unit)) then
					text = "Ghost";
				elseif (not UnitIsConnected(this.unit)) then
					text = PLAYER_OFFLINE;
				end
			end
			text = string.gsub(text, "$cur", curr);
			text = string.gsub(text, "$max", maxtext);
			text = string.gsub(text, "$perc", perc.."%%");
			text = string.gsub(text, "$miss", missingtext);

			if (infotype == "xp") then
				local name = GetWatchedFactionInfo();
				if (GetXPExhaustion() ~= nil and not name) then
					text = string.gsub(text, "$rest", " ("..GetXPExhaustion()..")");
				elseif (name) then
					text = string.gsub(text, "$rest", " ("..name..")");
				else
					text = string.gsub(text, "$rest", "");
				end
			end
			child:SetText(text);
			if (child:GetParent() == this and color) then
				child:SetTextColor(color.r, color.g, color.b);
			end
		elseif (objtype == "Texture" and child.fill) then
			if (max == 0 or curr == 0) then
				child:Hide();
			else
				local p = curr / max;
				local size = child.bar * p;
				local p_h1, p_h2;

				if (child.fill == "top" or child.fill == "bottom" or child.fill == "vertical") then
					p_h1 = child.bar / child.height;
				else
					p_h1 = child.bar / child.width;
				end

				p_h2 = 1 - p_h1;
				self:TextureCoord(child, size, child.fill, (1-p) * p_h1 + p_h2);
				if (color) then
					child:SetVertexColor(color.r, color.g, color.b);
				end
				child:Show();
			end
		end
	end
end

function Nurfed_Units:UpdateManaColor(frame)
	if (frame) then
		this = frame;
	end
	local color = ManaBarColor[UnitPowerType(this.unit)];
	for _, child in ipairs(this.mp) do
		local objtype = child:GetObjectType();
		if (objtype == "StatusBar") then
			child:SetStatusBarColor(color.r, color.g, color.b);
		elseif (objtype == "Texture") then
			child:SetVertexColor(color.r, color.g, color.b);
		elseif (objtype == "FontString" and child:GetParent() == this) then
			child:SetTextColor(color.r, color.g, color.b);
		end
	end
	self:UpdateInfo("mp");
end

function Nurfed_Units:UpdateCombos()
	local comboPoints = GetComboPoints();
	for _, child in ipairs(this.combo) do
		if (comboPoints > 0) then
			local objtype = child:GetObjectType();
			if (objtype == "FontString") then
				child:SetText(comboPoints);
				if (comboPoints < 5) then
					child:SetTextColor(1, 1, 0);
				else
					child:SetTextColor(1, 0, 0);
				end
				child:Show();
			elseif (objtype == "StatusBar") then
				child:SetValue(comboPoints);
				child:Show();
			else
				if (comboPoints >= child.id) then
					child:Show();
				else
					child:Hide();
				end
			end
		else
			child:Hide();
		end
	end
end

function Nurfed_Units:UpdateStatus()
	local icon = getglobal(this:GetName().."status");
	if (icon) then
		local objtype = icon:GetObjectType();
		if (this.incombat) then
			if (objtype == "Texture") then
				icon:SetTexCoord(0.5, 1.0, 0, 0.5);
			else
				icon:SetText("Combat");
				icon:SetTextColor(1, 1, 1);
			end
			icon:Show();
--Remove		elseif (IsResting()) then
--Resting			if (objtype == "Texture") then
--From				icon:SetTexCoord(0, 0.5, 0, 0.5);
--Showing			else
--				icon:SetText(TUTORIAL_TITLE30);
--				icon:SetTextColor(1, 1, 0);
--			end
			icon:Show();
		else
			icon:Hide();
		end
	end
end

function Nurfed_Units:UpdateRaidTarget()
	local icon = getglobal(this:GetName().."raidtarget");
	if (icon) then
		local index = GetRaidTargetIndex(this.unit);
		if (index) then
			SetRaidTargetIconTexture(icon, index);
			icon:Show();
		else
			icon:Hide();
		end
	end
end

function Nurfed_Units:UpdateText(frame)
	local objtype = frame:GetObjectType();
	if (objtype ~= "FontString") then
		local text = getglobal(frame:GetName().."text");
		if (text) then
			frame = text;
		end
	end
	if (frame and frame.format) then
		local display, color = self:FormatText(this.unit, frame.format);
		frame:SetText(display);
		if (color) then
			frame:SetTextColor(color.r, color.g, color.b);
		end
	end
end

function Nurfed_Units:UpdateLevel(level)
	local frame = getglobal(this:GetName().."level");
	if (frame) then
		self:UpdateText(frame);
	end
end

function Nurfed_Units:UpdateGroup()
	local text = getglobal(this:GetName().."group");
	if (text) then
		local info = self:GetUnit(UnitName(this.unit));
		if (info) then
			text:SetText(GROUP..": |cffffff00"..info.g.."|r");
		else
			text:SetText(nil);
		end
	end
end

function Nurfed_Units:UpdateLeader()
	local icon = getglobal(this:GetName().."leader");
	if (icon) then
		local id, found = gsub(this.unit, "party([1-4])", "%1");
		if (this.unit == "player") then
			if (IsPartyLeader()) then
				icon:Show();
			else
				icon:Hide();
			end
		elseif (found == 1) then
			if (GetPartyLeaderIndex() == tonumber(id)) then
				icon:Show();
			else
				icon:Hide();
			end
		end
	end
end

function Nurfed_Units:UpdateMaster()
	local icon = getglobal(this:GetName().."master");
	if (icon) then
		local id, found = gsub(this.unit, "party([1-4])", "%1");
		local lootMethod, lootMaster = GetLootMethod();
		if (this.unit == "player") then
			if (lootMaster == 0 and ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0))) then
				icon:Show();
			else
				icon:Hide();
			end
		elseif (found == 1) then
			if (lootMaster == tonumber(id)) then
				icon:Show();
			else
				icon:Hide();
			end
		end
	end
end

function Nurfed_Units:UpdatePvP()
	local icon = getglobal(this:GetName().."pvp");
	if (icon) then
		local objtype = icon:GetObjectType();
		local factionGroup, factionName = UnitFactionGroup(this.unit);
		if (UnitIsPVPFreeForAll(this.unit)) then
			if (objtype == "Texture") then
				icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
			else
				icon:SetText(PVP_ENABLED);
			end
			if (this.unit == "player" and not this.pvp) then
				this.pvp = true;
				PlaySound("igPVPUpdate");
			end
			icon:Show();
		elseif (factionGroup and UnitIsPVP(this.unit)) then
			if (objtype == "Texture") then
				icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup);
			else
				icon:SetText(PVP_ENABLED);
			end
			if (this.unit == "player" and not this.pvp) then
				this.pvp = true;
				PlaySound("igPVPUpdate");
			end
			icon:Show();
		else
			if (this.unit == "player" and this.pvp) then
				this.pvp = nil;
			end
			icon:Hide();
		end
	end
end

function Nurfed_Units:UpdateName()
	local ntext = getglobal(this:GetName().."name");
	local ctext = getglobal(this:GetName().."class");
	local rtext = getglobal(this:GetName().."race");
	local icon = getglobal(this:GetName().."classicon");
	if (ntext) then
		self:UpdateText(ntext);
	end
	if (ctext) then
		self:UpdateText(ctext);
	end
	if (rtext) then
		self:UpdateText(rtext);
	end
	if (icon) then
		local class, eclass = UnitClass(this.unit);
		local info = Nurfed_Units.class[eclass];
		if (info) then
			icon:SetTexCoord(info.right, info.left, info.top, info.bottom);
		end
	end
end

function Nurfed_Units:UpdateGuild()
	local frame = getglobal(this:GetName().."guild");
	if (frame) then
		self:UpdateText(frame);
	end
end

function Nurfed_Units:UpdateHappiness()
	local happiness, damagePercentage, loyaltyRate = GetPetHappiness();
	local hasPetUI, isHunterPet = HasPetUI();
	local text = getglobal(this:GetName().."name");
	local icon = getglobal(this:GetName().."happiness");
	if (text and icon and (happiness or isHunterPet)) then
		if (text:GetObjectType() ~= "FontString") then
			text = getglobal(text:GetName().."text");
		end
		local display = self:FormatText(this.unit, text.format);
		icon:Show();
		if (happiness == 1) then
			text:SetTextColor(1, 0.5, 0);
			icon:SetTexCoord(0.375, 0.5625, 0, 0.359375);
		elseif (happiness == 2) then
			text:SetTextColor(1, 1, 0);
			icon:SetTexCoord(0.1875, 0.375, 0, 0.359375);
		elseif (happiness == 3) then
			text:SetTextColor(0, 1, 0);
			icon:SetTexCoord(0, 0.1875, 0, 0.359375);
		end
		if (loyaltyRate < 0) then
			text:SetText("-"..display.."-");
		elseif ( loyaltyRate > 0 ) then
			text:SetText("+"..display.."+");
		else
			text:SetText(display);
		end
	end
end

function Nurfed_Units:UpdatePet()
	if (this.pet) then
		local button = frame.pet;
		local id = this:GetID();
		if (UnitExists("partypet"..id)) then
			button:Show();
		else
			button:Hide();
		end
	end
end

function Nurfed_Units:UpdateAuras(frame)
	if (frame) then
		this = frame;
		if (not UnitExists(this.unit)) then
			return;
		end
	end
	local total = 0;
	local resize = {};
	local aura, app, count, debufftype, border, button, color, bsize, dsize, ignore, filter;
	local name = this:GetName();
	if (string.find(name, "Nurfed_Raid")) then
		filter = utility:GetOption("raids", "aurafilter");
	elseif (not string.find(name, "Nurfed_Hud")) then
		ignore = utility:GetOption("unitframes", "targetbuffs");
		filter = utility:GetOption("unitframes", "castable");
		if (this.unit == "target" and ignore == 1) then
			filter = 0;
		end
	end
	for i = 1, 16 do
		button = getglobal(this:GetName().."buff"..i);
		if (button) then
			aura, app = UnitBuff(this.unit, i, filter);
			if (aura) then
				getglobal(button:GetName().."Icon"):SetTexture(aura);
				count = getglobal(button:GetName().."Count");
				if (app > 1) then
					count:SetText(app);
					count:Show();
				else
					count:Hide();
				end
				button.filter = filter;
				button:Show();
				total = total + 1;
				table.insert(resize, { a = button, t = "buff" });
			else
				button:Hide();
			end
		else
			break;
		end
	end

	if (this.aurasize and this.aurawidth) then
		if (this.aurasize > (this.aurawidth / total)) then
			bsize = this.aurawidth / total;
		else
			bsize = this.aurasize;
		end
	end

	total = 0;
	if (not string.find(name, "Nurfed_Raid") and not string.find(name, "Nurfed_Hud")) then
		ignore = utility:GetOption("unitframes", "targetdebuffs");
		filter = utility:GetOption("unitframes", "dispellable");
		if (this.unit == "target" and ignore == 1) then
			filter = 0;
		end
	end
	this.cure = nil;
	for i = 1, 16 do
		button = getglobal(this:GetName().."debuff"..i);
		if (button) then
			aura, app, debufftype = UnitDebuff(this.unit, i, filter);
			if (aura) then
				getglobal(button:GetName().."Icon"):SetTexture(aura);
				count = getglobal(button:GetName().."Count");
				border = getglobal(button:GetName().."Border");
				if (app > 1) then
					count:SetText(app);
					count:Show();
				else
					count:Hide();
				end
				if (debufftype) then
					color = DebuffTypeColor[debufftype];
				else
					color = DebuffTypeColor["none"];
				end
				border:SetVertexColor(color.r, color.g, color.b);
				button.filter = filter;
				button:Show();
				total = total + 1;
				table.insert(resize, { a = button, t = "debuff" });

				if (UnitIsFriend("player", this.unit) and not string.find(this:GetName(), "^Nurfed_Hud")) then
					local _, eclass = UnitClass("player");
					if (debufftype and self.cure[debufftype] and self.cure[debufftype][eclass]) then
						if (not button:GetScript("OnUpdate")) then
							button.flashtime = GetTime();
							button.update = 0;
							button.flashdct = 1;
							button:SetScript("OnUpdate", function() self:Fade(arg1) end);
						end
						this.cure = self.cure[debufftype][eclass];
					else
						button:SetScript("OnUpdate", nil);
						button:SetAlpha(1);
					end
				else
					button:SetScript("OnUpdate", nil);
					button:SetAlpha(this:GetAlpha());
				end
			else
				button:Hide();
			end
		else
			break;
		end
	end

	if (this.aurasize and this.aurawidth) then
		if (this.aurasize > (this.aurawidth / total)) then
			dsize = this.aurawidth / total;
		else
			dsize = this.aurasize;
		end

		for _, v in ipairs(resize) do
			if (v.t == "buff") then
				v.a:SetWidth(bsize);
				v.a:SetHeight(bsize);
			else
				v.a:SetWidth(dsize);
				v.a:SetHeight(dsize);
			end
		end
	end
end

function Nurfed_Units:UpdateHighlight()
	local highlight = getglobal(this:GetName().."highlight");
	if (highlight) then
		if (UnitExists("target") and UnitName("target") == UnitName(this.unit)) then
			highlight:Show();
		else
			highlight:Hide();
		end
	end
end

function Nurfed_Units:UpdateRank()
	local rankname, ranknumber = GetPVPRankInfo(UnitPVPRank(this.unit));
	local icon = getglobal(this:GetName().."rank");
	if (icon) then
		if (ranknumber and ranknumber > 0) then
			local objtype = icon:GetObjectType();
			if (objtype == "Texture") then
				if (ranknumber>9) then
					icon:SetTexture("Interface\\PVPRankBadges\\PVPRank"..ranknumber);
				else
					icon:SetTexture("Interface\\PVPRankBadges\\PVPRank0"..ranknumber);
				end
			else
				icon:SetText(ranknumber);
			end
			icon:Show();
		else
			icon:Hide();
		end
	end
end

function Nurfed_Units:OnUpdateToT(elapsed)
	this.update = this.update + elapsed;
	if (this.update > 0.25) then
		for _, frame in ipairs(this.target) do
			if (UnitExists(frame.unit)) then
				frame:Show();
			end
		end
		this.update = 0;
	end
end

function Nurfed_Units:OnUpdateTarget(elapsed)
	this.update = this.update + elapsed;
	if (this.update > 0.25) then
		if (UnitExists(this.unit)) then
			self:UpdateName();
			self:UpdateInfo("hp");
			self:UpdateInfo("mp");
			self:UpdateAuras();
		else
			this:Hide();
		end
		this.update = 0;
	end
end

function Nurfed_Units:GetHealth(unit)
	local currhp, maxhp = UnitHealth(unit), UnitHealthMax(unit);
	if (MobHealth3 and unit == "target") then
		currhp, maxhp = MobHealth3:GetUnitHealth("target", currhp, maxhp);
	end
	if (not UnitIsConnected(unit)) then
		currhp = 0;
	end
	local perc = currhp/maxhp;
	local color = {};
	if (Nurfed_HealthPercColor) then
		color = Nurfed_HealthPercColor(perc);
	else
		if(perc > 0.5) then
			color.r = (1.0 - perc) * 2;
			color.g = 1.0;
		else
			color.r = 1.0;
			color.g = perc * 2;
		end
		color.b = 0.0;
	end
	perc = format("%.0f", floor(perc * 100));
	return currhp, maxhp, perc, color;
end

function Nurfed_Units:GetMana(unit)
	local currmp, maxmp = UnitMana(unit), UnitManaMax(unit);
	if (not UnitIsConnected(unit)) then
		currmp = 0;
	end
	local perc = format("%.0f", (currmp / maxmp) * 100);
	return currmp, maxmp, perc;
end

function Nurfed_Units:GetXP(unit)
	if (not UnitExists(unit)) then
		return 0, 0, 0;
	end
	local name, reaction, min, max, value = GetWatchedFactionInfo();
	local currxp, maxxp, perc;
	local color = { r = 0.58, g = 0.0, b = 0.55 };
	if (name) then
		currxp = value - min;
		maxxp = max - min;
		color = FACTION_BAR_COLORS[reaction];
	else
		local exhaustionStateID = GetRestState();
		if (exhaustionStateID == 1) then
			color = { r = 0.0, g = 0.39, b = 0.88 };
		end
		currxp = UnitXP(unit);
		maxxp = UnitXPMax(unit);
	end
	local perc = format("%.0f", (currxp / maxxp) * 100);
	return currxp, maxxp, perc, color;
end

function Nurfed_Units:StatusBarUpdate(arg1)
	if (this.fade < 1) then
		this.fade = this.fade + arg1;
		if this.fade > 1 then
			this.fade = 1;
		end
		local delta = this.endvalue - this.startvalue;
		local diff = delta * (this.fade / 1);
		this.startvalue = this.startvalue + diff;
		this:SetValue(this.startvalue);
	end
end

function Nurfed_Units:Fade(arg1)
	this.update = this.update + arg1;
	if (this.update > 0.04) then
		this.update = 0;
		local now = GetTime();
		local frame, texture, p;
		if (now - this.flashtime > 0.3) then
			this.flashdct = this.flashdct * (-1);
			this.flashtime = now;
		end

		if (this.flashdct == 1) then
			p = (1 - (now - this.flashtime + 0.001) / 0.3 * 0.7);
		else
			p = ( (now - this.flashtime + 0.001) / 0.3 * 0.7 + 0.3);
		end
		this:SetAlpha(p);
	end
end

function Nurfed_Units:FormatText(unit, text)
	if (not unit or not text) then
		return;
	end
	local gcolor;

	if (string.find(text, "$name", 1, true)) then
		local name = UnitName(unit);
		if (UnitIsPlayer(unit)) then
			local class, eclass = UnitClass(unit);
			if (self.class[eclass]) then
				local color = self.class[eclass].color;
				name = color..name.."|r";
			end

			if (string.find(text, "$key", 1, true)) then
				local id, found = gsub(unit, "party([1-4])", "%1");
				if (found == 1) then
					local binding = GetBindingText(GetBindingKey("TARGETPARTYMEMBER"..id), "KEY_");
					binding = utility:FormatBinding(binding);
					text = string.gsub(text, "$key", binding);
				end
			end
		elseif (string.find(unit, "target", 1, true)) then
			local reaction = UnitReaction(unit, "player");
			local color = UnitReactionColor[reaction];
			if (UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
				color = { r = 0.5, g = 0.5, b = 0.5 };
			end
			if (not color) then
				color = { r = 1, g = 1, b = 1 };
			end
			color = string.format("|cff%02x%02x%02x", (color.r*255), (color.g*255), (color.b*255));
			name = color..name.."|r";
		end
		text = string.gsub(text, "$name", name);
	end

	if (string.find(text, "$level", 1, true)) then
		local level = UnitLevel(unit);
		local classification = UnitClassification(unit);
		gcolor = GetDifficultyColor(level);
		if (UnitIsPlusMob(unit)) then
			level = level.."+";
		elseif (level == 0) then
			level = "";
		elseif (level < 0) then
			level = "??";
			gcolor = { r = 1, g = 0, b = 0 };
		end
		if (classification == "worldboss") then
			level = BOSS;
			gcolor = { r = 1, g = 0, b = 0 };
		end
		text = string.gsub(text, "$level", level);
	end

	if (string.find(text, "$class", 1, true)) then
		local class, eclass = UnitClass(unit);
		if (UnitIsPlayer(unit)) then
			if (self.class[eclass]) then
				local color = self.class[eclass].color;
				class = color..class.."|r";
			end
		else
			local classification = UnitClassification(unit);
			if (UnitCreatureType(unit) == "Humanoid" and UnitIsFriend("player", unit)) then
				class = "NPC";
			elseif (UnitCreatureType(unit) == "Beast" and UnitCreatureFamily(unit)) then
				class = UnitCreatureFamily(unit);
			else
				class = UnitCreatureType(unit);
			end
			if (self.classification[classification]) then
				class = self.classification[classification].." "..class;
			end
		end
		if (not class) then
			class = "";
		end
		text = string.gsub(text, "$class", class);
	end

	if (string.find(text, "$guild", 1, true)) then
		local guild = GetGuildInfo(unit);
		if (guild) then
			local pguild = GetGuildInfo("player");
			local color = { r = 0, g = 0.75, b = 1 };
			if (guild == pguild) then
				color = { r = 1, g = 0, b = 1 };
			end
			color = string.format("|cff%02x%02x%02x", (color.r*255), (color.g*255), (color.b*255));
			guild = color..guild.."|r";
		else
			guild = "";
		end
		text = string.gsub(text, "$guild", guild);
	end

	if (string.find(text, "$rname", 1, true) or string.find(text, "$rnum", 1, true)) then
		local rankname, ranknumber = GetPVPRankInfo(UnitPVPRank(unit));
		if (not rankname) then
			rankname = "";
			ranknumber = "";
		end
		text = string.gsub(text, "$rname", rankname);
		text = string.gsub(text, "$rnum", ranknumber);
	end

	if (string.find(text, "$race", 1, true)) then
		race = UnitRace(unit);
		if (not race) then
			race = "";
		end
		text = string.gsub(text, "$race", race);
	end

	return text, gcolor;
	
end

function Nurfed_RaidFrameDropDown_Initialize()
	UnitPopup_ShowMenu(getglobal(UIDROPDOWNMENU_OPEN_MENU), "RAID", this.unit, this.name, this.id);
end

function Nurfed_Unit_OnClick(arg1)
	local name, dropdown;
	if (SpellIsTargeting() and arg1 == "RightButton") then
		SpellStopTargeting();
		return;
	end
	if (arg1 == "LeftButton") then
		if (SpellIsTargeting() and  SpellCanTargetUnit(this.unit)) then
			SpellTargetUnit(this.unit);
		elseif (CursorHasItem()) then
			if (this.unit == "player") then
				AutoEquipCursorItem();
			else
				DropItemOnUnit(this.unit);
			end
		else
			TargetUnit(this.unit);
		end
	elseif (arg1 == "RightButton") then
		if (string.find(this.unit, "party[1-4]")) then
			name = "PartyMemberFrame"..this:GetID();
			dropdown = getglobal(name.."DropDown");
		elseif (string.find(this.unit, "^raid")) then
			FriendsDropDown.initialize = Nurfed_RaidFrameDropDown_Initialize;
			FriendsDropDown.displayMode = "MENU";
			dropdown = FriendsDropDown;
		else
			name = string.gsub(this.unit, "^%l", string.upper);
			dropdown = getglobal(name.."FrameDropDown");
		end
		if (dropdown) then
			ToggleDropDownMenu(1, nil, dropdown, "cursor");
		end
		return;
	end
end

function Nurfed_SetAuraTooltip()
	if (not this:IsVisible()) then return; end
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT");
	local unit = this:GetParent().unit;
	if (this.isdebuff) then
		GameTooltip:SetUnitDebuff(unit, this:GetID(), this.filter);
	else
		GameTooltip:SetUnitBuff(unit, this:GetID(), this.filter);
	end
end