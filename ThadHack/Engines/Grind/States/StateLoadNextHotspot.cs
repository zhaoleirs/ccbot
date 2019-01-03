using ZzukBot.FSM;
using ZzukBot.Settings;

namespace ZzukBot.Engines.Grind.States
{
    internal class StateLoadNextHotspot : State
    {
        internal override int Priority => 15;

        internal override bool NeedToRun => Grinder.Access.Info.Waypoints.AtLastWaypoint;

        internal override string Name => "Loading next Hotspot";

        internal override void Run()
        {
            if (Options.TravelMode && Grinder.Access.Info.Waypoints.isReachOriginalWaypointEnd(1.8f))
            {
                EngineManager.StopCurrentEngine();
            }
            else
            {
                Grinder.Access.Info.Waypoints.LoadNextHotspot();
            }
        }
    }
}