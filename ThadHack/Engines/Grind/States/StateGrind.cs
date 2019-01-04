using System.Collections.Generic;
using ZzukBot.FSM;
using ZzukBot.Helpers;
using ZzukBot.Ingame;
using ZzukBot.Mem;

namespace ZzukBot.Engines.Grind.States
{
    internal class StateGrind : State
    {
        internal override int Priority => 22;

        internal override bool NeedToRun => Grinder.Access.Info.Target.NextGrind != null;

        internal override string Name => "Herb|Mine";
        private ulong LastGrindId;

        internal override void Run()
        {
            var grind = Grinder.Access.Info.Target.NextGrind;
            var dis = grind.Distance3DTo(ObjectManager.Player);
            if (dis < 5)
            {
                if (LastGrindId != grind.Guid)
                {
                    ObjectManager.Player.CtmStopMovement();
                }
                if (Wait.ForOrAdd("LootGrind", 3600))
                {
                    if (LastGrindId != grind.Guid)
                    {
                        Wait.Remove("LootGrindOut");
                        LastGrindId = grind.Guid;
                    }
                    ObjectManager.Player.RightClick(grind);
                }
                if (Wait.For("LootGrindOut", 3600 * 10))
                {
                    Grinder.Access.Info.Loot.AddToLootBlacklist(grind.Guid);
                }
            }
            else
            {
                Wait.Remove("LootGrind");
                Wait.Remove("LootGrindOut");
                var it = Grinder.Access.Info.PathToUnit.ToUnit(grind);
                if (it.Item1)
                {
                    ObjectManager.Player.CtmTo(it.Item2);
                }
            }
        }
    }
}