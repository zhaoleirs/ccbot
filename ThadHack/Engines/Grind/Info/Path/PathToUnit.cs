using System;
using ZzukBot.Helpers;
using ZzukBot.Ingame;
using ZzukBot.Mem;
using ZzukBot.Objects;

namespace ZzukBot.Engines.Grind.Info.Path
{
    internal class _PathToUnit
    {
        private ulong unitLastGuid;
        private IntPtr unitLastPtr;

        internal _PathToUnit()
        {
            unitLastPtr = IntPtr.Zero;
            unitLastGuid = 0;
        }

        private XYZ unitLastPos { get; set; }
        private XYZ playerLastPos { get; set; }
        private int unitLastWaypointIndex { get; set; }
        private XYZ[] unitPath { get; set; }

        internal Tuple<bool, XYZ> ToUnit(WoWObject parUnit)
        {
            if (Calc.Distance2D(ObjectManager.Player.Position, parUnit.Position) < 3)
                return Tuple.Create(true, parUnit.Position);


            if (parUnit.Guid != unitLastGuid ||
                parUnit.Pointer != unitLastPtr ||
                Calc.Distance2D(parUnit.Position, unitLastPos) > 3)
            {
                unitPath = Navigation.CalculatePath(ObjectManager.Player.Position,parUnit.Position, true);
                unitLastWaypointIndex = 0;
                unitLastPos = parUnit.Position;
                unitLastGuid = parUnit.Guid;
                unitLastPtr = parUnit.Pointer;
            }
            if (playerLastPos == null)
            {
                playerLastPos = ObjectManager.Player.Position;
            }
            else if (Wait.For("PathToUnitTime", 5000)) {
                if (Calc.Distance3D(playerLastPos, ObjectManager.Player.Position) < 3)
                {
                    unitPath = Navigation.CalculatePath(ObjectManager.Player.Position, parUnit.Position, true);
                    unitLastWaypointIndex = 0;
                    unitLastPos = parUnit.Position;
                    unitLastGuid = parUnit.Guid;
                    unitLastPtr = parUnit.Pointer;
                }
                else
                {
                    playerLastPos = ObjectManager.Player.Position;
                }
            }
            if (unitPath.Length > 0)
            {
                if (Grinder.Access.Info.Waypoints.
                    NeedToLoadNextWaypoint(unitPath[unitLastWaypointIndex]))
                    //if (ObjectManager.Player.DistanceTo(
                    //    unitPath[unitLastWaypointIndex]) < 1.2f)
                {
                    var tmp = unitLastWaypointIndex + 1;
                    if (tmp != unitPath.Length)
                        unitLastWaypointIndex = tmp;
                }
            }
            var nextPoint = unitPath[unitLastWaypointIndex];
            return Tuple.Create(true, nextPoint);
        }
    }
}