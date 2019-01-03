﻿using System;
using System.Linq;
using ZzukBot.Constants;
using ZzukBot.Engines.CustomClass;
using ZzukBot.FSM;
using ZzukBot.Helpers;
using ZzukBot.Mem;
using ZzukBot.Objects;

namespace ZzukBot.Engines.Grind.States
{
    internal class StateFight : State
    {
        private bool CanceledLogout = true;
        private readonly Random ran = new Random();

        private WoWUnit target;
        private ulong LastTargetGuid;
        internal override int Priority => 50;

        internal override bool NeedToRun => Grinder.Access.Info.Combat.Attackers.Count != 0;

        internal override string Name => "Fight";

        internal virtual bool GroupRest() {
            return false;
        }
        internal override void Run()
        {
            if (Grinder.Access.Info.Vendor.GoBackToGrindAfterVendor
                || Grinder.Access.Info.Vendor.TravelingToVendor)
            {
                Grinder.Access.Info.Vendor.RegenerateSubPath = true;
            }
            Grinder.Access.Info.PathAfterFightToWaypoint.SetAfterFightMovement();
            Grinder.Access.Info.Combat.LastFightTick = Environment.TickCount + ran.Next(50, 100);
            Grinder.Access.Info.Loot.RemoveRespawnedMobsFromBlacklist(Grinder.Access.Info.Combat.Attackers);
            Grinder.Access.Info.Target.SearchDirect = true;

            if (Grinder.Access.Info.BreakHelper.NeedToBreak)
            {
                if (CanceledLogout)
                {
                    Functions.DoString("CancelLogout()");
                    CanceledLogout = false;
                }
            }
            else
            {
                CanceledLogout = true;
            }

            target = ObjectManager.Target;
            if (target != null)
            {
                // if (!GroupRest())
                // {
                //     if (target.Guid == LastTargetGuid)
                //     {
                //         if (Wait.For("attacktimeout", 20000)) {
                //             if (target.HealthPercent > 90)
                //             {
                //                 Grinder.Access.Info.Combat.AddToBlacklist(target.Guid);
                //             }
                //             else
                //             {
                //                 Wait.Remove("attacktimeout");
                //                 Grinder.Access.Info.Combat.RemoveFromBlacklist(target.Guid);
                //             }
                //         }

                //     }
                //     else
                //     {
                //         Wait.Remove("attacktimeout");
                //         LastTargetGuid = target.Guid;
                //     }
                // }
                // else {
                //     Wait.Remove("attacktimeout");
                // }
                var player = ObjectManager.Player;
                var IsCasting = !(player.Casting == 0 && player.Channeling == 0);
                var targetIsMoving = (target.MovementState & 0x1) == 0x1;
                var playerIsMoving = (player.MovementState & 0x1) == 0x1;
                var distanceToTarget =
                    Calc.Distance3D(player.Position, target.Position);

                if (!Grinder.Access.Info.Combat.IsAttacker(target.Guid)&&!IsCasting)
                {
                    var tmp = Grinder.Access.Info.Combat.Attackers.OrderBy(i => i.Health).FirstOrDefault();
                    if (tmp == null) return;
                    player.SetTarget(tmp);
                    player.Spells.StopCasting();
                    return;
                }

                if (player.IsCtmIdle &&
                    (player.MovementState & (uint) Enums.MovementFlags.Back) != (uint) Enums.MovementFlags.Back
                    && player.MovementState != 0)
                {
                    player.StopMovement(Enums.ControlBits.All);
                    player.CtmStopMovement();
                }

                if (distanceToTarget >= Grinder.Access.Info.Target.CombatDistance && ((!IsCasting
                                                                                       &&
                                                                                       !Grinder.Access.Info.Combat
                                                                                           .IsMoving) ||
                                                                                      !Grinder.Access.Info.Target
                                                                                          .InSightWithTarget))
                {
                    var tu = Grinder.Access.Info.PathToUnit.ToUnit(target);
                    if (tu.Item1)
                        player.CtmTo(tu.Item2);
                    CCManager.MoveToTargetPulse(ref target);
                }
                else
                {
                    if (!Grinder.Access.Info.Combat.IsMoving)
                    {
                        if (playerIsMoving)
                        {
                            if (!(Grinder.Access.Info.Target.CombatDistance < 4 && IsCasting && targetIsMoving)) {

                                //player.CtmSetToIdle();
                                player.CtmStopMovement();
                            }
                        }
                        else
                        {
                            player.CtmSetToIdle();
                            player.Face(target);
                        }
                        Wait.Remove("FixFacingTimer");
                    }
                    else
                    {
                        if (Grinder.Access.Info.Combat.IsMovingBack)
                        {
                        }
                        else if (Grinder.Access.Info.Target.FixFacing)
                        {
                            FixFacing();
                        }
                    }
                    CCManager.FightPulse(ref target);
                }
            }
            else
            {
                var tmp = Grinder.Access.Info.Combat.Attackers.OrderBy(i => i.Health).FirstOrDefault();
                if (tmp == null) return;
                ObjectManager.Player.SetTarget(tmp);
            }
        }

        private void FixFacing()
        {
            if (ObjectManager.Player.IsFacing(target.Position))
            {
                if (!ObjectManager.Player.IsCtmIdle)
                {
                    ObjectManager.Player.CtmStopMovement();
                }
                else
                {
                    if (ObjectManager.Player.MovementState != 0x2)
                        ObjectManager.Player.StartMovement(Enums.ControlBits.Back);
                }
            }
            else
            {
                Grinder.Access.Info.Target.FixFacing = false;
                ObjectManager.Player.StopMovement(Enums.ControlBits.Back);
            }
            if (Wait.For("FixFacingTimer", 1000))
            {
                Grinder.Access.Info.Target.FixFacing = false;
                ObjectManager.Player.StopMovement(Enums.ControlBits.Back);
            }
        }
    }
}