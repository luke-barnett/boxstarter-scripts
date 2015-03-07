#Boxstarter options
$Boxstarter.RebookOk=$true #allow reboots
$Boxstarter.NoPassword=$false #we have a password
$Boxstarter.AutoLogin=$true #save my password and use it to login after reboots

[Environment]::SetEnvironmentVariable('BoxStarterScriptsRoot', 'https://gist.githubusercontent.com/luke-barnett/ea9057cfcad3a36be7a4/raw/', 'User')

#living on the edge
Update-ExecutionPolicy Unrestricted

#Windows customisations
Set-StartScreenOptions -EnableBootToDesktop -EnableDesktopBackgroundOnStart -EnableShowStartOnActiveScreen -EnableShowAppsViewOnStartScreen -EnableSearchEverywhereInAppsView -EnableListDesktopAppsFirst
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtension
Disable-InternetExplorerESC #servers be dammed

#reboot if needed
if (Test-PendingReboot) { Invoke-Reboot }

#install windows updates reboot if we need to
Install-WindowsUpdate -AcceptEula
if (Test-PendingReboot) { Invoke-Reboot }

#.NET  3.5 reboot if we need to
cinst DotNet3.5
if (Test-PendingReboot) { Invoke-Reboot }

#HyperV reboot if we need to
cinst Microsoft-Hyper-V-All -source windowsFeatures
if (Test-PendingReboot) { Invoke-Reboot }

iex ((new-object net.webclient).DownloadString($env:BoxStarterScriptsRoot + 'essentials.ps1'))
iex ((new-object net.webclient).DownloadString($env:BoxStarterScriptsRoot + 'utilities.ps1'))
iex ((new-object net.webclient).DownloadString($env:BoxStarterScriptsRoot + 'personal-utilities.ps1'))
iex ((new-object net.webclient).DownloadString($env:BoxStarterScriptsRoot + 'visualstudio.ps1'))
iex ((new-object net.webclient).DownloadString($env:BoxStarterScriptsRoot + 'dev-tools.ps1'))
iex ((new-object net.webclient).DownloadString($env:BoxStarterScriptsRoot + 'git-tools.ps1'))
