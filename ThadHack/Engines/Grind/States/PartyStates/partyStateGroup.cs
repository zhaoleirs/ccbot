using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZzukBot.Engines.CustomClass;
using ZzukBot.Engines.Party;
using ZzukBot.FSM;
using ZzukBot.Helpers;
using ZzukBot.Mem;

namespace ZzukBot.Engines.Grind.States
{
    internal class PartyStateGroup : State
    {
        internal override int Priority => 99;

        internal override bool NeedToRun
        {
            get
            {
                if (!PartyAssist.Local.isLeader||!PartyAssist.InSignAll()) return false;
                Functions.DoString("partyCount=GetNumPartyMembers()");
                return Convert.ToInt32(Functions.GetText("partyCount"))<PartyAssist.members.Count-1;
            }
        }

        internal override string Name => "MakeGroup";

        internal override void Run()
        {
            if (Wait.For("maketeam", 2000))
            {
                foreach (var member in PartyAssist.members)
                {
                    if (member.Name != ObjectManager.Player.Name)
                    {
                        ObjectManager.Player.SetTarget(member.instance());
                        CCManager.UpdateTarget(member.instance());
                        Functions.DoString("InviteToParty('target')");
                    }
                }
            }
        }
    }
}
