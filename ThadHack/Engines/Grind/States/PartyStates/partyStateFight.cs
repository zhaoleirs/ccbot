using System;
using System.Linq;
using ZzukBot.Constants;
using ZzukBot.Engines.CustomClass;
using ZzukBot.Engines.Party;
using ZzukBot.FSM;
using ZzukBot.Helpers;
using ZzukBot.Mem;
using ZzukBot.Objects;
using ZzukBot.Settings;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateFight : StateFight
    {

        internal override bool NeedToRun =>base.NeedToRun&&(ObjectManager.Player.IsInCombat||(!PartyAssist.Resting&&PartyAssist.InSignAll()));

        internal override bool GroupRest()
        {
            return PartyAssist.Resting;
        }

        internal override void Run()
        {
            if (PartyAssist.Local.isLeader)
            {
                var players = ObjectManager.Players;
                int playerCount = players.Count(i => i.DistanceToPlayer < 50 && !i.IsInCombat && !PartyAssist.members.Any(m => i.Name == m.Name));
                if (playerCount >= 1)
                {
                    if (Wait.For("look_cheat_say", 30 * 1000))
                    {
                        Lua.RunInMainthread("SendChatMessage('????','PARTY')");
                    }
                    if (Wait.For("look_cheat", 60 * 1000))
                    {
                        Lua.RunInMainthread("SendChatMessage('vendor','PARTY')");
                        Options.SpaceTime = 5;
                    }
                }
                else
                {
                    Wait.Remove("look_cheat");
                }
            }
            base.Run();
        }
    }
}