using ZzukBot.FSM;
using ZzukBot.Mem;
using System.Linq;
using ZzukBot.Settings;
using ZzukBot.Constants;
using System;
using ZzukBot.Helpers;

namespace ZzukBot.Engines.Grind.States
{
    internal class StateBattleGroup : State
    {
        internal override int Priority => 98;

        internal override bool NeedToRun => ObjectManager.Player.GetMapID == 1||(ObjectManager.Player.InBattleGround&& ResultFrameOpen);

        internal const string IsResultOpen = "if WorldFrame:IsVisible() then resultSh1 = 'true' else resultSh1 = 'false' end";
        internal const string GT_IsResultOpen = "resultSh1";

        internal override string Name => "BattleGroup";
        internal const string IsGossipOpen = "if GossipFrame:IsVisible() then gossipSh1 = 'true' else gossipSh1 = 'false' end";

        internal const string GT_IsGossipOpen = "gossipSh1";

        internal const string IsBattleFrameOpen ="if BattlefieldFrame:IsVisible() then battlefieldSh1 = 'true' else battlefieldSh1 = 'false' end";

        internal const string GT_IsBattleFrameOpen = "battlefieldSh1";
        private string JoinBattleField= "for i=1, MAX_BATTLEFIELD_QUEUES do status, mapName, instanceID = GetBattlefieldStatus(i) if status == 'confirm' then AcceptBattlefieldPort(i,1) StaticPopup_Hide('CONFIRM_BATTLEFIELD_ENTRY') end end";

        internal override void Run()
        {
            Functions.DoString("battleFieldTime=GetBattlefieldTimeWaited(1)");
            bool isBattleQueue = Functions.GetText("battleFieldTime") != "0";
            if (!isBattleQueue)
            {
                if (PartyCondition())
                {
                    //aoge
                    if (GossipOpen)
                    {
                        Functions.DoString("SelectGossipOption(1)");
                    }
                    else if (BattlefieldOpen)
                    {
                        JoinButtonTap();
                    }
                    else
                    {
                        // open vendor interface and skip gossip
                        var vendor = ObjectManager.Npcs.FirstOrDefault(i => i.Name == Options.Party.BattleGround);
                        if (vendor != null)
                        {
                            ObjectManager.Player.CancelShapeshift();
                            ObjectManager.Player.RightClick(vendor);
                        }
                    }
                }
            }
            else
            {
                if (Wait.For("JoinBattleField", 7000)) {
                    Lua.RunInMainthread(JoinBattleField);
                }
            }
        }
        internal virtual bool PartyCondition()
        {
            return true;
        }
        internal virtual void JoinButtonTap()
        {
            Functions.DoString("BattlefieldFrameJoinButton:Click()");
        }

        internal bool ResultFrameOpen
        {
            get
            {
                if (Wait.For("ResultFrameOpen", 10000)) {

                    Lua.RunInMainthread("WorldStateScoreFrameLeaveButton:Click()");
                }
                return false;
            }
        }

        internal bool GossipOpen
        {
            get
            {
                var encryptedName = GT_IsGossipOpen.GenLuaVarName();
                Functions.DoString(IsGossipOpen.Replace(GT_IsGossipOpen, encryptedName));
                var res = Functions.GetText(encryptedName) == "true";
                return res;
            }
        }

        internal bool BattlefieldOpen
        {
            get
            {
                var encryptedName = GT_IsBattleFrameOpen.GenLuaVarName();
                Functions.DoString(IsBattleFrameOpen.Replace(GT_IsBattleFrameOpen, encryptedName));
                var res = Functions.GetText(encryptedName) == "true";
                return res;
            }
        }
    }
}