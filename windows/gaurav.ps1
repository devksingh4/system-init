# elevate if needed
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
  }
}
# Apps use dark theme
# New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0 -Type Dword -Force

# Set dark theme
# start-process -filepath "C:\Windows\Resources\Themes\dark.theme"; timeout /t 3; taskkill /im "systemsettings.exe" /f

# Clear Taskbar
$path =  'C:\Users\dsingh\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\'
if (Test-Path $path) {
  Remove-Item -Recurse -Force $path
}

REG DELETE HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband /F

taskkill /f /im explorer.exe

start explorer.exe

# Bring back old context menu
REG ADD "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# Uninstall OneDrive
TASKKILL/F /IM OneDrive.exe
C:\Windows\System32\OneDriveSetup.exe /uninstall /allusers

# Uninstall Teams
# Removal Machine-Wide Installer - This needs to be done before removing the .exe below!
Get-WmiObject -Class Win32_Product | Where-Object {$_.IdentifyingNumber -eq "{39AF0813-FA7B-4860-ADBE-93B9B214B914}"} | Remove-WmiObject

#Teams - Variables
$TeamsUsers = Get-ChildItem -Path "$($ENV:SystemDrive)\Users"

 $TeamsUsers | ForEach-Object {
    Try { 
        if (Test-Path "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Microsoft\Teams") {
            Start-Process -FilePath "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Microsoft\Teams\Update.exe" -ArgumentList "-uninstall -s"
        }
    } Catch { 
        Out-Null
    }
}

# Teams - Remove AppData folder for $($_.Name).
$TeamsUsers | ForEach-Object {
    Try {
        if (Test-Path "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Microsoft\Teams") {
            Remove-Item –Path "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Microsoft\Teams" -Recurse -Force -ErrorAction Ignore
        }
    } Catch {
        Out-Null
    }
}

# Don't start teams on boot:

Clear-Host
 
$ErrorActionPreference= 'silentlycontinue'
 
# Delete Reg Key
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$regKey = "com.squirrel.Teams.Teams"
 
Remove-ItemProperty $regPath -Name $regKey
 
# Teams Config Path
$teamsConfigFile = "$env:APPDATA\Microsoft\Teams\desktop-config.json"
$teamsConfig = Get-Content $teamsConfigFile -Raw
 
if ( $teamsConfig -match "openAtLogin`":false") {
    break
}
elseif ( $teamsConfig -match "openAtLogin`":true" ) {
    # Update Teams Config
    $teamsConfig = $teamsConfig -replace "`"openAtLogin`":true","`"openAtLogin`":false"
}
else {
    $teamsAutoStart = ",`"appPreferenceSettings`":{`"openAtLogin`":false}}"
    $teamsConfig = $teamsConfig -replace "}$",$teamsAutoStart
}
 
$teamsConfig | Set-Content $teamsConfigFile
