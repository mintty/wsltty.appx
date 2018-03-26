using System.IO;
using System.Diagnostics;
using System.Reflection;
using Windows.Storage;

namespace Launcher
{
    class Launcher
    {
        static void Main()
        {
            string location = Assembly.GetExecutingAssembly().Location;
            int index = location.LastIndexOf("\\");
            string exePath = location.Substring(0, index);

            string appData = ApplicationData.Current.LocalCacheFolder.Path; //only for UWP//
            string[] files = new string[] { "cygwin1.dll", "wslbridge.exe", "wslbridge-backend" };
            foreach (string file in files)
            {
                File.Copy($"{exePath}\\{file}", $"{appData}\\{file}", true);
            }

            string wslbridge = $"{appData}\\wslbridge.exe";
            string config = $"{appData}\\mintty.config";
            Process.Start(
                $"{exePath}\\mintty.exe",
                $" --config {config} --icon \"{exePath}\\wsltty.ico\" --exec {wslbridge}  -C ~"
                );
        }
    }
}
