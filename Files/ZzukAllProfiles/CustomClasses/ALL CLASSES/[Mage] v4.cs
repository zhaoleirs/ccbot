using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using ZzukBot.Engines.CustomClass;
//using ZzukBot.Engines.CustomClass.Objects;

namespace TwinRovaMageCC //0.2.6
{
   // This is a modified EmuMage for leveling as frost. Credit goes to Emu for the original script.
    public class TwinRovaMage : CustomClass
    {
        //edit to true if you want these spells
        bool useManaShield = true;
        bool useDampenMagic = true;
        bool useIceBlock = true;
        bool useCounterSpell = true;
        bool useBlink = true;
        //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

        //this enum will be used later in the fight loop to improve the class greatly.
        enum fightingStateEnum {Bursting, LowPlayerHealth, LowPlayerMana, LowTargetHealth, FrostNovaToBlink, Polymorphing, AoEPull, RunAway, EnemyFlee};

        fightingStateEnum fightState = fightingStateEnum.Bursting;

        //these timers are used to make it look more human, and make calculations for spell timing.
        int timerFrostNovaBlink = 5;

        //used for conjure food and water
        private string[] WaterName = {"", "Conjured Water", "Conjured Fresh Water",
                                         "Conjured Purified Water", "Conjured Spring Water",
                                         "Conjured Mineral Water", "Conjured Sparkling Water",
                                         "Conjured Crystal Water"};
        private string[] FoodName = {"", "Conjured Muffin", "Conjured Bread",
                                         "Conjured Rye", "Conjured Pumpernickel",
                                         "Conjured Sourdough", "Conjured Sweet Roll",
                                         "Conjured Cinnamon Roll"};

        //mana gems
        private string[] manaGemNames = {"Mana Agate"};

        private int[] manaGemLevels = {1};


        //mage class
        public override byte DesignedForClass
        {
            get
            {
                return PlayerClass.Mage;
            }
        }

        //CC name
        public override string CustomClassName
        {
            get
            {
                return "TwinrovaFrost";
            }
        }

        //pre fight
        public override void PreFight()
        {
            this.Player.Attack();
            this.SetCombatDistance(37);
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

            if (this.Player.GetSpellRank("Frostbolt") == 0)
            {
                this.Player.Cast("Fireball");
            }
            else
            {
                this.Player.Cast("Frostbolt");
            }

        }

        //FIGHT!
        public override void Fight()
        {

            //Fight States!!
            /*
            switch (fightState)
            {
                case fightingStateEnum.Bursting:
                {
                       
                    break;
                }
                case fightingStateEnum.LowPlayerHealth:
                {

                    break;
                }
                case fightingStateEnum.LowPlayerMana:
                {

                    break;
                }
                case fightingStateEnum.LowTargetHealth:
                {

                    break;
                }
                case fightingStateEnum.FrostNovaToBlink:
                {

                    break;
                }
                case fightingStateEnum.Polymorphing:
                {

                    break;
                }
                case fightingStateEnum.AoEPull:
                {

                    break;
                }
                case fightingStateEnum.RunAway:
                {

                    break;
                }
                case fightingStateEnum.EnemyFlee:
                {

                    break;
                }

            }
            */

            bool canWand = this.Player.IsWandEquipped();

            if (!canWand)
            {
                Player.Attack();
            }
           
            //mana gem
            if (this.Player.ManaPercent < 25 && this.Player.ItemCount(manaGemNames[0]) == 1)
            {
                this.Player.UseItem(manaGemNames[0]);
            }
			
	        //Mana Potion
			if (this.Player.ManaPercent <= 15 && this.Player.ItemCount("Superior Mana Potion") != 0)
			{
				this.Player.UseItem("Superior Mana Potion");
			}
			
             //Health Potion
             if (this.Player.HealthPercent <= 15 && this.Player.ItemCount("Superior Healing Potion") != 0)
             {
                this.Player.UseItem("Superior Healing Potion");
             }
          
             if (this.Player.HealthPercent <= 15 && this.Player.ItemCount("Greater Healing Potion") != 0)
             {
                this.Player.UseItem("Greater Healing Potion");
             }

             if (this.Player.HealthPercent <= 15 && this.Player.ItemCount("Healing Potion") != 0)
             {
                this.Player.UseItem("Healing Potion");
             }

             if (this.Player.HealthPercent <= 15 && this.Player.ItemCount("Lesser Healing Potion") != 0)
             {
                this.Player.UseItem("Lesser Healing Potion");
             }
          
             if (this.Player.HealthPercent <= 15 && this.Player.ItemCount("Minor Healing Potion") != 0)
             {
                this.Player.UseItem("Minor Healing Potion");
             }    
					
            //wand
            if (this.Player.ManaPercent < 13 || Target.HealthPercent < 13)
            {
                if (canWand && this.Player.IsCasting != "Shoot" && this.Player.IsChanneling != "Shoot")
                {
                    this.Player.StartWand();
                    return;
                }
            }

            //mana shield
            if (this.Player.HealthPercent <= 17 && !this.Player.GotBuff("Mana Shield") && useManaShield)
            {
                if (this.Player.GetSpellRank("Mana Shield") != 0)
                {
                    this.Player.Cast("Mana Shield");
                }
            }

			//IceBlock
            if (this.Player.HealthPercent <= 10 && this.Player.CanUse("Ice Block") && useIceBlock)
            {
                this.Player.Cast("Ice Block");
            }
             
            //ice barrier
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

            //counterspell
            if (this.Target.IsCasting != "" || this.Target.IsChanneling != "" && useCounterSpell)
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

			/*
            //cone of cold
            if (this.Player.GetSpellRank("Cone of Cold") != 0 && this.Target.DistanceToPlayer <= 12)
            {
                if (this.Player.CanUse("Cone of Cold"))
                {
                    this.Player.Cast("Cone of Cold");
                    return;
                }
            }*/
			
			
			//Cone of Cold + Nova *****
			if (Target.GotDebuff("Frost Nova") && this.Target.DistanceToPlayer > 8)
			{
                if (this.Player.CanUse("Cone of Cold") && this.Player.CanUse("Frostbolt"))
				{
                  this.Player.CastWait("Cone of Cold", 4000);
			      this.Player.Cast("Frostbolt");				  
				  return;
				}
			}

			
	         //Frost Nova Burst -- Shatter Burst (Frostbolt + Cone )
             if (this.Target.GotDebuff("Frost Nova") || this.Target.GotDebuff("Frostbite") || this.Target.GotDebuff("Freeze"))
             {
                if (this.Player.GetSpellRank("Cone of Cold") != 0 && this.Target.DistanceToPlayer <= 10)
                {
                   if (this.Player.CanUse("Cone of Cold") && this.Player.CanUse("Frostbolt"))
                   {
                      this.Player.CastWait("Frostbolt", 4000);
                      this.Player.Cast("Cone of Cold");
                      return;
                   }   
                }
             else if (this.Player.GetSpellRank("Fire Blast") != 0 && this.Target.DistanceToPlayer <= 20)
                {
                   if (this.Player.CanUse("Fire Blast") && this.Player.CanUse("Frostbolt"))
                   {
                      this.Player.CastWait("Frostbolt", 4000);
                      this.Player.Cast("Fire Blast");
                      return;
                   }
                }            
                else if (this.Player.CanUse("Frostbolt"))
                {
                   this.Player.Cast("Frostbolt");
                   return;               
                }   
             }
			 
			
            //fireblast
			if (this.Player.GetSpellRank("Fire Blast") != 0 && this.Target.DistanceToPlayer <= 20)
            {
                if (this.Player.CanUse("Fire Blast"))
                {
                    this.Player.Cast("Fire Blast");
                    return;
                }
            }

			
             //Frost Nova
             if (this.Player.CanUse("Frost Nova") && this.Target.DistanceToPlayer <= 12 && this.Target.HealthPercent >= 28 && !this.Target.GotDebuff("Frost Nova") 
		     && !this.Target.GotDebuff("Frostbite"))
             {
                this.Player.Cast("Frost Nova");
                return;
             }
			 
			
             //Coldsnap if Frost Nova is on CD and HP is low
             else if (this.Player.CanUse("Frost Nova") == false && this.Target.DistanceToPlayer <= 10 && this.Target.HealthPercent >= 20 
			 && this.Player.CanUse("Cold Snap") && this.Player.HealthPercent <= 40 && !this.Target.GotDebuff("Frost Nova"))
             {
                this.Player.Cast("Cold Snap");
                return;
             }
				 
				 
			/*
            //blink ---- OLD
            if (Target.GotDebuff("Frost Nova"))
            {
                if (this.Player.CanUse("Blink") && useBlink)
                {
                    this.Player.Cast("Blink");
                }
                else
                {
                    bool res = Player.ForceBackup(10); //Set to 6 for CONE
                }
            }
            else
            {
                Player.StopForceBackup();
            }*/

			
			
			//------------------------//
			
		     //Blink on CC
             if (this.Player.GotDebuff("Web") && this.Target.GotDebuff("Frost Nova") || this.Player.GotDebuff("Tendon Rip") && this.Target.GotDebuff("Frost Nova") 
		     || this.Player.GotDebuff("Kidney Shot") || this.Player.GotDebuff("Intercept Stun") || this.Player.GotDebuff("Hammer of Justice") 
		     || this.Player.GotDebuff("Stun"))
             {
                if (this.Player.CanUse("Blink") && useBlink)
                {
                   this.Player.Cast("Blink");
                }
             }
			
             //Backup from Frost Novad target
             if (this.Target.GotDebuff("Frost Nova") && this.Target.DistanceToPlayer <= 10)
             {
                //Use Blink if low hp
                if (this.Player.CanUse("Blink") && useBlink && this.Player.HealthPercent <= 30)
                {
                   this.Player.Cast("Blink");
                }
                else
                {
                   bool res = Player.ForceBackup(6);
                }
             }
             else
             {
                Player.StopForceBackup();
             }
			
			//-------------------------//
			
            //frostbolt, and backup main spells
            if (this.Player.GetSpellRank("Frostbolt") == 0)
            {
                this.Player.Cast("Fireball");
            }
            else
            {
                if (this.Player.CanUse("Frostbolt"))
                {
                    this.Player.Cast("Frostbolt");
                }
                else if (this.Player.CanUse("Fireball"))
                {
                    this.Player.Cast("Fireball");
                }
                else
                {
                    //this.Player.Cast("Arcane Missiles");
                }
               
            }

        }

        //rest
        public override void Rest()
        {
            //evocate for mana if we can
            if (this.Player.GetSpellRank("Evocation") != 0)
            {

                if (this.Player.CanUse("Evocation") && Player.ManaPercent <= 20)
                {
                    this.Player.CastWait("Evocation", 8000);
                    //return;
                }
            }

            //dont cancel evocation if we're casting it.
            if (this.Player.IsChanneling != "Evocation" && this.Player.IsCasting != "Evocation")
            {
                //food
                if (this.Player.ItemCount(FoodName[this.Player.GetSpellRank("Conjure Food")]) >= 1)
                {
                    this.Player.Eat(FoodName[this.Player.GetSpellRank("Conjure Food")]);
                }
                else
                {
                    Player.Eat();
                }
                //drink
                if (this.Player.ItemCount(WaterName[this.Player.GetSpellRank("Conjure Water")]) >= 1)
                {
                    this.Player.Drink(WaterName[this.Player.GetSpellRank("Conjure Water")]);
                }
                else
                {
                    Player.Drink();
                }
                //mana gem
                if (this.Player.ItemCount(manaGemNames[0]) != 1 && this.Player.CanUse("Conjure " + manaGemNames[0]))
                {
                    this.Player.Cast("Conjure " + manaGemNames[0]);
                }
            }

        }

        //buffs
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
                if (this.Player.GetSpellRank("Ice Armor") != 0)
                {
                    if (!this.Player.GotBuff("Ice Armor"))
                    {
                        this.Player.Cast("Ice Armor");
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
            if (this.Player.GetSpellRank("Dampen Magic") != 0 && useDampenMagic)
            {
                if (!this.Player.GotBuff("Dampen Magic"))
                {
                    this.Player.Cast("Dampen Magic");
                    return false;
                }
            }
            if (this.Player.ItemCount(manaGemNames[0]) != 1 && this.Player.CanUse("Conjure " + manaGemNames[0]))
            {
                this.Player.Cast("Conjure " + manaGemNames[0]);
                return false;
            }
            //True means we are done buffing, or cannot buff
            return true;
        }

        //cheked each fight loop for the best fight state
        private fightingStateEnum GetFightingState()
        {
            if (Target.DistanceToPlayer <= 7)
            {
                return fightingStateEnum.FrostNovaToBlink;
            }
            else if (this.Player.HealthPercent <= 15)
            {
                return fightingStateEnum.LowPlayerHealth;
            }
            else if (this.Player.ManaPercent <= 10)
            {
                return fightingStateEnum.LowPlayerMana;
            }
            else
            {
                return fightingStateEnum.Bursting;
            }
        }

        //runs all Zzukbot checks for a spell cast. Saves time.
        public bool CheckIfUseableFull(string spellName)
        {
            if (this.Player.GetSpellRank(spellName) != 0 && this.Player.CanUse(spellName))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

    }
}
