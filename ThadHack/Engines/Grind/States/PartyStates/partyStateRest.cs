using ZzukBot.Engines.CustomClass;
using ZzukBot.Engines.Party;
using ZzukBot.Mem;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateRest : StateRest
    {
        internal override bool NeedToRun => !PartyAssist.IsInCombat && base.NeedToRun;
    }
}