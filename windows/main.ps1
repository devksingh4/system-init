# elevate if needed
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
  }
}
Write-Host "Setting PowerShell execution policy to Unrestricted..."
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force
function Install-WinGet {

		$releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"

		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		$releases = Invoke-RestMethod -uri "$($releases_url)"
		$latestRelease = $releases.assets | Where-Object { $_.browser_download_url.EndsWith("msixbundle") } | Select -First 1
	
		Add-AppxPackage -Path $latestRelease.browser_download_url
}
# check if winget is available
winget --version

if($?)
{
  Write-Host 'WinGet is available!';
}
else
{
  Write-Host 'WinGet is not installed, installing now!';
  Install-WinGet
}
winget --version
if(-not $?)
{
  throw 'WinGet is still not installed, please install and try again!';
}

$rootPath = "https://raw.githubusercontent.com/devksingh4/system-init/master/windows/"
$scriptList = @(
    'winget.ps1'
    'wsl.ps1'
);
foreach ($script in $scriptList) {
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($rootPath + $script))
}

Write-Host 'Done! Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');