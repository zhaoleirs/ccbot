using System.Collections.Generic;

namespace ZzukBot.Settings
{
    /// <summary>
    ///     The class containing settings the user made
    /// </summary>
    public static class Options
    {
        internal static string ZzukAccountMail = "";
        internal static string ZzukAccountPassword = "";

        internal static string AccountName = "";
        internal static string AccountPassword = "";
        internal static int RestManaAt = 40;
        internal static string Drink = "";
        internal static int RestHealthAt = 40;
        internal static string Food = "";
        internal static string PetFood = "";
        internal static float MobSearchRange = 20;
        internal static float MaxDiffToWp = 100;
        internal static float CombatDistance = 4;
        internal static int MinFreeSlotsBeforeVendor = 3;
        internal static int KeepItemsFromQuality = 2;
        internal static string[] ProtectedItems = {};
        internal static decimal WaypointModifier = 0;

        internal static string LastProfile = "";

        internal static int CapFpsTo = 60;

        internal static bool StopOnRare = false;
        internal static bool NotifyOnRare = false;

        internal static int ForceBreakAfter = 0;
        internal static int BreakFor = 0;

        internal static string RealmList = "";

        internal static bool BeepOnWhisper = false;
        internal static bool BeepOnSay = false;
        internal static bool BeepOnName = false;

        internal static bool UseIRC = false;
        internal static string IRCBotNickname = "";
        internal static string IRCBotChannel = "";

        internal static bool SkinUnits = false;
        internal static bool NinjaSkin = false;
        internal static bool LootUnits = true;
        internal static bool Herb = false;
        internal static bool Mine = false;
        internal static bool TravelMode=false;
        public static bool GroupMode = false;
        internal static string Tanlet;
        internal static decimal TargetZ;
        internal static int LevelOut;
        internal static string[] GrindItems = { };
        internal static int SpaceTime=0;
        internal static string MountName;

        public static class Party
        {

            public static string party1;
            public static string party2;
            public static string party3;
            public static string party4;
            public static string party5;
            internal static int LeaderDistance;
        }
    }
}