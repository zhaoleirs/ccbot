using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Windows.Forms;
using ZzukBot.AntiWarden;
using ZzukBot.Constants;
using ZzukBot.Engines.CustomClass;
using ZzukBot.Engines.CustomClass.Objects;
using ZzukBot.Engines.Grind.States;
using ZzukBot.Engines.Party;
using ZzukBot.FSM;
using ZzukBot.GUI_Forms;
using ZzukBot.Helpers;
using ZzukBot.Hooks;
using ZzukBot.Mem;
using ZzukBot.Settings;

namespace ZzukBot.Engines.Grind
{
    internal class Grinder
    {
        internal static Grinder Access;

        internal Grinder()
        {
            Access = this;
            ErrorEnumHook.OnNewError += ErrorEnum_OnNewError;
        }

        //internal _StuckHelper StuckHelper { get; set; }
        // holds details about the currently loaded profile
        internal GrindProfile Profile { get; private set; }
        // the fsm for our grindbot
        internal _Engine Engine { get; private set; }
        // ingame informations
        internal _Info Info { get; private set; }
        // the last state that got run
        internal string LastState { get; private set; }
        internal string LastLastState { get; private set; }
        
        private void ErrorEnum_OnNewError(ErrorEnumArgs e)
        {
           // Main.MainForm.AddLog(e.Message);
            if (e.Message.StartsWith("Target not"))
            {
                if (Access.Info.Combat.IsMovingBack) return;
                if (!Access.Info.Target.InSightWithTarget) return;
                // LosTimer is used within info.target.combatdistance
                Access.Info.Target.InSightWithTarget = false;
                Access.Info.Target.ResetToNormalAt = Environment.TickCount + 3000;
            }
            else if (e.Message.StartsWith("You must be standing") ||
                     e.Message.StartsWith("You need to be standing up to loot"))
            {
                Functions.DoString("SitOrStand()");
            }
            else if (e.Message.StartsWith("You can't mount")|| e.Message.StartsWith("Cannot use while swimming"))
            {
                ObjectManager.Player.UnMountDelay = Environment.TickCount + 20000;
            }
            else if (e.Message.StartsWith("You cannot attack that target") || e.Message.StartsWith("Invalid target"))
            {
                var target = ObjectManager.Target;
                if (target == null) return;
                if (target.Health != 0)
                {
                    Access.Info.Combat.AddToBlacklist(target.Guid);
                }
            }
            else if (e.Message.StartsWith("You are facing the") || e.Message.StartsWith("Target needs to be"))
            {
                var tar = ObjectManager.Target;
                if (tar == null) return;
                if (Access.Info.Combat.IsMoving) return;
                Access.Info.Target.FixFacing = true;
                Wait.Remove("FixFacingTimer");
            }
            else if (e.Message.Contains("mounted"))
            {
                Lua.RunInMainthread(Strings.Dis_Mounted);
            }
            else if (e.Message.StartsWith("Target too close"))
            {
                if (!Access.Info.Combat.IsMoving)
                    Access.Info.PathBackup.SetToCloseForRanged();
            }
            else if (e.Message.StartsWith("You can't carry any")
                     || e.Message.StartsWith("Requires Skinning"))
            {
                Access.Info.Loot.BlacklistCurrentLoot = true;
            }
        }

        /// <summary>
        ///     Code of the grindbot to run in Endscene
        /// </summary>
        private void RareCheck()
        {
            if (Options.StopOnRare || Options.NotifyOnRare)
            {
                if (Wait.For("RareScan12", 10000))
                {
                    if (Options.NotifyOnRare)
                    {
                        var tmp = ObjectManager.Npcs.FirstOrDefault(i => i.IsRareElite && i.Health != 0);
                        if (tmp != null)
                        {
                            if (Calc.Distance3D(ObjectManager.Player.Position, tmp.Position) < 25)
                            {
                                if (!Info.RareSpotter.Notified(tmp.Guid))
                                {
                                    Main.MainForm.updateNotification("Found a rare: " + tmp.Name);
                                }
                            }
                        }
                    }
                    if (Options.StopOnRare)
                    {
                        Stop();
                    }
                }
            }
        }

        private void Refreshments()
        {
            Info.Latency = ObjectManager.Player.GetLatency()*2;
        }



        private void RelogRoutine()
        {

            if (Relog.CurrentWindowName == "RealmList")
            {
                if (Wait.For("CancelRealmSelection", 2000))
                {
                    Wait.Remove("PressLogin");
                    Relog.ResetLogin();
                }
            }
            switch (Relog.LoginState)
            {
                case "login":
                    //var glueText = Relog.GetGlueDialogText().ToLower();
                    if ( Wait.For("SendAccountDetailsWait", 2000))
                        {
                        Relog.ResetLogin();
                        Relog.Login();
                            Wait.Remove("RelogReset");
                            Wait.Remove("RelogReset2");
                            Wait.Remove("StartGhostWalk");
                            Access.Info.SpiritWalk.GeneratePath = true;
                            Wait.Remove("WrongInfo");
                        }
                    break;

                case "charselect":
                    if (Wait.For("EnterWorldClicker", 2000))
                        Functions.EnterWorld();
                    break;
            }
        }

        private void RunGrinder(ref int FrameCounter, bool IsIngame)
        {
            try
            {
                if (FrameCounter%3 == 0)
                {
                    bool inSpaceTime = Info.BreakHelper.InSpaceTime();
                    if (FrameCounter%15 == 0 && IsIngame&&!inSpaceTime)
                    {
                        var dottedUnitsToRemove =
                           Info.Combat.UnitsDottedByPlayer.Where(kvp => Environment.TickCount - kvp.Value >= 40000).ToList();
                        foreach (var item in dottedUnitsToRemove)
                        {
                            Info.Combat.UnitsDottedByPlayer.Remove(item.Key);
                        }
                        var target = ObjectManager.Target;
                        if (target != null)
                        {
                            var debuffCount = target.Debuffs.Count;
                            if (!target.TappedByOther && !target.TappedByMe && debuffCount > 0)
                            {
                                if (!Info.Combat.UnitsDottedByPlayer.ContainsKey(target.Guid))
                                    Info.Combat.UnitsDottedByPlayer.Add(target.Guid, Environment.TickCount);
                            }
                        }
                       
                    }
                    ObjectManager.Player.AntiAfk();

                    if (IsIngame)
                    {
                        if (!inSpaceTime)
                        {
                            if (FrameCounter % 300 == 0)
                            {
                                RareCheck();
                                if (Options.GroupMode)
                                {
                                    PartyAssist.Update();
                                }
                                if (FrameCounter % 1800 == 0)
                                {
                                    Refreshments();
                                }
                            }

                            LastState = Engine.Pulse();
                            if (Options.GroupMode)
                            {
                                if (LastState == "Resting" && LastLastState != "Resting")
                                {
                                    PartyAssist.Local.Report(3);
                                }

                                if (LastLastState == "Resting" && LastState != "Resting")
                                {
                                    PartyAssist.Local.Report(4);
                                }
                                LastLastState = LastState;
                            }
                            Main.MainForm.UpdateControl("State: " + LastState, Main.MainForm.lGrindState);
                            Main.MainForm.UpdateControl("Exp: " + ObjectManager.Player.Level + "(" + ObjectManager.Player.CurrentXp + "/" + ObjectManager.Player.NextLevelXp + ") Players:" + ObjectManager.Players.Count, Main.MainForm.lbExp);
                            Main.MainForm.UpdateControl(ObjectManager.Player.HealthPercent, Main.MainForm.pbHP);
                            Main.MainForm.UpdateControl("Money:"+(ObjectManager.Player.Money/10000)+"g "+ ((ObjectManager.Player.Money % 10000)/100)+"s " + (ObjectManager.Player.Money %100)+"c", Main.MainForm.lbMoney);
                            
                        }
                    }
                    else
                    {
                        if (Info.BreakHelper.NeedToBreak)
                            return;
                        RelogRoutine();
                    }
                }
            }
            catch (Exception e)
            {
                Logger.Append(e.Message, "Exceptions.txt");
            }
        }

        private void StopGrinder(ref int FrameCounter, bool IsIngame)
        {
            Memory.GetHack("Ctm").Remove();
            if (IsIngame)
            {
                // disable all current ingame movements if we are ingame
                ObjectManager.Player.CtmStopMovement();
            }
            if(HookWardenMemScan.GetHack("Collision3")!=null)
                HookWardenMemScan.GetHack("Collision3").Remove();
            if(HookWardenMemScan.GetHack("Collision") !=null)
                HookWardenMemScan.GetHack("Collision").Remove();
            // we arent running anymore
            Access = null;
            ErrorEnumHook.OnNewError -= ErrorEnum_OnNewError;
            DirectX.StopRunning();
        }

        /// <summary>
        ///     Prepare everything (setup fsm, parse profile etc.)
        ///     return true if ingame and profile is valid
        /// </summary>
        [Obfuscation(Feature = "virtualization", Exclude = false)]
        internal bool Prepare(string parProfilePath, Action parCallback)
        {
            if (!ObjectManager.EnumObjects()) return false;
            Profile = new GrindProfile(parProfilePath);
            if (!Profile.ProfileValid) return false;

            if (!CCManager.ChooseCustomClassByWowClass((byte)ObjectManager.Player.Class))
            {
                MessageBox.Show("Couldnt find a Custom Class we can use");
                return false;
            }

           // StuckHelper = new _StuckHelper();
            Info = new _Info();
            Info.Waypoints.LoadFirstWaypointsAsync(parCallback);
            if (Options.GroupMode)
            {
                var tmpStates = new List<State>
                {
                new PartyStateIdle(),
                new PartyStateLoadNextHotspot(),
                new PartyStateLoadNextWaypoint(),
                new PartyStateWalk(),
                new PartyStateFindTarget(),
                new PartyStateApproachTarget(),
                new PartyStateFight(),
                new PartyStateRest(),
                new PartyStateBuff()
                };
                //if (Options.LootUnits)
                //{
                tmpStates.Add(new PartyStateLoot());
                // }
                tmpStates.Add(new PartyStateReleaseSpirit());
                tmpStates.Add(new PartyStateGhostWalk());
                tmpStates.Add(new PartyStateWalkToRepair());
                tmpStates.Add(new PartyStateWalkBackToGrind());
                tmpStates.Add(new PartyStateAfterFightToPath());
                tmpStates.Add(new PartyStateWaitAfterFight());
                tmpStates.Add(new PartyStateDoRandomShit());
                tmpStates.Add(new PartyStateGroup());

                if (Options.BreakFor != 0 && Options.ForceBreakAfter != 0)
                {
                    Info.BreakHelper.SetBreakAt(60000);
                    tmpStates.Add(new PartyStateStartBreak());
                }
                tmpStates.Add(new StateTanlet());
                tmpStates.Add(new PartyStateMounted());

                if (Profile.RepairNPC != null)
                    tmpStates.Add(new PartyStateRepair());

                if (!string.IsNullOrEmpty(Options.Party.BattleGround))
                {
                    tmpStates.Add(new PartyStateBattleGroup());
                }

                tmpStates.Sort();

                Engine = new _Engine(tmpStates);
            }
            else
            {
                var tmpStates = new List<State>
            {
                new StateIdle(),
                new StateLoadNextHotspot(),
                new StateLoadNextWaypoint(),
                new StateWalk(),
                new StateApproachTarget(),
                new StateFight(),
                new StateRest(),
                new StateBuff()
            };
                if (Options.LootUnits)
                {
                    tmpStates.Add(new StateLoot());
                }
                if (Options.Mine || Options.Herb)
                {
                    //tmpStates.Add(new StateFindGrind());
                    tmpStates.Add(new StateGrind());
                }
                else
                {
                    tmpStates.Add(new StateFindTarget());
                }
                tmpStates.Add(new StateReleaseSpirit());
                tmpStates.Add(new StateGhostWalk());
                tmpStates.Add(new StateWalkToRepair());
                tmpStates.Add(new StateWalkBackToGrind());
                tmpStates.Add(new StateAfterFightToPath());
                tmpStates.Add(new StateWaitAfterFight());
                tmpStates.Add(new StateDoRandomShit());

                if (Options.BreakFor != 0 && Options.ForceBreakAfter != 0)
                {
                    Info.BreakHelper.SetBreakAt(60000);
                    tmpStates.Add(new StateStartBreak());
                }
                tmpStates.Add(new StateTanlet());
                tmpStates.Add(new StateMounted());

                if (Profile.RepairNPC != null)
                    tmpStates.Add(new StateRepair());

                if (Profile.MailNPC != null)
                    tmpStates.Add(new StateMail());

                if (!string.IsNullOrEmpty(Options.Party.BattleGround)) {
                    tmpStates.Add(new StateBattleGroup());
                }

                tmpStates.Sort();

                Engine = new _Engine(tmpStates);

            }
            return true;
        }

        /// <summary>
        ///     Start running the fsm
        /// </summary>
        [Obfuscation(Feature = "virtualization", Exclude = false)]
        internal bool Run()
        {
            if (!ObjectManager.EnumObjects()) return false;
            ObjectManager.Player.InitSkills();
            Main.MainForm.UpdateControl("State: Party Loading", Main.MainForm.lGrindState);
            if (Options.GroupMode )
            {
                PartyAssist.Init();
            }
            Main.MainForm.UpdateControl("State: Party Loaded", Main.MainForm.lGrindState);
            // start running the grindbot in endscene
            if (DirectX.RunInEndScene(RunGrinder))
            {
                // Enable the ctm patch to not stutter while walking
                Memory.GetHack("Ctm").Apply();
                ObjectManager.Player.TurnOnSelfCast();
                if (ObjectManager.Player.InGhostForm) Access.Info.SpiritWalk.GeneratePath = true;
                // we are running now
                Shared.ResetJumper();
                Wait.RemoveAll();
                return true;
            }
            return false;
        }

        internal void Stop()
        {
            DirectX.ForceRunInEndScene(StopGrinder);
        }

        internal void SetWaypointModifier(float parModifier)
        {
            Options.WaypointModifier = (decimal) parModifier;
        }
    }
}