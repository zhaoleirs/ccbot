using System;
using ZzukBot.Engines.Party;
using ZzukBot.FSM;
using ZzukBot.Helpers;
using ZzukBot.Mem;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateLoot : StateLoot
    {
       
        internal override bool NeedToRun => ObjectManager.Player.Name == PartyAssist.SelectLootPlayer()&&base.NeedToRun;

    }
}