using System;
using System.Text;
using ZzukBot.Constants;
using ZzukBot.Helpers;
using ZzukBot.Mem;
using static ZzukBot.Constants.GameConstants;
using Ptr = ZzukBot.Constants.Offsets;

namespace ZzukBot.Objects
{
    internal class WoWGameObject : WoWObject
    {
        /// <summary>
        ///     Constructor taking guid aswell Ptr to object
        /// </summary>
        internal WoWGameObject(ulong parGuid, IntPtr parPointer, Enums.WoWObjectTypes parType)
            : base(parGuid, parPointer, parType)
        {
            _gatherInfo.RequiredSkill = 0;
            _gatherInfo.Type = Enums.GatherType.Unknown;
        }

        internal int Type => GetDescriptor<int>(0x54);

        private GatherInfo _gatherInfo;
        /// <summary>
        /// Get gathering info about the gameobject
        /// </summary>
        public GatherInfo GatherInfo
        {
            get
            {
                if (_gatherInfo.Type != Enums.GatherType.Unknown) {
                    return _gatherInfo;
                }
                var gameObjType = GetDescriptor<int>(0x54);
                if (gameObjType != 3)
                {
                    return _gatherInfo;//new GatherInfo { RequiredSkill = 0, Type = Enums.GatherType.None };
                }
                var lockRowId = Pointer.Add(0x214).ReadAs<IntPtr>().Add(0x1c).ReadAs<int>();
                var maxLockRowId = 0xc0dae8.ReadAs<int>();
                if (lockRowId > maxLockRowId)
                {
                    return _gatherInfo;//new GatherInfo { RequiredSkill = 0, Type = Enums.GatherType.None };
                }
                var lockRowPtr = 0xc0dae4.ReadAs<IntPtr>().Add(lockRowId * 4).ReadAs<IntPtr>();
                var isGatherType = lockRowPtr.Add(0x4).ReadAs<int>();
                if (isGatherType != 2)
                {
                    return _gatherInfo;//new GatherInfo { RequiredSkill = 0, Type = Enums.GatherType.None };
                }
                var gatherType = lockRowPtr.Add(0x24).ReadAs<int>();
                var requiredSkill = lockRowPtr.Add(0x11 * 4).ReadAs<int>();
                _gatherInfo.RequiredSkill = requiredSkill;
                _gatherInfo.Type = (Enums.GatherType)gatherType;
                return _gatherInfo;//new GatherInfo { RequiredSkill = requiredSkill, Type = (Enums.GatherType)gatherType };
            }
        }

        /// <summary>
        ///     Get the owner of the game object
        /// </summary>
        public ulong OwnedBy => GetDescriptor<ulong>(0x18);

        /// <summary>
        ///     Check if the object is bobbing (obviously only working for bobbers)
        /// </summary>
        public bool IsBobbing => ReadRelative<short>(0xE8) == 1;
        /// <summary>
        ///     Position of object
        /// </summary>
        internal override XYZ Position
        {
            get
            {
                var X = GetDescriptor<float>(Offsets.GameObject.PosX);
                var Y = GetDescriptor<float>(Offsets.GameObject.PosY);
                var Z = GetDescriptor<float>(Offsets.GameObject.PosZ);
                return new XYZ(X, Y, Z);
            }
        }

        /// <summary>
        ///     Name of object
        /// </summary>
        internal override string Name
        {
            get
            {
                var ptr1 = ReadRelative<IntPtr>(Offsets.GameObject.NameBase);
                var ptr2 = Memory.Reader.Read<IntPtr>(IntPtr.Add(ptr1, Offsets.GameObject.NameBasePtr1));
                return Memory.Reader.ReadString(ptr2, Encoding.ASCII, 30);
            }
        }

        /// <summary>
        ///     Distance to object
        /// </summary>
        internal float DistanceTo(WoWObject parOtherObject)
        {
            return Calc.Distance2D(Position, parOtherObject.Position);
        }

        internal float Distance3DTo(WoWObject parOtherObject)
        {
            return Calc.Distance3D(Position, parOtherObject.Position);
        }

        internal void Interact(bool parAutoLoot)
        {
            Functions.OnRightClickObject(Pointer, Convert.ToInt32(parAutoLoot));
        }
    }
}