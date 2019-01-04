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
    }
}