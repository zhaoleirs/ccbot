using System;
using ZzukBot.Engines.CustomClass;
using ZzukBot.Engines.Party;
using ZzukBot.FSM;
using ZzukBot.Helpers;
using ZzukBot.Mem;
using ZzukBot.Objects;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateApproachTarget : StateApproachTarget
    {
        internal override bool NeedToRun => base.NeedToRun && (ObjectManager.Player.IsInCombat || (!PartyAssist.Resting && PartyAssist.InSignAll()));
    }
}