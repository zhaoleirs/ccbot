using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZzukBot.Constants;
using ZzukBot.Mem;

namespace ZzukBot.Ingame
{

    internal class Skills { 
       /// Represents a skill
       /// </summary>
        internal class Skill
        {
            internal IntPtr CurPointer;

            internal Skill() { }
            public Enums.Skills Id { get; set; }
            public int CurrentLevel => CurPointer== IntPtr.Zero ? 0:(CurPointer.Add(4).ReadAs<int>() & 0xFFFF);
            public int MaxLevel => CurPointer == IntPtr.Zero ? 0 :(CurPointer.Add(4).ReadAs<int>() >> 16);
        }
        private List<Skill> skills;
        private Skill defaultSkill;
        internal Skills()
        {
            skills = new List<Skill>();
            defaultSkill = new Skill { Id = 0, CurPointer = IntPtr.Zero };
            GetAllPlayerSkills();
        }

        internal Skill GetSkill(Enums.Skills Id) {
            var skill = skills.FirstOrDefault(i => i.Id == Id);
            return skill ?? defaultSkill;
        }

        /// <summary>
        /// Returns all skills the player has learned
        /// </summary>
        /// <returns></returns>
        private void  GetAllPlayerSkills()
        {
            skills.Clear();
            var start = ObjectManager.Player.SkillField;
            var maxSkills = 0x00B700B4.ReadAs<int>();
            for (var i = 0; i < maxSkills + 5; i++)
            {
                var curPointer = start.Add(i * 12);
                var id = curPointer.ReadAs<Enums.Skills>();
                if (!Enum.IsDefined(typeof(Enums.Skills), id))
                {
                    continue;
                }
                var minMax = curPointer.Add(4).ReadAs<int>();

                skills.Add(new Skill
                {
                    Id = id,
                    CurPointer = curPointer
                });
            }
        }
    }
}
