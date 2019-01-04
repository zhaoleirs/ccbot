local L = AceLibrary("AceLocale-2.2"):new("sRaidFrames")

-------------------------------------------------------------------------------
-- Localization                                                              --
-------------------------------------------------------------------------------

L:RegisterTranslations("zhCN", function() return {
	["hidden"] = "隐藏",
	["shown"] = "显示",
	
	["Lock"] = "锁定",
	["Lock/Unlock the raid frames"] = "锁定/解锁框体",
	["Unlocked"] = "解锁",
	["Locked"] = "锁定",
	
	["Health text"] = "血条样式",
	["Set health display type"] = "设定血条显示样式",
	["Current and max health"] = "当前与最大血量",
	["Health deficit"] = "失去血量数值",
	["Health percentage"] = "血量百分比",
	["Current health"] = "当前血量",
	["Hide health text"] = "隐藏血量",
	
	["Invert health bars"] = "反转血条",
	["Invert the growth of the health bars"] = "反转血条",

	
	["Buff filter"] = "Buff滤器",
	["Set buff filter"] = "设定Buff滤器",
	["Add buff"] = "增加buff",
	["Add a buff"] = "增加一个buff",
	["<name of buff>"] = "<buff名称>",
	
	["Show group titles"] = "显示小组/职业",
	["Toggle display of titles above each group frame"] = "显示小组/职业",
	["Member sort order"] = "队员排列方式",
	["Select how you wish to sort the members of each group"] = "选择如何排列你的队友",
	["By name"] = "根据姓名",
	["By class"] = "根据职业",
	["Blizzard default"] = "Blizzard默认",
	["Group by"] = "分组方式",
	["Select how you wish to show the groups"] = "选择你希望显示的小队",
	["By group"] = "根据小队",
	["By class"] = "根据职业",
	
	["Buff/Debuff visibility"] = "Buff/Debuff显示选项",
	["Show buffs or debuffs on the raid frames"] = "选择显示的buff或debuff",
	["Only buffs"] = "只显示buff",
	["Only debuffs"] = "只显示debuff",
	["Buffs if not debuffed"] = "自定义buff显示",
	["Power type visiblity"] = "能量显示选项",
	["Toggle the display of certain power types (Mana, Rage, Energy)"] = "显示特定的能量种类(魔法, 怒气, 能量)",
	["Mana"] = "魔法值",
	["Toggle the display of mana bars"] = "显示魔法值",
	["Energy & Focus"] = "能量值",
	["Toggle the display of energy and focus bars"] = "显示能量值",
	["Rage"] = "怒气",
	["Toggle the display of rage bars"] = "显示怒气值",
	["Filter dispellable debuffs"] = "debuff滤器",
	["Toggle display of dispellable debuffs only"] = "只显示可驱散的debuff",
	
	["Bar textures"] = "框体材质",
	["Set the texture used on health and mana bars"] = "设定血量/魔法条材质",
	["Default"] = "Default",
	["Smooth"] = "Smooth",
	["Striped"] = "Striped",
	["Blizzard"] = "Blizzard",
	["BantoBar"] = "BantoBar",
	
	["Scale"] = "缩放",
	["Set the scale of the raid frames"] = "缩放框体",
	["Layout"] = "布局",
	["Set the layout of the raid frames"] = "设定整体的布局",
	["Reset layout"] = "重置为默认布局",
	["Reset the position of sRaidFrames"] = "重置sRaidFrames为默认布局",
	["Predefined Layout"] = "预设布局",
	["Set a predefined layout for the raid frames"] = "设定整体布局为预设布局",
	["CT_RaidAssist"] = "CTRA布局",
	["Horizontal"] = "水平布局",
	["Vertical"] = "垂直布局",
	
	["Background color"] = "背景颜色",
	["Change the background color"] = "改变背景颜色",
	["Border color"] = "边框颜色",
	["Change the border color"] = "改变边框颜色",
	["Tooltip display"] = "显示帮助提示",
	["Determine when a tooltip is displayed"] = "选择是否显示帮助提示",
	["Never"] = "从不",
	["Only when not in combat"] = "非战斗状态显示",
	["Always"] = "总是显示",
	
	["Highlight units with aggro"] = "高亮仇恨目标",
	["Turn the border of units who have aggro red"] = "仇恨目标会用红色闪现",
	["Range"] = "距离设置",
	["Set about range"] = "距离设置",
	["Enable range check"] = "开启距离检查",
	["Enable range checking"] = "允许距离检查",
	
	["Alpha"] = "透明度",
	["The alpha level for units who are out of range"] = "设定超出距离单位的透明度",
	["Frequency"] = "检测时间间隔(s)",
	["The interval between which range checks are performed"] = "每次检查之间的时间间隔",
	
	["Show Group/Class"] = "显示的小队/职业",
	["Toggle the display of certain Groups/Classes"] = "显示小队/职业滤器",
	["Classes"] = "职业",
	["Warriors"] = "战士",
	["Toggle the display of Warriors"] = "显示战士框体",
	["Paladins"] = "圣骑士",
	["Toggle the display of Paladins"] = "显示圣骑士框体",
	["Shamans"] = "萨满祭司",
	["Toggle the display of Shamans"] = "显示萨满祭司框体",
	["Hunters"] = "猎人",
	["Toggle the display of Hunters"] = "显示猎人框体",
	["Warlocks"] = "术士",
	["Toggle the display of Warlocks"] = "显示术士框体",
	["Mages"] = "魔法师",
	["Toggle the display of Mages"] = "显示魔法师框体",
	["Druids"] = "德鲁伊",
	["Toggle the display of Druids"] = "显示德鲁伊框体",
	["Rogues"] = "盗贼",
	["Toggle the display of Rogues"] = "显示盗贼框体",
	["Priests"] = "牧师",
	["Toggle the display of Priests"] = "显示牧师框体",
	
	["Groups"] = "小队",
	["Group 1"] = "小队 1",
	["Toggle the display of Group 1"] = "显示小队 1",
	["Group 2"] = "小队 2",
	["Toggle the display of Group 2"] = "显示小队 2",
	["Group 3"] = "小队 3",
	["Toggle the display of Group 3"] = "显示小队 3",
	["Group 4"] = "小队 4",
	["Toggle the display of Group 4"] = "显示小队 4",
	["Group 5"] = "小队 5",
	["Toggle the display of Group 5"] = "显示小队 5",
	["Group 6"] = "小队 6",
	["Toggle the display of Group 6"] = "显示小队 6",
	["Group 7"] = "小队 7",
	["Toggle the display of Group 7"] = "显示小队 7",
	["Group 8"] = "小队 8",
	["Toggle the display of Group 8"] = "显示小队 8",
	
	["Growth"] = "增长方向",
	["Set the growth of the raid frames"] = "设置框体的增长方向",
	["Up"] = "上",
	["Down"] = "下",
	["Left"] = "左",
	["Right"] = "右",
	
	["Border"] = "边框",
	["Toggle the display of borders around the raid frames"] = "显示各小组的边框",
	["Frame Spacing"] = "框体间距",
	["Set the spacing between each of the raid frames"] = "设定各组间框体间距",
	
	["Offline"] = "离线",
	["Released"] = "灵魂状态",
	["Dead"] = "死亡",
	["Feign Death"] = "假死",
	["Unknown"] = "未知",
	
	["Warrior"] = "战士",
	["Mage"] = "魔法师",
	["Paladin"] = "圣骑士",
	["Shaman"] = "萨满祭司",
	["Druid"] = "德鲁伊",
	["Hunter"] = "猎人",
	["Rogue"] = "盗贼",
	["Warlock"] = "术士",
	["Priest"] = "牧师",

	["Intervened"] = "被干涉",
	["Innervating"] = "激活中",
	["Spirit"] = "救赎之魂",
	["Shield Wall"] = "盾墙",
	["Last stand"] = "破釜沉舟",
	["Gift of Life"] = "生命赐福",
	["Ice block"] = "寒冰屏障",
	["Vanished"] = "消失",
	["Stealthed"] = "潜行",
	["Infused"] = "能量灌注中",
	["Fear Ward"] = "防护恐惧结界",
} end)
