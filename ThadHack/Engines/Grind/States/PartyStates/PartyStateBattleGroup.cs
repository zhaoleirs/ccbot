using ZzukBot.FSM;
using ZzukBot.Mem;
using System.Linq;
using ZzukBot.Settings;
using ZzukBot.Constants;
using System;
using ZzukBot.Engines.Party;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateBattleGroup : StateBattleGroup
    {
        internal override void JoinButtonTap()
        {
            Functions.DoString("BattlefieldFrameGroupJoinButton: Click()");
        }

        internal override bool PartyCondition()
        {
            return PartyAssist.Local.isLeader;
        }
    }
}