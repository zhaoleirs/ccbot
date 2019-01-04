-- Bindings
BINDING_HEADER_ECASTINGBAR = "eCastingBar"
BINDING_NAME_ECASTINGBARDLG = "Toggle Configuration Window";
ECASTINGBAR_TITLE = "Configure eCastingBar"

-- Global constants
CASTING_BAR_MAJOR_VERSION = "1";
CASTING_BAR_MINOR_VERSION = "3";
CASTING_BAR_REVISION = "24";
CASTING_BAR_ALPHA_STEP = 0.05;
CASTING_BAR_FLASH_STEP = 0.2;
CASTING_BAR_HOLD_TIME = 1;
CASTING_BAR_WIDTH = 264;
CASTING_BAR_HEIGHT = 30;
CASTING_BAR_SLIDER_WIDTH_MIN = 100;
CASTING_BAR_SLIDER_WIDTH_MAX = 2000;
CASTING_BAR_SLIDER_HEIGHT_MIN = 20;
CASTING_BAR_SLIDER_HEIGHT_MAX = 60;
CASTING_BAR_DEFAULT_SPELL_LENGTH = -1     -- show all
CASTING_BAR_DEFAULT_SPELL_JUSTIFY = "Center"


-- Global variables
eCastingBar_Saved = {};
eCastingBar_Player = nil;
eCastingBar_Resolution = nil;
eCastingBar_ResolutionWidth = 0;
eCastingBar_ResolutionHeight = 0;
eCastingBar_MENU_SAVEDSETTINGS = nil;
eCastingBar_SETTINGS_INDEX = "";

-- Local Constants
local CASTING_BAR_DEFAULT_TEXTURE = "Interface\\TargetingFrame\\UI-StatusBar";
local CASTING_BAR_PERL_TEXTURE = "Interface\\AddOns\\eCastingBar\\Textures\\StatusBar.tga";
local CASTING_BAR_COLOR_TEXTURE = "Interface\\AddOns\\eCastingBar\\Textures\\RoundedLightSample.tga";
local CASTING_BAR_BACKGROUND_FILE = "Interface\\Tooltips\\UI-Tooltip-Background";
local CASTING_BAR_EDGE_FILE = "Interface\\Tooltips\\UI-Tooltip-Border";

local eCastingBar_SlotUsed = -1;

-- Casting Bar Frame Suffixes
local frameSuffixes = { "" }

local CASTING_BAR_DEFAULTS = {
  ["Locked"] = 0,
  ["Enabled"] = 1,
  ["UsePerlTexture"] = 1,
  ["ShowTime"] = 1,
  ["HideBorder"] = 0,
  ["ShowDelay"] = 1,
  ["ShowSpellRank"] = 0,
  ["UseFriendlyEnemy"] = 0,
  ["Width"] = CASTING_BAR_WIDTH,
  ["Height"] = CASTING_BAR_HEIGHT,
  ["Left"] = 300,
  ["Bottom"] = 300,
  ["SpellLength"] = CASTING_BAR_DEFAULT_SPELL_LENGTH,
  ["SpellJustify"] = CASTING_BAR_DEFAULT_SPELL_JUSTIFY,
  ["FontSize"] = 12,
  ["MirrorLocked"] = 0,
  ["MirrorEnabled"] = 1,
  ["MirrorUsePerlTexture"] = 1,
  ["MirrorShowTime"] = 1,
  ["MirrorHideBorder"] = 0,
  ["MirrorWidth"] = CASTING_BAR_WIDTH,
  ["MirrorHeight"] = CASTING_BAR_HEIGHT,
  ["MirrorLeft"] = 300,
  ["MirrorBottom"] = 400,
  ["MirrorSpellLength"] = CASTING_BAR_DEFAULT_SPELL_LENGTH,
  ["MirrorSpellJustify"] = CASTING_BAR_DEFAULT_SPELL_JUSTIFY,
  ["MirrorFontSize"] = 12
}

local CASTING_BAR_DEFAULT_COLORS = {
  ["SpellColor"] = {1.0, 0.7, 0.0, 1},
  ["ChannelColor"] = {0.3, 0.3, 1.0, 1},
  ["SuccessColor"] = {0.0, 1.0, 0.0, 1},
  ["FailedColor"] = {1.0, 0.0, 0.0, 1},
  ["FlashBorderColor"] = {1.0, 0.88, 0.25, 1},
  ["FeignDeathColor"] = {1.0, 0.7, 0.0, 1},
  ["ExhaustionColor"] = {1.0, 0.9, 0.0, 1},
  ["BreathColor"] = {0.0, 0.5, 1.0, 1},
  ["TimeColor"] = {1.0, 1.0, 1.0, 1},
  ["DelayColor"] = {1.0, 0.0, 0.0, 1},
  ["MirrorTimeColor"] = {1.0, 1.0, 1.0, 1},
  ["MirrorFlashBorderColor"] = {1.0, 0.88, 0.25, 1},
  ["FriendColor"] = {0.0, 0.0, 1.0, 1},
  ["EnemyColor"] = {1.0, 0.0, 0.0, 1}
}
-- local variables

local eCastingBar__FlashBorders = {
	"TOPLEFT",
	"TOP",
	"TOPRIGHT",
	"LEFT",
	"RIGHT",
	"BOTTOMLEFT",
	"BOTTOM",
	"BOTTOMRIGHT"	
}

local eCastingBar__Events = {
	"SPELLCAST_START",
	"SPELLCAST_STOP",
	"SPELLCAST_INTERRUPTED",
	"SPELLCAST_FAILED",
	"SPELLCAST_DELAYED",
	"SPELLCAST_CHANNEL_START",
	"SPELLCAST_CHANNEL_UPDATE",
	"SPELLCAST_CHANNEL_STOP",
  "MIRROR_TIMER_START"
}


local eCastingBar__CastTimeEvents = {
	"SPELLCAST_START",
	"SPELLCAST_STOP",
	"SPELLCAST_INTERRUPTED",
	"SPELLCAST_FAILED"
}

-- FlightMap vars
local eCB_FM_TakeTaxiNode = function() end;

function ECB_addChat(msg)
	DEFAULT_CHAT_FRAME:AddMessage(CASTINGBAR_HEADER.." "..msg)
end

function eCastingBar_Toggle()
	if eCastingBarConfigFrame:IsVisible() then
    eCastingBarConfigFrame:Hide()
	else
    eCastingBarConfigFrame:Show()
	end
end

--[[ onFoo stuff ]]--
function eCastingBar_OnLoad()

	-- load the new castingbar:
	eCastingBar:RegisterEvent("PLAYER_ENTERING_WORLD")
	eCastingBar:RegisterEvent("VARIABLES_LOADED")

  -- replace use action function
  --ECB_orig_UseAction = UseAction;
  --UseAction = eCastingBar_UseAction;
end

--[[ 
This function will check for the Flight Map Addon
If found, we will overwrite their OnEnter function with ours.
]]--
function eCastingBar_CheckFlightMapAddon()
	if (FlightMapFrame) then
    -- store the FlightPath TaxiNodeOnButtonEnter function
    eCB_FM_TakeTaxiNode = TakeTaxiNode
    -- hook our function up
    TakeTaxiNode = eCastingBar_TakeTaxiNode;
	end
end

function eCastingBar_TakeTaxiNode(id)
	-- first call the Flight Maps TakeTaxiNode
  eCB_FM_TakeTaxiNode(id)

  eCastingBar_SetTaxiInfo()
end

function eCastingBar_SetTaxiInfo()	  
  -- now we will use the values for the taxi node for the casting bar
  if (FlightMapTimesFrame) then
  	if (FlightMapTimesFrame:IsVisible()) then
      if (eCastingBar_Saved[eCastingBar_Player].Enabled == 1) then
        -- grab all the values for this casting bar
        local intDuration = nil

        if (FlightMapTimesFrame.endTime ~= nil) then
          intDuration = (FlightMapTimesFrame.endTime - FlightMapTimesFrame.startTime) * 1000
        end

        eCastingBar.OnTaxi = true;
        eCastingBar_SpellcastChannelStart( "", intDuration , FlightMapTimesFrame.endPoint )

        -- store the flight map position
        eCastingBar_Saved[eCastingBar_Player].FlightMapX = FlightMapTimesFrame:GetLeft()
        eCastingBar_Saved[eCastingBar_Player].FlightMapY = FlightMapTimesFrame:GetBottom()

        -- now move the frame off the screen
        FlightMapTimesFrame:ClearAllPoints()
        FlightMapTimesFrame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", -2000, 2000 )
      end
  	end
  end
end

--[[ Registers "frame" (passed as a string) to spellcast events. ]]--
function eCastingBar_Register( frmFrame, strEvent )

	-- register event.
	getglobal( frmFrame ):RegisterEvent( strEvent )	

end

--[[ Unregisters "frame" (passed as a string) from spellcast events. ]]--
function eCastingBar_Unregister( frmFrame, strEvent )

	-- ungregister event.
	getglobal( frmFrame ):UnregisterEvent( strEvent )	

end

--[[ Handles all the mods' events. ]]--
function eCastingBar_OnEvent( frame )
	if event == "PLAYER_ENTERING_WORLD" then
	
		-- inform the user we are starting loading .
		ECB_addChat( CASTINGBAR_LOADED )

		eCastingBar:UnregisterEvent( event )
		
		eCastingBar_Player = UnitName( "player" ).. " - " ..GetRealmName( )

    -- hide all bars
    for index, option in frameSuffixes do
      getglobal("eCastingBar"..option):Hide();
    end

		--is the save empty or broken?
		if not eCastingBar_Saved[eCastingBar_Player]  or eCastingBar_Saved[eCastingBar_Player] == 1 then
      eCastingBar_Saved[eCastingBar_Player] = {}

			--yes, inform the user we are loaing defaults
			ECB_addChat( "	First Load or broken save, Loading defaults." )
			
			--set it to defaults
      eCastingBar_ResetSettings()
		end
		
    eCastingBar_CheckSettings()

		eCastingBar_LoadVariables()

    -- check for FlightMap Addon
    eCastingBar_CheckFlightMapAddon()

	end

    --if( event == "VARIABLES_LOADED" ) then
	
		-- load the variables

	--end
	
	if( event == "SPELLCAST_START" ) then

		-- arg1 = Spell Name
		-- arg2 = Duration (in milliseconds)
		eCastingBar_SpellcastStart( frame, arg1, arg2 )
		
	elseif( event == "SPELLCAST_STOP" ) then
	
		eCastingBar_SpellcastStop( frame )
		
	elseif( event == "SPELLCAST_FAILED" or event == "SPELLCAST_INTERRUPTED" ) then
	
		eCastingBar_SpellcastFailed( frame )

	elseif( event == "SPELLCAST_DELAYED" ) then
	
		-- arg1 = Disruption Time(in milliseconds)
		eCastingBar_SpellcastDelayed( frame, arg1 )

	elseif( event == "SPELLCAST_CHANNEL_START" ) then

		-- arg1 = Duration (in milliseconds)
		-- arg2 = Spell Name
		eCastingBar_SpellcastChannelStart( frame, arg1, arg2 )
		
	elseif( event == "SPELLCAST_CHANNEL_UPDATE" ) then
	  
    -- won't fire now
		-- arg1 = Remaining Duration (in milliseconds)
    eCastingBar_SpellcastChannelUpdate( frame, arg1 ) 
  elseif ( event == "SPELLCAST_CHANNEL_STOP" ) then
    eCastingBar_SpellcastChannelStop( frame ) 
	end

  -- check for mirros
  if( event == "MIRROR_TIMER_START" ) then
    if (eCastingBar_Saved[eCastingBar_Player].MirrorEnabled == 1) then 
      -- if we are not using Blizzards timers we should hide it.
      if (eCastingBar_Saved[eCastingBar_Player].MirrorEnabled == 1) then
      	hideBlizzardMirrorFrame(arg1)
      else
        -- else make sure its shown
        showBlizzardMirrorFrame(arg1)
      end
      eCastingBarMirror_Show(arg1, arg2, arg3, arg4, arg5, arg6)
    end
  end
end

function hideBlizzardMirrorFrame(timer)
	-- hide the Blizzard frame
  for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    local frame = getglobal("MirrorTimer"..index)
    if (frame.timer == timer) then
      frame:Hide()
    end
  end
end

function showBlizzardMirrorFrame(timer)
	-- hide the Blizzard frame
  for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    local frame = getglobal("MirrorTimer"..index)
    if (frame.timer == timer) then
      frame:Show()
    end
  end
end

function hideAllBlizzardMirrorFrames()
	-- hide the Blizzard frame
  for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    local frame = getglobal("MirrorTimer"..index)
    local frame2 = getglobal("eCastingBarMirror"..index)
    
    if (frame2.timer ~= nil) then
    	frame:Hide()
      frame2:Show()
    end
  end
end


function showAllBlizzardMirrorFrames()
	-- hide the Blizzard frame
  for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    local frame = getglobal("MirrorTimer"..index)
    local frame2 = getglobal("eCastingBarMirror"..index)
    if (frame.timer ~= nil) then
      frame:Show()
      frame2:Hide()
    end
  end
end

function eCastingBar_ResetSettings()
  ECB_addChat("Resetting Default Settings")
  eCastingBar_Saved[eCastingBar_Player] = {}
  -- Reset General Options
  for option in CASTING_BAR_DEFAULTS do
     eCastingBar_Saved[eCastingBar_Player][option] = CASTING_BAR_DEFAULTS[option]
  end
  
  -- Reset Colors
  for color in CASTING_BAR_DEFAULT_COLORS do
     eCastingBar_Saved[eCastingBar_Player][color] = CASTING_BAR_DEFAULT_COLORS[color]
  end

  
  setup()
end

function eCastingBar_CheckSettings()
  -- Reset General Options
  for option in CASTING_BAR_DEFAULTS do
     if (eCastingBar_Saved[eCastingBar_Player][option] == nil) then
       eCastingBar_Saved[eCastingBar_Player][option] = CASTING_BAR_DEFAULTS[option]
     end
  end

  -- check for nil colors
  for color in CASTING_BAR_DEFAULT_COLORS do
    if (eCastingBar_Saved[eCastingBar_Player][color] == nil) then
      eCastingBar_Saved[eCastingBar_Player][color] = CASTING_BAR_DEFAULT_COLORS[color]
    end
  end
end

function setup()
  eCastingBar_checkEnabled()
  eCastingBar_checkLocked()
  eCastingBar_checkBorders()
  eCastingBar_checkTimeColors( )
  eCastingBar_setDelayColor()
  eCastingBar_SetSize()
  eCastingBar_checkFlashBorderColors()
  eCastingBar_checkTextures()
end

--[[ Iniitialization ]]--
function eCastingBar_LoadVariables( )	
    setup()
    eCastingBar_SetSavedSettingsMenu()

		-- set the loaded variables
		
		-- make the casting bar link to the movable button
		eCastingBar:SetPoint("TOPLEFT", "eCastingBar_Outline", "TOPLEFT", 0, 0 )

    -- make the mirror casting bar link to the movable button
		eCastingBarMirror1:SetPoint("TOPLEFT", "eCastingBarMirror_Outline", "TOPLEFT", 0, 0 )
		
		-- reset variables
    for index, option in frameSuffixes do
      getglobal("eCastingBar"..option).casting = nil
      getglobal("eCastingBar"..option).holdTime = 0
    end
		
			-- code used if no cosmos is present

		-- make the slash commands
		SlashCmdList["ECASTINGBAR"] = eCastingBar_SlashHandler
		SLASH_ECASTINGBAR1 = "/eCastingBar"
		SLASH_ECASTINGBAR2 = "/eCB"

    -- resolution
    SetResolution(GetScreenResolutions())
    local i,j = string.find(eCastingBar_Resolution, "x")

    --eCastingBar_ResolutionWidth = tonumber(string.sub(eCastingBar_Resolution, 0, i - 1))
    --eCastingBar_ResolutionHeight = tonumber(string.sub(eCastingBar_Resolution, i + 1, string.len(eCastingBar_Resolution)))

    -- override these for now until I can figure out why blizzard is jacked up
    eCastingBar_ResolutionWidth = 2000
    eCastingBar_ResolutionHeight = 2000

    setupConfigFrame()
    setupDefaultConfigFrame()
    setupColorsConfigFrame()
end

function setupConfigFrame()
	-- set all text values --
  eCastingBarGeneralsSelect:SetText(CASTINGBAR_GENERAL_BUTTON)
  eCastingBarMirrorSelect:SetText(CASITINGBARMIRROR_BUTTON)
  eCastingBarColorsSelect:SetText(CASTINGBAR_COLOR_BUTTON)
  eDefaultsConfigButton:SetText(CASTINGBAR_DEFAULTS_BUTTON)
  eCloseConfigButton:SetText(CASTINGBAR_CLOSE_BUTTON)
  eCastingBarSaveSettingsButton:SetText(CASTINGBAR_SAVE_BUTTON)
  eCastingBarLoadSettingsButton:SetText(CASTINGBAR_LOAD_BUTTON)
  eCastingBarDeleteSettingsButton:SetText(CASTINGBAR_DELETE_BUTTON)
end

function setupDefaultConfigFrame()
  -- set all text values --
  for option in CASTING_BAR_BUTTONS do
    local btnText = getglobal("eCastingBar"..option.."Text")
    btnText:SetText(CASTING_BAR_BUTTONS[option])
  end

  eCastingBarSpellLength:SetNumber(eCastingBar_Saved[eCastingBar_Player].SpellLength)
  eCastingBarSpellLengthText:SetText(CASTINGBAR_SPELL_LENGTH_TEXT)
  eCastingBarSpellJustify_Label:SetText(CASTINGBAR_SPELL_JUSTIFY_TEXT)
  eCastingBarSpellJustify_Setting:SetText(eCastingBar_Saved[eCastingBar_Player].SpellJustify)  
  eCastingBarText:SetJustifyH(eCastingBar_Saved[eCastingBar_Player].SpellJustify)
  
  eCastingBarMirrorSpellLength:SetNumber(eCastingBar_Saved[eCastingBar_Player].MirrorSpellLength)
  eCastingBarMirrorSpellLengthText:SetText(CASTINGBARMIRROR_SPELL_LENGTH_TEXT)
  eCastingBarMirrorSpellJustify_Label:SetText(CASTINGBARMIRROR_SPELL_JUSTIFY_TEXT)
  eCastingBarMirrorSpellJustify_Setting:SetText(eCastingBar_Saved[eCastingBar_Player].MirrorSpellJustify)  

  for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    getglobal("eCastingBarMirror"..index.."StatusBarText"):SetJustifyH(eCastingBar_Saved[eCastingBar_Player].MirrorSpellJustify)
  end

  -- set all checks
  for option in CASTING_BAR_BUTTONS do
    local btn = getglobal("eCastingBar"..option)
    btn:SetChecked(eCastingBar_Saved[eCastingBar_Player][option])
  end
  
  local slider, sliderText, low, high, width, height

  local optionTabs = { "", "Mirror" }

  for index, option in optionTabs do
  	-- setup the width slider
    slider = getglobal("eCastingBar"..option.."WidthSlider")
    sliderText = getglobal("eCastingBar"..option.."WidthSliderText")
    low = getglobal("eCastingBar"..option.."WidthSliderLow")
    high = getglobal("eCastingBar"..option.."WidthSliderHigh")

    slider:SetMinMaxValues(CASTING_BAR_SLIDER_WIDTH_MIN, eCastingBar_ResolutionWidth)
    slider:SetValueStep(1)
    slider:SetValue(eCastingBar_Saved[eCastingBar_Player][option.."Width"])
    sliderText:SetText(CASTINGBAR_SLIDER_WIDTH_TEXT)
    low:SetText(CASTING_BAR_SLIDER_WIDTH_MIN)
    high:SetText(eCastingBar_ResolutionWidth)

    -- setup the height slider
    slider = getglobal("eCastingBar"..option.."HeightSlider")
    sliderText = getglobal("eCastingBar"..option.."HeightSliderText")
    low = getglobal("eCastingBar"..option.."HeightSliderLow")
    high = getglobal("eCastingBar"..option.."HeightSliderHigh")


    slider:SetMinMaxValues(CASTING_BAR_SLIDER_HEIGHT_MIN, CASTING_BAR_SLIDER_HEIGHT_MAX)
    slider:SetValueStep(1)
    slider:SetValue(eCastingBar_Saved[eCastingBar_Player][option.."Height"])
    sliderText:SetText(CASTINGBAR_SLIDER_HEIGHT_TEXT)
    low:SetText(CASTING_BAR_SLIDER_HEIGHT_MIN)
    high:SetText(CASTING_BAR_SLIDER_HEIGHT_MAX)

    -- setup the x slider
    slider = getglobal("eCastingBar"..option.."LeftSlider")
    sliderText = getglobal("eCastingBar"..option.."LeftSliderText")
    low = getglobal("eCastingBar"..option.."LeftSliderLow")
    high = getglobal("eCastingBar"..option.."LeftSliderHigh")

    if (option == "Mirror") then
      width = tonumber(string.format("%.0f", getglobal("eCastingBarMirror1"):GetWidth()))
      height = tonumber(string.format("%.0f", getglobal("eCastingBarMirror1"):GetHeight()))
    else
      width = tonumber(string.format("%.0f", getglobal("eCastingBar"..option):GetWidth()))
      height = tonumber(string.format("%.0f", getglobal("eCastingBar"..option):GetHeight()))
    end

    slider:SetMinMaxValues(-1000, eCastingBar_ResolutionWidth)
    slider:SetValueStep(1)
    slider:SetValue(eCastingBar_Saved[eCastingBar_Player][option.."Left"])
    sliderText:SetText(CASTINGBAR_SLIDER_LEFT_TEXT)
    low:SetText(-1000)
    high:SetText(eCastingBar_ResolutionWidth)

    -- setup the y slider
    slider = getglobal("eCastingBar"..option.."BottomSlider")
    sliderText = getglobal("eCastingBar"..option.."BottomSliderText")
    low = getglobal("eCastingBar"..option.."BottomSliderLow")
    high = getglobal("eCastingBar"..option.."BottomSliderHigh")

    slider:SetMinMaxValues(-1000, eCastingBar_ResolutionHeight)
    slider:SetValueStep(1)
    slider:SetValue(eCastingBar_Saved[eCastingBar_Player][option.."Bottom"])
    sliderText:SetText(CASTINGBAR_SLIDER_BOTTOM_TEXT)
    low:SetText(-1000)
    high:SetText(eCastingBar_ResolutionHeight)

    -- setup the font slider
    slider = getglobal("eCastingBar"..option.."FontSlider")
    sliderText = getglobal("eCastingBar"..option.."FontSliderText")
    low = getglobal("eCastingBar"..option.."FontSliderLow")
    high = getglobal("eCastingBar"..option.."FontSliderHigh")

    slider:SetMinMaxValues(8, 40)
    slider:SetValueStep(1)
    slider:SetValue(eCastingBar_Saved[eCastingBar_Player][option.."FontSize"])
    sliderText:SetText(CASTINGBAR_SLIDER_FONT_TEXT)
    low:SetText(8)
    high:SetText(40)
  end
end

function setupColorsConfigFrame()
  -- set the textures --
  for color in CASTINGBAR_COLOR_LABEL do
    local btnColor = getglobal("btn"..color.."Texture")

    -- set the texture
    btnColor:SetTexture(CASTING_BAR_COLOR_TEXTURE)

    -- set the vertex color
    btnColor:SetVertexColor(unpack(eCastingBar_Saved[eCastingBar_Player][color]))

    -- set the label
    getglobal("lbl"..color.."Text"):SetText(CASTINGBAR_COLOR_LABEL[color])
  end
end

function SetResolution(...)
  local iRes = GetCurrentResolution()

  for i=1, arg.n, 1 do
    if (iRes == i) then
    	eCastingBar_Resolution = arg[i]
    end
  end
end


--[[ Handles all the slash commands if cosmos isn't present. ]]--
function eCastingBar_SlashHandler( strMessage )
  local command, param
	-- make it it all lower case to be sure
	strMessage = string.lower( strMessage )

  if(index) then
		command = string.sub(strMessage, 1, (index - 1))
		param = string.sub(strMessage, (index + 1)  )
	else
		command = strMessage
	end
			
	if( command == CASTINGBAR_CHAT_C1 ) then 
		-- show the config window
    getglobal("eCastingBarConfigFrame"):Show()
  
  -- no, did they type: help?
  elseif ( command == CASTINGBAR_CHAT_C2) then
    -- call for help
    eCastingBar_ChatHelp()

	-- no: do default
	else

    -- show the config window
    getglobal("eCastingBarConfigFrame"):Show()
		
	end	

  setupDefaultConfigFrame()
  setupColorsConfigFrame()
	
end

--[[ Handles chat help messages. ]]--
function eCastingBar_ChatHelp( )

	local intIndex = 0
	local strMessage = ""
	
	-- prints each line in CASTINGBAR_HELP = { }
	for intIndex, strMessage in CASTINGBAR_HELP do
	
		ECB_addChat( strMessage )
		
	end
	
end


--[[ Replaces the UseAction function ]]--
function eCastingBar_UseAction(slot, checkCursor, onSelf)
  eCastingBar_SlotUsed = slot;
  return ECB_orig_UseAction(slot, checkCursor, onSelf)
end

function ECB_GetActionSpell(slot)
	ECB_TooltipTextLeft1:SetText();
	ECB_TooltipTextRight1:SetText();
	ECB_Tooltip:SetAction(slot);
	local start, stop, name, rank;
	name = ECB_TooltipTextLeft1:GetText();
	rank = ECB_TooltipTextRight1:GetText();
	start, stop, rank = string.find((rank or ""), "(%d+)");
	rank = (rank or 1) / 1.0;
	return (name or ""), rank;
end

function eCastingBar_IsSpell(spell, rank)
  local i = 1
  
  rank = "Rank "..tonumber(rank);

  while true do
    local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)

    if not spellName then
      do break end
    end

    if (spell == spellName and rank == spellRank) then
      return 1;
    end
     
    i = i + 1
  end

  return 0;
end

--[[ Handles the SPELLCAST_START event. ]]--
function eCastingBar_SpellcastStart( fraFrame, strSpellName, intDuration ) 
  local spell = "";
  local rank = "";
  
  -- try to find the current action
  for slot = 1, 200, 1 do
    if (HasAction(slot) == 1 and IsCurrentAction(slot) == 1) then
      spell, rank = ECB_GetActionSpell(slot);
      
      -- go through the spellbook and see if this is an actual spell
      if (eCastingBar_IsSpell(spell, rank) == 0) then
      	spell = "";
        rank = "";
      end
      break;
    end
  end

  if (eCastingBar_Saved[eCastingBar_Player].ShowSpellRank == 1) then
    if (spell ~= "") then
      strSpellName = spell.." (Rank "..rank..")"	
    end
  end
  
	-- set the bar color
  -- check for friendly or enemy player
  local Red, Green, Blue, Alpha
  
  if (eCastingBar_CurrentSpell ~= "" and eCastingBar_Saved[eCastingBar_Player].UseFriendlyEnemy == 1) then
    if (UnitIsFriend("player","target") and (UnitName("target") ~= UnitName("player"))) then
      Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player].FriendColor)
    elseif (UnitIsEnemy("player","target")) then
      Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player].EnemyColor)
    else
      Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player].SpellColor)
    end
  else
    Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player].SpellColor)
  end
  

  
	getglobal("eCastingBar"..fraFrame.."StatusBar"):SetStatusBarColor( Red, Green, Blue, Alpha )
	
	-- show the spark
	getglobal("eCastingBar"..fraFrame.."Spark"):Show( )
	
	-- set the start and max time
	getglobal("eCastingBar"..fraFrame).startTime = GetTime( )
  getglobal("eCastingBar"..fraFrame).initStartTime = GetTime( )

  -- if the duration is nil set it to 10 minutes.  Nothing should last this long
  if (intDuration == nil) then
  	intDuration = 600000
  end
	getglobal("eCastingBar"..fraFrame).maxValue = getglobal("eCastingBar"..fraFrame).startTime + ( intDuration / 1000 )
	
	-- set the bar minium and maxium accordingly (basicly it will grow as time passes)
	getglobal("eCastingBar"..fraFrame.."StatusBar"):SetMinMaxValues( getglobal("eCastingBar"..fraFrame).startTime, getglobal("eCastingBar"..fraFrame).maxValue )
	
	-- set the bar to empty
	getglobal("eCastingBar"..fraFrame.."StatusBar"):SetValue( getglobal("eCastingBar"..fraFrame).startTime )
	
	-- set the text to the spell name
  -- figure out how much to show
  if ( eCastingBar_Saved[eCastingBar_Player][fraFrame.."SpellLength"] == -1 ) then
    -- show all
  	getglobal("eCastingBar"..fraFrame.."Text"):SetText( strSpellName )
  elseif ( eCastingBar_Saved[eCastingBar_Player][fraFrame.."SpellLength"] == 0) then
    -- dont show it
    getglobal("eCastingBar"..fraFrame.."Text"):SetText( "" ) 
  else
    -- if the size of the name is less than or equal to the max size, just show it all
    if ( string.len(strSpellName) <= eCastingBar_Saved[eCastingBar_Player][fraFrame.."SpellLength"] ) then
    	getglobal("eCastingBar"..fraFrame.."Text"):SetText( strSpellName )
    else
      getglobal("eCastingBar"..fraFrame.."Text"):SetText( string.sub(strSpellName , 1, eCastingBar_Saved[eCastingBar_Player][fraFrame.."SpellLength"]) )
    end
  end
	
	-- set the bar to fully opaque
	getglobal("eCastingBar"..fraFrame):SetAlpha( 1.0 )
	
	-- start the casting state, and make sure everything else is reset
	getglobal("eCastingBar"..fraFrame).holdTime = 0
	getglobal("eCastingBar"..fraFrame).casting = 1
	getglobal("eCastingBar"..fraFrame).fadeOut = nil
  getglobal("eCastingBar"..fraFrame).delay = 0
	getglobal("eCastingBar"..fraFrame):Show( )
	getglobal("eCastingBar"..fraFrame).mode = "casting"
  
end

--[[ Handles the SPELLCAST_STOP event. ]]--
function eCastingBar_SpellcastStop( fraFrame )

	-- NOTE: not sure why but certain things in here keep getting called everytime channeling updates
	--	first the green bar colored used for success, forced channeling green also (no matter what i did)
	-- so don't put anything in here that will fuck w/ channeling, unless you use if( eCastingBar.channeling == nil)

		-- test

	-- make sure we aren't channeling first
	if( getglobal("eCastingBar"..fraFrame).channeling == nil ) then
		-- set the bar color
    local Red, Green, Blue, Alpha
    Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player].SuccessColor)
  	getglobal("eCastingBar"..fraFrame.."StatusBar"):SetStatusBarColor( Red, Green, Blue, Alpha )
		getglobal("eCastingBar"..fraFrame.."Spark"):Hide( )
		
	end
		
	-- is the bar still visiable?
	if ( not getglobal("eCastingBar"..fraFrame):IsVisible( ) ) then
	
		-- yes, we are done casting, so hide it
		getglobal("eCastingBar"..fraFrame):Hide( )
		
	end
	
	-- is the bar still shown? ( not sure what the difference between this and :IsVisible, but there is (figure it out!) )
	if ( getglobal("eCastingBar"..fraFrame):IsShown( ) ) then
	
		-- set the bar to max value (visually helps the user see)
		getglobal("eCastingBar"..fraFrame.."StatusBar"):SetValue( getglobal("eCastingBar"..fraFrame).maxValue )
		
		-- start the flash state
		getglobal("eCastingBar"..fraFrame.."Flash"):SetAlpha( 0.0 )
		getglobal("eCastingBar"..fraFrame.."Flash"):Show( )
		getglobal("eCastingBar"..fraFrame).casting = nil
    getglobal("eCastingBar"..fraFrame).OnTaxi = nil
    getglobal("eCastingBar"..fraFrame).flying = nil
    getglobal("eCastingBar"..fraFrame).delay = 0
		getglobal("eCastingBar"..fraFrame).flash = 1
		getglobal("eCastingBar"..fraFrame).fadeOut = 1
		getglobal("eCastingBar"..fraFrame).mode = "flash"
		
	end

end

--[[ Handles the SPELLCAST_FAILED and SPELLCAST_INTERRUPTED events. ]]--
function eCastingBar_SpellcastFailed( fraFrame )
  -- first make sure we are not flying.  if so, just ignore this
  if (getglobal("eCastingBar"..fraFrame).flying) then return; end

	-- is the bar still shown? ( not sure what the difference between this and :IsVisiable, but there is (figure it out!) )
	if ( getglobal("eCastingBar"..fraFrame):IsShown( ) ) then
	
		-- set the bar to max (visually helps the user see)
		getglobal("eCastingBar"..fraFrame.."StatusBar"):SetValue( getglobal("eCastingBar"..fraFrame).maxValue )
		
		-- set the bar color
    local Red, Green, Blue, Alpha
    Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player].FailedColor)
    getglobal("eCastingBar"..fraFrame.."StatusBar"):SetStatusBarColor( Red, Green, Blue, Alpha )
		
		-- hide the spark, we dont need it anymore
		getglobal("eCastingBar"..fraFrame.."Spark"):Hide( )
		
		-- was the called event: spell failed?
		if ( event == "SPELLCAST_FAILED" ) then
		
			-- yes, set the text accordingly
			getglobal("eCastingBar"..fraFrame.."Text"):SetText( FAILED )
			
		else
		
			-- no, it must have been interupted instead, set the text accordingly
			getglobal("eCastingBar"..fraFrame.."Text"):SetText( INTERRUPTED )
			
		end
		
		-- end the casting state, start the fadeout state
		getglobal("eCastingBar"..fraFrame).casting = nil
    getglobal("eCastingBar"..fraFrame).delay = 0
		getglobal("eCastingBar"..fraFrame).fadeOut = 1
		getglobal("eCastingBar"..fraFrame).holdTime = GetTime() + CASTING_BAR_HOLD_TIME
	end

end

--[[ Handles the SPELLCAST_DELAYED event. ]]--
function eCastingBar_SpellcastDelayed( fraFrame, intDisruptionTime )

	-- is the bar still shown? ( not sure what the difference between this and :IsVisiable, but there is (figure it out!) )
	if( getglobal("eCastingBar"..fraFrame):IsShown( ) ) then
	
		-- set the start and max time according to how much it was disrupted
		getglobal("eCastingBar"..fraFrame).startTime = getglobal("eCastingBar"..fraFrame).startTime + ( intDisruptionTime / 1000 )
		getglobal("eCastingBar"..fraFrame).maxValue = getglobal("eCastingBar"..fraFrame).maxValue + ( intDisruptionTime / 1000 )
		
		-- set the bar accordingly (basicly stricking it according to how much it was disrupted)
		getglobal("eCastingBar"..fraFrame.."StatusBar"):SetMinMaxValues( getglobal("eCastingBar"..fraFrame).startTime, getglobal("eCastingBar"..fraFrame).maxValue )

    if (getglobal("eCastingBar"..fraFrame).delay == nil) then
    	getglobal("eCastingBar"..fraFrame).delay = 0
    end

    getglobal("eCastingBar"..fraFrame).delay = getglobal("eCastingBar"..fraFrame).delay + (intDisruptionTime / 1000)
		
	end

end

--[[ Handles the SPELLCAST_CHANNEL_START event. ]]--
function eCastingBar_SpellcastChannelStart( fraFrame, intDuration, strSpellName )
  local spell = "";
  local rank = "";

  -- try to find the current action
  for slot = 1, 200, 1 do
    if (HasAction(slot) == 1 and IsCurrentAction(slot) == 1) then
      spell, rank = ECB_GetActionSpell(slot);
      
      -- go through the spellbook and see if this is an actual spell
      if (eCastingBar_IsSpell(spell, rank) == 0) then
      	spell = "";
        rank = "";
      end
      break;
    end
  end

  if (eCastingBar_Saved[eCastingBar_Player].ShowSpellRank == 1) then
    if (spell ~= "") then
      strSpellName = spell.." (Rank "..rank..")"	
    end
  end

  if (eCastingBar_CurrentSpell ~= "" and eCastingBar_Saved[eCastingBar_Player].UseFriendlyEnemy == 1) then
    if (UnitIsFriend("player","target") and (UnitName("target") ~= UnitName("player"))) then
      Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player].FriendColor)
    elseif (UnitIsEnemy("player","target")) then
      Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player].EnemyColor)
    else
      Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player].ChannelColor)
    end
  else
    Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player].ChannelColor)
  end

  getglobal("eCastingBar"..fraFrame.."StatusBar"):SetStatusBarColor( Red, Green, Blue, Alpha )
	-- show the spark
	getglobal("eCastingBar"..fraFrame.."Spark"):Show( )
	
	-- set the bar to max
	getglobal("eCastingBar"..fraFrame).maxValue = 1

  -- set the delay
  getglobal("eCastingBar"..fraFrame).delay = 0
	
	-- set the start and end times
	getglobal("eCastingBar"..fraFrame).startTime = GetTime( )
  getglobal("eCastingBar"..fraFrame).initStartTime = GetTime( )
  getglobal("eCastingBar"..fraFrame).duration = intDuration / 1000

  -- if the duration is nil set it to 10 minutes.  Nothing should last this long
  if (intDuration == nil) then
  	intDuration = 600000
  end
	getglobal("eCastingBar"..fraFrame).endTime = getglobal("eCastingBar"..fraFrame).startTime + ( intDuration / 1000 )
	
	-- set the bar minium and maxium values
	getglobal("eCastingBar"..fraFrame.."StatusBar"):SetMinMaxValues( getglobal("eCastingBar"..fraFrame).startTime, getglobal("eCastingBar"..fraFrame).endTime )
	
	-- set the bar length visually to reflex the new time
	getglobal("eCastingBar"..fraFrame.."StatusBar"):SetValue( getglobal("eCastingBar"..fraFrame).endTime )
	
	-- set the text to the spell name
  -- figure out how much to show
  if ( eCastingBar_Saved[eCastingBar_Player][fraFrame.."SpellLength"] == -1 ) then
    -- show all
  	getglobal("eCastingBar"..fraFrame.."Text"):SetText( strSpellName )
  elseif ( eCastingBar_Saved[eCastingBar_Player][fraFrame.."SpellLength"] == 0) then
    -- dont show it
    getglobal("eCastingBar"..fraFrame.."Text"):SetText( "" ) 
  else
    -- if the size of the name is less than or equal to the max size, just show it all
    if ( string.len(strSpellName) <= eCastingBar_Saved[eCastingBar_Player][fraFrame.."SpellLength"] ) then
    	getglobal("eCastingBar"..fraFrame.."Text"):SetText( strSpellName )
    else
      getglobal("eCastingBar"..fraFrame.."Text"):SetText( string.sub(strSpellName , 1, eCastingBar_Saved[eCastingBar_Player][fraFrame.."SpellLength"]) )
    end
  end
	
	-- set the bar to fully opaque
	getglobal("eCastingBar"..fraFrame):SetAlpha( 1.0 )
	
	-- reset various valuses used to hide the bar, also make sure its channeling not casting
	getglobal("eCastingBar"..fraFrame).holdTime = 0
	getglobal("eCastingBar"..fraFrame).casting = nil
	getglobal("eCastingBar"..fraFrame).channeling = 1
	getglobal("eCastingBar"..fraFrame).fadeOut = nil
	getglobal("eCastingBar"..fraFrame):Show( )
	getglobal("eCastingBar"..fraFrame).mode = "channeling"
end

--[[ Handles the SPELLCAST_CHANNEL_UPDATE event. ]]--
-- won't fire now
function eCastingBar_SpellcastChannelUpdate( fraFrame, intRemainingDuration )

	-- is the remaining time zero?
	if( intRemainingDuration == 0 ) then
	
			-- yes, we aren't channeling anymore
			getglobal("eCastingBar"..fraFrame).channeling = nil
		
	-- no, is the bar still shown? ( not sure what the difference between this and :IsVisiable, but there is (figure it out!) )
	elseif( getglobal("eCastingBar"..fraFrame):IsShown( ) ) then
					
		-- set the original duration
		local intOriginalDuration = getglobal("eCastingBar"..fraFrame).endTime - getglobal("eCastingBar"..fraFrame).startTime

    -- set the delay
    local elapsedTime = GetTime() - getglobal("eCastingBar"..fraFrame).startTime;
    local losttime = intOriginalDuration*1000 - elapsedTime*1000 - arg1;
    getglobal("eCastingBar"..fraFrame).delay = getglobal("eCastingBar"..fraFrame).delay + (losttime / 1000);

		-- set the start and end time
		getglobal("eCastingBar"..fraFrame).endTime = GetTime( ) + ( intRemainingDuration / 1000 )
		getglobal("eCastingBar"..fraFrame).startTime = getglobal("eCastingBar"..fraFrame).endTime - intOriginalDuration
		
		-- set the bar length reflect the new state (basicly decreases the start time as time passes, thus shrinking the bar)
		getglobal("eCastingBar"..fraFrame.."StatusBar"):SetMinMaxValues( getglobal("eCastingBar"..fraFrame).startTime, getglobal("eCastingBar"..fraFrame).endTime ) 
		
		-- test to see visually when it fires... and it doesn't fire much.
		--ECB_addChat( "SPELLCAST_CHANNELING_UPDATE" )
		
	end

end

--[[ Handles the SPELLCAST_CHANNEL_UPDATE event. ]]--
function eCastingBar_SpellcastChannelStop( fraFrame )
  getglobal("eCastingBar"..fraFrame).channeling = nil

  -- set the bar to max value (visually helps the user see)
  getglobal("eCastingBar"..fraFrame.."StatusBar"):SetValue( getglobal("eCastingBar"..fraFrame).maxValue )
  
  local failed = 0;

  if (getglobal("eCastingBar"..fraFrame).endTime ~= nil) then
  	if ( (getglobal("eCastingBar"..fraFrame).endTime - GetTime()) > 0.5 ) then
      failed = 1;
      eCastingBar_SpellcastFailed (fraFrame)
    end
  end

  if (failed == 0) then
    -- start the flash state
    getglobal("eCastingBar"..fraFrame.."Flash"):SetAlpha( 0.0 )
    getglobal("eCastingBar"..fraFrame.."Flash"):Show( )
    getglobal("eCastingBar"..fraFrame).casting = nil
    getglobal("eCastingBar"..fraFrame).OnTaxi = nil
    getglobal("eCastingBar"..fraFrame).flying = nil
    getglobal("eCastingBar"..fraFrame).delay = 0
    getglobal("eCastingBar"..fraFrame).flash = 1
    getglobal("eCastingBar"..fraFrame).fadeOut = 1
    getglobal("eCastingBar"..fraFrame).mode = "flash"
  end

  
end

--[[ Handles all updates. ]]--
function eCastingBar_OnUpdate( frame )

  -- check if we were on a taxi.
    -- Added for FlightMap support
  if ( getglobal("eCastingBar"..frame).OnTaxi ) then
    if (not getglobal("eCastingBar"..frame).flying) then
      if UnitOnTaxi("player") then getglobal("eCastingBar"..frame).flying = true; end
      return;
    end

    -- are we on a taxi?  
    -- Did we just get off?
    if (not UnitOnTaxi("player")) then
      getglobal("eCastingBar"..frame).flying = nil
      eCastingBar_SpellcastStop( "" )
    end
  end

  -- are we casting?
  if( getglobal("eCastingBar"..frame).casting ) then    
    -- yes:
    local intCurrentTime = GetTime()
    local intSparkPosition = 0
    
    -- update the casting time
    --eCastingBar_Time:SetText( string.sub( math.max( eCastingBar.maxValue - intCurrentTime, 0.00 ), 1,4 ) )
    
    -- Thanks to wbb at Cursed for the lovely formating
    if ( eCastingBar_Saved[eCastingBar_Player][frame.."ShowTime"] == 1) then
      getglobal("eCastingBar"..frame.."_Time"):SetText( string.format( "%.1f", math.max( getglobal("eCastingBar"..frame).maxValue - intCurrentTime, 0.0 ) ) )
    else
      getglobal("eCastingBar"..frame.."_Time"):SetText("")
    end

    local bDelay = false

    if ( eCastingBar_Saved[eCastingBar_Player][frame.."ShowDelay"] == 1) then  
      if (getglobal("eCastingBar"..frame).delay ~= 0) then
        bDelay = true
      end
    end

    if (bDelay) then
      getglobal("eCastingBar"..frame.."_Delay"):SetText("+"..string.format( "%.1f", eCastingBar.delay ) )
    else
      getglobal("eCastingBar"..frame.."_Delay"):SetText("")
    end
    
    -- is the status > than the max?
    if( intCurrentTime > getglobal("eCastingBar"..frame).maxValue ) then
    
      -- yes, set it to max (not sure how it would get that way, but again blizzard is safe)
      intCurrentTime = getglobal("eCastingBar"..frame).maxValue
      
    end
    
    -- update the bar length
    getglobal("eCastingBar"..frame.."StatusBar"):SetValue( intCurrentTime )
    
    --reset the flash to hidden
    getglobal("eCastingBar"..frame.."Flash"):Hide( )

    -- updates the spark
    local width = getglobal("eCastingBar"..frame.."StatusBar"):GetWidth()
    intSparkPosition = ( ( intCurrentTime - getglobal("eCastingBar"..frame).startTime ) / ( getglobal("eCastingBar"..frame).maxValue - getglobal("eCastingBar"..frame).startTime ) ) * width
    if( intSparkPosition < 0 ) then		
      intSparkPosition = 0			
    end
    
    -- set the spark to the end of the current barsize
    getglobal("eCastingBar"..frame.."Spark"):SetPoint( "CENTER", "eCastingBarStatusBar", "LEFT", intSparkPosition, 0 )
    
  -- no, are we channeling?	
  elseif ( getglobal("eCastingBar"..frame).channeling ) then
  
    -- yes:
    local intTimeLeft = GetTime( )
    local intBarValue = 0
    local intSparkPosition = getglobal("eCastingBar"..frame).endTime
    
    -- update the channeling time
    --eCastingBar_Time:SetText( string.sub( math.max( eCastingBar.endTime - intTimeLeft, 0.00 ), 1 , 4 ) )
    
    -- Thanks to wbb at Cursed for the lovely formating
    if (eCastingBar_Saved[eCastingBar_Player][frame.."ShowTime"] == 1) then    	
      -- if we are over 1 minute, do minute:seconds
      local timeLeft = math.max( getglobal("eCastingBar"..frame).endTime - intTimeLeft, 0.0 )
      local timeMsg = nil

      local minutes = 0
      local seconds = 0

      if (timeLeft > 60) then
        minutes = math.floor( ( timeLeft  / 60 ))
        local seconds = math.ceil( timeLeft - ( 60 * minutes ))

        if (seconds == 60) then
          minutes = minutes + 1
          seconds = 0
        end
        timeMsg = format("%s:%s", minutes, getFormattedNumber(seconds))
      else
        timeMsg = string.format( "%.1f", timeLeft )
      end

      --format(COOLDOWNCOUNT_MINUTES_SECONDS_FORMAT, minutes, CooldownCount_GetFormattedNumber(seconds))
      getglobal("eCastingBar"..frame.."_Time"):SetText( timeMsg )
    else
      getglobal("eCastingBar"..frame.."_Time"):SetText("")
    end

    local bDelay = false

    if (eCastingBar_Saved[eCastingBar_Player][frame.."ShowDelay"] == 1) then  
      if (getglobal("eCastingBar"..frame).delay ~= 0) then
        bDelay = true
      end
    end
    
    if (bDelay) then
      getglobal("eCastingBar"..frame.."_Delay"):SetText("-"..string.format( "%.1f", eCastingBar.delay ) )
    else
      getglobal("eCastingBar"..frame.."_Delay"):SetText("")
    end      	
    
    -- is the time left greater than channeling end time?
    if( intTimeLeft > getglobal("eCastingBar"..frame).endTime ) then
    
      -- yes, set it to the channeling end time (this will happen if you get delayed longer than the time left on channeling)
      intTimeLeft = getglobal("eCastingBar"..frame).endTime
      
    end
    
    -- are the times equal?
    if( intTimeLeft == getglobal("eCastingBar"..frame).endTime ) then
    
      -- yes, we finished channeling, so start the fadeout process and exit
      getglobal("eCastingBar"..frame).channeling = nil
      getglobal("eCastingBar"..frame).fadeOut = 1
      return
      
    end
    
    -- update the bar length
    intBarValue = getglobal("eCastingBar"..frame).startTime + ( getglobal("eCastingBar"..frame).endTime - intTimeLeft )
    getglobal("eCastingBar"..frame.."StatusBar"):SetValue( intBarValue )
    
    --reset the flash to hidden
    getglobal("eCastingBar"..frame.."Flash"):Hide( )
    
    -- updates the spark
    local width = getglobal("eCastingBar"..frame.."Background"):GetWidth()
    intSparkPosition = ( ( intBarValue - getglobal("eCastingBar"..frame).startTime ) / ( getglobal("eCastingBar"..frame).endTime - getglobal("eCastingBar"..frame).startTime ) ) * width
    getglobal("eCastingBar"..frame.."Spark"):SetPoint( "CENTER", "eCastingBar"..frame.."StatusBar", "LEFT", intSparkPosition, 0 )
    
  -- no,  is the current time < the hold time?
  elseif( GetTime( ) < getglobal("eCastingBar"..frame).holdTime ) then
  
    -- yes, exit, we aren't doing anything
    return
  
  -- no, are we in flash mode?
  elseif( getglobal("eCastingBar"..frame).flash ) then
  
    -- yes, sest the flash alpha
    local intAlpha = getglobal("eCastingBar"..frame.."Flash"):GetAlpha( ) + CASTING_BAR_FLASH_STEP
    
    -- reset the text
    getglobal("eCastingBar"..frame.."_Time"):SetText( "" )
    
    -- is the flash alpha < 1?
    if( intAlpha < 1 ) then
    
      -- yes, step it up
      getglobal("eCastingBar"..frame.."Flash"):SetAlpha( intAlpha )
      
    else
    
      -- no, which means its 1 or greater, and we are at full alpha and done.
      getglobal("eCastingBar"..frame).flash = nil
      
    end
    
  -- no, are we fading out now?
  elseif ( getglobal("eCastingBar"..frame).fadeOut ) then
  
    --yes, set the CastingBar alpha
    local intAlpha = getglobal("eCastingBar"..frame):GetAlpha( ) - CASTING_BAR_ALPHA_STEP
    
    -- is the bar alpha > 0?
    if( intAlpha > 0 ) then
    
      -- step it down
      getglobal("eCastingBar"..frame):SetAlpha( intAlpha )
      
    else
    
      -- no, which means its 0 or larger, and we are at fully transparent so we are done and hide the bar.
      getglobal("eCastingBar"..frame).fadeOut = nil
      getglobal("eCastingBar"..frame):Hide( )
      
    end
  end
end

function getFormattedNumber(number)
	if (strlen(number) < 2 ) then
		return "0"..number
	else
		return number
	end	
end

--[[ Starts moving the frame. ]]--
function eCastingBar_MouseUp( strButton, frmFrame, frameType )

	if( eCastingBar_Saved[eCastingBar_Player][frameType.."Locked"] == 0 ) then
		getglobal( frmFrame ):StopMovingOrSizing( )
    eCastingBar_Saved[eCastingBar_Player][frameType.."Left"] = getglobal(frmFrame):GetLeft()
    eCastingBar_Saved[eCastingBar_Player][frameType.."Bottom"] = getglobal(frmFrame):GetBottom()
    
    getglobal("eCastingBar"..frameType.."LeftSlider"):SetValue(eCastingBar_Saved[eCastingBar_Player][frameType.."Left"])
    getglobal("eCastingBar"..frameType.."BottomSlider"):SetValue(eCastingBar_Saved[eCastingBar_Player][frameType.."Bottom"])
	end
end

--[[ Stops moving the frame. ]]--
function eCastingBar_MouseDown( strButton, frmFrame, frameType )
	if( strButton == "LeftButton" and (eCastingBar_Saved[eCastingBar_Player][frameType.."Locked"] == 0 ) ) then
		getglobal( frmFrame ):StartMoving( )
	end
end

function eCastingBarGeneral_MouseUp( strButton, frmFrame )
		getglobal( frmFrame ):StopMovingOrSizing( )
end

--[[ Stops moving the frame. ]]--
function eCastingBarGeneral_MouseDown( strButton, frmFrame, frameType )
	if( strButton == "LeftButton") then
		getglobal( frmFrame ):StartMoving( )
	end
end

function eCastingBar_getShowDelay()
	return eCastingBar_Saved[eCastingBar_Player].ShowDelay
end

function eCastingBar_setShowDelay( intShowDelay )
	eCastingBar_Saved[eCastingBar_Player].ShowDelay = intShowDelay
end

function eCastingBar_checkBorders()

  for index, option in frameSuffixes do
    if (eCastingBar_Saved[eCastingBar_Player][option.."HideBorder"] == 1) then
      getglobal("eCastingBar"..option):SetBackdrop(nil)
    else
      getglobal("eCastingBar"..option):SetBackdrop({bgFile = CASTING_BAR_BACKGROUND_FILE, edgeFile = CASTING_BAR_EDGE_FILE, tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }}) 
      getglobal("eCastingBar"..option):SetBackdropColor(0,0,0,0.5)
    end
  end

  for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    if (eCastingBar_Saved[eCastingBar_Player].MirrorHideBorder == 1) then
      getglobal("eCastingBarMirror"..index):SetBackdrop(nil)
    else
      getglobal("eCastingBarMirror"..index):SetBackdrop({bgFile = CASTING_BAR_BACKGROUND_FILE, edgeFile = CASTING_BAR_EDGE_FILE, tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }}) 
      getglobal("eCastingBarMirror"..index):SetBackdropColor(0,0,0,0.5)
    end
  end
end

--[[-------------------------------------------
	Functions for Locked State
-------------------------------------------]]--

function eCastingBar_checkLocked()
  for index, option in frameSuffixes do
    -- only show the outline if we are enabled
    if (eCastingBar_Saved[eCastingBar_Player][option.."Enabled"] == 1 and
          eCastingBar_Saved[eCastingBar_Player][option.."Locked"] == 0) then
      getglobal("eCastingBar"..option.."_Outline"):Show()
    else
      getglobal("eCastingBar"..option.."_Outline"):Hide()
    end
  end

  for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    -- only show the outline if we are enabled
    if (eCastingBar_Saved[eCastingBar_Player].MirrorEnabled == 1 and 
          eCastingBar_Saved[eCastingBar_Player].MirrorLocked == 0) then
      getglobal("eCastingBarMirror_Outline"):Show()
    else
      getglobal("eCastingBarMirror_Outline"):Hide()
    end
  end
end


--[[-------------------------------------------
	Functions for Enabled State
-------------------------------------------]]--

--[[ Disables the frame. ]]--
function eCastingBar_Disable( fraFrame )
  eCastingBar_Saved[eCastingBar_Player][fraFrame.."Enabled"] = 0

	local intIndex = 0
	local strEvent = ""
	
	-- for each border in eCastingBar__Events register event.
  if (fraFrame == "") then  	
    for intIndex, strEvent in eCastingBar__Events do
    
      -- make sure old casting bar is registered
      eCastingBar_Register( "CastingBarFrame", strEvent )
        
      -- now unregister our casting bar
      eCastingBar_Unregister( "eCastingBar", strEvent )
      
    end
  
	-- CastTime mod exist 
    if( CastTimeFrame ) then
    
      -- for each event in eCastingBar__CastTimeEvents register event.
      for intIndex, strEvent in eCastingBar__CastTimeEvents do
      
        -- make sure CastTime mod is enabled also bar is registered
        eCastingBar_Register( "CastTimeFrame", strEvent )
        
      end

    end
  end
		
	-- is the frame unlocked?
	if( eCastingBar_Saved[eCastingBar_Player][fraFrame.."Locked"] == 0 ) then
	
		-- yes, lets hide the outline
		getglobal("eCastingBar"..fraFrame.."_Outline"):Hide( )
		
	end

  

  -- Check for FlightMap
  if (FlightMapFrame) then
    if (eCastingBar_Saved[eCastingBar_Player].FlightMapX and eCastingBar_Saved[eCastingBar_Player].FlightMapY) then
      FlightMapTimesFrame:ClearAllPoints()
      FlightMapTimesFrame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", eCastingBar_Saved[eCastingBar_Player].FlightMapX, eCastingBar_Saved[eCastingBar_Player].FlightMapY )
    end
  end
end

--[[ Enables the frame. ]]--
function eCastingBar_Enable( fraFrame )
  eCastingBar_Saved[eCastingBar_Player][fraFrame.."Enabled"] = 1

	local intIndex = 0
	local strEvent = ""
	
  if (fraFrame == "") then
    -- for each border in eCastingBar__Events register event.
    for intIndex, strEvent in eCastingBar__Events do
    
      -- make sure our bar is registered
      eCastingBar_Register( "eCastingBar", strEvent )
      
      -- now unregister blizzard bar
      eCastingBar_Unregister( "CastingBarFrame", strEvent )
      
    end
    
    -- CastTime mod exist 
    if( CastTimeFrame ) then
    
      -- for each event in eCastingBar__CastTimeEvents register event.
      for intIndex, strEvent in eCastingBar__CastTimeEvents do
      
        -- make sure CastTime mod is enabled also bar is registered
        eCastingBar_Unregister( "CastTimeFrame", strEvent )
        
      end

    end
  end
	
	-- is the frame unlocked?
	if( eCastingBar_Saved[eCastingBar_Player][fraFrame.."Locked"] == 0 ) then
	
		-- yes, lets show the outline
		getglobal("eCastingBar"..fraFrame.."_Outline"):Show( )
		
	end
end

--[[ Toggle enabled state. ]]--
function eCastingBar_checkEnabled()
  for index, option in frameSuffixes do
  	if (eCastingBar_Saved[eCastingBar_Player][option.."Enabled"] == 1) then
  		eCastingBar_Enable(option, 1)
    else
      eCastingBar_Disable(option, 0)
  	end
  end	

  for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    if (eCastingBar_Saved[eCastingBar_Player].MirrorEnabled == 1) then
  		if( eCastingBar_Saved[eCastingBar_Player].MirrorLocked == 0 ) then	
        -- yes, lets show the outline
        getglobal("eCastingBarMirror_Outline"):Show()        
      end		
    else
      if( eCastingBar_Saved[eCastingBar_Player].MirrorLocked == 0 ) then
        -- yes, lets hide the outline
        getglobal("eCastingBarMirror_Outline"):Hide()
      end
  	end
  end
end


--[[-------------------------------------------
	Functions for using the Texture 
-------------------------------------------]]--

--[[ Toggle enabled state. ]]--
function eCastingBar_checkTextures()

  for index, option in frameSuffixes do
    if ( eCastingBar_Saved[eCastingBar_Player][option.."UsePerlTexture"] == 1) then
    	getglobal("eCastingBar"..option.."Texture"):SetTexture( CASTING_BAR_PERL_TEXTURE )
    else
      getglobal("eCastingBar"..option.."Texture"):SetTexture( CASTING_BAR_DEFAULT_TEXTURE )
    end

    getglobal("eCastingBar"..option.."Texture"):SetWidth(20)
    getglobal("eCastingBar"..option.."Texture"):SetHeight(10)

  end

  for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    if ( eCastingBar_Saved[eCastingBar_Player].MirrorUsePerlTexture == 1) then
    	getglobal("eCastingBarMirror"..index.."StatusBarTexture"):SetTexture( CASTING_BAR_PERL_TEXTURE )
    else
      getglobal("eCastingBarMirror"..index.."StatusBarTexture"):SetTexture( CASTING_BAR_DEFAULT_TEXTURE )
    end

    getglobal("eCastingBarMirror"..index.."StatusBarTexture"):SetWidth(20)
    getglobal("eCastingBarMirror"..index.."StatusBarTexture"):SetHeight(10)
  end
	
end


function eCastingBar_checkTimeColors()
  local Red, Green, Blue, Alpha
  
  for index, option in frameSuffixes do
    Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player][option.."TimeColor"])
    getglobal("eCastingBar"..option.."_Time"):SetTextColor(Red,Green,Blue, Alpha )
  end

  Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player].MirrorTimeColor)

  for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    getglobal("eCastingBarMirror"..index.."StatusBar_Time"):SetTextColor(Red,Green,Blue, Alpha )
  end
end

function eCastingBar_setDelayColor()
  local Red, Green, Blue, Alpha
  Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player].DelayColor)
  eCastingBar_Delay:SetTextColor(Red,Green,Blue, Alpha )
end

--[[ sets up the flash to look cool ]]--
--	(thanks goes to kaitlin for the code used while resting). 
function eCastingBar_checkFlashBorderColors()

	local frmFrame = "eCastingBarFlash"
	local intIndex = 0
	local strBorder = ""

  local Red, Green, Blue, Alpha

  for index, option in frameSuffixes do
    Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player][option.."FlashBorderColor"])

    -- for each border in eCastingBar__FlashBorders set the color to gold.
    for intIndex, strBorder in eCastingBar__FlashBorders do
      getglobal( "eCastingBar"..option.."Flash_"..strBorder ):SetVertexColor( Red, Green, Blue, Alpha )	
    end
  end
	
  for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    Red, Green, Blue, Alpha = unpack(eCastingBar_Saved[eCastingBar_Player].MirrorFlashBorderColor)
    for intIndex, strBorder in eCastingBar__FlashBorders do
      getglobal( "eCastingBarMirror"..index.."Flash_"..strBorder ):SetVertexColor( Red, Green, Blue, Alpha )	
    end
  end
end


-- Sets the width and height of the casting bar
function eCastingBar_SetSize()
  local width, height, bottom, left, bar

  for index, option in frameSuffixes do
    -- check boundaries
    if (eCastingBar_Saved[eCastingBar_Player][option.."Width"] < CASTING_BAR_SLIDER_WIDTH_MIN) then
      width = CASTING_BAR_SLIDER_WIDTH_MIN
    elseif (eCastingBar_Saved[eCastingBar_Player][option.."Width"] > CASTING_BAR_SLIDER_WIDTH_MAX ) then
      width = CASTING_BAR_SLIDER_WIDTH_MAX
    else
      width = eCastingBar_Saved[eCastingBar_Player][option.."Width"]
    end
    
    if (eCastingBar_Saved[eCastingBar_Player][option.."Height"] > CASTING_BAR_SLIDER_HEIGHT_MAX) then
      height = CASTING_BAR_SLIDER_HEIGHT_MAX
    elseif (eCastingBar_Saved[eCastingBar_Player][option.."Height"] < CASTING_BAR_SLIDER_HEIGHT_MIN ) then
      height = CASTING_BAR_SLIDER_HEIGHT_MIN
    else
      height = eCastingBar_Saved[eCastingBar_Player][option.."Height"]
    end

    --if (eCastingBar_Saved[eCastingBar_Player][option.."Left"] < 0) then
    --  left = 0
    --else
      left = eCastingBar_Saved[eCastingBar_Player][option.."Left"]
    --end


    --if (eCastingBar_Saved[eCastingBar_Player][option.."Bottom"] < 0 ) then
    --  bottom = 0
    --else
      bottom = eCastingBar_Saved[eCastingBar_Player][option.."Bottom"]
    --end
    
    getglobal("eCastingBar"..option):SetWidth(width)
    getglobal("eCastingBar"..option):SetHeight(height)

    getglobal("eCastingBar"..option.."Background"):SetWidth(width - 9)
    getglobal("eCastingBar"..option.."Background"):SetHeight(height - 8)

    getglobal("eCastingBar"..option.."Flash"):SetWidth(width)
    getglobal("eCastingBar"..option.."Flash"):SetHeight(height)

    getglobal("eCastingBar"..option.."StatusBar"):SetWidth(width - 9)
    getglobal("eCastingBar"..option.."StatusBar"):SetHeight(height - 10)

    getglobal("eCastingBar"..option.."_Outline"):SetWidth(width)
    getglobal("eCastingBar"..option.."_Outline"):SetHeight(height)
    getglobal("eCastingBar"..option.."_Outline"):ClearAllPoints()
    getglobal("eCastingBar"..option.."_Outline"):SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", left, bottom )



    getglobal("eCastingBar"..option.."Flash_TOP"):SetWidth(width - 24)
    getglobal("eCastingBar"..option.."Flash_BOTTOM"):SetWidth(width - 24)
    getglobal("eCastingBar"..option.."Flash_LEFT"):SetHeight(height - 24)
    getglobal("eCastingBar"..option.."Flash_RIGHT"):SetHeight(height - 24)

    getglobal("eCastingBar"..option.."Spark"):SetHeight(height + 13)

    getglobal("eCastingBar"..option.."Text"):SetWidth(width - 49)
    getglobal("eCastingBar"..option.."Text"):SetHeight(height + 13)

    -- set the font size
    eCastingBarText:SetTextHeight(eCastingBar_Saved[eCastingBar_Player][option.."FontSize"])
    eCastingBar_Time:SetTextHeight(eCastingBar_Saved[eCastingBar_Player][option.."FontSize"])
  end

  for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    
    -- check boundaries
    if (eCastingBar_Saved[eCastingBar_Player].MirrorWidth < CASTING_BAR_SLIDER_WIDTH_MIN) then
      width = CASTING_BAR_SLIDER_WIDTH_MIN
    elseif (eCastingBar_Saved[eCastingBar_Player].MirrorWidth > CASTING_BAR_SLIDER_WIDTH_MAX ) then
      width = CASTING_BAR_SLIDER_WIDTH_MAX
    else
      width = eCastingBar_Saved[eCastingBar_Player].MirrorWidth
    end
    
    if (eCastingBar_Saved[eCastingBar_Player].MirrorHeight > CASTING_BAR_SLIDER_HEIGHT_MAX) then
      height = CASTING_BAR_SLIDER_HEIGHT_MAX
    elseif (eCastingBar_Saved[eCastingBar_Player].MirrorHeight < CASTING_BAR_SLIDER_HEIGHT_MIN ) then
      height = CASTING_BAR_SLIDER_HEIGHT_MIN
    else
      height = eCastingBar_Saved[eCastingBar_Player].MirrorHeight
    end

    --if (eCastingBar_Saved[eCastingBar_Player].MirrorLeft < 0) then
    --  left = 0
    --else
      left = eCastingBar_Saved[eCastingBar_Player].MirrorLeft
    --end


    --if (eCastingBar_Saved[eCastingBar_Player].MirrorBottom < 0 ) then
    --  bottom = 0
    --else
      bottom = eCastingBar_Saved[eCastingBar_Player].MirrorBottom
    --end
    
    getglobal("eCastingBarMirror"..index):SetWidth(width)
    getglobal("eCastingBarMirror"..index):SetHeight(height)

    getglobal("eCastingBarMirror"..index.."Background"):SetWidth(width - 9)
    getglobal("eCastingBarMirror"..index.."Background"):SetHeight(height - 8)

    getglobal("eCastingBarMirror"..index.."Flash"):SetWidth(width)
    getglobal("eCastingBarMirror"..index.."Flash"):SetHeight(height)

    getglobal("eCastingBarMirror"..index.."StatusBar"):SetWidth(width - 9)
    getglobal("eCastingBarMirror"..index.."StatusBar"):SetHeight(height - 10)

    getglobal("eCastingBarMirror_Outline"):SetWidth(width)
    getglobal("eCastingBarMirror_Outline"):SetHeight(height)
    getglobal("eCastingBarMirror_Outline"):ClearAllPoints()
    getglobal("eCastingBarMirror_Outline"):SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", left, bottom )


    getglobal("eCastingBarMirror"..index.."Flash_TOP"):SetWidth(width - 24)
    getglobal("eCastingBarMirror"..index.."Flash_BOTTOM"):SetWidth(width - 24)
    getglobal("eCastingBarMirror"..index.."Flash_LEFT"):SetHeight(height - 24)
    getglobal("eCastingBarMirror"..index.."Flash_RIGHT"):SetHeight(height - 24)

    getglobal("eCastingBarMirror"..index.."StatusBarSpark"):SetHeight(height + 13)

    getglobal("eCastingBarMirror"..index.."StatusBarText"):SetWidth(width - 49)
    getglobal("eCastingBarMirror"..index.."StatusBarText"):SetHeight(height + 13)

    -- set the font size
    getglobal("eCastingBarMirror"..index.."StatusBarText"):SetTextHeight(eCastingBar_Saved[eCastingBar_Player].MirrorFontSize)
    getglobal("eCastingBarMirror"..index.."StatusBar_Time"):SetTextHeight(eCastingBar_Saved[eCastingBar_Player].MirrorFontSize)
  end
end




function eCastingBar_Copy_Table(src, dest)
	for index, value in src do
		if (type(value) == "table") then
			dest[index] = {};
			eCastingBar_Copy_Table(value, dest[index]);
		else
			dest[index] = value;
		end
	end
end





------------------- MIRROR -------------------


function eCastingBarMirror_OnLoad()
	this:RegisterEvent("MIRROR_TIMER_PAUSE");
	this:RegisterEvent("MIRROR_TIMER_STOP");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this.timer = nil;
end