        using System;
        using System.Linq;
        using System.Collections.Generic;
        using System.Text;
        using System.Threading.Tasks;
        using ZzukBot.Engines.CustomClass;

        namespace something
        {
            public class PhoenixHunter : CustomClass
            {
                private string[] Ammo = {"Rough Ammo","Sharp Arrow","Razor Arrow","Feathered Arrow","Precision Arrow","Jagged Arrow","Ice Threaded Arrow","Thorium Headed Arrow","Doomshot","Wicked Arrow","Ligth Shot","Flash Pellet","Heavy Shot","Smooth Pebble","Crafted Heavy Shot","Solid Shot","Crafted Solid Shot","Exploding Shot","Hi-Impact Mithril Slugs","Accurate Slugs","Mithril Gyro-Shots","Ice Threaded Bullet","Thorium Shells","Rockshard Pellets","Miniature Cannon Balls","Impact Shot"};
               
                private int[] MPMana = {0, 50, 90, 155, 225, 300, 385, 480};
               
                private bool buff = false;
               
                private string PetFamily()
                {
                    Player.DoString("creatureFamily = UnitCreatureFamily('pet'); if creatureFamily == nil then creatureFamily = 'NONE' end");
                    return Player.GetText("creatureFamily");
                }
                                   
                private string [] MeatFoodName = {"Crisp Spider Meat","Lean Wolf Flank",
                                    "Lion Meat","Tough Jerky", "Haunch of Meat",
                                   "Mutton Chop", "Wild Hog Shank",
                                   "Cured Ham Steak", "Roasted Quail",
                                   "Smoked Talbuk Venison", "Stringy Wolf Meat",
                                   "Lynx Meat", "Meaty Bat Wing",
                                   "Chunk of Boar Meat", "Stringy Vulture Meat",
                                   "Strider Meat", "Kodo Meat",
                                   "Coyote Meat", "Bear Meat",
                                   "Crawler Meat", "Clam Meat",
                                   "Crocolisk Meat", "Tough Condor Meat",
                                   "Big Bear Meat", "Tangy Clam Meat",
                                   "Stag Meat", "Lion Meat",
                                   "Tender Crocolisk Meat", "Mystery Meat",
                                   "Red Wolf Meat", "Tiger Meat",
                                   "Turtle Meat", "Heavy Kodo Meat",
                                   "Giant Clam Meat", "Tender Wolf Meat",
                                   "Tender Crab Meat", "White Spider Meat",
                                   "Zesty Clam Meat", "Sandworm Meat",
                    "Mystery Meat","Raptor Flesh"};
                                   
                private string [] CheeseFoodName = {"Darnassian Bleu", "Dalaran Sharp",
                                   "Spiced Onion Cheese", "Dwarven Mild",
                                   "Stormwind Brie", "Fine Aged Cheddar",
                                   "Alterac Swiss"};
                                   
                private string [] FruitFoodName = {"Shiny Red Apple",
                                   "Tel'Abim Banana", "Snapvine Watermelon",
                                   "Goldenbark Apple", "Heaven Peach",
                                   "Moon Harvest Pumpkin", "Deep Fried Plantains"};
               
                private string [] FishFoodName = {"Longjaw Mud Snapper","Slitherskin Mackerel",
                                   "Bristle Whisker Catfish", "Rockscale Cod",
                                   "Striped Yellowtail", "Spinefin Halibut"};
               
                private string[] BreadFoodName = {"Tough Hunk of Bread", "Freshly Baked Bread",
                                   "Moist Cornbread", "Mulgore Spice Bread",
                                   "Soft Banana Bread", "Homemade Cherry Pie",
                                   "Conjured Muffin", "Conjured Bread",
                                   "Conjured Rye", "Conjured Pumpernickle",
                                   "Conjured Sourdough", "Conjured Sweet Roll"};
                                   
                private string[] FungusFoodName = {"Forest Mushroom Cap", "Red-speckled Mushroom",
                                   "Spongy Morel","Delicious Cave Mold",
                                   "Raw Black Truffle", "Dried King Bolete"};
                                   
                                   
                public override byte DesignedForClass
                {
                    get
                    {
                        return PlayerClass.Hunter;
                    }
                }
               
                public override string CustomClassName
                {
                    get
                    {
                        return "Phoenix Hunter";
                    }
                }
             
                 
                public override bool Buff()
                {
                   
                    //10-60
                    if(this.Player.GetSpellRank("Call Pet") != 0)
                    {
                        if(!this.Player.GotPet())
                        {
                            this.Pet.Call();
                            return false;
                        }
                        else
                        {
                            if(!this.Pet.IsAlive())
                            {
                                this.Pet.Revive();
                                return false;
                            }
                        }
                        if(this.Pet.HealthPercent <= 60 && this.Player.GetSpellRank("Mend Pet") != 0 && this.Player.CanUse("Mend Pet") && !(this.Player.IsChanneling == "Mend Pet") && this.Player.Mana >= MPMana[this.Player.GetSpellRank("Mend Pet")])
                        {
                           this.Player.CastWait("MendPet",500);
                           return false;
                        }
                    }               
                    if(this.Player.GetSpellRank("Aspect of the Cheetah") != 0 && this.Player.CanUse("Aspect of the Cheetah") && !this.Player.GotBuff("Aspect of the Cheetah") && buff == false)
                    {
                        this.Player.Cast("Aspect of the Cheetah");
                        buff = true;
                        return false;
                    }
                    return true;
                }
               
                public override void PreFight()
                {
                      if (this.Target.DistanceToPlayer > 30)
                      {
                         this.SetCombatDistance(25);
                      }
                      if(this.Player.ItemCount(this.Player.GetLastItem(Ammo)) >= 5)
                      {
                            if(this.Player.GetSpellRank("Aspect of the Hawk") != 0 && !this.Player.GotBuff("Aspect of the Hawk"))
                            {
                                this.Player.Cast("Aspect of the Hawk");
                            }
                      }
                      //Low Level when you don't have Aspect of the Hawk or Not enougth Ammo.
                      if(this.Player.GetSpellRank("Aspect of the Monkey") != 0 && !this.Player.GotBuff("Aspect of the Hawk") && !this.Player.GotBuff("Aspect of the Monkey"))
                      {
                            this.Player.Cast("Aspect of the Monkey");
                      } 
                      if(this.Player.GetSpellRank("Hunter's Mark") != 0 && this.Player.CanUse("Hunter's Mark") && this.Player.ItemCount(this.Player.GetLastItem(Ammo)) != 0 && !this.Target.GotDebuff("Hunter's Mark"))
                      {
                          this.Player.Cast("Hunter's Mark");
                      }
                      //1-10
                      if(!this.Player.GotPet())
                      {
                          if(this.Player.ItemCount(this.Player.GetLastItem(Ammo)) >= 5)
                          {
                                if(this.Player.GetSpellRank("Concussive Shot") != 0 && this.Player.CanUse("Concussive Shot"))
                                {
                                    this.Player.Cast("Concussive Shot");
                                }
                                else if(this.Player.GetSpellRank("Serpent Sting") != 0 && this.Player.CanUse("Serpent Sting"))
                                {
                                    this.Player.Cast("Serpent Sting");
                                }
                          }
                          else
                          {
                              this.SetCombatDistance(4);
                              this.Player.Attack();
                          }
                      }
                      //10-60
                      else
                      {
                          this.Pet.Attack();
                      } 
                }
               
                public override void Fight()
                {
                   
                      buff = false;
                      //AVOID REVIVE PET CASTING BREAKS
                      if (this.Player.IsCasting == "Revive Pet")
                      {
                         return;
                      }
                    //1-10
                    if(this.Player.GetSpellRank("Call Pet") == 0)
                    {
                        if(this.Attackers.Count > 1 || ( this.Player.HealthPercent < 20 && this.Target.HealthPercent > 60))
                        {
                            Player.ForceBackup(50);
                        }
                        //Target too close
                        if(this.Target.DistanceToPlayer <= 8 && this.Player.ItemCount(this.Player.GetLastItem(Ammo)) <= 5)
                        {
                            this.SetCombatDistance(4);
                            if(this.Player.GetSpellRank("Aspect of the Monkey") != 0 && !this.Player.GotBuff("Aspect of the Monkey"))
                            {
                                this.Player.Cast("Aspect of the Monkey");
                            }
                            this.Player.Cast("Raptor Strike");
                        }
                        //Target Range
                        else
                        {
                               this.SetCombatDistance(30);
                               if(this.Player.GetSpellRank("Serpent Sting") != 0 && this.Player.CanUse("Serpent Sting"))
                               {
                                   this.Player.Cast("Serpent Sting");
                               }
                               this.Player.RangedAttack();
                        }                   
                    }
                    //10-60
                    else
                    {
                        if((this.Attackers.Count > 1 && !this.Pet.IsAlive()) || (this.Attackers.Count > 1 && this.Pet.HealthPercent < 10) || (!this.Pet.IsAlive() && this.Player.HealthPercent < 20 && this.Target.HealthPercent > 60))
                        {
                            if(this.Player.GetSpellRank("Feign Death") != 0 && this.Player.CanUse("Feign Death"))
                            {
                                this.Player.Cast("Feign Death");
                                return;
                            }
                            else
                            {
                                Player.ForceBackup(35);
                            }
                        }
                        if (this.Attackers.Count >= 2 && this.Pet.IsAlive())
                        {
                            //MAKES THE PET ATTACK THE MOB WHO IS ATTACKING THE TOON
                            var UnitToAttack = this.Attackers.FirstOrDefault(Mob => Mob.TargetGuid == this.Player.Guid);
                            if (UnitToAttack != null)
                            {
                                this.Player.SetTargetTo(UnitToAttack);
                                if (!this.Pet.IsOnMyTarget())
                                {
                                    this.Pet.Attack();
                                }
                            }
                            //END
                            //IF ALL THE MOBS ARE ATTACKING THE PET FOCUS THE LOWER HP ONE
                            else
                            {
                                int LowerHP = this.Attackers.Min(Mob => Mob.HealthPercent);
                                var LowerHPUnit = this.Attackers.SingleOrDefault(Mob => Mob.HealthPercent == LowerHP);
                                if (LowerHPUnit != null && LowerHPUnit.Guid != this.Target.Guid)
                                {
                                    this.Player.SetTargetTo(LowerHPUnit);
                                }
                            }
                            //END
                         }
                        //Avoid to break Mend Pet
                        if(this.Player.IsChanneling == "Mend Pet")
                        {
                            return;
                        }
                       
                        if(this.Pet.HealthPercent <= 40 && this.Player.GetSpellRank("Mend Pet") != 0 && this.Player.CanUse("Mend Pet") && !(this.Player.IsChanneling == "Mend Pet") && this.Player.Mana >= MPMana[this.Player.GetSpellRank("Mend Pet")])
                        {
                           if (this.Pet.DistanceToPlayer >= 20)
                           {
                                    this.SetCombatDistance(18);
                           }
                           this.Player.CastWait("Mend Pet",500);
                           return;
                        }
                       
                        //Pet Tanking
                        if(this.Pet.IsTanking()  && this.Player.ItemCount(this.Player.GetLastItem(Ammo)) > 0)
                        {
                            this.SetCombatDistance(34);
                        //Target Range
                        if(!this.Player.ToCloseForRanged)
                        {
                                if(this.Player.ItemCount(this.Player.GetLastItem(Ammo)) >= 5)
                                {
                                    if(this.Player.GetSpellRank("Aspect of the Hawk") != 0 && !this.Player.GotBuff("Aspect of the Hawk"))
                                    {
                                        this.Player.Cast("Aspect of the Hawk");
                                    }
                                }
                                if(this.Player.GetSpellRank("Serpent Sting") != 0 && this.Player.CanUse("Serpent Sting") && !this.Target.GotDebuff("Serpent Sting"))
                                {
                                    this.Player.Cast("Serpent Sting");
                 }
                                if (this.Player.ManaPercent >= 25 && this.Player.GetSpellRank("Arcane Shot") != 0 && this.Player.CanUse("Arcane Shot"))
                                {
                                    this.Player.Cast("Arcane Shot");
                                }
                                if (this.Player.ManaPercent <= 90 && this.Player.GetSpellRank("Bestial Wrath") != 0 && this.Player.CanUse("Bestial Wrath"))
                                {
                                this.Player.Cast("Bestial Wrath");
                                }
                                if(this.Attackers.Count > 1)
                                {
                                    if(this.Player.GetSpellRank("Multi-Shot") != 0 && this.Player.CanUse("Multi-Shot") && this.Player.ManaPercent > 60)
                                    {
                                        this.Player.Cast("Multi-Shot");
                                    }
                                    else if(this.Player.GetSpellRank("Rapid Fire") != 0 && this.Player.CanUse("Rapid Fire"))
                                    {
                                        this.Player.Cast("Rapid Fire");
                                    }
                                }
                                this.Player.RangedAttack();
                        }
                         else
                         {
                              if(!Player.Backup(14))
                              {
                                   if (this.Target.DistanceToPlayer <= 8)
                                   {
                                       this.SetCombatDistance(2);
                                       if(this.Player.GetSpellRank("Mongoose Bite") != 0 && this.Player.CanUse("Mongoose Bite"))
                                       {
                                            this.Player.Cast("Mongoose Bite");
                                       }
                                       if(this.Player.CanUse("Raptor Strike"))
                                       {
                                            this.Player.Cast("Raptor Strike");
                                        }
                                        this.Player.Attack();
                                    }
                              }
                              else
                              {
                                      if(this.Player.ItemCount(this.Player.GetLastItem(Ammo)) >= 5)
                                        {
                                            if(this.Player.GetSpellRank("Aspect of the Hawk") != 0 && !this.Player.GotBuff("Aspect of the Hawk"))
                                            {
                                                this.Player.Cast("Aspect of the Hawk");
                                            }
                                        }
                              }
                          }
                        }
                          //Melee Range
                          else
                          {
                                if(this.Player.GetSpellRank("Intimidation") != 0 && this.Player.CanUse("Intimidation"))
                                {
                                    this.Player.Cast("Intimidation");
                                    return;
                                }
                                if(this.Player.ItemCount(this.Player.GetLastItem(Ammo)) > 0)
                                {
                                    if(this.Player.GetSpellRank("Disengage") != 0 && this.Player.CanUse("Disengage"))
                                    {
                                      this.Pet.Attack();
                                      this.SetCombatDistance(2); 
                                      this.Player.Cast("Disengage");
                                      return;
                                    }
                                }
                                //Melee Routine Attack
                                this.SetCombatDistance(2);   
                                if(this.Player.GetSpellRank("Aspect of the Monkey") != 0 && !this.Player.GotBuff("Aspect of the Monkey"))
                                {
                                   this.Player.Cast("Aspect of the Monkey");
                                }
                                if(this.Player.GetSpellRank("Mongoose Bite") != 0 && this.Player.CanUse("Mongoose Bite"))
                                {
                                    this.Player.Cast("Mongoose Bite");
                                }
                                if(this.Player.CanUse("Raptor Strike"))
                                 {
                                     this.Player.Cast("Raptor Strike");
                                 }
                                   this.Player.Attack();
                           }
                   
                }
                }
               
               
                public override void Rest()
                {
                    buff = false;
                    if(this.Player.IsCasting != "" || this.Player.IsChanneling != "")
                    {
                        return;
                    }
                    this.Player.DoString("DoEmote('Sit')");
                    this.Player.Drink();
                    this.Player.Eat();
                }
               
                            //API doesn't currently support custom pet food - this is a workaround
                public void Feed(String food)
                {
                    string luaCheckFeed = "CanFeedMyPet = 0; if CursorHasSpell() then CanFeedMyPet = 1 end;";
                    string luaFeedPet = "CastSpellByName('Feed Pet'); TargetUnit('Pet');";
                    string UsePetFood1 = "for bag = 0,4 do for slot = 1,GetContainerNumSlots(bag) do local item = GetContainerItemLink(bag,slot) if item then if string.find(item, '";
                    string UsePetFood2 = "') then PickupContainerItem(bag,slot) break end end end end";
                    if (!Pet.GotBuff("Feed Pet Effect"))
                    {
                        if (Player.ItemCount(food) != 0)
                        {
                            Player.DoString(luaCheckFeed);
                            if (Player.GetText("CanFeedMyPet").Trim().Contains("0"))
                            {
                                Player.DoString(luaFeedPet);
                            }
                            Player.DoString(UsePetFood1 + food.Replace("'", "\\'") + UsePetFood2);
                        }
                    }
                    Player.DoString("ClearCursor()");
                }
               
                public void FeedPet()
                {
                        string PetSpecies = PetFamily();
                        string food = "";
                        if(PetSpecies == "Cat" || PetSpecies == "Carrion Bird" || PetSpecies == "Crocolisk")
                        {
                            food = this.Player.GetLastItem(MeatFoodName);
                            if(food == String.Empty)
                            {
                                food = this.Player.GetLastItem(FishFoodName);
                            }
                        }
                        else if (PetSpecies == "Bat" || PetSpecies == "Gorilla")
                        {
                            food = this.Player.GetLastItem(FruitFoodName);
                            if(food == String.Empty)
                            {
                                food = this.Player.GetLastItem(FungusFoodName);
                            }
                        }
                        else if (PetSpecies == "Bear")
                        {
                            food = this.Player.GetLastItem(BreadFoodName);
                            if(food == String.Empty)
                            {
                                food = this.Player.GetLastItem(CheeseFoodName);
                                if(food == String.Empty)
                                {
                                    food = this.Player.GetLastItem(FruitFoodName);
                                    if(food == String.Empty)
                                    {
                                        food = this.Player.GetLastItem(FungusFoodName);
                                        if(food == String.Empty)
                                        {
                                            food = this.Player.GetLastItem(MeatFoodName);
                                        }
                                    }
                                }
                            }
                           
                        }
                        else if (PetSpecies == "Boar")
                        {
                            food = this.Player.GetLastItem(BreadFoodName);
                            if(food == String.Empty)
                            {
                                food = this.Player.GetLastItem(CheeseFoodName);
                                if(food == String.Empty)
                                {
                                    food = this.Player.GetLastItem(FruitFoodName);
                                    if(food == String.Empty)
                                    {
                                        food = this.Player.GetLastItem(FungusFoodName);
                                        if(food == String.Empty)
                                        {
                                            food = this.Player.GetLastItem(MeatFoodName);
                                            if(food == String.Empty)
                                            {
                                                food = this.Player.GetLastItem(FishFoodName);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (PetSpecies == "Crab")
                        {
                            food = this.Player.GetLastItem(BreadFoodName);
                            if(food == String.Empty)
                            {
                                food = this.Player.GetLastItem(FishFoodName);
                                if(food == String.Empty)
                                {
                                    food = this.Player.GetLastItem(FruitFoodName);
                                    if(food == String.Empty)
                                    {
                                       food = this.Player.GetLastItem(FungusFoodName);
                                    }
                                }
                            }
                        }
                        else if (PetSpecies == "Hyena")
                        {
                            food = this.Player.GetLastItem(FruitFoodName);
                            if(food == String.Empty)
                            {
                                food = this.Player.GetLastItem(MeatFoodName);
                            }
                        }
                        else if (PetSpecies == "Owl" || PetSpecies == "Raptor" || PetSpecies == "Scorpid" || PetSpecies == "Spider" || PetSpecies == "Wolf")
                        {
                            food = this.Player.GetLastItem(MeatFoodName);
                        }
                        else if (PetSpecies == "Tallstrider")
                        {
                            food = this.Player.GetLastItem(FruitFoodName);
                            if(food == String.Empty)
                            {
                                food = this.Player.GetLastItem(CheeseFoodName);
                                if(food == String.Empty)
                                {
                                    food = this.Player.GetLastItem(FungusFoodName);
                                }
                            }
                        }
                        else if (PetSpecies == "Turtle")
                        {
                            food = this.Player.GetLastItem(FishFoodName);
                            if(food == String.Empty)
                            {
                                food = this.Player.GetLastItem(FruitFoodName);
                                if(food == String.Empty)
                                {
                                    food = this.Player.GetLastItem(FungusFoodName);
                                }
                            }
                        }
                        else if (PetSpecies == "Wind Serpent")
                        {
                            food = this.Player.GetLastItem(FishFoodName);
                            if(food == String.Empty)
                            {
                                food = this.Player.GetLastItem(BreadFoodName);
                                if(food == String.Empty)
                                {
                                    food = this.Player.GetLastItem(CheeseFoodName);
                                }
                            }
                        }
                        if (food != String.Empty)
                        {
                            if (!Pet.GotBuff("Feed Pet Effect"))
                            {
                                Feed(food);
                            }
                        }
                }
            }
        }