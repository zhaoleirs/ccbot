    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Threading.Tasks;
    using ZzukBot.Engines.CustomClass;

    namespace something
    {
        public class EmuPriest : CustomClass
        {


            public override byte DesignedForClass
            {
                get
                {
                    return PlayerClass.Priest;
                }
            }

            public override string CustomClassName
            {
                get
                {
                    return "EmuPriest";
                }
            }

            public override void PreFight()
            {
                this.SetCombatDistance(30);
                this.Player.Attack();
                /*For those with touch of weakness*/
                if (this.Player.GetSpellRank("Touch of Weakness") != 0)
                {
                    if (!this.Player.GotBuff("Touch of Weakness"))
                    {
                        this.Player.Cast("Touch of Weakness");
                    }
                }
                if (this.Player.GetSpellRank("Shadow Word: Pain") != 0)
                {
                    if (!Target.GotDebuff("Shadow Word: Pain"))
                    {
                        this.Player.Cast("Shadow Word: Pain");
                    }
                }
                else
                {
                    this.Player.Cast("Smite");
                }

            }

            public override void Fight()
            {
                bool canWand = this.Player.IsWandEquipped();

                if (this.Player.ManaPercent < 10)
                {
                    if (canWand)
                    {
                        this.Player.StartWand();
                    }
                    else
                    {
                        this.Player.Attack();
                    }
                    return;
                }

                if (this.Player.GetSpellRank("Shadow Word: Pain") != 0)
                {
                    if (!this.Target.GotDebuff("Shadow Word: Pain"))
                    {
                        this.Player.StopWand();
                        this.Player.Cast("Shadow Word: Pain");
                        return;
                    }
                }


                if (this.Player.HealthPercent <= 40)
                {
                    this.Player.StopWand();
                    if (this.Player.GetSpellRank("Flash Heal") != 0)
                    {
                        this.Player.Cast("Flash Heal");
                    }
                    else
                    {
                        this.Player.Cast("Lesser Heal");
                    }
                    return;
                }

                if (this.Player.GetSpellRank("Power Word: Shield") != 0)
                {
                    if (!this.Player.GotBuff("Power Word: Shield") && !this.Player.GotDebuff("Weakened Soul") && this.Target.HealthPercent > 5)
                    {
                        this.Player.StopWand();
                        this.Player.Cast("Power Word: Shield");
                    }
                }

                if (this.Player.GetSpellRank("Inner Fire") != 0)
                {
                    if (!Player.GotBuff("Inner Fire"))
                    {
                        this.Player.StopWand();
                        this.Player.Cast("Inner Fire");
                        return;
                    }
                }

                if (this.Player.GetSpellRank("Shadow Word: Pain") != 0 && this.Player.GetSpellRank("Power Word: Shield") != 0)
                {
                    if (this.Player.GotBuff("Power Word: Shield") || this.Player.GotDebuff("Weakened Soul") && this.Target.GotDebuff("Shadow Word: Pain"))
                    {
                        if (canWand)
                        {
                            this.Player.StartWand();
                        }
                        else
                        {
                            this.Player.Attack();
                        }
                    }
                }
                else if (this.Player.GetSpellRank("Shadow Word: Pain") != 0 && this.Player.GetSpellRank("Power Word: Shield") == 0)
                {
                    if (this.Target.GotDebuff("Shadow Word: Pain"))
                    {
                        if (canWand)
                        {
                            this.Player.StartWand();
                        }
                        else
                        {
                            this.Player.Attack();
                        }
                    }
                }
                else if (this.Player.GetSpellRank("Shadow Word: Pain") == 0 && this.Player.GetSpellRank("Power Word: Shield") != 0)
                {
                    if (this.Player.GotBuff("Power Word: Shield") || this.Player.GotDebuff("Weakened Soul"))
                    {
                        if (canWand)
                        {
                            this.Player.StartWand();
                        }
                        else
                        {
                            this.Player.Attack();
                        }
                    }
                }
                else
                {
                    if (canWand)
                    {
                        this.Player.StartWand();
                    }
                    else
                    {
                        if (this.Player.ManaPercent > 60)
                        {
                            this.SetCombatDistance(30);
                            this.Player.Cast("Smite");
                        }
                        //Run to mob?
                        if(this.Target.DistanceToPlayer <= 4){
                            this.Player.Attack();
                        }
                    }
                }
            }

            public override void Rest()
            {

                if (this.Player.ManaPercent < 60)
                {
                    this.Player.Drink();
                    this.Player.Eat();
                }
                else
                {
                    if (this.Player.HealthPercent <= 90 && this.Player.GetSpellRank("Flash of Light") != 0)
                    {
                        this.Player.Cast("Flash  Heal");
                    }
                    else if (this.Player.HealthPercent <= 75)
                    {
                        if (this.Player.GetSpellRank("Heal") != 0)
                        {
                            this.Player.Cast("Heal");
                        }
                        else
                        {
                            this.Player.Cast("Lesser Heal");
                        }
                    }
                }
               
            }

            public override bool Buff()
            {
                if (this.Player.GetSpellRank("Touch of Weakness") != 0)
                {
                    if (!this.Player.GotBuff("Touch of Weakness"))
                    {
                        this.Player.Cast("Touch of Weakness");
                        return false;
                    }
                }
                if (this.Player.GetSpellRank("Inner Fire") != 0)
                {
                    if (!this.Player.GotBuff("Inner Fire"))
                    {
                        this.Player.Cast("Inner Fire");
                        return false;
                    }
                }
                if (this.Player.GetSpellRank("Power Word: Fortitude") != 0)
                {
                    if (!this.Player.GotBuff("Power Word: Fortitude"))
                    {
                        this.Player.Cast("Power Word: Fortitude");
                        return false;
                    }
                }
                if (this.Player.GetSpellRank("Divine Spirit") != 0)
                {
                    if (!this.Player.GotBuff("Divine Spirit"))
                    {
                        this.Player.Cast("Divine Spirit");
                        return false;
                    }
                }
                //True means we are done buffing, or cannot buff
                return true;
            }
        }
    }

