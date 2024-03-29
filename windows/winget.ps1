# elevate if needed
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
  }
}
function Install-IfUnavailable {
  param(
  [Parameter (Mandatory = $true)] [String] $package
  )
  $check_output = [string](winget list --exact -q $package)
  $installed = -not ($check_output -like "*No installed package found*")
  if ($installed) {
    Write-Host "$($package) is already installed, skipping!"
  } else {
    Write-Host "Installing $($package)..."
    winget install --accept-package-agreements --exact --silent --id $package
  }
}
(
  "Google.Chrome",
  "CPUID.CPU-Z",
  "Mozilla.Firefox",
  "Discord.Discord",
  "OpenJS.NodeJS.LTS",
  "Docker.DockerDesktop",
  "Microsoft.WindowsTerminal",
  "Cryptomator.Cryptomator",
  "Git.Git",
  "9NCBCSZSJRSB", # spotify
  "OBSProject.OBSStudio",
  "Microsoft.PowerToys",
  "9WZDNCRDK3WP", # slack
  "Valve.Steam",
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
  "Apple.iTunes",
  "WinSCP.WinSCP",
  "WireGuard.WireGuard",
  "Zoom.Zoom",
  "CPUID.HWMonitor",
  "GitHub.GitHubDesktop",
  "Yarn.Yarn",
  "tailscale.tailscale",
  "qBittorrent.qBittorrent",
  "RiotGames.Valorant.NA",
  "Balena.Etcher",
  "Windscribe.Windscribe",
  "9PC3H3V7Q9CH" # Rufus
) | ForEach-Object { Install-IfUnavailable -package $_ }
