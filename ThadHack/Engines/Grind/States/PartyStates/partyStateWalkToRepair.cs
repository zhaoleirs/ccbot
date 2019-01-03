using System;
using ZzukBot.Engines.Party;
using ZzukBot.FSM;
using ZzukBot.Helpers;
using ZzukBot.Mem;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateWalkToRepair : StateWalkToRepair
    {

        internal override bool NeedToRun => (PartyAssist.InSignAll()||!PartyAssist.Local.isLeader) &&base.NeedToRun;

    }
}