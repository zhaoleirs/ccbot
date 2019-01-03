using ZzukBot.Engines.Party;
namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateBuff : StateBuff
    {
        internal override bool NeedToRun => PartyAssist.InSignAll() && base.NeedToRun;
    }
}