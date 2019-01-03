using System;
using ZzukBot.Constants;
using ZzukBot.Engines.Party;
using ZzukBot.FSM;
using ZzukBot.GUI_Forms;
using ZzukBot.Helpers;
using ZzukBot.Ingame;
using ZzukBot.Mem;
using ZzukBot.Settings;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateWalk : StateWalk
    {
        internal override bool NeedToRun => isMoving() && base.NeedToRun;
        internal override bool GroupCondition()
        {
            return !PartyAssist.Local.isLeader;
        }
        private bool isMoving()
        {
            if (PartyAssist.Resting) return false;
            if (PartyAssist.Local.isLeader)
            {
                return PartyAssist.InSignAll();
            }
            else
            {
                float distance = Calc.Distance2D(ObjectManager.Player.Position, PartyAssist.Leader.Postion);
                var pRet = distance > Options.Party.LeaderDistance;
                return pRet;
            }
        }

        internal override void Run()
        {
            Shared.RandomJump();

            if (!PartyAssist.Local.isLeader)
            {
                var tu = Grinder.Access.Info.PathToPosition.ToPos(PartyAssist.Leader.Postion);
                ObjectManager.Player.CtmTo(tu);
            }
            else
            {
                base.Run();
            }
        }
    }
}