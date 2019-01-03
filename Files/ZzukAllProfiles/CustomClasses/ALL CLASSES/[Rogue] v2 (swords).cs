    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Threading.Tasks;
    using ZzukBot.Engines.CustomClass;

    namespace something
    {
        public class EmuRogue : CustomClass
        {
            private int[][] EviscerateDamage = new int[][]
                {
                    new int[] {0,0,0,0,0},
                    new int[] {10, 10,15,20,25,30},
                    new int[] {20, 22,33,44,55,66},
                    new int[] {30, 39,58,77,96,115},
                    new int[] {50, 61,92,123,154,185},
                    new int[] {60, 60,135,180,225,270},
                    new int[] {80, 143,220,297,374,451},
                    new int[] {100, 212,322,432,542,652},
                    new int[] {150, 295,446,597,748,899},
                    new int[] {200, 332,502,672,842,1012},
                };
            private bool ShouldWeEviscerate()
            {
                int rank = this.Player.GetSpellRank("Eviscerate");
                int damage = 0;
                int comboPoints = this.Player.ComboPoints;
                if (rank >= 1 && comboPoints >= 1)
                {
                    damage = (EviscerateDamage[rank][comboPoints] + EviscerateDamage[rank][0]);
                    if (this.Target.Health <= damage)
                    {
                        return true;
                    }
                }
                return false;
            }
            private double GetSliceAndDiceDuration()
            {
                try
                {
                    this.Player.DoString("function getBuffDuration(name) GetSpellForBot = name " +
                    "timeleft = -1 for i=0,31 do local id,cancel = GetPlayerBuff(i,'HELPFUL|HARMFUL|PASSIVE') if(name == GetPlayerBuffTexture(id)) then " +
                    "timeleft = GetPlayerBuffTimeLeft(id) " + " return timeleft end end return timeleft end");
                }
                catch
                {
                    return -3;
                }

                try
                {
                    string tex = @"Interface\\Icons\\Ability_Rogue_SliceDice";
                    this.Player.DoString("points = getBuffDuration('" + tex + "')");
                    return Convert.ToDouble(this.Player.GetText("points"));
                }
                catch
                {
                    return -3;
                }
            }
            public override byte DesignedForClass
            {
                get
                {
                    return PlayerClass.Rogue;
                }
            }
            public override string CustomClassName
            {
                get
                {
                    return "EmuRogue";
                }
            }
            public override void PreFight()
            {
                this.SetCombatDistance(29);
                if (this.Player.ItemCount("Small Throwing Knife") != 0)
                {
                    this.Player.Cast("Throw");
                }
                else
                {
                    this.SetCombatDistance(4);
                    this.Player.Attack();
                }     
            }
            public override void Fight()
            {
                int Energy = this.Player.Energy;
                int ComboPoint = this.Player.ComboPoints;

                this.Player.Attack();
                if (this.Target.DistanceToPlayer <= 15 || this.Target.IsCasting != "" || this.Target.IsChanneling != "")
                {
                    this.SetCombatDistance(4);
                }
                if (this.Attackers.Count >= 2)
                {
                    if (this.Player.GetSpellRank("Adrenaline Rush") != 0)
                    {
                        if (this.Player.CanUse("Adrenaline Rush"))
                        {
                            this.Player.Cast("Adrenaline Rush");
                        }
                    }
                    if (this.Player.GetSpellRank("Blood Fury") != 0)
                    {
                        if (this.Player.CanUse("Blood Fury"))
                        {
                            this.Player.Cast("Blood Fury");
                        }
                    }
                    if (this.Player.GetSpellRank("Blade Flurry") != 0 && Energy >= 25)
                    {
                        if (this.Player.CanUse("Blade Flurry"))
                        {
                            this.Player.Cast("Blade Flurry");
                        }
                    }
                    if (this.Player.GetSpellRank("Evasion") != 0)
                    {
                        if (this.Player.CanUse("Evasion"))
                        {
                            this.Player.Cast("Evasion");
                        }
                    }
                }
                if (Energy <= 20)
                {
                    return;
                }
                if (Energy >= 25 && (this.Target.IsCasting != "" || this.Target.IsChanneling != ""))
                {
                    if (this.Player.GetSpellRank("Kick") != 0)
                    {
                        this.Player.Cast("Kick");
                    }
                }

                if (Energy >= 35)
                {
                    if (this.Player.GetSpellRank("Eviscerate") != 0)
                    {
                        if (this.ShouldWeEviscerate() || ComboPoint == 5)
                        {
                            this.Player.Cast("Eviscerate");
                            return;
                        }
                    }
                }
                if (Energy >= 25)
                {
                    if (this.Player.GetSpellRank("Slice and Dice") != 0)
                    {
                        if ((!this.Player.GotBuff("Slice and Dice") ||
                            this.GetSliceAndDiceDuration() <= 2.0) &&
                            !this.ShouldWeEviscerate() && ComboPoint > 0)
                        {
                            this.Player.Cast("Slice and Dice");
                            return;
                        }
                    }
                    if (Energy >= 40)
                    {
                        this.Player.Cast("Sinister Strike");
                    }
                }
            }
            public override bool Buff()
            {
                if (this.Player.IsMainhandEnchanted() && this.Player.IsOffhandEnchanted())
                    return true;
                   
                if (this.Player.IsCasting != "")
                    return false;

                string[] Posions = { "Instant Poison", "Instant Poison I", "Instant Poison II", "Instant Poison III", "Instant Poison IV", "Instant Poison V", "Instant Poison VI" };
                if (this.Player.GetLastItem(Posions) != String.Empty)
                {

                    if (!this.Player.IsMainhandEnchanted())
                    {
                        this.Player.EnchantMainhandItem(this.Player.GetLastItem(Posions));
                        return false;
                    }
                    if (!this.Player.IsOffhandEnchanted())
                    {
                        this.Player.EnchantOffhandItem(this.Player.GetLastItem(Posions));
                        return false;
                    }
                }
                return true;
            }
        }
    }