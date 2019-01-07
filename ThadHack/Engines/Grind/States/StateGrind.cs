﻿using System.Collections.Generic;
using ZzukBot.FSM;
using ZzukBot.Helpers;
using ZzukBot.Ingame;
using ZzukBot.Mem;
using ZzukBot.Objects;
using ZzukBot.Settings;

namespace ZzukBot.Engines.Grind.States
{
    internal class StateGrind : State
    {
        internal override int Priority => 22;

        private WoWGameObject gather;
        internal override bool NeedToRun {
            get {
                if (Options.Mine) {
                    gather = Grinder.Access.Info.Target.NextGrind(Constants.Enums.GatherType.Mining);
                    if (gather != null) return true;
                }
                if (Options.Herb) {
                    gather = Grinder.Access.Info.Target.NextGrind(Constants.Enums.GatherType.Herbalism);
                    if (gather != null) return true;
                }
                return false;
            }
        } 

        internal override string Name => "Herb|Mine";
        private ulong LastGrindId;

        internal override void Run()
        {
            var dis = gather.Distance3DTo(ObjectManager.Player);
            if (dis < 1.3)
            {
                
                if (LastGrindId != gather.Guid)
                {
                    ObjectManager.Player.CtmStopMovement();
                }
                if (LastGrindId != gather.Guid||Wait.ForOrAdd("LootGrind", 4500))
                {
                    if (LastGrindId != gather.Guid)
                    {
                        Wait.Remove("LootGrindOut");
                        LastGrindId = gather.Guid;
                    }
                    ObjectManager.Player.RightClick(gather);
                }
                if (Wait.For("LootGrindOut", 4500 * 10))
                {
                    Grinder.Access.Info.Loot.AddToLootBlacklist(gather.Guid);
                }
                Wait.Remove("LootGrindMoving");
            }
            else
            {
                if (dis <= 7) {
                    if (ObjectManager.Player.IsMounted)
                    {
                        Lua.RunInMainthread(Constants.Strings.Dis_Mounted);
                    }
                }
                Wait.Remove("LootGrind");
                Wait.Remove("LootGrindOut");
                if (Wait.For("LootGrindMoving", 25000))
                {
                    Grinder.Access.Info.Loot.AddToLootBlacklist(gather.Guid);
                    return;
                }
                var it = Grinder.Access.Info.PathToUnit.ToUnit(gather);
                if (it.Item1)
                {
                    ObjectManager.Player.CtmTo(it.Item2);
                }
            }
        }
    }
}