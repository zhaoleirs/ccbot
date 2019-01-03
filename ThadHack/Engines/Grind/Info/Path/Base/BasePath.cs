using System.Collections.Generic;
using ZzukBot.Constants;
using ZzukBot.GUI_Forms;
using ZzukBot.Helpers;
using ZzukBot.Mem;

namespace ZzukBot.Engines.Grind.Info.Path.Base
{
    internal class BasePath
    {
        private int SubPathIndex;
        private readonly List<SubPath> SubPaths;
        private XYZ LastPostion;

        internal BasePath(List<Waypoint> parWaypoints)
        {
            SubPaths = new List<SubPath>();
            SubPathIndex = 0;

            for (var i = 0; i < parWaypoints.Count; i++)
            {
                if (i == 0)
                {
                    var Start = new Waypoint
                    {
                        Position = ObjectManager.Player.Position,
                        Type = Enums.PositionType.Hotspot
                    };
                    var End = parWaypoints[i];
                    SubPaths.Add(new SubPath(Start, End));
                }
                else
                {
                    var Start = parWaypoints[i - 1];
                    var End = parWaypoints[i];
                    SubPaths.Add(new SubPath(Start, End));
                }
            }
        }
        internal void SetCurrentWaypointToClosest()
        {
            var closestIndex = SubPathIndex;
            for (var i = SubPathIndex; i < SubPaths.Count; i++)
            {
                float disA;
                float disB;

                if (Shared.IgnoreZAxis)
                {
                    disA = Calc.Distance2D(ObjectManager.Player.Position, SubPaths[closestIndex].EndPoint.Position);
                    disB = Calc.Distance2D(ObjectManager.Player.Position, SubPaths[i].EndPoint.Position);
                }
                else
                {
                    disA = Calc.Distance3D(ObjectManager.Player.Position, SubPaths[closestIndex].EndPoint.Position);
                    disB = Calc.Distance3D(ObjectManager.Player.Position, SubPaths[i].EndPoint.Position);
                }



                if (disB < disA)
                {
                    closestIndex = i;
                }
            }
            SubPathIndex = closestIndex;
        }

        internal SubPath CurrentSubPath => SubPaths[SubPathIndex];

        internal bool NeedToLoadNextSubPath => CurrentSubPath.ArrivedAtEndPoint;

        private bool AtLastSubPath => SubPathIndex == SubPaths.Count - 1;

        internal bool ArrivedAtDestination
        {
            get
            {
                if (!AtLastSubPath) return false;
                return CurrentSubPath.ArrivedAtEndPoint;
            }
        }

        internal XYZ NextWaypoint
        {
            get
            {
                if (NeedToLoadNextSubPath)
                {
                    LoadNextSubPath();
                }
                var playerPosition = ObjectManager.Player.Position;
                if (LastPostion==null)
                {
                    LastPostion= playerPosition;
                }
                else if (Wait.For("basepathout", 5000))
                {
                   // Main.MainForm.AddLog("basepathout:"+ Calc.Distance3D(playerPosition, LastPostion));
                    if (Calc.Distance3D(playerPosition, LastPostion) < 3)
                    {
                        RegenerateSubPath();
                    }
                    else
                    {
                        LastPostion = playerPosition;
                    }
                }
                return CurrentSubPath.CurrentWaypoint;
            }
        }

        internal void LoadNextSubPath()
        {
            if (!NeedToLoadNextSubPath) return;
            if (SubPathIndex <= SubPaths.Count - 2)
            {
                SubPathIndex++;
            }
        }

        internal void RegenerateSubPath()
        {
            CurrentSubPath.RegenerateWaypoints();
        }
    }
}