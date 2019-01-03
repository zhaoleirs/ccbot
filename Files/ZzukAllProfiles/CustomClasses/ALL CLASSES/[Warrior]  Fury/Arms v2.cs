using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using ZzukBot.Engines.CustomClass;

namespace something
{
    public class SimpleWarrior : CustomClass
    {

        public override byte DesignedForClass
        {
            get
            {
                return PlayerClass.Warrior;
            }
        }

        public override string CustomClassName
        {
            get
            {
                return "BokuWar";
            }
        }

        private void EquipThrow()
        {
            this.Player.DoString(string.Format(@"for i=1,4 do for j=1,10 do local x = GetContainerItemInfo(i,j); if x == ""Interface\\Icons\\INV_ThrowingKnife_02"" then UseContainerItem(i,j) return; end	end end"));
        }

        public override void PreFight()
        {
            /*this.SetCombatDistance(6);
            if (!this.Player.GotBuff("Battle Stance"))
            {
                this.Player.Cast("Battle Stance");
                //return;
            }
            if (this.Player.GetSpellRank("Charge") != 0)
            {
                if (this.Player.CanUse("Charge"))
                {
                    this.Player.Cast("Charge");
                }
            }
            this.Player.Attack();*/
            EquipThrow();
            this.SetCombatDistance(29);
            if (this.Player.ItemCount("Small Throwing Knife") != 0)
            {
                this.Player.Cast("Throw");
            }
            else
            {
                this.SetCombatDistance(4);
                this.Player.Attack();
            }


        }

        private bool TargetCanBleed()
        {
            return (this.Target.CreatureType != CreatureType.Elemental && this.Target.CreatureType != CreatureType.Mechanical);
        }

        public override void Fight()
        {
            this.Player.Attack();
            if (this.Target.DistanceToPlayer <= 15 || this.Target.IsCasting != "" || this.Target.IsChanneling != "")
            {
                this.SetCombatDistance(4);
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

            if (this.Player.GetSpellRank("Battle Shout") != 0)
            {
                if (this.Player.Rage >= 10 && !this.Player.GotBuff("Battle Shout"))
                {
                    this.Player.Cast("Battle Shout");
                }
            }

            if (this.Player.Rage <= 40)
            {
                if (this.Player.GetSpellRank("Bloodrage") != 0 && this.Player.CanUse("Bloodrage"))
                {
                    this.Player.Cast("Bloodrage");
                }
                if (this.Player.GetSpellRank("Berserker Rage") != 0 && this.Player.CanUse("Berserker Rage") && this.Player.GotBuff("Berserker Stance"))
                {
                    this.Player.Cast("Berserker Rage");
                }
            }

            if (this.Player.GetSpellRank("Execute") != 0 && !this.Player.GotBuff("Defensive Stance"))
            {
                if (this.Target.HealthPercent <= 20 && Player.Rage >= 15)
                {
                    this.Player.Cast("Execute");
                    return;
                }
            }

            if (this.Player.GetSpellRank("Bloodthirst") != 0)
            {
                if (this.Player.CanUse("Bloodthirst") && this.Player.Rage >= 20)
                {
                    this.Player.Cast("Bloodthirst");
                    return;
                }
            }
            else if (this.Player.GetSpellRank("Mortal Strike") != 0)
            {
                if (this.Player.CanUse("Mortal Strike") && this.Player.Rage >= 20)
                {
                    this.Player.Cast("Mortal Strike");
                    return;
                }
            }
            else //Super low level 
            {


                if (this.Player.GetSpellRank("Rend") != 0 && TargetCanBleed())
                {
                    if (!this.Target.GotDebuff("Rend") && this.Player.Rage >= 10 & this.Target.HealthPercent > 25)
                    {
                        this.Player.Cast("Rend");
                        return;
                    }
                }
                if (this.Player.Rage >= 15)
                {
                    this.Player.Cast("Heroic Strike");
                }
            }



            if (this.Player.GetSpellRank("Overpower") != 0)
            {
                if (this.Player.CanOverpower)
                {
                    if (this.Player.Rage >= 5)
                        Player.Cast("Overpower");

                }
            }

            if (this.Player.Rage >= 30)
            {
                if (this.Attackers.Count >= 2 && this.Player.GetSpellRank("Cleave") != 0)
                {
                    this.Player.Cast("Cleave");
                }
                else
                {
                    this.Player.Cast("Heroic Strike");
                }
            }

        }

        public override bool Buff()
        {
            //True means we are done buffing, or cannot buff
            return true;
        }
    }
}