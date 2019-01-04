using ZzukBot.FSM;
using ZzukBot.Helpers;
using ZzukBot.Mem;

namespace ZzukBot.Engines.Grind.States
{
    internal class StateReleaseSpirit : State
    {
        internal override int Priority => 55;

        internal override bool NeedToRun => ObjectManager.Player.IsDead;

        internal override string Name => "Releasing Spirit";

        internal override void Run()
        {
            if (!Wait.For("ReleasingSpirit", 1250)) return;
            ObjectManager.Player.CtmStopMovement();
            Wait.Remove("StartGhostWalk");
            Lua.RunInMainthread("RepopMe()");
            Grinder.Access.Info.SpiritWalk.GeneratePath = true;
        }
    }
}