using ZzukBot.Engines.Party;
using ZzukBot.FSM;
using ZzukBot.Mem;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateLoadNextWaypoint : StateLoadNextWaypoint
    {

        internal override bool NeedToRun => PartyAssist.Local.isLeader && PartyAssist.InSignAll() && base.NeedToRun;
    }
}