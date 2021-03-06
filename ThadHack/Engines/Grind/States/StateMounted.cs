﻿using ZzukBot.FSM;
using ZzukBot.Helpers;
using ZzukBot.Mem;
using ZzukBot.Settings;

namespace ZzukBot.Engines.Grind.States
{
    internal class StateMounted : State
    {
        internal override int Priority => 20;

        internal override bool NeedToRun
        {
            get
            {
                
                bool needMounted = !ObjectManager.Player.IsMounted&&ObjectManager.Player.CanMounted&& Grinder.Access.Info.Waypoints.NeedMounted;
                return needMounted;
            }
        }// => ;

        internal override string Name => "Mounted";

        internal override void Run()
        {
            if (Wait.ForOrAdd("mounted",5000))
            {
                ObjectManager.Player.CtmStopMovement();
                ObjectManager.Player.Inventory.UseItem(Options.MountName);
            }

        }
    }
}