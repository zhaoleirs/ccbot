using ZzukBot.Engines.Party;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateFindTarget : StateFindTarget
    {

        internal override bool NeedToRun => PartyAssist.Local.isLeader && PartyAssist.InSignAll() && base.NeedToRun;

    }
}