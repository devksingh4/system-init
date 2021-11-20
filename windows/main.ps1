# elevate if needed
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
  }
}

$rootPath = "https://raw.githubusercontent.com/devksingh4/system-init/master/windows/"
$scriptList = @(
    'winget.ps1'
    'wsl.ps1'
);
foreach ($script in $scriptList) {
  iex ((New-Object System.Net.WebClient).DownloadString($rootPath + $script))
}

Write-Host 'Done! Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');