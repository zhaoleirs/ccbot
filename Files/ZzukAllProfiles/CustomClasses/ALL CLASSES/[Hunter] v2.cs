    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Threading.Tasks;
    using ZzukBot.Engines.CustomClass;

    namespace ConsoleApplication1
    {
        public class kallhunter : CustomClass
        {
            bool SummonPet = true;

            private string[] PetFoodName =   {"Tough Jerky", "Haunch of Meat",
                               "Mutton Chop", "Wild Hog Shank",
                               "Cured Ham Steak", "Roasted Quail",
                               "Smoked Talbuk Venison", "Stringy Wolf Meat",
                               "Lynx Meat", "Meaty Bat Wing",
                               "Chunk of Boar Meat", "Stringy Vulture Meat",
                               "Strider Meat", "Kodo Meat",
                               "Coyote Meat", "Bear Meat",
                               "Crawler Meat", "Clam Meat",
                               "Crocolisk Meat", "Tough Condor Meat",
                               "Big Bear meat", "Tangy Clam Meat",
                               "Stag Meat", "Lion Meat",
                               "Tender Crocolisk Meat", "Mystery Meat",
                               "Red Wolf Meat", "Tiger Meat",
                               "Turtle Meat", "Heavy Kodo Meat",
                               "Giant Clam Meat", "Tender Wolf Meat",
                               "Tender Crab Meat", "White Spider Meat",
                               "Zesty Clam Meat", "Sandworm Meat",
                               "Darnassian Bleu", "Dalaran Sharp",
                               "Spiced Onion Cheese", "Dwarven Mild",
                               "Stormwind Brie", "Fine Aged Cheddar",
                               "Alterac Swiss", "Shiny Red Apple",
                               "Tel'Abim Banana", "Snapvine Watermelon",
                               "Goldenbark Apple", "Heaven Peach",
                               "Moon Harvest Pumpkin", "Deep Fried Plantains",
                               "Forest Mushroom Cap", "Red-speckled Mushroom",
                               "Spongy Morel", "Delicious Cave Mold",
                               "Raw Black Truffle", "Dried King Bolete",
                               "Slitherskin Mackerel", "Longjaw Mud Snapper",
                               "Bristle Whisker Catfish", "Rockscale Cod",
                               "Striped Yellowtail", "Spinefin Halibut",
                               "Tough Hunk of Bread", "Freshly Baked Bread",
                               "Moist Cornbread", "Mulgore Spice Bread",
                               "Soft Banana Bread", "Homemade Cherry Pie",
                               "Conjured Muffin", "Conjured Bread",
                               "Conjured Rye", "Conjured Pumpernickle",
                               "Conjured Sourdough", "Conjured Sweet Roll"};

            public override byte DesignedForClass
            {
                get
                {
                    // CustomClass for Hunters
                    return PlayerClass.Hunter;
                }
            }

            public override string CustomClassName
            {
                get
                {
                    // The name of the Custom Class
                    return "SimpleHunter";
                }
            }

            public override void PreFight()
            {
                this.SetCombatDistance(25);
                this.Player.RangedAttack();
                this.Pet.Attack();

                // Target doesnt have Hunters Mark?
                if (Player.GetSpellRank("Hunter's Mark") != 0 && !Target.GotDebuff("Hunter's Mark"))
                {
                    // Cast Hunters Mark
                    this.Player.Cast("Hunter's Mark");
                }

            }

            //Rest Function
            public override void Rest()
            {
                Player.Eat();
                Player.Drink();
                Player.DoString("DoEmote('Sit')");
            }

            public override void Fight()
            {
                // Send our pet to attack
                this.Pet.Attack();

                // If we are 4 yards or closer to the target
                if (this.Target.DistanceToPlayer <= 4)
                {
                    // Cast Raptor Strike and start melee attack
                    this.Player.Cast("Raptor Strike");
                    this.SetCombatDistance(25);
                    this.Player.Attack();
                }
                else
                {
                    // Are we to close for ranged attack?
                    if (Player.ToCloseForRanged)
                    {
                        // Run back til we are 18 yards away
                        if (!Player.Backup(18))
                            // Backup returns false? Means moveback is not possible.
                            // Set our combat range to 3 yards which results in the bot going into melee mod
                            this.SetCombatDistance(3);
                    }
                    // Start ranged attack
                    this.Player.RangedAttack();

                    // Over 10% mana?
                    if (this.Player.ManaPercent >= 10)
                    {
                        // Target got Serpent Sting debuff?
                        if (Player.GetSpellRank("Serpent Sting") != 0 && !this.Target.GotDebuff("Serpent Sting"))
                        {
                            // Cast Serpent Sting
                            this.Player.Cast("Serpent Sting");
                        }
                        // Can we use Arcane Shot?
                        if (Player.GetSpellRank("Arcane Shot") != 0 && this.Player.CanUse("Arcane Shot"))
                        {
                            // Cast Arcane Shot
                            this.Player.Cast("Arcane Shot");
                        }
                        // Can we use Concussive Shot?
                        if (Player.GetSpellRank("Concussive Shot") != 0 && this.Player.CanUse("Concussive Shot"))
                        {
                            // Cast Concussive Shot
                            this.Player.Cast("Concussive Shot");
                        }
                    }
                }
            }

            public override bool Buff()
            {
                // Do we have a pet?
                if (this.Player.GotPet())
                {

                    // Is Pet dead?
                    if (Pet.HealthPercent == 0)
                    {
                        // Revive it. Tell bot we are not buffed (false)
                        Pet.Revive();
                        return false;
                    }

                    if (Pet.HealthPercent <= 50)
                    {
                        // Revive it. Tell bot we are not buffed (false)
                        if (Player.GetSpellRank("Mend Pet") != 0)
                        {
                            Player.CastWait("Mend Pet", 500);
                        }
                        return false;
                    }

                    // Is our pet not happy?
                    if (!this.Pet.IsHappy())
                    {
                        //Do we have food set in UI?
                        if (Pet.GotPetFood)
                        {
                            // Is pet 'eating'?
                            if (!Pet.GotBuff("Feed Pet Effect"))
                            {
                                this.Pet.Feed();
                            }
                            // tell the bot we are not buffed
                            return false;
                        }
                        else // If we don't have food set in the UI
                        {
                            string food = this.Player.GetLastItem(PetFoodName);
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
                else
                {
                    if (SummonPet)
                    {
                        // we dont have a pet? call it
                        Pet.Call();
                        return false;
                    }
                }
                // We dont have aspect of the hawk?
                if (Player.GetSpellRank("Aspect of the Hawk") != 0 && !Player.GotBuff("Aspect of the Hawk"))
                {
                    // use it
                    Player.Cast("Aspect of the Hawk");
                    return false;
                }
                return true;
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
        }

    }