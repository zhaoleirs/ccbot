    using System;
    using System.Linq;
    using System.Collections.Generic;
    using System.Text;
    using System.Threading.Tasks;
    using ZzukBot.Engines.CustomClass;

    namespace something
    {
        public class dgcfusHunter : CustomClass
        {
            //SET YOUR AMMO        ▼ ▼ ▼ ▼ ▼ ▼
            private string Ammo = "Jagged Arrow";
            //SET YOUR AMMO        ▲ ▲ ▲ ▲ ▲ ▲
            //LOW AMMO BEHAVIOUR SETTED AT 50 LV 1-10       
            //LOW AMMO BEHAVIOUR SETTED AT 200 (1 STACK) LV 10-60
            private int[] MPMana = {0, 50, 90, 155, 225, 300, 385, 480};
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
                    return "dgcfus Hunter";
                }
            }
            public override bool Buff()
            {
                //----> WILL BUG IF THE PET LEAVES YOU <----
                if (this.Player.GetSpellRank("Call Pet") != 0)
                {
                    //AVOID MEND PET CHANNELING BREAKS
                    if (this.Player.IsChanneling == "Mend Pet")
                    {
                        return false;
                    }
                    //END
                    //CALLS AND/OR REVIVES PET (WAITS FOR PET TO RECOVER LV 10-12)
                    if (!this.Player.GotPet())
                    {
                        this.Pet.Call();
                        return false;
                    }
                    else
                    {
                        if (!this.Pet.IsAlive())
                        {
                            this.Pet.Revive();
                            return false;
                        }
                        if (this.Player.GetSpellRank("Mend Pet") == 0 && this.Pet.HealthPercent <= 80)
                        {
                            return false;
                        }
                        if (this.Pet.GotBuff("Feed Pet Effect"))
                        {
                            return false;
                        }
                    }
                    //END
                }
                return true;
            }
            public override void PreFight()
            {
                if (this.Target.DistanceToPlayer > 30)
                {
                    this.SetCombatDistance(25);
                }
                //CAST HUNTER'S MARK IF WE ARE NOT LOW ON AMMO
                if (this.Player.GetSpellRank("Hunter's Mark") != 0 && !this.Target.GotDebuff("Hunter's Mark") && this.Player.ItemCount(Ammo) >= 51 && this.Player.GetSpellRank("Call Pet") == 0)
                {
                    this.Player.Cast("Hunter's Mark");
                }               
                if (this.Player.GetSpellRank("Hunter's Mark") != 0 && !this.Target.GotDebuff("Hunter's Mark") && this.Player.ItemCount(Ammo) >= 201 && this.Player.GetSpellRank("Call Pet") != 0)
                {
                    this.Player.Cast("Hunter's Mark");
                }
                //END           
                //PULL FROM 30 YARDS IF THE TARGET IN IN THE CORRECT TANGE AND WE HAVE AMMO
                if (this.Target.DistanceToPlayer <= 30 && this.Target.DistanceToPlayer >= 8 && this.Player.ItemCount(Ammo) >= 1)
                {               
                    this.SetCombatDistance(34);
                    //WAIT FOR GLOBAL COOLDOWN TO BE OVER
                    if (this.Player.GetSpellRank("Hunter's Mark") != 0 && !this.Player.CanUse("Hunter's Mark"))
                    {
                        return;
                    }
                    //END
                    //PULL WITH SERPENT STING IF WE HAVE PET               
                    if (this.Player.GotPet())
                    {
                        if (this.Player.CanUse("Serpent Sting"))
                        {
                            this.Player.Cast("Serpent Sting");
                        }
                        this.Pet.Attack();
                    }
                    //END
                    //PULL WITH CONCUSSIVE SHOT OR RANGED ATTACK IF WE DON'T HAVE PET (LV 1-10)
                    else
                    {
                        if (this.Player.GetSpellRank("Concussive Shot") != 0 && this.Player.CanUse("Concussive Shot"))
                        {
                            this.Player.Cast("Concussive Shot");
                        }
                        else
                        {
                            this.Player.RangedAttack();
                        }
                    }
                    //END
                }
                //BODYPULL IF WE ARE OUT OF AMMO OR TOO CLOSE TO USE RANGED ABILITYS
                else
                {
                    if (this.Player.ItemCount(Ammo) == 0 || this.Target.DistanceToPlayer <= 8)
                    {
                        this.SetCombatDistance(4);
                        this.Player.Attack();
                        if (this.Player.GotPet())
                        {
                            this.Pet.Attack();
                        }               
                    }
                }
                //END
            }
            public override void Fight()
            {
                //AVOID REVIVE PET CASTING BREAKS
                if (this.Player.IsCasting == "Revive Pet")
                {
                    return;
                }
                //END
                //1-10 FIGHT PHASE
                if (this.Player.GetSpellRank("Call Pet") == 0)
                {
                    if (this.Target.DistanceToPlayer <= 8 || this.Player.ItemCount(Ammo) <= 50)
                    {
                        this.SetCombatDistance(4);
                        this.Player.Attack();
                        if (this.Player.HealthPercent <= 85 && this.Player.GetSpellRank("Aspect of the Monkey") != 0 && !this.Player.GotBuff("Aspect of the Monkey"))
                        {
                            this.Player.Cast("Aspect of the Monkey");
                        }
                        if (this.Player.CanUse("Raptor Strike") && this.Target.DistanceToPlayer <= 5)
                        {
                            this.Player.Cast("Raptor Strike");
                        }
                    }
                    else
                    {
                        this.SetCombatDistance(34);
                        this.Player.RangedAttack();
                        if (this.Player.GetSpellRank("Serpent Sting") != 0 && !this.Target.GotDebuff("Serpent Sting") && this.Player.CanUse("Serpent Sting") && this.Target.HealthPercent >= 40)
                        {
                            this.Player.Cast("Serpent Sting");
                        }
                        if (this.Player.GetSpellRank("Arcane Shot") != 0 && this.Player.CanUse("Arcane Shot"))
                        {
                            this.Player.Cast("Arcane Shot");
                        }
                    }
                }
                //END
                //10-60 FIGHT PHASE
                else
                {
                    //HANDLE MULTITARGET FIGHTS
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
                    //END
                    if (this.Player.IsChanneling == "Mend Pet")
                    {
                        return;
                    }
                    //BESTIAL WRATH IF USING TOO MUCH MANA ON MEND PET OR 3+ ATTACKERS (improved)
                    if (((this.Player.ManaPercent <= 20 && (this.Target.HealthPercent >= this.Pet.HealthPercent + 10 || this.Attackers.Count >= 2)) || this.Attackers.Count >= 3) && this.Player.GetSpellRank("Bestial Wrath") != 0 && this.Player.CanUse("Bestial Wrath"))
                    {
                        this.Player.Cast("Bestial Wrath");
                    }
                    //END
                    //BEHAVIOUR IF THE PET IS TANKING OUR TARGET AND WE HAVE ENOUGH AMMO
                    if (this.Pet.IsTanking() && this.Player.ItemCount(Ammo) >= 201)
                    {
                        this.SetCombatDistance(34);
                        //HEALS PET IF BELOW 50% HP (HIGH PRIORITY)
                        if (this.Pet.HealthPercent <= 50 && this.Pet.HealthPercent >= 1 && this.Player.GetSpellRank("Mend Pet") != 0 && this.Player.CanUse("Mend Pet") && !(this.Player.IsChanneling == "Mend Pet"))
                        {
                            if (this.Pet.DistanceToPlayer >= 20)
                            {
                                this.SetCombatDistance(18);
                                return;
                            }
                            else if (this.Player.Mana >= MPMana[this.Player.GetSpellRank("Mend Pet")])
                            {
                                this.Player.CastWait("Mend Pet", 500);
                                return;
                            }
                        }
                        //END
                        //BEHAVIOUR IF THE TARGET IS IN THE CORRECT RANGE
                        if (!this.Player.ToCloseForRanged)
                        {
                            if (this.Player.GetSpellRank("Aspect of the Hawk") != 0 && !this.Player.GotBuff("Aspect of the Hawk") && this.Player.ManaPercent >= 25)
                            {
                                this.Player.Cast("Aspect of the Hawk");
                            }
                            //RANGED COMBAT ROUTINE                 
                            this.Player.RangedAttack();
                            if (this.Player.ManaPercent >= 50)
                            {
                                if (!this.Target.GotDebuff("Serpent Sting") && this.Player.CanUse("Serpent Sting") && this.Target.HealthPercent >= 40)
                                {
                                    this.Player.Cast("Serpent Sting");
                                }
                                if (this.Player.CanUse("Arcane Shot"))
                                {
                                    this.Player.Cast("Arcane Shot");
                                }
                            }
                            //END
                        }
                        //END
                        //BEHAVIOUR IF THE TARGET IS TOO CLOSE
                        else if (this.Target.HealthPercent >= 20)
                        {
                            //RUN AWAY FROM THE MOB IF THERE IS SPACE
                            if (!this.Player.Backup(14))
                            //END
                            {
                                //BEHAVIOUR IF CAN'T RUN AWAY
                                if (this.Target.DistanceToPlayer <= 8)
                                {
                                    this.SetCombatDistance(4);
                                    if (this.Target.DistanceToPlayer <= 5)
                                    {
                                        this.Player.Attack();
                                        if (this.Player.CanUse("Raptor Strike") && this.Player.ManaPercent >= 25)
                                        {
                                            this.Player.Cast("Raptor Strike");
                                        }
                                    }
                                }
                                //END
                            }
                        }
                        //END
                        //BEHAVIOUR IF THE TARGET IS TOO CLOSE BUT ALMOST DEAD
                        else if (this.Target.HealthPercent <= 19)
                        {
                            if (this.Target.DistanceToPlayer <= 8)
                            {
                                this.SetCombatDistance(4);
                                if (this.Target.DistanceToPlayer <= 5)
                                {
                                    this.Player.Attack();
                                    if (this.Player.CanUse("Raptor Strike") && this.Player.ManaPercent >= 25)
                                    {
                                        this.Player.Cast("Raptor Strike");
                                    }
                                }
                            }
                        }
                        //END
                    }
                    //END
                    //BEHAVIOUR IF THE PET IS NOT TANKING OUR TARGET OR LOW IN AMMO
                    else
                    {
                        if (this.Target.DistanceToPlayer <= 8 || this.Player.ItemCount(Ammo) <= 200)
                        {
                            this.SetCombatDistance(4);
                            //USE INTIMIDATION IF GETTING TOO MUCH DAMAGE
                            if (this.Player.HealthPercent <= 50 && this.Pet.IsAlive() && this.Player.GetSpellRank("Intimidation") != 0 && this.Player.CanUse("Intimidation"))
                            {
                                this.Player.Cast("Intimidation");
                            }
                            //END
                            //HEALS PET IF BELOW 50% HP
                            if (this.Pet.HealthPercent <= 50 && this.Pet.HealthPercent >= 1 && this.Player.GetSpellRank("Mend Pet") != 0 && this.Player.CanUse("Mend Pet") && !(this.Player.IsChanneling == "Mend Pet"))
                            {
                                this.Player.CastWait("Mend Pet", 500);
                            }
                            if (this.Player.IsChanneling == "Mend Pet")
                            {
                                return;
                            }
                            //END
                            if (this.Player.HealthPercent <= 85 && !this.Player.GotBuff("Aspect of the Monkey"))
                            {
                                this.Player.Cast("Aspect of the Monkey");
                            }
                            //FEIGN DEATH OR DISENGAGE IF GETTING TOO MUCH DAMAGE
                            if (this.Player.HealthPercent <= 40 && this.Pet.IsAlive())
                            {
                                if (this.Player.GetSpellRank("Feign Death") != 0 && this.Player.CanUse("Feign Death"))
                                {
                                    this.Player.Cast("Feign Death");
                                    return;
                                }
                                else if (this.Player.GetSpellRank("Disengage") != 0 && this.Player.CanUse("Disengage"))
                                {
                                    this.Player.Cast("Disengage");
                                    return;
                                }
                            }
                            //END
                            //MELEE COMBAT ROUTINE
                            this.Player.Attack();
                            if (this.Player.ManaPercent >= 25 || !this.Pet.IsAlive())
                            {
                                if (this.Player.GetSpellRank("Mongoose Bite") != 0 && this.Player.CanUse("Mongoose Bite"))
                                {
                                    this.Player.Cast("Mongoose Bite");
                                }                                       //RAPTOR STRIKE BLOCKING MOVEMENT FIX
                                if (this.Player.CanUse("Raptor Strike") && this.Target.DistanceToPlayer <= 5)
                                {                                       //END
                                    this.Player.Cast("Raptor Strike");
                                }
                            }
                            //END
                        }
                    }
                    //END
                }
                //END
                //LAST ATTEMPT TO SAVE OUR ASS
                if (!this.Pet.IsAlive() && this.Player.HealthPercent <= this.Target.HealthPercent + 10)
                {
                    if (this.Player.GetSpellRank("Feign Death") != 0 && this.Player.CanUse("Feign Death"))
                    {
                        this.Player.Cast("Feign Death");
                    }
                }
                //CONTINUE...
            }
            public override void Rest()
            {
                //...LAST ATTEMPT TO SAVE OUR ASS
                if (this.Player.GotBuff("Feign Death"))
                {
                    if (this.Player.ManaPercent >= 60 && this.Player.HealthPercent >= 60)
                    {
                        this.Pet.Revive();
                    }
                    return;
                }
                //END
                //AVOID MEND PET CHANNELING BREAKS
                if (this.Player.IsChanneling == "Mend Pet")
                {
                    return;
                }
                //END
                this.Player.DoString("DoEmote('Sit')");
                this.Player.Drink();
                this.Player.Eat();
            }
        }
    }