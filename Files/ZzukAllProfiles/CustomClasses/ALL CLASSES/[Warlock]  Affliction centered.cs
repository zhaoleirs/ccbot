    using System;
    using System.Linq;
    using System.Collections.Generic;
    using System.Text;
    using System.Threading.Tasks;
    using ZzukBot.Engines.CustomClass;

    namespace ConsoleApplication1
    {
        class Fedlock : CustomClass
        {
            bool SummonPet = true;

            public override byte DesignedForClass
            {
                get
                {
                    return PlayerClass.Warlock;
                }
            }

            public override string CustomClassName
            {
                get
                {
                    return "Fedlock v1.3.3";
                }
            }

            public override void PreFight()
            {
                this.SetCombatDistance(29);
                if (this.Player.GotPet())
                {
                    this.Pet.Attack();
                }
                //Agony to pull
                if (this.Player.CanUse("Curse of Agony") && this.Player.GetSpellRank("Curse of Agony") != 0)
                {
                    this.Player.CastWait("Curse of Agony", 500);
                }
            }       
           
            public override void Fight()
            {
                // Send our pet to attack (He should already be doing this anyway)
                if (this.Player.GotPet())
                {
                    this.Pet.Attack();
                }
                //Health Stones >>>>MAKE SURE TO SET THIS TO YOUR BEST HEALTHSTONE<<<<<
                if (this.Player.ItemCount("Minor Healthstone") == 1 && this.Player.HealthPercent <= 15 && !this.Target.GotDebuff("Drain Life"))
                {
                    this.Player.UseItem("Minor Healthstone");
                }
                //Sacrifice Pet if he (or I) is getting to low on health >>>>MAKE SURE TO SET THIS TO YOUR BEST HEALTHSTONE<<<<<
                if ((Pet.CanUse("Sacrifice") && Pet.HealthPercent < 7 && Pet.HealthPercent > 0 && this.Player.GotPet()) || (this.Player.HealthPercent <= 7 && Pet.HealthPercent > 0 && this.Player.GotPet() && this.Player.ItemCount("Minor Healthstone") < 1))
                {
                        this.Player.CastWait("Sacrifice", 10000);
                }     
                //Soul Shards, make sure the number of soul shards is the same as the one in the wanding logic
                if (this.Player.ItemCount("Soul Shard") < 3 && this.Target.HealthPercent <= 10)
                {
                    this.Player.CastWait("Drain Soul", 1000);
                }     
                //HANDLE MULTITARGET FIGHTS >>Credit to dgcfus<<
                if (this.Attackers.Count >= 2 && this.Player.GotPet() && Pet.HealthPercent > 0)
                {
                    //MAKES THE PET ATTACK THE MOB WHO IS ATTACKING THE TOON, Casts suffering
                    var UnitToAttack = this.Attackers.FirstOrDefault(Mob => Mob.TargetGuid == this.Player.Guid);
                    if (UnitToAttack != null)
                    {
                        this.Player.SetTargetTo(UnitToAttack);
                        if (!this.Pet.IsOnMyTarget())
                        {
                            this.Pet.Attack();
                            this.Player.Cast("Suffering");
                            //Thanks dgcfus
                        }
                    }
                    //IF ALL THE MOBS ARE ATTACKING THE PET FOCUS THE LOWER HP ONE
                    else
                    {
                        int LowerHP = this.Attackers.Min(Mob => Mob.HealthPercent);
                        var LowerHPUnit = this.Attackers.SingleOrDefault(Mob => Mob.HealthPercent == LowerHP);
                        if (LowerHPUnit != null && LowerHPUnit.Guid != this.Target.Guid)
                        {
                            this.Player.SetTargetTo(LowerHPUnit);
                            //Thanks dgcfus
                        }
                    }
                }
                // Heal Pet
                if (this.Player.IsCasting == "Health Funnel")
                {
                    return;
                }
                else if (Pet.HealthPercent < 40 && Pet.HealthPercent > 0 && this.Player.HealthPercent >= 60 && this.Player.IsCasting == "")
                {
                    if (this.Player.GetSpellRank("Health Funnel") != 0 && !this.Target.GotDebuff("Drain Life") && this.Player.IsChanneling != "Health Funnel" && this.Player.IsCasting != "Health Funnel")
                        {
                            this.Player.CastWait("Health Funnel", 5000);
                        }
                }
                //Nightfall!
                if (this.Player.GotBuff("Shadow Trance"))
                {
                    this.Player.CastWait("Shadow Bolt", 1000);
                }
                //Convenience Life Tap
                if (this.Player.IsCasting == "Drain Soul")
                {
                    return;
                }
                else if (this.Attackers.Count <= 1 && this.Target.HealthPercent <= 10 && this.Player.GotPet() && Pet.HealthPercent > 40 && this.Player.ManaPercent <= 30 && this.Player.GetSpellRank("Life Tap") != 0 && !this.Target.GotDebuff("Drain Life") && this.Player.HealthPercent >= 40)
                {
                    this.Player.Cast("Life Tap");
                }
            //Start DOTs
                //Shadow Bolt if we don't have Immolate
                if (this.Player.GetSpellRank("Immolate") == 0 && this.Player.CanUse("Shadow Bolt") && this.Player.IsCasting == "" && this.Target.HealthPercent >= 80 && this.Player.ManaPercent >= 30)
                {
                    this.Player.CastWait("Shadow Bolt", 2000);
                }
                //Corruption
                if (this.Player.CanUse("Corruption") && this.Player.GetSpellRank("Corruption") != 0 && !this.Target.GotDebuff("Corruption") && !this.Target.GotDebuff("Drain Life") && this.Target.HealthPercent >= 12 && this.Player.ManaPercent >= 10)
                {
                    this.Player.CastWait("Corruption", 500);
                }
                //Agony
                if (this.Player.CanUse("Curse of Agony") && this.Player.GetSpellRank("Curse of Agony") != 0 && !this.Target.GotDebuff("Curse of Agony") && !this.Target.GotDebuff("Drain Life") && this.Target.HealthPercent >= 12 && this.Player.ManaPercent >= 10)
                {
                    this.Player.CastWait("Curse of Agony", 500);
                }
                //SL
                if (this.Player.CanUse("Siphon Life") && this.Player.GetSpellRank("Siphon Life") != 0 && !this.Target.GotDebuff("Siphon Life") && !this.Target.GotDebuff("Drain Life") && this.Target.HealthPercent >= 12 && this.Player.ManaPercent >= 10)
                {
                    this.Player.CastWait("Siphon Life", 500);
                }
                //Drain Life
                if (this.Player.HealthPercent <= 60 && this.Player.ManaPercent >= 20 && !this.Target.GotDebuff("Drain Life") && this.Player.GetSpellRank("Drain Life") != 0 && this.Target.HealthPercent >= 10)
                {
                    this.SetCombatDistance(19);
                    this.Player.CastWait("Drain Life", 1000);
                }
                //Immolate
                if (this.Player.CanUse("Immolate") && this.Player.GetSpellRank("Immolate") != 0 && !this.Target.GotDebuff("Immolate") && !this.Target.GotDebuff("Drain Life") && this.Target.HealthPercent >= 12 && this.Player.ManaPercent >= 10)
                {
                    this.Player.CastWait("Immolate", 500);
                }
                //Necessity Life Tap
                if ((this.Player.CanUse("Life Tap") && this.Player.ManaPercent <= 30 && this.Player.GetSpellRank("Life Tap") != 0 && !this.Target.GotDebuff("Drain Life") && this.Player.HealthPercent >= 60) || (this.Player.ManaPercent <= 80 && this.Player.GetSpellRank("Life Tap") != 0 && !this.Target.GotDebuff("Drain Life") && this.Player.HealthPercent >= 90))
                {
                    this.Player.Cast("Life Tap");
                }
                //Wanding
                if (this.Player.IsCasting == "" && this.Player.IsChanneling == "")
                {
                    bool canWand = this.Player.IsWandEquipped();
                    //Check if we can use immolate just as a GCD tracker.  Set soul shard value to that in drain soul logic.
                    if ((this.Player.CanUse("Immolate") && this.Player.ManaPercent <= 20) || (this.Player.CanUse("Immolate") && this.Player.HealthPercent > 60 && this.Player.ManaPercent > 30 && this.Target.GotDebuff("Immolate") && this.Target.GotDebuff("Corruption") && this.Target.GotDebuff("Curse of Agony")) || (this.Player.CanUse("Immolate") && this.Player.ItemCount("Soul Shard") == 3 && this.Target.HealthPercent < 12 && this.Attackers.Count <= 1) || this.Player.GetSpellRank("Curse of Agony") == 0)
                    {
                        if (canWand)
                        {
                            this.Player.StartWand();
                        }
                        else
                        {
                            this.SetCombatDistance(4);
                            this.Player.Attack();
                        }
                    }
                }
            }
           
    //*****▼ ▼ ▼ ▼ ▼ ▼ Remove this if you're buying food/water and plan on having the bot eat/drink ▼ ▼ ▼ ▼ ▼ ▼*****
            public override void Rest()
            {
                if ((this.Player.CanUse("Life Tap") && this.Player.ManaPercent <= 80 && this.Player.HealthPercent >= 80) || (this.Player.CanUse("Life Tap") && this.Player.ManaPercent <= 60 && this.Player.HealthPercent >= 60) || (this.Player.CanUse("Life Tap") && this.Player.ManaPercent <= 30 && this.Player.HealthPercent >= 30) || (this.Player.CanUse("Life Tap") && this.Player.ManaPercent <= 10 && this.Player.HealthPercent >= 10))
                {
                    this.Player.Cast("Life Tap");
                }
               
                else if (Pet.HealthPercent < 40 && Pet.HealthPercent > 0 && this.Player.HealthPercent >= 60 && this.Player.IsCasting == "")
                {
                    if (this.Player.GetSpellRank("Health Funnel") != 0 && !this.Target.GotDebuff("Drain Life") && this.Player.IsChanneling != "Health Funnel" && this.Player.IsCasting != "Health Funnel")
                        {
                            this.Player.CastWait("Health Funnel", 5000);
                        }
                }
            }
    //*****▲ ▲ ▲ ▲ ▲ ▲Remove this if you're buying food/water and plan on having the bot eat/drink ▲ ▲ ▲ ▲ ▲ ▲*****
           
            public override bool Buff()
            {
                if (this.Player.IsCasting == "Summon Voidwalker")
                {
                    return false;
                }
                if (this.Player.IsCasting == "Summon Imp")
                {
                    return false;
                }
                if (this.Player.IsCasting == "Health Funnel")
                {
                    return false;
                }
                if (this.Player.IsCasting == "Create Healthstone (Minor)")
                {         
                    return false;
                }
                if (this.Player.IsCasting == "")
                {
                    if (this.Player.GotPet())
                    {
                        if (Pet.HealthPercent <= 0)
                        {
                            if (this.Player.CanUse("Summon Voidwalker") && this.Player.GetSpellRank("Summon Voidwalker") != 0 && this.Player.ItemCount("Soul Shard") >= 1)
                            {
                                this.Player.Cast("Summon Voidwalker");
                                return false;
                            }
                        }
                    }
                    else           
                    {
                        if (this.Player.CanUse("Summon Voidwalker") && this.Player.GetSpellRank("Summon Voidwalker") != 0 && this.Player.ItemCount("Soul Shard") >= 1)
                        {
                            this.Player.Cast("Summon Voidwalker");
                            return false;
                        }
                        else if (this.Player.CanUse("Summon Imp") && this.Player.GetSpellRank("Summon Imp") != 0)
                        {
                            this.Player.Cast("Summon Imp");
                            return false;
                        }
                        else
                        {
                            return false;   
                        }
                    }
                }
                //Health Stones >>>>MAKE SURE TO SET THIS TO YOUR BEST HEALTHSTONE<<<<<
                if (this.Player.GetSpellRank("Create Healthstone (Minor)") != 0 && this.Player.ItemCount("Minor Healthstone") < 1 && this.Player.ItemCount("Soul Shard") >= 2)
                    {
                        this.Player.Cast("Create Healthstone (Minor)()");
                        return false;
                    }
               
                if (this.Player.CanUse("Demon Armor") && this.Player.GetSpellRank("Demon Armor") != 0)
                {
                    if (!this.Player.GotBuff("Demon Armor"))
                    {
                        this.Player.Cast("Demon Armor");
                        return false;
                    }
                }
                else if (this.Player.CanUse("Demon Skin") && this.Player.GetSpellRank("Demon Skin") != 0)
                {
                    if (!this.Player.GotBuff("Demon Skin"))
                    {
                        this.Player.Cast("Demon Skin");
                        return false;
                    }
                }
                else
                {
                    return false;   
                }
                return true;
            }
        }
    }
