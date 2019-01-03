        using System;
        using System.Collections.Generic;
        using System.Text;
        using System.Threading.Tasks;
        using ZzukBot.Engines.CustomClass;

        namespace something
        {
            public class SNXShamy : CustomClass
            {


                public override byte DesignedForClass
                {
                    get
                    {
                        return PlayerClass.Shaman;
                    }
                }

                public override string CustomClassName
                {
                    get
                    {
                        return "SNXShamy";
                    }
                }

                public override void PreFight()
                {
                    this.SetCombatDistance(15);
                    if (this.Player.GetSpellRank("Lightning Shield") != 0)
                    {
                        if (!this.Player.GotBuff("Lightning Shield"))
                        {
                            this.Player.Cast("Lightning Shield");
                        }
                    }
                   
                    else
                    {
                        this.Player.Cast("Lightning Bolt");
                    }
                }

                public override bool Buff()
                {
                    int rank = this.Player.GetSpellRank("Rockbiter Weapon");
                    if (rank != 0)
                    {
                        if (!this.Player.IsMainhandEnchanted())
                        {
                            this.Player.Cast("Rockbiter Weapon");
                            return false;
                        }
                    }
                    return true;
                }

                public override void Fight()
                {
                
                    this.SetCombatDistance(3);
                    this.Player.Attack();

                    if (this.Player.GetSpellRank("Stormstrike") != 0)
                    {
                        if (Player.CanUse("Stormstrike"))
                        {
                            this.Player.Cast("Stormstrike");
                            return;
                        }
                    }
                
                if (this.Player.GetSpellRank("Earth Shock") != 0)
                    {
                        if (!Target.GotDebuff("Earth Shock"))
                        {
                            this.Player.Cast("Earth Shock");
                        }
                    }

                    if (this.Player.HealthPercent <= 40)
                    {
                        if (this.Player.GetSpellRank("Healing Wave") != 0
                            && this.Player.CanUse("Healing Wave"))
                        {
                            this.Player.CastWait("Healing Wave", 250);
                        }
                        return;
                    }

                    if (this.Player.GetSpellRank("Lightning Shield") != 0)
                    {
                        if (!this.Player.GotBuff("Lightning Shield"))
                        {
                            this.Player.Cast("Lightning Shield");
                        }
                    }


                    if (this.Player.GetSpellRank("Stoneclaw Totem") != 0)
                    {
                        float rangeToTotem = this.Player.IsTotemSpawned("Stoneclaw Totem");
                        if (this.Attackers.Count >= 2 && (rangeToTotem == -1 || rangeToTotem > 25)
                            && this.Player.CanUse("Stoneclaw Totem"))
                        {
                            this.Player.Cast("Stoneclaw Totem");
                        }
                    }

                    if (Player.GetSpellRank("Windfury Totem") != 0)
                    {
                        float rangeToTotem = this.Player.IsTotemSpawned("Windfury Totem");
                        if ((rangeToTotem == -1 || rangeToTotem > 25) && Player.CanUse("Windfury Totem"))
                        {
                            this.Player.Cast("Windfury Totem");
                        }
                    }

                    //Run to mob?
                    if (this.Target.DistanceToPlayer <= 4)
                    {
                        this.Player.Attack();
                    }
                }
            }
        }


