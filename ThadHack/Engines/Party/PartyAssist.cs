using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using ZzukBot.Engines.CustomClass;
using ZzukBot.Engines.Grind;
using ZzukBot.GUI_Forms;
using ZzukBot.Helpers;
using ZzukBot.Mem;
using ZzukBot.Objects;
using ZzukBot.Settings;

namespace ZzukBot.Engines.Party
{
    /// <summary>
    /// 
    /// </summary>
    public class PartyAssist
    {
        /// <summary>
        /// 
        /// </summary>
        public static List<PartyMember> members = new List<PartyMember>();
        internal static bool FocusToVendor;
        internal static bool NeedResurrect=> !members.Exists(i => i.IsDead&&!i.ReportResurrect);

        internal static bool Resting=>members.Exists(i=>i.Rest);

        internal static bool IsInCombat
        {
            get
            {
                foreach (var member in members)
                {
                    var player = member.instance();
                    if (player != null && player.IsInCombat)
                    {
                        return true;
                    }
                }
                return false;
            }
        }
        internal static bool InSignAll()
        {
            var players = ObjectManager.Players;
            foreach (var member in members)
            {
                if (member.Name != ObjectManager.Player.Name)
                {
                    if (!players.Exists(i => i.Name == member.Name && !member.IsDead)) return false;
                }
            }
            return true;
        }

        internal static bool PartyMemberTarget(ulong guid)
        {
            foreach (var member in members)
            {
                var player = member.instance();
                if (player != null)
                {
                    if (player.TargetGuid == guid) return true;
                }
            }
            return false;
        }

        internal static bool TargetPartyMember(ulong targetGuid)
        {
            foreach (var member in members)
            {
                var player = member.instance();
                if (player != null)
                {
                    if (player.Guid == targetGuid) return true;
                }
            }
            return false;
        }
        internal static bool TargetPartyMemberInCombat(ulong targetGuid)
        {
            foreach (var member in members)
            {
                var player = member.instance();
                if (player != null)
                {
                    if (player.Guid == targetGuid&&player.IsInCombat) return true;
                }
            }
            return false;
        }

        internal static void Init()
        {
            FocusToVendor = false;
            members.Clear();
            if (!string.IsNullOrEmpty(Options.Party.party1))
            {
                var part = new PartyMember(Options.Party.party1, members.Count, false,Main.MainForm.pbPart1);
                members.Add(part);
                Main.MainForm.AddLog("Add Party:" + part.Name + ",instance:" + (part.instance() != null));
            }
            if (!string.IsNullOrEmpty(Options.Party.party2))
            {
                var part = new PartyMember(Options.Party.party2, members.Count, false, Main.MainForm.pbPart2);
                members.Add(part);
                Main.MainForm.AddLog("Add Party:" + part.Name + ",instance:" + (part.instance() != null));
            }
            if (!string.IsNullOrEmpty(Options.Party.party3))
            {
                var part = new PartyMember(Options.Party.party3, members.Count, false, Main.MainForm.pbPart3);
                members.Add(part);
                Main.MainForm.AddLog("Add Party:" + part.Name + ",instance:" + (part.instance() != null));

            }
            if (!string.IsNullOrEmpty(Options.Party.party4))
            {
                var part = new PartyMember(Options.Party.party4, members.Count, false, Main.MainForm.pbPart4);
                members.Add(part);
                Main.MainForm.AddLog("Add Party:" + part.Name + ",instance:" + (part.instance() != null));
            }
            if (!string.IsNullOrEmpty(Options.Party.party5))
            {
                var part = new PartyMember(Options.Party.party5, members.Count, true, Main.MainForm.pbPart5);
                members.Add(part);
                Main.MainForm.AddLog("Add Leader:" + part.Name + ",instance:" + (part.instance() != null));
            }
        }
        internal static PartyMember Local => members.FirstOrDefault(i => i.Name == ObjectManager.Player.Name);

        internal static PartyMember Leader => members.FirstOrDefault(i => i.isLeader);

        internal static void OnChatMsg(int parType, string parOwner, string parMessage)
        {
            if (parType == 1)
            {
                if (parMessage == "vendor")
                {
                    FocusToVendor = true;
                }
                else if (parMessage.StartsWith("dead_"))
                {

                    int index = Convert.ToInt32(parMessage.Substring(5));
                    members[index].OnReport(1);
                }
                else if (parMessage.StartsWith("xyz_"))
                {
                    var parms = parMessage.Split('_');
                    int index = Convert.ToInt32(parms[1]);
                    members[index].OnReport(0, parms[2]);
                }
                else if (parMessage.StartsWith("bagfull_"))
                {
                    int index = Convert.ToInt32(parMessage.Substring(8));
                    members[index].OnReport(2);
                }
                else if (parMessage.StartsWith("reston_"))
                {
                    int index = Convert.ToInt32(parMessage.Substring(7));
                    members[index].OnReport(3);
                }
                else if (parMessage.StartsWith("restoff_"))
                {
                    int index = Convert.ToInt32(parMessage.Substring(8));
                    members[index].OnReport(4);
                }
                else if (parMessage.StartsWith("bagempty_"))
                {
                    int index = Convert.ToInt32(parMessage.Substring(9));
                    members[index].OnReport(5);
                }
                else if (parMessage=="vendor")
                {
                    FocusToVendor = true;
                }
            }
        }
        internal static string SelectLootPlayer()
        {
            var member = members.FirstOrDefault(i => !i.IsBagFull);
            if (member == null)
            {
                FocusToVendor = true;
                Main.MainForm.UpdateControl("Loot:Vendor", Main.MainForm.lbLoot);
                return null;
            }
            else
            {
                Main.MainForm.UpdateControl("Loot:" + member.Name, Main.MainForm.lbLoot);
            }
            return member.Name;
        }
        internal static void SetLootMethod()
        {

            Lua.RunInMainthread("LootMethod=GetLootMethod()");
            if (Functions.GetText("LootMethod") != "freeforall")
            {
                Lua.RunInMainthread("SetLootMethod('freeforall')");
                new Thread(new ThreadStart(() =>
                {
                    Thread.Sleep(2000);
                    Lua.RunInMainthread("SetLootThreshold(5)");
                    Thread.CurrentThread.Abort();
                })).Start();
            }
        }

        internal static void Update()
        {
            if (Local.isLeader)
            {
                SetLootMethod();
            }
            foreach (var m in members)
            {
                m.Update(InSignAll());
            }

            if (InSignAll()) {
                var unit=ObjectManager.Npcs.Where(i => TargetPartyMemberInCombat(i.TargetGuid)).OrderBy(i=>i.HealthPercent).FirstOrDefault(); 
                if (unit != null) {
                    Grinder.Access.Info.Combat.RemoveFromBlacklist(unit.Guid);
                    ObjectManager.Player.SetTarget(unit);
                }
            }
        }

    }
}
