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
            File.Copy($"{exePath}\\wslbridge-backend", $"{appData}\\wslbridge-backend", true);

            string wslbridge = $"\"{exePath}\\wslbridge.exe\" --backend \"{appData}\\wslbridge-backend\" -C ~";
            string config = $"{appData}\\mintty.config";
            Process.Start(
                $"{exePath}\\mintty.exe",
                $" --config {config} --icon \"{exePath}\\wsltty.ico\" --exec {wslbridge}"
                );
        }
    }
}
