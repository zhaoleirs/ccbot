using System;
using System.Collections.Generic;
using ZzukBot.Engines.CustomClass;
using ZzukBot.FSM;
using ZzukBot.Mem;
using ZzukBot.Settings;

namespace ZzukBot.Engines.Grind.States
{
    internal class StateTanlet : State
    {
        private List<Talent> TanletList;
        private bool learnEnd=false;

        class Talent
        {
            public string name;
            public int tab;
            public int index;
            public int current;
            public int max;
            public Talent(string name, int tab, int index, int current, int max)
            {
                this.name = name;
                this.tab = tab;
                this.index = index;
                this.current = current;
                this.max = max;
            }
        }
        internal override int Priority => 80;

        internal override bool NeedToRun
        {
            get
            {
                if (string.IsNullOrEmpty(Options.Tanlet)|| learnEnd) return false;
                Functions.DoString("tanletPoint= UnitCharacterPoints('player')");
                return Convert.ToInt32(Functions.GetText("tanletPoint"))>0;
            }
        }

        internal override string Name => "Tanlet";



        internal override void Run()
        {
            if (TanletList == null)
            {
                TanletList = new List<Talent>();
                Functions.DoString("tanletTab=GetNumTalentTabs();");
                int tab = Convert.ToInt32(Functions.GetText("tanletTab"));
                for (int i = 1; i <= tab; i++)
                {
                    Functions.DoString("talentCount=GetNumTalents(" + i + ");");
                    int talentCount = Convert.ToInt32(Functions.GetText("talentCount"));
                    for (int j = 1; j <= talentCount; j++)
                    {
                        Functions.DoString("tanlentN,_,_,_,tanlentC,tanlentM=GetTalentInfo(" + i + "," + j + ");");
                        TanletList.Add(new Talent(Functions.GetText("tanlentN"), i, j, Convert.ToInt32(Functions.GetText("tanlentC")), Convert.ToInt32(Functions.GetText("tanlentM"))));
                    }
                }
            }

            for (int i = 0; i < Options.Tanlet.Length; i++)
            {
                int toNumber = Convert.ToInt32(Options.Tanlet.Substring(i, 1));
                if (i < TanletList.Count)
                {
                    var talent = TanletList[i];
                    if (toNumber > talent.current && toNumber <= talent.max)
                    {
                        Functions.DoString("LearnTalent(" + talent.tab + "," + talent.index + ")");
                        return;
                    }
                }

            }
            learnEnd = true;
        }
    }
}