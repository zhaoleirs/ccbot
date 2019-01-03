using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using ZzukBot.Constants;
using ZzukBot.FSM;
using ZzukBot.Helpers;
using ZzukBot.Mem;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateDoRandomShit : StateDoRandomShit
    {
        internal override bool NeedToRun =>false;
    
    }
}