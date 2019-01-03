using System;
using System.Collections.Generic;
using System.Reflection;
using ZzukBot.Engines.Grind;
using ZzukBot.Engines.Party;
using ZzukBot.Mem;
using ZzukBot.Settings;
using obj = ZzukBot.Engines.CustomClass.Objects;

namespace ZzukBot.Engines.CustomClass
{
    /// <summary>
    ///     Overrideable class to create CustomClasses
    /// </summary>
    [Obfuscation(Feature = "renaming", ApplyToMembers = true)]
    public class PartyCustomClass:CustomClass
    {
        #region overrides

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override  bool Buff()
        {
            if (PartyAssist.InSignAll()) {
                return BuffAll(PartyAssist.members);
            }
            return true;
        }

        public virtual bool BuffAll(List<PartyMember> members)
        {
           
            return true;
        }

        #endregion
    }
}