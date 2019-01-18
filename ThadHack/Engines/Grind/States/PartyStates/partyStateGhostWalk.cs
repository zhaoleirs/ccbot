using System;
using System.Collections.Generic;
using ZzukBot.AntiWarden;
using ZzukBot.Constants;
using ZzukBot.Engines.Grind.Info.Path.Base;
using ZzukBot.Engines.Party;
using ZzukBot.FSM;
using ZzukBot.GUI_Forms;
using ZzukBot.Helpers;
using ZzukBot.Ingame;
using ZzukBot.Mem;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateGhostWalk : StateGhostWalk
    {

        internal override bool NeedToRun
        {
            get
            {
                bool run = base.NeedToRun;
                if (!run)
                {

                    PartyAssist.Local.ReportResurrect = false;
                    PartyAssist.Local.ReportDead = false;
                }
                return run;
            }
        }
        internal override void Retrieve()
        {
            if (PartyAssist.NeedResurrect)
            {
                base.Retrieve();
            }
            else
            {
                if (Wait.For("party_res",4000))
                    PartyAssist.Local.Report(6);
            }
        }
    }
}