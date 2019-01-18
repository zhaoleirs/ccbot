using System.IO;
using System.Windows.Forms;
using ZzukBot.Engines.Grind;
using ZzukBot.Engines.ProfileCreation;
using ZzukBot.GUI_Forms;
using ZzukBot.Mem;
using ZzukBot.Settings;

namespace ZzukBot.Engines
{
    internal enum Engines
    {
        None = 0,
        ProfileCreation = 1,
        Grind = 2
    }

    internal static class EngineManager
    {
        private static object _Engine;
        private static string tmpProfileName;
        private static volatile bool IsWaitingForGeneration;
        private static Grinder tmpGrind;
        internal delegate void Profile();
        private static bool IsEngineRunning => _Engine != null;

        internal static Engines CurrentEngineType
        {
            get
            {
                if (IsEngineRunning)
                {
                    if (_Engine.GetType() == typeof (ProfileCreator))
                        return Engines.ProfileCreation;

                    if (_Engine.GetType() == typeof (Grinder))
                        return Engines.Grind;
                }
                return Engines.None;
            }
        }

        internal static T EngineAs<T>()
        {
            return (T) _Engine;
        }

        internal static void StartProfileCreation()
        {
            Main.MainForm.Invoke(new MethodInvoker(delegate
            {
                if (IsEngineRunning) return;
                _Engine = new ProfileCreator();
            }));
        }
        internal static void ChooseProfile(bool parLoadLast, Profile profile) {
           
            if (parLoadLast &&!string.IsNullOrEmpty(Options.LastProfile))
            {
                tmpProfileName = Options.LastProfile;
                profile();
            }
            else
            {
                using (var locateProfile = new OpenFileDialog())
                {
                    if (Directory.Exists(Paths.PathToWoW + "\\ZzukBot_Profiles"))
                        locateProfile.InitialDirectory = Paths.PathToWoW + "\\ZzukBot_Profiles";
                    else
                        locateProfile.InitialDirectory = Paths.ProfileFolder;
                    locateProfile.CheckFileExists = true;
                    locateProfile.CheckPathExists = true;
                    locateProfile.Filter = "xml Profile (*.xml)|*.xml";
                    locateProfile.FilterIndex = 1;
                    if (locateProfile.ShowDialog() == DialogResult.OK)
                    {
                        tmpProfileName = locateProfile.FileName;
                        profile();
                    }
                    else
                    {
                        return;
                    }
                }
            }
        }
        internal static void StartGrinder()
        {
            if (IsEngineRunning) return;
            tmpGrind = new Grinder();
            if (!IsWaitingForGeneration && tmpGrind.Prepare(tmpProfileName, Callback))
            {
                Main.MainForm.Invoke(new MethodInvoker(delegate
                {
                    Main.MainForm.lGrindState.Text = "State: Loading mmaps";
                    IsWaitingForGeneration = true;
                    Options.LastProfile = tmpProfileName;
                }));
            }
        }

        private static void Callback()
        {
            if (tmpGrind != null && tmpGrind.Run())
            {
                Main.MainForm.Invoke(new MethodInvoker(delegate
                {
                    Main.MainForm.lGrindLoadProfile.Text = "Profile:"+  Options.LastProfile.Substring(Options.LastProfile.LastIndexOf("\\")+1);
                    _Engine = tmpGrind;
                    IsWaitingForGeneration = false;
                }));
            }
        }

        internal static void StopCurrentEngine()
        {
            var dispose = true;
            if (IsEngineRunning) { 
                if (_Engine.GetType() == typeof (ProfileCreator))
                    dispose = EngineAs<ProfileCreator>().Dispose();

                if (_Engine.GetType() == typeof (Grinder))
                {
                    EngineAs<Grinder>().Stop();
                    IsWaitingForGeneration = false;
                    tmpGrind = null;
                }
            }
            if (dispose)
                _Engine = null;
        }
    }
}