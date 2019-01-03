using System;
using ZzukBot.Engines.Party;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateAfterFightToPath : StateAfterFightToPath
    {
        internal override bool NeedToRun => PartyAssist.Local.isLeader&&PartyAssist.InSignAll() && base.NeedToRun;
    }
}