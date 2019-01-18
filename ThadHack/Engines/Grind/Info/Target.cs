using System;
using System.Collections.Generic;
using System.Linq;
using ZzukBot.Constants;
using ZzukBot.Engines.Party;
using ZzukBot.Helpers;
using ZzukBot.Mem;
using ZzukBot.Objects;
using ZzukBot.Settings;

namespace ZzukBot.Engines.Grind.Info
{
    internal class _Target
    {
        internal volatile bool FixFacing;
        internal int HostileMobRange = 15;

        internal volatile bool InSightWithTarget;
        internal volatile int ResetToNormalAt = 0;

        internal bool SearchDirect = false;

        internal _Target()
        {
            InSightWithTarget = true;
            FixFacing = false;
        }
        internal WoWGameObject NextGrind(Enums.GatherType type)
        {
            
            var grinds  = type==Enums.GatherType.Mining? ObjectManager.Mines: ObjectManager.Herbs;
            return grinds.Where(i => !Grinder.Access.Info.Loot.LootBlacklist.Contains(i.Guid) && Calc.Distance3D(i.Position, ObjectManager.Player.Position) <= Options.MobSearchRange && Math.Abs(ObjectManager.Player.Position.Z - i.Position.Z) <= (int)Options.TargetZ && (Options.GrindItems.Contains("*")|| Options.GrindItems.Any(p => p.Contains(i.Name)))).OrderBy(i =>i.DistanceTo(ObjectManager.Player)).FirstOrDefault();
            
        }
        // Get the next mob we should attack
        internal WoWUnit NextTarget
        {
            get
            {
                var mobs = ObjectManager.Player.InBattleGround ? ObjectManager.Players : ObjectManager.Npcs;

                mobs = mobs
                    .Where(
                        i =>
                            i.Health != 0 &&i.RoundEnemyCount<3&&i.Reaction != Enums.UnitReaction.Friendly && (ObjectManager.Player.InBattleGround || (i.IsMob&&!i.IsPlayerPet && ObjectManager.Player.Level - i.Level < Options.LevelOut && i.CreatureRank == 0)  && !Grinder.Access.Info.Combat.BlacklistContains(i) &&
                            (Grinder.Access.Profile.Factions == null || Grinder.Access.Profile.Factions.Contains(i.FactionID)) &&
                            (Grinder.Access.Profile.Ids == null || Grinder.Access.Profile.Ids.Contains(i.NpcID))&& (!i.TappedByOther || i.IsUntouched) &&
                            Calc.Distance3D(i.Position, ObjectManager.Player.Position) <= Options.MobSearchRange &&
                            Math.Abs(ObjectManager.Player.Position.Z - i.Position.Z) <= (int)Options.TargetZ && i.SummonedBy == 0 ))
                    .OrderBy(i =>Calc.Distance3D(i.Position, ObjectManager.Player.Position)).ToList();
                return mobs.FirstOrDefault();
            }
        }

        // should we attack our current target?
        internal bool ShouldAttackTarget
        {
            get
            {
                var target = ObjectManager.Target;
                if (target == null||target.Health==0) return false;
                var ret =
                    target.IsMob && !Grinder.Access.Info.Combat.BlacklistContains(target.Guid) &&
                    target.Reaction != Enums.UnitReaction.Friendly /*&&
                    (target.IsUntouched || target.IsMarked)*/&&( Options.GroupMode||!target.TappedByOther && target.HealthPercent == 100)
                    && !target.IsCritter;

                if (!ret)
                {
                    ObjectManager.Player.SetTarget(0);

                    if (ObjectManager.Player.Casting != 0 || ObjectManager.Player.Channeling != 0)
                    {
                        ObjectManager.Player.StartMovement(Enums.ControlBits.Front);
                        ObjectManager.Player.StopMovement(Enums.ControlBits.Front);
                    }
                }
                return ret;
            }
        }
       
        // In range ton attack target
        internal float CombatDistance
        {
            get
            {
                var tmp = Options.CombatDistance;
                if (!InSightWithTarget)
                {
                    if (!Grinder.Access.Info.Combat.IsMovingBack)
                        tmp = 3;
                    if (Environment.TickCount >= ResetToNormalAt)
                        InSightWithTarget = true;
                }
                return tmp;
            }
        }
    }
}