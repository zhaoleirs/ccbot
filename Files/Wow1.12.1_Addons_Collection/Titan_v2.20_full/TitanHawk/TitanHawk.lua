--[[

	Titan Hawk: 
		copyright 2005 by Stephen Blaising

	- Displays Item Counts.
	
	Version: 1.11.00-0

]]

SFBTITANHAWK_ADDONNAME 	= "Titan Hawk";
SFBTITANHAWK_TITANID 	= "TitanHawk";
SFBTITANHAWK_VERSION 	= "1.11.00-0";
SFBTITANHAWK_FREQUENCY  = 1;

local Orig_SFBItemsDisplay_MakeMenu; 
function TitanPanelTitanHawkButton_OnLoad()

	this.registry = { 
		id = SFBTITANHAWK_TITANID,
		version = SFBTITANHAWK_VERSION,
		menuText = SFBTITANHAWK_ADDONNAME, 
		tooltipTitle = SFBTITANHAWK_ADDONNAME
	};
	
	Orig_SFBItemsDisplay_MakeMenu = SFBItemsDisplay_MakeMenu;
	SFBItemsDisplay_MakeMenu = SFBTitanHawk_MakeMenu;
	
	SFBTitanHawk_ArbStandAlone();
	
	SFBItemsDisplay_Print(SFBTITANHAWK_ADDONNAME.." v"..SFBTITANHAWK_VERSION.." "..SFBITEMS_LOADED);
end

function SFBTitanHawk_MakeMenu()
	local cursorX, cursorY = GetCursorPosition();
	SFBDisplayItems_ToggleDropDownMenuUpdate_ToggleDropDownMenu(1, this:GetName(), getglobal("SFBTitanHawk_DropDown"), "UIParent", cursorX, cursorY);
end

function SFBTitanHawk_DropDown_OnLoad()
	UIDropDownMenu_Initialize(this, SFBTitanHawk_DropDown_Initialize, "MENU");
end

function SFBTitanHawk_DropDown_Initialize(level)

	if (level == nil) then
		level = 1;
	end
	
	if (level == 1) then


		local info = {};
		info.text = "- |cff0080ff"..SFBTITANHAWK_ADDONNAME.." "..SFBITEMS_DISPLAYOPTIONS.."|r -";
		info.notClickable = 1;
		info.isTitle = 1;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info);
		
		--[[
		local info = {};
		info.text = SFBITEMS_FORCESTANDALONE;
		if ( SFBInventoryHawk_Player["standalone"] == 1 ) then
			info.checked = 1;
		end
		info.func = SFBTitanHawk_ToggleStandAlone;
		info.keepShownOnClick = 1;
		UIDropDownMenu_AddButton(info);
		]]
		
		TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, SFBTITANHAWK_TITANID, TITAN_PANEL_MENU_FUNC_HIDE);
		
		
	end
	
	SFBItemsDisplay_DropDown_Initialize(level);
end

function SFBTitanHawk_ToggleStandAlone()
	SFBItemsDisplay_TogglePlayerArrayVar("standalone");
	SFBTitanHawk_ArbStandAlone();
	SFBItemsDisplay_CheckStandalone();
	SFBItemsDisplay_CountItems();
	
end 

function SFBTitanHawk_ArbStandAlone()
	--[[
	if ( SFBInventoryHawk_Player["standalone"] == 1 )then
		-- TitanPanel_RemoveButton(SFBTITANHAWK_TITANID);
		TitanPanelTitanHawkButton_OnShow();
		SFBItemsDisplay_MainFrame = "SFBItemsFrame";
		SFBItemsDisplay_UIParent = "UIParent";
		SFBItemsFrame:ClearAllPoints();
	  	SFBItemsFrame:SetPoint("TOP", "UIParent", "TOP", 0,-20 );
		SFBItemsDisplay_ESNormSetPoint = -2;
		SFBItemsDisplay_ESElseSetPoint = 2;
		SFBItemsDisplay_MainYPoint = 0;
		SFBItemsBackdropFrame:SetAlpha(SFBInventoryHawk_Player["titlebuttonalpha"]);
	else
	]]
		
		SFBItemsDisplay_MainFrame = "TitanPanelTitanHawkButton";
		SFBItemsDisplay_UIParent = "UIParent";
		SFBItemsDisplay_ESNormSetPoint = -5;
		SFBItemsDisplay_ESElseSetPoint = 5;
		SFBItemsDisplay_MainYPoint = 3;
		SFBInventoryHawkButton:SetFrameStrata("FULLSCREEN");
		SFBInventoryHawkButton:SetFrameLevel(999);
		SFBItemsBackdropFrame:SetAlpha(0.0);
		IWMoneyDisplayButton:SetFrameStrata("FULLSCREEN");
		IWMoneyDisplayButton:SetFrameLevel(999);
	-- end	
	
end


function TitanPanelTitanHawkButton_OnShow()
	SFBItemsDisplay_Enabled = true;
	SFBInventoryHawkButtonText:Show();
	SFBInventoryHawkButton:Show();
	SFBItemsBackdropFrame:Show();
	IWEmptySlotsTextButton:Show();
	SFBItemsDisplay_CheckStandalone();
	
end

function TitanPanelTitanHawkButton_OnHide()
	SFBItemsDisplay_Enabled = false;
	SFBInventoryHawkButtonText:Hide();
	SFBInventoryHawkButton:Hide();
	SFBItemsBackdropFrame:Hide();
	IWEmptySlotsTextButton:Hide();
	

end

