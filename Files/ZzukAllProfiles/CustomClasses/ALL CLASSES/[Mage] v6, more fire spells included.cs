using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using ZzukBot.Engines.CustomClass;

namespace something
{
    public class EmuMage : CustomClass
    {
        string MainSpell = "Frostbolt";

        private string[] WaterName = {"", "Conjured Water", "Conjured Fresh Water",
                                         "Conjured Purified Water", "Conjured Spring Water",
                                         "Conjured Mineral Water", "Conjured Sparkling Water",
                                         "Conjured Crystal Water"};
        private string[] FoodName = {"", "Conjured Muffin", "Conjured Bread",
                                         "Conjured Rye", "Conjured Pumpernickel",
                                         "Conjured Sourdough", "Conjured Sweet Roll",
                                         "Conjured Cinnamon Roll"};


        public override byte DesignedForClass
        {
            get
            {
                return PlayerClass.Mage;
            }
        }

        public override string CustomClassName
        {
            get
            {
                return "EmuMage";
            }
        }

        public override void PreFight()
        {
            this.Player.Attack();
            this.SetCombatDistance(30);
            if (this.Player.GetSpellRank("Ice Barrier") != 0)
            {
                if (!this.Player.GotBuff("Ice Barrier"))
                {
                    if (this.Player.CanUse("Ice Barrier"))
                    {
                        this.Player.Cast("Ice Barrier");
                    }
                }
            }

            if (this.Player.GetSpellRank("Pyroblast") != 0)
            {
                this.Player.CastWait("Pyroblast", 1000);
            }

            this.Player.Cast(this.Player.GetSpellRank(MainSpell) != 0 ? MainSpell : "Fireball");
        }


        public override void Fight()
        {
            bool canWand = this.Player.IsWandEquipped();

            if (!canWand)
            {
                Player.Attack();
            }
            //Either we are a really low level or we are out of mana // the OR should be changed with a level requirement
            if (this.Player.ManaPercent < 10 || ((this.Player.GetSpellRank("Frostbolt") == 0) && this.Player.ManaPercent <= 10))
            {
                if (canWand)
                {
                    this.Player.StartWand();
                }
                return;
            }
			
			 //Health Potion
             if (this.Player.HealthPercent <= 22 && this.Player.ItemCount("Superior Healing Potion") != 0)
             {
                this.Player.UseItem("Superior Healing Potion");
             }
          
             if (this.Player.HealthPercent <= 22 && this.Player.ItemCount("Greater Healing Potion") != 0)
             {
                this.Player.UseItem("Greater Healing Potion");
             }

             if (this.Player.HealthPercent <= 22 && this.Player.ItemCount("Healing Potion") != 0)
             {
                this.Player.UseItem("Healing Potion");
             }

             if (this.Player.HealthPercent <= 20 && this.Player.ItemCount("Lesser Healing Potion") != 0)
             {
                this.Player.UseItem("Lesser Healing Potion");
             }
          
             if (this.Player.HealthPercent <= 20 && this.Player.ItemCount("Minor Healing Potion") != 0)
             {
                this.Player.UseItem("Minor Healing Potion");
             }      

            if (this.Player.HealthPercent <= 30 && !this.Player.GotBuff("Mana Shield"))
            {
                if (this.Player.GetSpellRank("Mana Shield") != 0)
                {
                    this.Player.Cast("Mana Shield");
                }
            }

            if (this.Player.GetSpellRank("Ice Barrier") != 0 && (this.Attackers.Count > 1 || this.Target.HealthPercent > 10))
            {
                if (!this.Player.GotBuff("Ice Barrier"))
                {
                    if (this.Player.CanUse("Ice Barrier"))
                    {
                        this.Player.Cast("Ice Barrier");
                    }
                }
            }


            if (this.Target.IsCasting != "" || this.Target.IsChanneling != "")
            {
                if (this.Player.GetSpellRank("Counterspell") != 0)
                {
                    if (this.Player.CanUse("Counterspell"))
                    {
                        this.Player.Cast("Counterspell");
                        return;
                    }
                }
            }
		
			
            if (this.Player.GetSpellRank("Fire Blast") != 0 && this.Target.DistanceToPlayer <= 20)
            {
                if (this.Player.CanUse("Fire Blast"))
                {
                    this.Player.Cast("Fire Blast");
                    return;
                }
            }
			
            //cone of cold
            if (this.Player.GetSpellRank("Cone of Cold") != 0 && this.Target.DistanceToPlayer <= 10 && Target.HealthPercent > 10)
            {
                if (this.Player.CanUse("Cone of Cold"))
                {
                    this.Player.Cast("Cone of Cold");
                    return;
                }
            }
			
            if (this.Player.GetSpellRank("Frost Nova") != 0 && this.Player.CanUse("Frost nova") && this.Player.IsAoeSafe(8)
                && this.Target.DistanceToPlayer <= 4 && this.Target.HealthPercent >= 20)
            {
                this.Player.Cast("Frost Nova");
            }

            if (Target.GotDebuff("Frost Nova"))
            {
                bool res = Player.ForceBackup(8);
            }
            else
            {
                Player.StopForceBackup();
            }

            if (this.Player.GetSpellRank(MainSpell) == 0)
            {
                this.Player.Cast("Fireball");
            }
            else
            {
                this.Player.Cast(MainSpell);
            }
        }

        public override void Rest()
        {

            if (this.Player.GetSpellRank("Evocation") != 0)
            {

                if (this.Player.CanUse("Evocation") && Player.ManaPercent <= 20)
                {
                    this.Player.CastWait("Evocation", 1000);
                    return;
                }
            }

            if (this.Player.ItemCount(FoodName[this.Player.GetSpellRank("Conjure Food")]) >= 1)
            {
                this.Player.Eat(FoodName[this.Player.GetSpellRank("Conjure Food")]);
            }
            else
            {
                Player.Eat();
            }
            if (this.Player.ItemCount(WaterName[this.Player.GetSpellRank("Conjure Water")]) >= 1)
            {
                this.Player.Drink(WaterName[this.Player.GetSpellRank("Conjure Water")]);
            }
            else
            {
                Player.Drink();
            }

        }

        public override bool Buff()
        {

            if (this.Player.IsCasting != "")
                return false;

            if (this.Player.GetSpellRank("Conjure Water") != 0)
            {
                if (this.Player.ItemCount(WaterName[this.Player.GetSpellRank("Conjure Water")]) <= 5)
                {
                    this.Player.Cast("Conjure Water");
                    return false;
                }
            }

            if (this.Player.GetSpellRank("Conjure Food") != 0)
            {
                if (this.Player.ItemCount(FoodName[this.Player.GetSpellRank("Conjure Food")]) <= 5)
                {
                    this.Player.Cast("Conjure Food");
                    return false;
                }
            }

            if (this.Player.GetSpellRank("Mage Armor") != 0)
            {
                if (!this.Player.GotBuff("Mage Armor"))
                {
                    this.Player.Cast("Mage Armor");
                    return false;
                }
            }
            else
            {
                if (this.Player.GetSpellRank("Frost Armor") != 0)
                {
                    if (!this.Player.GotBuff("Frost Armor"))
                    {
                        this.Player.Cast("Frost Armor");
                        return false;
                    }
                }
            }
            if (this.Player.GetSpellRank("Arcane Intellect") != 0)
            {
                if (!this.Player.GotBuff("Arcane Intellect"))
                {
                    this.Player.Cast("Arcane Intellect");
                    return false;
                }
            }
            if (this.Player.GetSpellRank("Dampen Magic") != 0)
            {
                if (!this.Player.GotBuff("Dampen Magic"))
                {
                    this.Player.Cast("Dampen Magic");
                    return false;
                }
            }
            //True means we are done buffing, or cannot buff
            return true;
        }

    }
}