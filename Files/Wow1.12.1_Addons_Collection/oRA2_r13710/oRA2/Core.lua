------------------------------
--      Are you local?      --
------------------------------
local L = AceLibrary("AceLocale-2.0"):new("oRA")

local CTRAversion = "1.541"


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["You are now AFK"] = true,
	["You are now DND"] = true,
	["You have to be Raid Leader or Assistant to do that."] = true,
	["Requested a status update."] = true,
	["useshorthands"] = true,
	["Use shorthands"] = true,
	["Toggle using of CTRA shorthands"] = true,
	[" ...hic!"] = true,
	["status"] = true,
	["Request status"] = true,
	["Request a status update"] = true,
-- texture handling in the core yeah baby
	["Textures"] = true,
	["default"] = true,
	["otravi"] = true,
	["perl"] = true,
	["smooth"] = true,
	["striped"] = true,
	["bantobar"] = true,
	["smudge"] = true,
	["charcoal"] = true,
	["Set all statusbar textures."] = true,	
} end)

L:RegisterTranslations("deDE", function() return {
	["You are now AFK"] = "Ihr seid jetzt AFK",
	["You are now DND"] = "Ihr seid jetzt DND",
	["You have to be Raid Leader or Assistant to do that."] = "Ihr m\195\188sst Raid Leiter oder Assistent sein, um das zu machen.",
	["Requested a status update."] = "Status-Aktualisierung wurde angefordert.",
	["Use shorthands"] = "K\195\188rzel verwenden",
	["Toggle using of CTRA shorthands"] = "Verwendung von CTRA K\195\188rzel umschalten",
	[" ...hic!"] = " ...hic!",
	["Request status"] = "Status anfordern",
	["Request a status update"] = "Eine Status-Aktualisierung anfordern",
} end)

L:RegisterTranslations("koKR", function() return {
	["You are now AFK"] = "자리 비움으로 설정되었습니다",
	["You are now DND"] = "|1으로;로; 설정되었습니다",
	["You have to be Raid Leader or Assistant to do that."] = "공격대장이거나 승급된 사람만 사용 가능합니다.",
	["Requested a status update."] = "상태 갱신을 요청합니다.",
	["useshorthands"] = "단축명령어사용",
	["Use shorthands"] = "단축 명령어 사용",
	["Toggle using of CTRA shorthands"] = "공격대 도우미 단축 명령어 사용 토글",
	[" ...hic!"] = " ...딸꾹!",
	["status"] = "상태",
	["Request status"] = "상태 갱신 요청",
	["Request a status update"] = "상태 갱신을 요청",
-- texture handling in the core yeah baby
	["Textures"] = "텍스쳐",
	["default"] = "기본",
	["otravi"] = "otravi",
	["perl"] = "perl",
	["smooth"] = "smooth",
	["striped"] = "striped",
	["bantobar"] = "bantobar",
	["smudge"] = "smudge",
	["charcoal"] = "charcoal",
	["Set all statusbar textures."] = "모든 상태바 텍스쳐를 설정합니다.",	
	
} end)

L:RegisterTranslations("zhCN", function() return {
	["You are now AFK"] = "你正在AFK状态",
	["You are now DND"] = "你正在DND状态",
	["You have to be Raid Leader or Assistant to do that."] = "只有团队领袖/队长才可以",
	["Requested a status update."] = "请求更新状态",
	["useshorthands"] = "使用缩略",
	["Use shorthands"] = "使用缩略",
	["Toggle using of CTRA shorthands"] = "使用CTRA缩略",
	["Toggle using of CTRA shorthands"] = "使用CTRA缩略",
	[" ...hic!"] = "...嗝!",
	["status"] = "状态",
	["Request status"] = "获取状态",
	["Request a status update"] = "获取状态更新",
	
} end)

---------------------------------
--      Addon Declaration      --
---------------------------------

oRA = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDebug-2.0", "AceModuleCore-2.0", "AceConsole-2.0", "AceDB-2.0")
oRA:SetModuleMixins("AceDebug-2.0", "AceEvent-2.0")
oRA.defaults = {
	bartexture = L["default"],
	useshorthands = true,
}
oRA.version = tonumber(string.sub("$Revision: 13699 $", 12, -3))
oRA.CTRAversion = CTRAversion
oRA.consoleOptions = {
		type	= "group",
		args	= {
			[L["useshorthands"]] = {
				name = L["Use shorthands"], type = "toggle",
				desc = L["Toggle using of CTRA shorthands"],
				get = function() return oRA.db.profile.useshorthands end,
				set = function(v)
					oRA.db.profile.useshorthands = v
					oRA:UpdateShorthands()
				end,
				order = 1000,
			},
			[L["status"]] = {
				name = L["Request status"], type = "execute",
				desc = L["Request a status update"],
				func = function()
					oRA:RequestStatus()
				end,
				order = 1000,
			},
			[L["Textures"]] = {
				type = "text",
				name = L["Textures"],
				desc = L["Set all statusbar textures."],
				get = function() return oRA.db.profile.bartexture end,
				set = function(v) oRA:SetBarTexture(v)	end,
				validate = { L["smudge"], L["bantobar"], L["charcoal"], L["smooth"], L["otravi"], L["perl"], L["striped"], L["default"] }
			}
		}
	}

oRA:RegisterDB("oRADB", "oRADBPerChar")
oRA:RegisterDefaults("profile", oRA.defaults)
oRA:RegisterChatCommand({"/ora", "/oRA"}, oRA.consoleOptions )


------------------------------
--      Initialization      --
------------------------------

function oRA:OnInitialize()

	self.checks = {}
	self.shorthands = {}

	self.roster = AceLibrary("RosterLib-2.0")

	self.debugFrame = ChatFrame5

	local name, module
	for name,module in self:IterateModules() do 
		self:RegisterModule(name, module)

		if module.db then module:RegisterDefaults("profile", module.defaults or {})
		else self:RegisterDefaults(name, "profile", module.defaults or {}) end

		if not module.db then module.db = self:AcquireDBNamespace(name) end
	end
	setglobal("BINDING_HEADER_oRA2", "oRA2")


	self.bartextures = {
		["default"]     = "Interface\\TargetingFrame\\UI-StatusBar",
		["otravi"]      = "Interface\\AddOns\\oRA2\\Textures\\otravi",
		["perl"]        = "Interface\\AddOns\\oRA2\\Textures\\perl",
		["smooth"]      = "Interface\\AddOns\\oRA2\\Textures\\smooth",
		["striped"]     = "Interface\\AddOns\\oRA2\\Textures\\striped",
		["bantobar"]	= "Interface\\AddOns\\oRA2\\Textures\\bantobar",
		["smudge"]	= "Interface\\AddOns\\oRA2\\Textures\\smudge",
		["charcoal"] 	= "Interface\\AddOns\\oRA2\\Textures\\charcoal",
	}


end

function oRA:OnEnable()
	self.roster:Enable()
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("CHAT_MSG_SYSTEM")

	self:RegisterEvent("oRA_SendVersion", "DistributeVersion")
	self:RegisterEvent("oRA_JoinedRaid", "DistributeVersion")
	self:RegisterEvent("oRA_UpdateVersion")
	self:RegisterEvent("oRA_UpdateAfkDnd")
	self:RegisterEvent("oRA_UpdateCTRAVersion")
	self:RegisterEvent("oRA_UpdateVersion")

	self:RegisterCheck("SR", "oRA_SendVersion")
	self:RegisterCheck("AFK", "oRA_UpdateAfkDnd")
	self:RegisterCheck("DND", "oRA_UpdateAfkDnd")
	self:RegisterCheck("UNAFK", "oRA_UpdateAfkDnd")
	self:RegisterCheck("UNDND", "oRA_UpdateAfkDnd")
	self:RegisterCheck("V", "oRA_UpdateCTRAVersion")
	self:RegisterCheck("oRAV", "oRA_UpdateVersion")

	self:RegisterEvent("AceEvent_FullyInitialized")
end

function oRA:OnDisable()
	self:UnregisterAllEvents()
end

--------------------------------
--      Module Prototype      --
--------------------------------

oRA.modulePrototype.core = oRA

function oRA.modulePrototype:RegisterCheck( c, e )
	self.core:RegisterCheck(c, e)
	self:RegisterEvent(e)
end

function oRA.modulePrototype:UnregisterCheck( c )
	self.core:UnregisterCheck(c)
end

function oRA.modulePrototype:IsValidRequest( a, i)
	return self.core:IsValidRequest(a, i)
end

function oRA.modulePrototype:SendMessage( msg, ora)
	self.core:SendMessage(msg, ora)
end

function oRA.modulePrototype:CleanMessage( msg ) 
	return self.core:CleanMessage( msg )
end

function oRA.modulePrototype:IsPromoted( a )
	return self.core:IsPromoted( a )
end

function oRA.modulePrototype:RegisterShorthand( s, f, i)
	self.core:RegisterShorthand(s, f, i)
end

function oRA.modulePrototype:UnregisterShorthand( s )
	self.core:UnregisterShorthand(s)
end

function oRA.modulePrototype:Print( msg )
	self.core:Print("(%s) %s", self.name, msg )
end

-------------------------------
--      Module Handling      --
-------------------------------

function oRA:RegisterModule(name, module)
	if module.consoleOptions then
		local m = module.consoleCmd or name
		-- if the consoleoption already exists we merge in the data otherwise we create a new option
		if self.consoleOptions.args[m] then
			for k,v in pairs(module.consoleOptions.args) do self.consoleOptions.args[m].args[k] = v end
		else
			self.consoleOptions.args[m] = module.consoleOptions
		end
	end
end

-------------------------------
--      Core 		     --
-------------------------------

-- Distrubutes your version to the raid

function oRA:DistributeVersion()
	self:SendMessage( "V " .. self.CTRAversion)
	self:SendMessage( "oRAV "..self.version, true )
end


-- Command handler
-- Updates the shorthands for the current setting

function oRA:UpdateShorthands()
	if self.db.profile.useshorthands then
		local s,f
		for s,f in pairs(self.shorthands) do
			self:RegisterShorthand(s, f, true)
		end
	else
		local s,f
		for s, f in pairs(self.shorthands) do
			local type = "ORA_SHORTHAND_"..strupper(s)
			SlashCmdList[type] = nil
			setglobal("SLASH_"..type.."1", nil)
		end
	end
end

-- Command handler
-- Sends a status request.

function oRA:RequestStatus()
	self:Print(L["Requested a status update."])
	self:SendMessage("SR")
end

function oRA:SetBarTexture( texture )
	if L:HasReverseTranslation(texture) then
		texture = L:GetReverseTranslation(texture)
	else
		texture = "default"
	end
	self.db.profile.bartexture = texture

	self:TriggerEvent("oRA_BarTexture", texture )
end

-------------------------------
-- 	Event Handlers       --
-------------------------------

function oRA:AceEvent_FullyInitialized()
	if GetNumRaidMembers() > 0 then
		self:TriggerEvent("oRA_JoinedRaid")
	else
		self:TriggerEvent("oRA_LeftRaid")
	end
end

-- Event handler for the CHAT_MSG_ADDON event
-- Parses the info sent over the addon channel
-- Checks for the keywrods and triggers the appropriate events

function oRA:CHAT_MSG_ADDON(prefix, msg, type, author)
	if prefix ~= "CTRA" and prefix ~= "oRA" then return end
	if type ~= "RAID" then return end
	local msgArr = self:SplitMessage(msg, "#")
	for _, c in pairs(msgArr) do
		cmd = self:SplitMessage(c, " ")
		if self.checks[cmd[1]] then
			self:TriggerEvent(self.checks[cmd[1]],c, author)
		end
	end	
end


-- Event handler for the CHAT_MSG_SYSTEM event
-- Will send your AFK/DND status to the raid

function oRA:CHAT_MSG_SYSTEM(msg)
	if string.find(msg, ERR_RAID_YOU_LEFT) then
		self:TriggerEvent("oRA_LeftRaid")
	elseif string.find(msg, ERR_RAID_YOU_JOINED) then
		self:TriggerEvent("oRA_JoinedRaid")
	elseif string.find(msg, L["You are now AFK"]) then
		self:SendMessage("AFK")
	elseif string.find(msg, L["You are now DND"]) then
		self:SendMessage("DND")
	elseif string.find(msg, CLEARED_AFK ) then
		self:SendMessage("UNAFK")
	elseif string.find(msg, CLEARED_DND ) then
		self:SendMessage("UNDND")
	end
end

-------------------------------
--   Checks Event Handlers   --
-------------------------------

-- Event handler for the AFK/DND/UNAFK/UNDND messages
-- Will update the roster for the player who sent the message

function oRA:oRA_UpdateAfkDnd(msg, author)

	if not self:IsValidRequest( author, true) then return end
	local u = self.roster:GetUnitObjectFromName(author)
	if not u then return end

	msg = self:CleanMessage(msg)

	if string.find( msg, "^AFK(.*)") then u.ora_afk = true
	elseif string.find( msg, "^DND(.*)") then u.ora_dnd = true
	elseif string.find( msg, "^UNAFK(.*)") then u.ora_afk = nil
	elseif string.find( msg, "^UNDND(.*)") then u.ora_dnd = nil
	end
	self:TriggerEvent("oRA_AfkDndUpdated", author)
end

-- Event handler for the "V " message
-- Will update the roster for the player who sent the V with his version

function oRA:oRA_UpdateCTRAVersion(msg, author)
	if not self:IsValidRequest( author, true ) then return end
	local u = self.roster:GetUnitObjectFromName(author)
	if not u then return end
	
	msg = self:CleanMessage(msg)

	local _,_,version = string.find(msg, "V (.+)")

	if version then	u.ora_ctraversion = version end
end

-- Event handler for the "oRAV " message
-- Will update the roster for the player who sent the oRAV with his version

function oRA:oRA_UpdateVersion(msg, author)
	if not self:IsValidRequest( author, true ) then return end
	local u = self.roster:GetUnitObjectFromName(author)
	if not u then return end

	msg = self:CleanMessage(msg)

	local _,_,version = string.find(msg, "oRAV (.+)")

	if version then	u.ora_version = version end	
end

-------------------------------
--     Raid Roster Utils     --
-------------------------------

-- Checks if the player is raid leader or raid officer
-- Args: showmsg - when set to true will print out an error when the check fails
-- Returns true when the player is raid leader or raid officer

function oRA:IsPromoted( showmsg )
	if IsRaidLeader() or IsRaidOfficer() then return true end
	if showmsg then self:Print(L["You have to be Raid Leader or Assistant to do that."]) end
	return false	
end

-- Checks if a player is in the raid and optionally if he/she has the correct rank
-- Args: name - name of the player
--       ignorerank - flag, when set to true will ignore the rank of the player
-- Returns true when a player is authorized for a request

function oRA:IsValidRequest( name, ignorerank )
    if (not name) then name = UnitName("player") end
	local u = self.roster:GetUnitObjectFromName( name )
	if u then
		if ignorerank then return true end
		if u.rank > 0 then return true end
	end
	return false
end

---------------------------
--    Channel checks     --
---------------------------

-- Registers a keyword check
-- Args: check - keyword to check on
--       event - event to fire when the keyword is received

function oRA:RegisterCheck(check,event)
	self.checks[check] = event
end

-- Unregisters a keyword check
-- Args: check - keyword to remove from the checklist

function oRA:UnregisterCheck(check)
	if self.checks[check] then self.checks[check] = nil end
end

---------------------------
--       Messaging       --
---------------------------

-- Sends a message
-- Args: msg - message to send
-- returns true when succesful

function oRA:SendMessage( msg, ora )
	if ora then
		SendAddonMessage("oRA", msg, "RAID")
	else 
		SendAddonMessage("CTRA", msg, "RAID")
	end
	return true
end


-- Cleans a message replacing escaped characters by their true ones.
-- also removes the drunken ... hic!
-- Args: msg - msg to clean
-- Returns the cleaned up message

function oRA:CleanMessage( msg )
	msg = string.gsub(msg, "%$", "s")
	msg = string.gsub(msg, "", "S")
	
	if ( strsub(msg, strlen(msg)-7) == L[" ...hic!"]) then
		msg = strsub(msg, 1, strlen(msg)-8)
	end
	return msg
end

-- Splits a string on a given character
-- Args: msg - string to split
--       char - character to split on
-- Returns an array with all the pieces this array will contain the total string if
-- the split character was not found.

function oRA:SplitMessage( msg, char )
	local arr = { }
	while (string.find(msg, char) ) do
		local iStart, iEnd = string.find(msg, char)
		table.insert(arr, strsub(msg, 1, iStart-1))
		msg = strsub(msg, iEnd+1, strlen(msg))
	end
	if ( strlen(msg) > 0 ) then
		table.insert(arr, msg)
	end
	return arr
end

---------------------------------
--      Short Hand System      --
---------------------------------

-- Registers a CTRA shorthand
-- Args: shorthand - shorthand you wish to register: rajoin => /rajoin
-- 	 func	   - function to execute
--	 system	   - when set to true will only enable the shorthand not register it again.
--		     this flag is only used by the core itself.

function oRA:RegisterShorthand(shorthand, func, system)
	if shorthand and shorthand ~= "" then
		if self.db.profile.useshorthands then
			local type = "ORA_SHORTHAND_"..strupper(shorthand)
			SlashCmdList[type] = func
			setglobal("SLASH_"..type.."1", "/"..strlower(shorthand))
		end
		if not system then
			self.shorthands[shorthand] = func
		end
	end
end


-- Unregisters a CTRA shorthand
-- Args: shorthand - the shorthand you wish to unregister
-- Returns true when succesful

function oRA:UnRegisterShorthand( shorthand )
	if shorthand and shorthand ~= "" then
		local s, f
		for s, f in pairs(self.shorthands) do
			if s == shorthand then
				local type = "ORA_SHORTHAND_"..strupper(s)
				SlashCmdList[type] = nil
				setglobal("SLASH_"..type.."1", nil)
				self.shorthands[s] = nil
				return true
			end
		end
	end
end


