using ZzukBot.Engines.CustomClass;
using ZzukBot.Engines.Party;
using ZzukBot.Mem;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateMounted : StateMounted
    {
        internal override bool NeedToRun
        {
            get
            {
                if (PartyAssist.IsInCombat || ObjectManager.Player.IsMounted) {
                    PartyAssist.Local.ReportMounted = false;
                }
                bool mounted= !PartyAssist.IsInCombat && PartyAssist.Mounted;
                if (mounted&&PartyAssist.Local.isLeader) {
                    PartyAssist.Local.Report(7);
                }
                return mounted;
            }
        }

    }
}