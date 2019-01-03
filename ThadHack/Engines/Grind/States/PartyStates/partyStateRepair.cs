using ZzukBot.Engines.Party;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateRepair : StateRepair
    {
        internal override bool NeedToRun => Grinder.Access.Info.Vendor.NeedToVendorParty;
         internal override bool GroupCondition() {
            return PartyAssist.Local.isLeader;
        }
    }
}