using System;
using ZzukBot.Constants;
using ZzukBot.FSM;
using ZzukBot.Helpers;
using ZzukBot.Mem;
using ZzukBot.Settings;

namespace ZzukBot.Engines.Grind.States
{
    internal class StateWalk : State
    {
        internal Random ran = new Random();

        internal override int Priority => 10;

        internal override bool NeedToRun => (((ObjectManager.Player.MovementState &(int) Enums.MovementFlags.Front)!= (int) Enums.MovementFlags.Front)
                                                || !Grinder.Access.Info.Waypoints.NeedToLoadNextWaypoint()
                                                ||GroupCondition())
                                            && ObjectManager.Player.Casting == 0
                                            && ObjectManager.Player.Channeling == 0;

        internal override string Name => "Walking";

        internal virtual bool GroupCondition() {
            return false;
        }
        internal override void Run()
        {
            // start movement to the current waypoint
            if (ObjectManager.Player.Casting != 0)
                return;
            if (!string.IsNullOrEmpty(Options.MountName)) {
                if (Calc.Distance2D(ObjectManager.Player.Position, Grinder.Access.Info.Waypoints.CurrentHotspot) > 50) {
                    if (!ObjectManager.Player.IsMounted) {
                        ObjectManager.Player.Inventory.UseItem(Options.MountName);
                    }
                }
            }
            Shared.RandomJump();
            Grinder.Access.Info.PathAfterFightToWaypoint.AdjustPath();

            // ReSharper disable once ConvertIfStatementToConditionalTernaryExpression
            if (Grinder.Access.Info.PathAfterFightToWaypoint.AfterFightMovement)
            {
                ObjectManager.Player.CtmTo(
                    Grinder.Access.Info.PathToPosition.ToPos(Grinder.Access.Info.Waypoints.CurrentWaypoint));
            }
            else
            {
                ObjectManager.Player.CtmTo(Grinder.Access.Info.Waypoints.CurrentWaypoint);
            }
        }
    }
}