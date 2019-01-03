using ZzukBot.Engines.Party;
using ZzukBot.FSM;
using ZzukBot.Settings;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateLoadNextHotspot : StateLoadNextHotspot
    {

        internal override bool NeedToRun => PartyAssist.Local.isLeader&&PartyAssist.InSignAll()&&base.NeedToRun;
    }
}