using System;
using ZzukBot.Settings;

namespace ZzukBot.Constants
{
    internal static class Enums
    {
        internal enum WoWObjectTypes : byte
        {
            OT_NONE = 0,
            OT_ITEM = 1,
            OT_CONTAINER = 2,
            OT_UNIT = 3,
            OT_PLAYER = 4,
            OT_GAMEOBJ = 5,
            OT_DYNOBJ = 6,
            OT_CORPSE = 7
        }
        public enum Skills : short
        {
            FROST = 6,
            FIRE = 8,
            ARMS = 26,
            COMBAT = 38,
            SUBTLETY = 39,
            POISONS = 40,
            SWORDS = 43,
            AXES = 44,
            BOWS = 45,
            GUNS = 46,
            BEAST_MASTERY = 50,
            SURVIVAL = 51,
            MACES = 54,
            TWOHAND_SWORDS = 55,
            HOLY = 56,
            SHADOW = 78,
            DEFENSE = 95,
            LANG_COMMON = 98,
            RACIAL_DWARVEN = 101,
            LANG_ORCISH = 109,
            LANG_DWARVEN = 111,
            LANG_DARNASSIAN = 113,
            LANG_TAURAHE = 115,
            DUAL_WIELD = 118,
            RACIAL_TAUREN = 124,
            ORC_RACIAL = 125,
            RACIAL_NIGHT_ELF = 126,
            FIRST_AID = 129,
            FERAL_COMBAT = 134,
            LANG_THALASSIAN = 137,
            STAVES = 136,
            LANG_DRACONIC = 138,
            LANG_DEMON_TONGUE = 139,
            LANG_TITAN = 140,
            LANG_OLD_TONGUE = 141,
            SURVIVAL2 = 142,
            RIDING_HORSE = 148,
            RIDING_WOLF = 149,
            RIDING_RAM = 152,
            RIDING_TIGER = 150,
            SWIMING = 155,
            TWOHAND_MACES = 160,
            UNARMED = 162,
            MARKSMANSHIP = 163,
            BLACKSMITHING = 164,
            LEATHERWORKING = 165,
            ALCHEMY = 171,
            TWOHAND_AXES = 172,
            DAGGERS = 173,
            THROWN = 176,
            HERBALISM = 182,
            GENERIC_DND = 183,
            RETRIBUTION = 184,
            COOKING = 185,
            MINING = 186,
            PET_IMP = 188,
            PET_FELHUNTER = 189,
            TAILORING = 197,
            ENGINERING = 202,
            PET_SPIDER = 203,
            PET_VOIDWALKER = 204,
            PET_SUCCUBUS = 205,
            PET_INFERNAL = 206,
            PET_DOOMGUARD = 207,
            PET_WOLF = 208,
            PET_CAT = 209,
            PET_BEAR = 210,
            PET_BOAR = 211,
            PET_CROCILISK = 212,
            PET_CARRION_BIRD = 213,
            PET_GORILLA = 215,
            PET_CRAB = 214,
            PET_RAPTOR = 217,
            PET_TALLSTRIDER = 218,
            RACIAL_UNDED = 220,
            CROSSBOWS = 226,
            SPEARS = 227,
            WANDS = 228,
            POLEARMS = 229,
            ATTRIBUTE_ENCHANCEMENTS = 230,
            SLAYER_TALENTS = 231,
            MAGIC_TALENTS = 233,
            DEFENSIVE_TALENTS = 234,
            PET_SCORPID = 236,
            ARCANE = 237,
            PET_TURTLE = 251,
            FURY = 256,
            PROTECTION = 257,
            BEAST_TRAINING = 261,
            PROTECTION2 = 267,
            PET_TALENTS = 270,
            PLATE_MAIL = 293,
            ASSASSINATION = 253,
            LANG_GNOMISH = 313,
            LANG_TROLL = 315,
            ENCHANTING = 333,
            DEMONOLOGY = 354,
            AFFLICTION = 355,
            FISHING = 356,
            ENHANCEMENT = 373,
            RESTORATION = 374,
            ELEMENTAL_COMBAT = 375,
            SKINNING = 393,
            LEATHER = 414,
            CLOTH = 415,
            MAIL = 413,
            SHIELD = 433,
            FIST_WEAPONS = 473,
            TRACKING_BEAST = 513,
            TRACKING_HUMANOID = 514,
            TRACKING_DEMON = 516,
            TRACKING_UNDEAD = 517,
            TRACKING_DRAGON = 518,
            TRACKING_ELEMENTAL = 519,
            RIDING_RAPTOR = 533,
            RIDING_MECHANOSTRIDER = 553,
            RIDING_UNDEAD_HORSE = 554,
            RESTORATION2 = 573,
            BALANCE = 574,
            DESTRUCTION = 593,
            HOLY2 = 594,
            DISCIPLINE = 613,
            LOCKPICKING = 633,
            PET_BAT = 653,
            PET_HYENA = 654,
            PET_OWL = 655,
            PET_WIND_SERPENT = 656,
            LANG_GUTTERSPEAK = 673,
            RIDING_KODO = 713,
            RACIAL_TROLL = 733,
            RACIAL_GNOME = 753,
            RACIAL_HUMAN = 754,
            JEWELCRAFTING = 755,
            RACIAL_BLOODELF = 756,
            PET_EVENT_REMOTECONTROL = 758,
            LANG_DRAENEI = 759,
            DRAENEI_RACIAL = 760,
            PET_FELGUARD = 761,
            RIDING = 762,
            PET_DRAGONHAWK = 763,
            PET_NETHER_RAY = 764,
            PET_SPOREBAT = 765,
            PET_WARP_STALKER = 766,
            PET_RAVAGER = 767,
            PET_SERPENT = 768,
            INTERNAL = 769,
        }
        /// <summary>
        /// Gather types of WoW
        /// </summary>
        internal enum GatherType
        {

            Unknown = -2,
            None = -1,
            Herbalism = 2,
            Mining = 3
        }

        internal static class CreatureType
        {
            internal static int Beast = 1;
            internal static int Dragonkin = 2;
            internal static int Demon = 3;
            internal static int Elemental = 4;
            internal static int Giant = 5;
            internal static int Undead = 6;
            internal static int Humanoid = 7;
            internal static int Critter = 8;
            internal static int Mechanical = 9;
            internal static int NotSpecified = 10;
            internal static int Totem = 11;
        }


        internal static class DynamicFlags
        {
            internal static uint IsMarked = 0x2;
            internal static uint CanBeLooted = 0xD;
            internal static uint TappedByMe = 0xC;
            internal static uint TappedByOther = 0x4;
            internal static uint Untouched = 0x0;
            internal static int AuraBase = 0xBC;
            internal static int NextAura = 4;
            //internal static uint CanBeLooted = 0xD;
            //internal static uint TappedByMe = 0xC;
            //internal static uint TappedByOther = 0x4;
            //internal static uint Untouched = 0x0;

            internal static void AdjustToRealm()
            {
                var isElysium = Options.RealmList.Contains("elysium");
                if (!Options.RealmList.Contains("nostalrius") && !isElysium)
                {
                    CanBeLooted = 0x1;
                    TappedByMe = 0x0;
                }
                if (Options.RealmList.Contains("vanillagaming"))
                {
                    AuraBase = 0x138;
                    NextAura = -4;
                }
            }
        }

        internal static class UnitFlags
        {
            internal static int UNIT_FLAG_FLEEING = 0x00800000;
            internal static int UNIT_FLAG_CONFUSED = 0x00400000;
            internal static int UNIT_FLAG_IN_COMBAT = 0x00080000;
            internal static int UNIT_FLAG_SKINNABLE = 0x04000000;
            internal static int UNIT_FLAG_STUNNED = 0x00040000;
            internal static int UNIT_FLAG_DISABLE_MOVE = 0x00000004;
        }

        internal enum MovementFlags : uint
        {
            None = 0x0,
            Front = 0x00000001,
            Back = 0x00000002,
            Left = 0x00000010,
            Right = 0x00000020,
            StrafeLeft = 0x00000004,
            StrafeRight = 0x00000008,

            Swimming = 0x00200000,
            jumping = 0x00002000,
            Falling = 0x0000A000,
            Levitate = 0x70000000
        }

        [Flags]
        internal enum ControlBits : uint
        {
            All = Front | Right | Left | StrafeLeft | StrafeRight | Back,
            Nothing = 0x0,
            CtmWalk = 0x00001000,
            Front = 0x00000010,
            Back = 0x00000020,
            Left = 0x00000100,
            Right = 0x00000200,
            StrafeLeft = 0x00000040,
            StrafeRight = 0x00000080
        }

        internal enum ControlBitsMouse : uint
        {
            Rightclick = 0x00000001,
            Leftclick = 0x00000002
        }

        internal enum ChatType
        {
            Say = 0,
            Yell = 5,
            Channel = 14,
            Group = 1,
            Guild = 3,
            Whisper = 6
        }

        internal enum LoginState
        {
            login,
            charselect
        }

        internal enum UnitReaction : uint
        {
            Neutral = 3,
            Friendly = 4,

            // Guards of the other faction are for example hostile 2.
            // All other hostile mobs I met are just hostile.
            Hostile = 1,
            Hostile2 = 0
        }

        internal enum ClassIds : byte
        {
            Warrior = 1,
            Paladin = 2,
            Hunter = 3,
            Rogue = 4,
            Priest = 5,
            Shaman = 7,
            Mage = 8,
            Warlock = 9,
            Druid = 11
        }

        internal enum MovementOpCodes : uint
        {
            stopTurn = 0xBE,
            turnLeft = 0xBC,
            turnRight = 0xBD,

            moveStop = 0xB7,
            moveFront = 0xB5,
            moveBack = 0xB6,

            setFacing = 0xDA,

            heartbeat = 0xEE,

            strafeLeft = 0xB8,
            strafeRightStart = 0xB9,
            strafeStop = 0xBA
        }

        internal enum ItemQuality
        {
            Grey = 0,
            White = 1,
            Green = 2,
            Blue = 3,
            Epic = 4
        }

        internal enum WaypointType
        {
            Waypoint = 0,
            VendorWaypoint = 1,
            GhostWaypoint = 2
        }

        internal enum CtmType : uint
        {
            FaceTarget = 0x1,
            Face = 0x2,

            /// <summary>
            ///     Will throw a UI error. Have not figured out how to avoid it!
            /// </summary>
            // ReSharper disable InconsistentNaming
            Stop_ThrowsException = 0x3,
            // ReSharper restore InconsistentNaming
            Move = 0x4,
            NpcInteract = 0x5,
            Loot = 0x6,
            ObjInteract = 0x7,
            FaceOther = 0x8,
            Skin = 0x9,
            AttackPosition = 0xA,
            AttackGuid = 0xB,
            ConstantFace = 0xC,
            None = 0xD,
            Attack = 0x10,
            Idle = 0xC
        }

        internal enum PositionType
        {
            Hotspot,
            Waypoint
        }
    }
}