using System;
using ZzukBot.FSM;
using ZzukBot.Mem;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateWaitAfterFight : StateWaitAfterFight { 

        internal override bool NeedToRun => base.NeedToRun;
    }
}