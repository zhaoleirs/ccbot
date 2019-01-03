using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using ZzukBot.Engines.CustomClass;
using ZzukBot.Engines.Party;
using obj = ZzukBot.Engines.CustomClass.Objects;

namespace something
{
    public class Schouten_Priest : PartyCustomClass
    {
        public override byte DesignedForClass
        {
            get
            {
                return PlayerClass.Priest;
            }
        }
        public override string CustomClassName
        {
            get
            {
                return "Schouten_Priest";
            }
        }
        class HealthClass
        {
            public string name;
            string debuff;
            int hp;
            bool isBuff;


            public HealthClass(string name, int hp, bool isBuff = false, string debuff = null)
            {
                this.name = name;
                this.hp = hp;
                this.debuff = debuff;
                this.isBuff = isBuff;
            }
            public bool needUse(PartyMember player)
            {
                var _m=player.InstanceDistance(30);
                if(_m==null||_m.HealthPercent<1)return false;
                var isCondition = _m.HealthPercent < this.hp;
                if (isCondition)
                {
                    return !isBuff || (!_m.GotAura(name) && (string.IsNullOrEmpty(debuff) || !_m.GotDebuff(debuff)));

                }
                return false;
            }
        }
        private string[] buffs = { "Power Word: Fortitude", "Divine Spirit" };//, "Shadow Protection"
        private HealthClass[] healths = { new HealthClass("Flash Heal", 50), new HealthClass("Renew", 90, true),new HealthClass("Power Word: Shield", 70, true, "Weakened Soul") };
        private int wandtime=0;
        private void Pain(){
            if (Target.HealthPercent>10&&this.Player.GetSpellRank("Shadow Word: Pain") != 0 && (Target.Level-Player.Level)<=3&&!Target.GotDebuff("Shadow Word: Pain"))
            {
                Player.StopWand();
                this.Player.Cast("Shadow Word: Pain");
                return;
            }

        }
        public override void PreFight()
        {
            //set the attack distance
            this.SetCombatDistance(25);

            //pull with mind blast
            if (this.Player.GetSpellRank("Mind Blast") != 0)
            {
                if (this.Player.CanUse("Mind Blast"))
                {
                    this.Player.Cast("Mind Blast");
                    return;
                }
            }
            //get a swp on the mob
            Pain();

            if (this.Player.IsWandEquipped())
            {
                StartWand();
            }
            else if (this.Player.GetSpellRank("Smite") != 0)
            {
                if (this.Player.CanUse("Smite"))
                {
                    this.Player.Cast("Smite");
                }
            }
        }
        private void StartWand(){
            int time=Environment.TickCount;
            if(wandtime+1200<time){
                wandtime=time;
                Player.StartWand();
            }
        }
        public override void MoveTarget(){
           Pain();
         }
         private bool HealthAll(){
            foreach (var party in PartyAssist.members)
                {
                    var player=party.InstanceDistance(30);
                    if(player!=null){
                        if(this.Player.GetSpellRank("Abolish Disease") != 0){
                            if(player.GotDebuff("Rabies")){
                                this.Player.StopWand();
                                party.CastOn("Abolish Disease");
                                return false;
                            }
                        }
                        foreach (var health in healths)
                        {
                            if (Player.GetSpellRank(health.name) != 0&& Player.CanUse(health.name)&& health.needUse(party))
                            {
                                this.Player.StopWand();
                                party.CastOn(health.name);
                                return false;
                            }
                        }
                    }
                }
                return true;
         }
        public override void Fight()
        {
            if(Player.ItemCount("Big-mouth Clam")>0){
                Player.UseItem("Big-mouth Clam"); 
                LootAll();
            }
            //freak out because the shit is hitting the fan
            if(Player.ManaPercent>10){
                if (this.Player.HealthPercent < 10 && this.Player.CanUse("Psychic Scream"))
                {
                    this.Player.StopWand();
                    this.Player.Cast("Psychic Scream");
                }
                HealthAll();
                //multi mob SWP all the time
                Pain();

                if (this.Player.GetSpellRank("Inner Fire") != 0)
                {
                    if (!Player.GotBuff("Inner Fire"))
                    {
                        this.Player.StopWand();
                        this.Player.Cast("Inner Fire");
                        return;
                    }
                }
            }
            if (this.Player.IsWandEquipped())
            {
                StartWand();
            }
            else
            {
                if (this.Player.GetSpellRank("Smite") != 0&&this.Player.ManaPercent>40)
                {
                    this.Player.Cast("Smite");
                }else{

                    this.Player.Attack();
                }
            }
        }

        public override void Rest()
        {

            if(Player.GotBuff("Drink"))return;
          
            if(Player.ManaPercent<70){

                if(Player.ItemCount("Ice Cold Milk")>0){
                    this.Player.UseItem("Ice Cold Milk");
                }else if (Player.ItemCount("Morning Glory Dew")>0){
                    this.Player.UseItem("Morning Glory Dew");
                }else if (Player.ItemCount("Moonberry Juice")>0){
                    this.Player.UseItem("Moonberry Juice");
                }else if (Player.ItemCount("Sweet Nectar")>0){
                    this.Player.UseItem("Sweet Nectar");
                }
                else if (Player.ItemCount("Enchanted Water")>0){
                    this.Player.UseItem("Enchanted Water"); 
                }
                else if (Player.ItemCount("Refreshing Spring Water")>0){
                    this.Player.UseItem("Refreshing Spring Water");
                }
                    
            }
           // else
               // this.EndRest();
        }
        public override bool BuffAll(List<PartyMember> members)
        {
        
            //this should prevent more than one spell from trying to be called at once
            if (this.Player.IsCasting != "")
                return false;
            if (this.Player.GetSpellRank("Inner Fire") != 0)
            {
                if (!this.Player.GotBuff("Inner Fire"))
                {
                    this.Player.Cast("Inner Fire");
                    return false;
                }
            }
            if(!HealthAll())return false;
           // foreach (var party in members)
           //  {
           //      if(party.instance(30)!=null){
           //          foreach (var health in healths)
           //          {
           //              if (Player.GetSpellRank(health.name) != 0&& Player.CanUse(health.name) && health.needUse(party))
           //              {
           //                  party.CastOn(health.name);
           //                  return false;
           //              }
           //          }
           //      }
           //  }
            foreach (var party in PartyAssist.members)
            {
                var player = party.InstanceDistance(30);
                if(player!=null&&player.HealthPercent>1)
                foreach (var buff in buffs)
                {
                    if (this.Player.GetSpellRank(buff) != 0)
                    {
                        if (!player.GotAura(buff))
                        {
                            party.CastOn(buff);
                            return false;
                        }
                    }
                }
            }
            //True means we are done buffing, or cannot buff
            return true;
        }
    }
}
