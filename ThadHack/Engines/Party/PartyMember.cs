using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using ZzukBot.Engines.CustomClass;
using ZzukBot.Engines.CustomClass.Objects;
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
    public class PartyMember
    {
        /// <summary>
        /// 名字
        /// </summary>
        internal string Name { get; set; }
        internal bool isLocalPlayer => ObjectManager.Player.Name == Name;
        internal bool isLeader;
        internal int Index;
        internal XYZ ReportPosition { get; private set; }
        internal bool ReportBagFull;
        internal bool ReportDead;
        internal bool Rest;
        private ProgressBar pb;
        internal bool ReportResurrect;
        private bool LocalResting;
        private bool LocalBagFull;
        private bool LocalResurrect;

        internal XYZ Postion { get {
                WoWUnit player = instance();
                if (player != null && player.Health > 0) {
                    return player.Position;
                }
                return ReportPosition;
            } }

        internal bool IsBagFull
        {
            get
            {
                if (isLocalPlayer)
                {
                    var full= !Options.LootUnits || ObjectManager.Player.Inventory.FreeSlots < Options.MinFreeSlotsBeforeVendor;
                    if (full) {
                        Report(2);
                    }
                }
                return ReportBagFull;
            }
        }
        internal bool IsDead
        {
            get
            {
                if (isLocalPlayer)
                {
                    return ObjectManager.Player.InGhostForm;
                }
                else 
                {

                    WoWUnit player = instance();
                    if (player != null) {
                        return player.Health <= 1;
                    }
                    return ReportDead;
                }
            }
        }
        /// <summary>
        /// 0-positoin 1-dead 2-bagfull 3-reston 4-restoff 5-bag_empty 6-resurrect
        /// </summary>
        /// <param name="state">0-positoin 1-dead 2-bagfull</param>
        internal void Report(int state) {
            switch (state)
            {
                case 0:
                    Lua.RunInMainthread("SendChatMessage('xyz_" + Index + "_" + instance().Position + "','PARTY')");
                    break;
                case 1:
                    LocalResurrect = false;
                    Lua.RunInMainthread("SendChatMessage('dead_" + Index + "','PARTY')");
                    break;
                case 2:
                    LocalBagFull=true;
                    if (LocalBagFull!=ReportBagFull)
                    {
                        Lua.RunInMainthread("SendChatMessage('bagfull_" + Index + "','PARTY')");
                    }
                    break;
                case 3:
                    LocalResting = true;
                    Lua.RunInMainthread("SendChatMessage('reston_" + Index + "','PARTY')");
                    break;
                case 4:
                    LocalResting = false;
                    Lua.RunInMainthread("SendChatMessage('restoff_" + Index + "','PARTY')");
                    break;
                case 5:
                    LocalBagFull = false;
                    if (LocalBagFull != ReportBagFull)
                    {
                        Lua.RunInMainthread("SendChatMessage('bagempty_" + Index + "','PARTY')");
                    }
                    break;
                case 6:
                    LocalResurrect = true;
                    if (!ReportResurrect)
                        Lua.RunInMainthread("SendChatMessage('resurrect_" + Index + "','PARTY')");
                    break;
            }
        }
        /// <summary>
        /// 0-positoin 1-dead 2-bagfull 3-reston 4-restoff 5-bag_empty  6-resurrect
        /// </summary>
        /// <param name="state">0-positoin 1-dead 2-bagfull</param>
        /// <param name="value"></param>
        internal void OnReport(int state,string value=null)
        {
            switch (state)
            {
                case 0:
                    ReportPosition.ParseString(value);
                    break;
                case 1:
                    ReportDead = true;
                    break;
                case 2:
                    ReportBagFull = true;
                    break;
                case 3:
                    Rest = true;
                    break;
                case 4:
                    Rest = false;
                    break;
                case 5:
                    ReportBagFull = false;
                    break;
                case 6:
                    ReportResurrect = true;
                    break;
            }
        }
        /// <summary>
        /// part member
        /// </summary>
        /// <param name="Name"></param>
        /// <param name="Index"></param>
        /// <param name="isLeader"></param>
        public PartyMember(string Name,int Index,bool isLeader,ProgressBar pb) {
            this.Name = Name;
            this.Index = Index;
            this.isLeader = isLeader;
            this.pb = pb;
            ReportPosition = new XYZ();
        }
        
        /// <summary>
        /// cast on player
        /// </summary>
        /// <param name="spell"></param>
        public void CastOn(string spell) {
            var player = this.instance();
            if (player != null) {
                if (player != ObjectManager.Player|| CCManager._Target.Ptr.IsPlayer)
                {
                    ObjectManager.Player.SetTarget(player);
                    CCManager.UpdateTarget(player);
                }
                CCManager._Player.Cast(spell);
            }
        }
        private string getLuaId()
        {
            for (int i = 1; i <= 4; i++)
            {
                Functions.DoString("partyN=UnitIsUnit('target','party" + i + "')");
                if (Functions.GetText("partyN")=="1"){
                    return "party" + i; 
                }
            }
            return "";
        }
        /// <summary>
        /// get instance player
        /// </summary>
        /// <returns></returns>
         internal WoWUnit instance() {
            if (isLocalPlayer) return ObjectManager.Player;
            return ObjectManager.Players.FirstOrDefault(i => i.Name == Name);
        }

        public WoWUnit InstanceDistance(float dis)
        {
            if (isLocalPlayer) return ObjectManager.Player;
            return ObjectManager.Players.FirstOrDefault(i => i.Name == Name&& i.DistanceToPlayer<dis);
        }

        internal void Update(bool inSign)
        {
            if (isLocalPlayer) {
                if (ObjectManager.Player.InGhostForm)
                {
                    Report(LocalResurrect?6:1);
                }
                else {
                    if (!inSign&&isLeader)
                    {
                        Report(0);
                    }

                    if (LocalResting != Rest)
                    {
                        if (LocalResting)
                        {

                            Report(3);
                        }
                        else
                        {
                            Report(4);
                        }
                    }
                    if (LocalBagFull != ReportBagFull)
                    {
                        if (LocalBagFull)
                        {

                            Report(2);
                        }
                        else
                        {
                            Report(5);
                        }
                    }
                }
                
            }
            WoWUnit player = instance();
            if (player != null) {
                Main.MainForm.UpdateProgress(player.Health*100/player.MaxHealth, pb);
            }
            else
            {
                Main.MainForm.UpdateProgress(0, pb);
            }
        }
    }
}
