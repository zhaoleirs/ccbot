    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading;
    using System.Threading.Tasks;
    using ZzukBot.Engines.CustomClass;
    using ZzukBot.Engines.CustomClass.Objects;


    namespace Bokutox
    {
       // This is a modified EmuMage & TwinRovaMage for leveling as frost. Credit goes to Emu&TwinRova for the original script. Credits to PhoenixWarlock as well.
       public class Bokutox : CustomClass
       {
          //Edit to true if you want these spells
          bool useManaShield = true;
          bool useDampenMagic = true;
          bool useIceBlock = true;
          bool useCounterSpell = true;
          bool useBlink = true;
          //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

          //This enum will be used later in the fight loop to improve the class greatly.
          enum fightingStateEnum {Bursting, LowPlayerHealth, LowPlayerMana, LowTargetHealth, FrostNovaToBlink, Polymorphing, AoEPull, RunAway, EnemyFlee};

          fightingStateEnum fightState = fightingStateEnum.Bursting;

          private string[] WaterName = {"", "Conjured Water", "Conjured Fresh Water",
                                  "Conjured Purified Water", "Conjured Spring Water",
                                  "Conjured Mineral Water", "Conjured Sparkling Water",
                                  "Conjured Crystal Water"};
                                  
          private string[] FoodName = {"", "Conjured Muffin", "Conjured Bread",
                                  "Conjured Rye", "Conjured Pumpernickel",
                                  "Conjured Sourdough", "Conjured Sweet Roll",
                                  "Conjured Cinnamon Roll"};

          private string[] ManaGem = {"Mana Agate","Mana Jade","Mana Citrine","Mana Ruby"};


          //Mage Class
          public override byte DesignedForClass
          {
             get
             {
                return PlayerClass.Mage;
             }
          }

		  
          //CustomClass name
          public override string CustomClassName
          {
             get
             {
                return "Bokutox 1-35";
             }
          }

		  
          //Prefight
          public override void PreFight()
          {
             this.Player.Attack();
             this.SetCombatDistance(31);
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

			 // ** Change 1st And 3rd "Frostbolt" TO -- "Fireball" to Make bot Cast Fireball FIRST (Visa Versa)
			 
             if (this.Player.GetSpellRank("Fireball") == 0)
             {
                this.Player.Cast("Fireball");
             }
             else
             {
                this.Player.Cast("Fireball");
             }
          }

		  
          //FIGHT!
          public override void Fight()
          {

             bool canWand = this.Player.IsWandEquipped();

             if (!canWand)
             {
                Player.Attack();
             }
               
             //Mana Gem
             if (this.Player.ManaPercent < 25)
             {
                this.Player.UseItem("Mana Agate");
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
			 
             //Wand
             if (this.Player.ManaPercent < 10 || Target.HealthPercent < 10)
             {
                if (canWand && this.Player.IsCasting != "Shoot" && this.Player.IsChanneling != "Shoot")
                {
                   this.Player.StartWand();
                   return;
                }
             }
             
			 
		     //Blink on CC
             if (this.Player.GotDebuff("Frost Nova") && this.Target.GotDebuff("Frost Nova") 
		     || this.Player.GotDebuff("Tendon Rip") && this.Target.GotDebuff("Frost Nova") 
		     || this.Player.GotDebuff("Entangling Roots") && this.Target.GotDebuff("Frost Nova") 
			 || this.Player.GotDebuff("Web") && this.Target.GotDebuff("Frost Nova") 
			 || this.Player.GotDebuff("Kidney Shot") || this.Player.GotDebuff("Intercept Stun") 
			 || this.Player.GotDebuff("Freezing Trap") || this.Player.GotDebuff("Intimidation")
			 || this.Player.GotDebuff("Hammer of Justice") || this.Player.GotDebuff("Stun")
			 || this.Player.GotDebuff("Pounce") || this.Player.GotDebuff("Repentance")
			 || this.Player.GotDebuff("Sap") || this.Player.GotDebuff("Charge Stun")
			 || this.Player.GotDebuff("Pounce") || this.Player.GotDebuff("Repentance"))
             {
                if (this.Player.CanUse("Blink") && useBlink)
                {
                   this.Player.Cast("Blink");
                }
             }
             
			 
             //Counterspell
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
             //Fire Ward
             if (this.Target.isCasting = "Fireball" || this.Target.isCasting = "Scorch" || this.Target.isCasting = "Searing Pain")
             {
                if (this.Player.GetSpellRank("Fire Ward")  != 0)
                {
                   if (this.Player.CanUse("Fire Ward"))
                   {
                      this.Player.Cast("Fire Ward");
                      return;
                   }
                }
             }
             
			 
             //Frost Ward
             if (this.Target.isCasting = "Frostbolt")
             {
                if (this.Player.GetSpellRank("Frost Ward")  != 0)
                {
                   if (this.Player.CanUse("Frost Ward"))
                   {
                      this.Player.Cast("Frost Ward");
                      return;
                   }
                }
             }
             */
             
			 
			 //mana shield
             if (this.Player.HealthPercent <= 10 && !this.Player.GotBuff("Mana Shield") && useManaShield)
             {
                 if (this.Player.GetSpellRank("Mana Shield") != 0)
                 {
                     this.Player.Cast("Mana Shield");
                 } 
             }

			
             //Ice Block
             if (this.Player.HealthPercent <= 15 && this.Player.CanUse("Ice Block") && useIceBlock)
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

			 
             /*
             //Sheep add
             if (Attackers.Count > 1)
             {            
                int LowerHP = this.Attackers.Min(Mob => Mob.HealthPercent);
                var LowerHPUnit = this.Attackers.SingleOrDefault(Mob => Mob.HealthPercent == LowerHP);

                int HigherHp = this.Attackers.Max(Mob => Mob.HealthPercent);
                var HigherHpUnit = this.Attackers.SingleOrDefault(Mob => Mob.HealthPercent == HigherHp);
                if(HigherHpUnit != null && !HigherHpUnit.GotDebuff("Polymorph") && HigherHpUnit.Guid != this.Target.Guid)
                {
                   this.Player.SetTargetTo(HigherHpUnit);
                   if(!this.Target.GotDebuff("Polymorph") && this.Player.GetSpellRank("Polymorph") != 0 && this.Player.CanUse("Polymorph"))
                   {
                      this.Player.Cast("Polymorph");
                   }
                   this.Player.SetTargetTo(LowerHPUnit);
                }
             }
             */
			 
             
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
                   bool res = Player.ForceBackup(8);
                }
             }
             else
             {
                Player.StopForceBackup();
             }
             
             /*
             //Backup from Frostbite
             if (this.Target.GotDebuff("Frostbite") && this.Target.DistanceToPlayer <=5)
             {
                bool res = Player.ForceBackup(8);
             }
             else
             {
                Player.StopForceBackup();
             }
             */

			 
             //Cone of Cold as finisher if 2+ mobs
             if (this.Player.GetSpellRank("Cone of Cold") != 0 && this.Target.DistanceToPlayer <= 10 && this.Target.HealthPercent < 28 && this.Attackers.Count > 1)
             {
                if (this.Player.CanUse("Cone of Cold"))
                {
                   this.Player.Cast("Cone of Cold");
                   return;
                }
             }

			 
             //Fire Blast as finisher
             if (this.Player.GetSpellRank("Fire Blast") != 0 && this.Target.DistanceToPlayer <= 20 && this.Target.HealthPercent > 28)
             {
                if (this.Player.CanUse("Fire Blast"))
                {
                   this.Player.Cast("Fire Blast");
                   return;
                }
             }         

			 
			 //Frost Nova Burst
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
                     
					 
             //Frost Nova
             if (this.Player.CanUse("Frost Nova") && this.Target.DistanceToPlayer <= 10 && this.Target.HealthPercent >= 28 && !this.Target.GotDebuff("Frost Nova") 
			 && !this.Target.GotDebuff("Frostbite"))
             {
                this.Player.Cast("Frost Nova");
                return;
             }
			 
			 
             //Coldsnap if Frost Nova is on CD and HP is low
             else if (this.Player.CanUse("Frost Nova") == false && this.Target.DistanceToPlayer <= 5 && this.Target.HealthPercent >= 28 
			 && this.Player.CanUse("Cold Snap") && this.Player.HealthPercent <= 40 && !this.Target.GotDebuff("Frost Nova"))
             {
                this.Player.Cast("Cold Snap");
                return;
             }

			 
             //Spam Frostbolt, if  not Scorch or Fireball
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
                else if (this.Player.CanUse("Scorch"))
                {
                   this.Player.Cast("Scorch");
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
	
		  // Rest
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

                 if (this.Player.ItemCount(FoodName[this.Player.GetSpellRank("Conjure Food")]) >= 5)
                 {
                     this.Player.Eat(FoodName[this.Player.GetSpellRank("Conjure Food")]);
                 }
                 else
                 {
                     Player.Eat();
                 }
                 if (this.Player.ItemCount(WaterName[this.Player.GetSpellRank("Conjure Water")]) >= 5)
                 {
                     this.Player.Drink(WaterName[this.Player.GetSpellRank("Conjure Water")]);
                 }
                 else
                 {
                     Player.Drink();
                 }
			 }
         }
          
          //Buffs
          public override bool Buff()
          {

             if (this.Player.IsCasting != "")
                return false;
			
			 // Conjure Water
             if (this.Player.GetSpellRank("Conjure Water") != 0)
             {
                if (this.Player.ItemCount(WaterName[this.Player.GetSpellRank("Conjure Water")]) <= 5)
                {
                   this.Player.Cast("Conjure Water");
                   return false;
                }
             }
			 
			 // Conjure Food
             if (this.Player.GetSpellRank("Conjure Food") != 0)
             {
                if (this.Player.ItemCount(FoodName[this.Player.GetSpellRank("Conjure Food")]) <= 5)
                {
                   this.Player.Cast("Conjure Food");
                   return false;
                }
             }
			 
			 // Mage ARMOR Buffs ( Change "Mage" to whatever armor you want for the bot to cast it.)
             if (this.Player.GetSpellRank("Ice Armor") != 0)
             {
                if (!this.Player.GotBuff("Ice Armor"))
                {
                   this.Player.Cast("Ice Armor");
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
             if (this.Player.GetSpellRank("Dampen Magic") != 0 && useDampenMagic)
             {
                if (!this.Player.GotBuff("Dampen Magic"))
                {
                   this.Player.Cast("Dampen Magic");
                   return false;
                }
             }
             
             if (this.Player.ItemCount("Mana Agate") == 0)
             {
                if (this.Player.TryCast("Conjure Mana Agate") && this.Player.ItemCount("Mana v") == 0)
                {
                   this.Player.Cast("Conjure Mana Agate");
                   return false;
                }
             }
             
             if (this.Player.GetSpellRank("Ice Barrier") != 0)
             {
                if (!this.Player.GotBuff("Ice Barrier"))
                {
                   if (this.Player.CanUse("Ice Barrier"))
                   {
                      this.Player.Cast("Ice Barrier");
                      return false;
                   }
                }
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

          public void CreateManaGem()
          {
             if(this.Player.TryCast("Conjure Mana Ruby") && this.Player.ItemCount("Mana Ruby") == 0)
             {
                this.Player.Cast("Conjure Mana Ruby");
             }
             else if(this.Player.TryCast("Conjure Mana Citrine") && this.Player.ItemCount("Mana Citrine") == 0)
             {
                this.Player.Cast("Conjure Mana Citrine");
             }
             else if(this.Player.TryCast("Conjure Mana Jade") && this.Player.ItemCount("Mana Jade") == 0)
             {
                this.Player.Cast("Conjure Mana Jade");
             }
             else if(this.Player.TryCast("Conjure Mana Agate") && this.Player.ItemCount("Mana Agate") == 0)
             {
                this.Player.Cast("Conjure Mana Agate");
             }
          }
          
          public void UseManaGem()
          {
             if(this.Player.ItemCount(this.Player.GetLastItem(ManaGem)) != 0)
             {
                this.Player.UseItem(this.Player.GetLastItem(ManaGem));
             }
          }
       }
    }