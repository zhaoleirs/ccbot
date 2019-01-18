using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZzukBot.Constants;
using ZzukBot.Engines.Grind.Info.Path.Base;
using ZzukBot.FSM;
using ZzukBot.GUI_Forms;
using ZzukBot.Helpers;
using ZzukBot.Mem;
using ZzukBot.Settings;

namespace ZzukBot.Engines.Grind.States
{
    internal class StateMail : State
    {

        internal override int Priority => 100;

        internal override bool NeedToRun => Grinder.Access.Info.Mail.NeedToMail;

        internal override string Name => "MailTo";

        internal override void Run()
        {
            //ClickSendMailItemButton
            if (Calc.Distance3D(ObjectManager.Player.Position, Grinder.Access.Profile.MailNPC.Coordinates) < 5)
            {
                ObjectManager.Player.CtmStopMovement();
                var mail = ObjectManager.GameObjects.FirstOrDefault(i => i.Name == Grinder.Access.Profile.MailNPC.Name);
                if (!Grinder.Access.Info.Vendor.MailOpen)
                {
                    ObjectManager.Player.CancelShapeshift();
                    ObjectManager.Player.RightClick(mail);
                }
                else
                {
                    bool Done = !ObjectManager.Player.Inventory.MailItems();
                    Functions.DoString("ClickSendMailItemButton(1)");
                    Functions.DoString("SendMail('" + Options.MailTo + "', 'Hey Bob', 'Hows it going, Bob?')");
                    if (Done)
                    {
                        Grinder.Access.Info.Mail.AfterMail = false;
                        Grinder.Access.Info.Mail.MailProcess = false;
                        Functions.DoString("ClearCursor()");
                    }
                }
            }
            else {
                if (Grinder.Access.Info.Mail.RegenerateSubPath)
                {
                    var tmpList = new List<Waypoint>();
                    if (Grinder.Access.Profile.MailHotspots != null && Grinder.Access.Profile.MailHotspots.Length != 0)
                    {
                        tmpList.AddRange(Grinder.Access.Profile.MailHotspots);
                    }
                    var tmpWp = new Waypoint
                    {
                        Position = Grinder.Access.Profile.MailNPC.Coordinates,
                        Type = Enums.PositionType.Hotspot
                    };
                    tmpList.Add(tmpWp);
                    Grinder.Access.Info.PathManager.GrindToMail = new BasePath(tmpList);

                    Grinder.Access.Info.PathManager.GrindToMail.RegenerateSubPath();
                    Grinder.Access.Info.Mail.RegenerateSubPath = false;
                }
                if (!Grinder.Access.Info.PathManager.GrindToMail.ArrivedAtDestination)
                {
                    var to = Grinder.Access.Info.PathManager.GrindToMail.NextWaypoint;
                    ObjectManager.Player.CtmTo(to);
                }
                else {
                    Grinder.Access.Info.PathToPosition.ToPos(Grinder.Access.Profile.MailNPC.Coordinates);
                }
            }
        }
    }
}
