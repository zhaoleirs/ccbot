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

        internal override bool NeedToRun => base.NeedToRun;
        internal override void Resurrect()
        {
            if (PartyAssist.NeedResurrect)
            {
                PartyAssist.Local.ReportResurrect = false;
                base.Resurrect();
            }
            else {
                PartyAssist.Local.Report(6);
            }
        }
    }
}