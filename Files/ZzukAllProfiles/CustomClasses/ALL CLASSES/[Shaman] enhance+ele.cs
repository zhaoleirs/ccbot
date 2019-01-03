    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Threading.Tasks;
    using ZzukBot.Engines.CustomClass;

    namespace something
    {
        public class Enhancement : CustomClass
        {
            bool ShouldRest = true;
            //SET YOUR POTION
            string HPot = "Superior Healing Potion";
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
                    return "Enhancement";
                }
            }
            public override bool Buff()
            {
                return true;   
            }
            public override void PreFight()
            {
                this.SetCombatDistance(26);
                if (this.Target.DistanceToPlayer <= 29)
                {
                    if (this.Player.GetSpellRank("Grace of Air Totem") != 0 && this.Player.CanUse("Grace of Air Totem") && !this.Player.GotBuff("Grace of Air"))
                    {
                        this.Player.Cast("Grace of Air Totem");
                    }
                }
                if (this.Target.DistanceToPlayer <= 27)
                {
                    this.SetCombatDistance(29);
                    if (this.Player.CanUse("Lightning Bolt"))
                    {       
                        this.Player.CastWait("Lightning Bolt", 5000);
                        ShouldRest = false;
                    }
                    else
                    {
                        return;
                    }               
                } 
            }
            public override void Fight()
            {
                ShouldRest = true;           
                if (this.Player.HealthPercent <= 5 && this.Player.IsCasting == "" && this.Player.ItemCount(HPot) >= 1 && this.Player.CanUse(HPot))
                {
                    this.Player.UseItem(HPot);
                }         
                this.Player.Attack();
                if (this.Target.DistanceToPlayer >= 21 && this.Player.GetSpellRank("Earth Shock") != 0 && this.Player.CanUse("Earth Shock"))
                {
                    if (this.Target.IsCasting != "")
                    {
                        this.SetCombatDistance(19);
                        return;
                    }
                }
                if (this.Target.DistanceToPlayer <= 20 && this.Player.GetSpellRank("Earth Shock") != 0 && this.Player.CanUse("Earth Shock"))
                {
                    if (this.Target.IsCasting != "")
                    {
                        this.Player.Cast("Earth Shock");
                        return;
                    }
                }                         
                if (this.Target.DistanceToPlayer <= 8 || this.Target.IsCasting != "" || this.Target.IsChanneling != "")
                {
                    this.SetCombatDistance(4);
                }     
                if (this.Player.HealthPercent <= 35 && ((this.Target.HealthPercent + 5) >= this.Player.HealthPercent || this.Attackers.Count >= 2))
                {
                    if (this.Player.GetSpellRank("Lesser Healing Wave") != 0 && this.Player.CanUse("Lesser Healing Wave"))
                    {
                        this.Player.CastWait("Lesser Healing Wave", 500);
                    }
                    else
                    {
                        if (this.Player.CanUse("Healing Wave"))
                        {
                            this.Player.CastWait("Healing Wave", 500);
                        }
                    }
                    return;
                }
                if (this.Player.GetSpellRank("Stormstrike") == 0)
                {
                    if (this.Player.GetSpellRank("Flame Shock") != 0 && !this.Target.GotDebuff("Flame Shock") && this.Target.HealthPercent >= 40 && this.Player.CanUse("Flame Shock"))
                    {
                        this.Player.Cast("Flame Shock");
                        return;
                    }
                    if (this.Player.GetSpellRank("Earth Shock") != 0 && this.Target.HealthPercent >= 15 && this.Player.ManaPercent >= 25 && this.Player.CanUse("Earth Shock"))
                    {
                        this.Player.Cast("Earth Shock");
                    }         
                }
                else
                {
                    if (this.Player.CanUse("Stormstrike") && this.Target.HealthPercent >= 35)
                    {
                        this.Player.Cast("Stormstrike");
                    }
                    if (this.Player.GetSpellRank("Earth Shock") != 0 && this.Target.HealthPercent >= 15 && this.Player.ManaPercent >= 25 && this.Player.CanUse("Earth Shock") && this.Target.GotDebuff("Stormstrike"))
                    {
                        this.Player.Cast("Earth Shock");
                    }
                }
                if (this.Player.GetSpellRank("Stoneclaw Totem") != 0 && this.Attackers.Count >= 2 && this.Player.CanUse("Stoneclaw Totem"))
                {             
                    this.Player.Cast("Stoneclaw Totem");   
                }
                if (this.Player.GetSpellRank("Windfury Weapon") != 0)
                {
                    if (!this.Player.IsMainhandEnchanted())
                    {
                        this.Player.Cast("Windfury Weapon");
                    }
                }
                else
                {
                    if (!this.Player.IsMainhandEnchanted())
                    {
                        this.Player.Cast("Rockbiter Weapon");
                    }
                }
                if (this.Player.GetSpellRank("Mana Spring Totem") != 0 && this.Player.CanUse("Mana Spring Totem") && !this.Player.GotBuff("Mana Spring") && this.Player.ManaPercent <= 40)
                {
                    this.Player.Cast("Mana Spring Totem");
                } 
            }
            public override void Rest()
            {
                if (this.Player.HealthPercent <= 50 && this.Player.CanUse("Healing Wave") && !this.Player.GotBuff("Drink") && this.Player.ManaPercent >= 20)
                {
                     this.Player.CastWait("Healing Wave", 500);
                     return;
                }
                if (ShouldRest && this.Player.NeedToDrink)
                {
                    this.Player.Drink();
                    return;
                }         
            }
        }
    }