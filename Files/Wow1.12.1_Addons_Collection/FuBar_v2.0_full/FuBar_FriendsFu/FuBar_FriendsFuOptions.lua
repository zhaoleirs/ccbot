local L = AceLibrary("AceLocale-2.0"):new("FuBar_FriendsFu")

local opts = {
	type = "group", args = {
		["text"] = {
			type = "group", name = L["Text"], desc = L["Text Settings"], args = {
				["show_displayed"] = {
					type = "toggle", name = L["Show Displayed"], desc = L["Toggles display of number of unfiltered friends"],
					get = function() return FuBar_FriendsFu.db.profile.text.show_displayed end,
					set = function(v) FuBar_FriendsFu.db.profile.text.show_displayed = v; FuBar_FriendsFu:UpdateText() end,
					order = 1,
				},
				["show_online"] = {
					type = "toggle", name = L["Show Online"], desc = L["Toggles display of number of online friends"],
					get = function() return FuBar_FriendsFu.db.profile.text.show_online end,
					set = function(v) FuBar_FriendsFu.db.profile.text.show_online = v; FuBar_FriendsFu:UpdateText() end,
					order = 2,
				},
				["show_total"] = {
					type = "toggle", name = L["Show Total"], desc = L["Toggles display of number of total friends known"],
					get = function() return FuBar_FriendsFu.db.profile.text.show_total end,
					set = function(v) FuBar_FriendsFu.db.profile.text.show_total = v; FuBar_FriendsFu:UpdateText() end,
					order = 3,
				},
			}, order = 1,
		},
		["tooltip"] = {
			type = "group", name = L["Tooltip"], desc = L["Tooltip Settings"], args = {
				["sort"] = {
					type = "text", name = L["Sort"], desc = L["Sets sorting"],
					get = function() return FuBar_FriendsFu.db.profile.tooltip.sort end,
					set = function(v) FuBar_FriendsFu.db.profile.tooltip.sort = v; FuBar_FriendsFu:Update() end,
					validate = {["NAME"] = L["Name"], ["CLASS"] = L["Class"], ["LEVEL"] = L["Level"], ["ZONE"] = L["Zone"]},
					order = 1,
				},
				["group"] = {
					type = "group", name = L["Group"], desc = L["Group Indicator Settings"], args = {
						["show"] = {
							type = "toggle", name = L["Show"], desc = L["Toggles display of group indicators"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.group_show end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.group_show = v; FuBar_FriendsFu:UpdateTooltip() end,
							order = 1,
						},
					}, order = 2,
				},
				["name"] = {
					type = "group", name = L["Name"], desc = L["Name Column Settings"], args = {
						["color"] = {
							type = "text", name = L["Color"], desc = L["Sets color of name column"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.name_color end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.name_color = v; FuBar_FriendsFu:UpdateTooltip() end,
							validate = {["NONE"] = L["None"], ["CLASS"] = L["Class"]},
							order = 1,
						},
						["status"] = {
							type = "toggle", name = L["Status"], desc = L["Toggles display of status"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.name_status end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.name_status = v; FuBar_FriendsFu:UpdateTooltip() end,
							order = 2,
						},
					}, order = 3,
				},
				["class"] = {
					type = "group", name = L["Class"], desc = L["Class Column Settings"], args = {
						["show"] = {
							type = "toggle", name = L["Show"], desc = L["Toggles display of class column"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.class_show end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.class_show = v; FuBar_FriendsFu:UpdateTooltip() end,
							order = 1,
						},
						["align"] = {
							type = "text", name = L["Align"], desc = L["Sets alignment of class column"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.class_align end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.class_align = v; FuBar_FriendsFu:UpdateTooltip() end,
							validate = {["LEFT"] = L["Left"], ["CENTER"] = L["Center"], ["RIGHT"] = L["Right"]},
							order = 2,
						},
					}, order = 4,
				},
				["level"] = {
					type = "group", name = L["Level"], desc = L["Level Column Settings"], args = {
						["show"] = {
							type = "toggle", name = L["Show"], desc = L["Toggles display of level column"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.level_show end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.level_show = v; FuBar_FriendsFu:UpdateTooltip() end,
							order = 1,
						},
						["align"] = {
							type = "text", name = L["Align"], desc = L["Sets alignment of level column"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.level_align end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.level_align = v; FuBar_FriendsFu:UpdateTooltip() end,
							validate = {["LEFT"] = L["Left"], ["CENTER"] = L["Center"], ["RIGHT"] = L["Right"]},
							order = 2,
						},
						["color"] = {
							type = "text", name = L["Color"], desc = L["Sets color of level column"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.level_color end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.level_color = v; FuBar_FriendsFu:UpdateTooltip() end,
							validate = {["NONE"] = L["None"], ["RELATIVE"] = L["Relative"]},
							order = 3,
						},
					}, order = 5,
				},
				["zone"] = {
					type = "group", name = L["Zone"], desc = L["Zone Column Settings"], args = {
						["show"] = {
							type = "toggle", name = L["Show"], desc = L["Toggles display of zone column"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.zone_show end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.zone_show = v; FuBar_FriendsFu:UpdateTooltip() end,
							order = 1,
						},
						["align"] = {
							type = "text", name = L["Align"], desc = L["Sets alignment of zone column"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.zone_align end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.zone_align = v; FuBar_FriendsFu:UpdateTooltip() end,
							validate = {["LEFT"] = L["Left"], ["CENTER"] = L["Center"], ["RIGHT"] = L["Right"]},
							order = 2,
						},
						["color"] = {
							type = "text", name = L["Color"], desc = L["Sets color of zone column"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.zone_color end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.zone_color = v; FuBar_FriendsFu:UpdateTooltip() end,
							validate = {["NONE"] = L["None"], ["FACTION"] = L["Faction"], ["LEVEL"] = L["Level"]},
							order = 3,
						},
					}, order = 6,
				},
				["notes"] = {
					type = "group", name = L["Notes"], desc = L["Notes Column Settings"], args = {
						["show_auldlangsyne"] = {
							type = "toggle", name = L["Show AuldLangSyne"], desc = L["Toggles display of AuldLangSyne notes"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.note_showauldlangsyne end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.note_showauldlangsyne = v; FuBar_FriendsFu:UpdateTooltip() end,
							hidden = not IsAddOnLoaded("AuldLangSyne"),
							order = 1,
						},
						["show_ctplayernotes"] = {
							type = "toggle", name = L["Show CT_PlayerNotes"], desc = L["Toggles display of CT_PlayerNotes notes"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.note_showctplayernotes end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.note_showctplayernotes = v; FuBar_FriendsFu:UpdateTooltip() end,
							hidden = not IsAddOnLoaded("CT_PlayerNotes"),
							order = 2,
						},
						["align"] = {
							type = "text", name = L["Align"], desc = L["Sets alignment of notes column"],
							get = function() return FuBar_FriendsFu.db.profile.tooltip.note_align end,
							set = function(v) FuBar_FriendsFu.db.profile.tooltip.note_align = v; FuBar_FriendsFu:UpdateTooltip() end,
							validate = {["LEFT"] = L["Left"], ["CENTER"] = L["Center"], ["RIGHT"] = L["Right"]},
							order = 3,
						},
					}, order = 7, hidden = not (IsAddOnLoaded("AuldLangSyne") or IsAddOnLoaded("CT_PlayerNotes")),
				},
			}, order = 2,
		},
		["filter"] = {
			type = "group", name = L["Filter"], desc = L["Filter Settings"], args = {
				["class"] = {
					type = "group", name = L["Class"], desc = L["Class Filter Settings"], args = {
						["druid"] = {
							type = "toggle", name = L["Druid"], desc = L["Toggles display of Druids"],
							get = function() return FuBar_FriendsFu.db.profile.filter.class_druid end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.class_druid = v; FuBar_FriendsFu:Update() end,
							order = 1,
						},
						["hunter"] = {
							type = "toggle", name = L["Hunter"], desc = L["Toggles display of Hunters"],
							get = function() return FuBar_FriendsFu.db.profile.filter.class_hunter end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.class_hunter = v; FuBar_FriendsFu:Update() end,
							order = 2,
						},
						["mage"] = {
							type = "toggle", name = L["Mage"], desc = L["Toggles display of Mages"],
							get = function() return FuBar_FriendsFu.db.profile.filter.class_mage end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.class_mage = v; FuBar_FriendsFu:Update() end,
							order = 3,
						},
						["paladin"] = {
							type = "toggle", name = L["Paladin"], desc = L["Toggles display of Paladins"],
							get = function() return FuBar_FriendsFu.db.profile.filter.class_paladin end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.class_paladin = v; FuBar_FriendsFu:Update() end,
							order = 4,
						},
						["priest"] = {
							type = "toggle", name = L["Priest"], desc = L["Toggles display of Priests"],
							get = function() return FuBar_FriendsFu.db.profile.filter.class_priest end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.class_priest = v; FuBar_FriendsFu:Update() end,
							order = 5,
						},
						["rogue"] = {
							type = "toggle", name = L["Rogue"], desc = L["Toggles display of Rogues"],
							get = function() return FuBar_FriendsFu.db.profile.filter.class_rogue end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.class_rogue = v; FuBar_FriendsFu:Update() end,
							order = 6,
						},
						["shaman"] = {
							type = "toggle", name = L["Shaman"], desc = L["Toggles display of Shamans"],
							get = function() return FuBar_FriendsFu.db.profile.filter.class_shaman end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.class_shaman = v; FuBar_FriendsFu:Update() end,
							order = 7,
						},
						["warlock"] = {
							type = "toggle", name = L["Warlock"], desc = L["Toggles display of Warlocks"],
							get = function() return FuBar_FriendsFu.db.profile.filter.class_warlock end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.class_warlock = v; FuBar_FriendsFu:Update() end,
							order = 8,
						},
						["warrior"] = {
							type = "toggle", name = L["Warrior"], desc = L["Toggles display of Warriors"],
							get = function() return FuBar_FriendsFu.db.profile.filter.class_warrior end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.class_warrior = v; FuBar_FriendsFu:Update() end,
							order = 9,
						},
					}, order = 1,
				},
				["level"] = {
					type = "group", name = L["Level"], desc = L["Level Filter Settings"], args = {
						["0109"] = {
							type = "toggle", name = L[" 1- 9"], desc = L["Toggles display of level 1 to 9 chars"],
							get = function() return FuBar_FriendsFu.db.profile.filter.level_0109 end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.level_0109 = v; FuBar_FriendsFu:Update() end,
							order = 1,
						},
						["1019"] = {
							type = "toggle", name = L["10-19"], desc = L["Toggles display of level 10 to 19 chars"],
							get = function() return FuBar_FriendsFu.db.profile.filter.level_1019 end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.level_1019 = v; FuBar_FriendsFu:Update() end,
							order = 2,
						},
						["2029"] = {
							type = "toggle", name = L["20-29"], desc = L["Toggles display of level 20 to 29 chars"],
							get = function() return FuBar_FriendsFu.db.profile.filter.level_2029 end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.level_2029 = v; FuBar_FriendsFu:Update() end,
							order = 3,
						},
						["3039"] = {
							type = "toggle", name = L["30-39"], desc = L["Toggles display of level 30 to 39 chars"],
							get = function() return FuBar_FriendsFu.db.profile.filter.level_3039 end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.level_3039 = v; FuBar_FriendsFu:Update() end,
							order = 4,
						},
						["4049"] = {
							type = "toggle", name = L["40-49"], desc = L["Toggles display of level 40 to 49 chars"],
							get = function() return FuBar_FriendsFu.db.profile.filter.level_4049 end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.level_4049 = v; FuBar_FriendsFu:Update() end,
							order = 5,
						},
						["5059"] = {
							type = "toggle", name = L["50-59"], desc = L["Toggles display of level 50 to 59 chars"],
							get = function() return FuBar_FriendsFu.db.profile.filter.level_5059 end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.level_5059 = v; FuBar_FriendsFu:Update() end,
							order = 6,
						},
						["60"] = {
							type = "toggle", name = L["60"], desc = L["Toggles display of level 60 chars"],
							get = function() return FuBar_FriendsFu.db.profile.filter.level_60 end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.level_60 = v; FuBar_FriendsFu:Update() end,
							order = 7,
						},
					}, order = 2,
				},
				["zone"] = {
					type = "group", name = L["Zone"], desc = L["Zone Filter Settings"], args = {
						["battleground"] = {
							type = "toggle", name = L["In Battleground"], desc = L["Toggles display of chars in battlegrounds"],
							get = function() return FuBar_FriendsFu.db.profile.filter.zone_bg end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.zone_bg = v; FuBar_FriendsFu:Update() end,
							order = 1,
						},
						["instance"] = {
							type = "toggle", name = L["In Instance"], desc = L["Toggles display of chars in instances"],
							get = function() return FuBar_FriendsFu.db.profile.filter.zone_inst end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.zone_inst = v; FuBar_FriendsFu:Update() end,
							order = 2,
						},
						["open_field"] = {
							type = "toggle", name = L["In Open Field"], desc = L["Toggles display of chars in open field"],
							get = function() return FuBar_FriendsFu.db.profile.filter.zone_open end,
							set = function(v) FuBar_FriendsFu.db.profile.filter.zone_open = v; FuBar_FriendsFu:Update() end,
							order = 3,
						},
					}, order = 3,
				},
			}, order = 3,
		},
	},
}

FuBar_FriendsFu:RegisterChatCommand({"/friendsfu"}, opts)
FuBar_FriendsFu.OnMenuRequest = opts
