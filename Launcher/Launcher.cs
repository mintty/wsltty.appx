using System;
using System.IO;
using System.Diagnostics;
using Windows.Storage;

namespace Launcher
{
    class Launcher
    {
        static void Main()
        {
            string location = System.Reflection.Assembly.GetExecutingAssembly().Location;
            int index = location.LastIndexOf("\\");
            string exePath = location.Substring(0, index);

            string wslbridge = $"{Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData)}\\wslbridge";
            Directory.CreateDirectory(wslbridge);
            string[] files = new string[] { "cygwin1.dll", "wslbridge.exe", "wslbridge-backend" };
            foreach (string file in files)
            {
                File.Copy($"{exePath}\\{file}", $"{wslbridge}\\{file}", true);
            }

            string mintty = $"{exePath}\\mintty.exe";
            string wslbridgePath = $"{ApplicationData.Current.LocalCacheFolder.Path}\\Roaming\\wslbridge\\wslbridge.exe";
            string configPath = $"{ApplicationData.Current.LocalCacheFolder.Path}\\Roaming\\mintty.config";
            Process.Start(
                mintty,
                $" --config {configPath} --icon \"{exePath}\\wsltty.ico\" --exec {wslbridgePath}  -C ~"
                );
        }
    }
}

/*END-35*/