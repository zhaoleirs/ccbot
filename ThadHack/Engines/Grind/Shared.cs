using System;
using ZzukBot.Helpers;
using ZzukBot.Mem;

namespace ZzukBot.Engines.Grind
{
    internal class Shared
    {
        private static readonly Random ran = new Random();

        internal static bool StartedMovement = false;

        private static readonly Random random = new Random();

        internal static bool IgnoreZAxis = false;
        private static DateTime JumpTime=DateTime.Now;

        internal static void RandomJump()
        {
            if (JumpTime.AddSeconds(20)<DateTime.Now)
            {
                Functions.DoString("Jump()");
                ResetJumper();
            }
        }

        internal static void ResetJumper()
        {
            JumpTime = DateTime.Now;
        }


        internal static void RandomResetJumper()
        {
            if (random.Next(1, 3) == 2)
                ResetJumper();
        }

        public static void RandomResetJumperComplete()
        {
            if (random.Next(1, 4) == 2)
            {
                ResetJumper();
            }
        }
    }
}