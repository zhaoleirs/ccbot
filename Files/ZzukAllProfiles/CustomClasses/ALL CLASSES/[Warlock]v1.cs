           using System;
        using System.Collections.Generic;
        using System.Linq;
        using System.Text;
        using System.Threading;
        using System.Threading.Tasks;
        using ZzukBot.Engines.CustomClass;
        using ZzukBot.Engines.CustomClass.Objects;

        namespace PhoenixWarlock
        {
            public class PhoenixWarlock : CustomClass
            {
               
                private bool handleaggrofear = false;
               
                private bool petfightfirst = true;
               
                private string[] Healthstone = {"Minor Healthstone","Lesser Healthstone","Healthstone",
                "Minor Healthstone","Greater Healthstone","Major Healthstone"};
               
                private string[] Soulstone = {"Minor Soulstone","Lesser Soulstone","Soulstone",
                "Greater Soulstone","Major Soulstone"};
               
                private bool curseofagony = false;
               
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
                        return "PhoenixWarlock";
                    }
                }
               
                private int CharacterLevel()
                {
                    Player.DoString("Unitlevel = UnitLevel('player');");
                    int Levelcharacter = Int32.Parse(Player.GetText("Unitlevel"));
                    return Levelcharacter;
                }
               
                private int NumberSoulShards()
                {
                    int NumberSoulShard = this.Player.ItemCount("Soul Shard");
                    return NumberSoulShard;
                }
               
                private bool  RezSS()
                {
                    bool RezSS = Player.GotBuff("Soulstone Resurrection");
                    return RezSS;
                }
               
                private string PetFamily()
                {
                    Player.DoString("creatureFamily = UnitCreatureFamily('pet'); if creatureFamily == nil then creatureFamily = 'NONE' end");
                    return Player.GetText("creatureFamily");
                }
               
                private string CreatureType()
                {
                    Player.DoString("creatureType = UnitCreatureType('target'); if creatureType == nil then creatureType = 'NONE' end");
                    return Player.GetText("creatureType");
                }
               
                public override bool Buff()
                {
                    curseofagony = false;   
                    if(CheckSpell("Demon Armor") && !this.Player.GotBuff("Demon Armor"))
                    {
                        this.Player.Cast("Demon Armor");
                        return false;
                    }
                   
                    if(!this.Player.GotBuff("Demon Armor") && CheckSpell("Demon Skin") && !this.Player.GotBuff("Demon Skin"))
                    {
                        this.Player.Cast("Demon Skin");
                        return false;
                    }
                   
                    if((CheckSpell("Life Tap") && this.Player.ManaPercent < 60 && this.Player.HealthPercent > 70) || (this.Player.HealthPercent == 100) && this.Player.HealthPercent > this.Player.ManaPercent)
                    {
                        this.Player.Cast("Life Tap");
                        return false;
                    }
                   
                    if(PetFamily() != "Voidwalker" && NumberSoulShards() > 0 && CheckSpell("Summon Voidwalker"))
                    {
                        this.Player.Cast("Summon Voidwalker");
                        return false;
                    }
                    if(!this.Player.GotPet() && CheckSpell("Summon Imp"))
                    {
                        this.Player.Cast("Summon Imp");
                        return false;
                    }
                   
                    if(PetFamily() == "Voidwalker" && this.Pet.HealthPercent < 50)
                    {
                        this.Player.Cast("Consume Shadows");
                        return false;
                    }
                   
                    if(NumberSoulShards() > 0)
                    {
                        if(this.Player.ItemCount(this.Player.GetLastItem(Healthstone)) == 0)
                        {
                            CreateHealthstone();
                            return false;
                        }
                    }
                   
                    return true;
                }
               
               
                public override void PreFight()
                {
                    bool canWand = this.Player.IsWandEquipped();
                    this.SetCombatDistance(28);
                    if(petfightfirst && this.Player.GotPet())
                    {
                         this.Pet.Attack();
                    }
                    else
                    {
                       if(canWand)
                       {
                          this.Player.StartWand();
                          return;
                        }
                        else
                        {
                            if(!this.Target.GotDebuff("Immolate"))
                            {
                               this.Player.CastWait("Immolate",1500);
                            }
                         }
                     }
                  }

               
                public override void Fight()
                {
                    bool canWand = this.Player.IsWandEquipped();
                    SetCombatDistance(20);
                   
                    if(!this.Player.GotPet() && this.Player.ManaPercent > 10)
                    {
                        if(CheckSpell("Fel Domination"))
                        {
                            this.Player.CastWait("Fel Domination",180000);
                        }
                        if(NumberSoulShards() > 0)
                        {
                            this.Player.Cast("Summon Voidwalker");
                        }
                        else
                        {
                            this.Player.Cast("Summon Imp");
                        }
                    }
                    else
                    {
                        this.Pet.Attack();
                    }
                   
                    if (this.HandledMultiTargetCombat() == false)
                    {
                        return;
                    }
                   
                    if((CheckSpell("Drain Soul") && (this.Pet.IsTanking() || this.Player.HealthPercent > 50) && this.Target.HealthPercent < 10 && NumberSoulShards() < 10) ||
                    (CheckSpell("Drain Soul") && this.Player.HealthPercent > 60 && this.Target.HealthPercent < 5 && NumberSoulShards() < 10 && (!this.Player.GotPet() || PetFamily() == "Imp")))
                    {
                        this.Player.Cast("Drain Soul");
                        return;
                    }
                   
                    if(this.Player.IsCasting != "" || this.Player.IsChanneling != "")
                    {
                        return;
                    }
                   
                    if(this.Player.HealthPercent < 10 && PetFamily() == "Voidwalker" && this.Target.HealthPercent > this.Player.HealthPercent)
                    {
                        this.Player.CastWait("Sacrifice",10000);
                    }
                   
                    if(this.Player.HealthPercent < 20)
                    {
                        UseHealthstone();
                    }
                   
		     //Health Potion
             if (this.Player.HealthPercent <= 20 && this.Player.ItemCount("Superior Healing Potion") != 0)
             {
                this.Player.UseItem("Superior Healing Potion");
             }
          
             if (this.Player.HealthPercent <= 20 && this.Player.ItemCount("Greater Healing Potion") != 0)
             {
                this.Player.UseItem("Greater Healing Potion");
             }

             if (this.Player.HealthPercent <= 20 && this.Player.ItemCount("Healing Potion") != 0)
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
				   
                    if((this.Player.ManaPercent < 80 && this.Player.HealthPercent > 50 && this.Player.HealthPercent > this.Player.ManaPercent && this.Player.CanUse("Life Tap") && this.Target.HealthPercent > 10 && this.Pet.IsTanking()) || (this.Player.HealthPercent == 100 && this.Player.HealthPercent > this.Player.ManaPercent))
                    {
                        this.Player.Cast("Life Tap");
                    }
                   
                    if(CheckSpell("Health Funnel") && this.Pet.HealthPercent < 10 && this.Player.HealthPercent > 40 && this.Pet.HealthPercent < this.Target.HealthPercent && this.Player.GotPet())
                    {
                        this.Player.Cast("Health Funnel");
                    }
                   
                    if(this.Player.GotBuff("Shadow Trance"))
                    {
                        this.Player.Cast("Shadow Bolt");
                    }
                   
                    if(CheckSpell("Corruption") && !this.Target.GotDebuff("Corruption"))
                    {
                        this.Player.Cast("Corruption");
                    }
                       
                    if(CheckSpell("Curse of Agony") && !this.Target.GotDebuff("Curse of Agony") && curseofagony == false)
                    {
                        this.Player.Cast("Curse of Agony");
                        curseofagony = true;
                    }
                   
                    if(CheckSpell("Drain Life") && this.Target.HealthPercent > 5 && CreatureType() != "Mechanical")
                    {
                        this.Player.Cast("Drain Life");
                    }
                   
                    if((this.Target.HealthPercent > 15 && CreatureType() == "Mechanical") || (!CheckSpell("Drain Life") && CharacterLevel() < 14) && this.Player.CanUse("Shadow Bolt"))
                    {
                        this.Player.Cast("Shadow Bolt");
                    }
                   
                    if(this.Target.HealthPercent < 5 || this.Player.ManaPercent < 10)
                    {
                        if (!canWand && this.Player.ManaPercent > 10)
                        {
                            this.Player.Cast("Shadow Bolt");
                        }
                        else if(!canWand && this.Player.ManaPercent < 10)
                        {
                            this.Player.Attack();
                        }
                        else
                        {
                            this.Player.StartWand();
                            return;
                        }
                    }

                }

               
                public override void Rest()
                {
                     if (this.Player.HealthPercent >= 90 && this.Player.ManaPercent < this.Player.HealthPercent &&
                     this.Player.ManaPercent > 80)
                    {
                        this.Player.Cast("Life Tap");
                        return;
                    }
                    if(this.Pet.HealthPercent < 50 && PetFamily() == "Voidwalker")
                    {
                        this.Player.Cast("Consume Shadows");
                    }
                    this.Player.DoString("DoEmote('Sit')");
                    this.Player.Drink();
                    this.Player.Eat();   
                }

               


               
                public bool CheckSpell(string spellName)
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
               
                public void CreateHealthstone()
                {
                        if(this.Player.TryCast("Create Healthstone (Major)") && this.Player.ItemCount("Major Healthstone") == 0)
                        {
                            this.Player.Cast("Create Healthstone (Major)");
                        }
                        else if(this.Player.TryCast("Create Healthstone (Greater)") && this.Player.ItemCount("Greater Healthstone") == 0)
                        {
                            this.Player.Cast("Create Healthstone (Greater)");
                        }
                        else if(this.Player.TryCast("Create Healthstone") && this.Player.ItemCount("Healthstone") == 0)
                        {
                            this.Player.Cast("Create Healthstone");
                        }
                        else if(this.Player.TryCast("Create Healthstone (Lesser)") && this.Player.ItemCount("Lesser Healthstone") == 0)
                        {
                            this.Player.Cast("Create Healthstone (Lesser)");
                        }
                        else if(this.Player.TryCast("Create Healthstone (Minor)") && this.Player.ItemCount("Minor Healthstone") == 0)
                        {
                            this.Player.Cast("Create Healthstone (Minor)");
                        }
                }
               
                public void CreateSoulstone()
                {
                        if(this.Player.TryCast("Create Soulstone (Major)") && this.Player.ItemCount("Major Soulstone") == 0)
                        {
                            this.Player.Cast("Create Soulstone (Major)");
                        }
                        else if(this.Player.TryCast("Create Soulstone (Greater)") && this.Player.ItemCount("Greater Soulstone") == 0)
                        {
                            this.Player.Cast("Create Soulstone (Greater)");
                        }
                        else if(this.Player.TryCast("Create Soulstone") && this.Player.ItemCount("Soulstone") == 0)
                        {
                            this.Player.Cast("Create Soulstone");
                        }
                        else if(this.Player.TryCast("Create Soulstone (Lesser)") && this.Player.ItemCount("Lesser Soulstone") == 0)
                        {
                            this.Player.Cast("Create Soulstone (Lesser)");
                        }
                        else if(this.Player.TryCast("Create Soulstone (Minor)") && this.Player.ItemCount("Minor Soulstone") == 0)
                        {
                            this.Player.Cast("Create Soulstone (Minor)");
                        }
                }
               
                public void UseHealthstone()
                {
                    if(this.Player.ItemCount(this.Player.GetLastItem(Healthstone)) != 0)
                    {
                        this.Player.UseItem(this.Player.GetLastItem(Healthstone));
                    }
                }
               
                public void UseSoulstone()
                {
                    if(this.Player.ItemCount(this.Player.GetLastItem(Soulstone)) != 0)
                    {
                        this.Player.UseItem(this.Player.GetLastItem(Soulstone));
                    }
                }
               
              private bool HandledMultiTargetCombat()
             {
                if (this.Player.ManaPercent < 15)
                {
                    return true;
                }

                if (Attackers.Count > 1)
                {
                    if (Target.GotDebuff("Curse of Agony") &&
                        Target.GotDebuff("Corruption"))
                    {
                        var unitDotToAttack =
                            Attackers.FirstOrDefault(
                                a =>
                                    !a.GotDebuff("Curse of Agony")
                                    ||
                                    !a.GotDebuff("Corruption"));
                                   
                        var unitToAttack = Attackers.FirstOrDefault(a=> a.TargetGuid == this.Player.Guid);

                        if (unitDotToAttack != null)
                        {
                            this.Player.StopWand();
                            this.Player.StopAttack();
                            this.Player.SetTargetTo(unitDotToAttack);
                            if(this.Player.GotPet())
                            {
                               this.Pet.Attack();
                               if(this.Player.CanUse("Suffering"))
                               {
                                   this.Player.Cast("Suffering");
                               }
                            }
                            DotTarget(unitToAttack, "Curse of Agony");
                            DotTarget(unitToAttack, "Corruption");
                            return false;
                        }
                       
                        if(unitToAttack != null)
                        {
                            this.Player.SetTargetTo(unitToAttack);
                            if(this.Player.GotPet())
                            {
                               this.Pet.Attack();
                               if(this.Player.CanUse("Suffering"))
                               {
                                   this.Player.Cast("Suffering");
                               }
                            }
                        }
                        else
                        {
                            int LowerHP = this.Attackers.Min(Mob => Mob.HealthPercent);
                            var LowerHPUnit = this.Attackers.SingleOrDefault(Mob => Mob.HealthPercent == LowerHP);
                            if (LowerHPUnit != null && LowerHPUnit.Guid != this.Target.Guid)
                            {
                                this.Player.SetTargetTo(LowerHPUnit);
                                this.Pet.Attack();
                            }
                           
                            if(handleaggrofear)
                            {
                                int HigherHp = this.Attackers.Max(Mob => Mob.HealthPercent);
                                var HigherHpUnit = this.Attackers.SingleOrDefault(Mob => Mob.HealthPercent == HigherHp);
                                if(HigherHpUnit != null && !HigherHpUnit.GotDebuff("Fear") && HigherHpUnit.Guid != this.Target.Guid)
                                {
                                     this.Player.SetTargetTo(HigherHpUnit);
                                     if(!this.Target.GotDebuff("Fear") && CheckSpell("Fear"))
                                     {
                                        this.Player.Cast("Fear");
                                     }
                                    this.Player.SetTargetTo(LowerHPUnit);
                                }
                            }
                        }
                     }
                }
               
                return true;
            }
           
           
            private void DotTarget(_Unit unitToAttack,string dotSpell)
            {
                if (this.Player.CanUse(dotSpell) && !unitToAttack.GotDebuff(dotSpell))
                {
                        this.Player.Cast(dotSpell);
                }
            }

            }
        }


