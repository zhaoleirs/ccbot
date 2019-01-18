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
    internal class _Combat
    {
        private int lastCheck;

        private readonly Random ran = new Random();

        private string[] msgs = { "???", "da guai?", "gengshang", "qu na er", "shen me renwu?", "....", ".....", "ni zuo renwu?" };
        internal int LastFightTick = 0;
        internal string RandomMsg
        {
            get
            {
                return msgs[ran.Next(0, msgs.Length)];
            }
        }

        internal Dictionary<ulong, int> UnitsDottedByPlayer { get; set; } = new Dictionary<ulong, int>();

        internal _Combat()
        {
            BlacklistedUnits = new List<ulong>();
            OldGuid = 0;
            OldHpPercent = 100;
        }

        // Mobs that attck us
        internal List<WoWUnit> Attackers
        {
            get
            {
                var mobs = ObjectManager.Player.InBattleGround?ObjectManager.Players:ObjectManager.Npcs;
                if (Options.GroupMode)
                {
                        mobs = mobs
                        .Where(i => !Grinder.Access.Info.Combat.BlacklistContains(i) &&(ObjectManager.Player.InBattleGround||i.IsMob && !i.IsPlayerPet) && i.Health != 0 &&(PartyAssist.TargetPartyMember(i.TargetGuid)||(i.Reaction != Enums.UnitReaction.Friendly&&PartyAssist.PartyMemberTarget(i.Guid)))).ToList();//
                }
                else {
                mobs = mobs
                    .Where(i =>
                         i.Health != 0 && i.Reaction != Enums.UnitReaction.Friendly && (ObjectManager.Player.InBattleGround || i.IsMob && !i.IsPlayerPet &&
                        (i.TargetGuid == ObjectManager.Player.Guid || ObjectManager.Player.TargetGuid == i.Guid ||
                            (ObjectManager.Player.HasPet && i.TargetGuid == ObjectManager.Player.Pet.Guid)||
                            (i.IsInCombat && i.TappedByMe &&
                             (i.Debuffs.Count > 0 || i.IsCrowdControlled) && UnitsDottedByPlayer.ContainsKey(i.Guid)))) && !ObjectManager.Player.IsEating && !ObjectManager.Player.IsDrinking
                             
                    )
                    .ToList();
                }
                return mobs;
            }
        }
        //
   

        private List<ulong> BlacklistedUnits { get; }
        private ulong OldGuid { get; set; }
        private float OldHpPercent { get; set; }

        internal bool IsMoving => Grinder.Access.Info.PathBackup.MovingBack || Grinder.Access.Info.PathForceBackup.MovingBack ||
                                  Grinder.Access.Info.Target.FixFacing || !Grinder.Access.Info.Target.InSightWithTarget;

        internal bool IsMovingBack => Grinder.Access.Info.PathBackup.MovingBack || Grinder.Access.Info.PathForceBackup.MovingBack;

        internal bool IsAttacker(ulong parGuid)
        {
            var tmpAtt = Attackers;
            return tmpAtt.Any(x => x.Guid == parGuid);
        }

        internal bool IsBlacklisted(WoWUnit parUnit)
        {
            if (parUnit == null) return false;
            if (BlacklistedUnits.Contains(parUnit.Guid))
                return true;

            if (OldGuid != parUnit.Guid)
            {
                OldGuid = parUnit.Guid;
                OldHpPercent = parUnit.HealthPercent;
                Wait.Remove("UnitBlacklist");
                lastCheck = Environment.TickCount;
            }
            else
            {
                if (Environment.TickCount - lastCheck >= 5000)
                {
                    Wait.Remove("UnitBlacklist");
                }
                lastCheck = Environment.TickCount;
                // ReSharper disable once CompareOfFloatsByEqualityOperator
                if (OldHpPercent == parUnit.HealthPercent)
                {
                    if (Wait.For("UnitBlacklist", 25000))
                    {
                        if (!BlacklistedUnits.Contains(parUnit.Guid))
                            BlacklistedUnits.Add(parUnit.Guid);
                    }
                }
                else
                    OldGuid = 0;
            }
            return false;
        }

        internal void AddToBlacklist(ulong parGuid)
        {
            if (!BlacklistedUnits.Contains(parGuid))
                BlacklistedUnits.Add(parGuid);
        }

        internal void RemoveFromBlacklist(ulong parGuid)
        {
            if (BlacklistedUnits.Contains(parGuid))
                BlacklistedUnits.Remove(parGuid);
        }

        internal bool BlacklistContains(ulong parGuid)
        {
            return BlacklistedUnits.Contains(parGuid);
        }

        internal bool BlacklistContains(WoWUnit unit)
        {
            return BlacklistContains(unit.Guid)&& unit.DistanceToPlayer>4;
        }
    }
}