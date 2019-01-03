using System.Collections.Generic;
using ZzukBot.Constants;
using ZzukBot.Engines.Party;
using ZzukBot.Helpers;
using ZzukBot.Mem;
using ZzukBot.Settings;

namespace ZzukBot.Engines.Grind.Info
{
    internal class _Vendor
    {
        internal bool GoBackToGrindAfterVendor = false;
        internal bool RegenerateSubPath = false;

        internal bool TravelingToVendor;

        internal _Vendor()
        {
            _NeedToVendor = false;
            TravelingToVendor = false;
        }

        private bool _NeedToVendor { get; set; }


         internal bool NeedToVendorParty
        {
            get
            {
                NeedToVendorPartyCheck();
                return PartyAssist.FocusToVendor&&(PartyAssist.Local.isLeader|| Calc.Distance2D(ObjectManager.Player.Position, Grinder.Access.Profile.RepairNPC.Coordinates) < 40);
            }
        }
        private void NeedToVendorPartyCheck()
        {
            if (!PartyAssist.FocusToVendor) {
                if ( ObjectManager.Player.Inventory.DurabilityPercentage < 30)
                {
                    Lua.RunInMainthread("SendChatMessage('vendor','PARTY')");
                    PartyAssist.FocusToVendor = true;
                }
            }
        }
        internal bool NeedToVendor
        {
            get
            {
                var res = ObjectManager.Player.Inventory.FreeSlots < Options.MinFreeSlotsBeforeVendor;
                if (res) _NeedToVendor = true;
                return _NeedToVendor;
            }
        }

        internal bool GossipOpen
        {
            get
            {
                var encryptedName = Strings.GT_IsVendorOpen.GenLuaVarName();
                Functions.DoString(Strings.IsVendorOpen.Replace(Strings.GT_IsVendorOpen, encryptedName));
                var res = Functions.GetText(encryptedName) == "true";
                return res;
            }
        }

        internal void DoneVendoring()
        {
            _NeedToVendor = false;
            PartyAssist.FocusToVendor = false;
            PartyAssist.Local.Report(5);
        }
    }
}