using System.Linq;
using System.Reflection;
using ZzukBot.Constants;
using ZzukBot.Helpers;
using ZzukBot.Mem;
using ZzukBot.Objects;

namespace ZzukBot.Engines.CustomClass.Objects
{
    /// <summary>
    ///     Representing the characters target.
    /// </summary>
    /// <seealso cref="_Unit" />
    [Obfuscation(Feature = "renaming", ApplyToMembers = true)]
    // ReSharper disable once InconsistentNaming
    public class _Target : _Unit
    {
        internal _Target() { }

        /// <summary>
        /// 周围目标数量
        /// </summary>
        public int RoundEnemyCount
        {
            get {
                var mobs = ObjectManager.Player.InBattleGround ? ObjectManager.Players : ObjectManager.Npcs;
                return mobs.Count(i => Calc.Distance2D(i.Position, this.Ptr.Position) < 20 && i.Health != 0 && i.Reaction != Enums.UnitReaction.Friendly&& i.Reaction != Enums.UnitReaction.Neutral);
            }
        }
    }

}