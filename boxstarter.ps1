#Boxstarter options
$Boxstarter.RebookOk=$true #allow reboots
$Boxstarter.NoPassword=$false #we have a password
$Boxstarter.AutoLogin=$true #save my password and use it to login after reboots

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

#VS Extensions
Install-ChocolateyVsixPackage WebEssentials https://visualstudiogallery.msdn.microsoft.com/56633663-6799-41d7-9df7-0f2a504ca361/file/105627/44/WebEssentials2013.vsix
Install-ChocolateyVsixPackage VSCommands https://visualstudiogallery.msdn.microsoft.com/c6d1c265-7007-405c-a68b-5606af238ece/file/106247/21/SquaredInfinity.VSCommands.VS12.vsix
Install-ChocolateyVsixPackage ProductivityPowerTools https://visualstudiogallery.msdn.microsoft.com/dbcb8670-889e-4a54-a226-a48a15e4cace/file/117115/4/ProPowerTools.vsix
Install-ChocolateyVsixPackage CodeMaid https://visualstudiogallery.msdn.microsoft.com/76293c4d-8c16-4f4a-aee6-21f83a571496/file/9356/29/CodeMaid_v0.7.5.vsix
Install-ChocolateyVsixPackage IntentGuides https://visualstudiogallery.msdn.microsoft.com/e792686d-542b-474a-8c55-630980e72c30/file/48932/20/IndentGuide%20v14.vsix
Install-ChocolateyVsixPackage PowershellTools https://visualstudiogallery.msdn.microsoft.com/c9eb3ba8-0c59-4944-9a62-6eee37294597/file/112013/15/PowerShellTools.vsix
Install-ChocolateyVsixPackage SpecFlow https://visualstudiogallery.msdn.microsoft.com/90ac3587-7466-4155-b591-2cd4cc4401bc/file/112721/3/TechTalk.SpecFlow.Vs2013Integration.vsix
Install-ChocolateyVsixPackage OpenCommandLine https://visualstudiogallery.msdn.microsoft.com/4e84e2cf-2d6b-472a-b1e2-b84932511379/file/151803/12/Open%20Command%20Line%20v1.7.121.vsix

#Chocolatey packages
cinst googlechrome
cinst vlc
cinst putty
cinst skype
cinst sumatrapdf
cinst googledrive
cinst curl
cinst checksum
cinst winrar
cinst dropbox
cinst windirstat
cinst steam
cinst openvpn
cinst vmwarevsphereclient
cinst mumble
cinst cyberduck
cinst spideroak
cinst f.lux
cisnt spotify
cinst microsip

#devtools
cinst atom
cinst vagrant
cinst nuget.commandline
cinst winmerge
cinst windowsazurepowershell
cinst nugetpackageexplorer
cinst linqpad
cinst hipchat

#git
cinst git
cinst poshgit
cinst tortoisegit
cinst sourcetree
cinst gittfs
cinst git-credential-winstore
#cinst smartgit

#debugging
cinst fiddler
cinst dotpeek
cinst ilspy

#runtimes
cinst nodejs
cisnt ruby
cinst python
cinst easy.install
cinst pip
cinst golang
