    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Threading.Tasks;
    using ZzukBot.Engines.CustomClass;

    namespace ConsoleApplication1
    {
        class kallhunter : CustomClass
        {
            bool SummonPet = true;

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
                    // Do we stil have food for our pet?
                    else if (this.Pet.GotPetFood)
                    {
                        // Is our pet not happy?
                        if (!this.Pet.IsHappy())
                        {
                            // Is pet 'eating'?
                            if (!Pet.GotBuff("Feed Pet Effect"))
                                // if it is not feed it
                                this.Pet.Feed();
                            // tell the bot we are not buffed
                            return false;
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
        }
    }
