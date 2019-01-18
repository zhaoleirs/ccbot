using System.Runtime.InteropServices;
using ZzukBot.Mem;

namespace ZzukBot.Constants
{
    internal static class GameConstants
    {
        internal const float MaxResurrectDistance = 28;
        internal const int RezzDistanceToHostile = 17;

        public struct GatherInfo
        {
            public Enums.GatherType Type { get; set; }
            public int RequiredSkill { get; set; }
        }


        /// <summary>
        ///     ItemCacheEntry fetched from the game
        /// </summary>
        [StructLayout(LayoutKind.Explicit)]
        public struct ItemCacheEntry
        {
            [FieldOffset(0x0)] public int Id;

            [FieldOffset(0x8)] private readonly int NamePtr;

            [FieldOffset(0x1C)] public int Quality;
            [FieldOffset(0x24)] public int BuyPrice;
            [FieldOffset(0x28)] public int SellPrice;
            [FieldOffset(0x2c)] public int InventoryType;
            [FieldOffset(0x38)] public int ItemLevel;
            [FieldOffset(0x3C)] public int RequiredLevel;
            [FieldOffset(0x5C)] public int MaxCount;
            [FieldOffset(0x60)] public int MaxStackCount;
            [FieldOffset(0x64)] public int ContainerSlots;

            [FieldOffset(0x68)] [MarshalAs(UnmanagedType.Struct)] public _ItemStats ItemStats;

            [FieldOffset(0xB8)] [MarshalAs(UnmanagedType.Struct)] public _Damage Damage;

            [FieldOffset(0xF4)] public int Armor;

            [FieldOffset(0x114)] public int AmmoType;

            [FieldOffset(0x1C4)] public int MaxDurability;

            [FieldOffset(0x1D0)] public int BagFamily;

            [StructLayout(LayoutKind.Sequential)]
            public struct _ItemStats
            {
                [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)] public uint[] ItemStatType;
                [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)] public int[] ItemStatValue;
            }

            [StructLayout(LayoutKind.Sequential)]
            public struct _Damage
            {
                public float DmgMin => BaseDmg + ExtraDmg;

                public float DmgMax => BaseDmgMax + ExtraDmgMax;

                private readonly float BaseDmg;
                private readonly float ExtraDmg;

                private readonly int unk0;
                private readonly int unk1;
                private readonly int unk2;

                private readonly float BaseDmgMax;
                private readonly float ExtraDmgMax;
            }

            public string Name => NamePtr.ReadString();
        }
    }
}