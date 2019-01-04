--[[
--
--	Satellite
--		A tool for slash command enchancement.
--
--	By Karl Isenberg (AnduinLothar)
--
--
--	$Id: Satellite.lua 3705 2006-06-26 08:15:29Z karlkfi $
--	$Rev: 3705 $
--	$LastChangedBy: karlkfi $
--	$Date: 2006-06-26 03:15:29 -0500 (Mon, 26 Jun 2006) $
--
--	Note: If you embed this addon you need to add the following lines to your toc
--	## SavedVariablesPerCharacter: Satellite_Config
--	Satellite\Satellite.xml
--
--]]

local SATELLITE_NAME 			= "Satellite"
local SATELLITE_VERSION 		= 1.71
local SATELLITE_LAST_UPDATED	= "September 11, 2006"
local SATELLITE_AUTHOR 			= "AnduinLothar"
local SATELLITE_EMAIL			= "karlkfi@cosmosui.org"
local SATELLITE_WEBSITE			= "http://www.wowwiki.com/Satellite"

------------------------------------------------------------------------------
--[[ Embedded Sub-Library Load Algorithm ]]--
------------------------------------------------------------------------------

if (not Satellite) then
	Satellite = {};
end
local isBetterInstanceLoaded = ( Satellite.version and Satellite.version >= SATELLITE_VERSION );

if (not isBetterInstanceLoaded) then
	
	Satellite.version = SATELLITE_VERSION;
	
	------------------------------------------------------------------------------
	--[[ Globals ]]--
	------------------------------------------------------------------------------
	
	if (not Satellite_Config) then
		Satellite_Config = {};
	end
	
	if (not Satellite_Config.chatTypes) then
		Satellite_Config.chatTypes = {};
	end

	-- A list of the slash commands
	if (not Satellite.slashCommands) then
		Satellite.slashCommands = {};
	end
	
	------------------------------------------------------------------------------
	--[[ User Functions: Slash Commands ]]--
	------------------------------------------------------------------------------
		
	--[[
	--	registerSlashCommand ( {slashCommand} [, {slashCommand}] ...)
	--
	--		See the slashCommand definition for more information.
	--
	--	(Should be at the end of this file)
	--
	--	Example:
	--		Satellite.registerSlashCommand(
	--			{
	--				id = "SNOOPY";
	--				commands = {"/snoop", "/snoopy"};
	--				onExecute = function( msg ) Sea.io.print("You're snoopy, ", msg , "!" ); end;
	--				sticky = false;
	--				helpText = "Shows the world you're nuts!"
	--			}
	--		);
	--
	--		/snoop Belldandy
	--
	--		Would print "You're snoopy, Belldandy!"
	--
	--      Sticky:
	--          true - The command will be saved so that when you bring up the
	--                 edit box the next time the command will already be loaded
	--          false or nil - The command will not be saved.
	--
	--	returns:
	--		true - success!
	--		false - a command failed!
	--
	--]]
	Satellite.registerSlashCommand = function (...)
		local noproblems = true;
	
		-- Quality checks first
		for i=1, table.getn(arg) do
			local v = arg[i];
			v = Satellite.validateSlashCommand(v);
			if ( v ) then
				if (Satellite.isSlashCommandByID(v.id) and v.replace) then
					Satellite.updateSlashCommand(v);
				else
					v.stored = {};
					if (v.header or v.printHeader or v.sticky or v.defaultColor or v.defaultFrames) then
						
						v.stored.header = getglobal("CHAT_"..v.id.."_SEND")
						if ( type(v.header) == "table" ) then
							-- Convert header table to be indexed by commands
							for i, cmd in v.commands do
								v.header[cmd] = v.header[i];
								v.header[i] = nil
							end
							setglobal("CHAT_"..v.id.."_SEND", v.header[v.commands[1]] or v.commands[1].." ");
						else
							setglobal("CHAT_"..v.id.."_SEND", v.header or v.commands[1].." ");
						end
						
						v.stored.printHeader = getglobal("CHAT_"..v.id.."_GET")
						setglobal("CHAT_"..v.id.."_GET", v.printHeader or (v.menuText and "["..v.menuText.."]: ") or "");
						
						v.stored.menuText = getglobal("CHAT_MSG_"..v.id)
						setglobal("CHAT_MSG_"..v.id, v.menuText or v.id);
						
						v.stored.ChatTypeGroup = ChatTypeGroup[v.id]
						ChatTypeGroup[v.id] = { "CHAT_MSG_"..v.id }; -- Fake event list
						
						v.stored.ChatTypeInfo = ChatTypeInfo[v.id];
						ChatTypeInfo[v.id] = {};
						local chatType = Satellite_Config.chatTypes[v.id]
						if (not chatType) then
							chatType = {};
							if (v.defaultFrames) then
								for i, frameID in v.defaultFrames do
									chatType[frameID] = true;
								end
							else
								chatType[DEFAULT_CHAT_FRAME:GetID()] = true;
							end
							if (v.defaultColor) then
								chatType.r = v.defaultColor.r;
								chatType.g = v.defaultColor.g;
								chatType.b = v.defaultColor.b;
							else
								chatType.r = 1.0;
								chatType.g = 1.0;
								chatType.b = 1.0;
							end
							Satellite_Config.chatTypes[v.id] = chatType;
						end
						local chatFrame;
						for i=1, NUM_CHAT_WINDOWS do
							if (chatType[i]) then
								chatFrame = getglobal("ChatFrame"..i);
								if (not Satellite.IsChatTypeVisible(v.id, chatFrame)) then
									ChatFrame_AddMessageGroup(chatFrame, v.id);
								end
							end
						end
						ChatTypeInfo[v.id].r = chatType.r;
						ChatTypeInfo[v.id].g = chatType.g;
						ChatTypeInfo[v.id].b = chatType.b;
						
						ChatTypeInfo[v.id].sticky = v.sticky and 1 or 0;
						
						if (not v.hideMenuOption) then
							local found;
							local i=1;
							while (OtherMenuChatTypeGroups[i]) do
								if (OtherMenuChatTypeGroups[i] == v.id) then
									found = true;
									break;
								end
								i=i+1;
							end
							if (not found) then
								OtherMenuChatTypeGroups[i] = v.id;
							end
						end
						
					end
					
					v.stored.SlashCmdList = SlashCmdList[v.id];
					SlashCmdList[v.id] = v.onExecute;
					v.stored.commands = {};
					
					local slash = "SLASH_"..v.id;
					local numCmds = getn(v.commands);
					local i = 1;
					while (i <= numCmds) do
						v.stored.commands[i] = getglobal(slash..i);
						setglobal(slash..i, v.commands[i]);
						i = i + 1;
					end
					local cmd = getglobal(slash..i);
					while (cmd) do
						v.stored.commands[i] = cmd;
						setglobal(slash..i, nil);
						i = i + 1;
						cmd = getglobal(slash..i);
					end
					
					
					Satellite.slashCommands[v.id] = v;
				end
			else
				noproblems = false;
			end
		end
	
		return noproblems;
	end
	
	--[[
	--	unregisterSlashCommand(id)
	--		Removes the slash commands associated with that id
	--
	--	args:
	--		id - string id
	--
	--]]
	Satellite.unregisterSlashCommand = function (id)
		id = strupper(id);
		local cmdInfo = Satellite.slashCommands[id]
		if (cmdInfo) then
			if (cmdInfo.stored) then
				local chatFrame;
				for i=1, NUM_CHAT_WINDOWS do
					chatFrame = getglobal("ChatFrame"..i);
					if (Satellite.IsChatTypeVisible(id, chatFrame)) then
						ChatFrame_RemoveMessageGroup(chatFrame, id);
					end
				end
				
				setglobal("CHAT_"..id.."_SEND", cmdInfo.stored.header);
				setglobal("CHAT_"..id.."_GET", cmdInfo.stored.printHeader);
				setglobal("CHAT_MSG_"..id, cmdInfo.stored.menuText);
				ChatTypeGroup[id] = cmdInfo.stored.ChatTypeGroup
				ChatTypeInfo[id] = cmdInfo.stored.ChatTypeInfo;
				SlashCmdList[id] = cmdInfo.stored.SlashCmdList;
				
				local slash = "SLASH_"..id;
				local numCmds = getn(cmdInfo.stored.commands);
				local i = 1;
				while (i <= numCmds) do
					setglobal(slash..i, cmdInfo.stored.commands[i]);
					i = i + 1;
				end
				while getglobal(slash..i) do
					setglobal(slash..i, nil);
					i = i + 1;
				end
				
				-- Removed the chat type from the 'Other' menu and move lower ones up
				local removed;
				i=1;
				while (OtherMenuChatTypeGroups[i]) do
					if (removed) or (OtherMenuChatTypeGroups[i] == id) then
						OtherMenuChatTypeGroups[i] = OtherMenuChatTypeGroups[i+1]
						removed = true;
					end
					i=i+1;
				end
			end
			
			Satellite.slashCommands[id] = nil;
		end
	end
	
	--[[
	--	updateSlashCommand ( {slashCommandParts}, ... )
	--
	--		Updates a /command member if its valid.
	--
	--		e.g.
	--			updateSlashCommand({id="myID";onExecute = fooFunc; } );
	--
	--			will change the onExecute function for myID.
	--
	--	arg members:
	--		id - the ID matching the old slashCommand
	--		member - onExecute | onSpace | onTab | commands | action | helpText 
	--				 sticky | hideMenuOption | menuText | header | printHeader | defaultFrames | defaultColor | onColorChange | onVisibleChange
	--		newvalue - the new value.
	--
	--	returns:
	--		true - successfully replace.
	--		false - validation failed
	--]]
	
	Satellite.updateSlashCommand = function ( ... )
		local noproblems = true;
		local chatInfo;
		-- Quality checks first
		for i=1,table.getn(arg) do
			local v = arg[i];
			local valid = true;
	
			-- Ensure the ID is valid and already exists.
			if ( not v.id ) then
				return;
			end
			v.id = strupper(v.id);
			if ( not Satellite.slashCommands[v.id]) then
				return;
			end
	
			-- Check Members
			for k2,v2 in v do
				if ( not Satellite.validateSlashMember(k2,v2,v.id) ) then
					return;
				else
					Satellite.slashCommands[v.id][k2] = v2;
				end
			end
			
			-- Update Command
			chatInfo = Satellite.slashCommands[v.id];
			
			if (chatInfo.header or chatInfo.sticky or chatInfo.defaultColor or chatInfo.defaultFrames) then
				
				if ( type(v.header) == "table" ) then
					-- Convert header table to be indexed by commands
					for i, cmd in chatInfo.commands do
						chatInfo.header[cmd] = chatInfo.header[i];
						chatInfo.header[i] = nil;
					end
					setglobal("CHAT_"..chatInfo.id.."_SEND", chatInfo.header[chatInfo.commands[1]] or chatInfo.commands[1].." ");
				elseif (v.header ~= nil) then
					setglobal("CHAT_"..chatInfo.id.."_SEND", chatInfo.header or chatInfo.commands[1].." ");
				end
				
				if (v.printHeader ~= nil) then
					setglobal("CHAT_"..chatInfo.id.."_GET", chatInfo.printHeader or (chatInfo.menuText and "["..chatInfo.menuText.."]: ") or "");
				end
				
				if (v.menuText ~= nil) then
					setglobal("CHAT_MSG_"..chatInfo.id, chatInfo.menuText or chatInfo.id);
				end
				
				ChatTypeGroup[chatInfo.id] = { "CHAT_MSG_"..chatInfo.id }; -- Fake event list
				
				if ( type(ChatTypeInfo[chatInfo.id]) ~= "table" ) then
					ChatTypeInfo[chatInfo.id] = {};
				end
				
				local chatType = Satellite_Config.chatTypes[chatInfo.id];
				if (not chatType) then
					Satellite_Config.chatTypes[chatInfo.id] = {};
					chatType = Satellite_Config.chatTypes[chatInfo.id];
				end
				
				if (v.defaultFrames) then
					for i=1, NUM_CHAT_WINDOWS do
						chatType[i] = nil;
					end
					for i, frameID in chatInfo.defaultFrames do
						chatType[frameID] = true;
					end
					local chatFrame;
					for i=1, NUM_CHAT_WINDOWS do
						chatFrame = getglobal("ChatFrame"..i);
						if (chatType[i]) then
							if (not Satellite.IsChatTypeVisible(chatInfo.id, chatFrame)) then
								ChatFrame_AddMessageGroup(chatFrame, chatInfo.id);
							end
						else
							if (Satellite.IsChatTypeVisible(chatInfo.id, chatFrame)) then
								ChatFrame_RemoveMessageGroup(chatFrame, chatInfo.id);
							end
						end
					end
				end
				
				if (v.defaultColor) then
					ChangeChatColor(chatInfo.id, chatInfo.defaultColor.r, chatInfo.defaultColor.g, chatInfo.defaultColor.b);
				end
				
				if (v.sticky ~= nil) then
					ChatTypeInfo[chatInfo.id].sticky = chatInfo.sticky and 1 or 0;
				end
				
				if (v.hideMenuOption ~= nil) then
					if (v.hideMenuOption) then
						-- Make sure it IS in the menu
						local found;
						local i=1;
						while (OtherMenuChatTypeGroups[i]) do
							if (OtherMenuChatTypeGroups[i] == chatInfo.id) then
								found = true;
								break;
							end
							i=i+1;
						end
						if (not found) then
							OtherMenuChatTypeGroups[i] = chatInfo.id;
						end
					else
						-- Make sure it IS NOT in the menu
						local removed;
						local i=1;
						while (OtherMenuChatTypeGroups[i]) do
							if (removed) or (OtherMenuChatTypeGroups[i] == id) then
								OtherMenuChatTypeGroups[i] = OtherMenuChatTypeGroups[i+1]
								removed = true;
							end
							i=i+1;
						end
					end
				end
			end
			
			if (v.onExecute) then
				SlashCmdList[v.id] = chatInfo.onExecute;
			end
			
			if (v.commands) then
				local slash = "SLASH_"..v.id;
				local numCmds = getn(chatInfo.commands);
				local i = 1;
				while (i <= numCmds) do
					setglobal(slash..i, chatInfo.commands[i]);
					i = i + 1;
				end
				while getglobal(slash..i) do
					setglobal(slash..i, nil);
					i = i + 1;
				end
			end
			
		end
	
		return v;
	end
	
	--[[ Validates a Slash Command ]]--
	Satellite.validateSlashCommand = function (v)
		if ( v.id == nil ) then
			Sea.io.error("Nil id passed to registerSlashCommand from ", (this and this:GetName()));
			return;
		else
			v.id = strupper(v.id);
			-- Check IDs
			if (Satellite.slashCommands[v.id] and not v.replace) then
				Sea.io.error ("Duplicate slash command ID: \"", v.id, "\" Sent from: ", (this and this:GetName()));
				return;
			end
			v.replace = nil;
	
			-- Check Members
			for k2,v2 in v do
				if ( not Satellite.validateSlashMember(k2,v2,v.id) ) then
					return;
				end
			end
		end
	
		return v;
	end
	
	--[[ Validates members individually ]]--
	Satellite.validateSlashMember = function ( member, value, id )
		local currType = type(value);
		if ( member == "commands" ) then
			-- Required
			if ( currType ~= "table" ) then
				Sea.io.error("Invalid command list passed for id (", id,") from ", (this and this:GetName()) );
				return false;
			else
				-- Ensure commands follow the format /cmd
				for k2,command in value do
					if ( string.gsub(command, "(/%w+)", "%1") ~= command ) then
						Sea.io.error("Invalid command: \"", command, "\" in id: ", id);
						return false;
					end
					if ( command ) then
						local commandRegistered = Satellite.isSatelliteSlashCommand(command);
						if ( commandRegistered and commandRegistered.id ~= id ) then
							Sea.io.error("Already registered: ", command, " by id: ", commandRegistered.id );
						end
					end
				end
	
			end
		elseif ( member == "onExecute" ) then
			-- Required
			if ( currType ~= "function" ) then
				Sea.io.error("Invalid or missing onExecute value for id: ", id);
				return false;
			end
		elseif ( member == "onTab" ) then
			if ( currType == "nil" ) then
				-- Optional
			elseif ( currType ~= "function" ) then
				Sea.io.error("Invalid onTab value for id: ", id);
				return false;
			end
		elseif ( member == "onSpace" ) then
			if ( currType == "nil" ) then
				-- Optional
			elseif ( currType ~= "function" ) then
				Sea.io.error("Invalid onSpace value for id: ", id);
				return false;
			end
		elseif ( member == "helpText" ) then
			if ( currType == "nil" ) then
				-- Optional
			elseif ( currType ~= "string" ) then
				Sea.io.error("Invalid helpText value for id: ", id);
				return false;
			end
		elseif ( member == "sticky" ) then
			if ( currType == "nil" ) then
				-- Optional
			elseif ( currType ~= "boolean" ) then
				Sea.io.error("Invalid sticky value for id: ", id);
				return false;
			end
		elseif ( member == "menuText" ) then
			if ( currType == "nil" ) then
				-- Optional
			elseif ( currType ~= "string" ) then
				Sea.io.error("Invalid menuText value for id: ", id);
				return false;
			end
		elseif ( member == "header" ) then
			if ( currType == "nil" ) then
				-- Optional
			elseif ( currType ~= "string" and currType ~= "table" ) then
				Sea.io.error("Invalid header value for id: ", id);
				return false;
			end
		elseif ( member == "printHeader" ) then
			if ( currType == "nil" ) then
				-- Optional
			elseif ( currType ~= "string" ) then
				Sea.io.error("Invalid printHeader value for id: ", id);
				return false;
			end
		elseif ( member == "defaultFrames" ) then
			if ( currType == "nil" ) then
				-- Optional
			elseif ( currType ~= "table" ) then
				Sea.io.error("Invalid defaultFrames list passed for id (", id,") from ", (this and this:GetName()) );
				return false;
			else
				-- Ensure commands are a # 1-NUM_CHAT_WINDOWS
				for k2, frameID in value do
					if ( type (frameID) ~= "number" or frameID < 1 or frameID > NUM_CHAT_WINDOWS) then
						Sea.io.error("Invalid command: \"", command, "\" in id: ", id);
						return false;
					end
				end
			end
		elseif ( member == "defaultColor" ) then
			if ( currType == "nil" ) then
				-- Optional
			elseif ( currType ~= "table" ) then
				Sea.io.error("Invalid defaultColor list passed for id (", id,") from ", (this and this:GetName()) );
				return false;
			else
				-- Ensure color has r,g,b between 0-1
				for k2, color in value do
					if ( type (color) ~= "number" or (k2 ~= "r" and k2 ~= "g" and k2 ~= "b") or color < 0 or color > 1) then
						Sea.io.error("Invalid defaultColor: \"", color, "\" in id: ", id);
						return false;
					end
				end
				if ( not value.r or not value.g or not value.b ) then
					Sea.io.error("Invalid defaultColor: in id: ", id, " defaultColor must contain r, g & b.");
				end
			end
		elseif ( member == "onColorChange" ) then
			if ( currType == "nil" ) then
				-- Optional
			elseif ( currType ~= "function" ) then
				Sea.io.error("Invalid onColorChange value for id: ", id);
				return false;
			end
		elseif ( member == "onVisibleChange" ) then
			if ( currType == "nil" ) then
				-- Optional
			elseif ( currType ~= "function" ) then
				Sea.io.error("Invalid onVisibleChange value for id: ", id);
				return false;
			end
		end
		return true;
	end
	
	--[[
	--	isSlashCommandByID(id)
	--		returns true if the id is already in use
	--		by a slash command
	--
	--	args:
	--		id - string id
	--
	--	returns:
	--		true - it exists
	--		false - not exists
	--]]
	Satellite.isSlashCommandByID = function (id)
		return (Satellite.slashCommands[id] ~= nil);
	end
	
	--[[
	--	isSatelliteSlashCommand(command)
	--		checks if a /command is a registered Satellite command.
	--
	--	args:
	--		command - string e.g. (/test)
	--
	--	returns:
	--		table - its a SatelliteSlashCommand, here's the info
	--		false - tis not in SatelliteSlashCommands
	--]]
	Satellite.isSatelliteSlashCommand = function(command)
		-- Check all of the registered Satellite Slash Commands
		for k,v in Satellite.slashCommands do
			for k2, cmd in v.commands do
				-- We find a match?
				if ( strlower(cmd) == strlower(command) ) then
					return v;
				end
			end
		end
	end


	------------------------------------------------------------------------------
	--[[ Utility Functions ]]--
	------------------------------------------------------------------------------
	
	Satellite.tempArgs = {};
	Satellite.NUM_MASKED_ARGS = 7;
	
	function Satellite.GenerateChatEvent(chatType, text)
		if ( not chatType ) then
			return;
		end
		chatType = strupper(chatType);
		if ( chatType and text and ChatTypeGroup[chatType] ) then
			arg1 = text;
			for i=2, Satellite.NUM_MASKED_ARGS do
				Satellite.tempArgs = arg1;
				setglobal("arg"..i, "");
			end
			local tempThis = this;
			local tempEvent = event;
			event = "CHAT_MSG_"..chatType;
			local messageTypeList;
			for i=1, NUM_CHAT_WINDOWS do
				this = getglobal("ChatFrame"..i);
				messageTypeList = this.messageTypeList;
				if ( messageTypeList ) then
					for joinedIndex, joinedValue in messageTypeList do
						if ( chatType == joinedValue ) then
							ChatFrame_OnEvent(event);
							break;
						end
					end
				end
			end
			this = tempThis;
			event = tempEvent;
			for i=1, Satellite.NUM_MASKED_ARGS do
				setglobal("arg"..i, Satellite.tempArgs);
			end
		end
	end
	
	
	--	readEditBox(editbox)
	-- Obtains a command, message pair from an EditBox's text
	function Satellite.readEditBox(editBox)
		if ( not editBox) then
			editBox = this;
		end
	
		local text = editBox:GetText();
		local chatType;
	
		-- If the string is in the format "/cmd blah", command will be "cmd"
		local _, _, command, msg = string.find(text, "(/[^%s]+)%s*(.*)");
		if (command) then
			typeInfo = Satellite.isSatelliteSlashCommand(command);
			if (typeInfo) then
				chatType = typeInfo.id
				typeInfo.lastCommandUsed = strlower(command);
			end
		elseif (Satellite.isSlashCommandByID(editBox.chatType)) then
			chatType = editBox.chatType;
		end
	
		if ( msg == text ) then
			msg = "";
		end
	
		return chatType, msg;
	end
	
	function Satellite.IsChatTypeVisible(chatTypeGroup, chatFrame)
		if (not chatFrame) then
			return;
		end
		local messageTypeList = chatFrame.messageTypeList
		if ( messageTypeList ) then
			for joinedIndex, joinedValue in messageTypeList do
				if ( chatTypeGroup == joinedValue ) then
					return true;
				end
			end
		end
		return false;
	end
	
	
	------------------------------------------------------------------------------
	--[[ ChatEdit Hook Functions ]]--
	------------------------------------------------------------------------------
	
	function Satellite.ChatEdit_UpdateHeader_hook(editBox)
		local chatType = editBox.chatType;
		if ( not chatType ) then
			return;
		end

		local typeInfo = Satellite.slashCommands[chatType];
		-- Update header if it is specified by command
		if ( typeInfo and type(typeInfo.header) == "table" ) then
			if ( typeInfo.header[typeInfo.lastCommandUsed] ) then
				setglobal("CHAT_"..typeInfo.id.."_SEND", typeInfo.header[typeInfo.lastCommandUsed]);
			else
				setglobal("CHAT_"..typeInfo.id.."_SEND", typeInfo.header[1] or typeInfo.commands[1].." ");
			end
		end
	end
	
	if (Sea.util.Hooks["ChatEdit_UpdateHeader"]) then
		Sea.util.unhook("ChatEdit_UpdateHeader", "Satellite.ChatEdit_UpdateHeader_hook", "before");
	end
	Sea.util.hook("ChatEdit_UpdateHeader", "Satellite.ChatEdit_UpdateHeader_hook", "before");
	
	
	function Satellite.ChatEdit_OnTabPressed_hook()
	
		local chatType, msg = Satellite.readEditBox(this);
	
		-- If there is not a Satellite chatType then behave normally
		if ( not chatType ) then
			return true;
		end
		
		local continue = true;
		local typeInfo = Satellite.slashCommands[chatType];
		
		if ( typeInfo and typeInfo.onTab ) then
			if ( not typeInfo.onTab(msg, typeInfo.lastCommandUsed) ) then
				continue = false;
			end
		end
		
		-- If we didn't return anything yet, return true (call orig);
		return continue;
	end
	
	if (Sea.util.Hooks["ChatEdit_OnTabPressed"]) then
		Sea.util.unhook("ChatEdit_OnTabPressed", "Satellite.ChatEdit_OnTabPressed_hook", "replace");
	end
	Sea.util.hook("ChatEdit_OnTabPressed", "Satellite.ChatEdit_OnTabPressed_hook", "replace");
	
	
	function Satellite.ChatEdit_OnSpacePressed_hook()
		
		local chatType, msg = Satellite.readEditBox(this);
	
		-- If there is not a Satellite chatType then behave normally
		if ( not chatType ) then
			return true;
		end
		
		local continue = true;
		local typeInfo = Satellite.slashCommands[chatType];
		
		if ( typeInfo and typeInfo.onSpace ) then
			if ( not typeInfo.onSpace(msg, typeInfo.lastCommandUsed) ) then
				continue = false;
			end
		end
	
		-- If we didn't return anything yet, return true (call orig);
		return continue;
	end
	
	if (Sea.util.Hooks["ChatEdit_OnSpacePressed"]) then
		Sea.util.unhook("ChatEdit_OnSpacePressed", "Satellite.ChatEdit_OnSpacePressed_hook", "replace");
	end
	Sea.util.hook("ChatEdit_OnSpacePressed", "Satellite.ChatEdit_OnSpacePressed_hook", "replace");
	
	--[[
	function Satellite.ChatEdit_OnEscapePressed_hook(editBox)
		local chatType, msg = Satellite.readEditBox(editBox);
	
		-- If there is not a Satellite chatType then behave normally
		if ( not chatType ) then
			return true;
		end
		
		local continue = true;
		local typeInfo = Satellite.slashCommands[chatType];
		if ( typeInfo and typeInfo.onEscape ) then
			if ( not typeInfo.onEscape(msg) ) then
				continue = false;
			end
		end
	
		-- If we didn't return anything yet, return true (call orig);
		return continue;
	end
	]]--
	if (Sea.util.Hooks["ChatEdit_OnEscapePressed"]) then
		Sea.util.unhook("ChatEdit_OnEscapePressed", "Satellite.ChatEdit_OnEscapePressed_hook", "replace");
	end
	--Sea.util.hook("ChatEdit_OnEscapePressed", "Satellite.ChatEdit_OnEscapePressed_hook", "replace");
	
	Satellite.AddChatWindowMessages_hook = function(frameID, chatType)
		if ( frameID and chatType and Satellite.isSlashCommandByID(chatType) and ChatTypeInfo[chatType] ) then
			Satellite_Config.chatTypes[chatType][frameID] = true;
			local cmdInfo = Satellite.slashCommands[chatType];
			if (cmdInfo.onVisibleChange) then
				cmdInfo.onVisibleChange(frameID, true);
			end
		else
			return true;
		end
	end
	
	if (Sea.util.Hooks["AddChatWindowMessages"]) then
		Sea.util.unhook("AddChatWindowMessages", "Satellite.AddChatWindowMessages_hook", "replace");
	end
	Sea.util.hook("AddChatWindowMessages", "Satellite.AddChatWindowMessages_hook", "replace");
	
	
	Satellite.RemoveChatWindowMessages_hook = function(frameID, chatType)
		if ( frameID and chatType and Satellite.isSlashCommandByID(chatType) and ChatTypeInfo[chatType] ) then
			Satellite_Config.chatTypes[chatType][frameID] = nil;
			local cmdInfo = Satellite.slashCommands[chatType];
			if (cmdInfo.onVisibleChange) then
				cmdInfo.onVisibleChange(frameID, false);
			end
		else
			return true;
		end
	end
	
	if (Sea.util.Hooks["RemoveChatWindowMessages"]) then
		Sea.util.unhook("RemoveChatWindowMessages", "Satellite.RemoveChatWindowMessages_hook", "replace");
	end
	Sea.util.hook("RemoveChatWindowMessages", "Satellite.RemoveChatWindowMessages_hook", "replace");
	
	
	Satellite.ChangeChatColor_hook = function(chatType, r, g, b)
		if ( chatType and Satellite.isSlashCommandByID(chatType) and ChatTypeInfo[chatType] ) then
			local cmdInfo = Satellite.slashCommands[chatType];
			if (cmdInfo.onColorChange) then
				cmdInfo.onColorChange(r, g, b);
			end
			ChatTypeInfo[chatType].r = r;
			ChatTypeInfo[chatType].g = g;
			ChatTypeInfo[chatType].b = b;
			Satellite_Config.chatTypes[chatType].r = r;
			Satellite_Config.chatTypes[chatType].g = g;
			Satellite_Config.chatTypes[chatType].b = b;
		else
			return true;
		end
	end
	
	if (Sea.util.Hooks["ChangeChatColor"]) then
		Sea.util.unhook("ChangeChatColor", "Satellite.ChangeChatColor_hook", "replace");
	end
	Sea.util.hook("ChangeChatColor", "Satellite.ChangeChatColor_hook", "replace");
	
	
	-- catch SendChatMessage from (anywhere) ChatEdit_SendText and execute slash commands that are also chat types (not previously caught by the builtin system)
	Satellite.SendChatMessage_hook = function(text, chatType)
		if ( chatType and Satellite.isSlashCommandByID(chatType) ) then
			local cmdInfo = Satellite.slashCommands[chatType];
			cmdInfo.onExecute(text, cmdInfo.lastCommandUsed);
		else
			return true;
		end
	end
	
	if (Sea.util.Hooks["SendChatMessage"]) then
		Sea.util.unhook("SendChatMessage", "Satellite.SendChatMessage_hook", "replace");
	end
	Sea.util.hook("SendChatMessage", "Satellite.SendChatMessage_hook", "replace");
	
	
	-- /chathelp hook to add satellite cmd descriptions
	Satellite.ChatFrame_DisplayChatHelp_hook = function(frame)
		if ( not frame ) then
			return;
		end
		local info = ChatTypeInfo["SYSTEM"];
		for id,sComm in Satellite.slashCommands do
			if ( sComm.helpText ) then
				frame:AddMessage(sComm.commands[1].." - "..sComm.helpText, info.r, info.g, info.b, info.id);
			end
		end
	end
	
	if (Sea.util.Hooks["ChatFrame_DisplayChatHelp"]) then
		Sea.util.unhook("ChatFrame_DisplayChatHelp", "Satellite.ChatFrame_DisplayChatHelp_hook", "after");
	end
	Sea.util.hook("ChatFrame_DisplayChatHelp", "Satellite.ChatFrame_DisplayChatHelp_hook", "after");
	
	
	------------------------------------------------------------------------------
	--[[ Built in Slash Commands (and examples) ]]--
	------------------------------------------------------------------------------
	
	-- Register an additional /script shortcut and add a header (and chatType)
	Satellite.registerSlashCommand(
		{
			id = "SCRIPT";
			commands = { "/z", SLASH_SCRIPT1, SLASH_SCRIPT2, SLASH_SCRIPT3, SLASH_SCRIPT4 };
			onExecute=SlashCmdList["SCRIPT"];
			header = SATELLITE_Z_HEADER;
			helpText = SATELLITE_Z_HELP;
			hideMenuOption = true;
			replace = true;
		}
	);
	
	-- Register the Print Command, useful for code testing
	-- Full chatType with sticky enabled and headers
	Satellite.registerSlashCommand(
		{
			id = "PRINT";
			commands = SATELLITE_PRINT_COMMANDS;
			onExecute = function(msg)
				RunScript('Satellite.GenerateChatEvent("PRINT", table.concat( {'..msg..'} ) )')
			end;
			header = SATELLITE_PRINT_HEADER;
			printHeader = SATELLITE_PRINT_HEADER2;
			menuText = SATELLITE_PRINT_TEXT;
			helpText = SATELLITE_PRINT_HELP;
			sticky = true;
			defaultColor = { r = 1.0, g = 1.0, b = 0.3 };
			defaultFrames = { DEFAULT_CHAT_FRAME:GetID() };
			replace = true;
		}
	);
	
	-- Register the Print Comma Command, useful for code testing
	-- Example of a semi-minimal non-chatType command (helpText is also optional)
	Satellite.registerSlashCommand(
		{
			id = "PRINT_COMMA";
			commands = SATELLITE_PRINT_COMMA_COMMANDS;
			onExecute = function(msg)
				RunScript('Satellite.GenerateChatEvent("PRINT", table.concat( {'..msg..'}, ", " ) )');
			end;
			helpText = SATELLITE_PRINT_COMMA_HELP;
			replace = true;
		}
	);
	
	
	------------------------------------------------------------------------------
	--[[ Frame Script Assignment ]]--
	------------------------------------------------------------------------------
	
	function Satellite.OnEvent()
		if (event == "VARIABLES_LOADED") or (event == "ADDON_LOADED" and arg1 == "Satellite") then
			-- Update Saved Chat Colors
			for chatType, info in Satellite_Config.chatTypes do
				if (Satellite.isSlashCommandByID(chatType)) then
					if (ChatTypeInfo[chatType] and info.r and info.g and info.b) then
						ChatTypeInfo[chatType].r = info.r;
						ChatTypeInfo[chatType].g = info.g;
						ChatTypeInfo[chatType].b = info.b;
					end
				end
			end
		elseif (event == "UPDATE_CHAT_WINDOWS") then
			for chatType, info in Satellite_Config.chatTypes do
				if (Satellite.isSlashCommandByID(chatType)) then
					local chatFrame;
					for i=1, NUM_CHAT_WINDOWS do
						if (info[i]) then
							chatFrame = getglobal("ChatFrame"..i);
							if (not Satellite.IsChatTypeVisible(chatType, chatFrame)) then
								ChatFrame_AddMessageGroup(chatFrame, chatType);
							end
						end
					end
				end
			end
		end
	end
	
	--Event Driver
	if (not SatelliteFrame) then
		CreateFrame("Frame", "SatelliteFrame");
	end
	SatelliteFrame:Hide();
	--Frame Scripts
	SatelliteFrame:SetScript("OnEvent", Satellite.OnEvent);
	SatelliteFrame:RegisterEvent("ADDON_LOADED");
	SatelliteFrame:RegisterEvent("VARIABLES_LOADED");
	SatelliteFrame:RegisterEvent("UPDATE_CHAT_WINDOWS");
	
end

--[[
-------------------------------------------------------------------------------
	slashCommand:
	 	{
	 		-- Required members
	 		id = Identifier;
	 		commands = { "/command1", "/command2" }; -- Note: commands should be lowercase
	 		onExecute = SomeFunction;
	 		
	 		-- Optional members
	 		onSpace = SomeFunction;
	 		onTab = SomeFunction;
	 		helpText = "This does something cool.";
	 		
	 		-- ChatType members 
	 		-- Using any of the following options will make the slash command a full fledged Chat Type.
	 		-- Chat Types are shown in the Chat Tab menus and can have their color and visibility controlled by the player.
	 		-- You can send emulated messages as a ChatType (registered Satellite ID) using GenerateChatEvent.
	 		sticky = false;
	 		hideMenuOption = false;
	 		menuText = "Command";
	 		header = "Command: ";
	 		printHeader = "[Command]: "; -- or { "header1 ", "header2 " };
	 		defaultFrames = { 1, 2, 3 };
	 		defaultColor = { r = 1.0, g = 1.0, b = 1.0 };
	 		onColorChange = SomeFunction;
	 		onVisibleChange = SomeFunction;
	 	}

	Allows you to register one or more /commands

	Arg Members:
		id - some unique ID (used in various variable generation and as the ChatType, all upper case)
		commands - a table of /commands to check for
		onExecute - a function which is called when the user runs the command
			args:
 				msg - the chat message as typed into the editbox (excluding the "/command ")
 				lastCommandUsed - the slash command as typed into the editbox (or last one used in the case of a sticky command)

	   Optional:
		onSpace - a function called when a spacebar is pressed
			args:
 				msg - the chat message as currently seen in the editbox (excluding the "/command ")
 				lastCommandUsed - the slash command as typed into the editbox (or last one used in the case of a sticky command)
		onTab - a function call when a tab key is pressed
			args:
 				msg - the chat message as currently seen in the editbox (excluding the "/command ")
 				lastCommandUsed - the slash command as typed into the editbox (or last one used in the case of a sticky command)
		helpText - a string explaining what the command does
		
	ChatType members
		sticky - boolean value determining if the command should be sticky
		hideMenuOption - boolean to dissable adding of this ChatType to the "Other Messages" menu of the Chat Tab Menu
		menuText - text seen in the "Other Messages" menu of the Chat Tab Menu (used to generate printHeader is absent)
 		header - text or table of text seen in the left of the edit box after entering the slash command (defaults to commands[1])
 			If in table form it should have the same amount of entries as the 'commands' table, implying direct relation.
 			ex: If command 1 is used header 1 will be seen, etc.
 		printHeader - text seen in the left of the chat frame message when using GenerateChatEvent
 		defaultFrames - a table of the #'s of chat frames this ChatType will by visible in by default
 		defaultColor - the default color table of this ChatType in the editbox and chat frame messages
 		onColorChange - function called when the color is changed
 			args:
 				r - red value (0-1)
 				g - green value (0-1)
 				b - blue value (0-1)
 		onVisibleChange
 			args:
 				frameID - (1-7) chat frame that visibility has been modified on
 				isVisible - boolean value for if the chatType is visible or not
 				
]]--