using System;
using System.Collections.Generic;
using System.IO;
using System.Windows.Forms;
using System.Xml.Linq;
using ZzukBot.GUI_Forms;

namespace ZzukBot.Settings
{
    /// <summary>
    ///     Class to manage the options
    /// </summary>
    internal static class OptionManager
    {
        /// <summary>
        ///     Holding the path to the xml file
        /// </summary>
        private static XDocument doc;

        private static string ProtectedItems => Paths.Root + "\\Settings\\ProtectedItems.ini";
        private static string GrindItems => Paths.Root + "\\Settings\\GrindItems.ini";

        internal static bool SaveZzukPassword
        {
            get
            {
                var element = doc.Element("Settings");
                var tmp = element.Element("ZzukSavePassword");
                if (tmp == null)
                {
                    element.Add(new XElement("ZzukSavePassword", false));
                }

                doc.Save(Paths.Settings);
                return (bool) element.Element("ZzukSavePassword");
            }
        }

        /// <summary>
        ///     Set the path to the xml file and the form
        /// </summary>
        internal static void LoadXmlSettings()
        {
            doc = XDocument.Load(Paths.Settings);
        }

        /// <summary>
        ///     load all settings
        /// </summary>
        internal static void LoadSettings()
        {
            LoadFromXml();
            AppendProtectedItemsFromFile(Main.MainForm.tbProtectedItems);
            AppendGrindItemsFromFile(Main.MainForm.tbGrindItems);
        }
        private static void AppendGrindItemsFromFile(TextBox parTb)
        {
            if (!File.Exists(GrindItems))
                File.Create(GrindItems).Close();

            var tmpItems = new List<string>();
            parTb.Clear();
            foreach (var x in File.ReadAllLines(GrindItems))
            {
                var tmp = x.Trim();
                if (string.IsNullOrWhiteSpace(tmp)) continue;
                tmpItems.Add(tmp);
                parTb.Text += tmp + Environment.NewLine;
            }
            Options.GrindItems = tmpItems.ToArray();
        }
        private static void AppendProtectedItemsFromFile(TextBox parTb)
        {
            if (!File.Exists(ProtectedItems))
                File.Create(ProtectedItems).Close();

            var tmpItems = new List<string>();
            parTb.Clear();
            foreach (var x in File.ReadAllLines(ProtectedItems))
            {
                var tmp = x.Trim();
                if (string.IsNullOrWhiteSpace(tmp)) continue;
                tmpItems.Add(tmp);
                parTb.Text += tmp + Environment.NewLine;
            }
            Options.ProtectedItems = tmpItems.ToArray();
        }

        private static void LoadFromXml()
        {
            GetElement("AccountName",
                ref Options.AccountName,
                Main.MainForm.tbAccount);

            GetElement("StopOnRare",
                ref Options.StopOnRare,
                Main.MainForm.cbStopOnRare);

            GetElement("NotifyOnRare",
                ref Options.NotifyOnRare,
                Main.MainForm.cbNotifyRare);

            GetElement("PetFood",
                ref Options.PetFood,
                Main.MainForm.tbPetFood);

            GetElement("MountName",
                ref Options.MountName,
                Main.MainForm.tbMount);


            GetElement("MailTo",
                ref Options.MailTo,
                Main.MainForm.tbMailTo);

            GetElement("AccountPassword",
                ref Options.AccountPassword,
                Main.MainForm.tbPassword);


            GetElement("RestManaAt",
                ref Options.RestManaAt,
                Main.MainForm.nudDrinkAt);


            GetElement("LevelOut",
                ref Options.LevelOut,
                Main.MainForm.nudLevelOut);

            GetElement("Drink",
                ref Options.Drink,
                Main.MainForm.tbDrink);


            GetElement("RestHealthAt",
                ref Options.RestHealthAt,
                Main.MainForm.nudEatAt);

            GetElement("Food",
                ref Options.Food,
                Main.MainForm.tbFood);

            GetElement("MobSearchRange",
                ref Options.MobSearchRange,
                Main.MainForm.nudMobSearchRange);

            GetElement("MaxDiffToWp",
                ref Options.MaxDiffToWp,
                Main.MainForm.nudRoamFromWp);

            GetElement("CombatDistance",
                ref Options.CombatDistance,
                Main.MainForm.nudCombatRange);

            GetElement("MinFreeSlotsBeforeVendor",
                ref Options.MinFreeSlotsBeforeVendor,
                Main.MainForm.nudFreeSlots);

            GetElement("KeepItemsFromQuality",
                ref Options.KeepItemsFromQuality,
                Main.MainForm.cbKeepQuality);

            GetElement("WaypointModifier",
                ref Options.WaypointModifier,
                Main.MainForm.nudWaypointModifier);

            GetElement("BeepOnSay",
                ref Options.BeepOnSay,
                Main.MainForm.cbBeepSay);

            GetElement("BeepOnWhisper",
                ref Options.BeepOnWhisper,
                Main.MainForm.cbBeepWhisper);

            GetElement("BeepOnName",
                ref Options.BeepOnName,
                Main.MainForm.cbBeepName);

            GetElement("BreakFor",
                ref Options.BreakFor,
                Main.MainForm.nudBreakFor);

            GetElement("ForceBreakAfter",
                ref Options.ForceBreakAfter,
                Main.MainForm.nudForceBreakAfter);

            GetElement("UseIRC",
                ref Options.UseIRC,
                Main.MainForm.cbIRCConnect);

            GetElement("IRCBotNickname",
                ref Options.IRCBotNickname,
                Main.MainForm.tbIRCBotNickname);

            GetElement("IRCBotChannel",
                ref Options.IRCBotChannel,
                Main.MainForm.tbIRCBotChannel);

            GetElement("SkinUnits",
                ref Options.SkinUnits,
                Main.MainForm.cbSkinUnits);

            GetElement("NinjaSkin",
                ref Options.NinjaSkin,
                Main.MainForm.cbNinjaSkin);

            GetElement("LootUnits",
                ref Options.LootUnits,
                Main.MainForm.cbLootUnits);

            GetElement("Herb",
                ref Options.Herb,
                Main.MainForm.cbHerb);

            GetElement("Mine",
                ref Options.Mine,
                Main.MainForm.cbMine);

            GetElement("TravelMode",
                ref Options.TravelMode,
                Main.MainForm.checkBoxTravel);


            GetElement("GroupMode",
                ref Options.GroupMode,
                Main.MainForm.cbGroupMode);

            GetElement("Tanlet",
                ref Options.Tanlet,
                Main.MainForm.tbTanlet);


            GetElement("TargetZ",
                ref Options.TargetZ,
                Main.MainForm.nudTargetZ);

            GetElement("Party1",
            ref Options.Party.party1,
            Main.MainForm.tbParty1);

            GetElement("Party2",
            ref Options.Party.party2,
            Main.MainForm.tbParty2); 

            GetElement("Party3",
            ref Options.Party.party3,
            Main.MainForm.tbParty3);

            GetElement("Party4",
            ref Options.Party.party4,
            Main.MainForm.tbParty4);

            GetElement("Party5",
            ref Options.Party.party5,
            Main.MainForm.tbParty5);

            GetElement("LeaderDistance",
            ref Options.Party.LeaderDistance,
            Main.MainForm.nudLeaderDistance);


            GetElement("BattleGround",
            ref Options.Party.BattleGround,
            Main.MainForm.tbBattleGround);

            var element = doc.Element("Settings");
            if (element.Element("LastProfile") == null) {
                element.Add(new XElement("LastProfile", ""));
            }
            Options.LastProfile = element.Element("LastProfile").Value;
            //GetProtectedItems(ref Options.ProtectedItems, Main.MainForm.tbProtectedItems);
        }

        /// <summary>
        ///     Save all settings
        /// </summary>
        internal static void SaveSettings()
        {
            SaveElement("AccountName", Options.AccountName);
            SaveElement("AccountPassword", Options.AccountPassword);
            SaveElement("RestManaAt", Options.RestManaAt);
            SaveElement("LevelOut", Options.LevelOut);
            SaveElement("Drink", Options.Drink);
            SaveElement("LastProfile", Options.LastProfile);
            SaveElement("RestHealthAt", Options.RestHealthAt);
            SaveElement("Food", Options.Food);
            SaveElement("MountName", Options.MountName);
            SaveElement("MailTo", Options.MailTo);
            SaveElement("MobSearchRange", Options.MobSearchRange);
            SaveElement("MaxDiffToWp", Options.MaxDiffToWp);
            SaveElement("CombatDistance", Options.CombatDistance);
            SaveElement("MinFreeSlotsBeforeVendor", Options.MinFreeSlotsBeforeVendor);
            SaveElement("KeepItemsFromQuality", Options.KeepItemsFromQuality);
            SaveElement("WaypointModifier", Options.WaypointModifier);
            SaveElement("PetFood", Options.PetFood);

            SaveElement("BeepOnName", Options.BeepOnName);
            SaveElement("BeepOnSay", Options.BeepOnSay);
            SaveElement("BeepOnWhisper", Options.BeepOnWhisper);

            SaveElement("StopOnRare", Options.StopOnRare);
            SaveElement("NotifyOnRare", Options.NotifyOnRare);

            SaveElement("ForceBreakAfter", Options.ForceBreakAfter);
            SaveElement("BreakFor", Options.BreakFor);

            SaveElement("UseIRC", Options.UseIRC);
            SaveElement("IRCBotNickname", Options.IRCBotNickname);
            SaveElement("IRCBotChannel", Options.IRCBotChannel);

            SaveElement("LootUnits", Options.LootUnits);
            SaveElement("SkinUnits", Options.SkinUnits);
            SaveElement("NinjaSkin", Options.NinjaSkin);
            SaveElement("Herb", Options.Herb);
            SaveElement("Mine", Options.Mine);
            SaveElement("Tanlet", Options.Tanlet);
            SaveElement("TargetZ", Options.TargetZ);
            SaveElement("CapFps", Options.CapFpsTo);

            SaveElement("TravelMode", Options.TravelMode);
            SaveElement("GroupMode", Options.GroupMode);
            SaveElement("Party1", Options.Party.party1);
            SaveElement("Party2", Options.Party.party2);
            SaveElement("Party3", Options.Party.party3);
            SaveElement("Party4", Options.Party.party4);
            SaveElement("Party5", Options.Party.party5);
            SaveElement("LeaderDistance", Options.Party.LeaderDistance);
            SaveElement("BattleGround", Options.Party.BattleGround);

            UpdateProtectedItems();
            UpdateGrindItems();
        }

        internal static string LoadZzukLogin()
        {
            return GetEmail() + ";" + GetEmailPassword();
        }

        internal static void SaveZzukLogin(string parEmail, string parPass, bool parSavePw)
        {
            SaveElement("ZzukAccountEmail", parEmail);
            SaveElement("ZzukAccountPassword", parSavePw ? parPass : "");
            SaveElement("ZzukSavePassword", parSavePw);
        }

        private static string GetEmail()
        {
            var element = doc.Element("Settings");
            var tmp = element.Element("ZzukAccountEmail");
            if (tmp == null)
            {
                element.Add(new XElement("ZzukAccountEmail", Options.ZzukAccountMail));
            }

            doc.Save(Paths.Settings);
            return (string) element.Element("ZzukAccountEmail");
        }

        private static string GetEmailPassword()
        {
            var element = doc.Element("Settings");
            var tmp = element.Element("ZzukAccountPassword");
            if (tmp == null)
            {
                element.Add(new XElement("ZzukAccountPassword", Options.ZzukAccountPassword));
            }

            doc.Save(Paths.Settings);
            return (string) element.Element("ZzukAccountPassword");
        }

        /// <summary>
        ///     Get Element with Name, value will be stored in value parameter
        ///     if element doesnt exist create it with value parameter as value
        /// </summary>
        private static void GetElement<T, X>(string Name, ref T Value, X control)
        {
            var element = doc.Element("Settings");
            var tmp = element.Element(Name);
            if (tmp == null)
            {
                element.Add(new XElement(Name, Value));
            }
            Value = (T) Convert.ChangeType(element.Element(Name).Value, typeof (T));

            object o = control;
            var x = (Control) o;
            Main.MainForm.UpdateControl(Value, x);
            doc.Save(Paths.Settings);
        }

        /// <summary>
        ///     Save the element with the value
        ///     Only works if the element exists
        /// </summary>
        private static void SaveElement<T>(string Name, T Value)
        {
            try
            {
                var element = doc.Element("Settings").Element(Name);
                element.Value = Value.ToString();
                doc.Save(Paths.Settings);
            }
            catch
            {
                // ignored
            }
        }

        /// <summary>
        ///     Get all protected items
        /// </summary>
        /// <summary>
        ///     Enums for WoW, no commenting needed
        /// </summary>
        private static void UpdateProtectedItems()
        {
            File.Create(ProtectedItems).Close();
            var tmpText = "";
            // ReSharper disable once LoopCanBeConvertedToQuery
            foreach (string t in Options.ProtectedItems)
            {
                var tmp = t.Trim();
                if (!string.IsNullOrWhiteSpace(tmp))
                {
                    tmpText += tmp + Environment.NewLine;
                }
            }
            File.WriteAllText(ProtectedItems, tmpText);
        }

        private static void UpdateGrindItems()
        {
            File.Create(GrindItems).Close();
            var tmpText = "";
            // ReSharper disable once LoopCanBeConvertedToQuery
            foreach (string t in Options.GrindItems)
            {
                var tmp = t.Trim();
                if (!string.IsNullOrWhiteSpace(tmp))
                {
                    tmpText += tmp + Environment.NewLine;
                }
            }
            File.WriteAllText(GrindItems, tmpText);
        }
    }
}