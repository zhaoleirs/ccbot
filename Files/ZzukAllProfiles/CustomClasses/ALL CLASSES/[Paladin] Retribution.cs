    using System;
    using System.Collections.Generic;
    using System.Text;
    using System.Threading.Tasks;
    using ZzukBot.Engines.CustomClass;

    namespace something
    {
        public class EmuPaladin : CustomClass
        {

            public override byte DesignedForClass
            {
                get
                {
                    return PlayerClass.Paladin;
                }
            }

            public override string CustomClassName
            {
                get
                {
                    return "Ret";
                }
            }

            public override void PreFight()
            {
                this.Player.Attack();
                this.SetCombatDistance(3);

                if (!Target.GotDebuff("Judgement of the Crusader"))
                    {
                         if (!this.Player.GotBuff("Seal of the Crusader"))
                             {
                                 this.Player.Cast("Seal of the Crusader");
                             }
                     } else
                    if (this.Player.GetSpellRank("Seal of Command") != 0)
                {
                    if (!this.Player.GotBuff("Seal of Command"))
                    {
                        this.Player.Cast("Seal of Command");
                    }
                }
                else if (!this.Player.GotBuff("Seal of Righteousness"))
                {
                    this.Player.Cast("Seal of Righteousness");
                   
                }
                   
               
            }

            public override void Fight()
            {
                this.Player.Attack();

                if (this.Player.GetSpellRank("Lay on Hands") != 0)
                {
                    if (this.Player.CanUse("Lay on Hands"))
                    {
                        if (this.Player.HealthPercent <= 20 && this.Target.HealthPercent > 5 && this.Attackers.Count < 4)
                        {
                            this.Player.Cast("Lay on Hands");
                        }
                    }
                }

                if (this.Player.ManaPercent <= 10)
                {
                    return;
                }

                if (this.Player.GetSpellRank("Hammer of Wrath") != 0)
                {
                    if (this.Player.CanUse("Hammer of Wrath") && this.Target.HealthPercent <= 20)
                    {
                        this.Player.Cast("Hammer of Wrath");
                    }
                }

                if (this.Player.HealthPercent <= 25)
                {
                    if (this.Player.GetSpellRank("Hammer of Justice") != 0)
                    {
                        if (this.Player.CanUse("Hammer of Justice"))
                            this.Player.Cast("Hammer of Justice");
                    }
                }

                //Prevent healing when mob is almost dead and dont use CDs if we dont need help killing it
                if ((this.Player.HealthPercent <= 30 && this.Player.ManaPercent >= 20 && this.Player.HealthPercent < this.Target.HealthPercent) || this.Attackers.Count >= 2 && this.Player.HealthPercent < 55)
                {

                    if (!this.Player.GotDebuff("Forbearance") && !this.Target.GotDebuff("Hammer of Justice"))
                    {
                        if (this.Player.GetSpellRank("Divine Shield") != 0 && this.Player.CanUse("Divine Shield"))
                        {
                            this.Player.Cast("Divine Shield");
                        }
                        else if (this.Player.GetSpellRank("Divine Protection") != 0 && this.Player.CanUse("Divine Protection"))
                        {
                            this.Player.Cast("Divine Protection");
                        }
                        else if (this.Player.GetSpellRank("Blessing of Protection") != 0 && this.Player.CanUse("Blessing of Protection"))
                        {
                            this.Player.Cast("Blessing of Protection");
                        }
                    }

                }
                //Logic needs to be looked at here, heal effectiveness changes greatly when leveling
                if ((this.Player.HealthPercent < 55 && this.Target.HealthPercent > 50) || ((this.Player.GotBuff("Divine Protection") || this.Player.GotBuff("Blessing of Protection")
                    || this.Player.GotBuff("Divine Shield")) && this.Player.HealthPercent < 80))
                {
                    if (this.Player.GetSpellRank("Flash of Light") != 0 && (!this.Target.GotDebuff("Hammer of Justice")
                        && (!this.Player.GotBuff("Divine Shield") && !this.Player.GotBuff("Divine Protection")
                        && !this.Player.GotBuff("Blessing of Protection"))) && this.Player.HealthPercent >= 70)
                    {
                        this.Player.CastWait("Flash of Light", 500);
                    }
                    else
                    {
                        if (this.Player.ManaPercent <= 10)
                        {
                            if (this.Player.GetSpellRank("Flash of Light") != 0)
                            {
                                this.Player.CastWait("Flash of Light", 500);
                                return;
                            }
                        }
                        this.Player.CastWait("Holy Light", 500);
                    }
                }

                if (!Target.GotDebuff("Judgement of the Crusader"))
                {
                    if (!this.Player.GotBuff("Seal of the Crusader"))
                    {
                        this.Player.Cast("Seal of the Crusader");
                    }
                }
                else
                     if (this.Player.GetSpellRank("Seal of Command") != 0)
                {
                    if (!this.Player.GotBuff("Seal of Command"))
                    {
                        this.Player.Cast("Seal of Command");
                    }
                }
                else if (!this.Player.GotBuff("Seal of Righteousness"))
                {
                    this.Player.Cast("Seal of Righteousness");

                }


                if (this.Player.ManaPercent > 10)
                {
                if (this.Player.GetSpellRank("Judgement") != 0)
                {
                    if (this.Player.CanUse("Judgement") && this.Player.GotBuff("Seal of Command") || this.Player.GotBuff("Seal of Righteousness") || this.Player.GotBuff("Seal of the Crusader"))
                    {
                        this.Player.CastWait("Judgement", 500);
                    }
                }
                }
            }

            public override void Rest()
            {
                if (this.Player.ManaPercent > 60 && !Player.GotBuff("Drink"))
                {

                    if (this.Player.HealthPercent >= 70 && this.Player.HealthPercent <= 90 && this.Player.GetSpellRank("Flash of Light") != 0)
                    {
                        this.Player.CastWait("Flash of Light", 500);
                    }
                    else if (this.Player.HealthPercent <= 90)
                    {
                        this.Player.CastWait("Holy Light", 500);
                    }

                }
                else
                {
                    this.Player.Drink();
                    this.Player.Eat();
                }
            }

            public override bool Buff()
            {
                /*Blessings*/
                if (this.Player.GetSpellRank("Blessing of Might") != 0)
                {
                    if (!this.Player.GotBuff("Blessing of Might"))
                    {
                        this.Player.Cast("Blessing of Might");
                        return false;
                    }
                }
                else if (this.Player.GetSpellRank("Blessing of Wisdom") != 0)
                {
                    if (!this.Player.GotBuff("Blessing of Wisdom"))
                    {
                        this.Player.Cast("Blessing of Wisdom");
                        return false;
                    }
                }

                /*Auras*/
                if (this.Player.GetSpellRank("Sanctity Aura") != 0)
                {
                    if (!this.Player.GotBuff("Sanctity Aura"))
                    {
                        this.Player.Cast("Sanctity Aura");
                        return false;
                    }
                }
                else if (this.Player.GetSpellRank("Retribution Aura") != 0)
                {
                    if (!this.Player.GotBuff("Retribution Aura"))
                    {
                        this.Player.Cast("Retribution Aura");
                        return false;
                    }
                }
                else if (this.Player.GetSpellRank("Devotion Aura") != 0)
                {
                    if (!this.Player.GotBuff("Devotion Aura"))
                    {
                        this.Player.Cast("Devotion Aura");
                        return false;
                    }
                }

                //True means we are done buffing, or cannot buff
                return true;
            }
        }
    }
