using System.Collections.Generic;
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
            if (dis < 5)
            {
                if (LastGrindId != gather.Guid)
                {
                    ObjectManager.Player.CtmStopMovement();
                }
                if (Wait.ForOrAdd("LootGrind", 3600))
                {
                    if (LastGrindId != gather.Guid)
                    {
                        Wait.Remove("LootGrindOut");
                        LastGrindId = gather.Guid;
                    }
                    ObjectManager.Player.RightClick(gather);
                }
                if (Wait.For("LootGrindOut", 3600 * 10))
                {
                    Grinder.Access.Info.Loot.AddToLootBlacklist(gather.Guid);
                }
            }
            else
            {
                Wait.Remove("LootGrind");
                Wait.Remove("LootGrindOut");
                var it = Grinder.Access.Info.PathToUnit.ToUnit(gather);
                if (it.Item1)
                {
                    ObjectManager.Player.CtmTo(it.Item2);
                }
            }
        }
    }
}