# elevate if needed
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
  }
}
(
  "Google.Chrome",
  "Mozilla.Firefox",
  "Discord.Discord",
  "Discord.Discord.Canary",
  "OpenJS.Nodejs.LTS",
  "Microsoft.WindowsTerminal",
  "Cryptomator.Cryptomator",
  "Git.Git",
  "Microsoft.PowerToys",
  "SlackTechnologies.Slack",
  "Valve.Steam",
  "Spotify.Spotify",
  "Microsoft.VisualStudioCode",
  "WiresharkFoundation.Wireshark",
  "7zip.7zip",
  "TimKosse.FileZilla.Client",
  "Google.Drive",
  "PuTTY.PuTTY",
  "Microsoft.Office",
  "Anaconda.Miniconda3",
  "Notepad++.Notepad++",
  "VideoLAN.VLC",
  "WinSCP.WinSCP",
  "WireGuard.WireGuard",
  "Zoom.Zoom",
  "CPUID.HWMonitor",
  "GitHub.GitHubDesktop"
) | ForEach-Object { winget install --accept-source-agreements  -e --id $_ }