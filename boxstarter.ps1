
# Adapted from http://www.west-wind.com/Weblog/posts/197245.aspx
function Get-FileEncoding($Path) {
    $bytes = [byte[]](Get-Content $Path -Encoding byte -ReadCount 4 -TotalCount 4)

    if(!$bytes) { return 'utf8' }

    switch -regex ('{0:x2}{1:x2}{2:x2}{3:x2}' -f $bytes[0],$bytes[1],$bytes[2],$bytes[3]) {
        '^efbbbf'   { return 'utf8' }
        '^2b2f76'   { return 'utf7' }
        '^fffe'     { return 'unicode' }
        '^feff'     { return 'bigendianunicode' }
        '^0000feff' { return 'utf32' }
        default     { return 'ascii' }
    }
}

#Boxstarter options
$Boxstarter.RebookOk=$true #allow reboots
$Boxstarter.NoPassword=$false #we have a password
$Boxstarter.AutoLogin=$true #save my password and use it to login after reboots

#living on the edge
Update-ExecutionPolicy Unrestricted

[Environment]::SetEnvironmentVariable('GIT_SSH', 'plink.exe', 'Machine')

if($env:BoxStarterScriptsRoot -eq $null)
{
  [Environment]::SetEnvironmentVariable('BoxStarterScriptsRoot', 'https://raw.githubusercontent.com/luke-barnett/boxstarter-scripts/master/', 'User')
}

if($env:PowerShellScriptsRepo -eq $null)
{
  [Environment]::SetEnvironmentVariable('PowerShellScriptsRepo', 'https://github.com/luke-barnett/powershell-scripts', 'User')
}

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
cinst -y DotNet3.5
if (Test-PendingReboot) { Invoke-Reboot }

#HyperV reboot if we need to
cinst -y Microsoft-Hyper-V-All -source windowsFeatures
if (Test-PendingReboot) { Invoke-Reboot }

#Browsers
cinst -y googlechrome
cinst -y firefox
cinst -y ie11

#Text editors
cinst -y atom
cinst -y sublimetext3

#Development tools
cinst -y fiddler
cinst -y ilspy
cinst -y linqpad
cinst -y nuget.commandline
cinst -y nugetpackageexplorer
cinst -y phantomjs
cinst -y windowsazurepowershell
cinst -y winmerge

#git
cinst -y git
cinst -y git-credential-manager-for-windows
cinst -y gitversion.portable
cinst -y sourcetree
cinst -y gittfs
cinst -y poshgit
cinst -y tortoisegit

#Runtimes
cinst -y nodejs

#Utilities
cinst -y boxstarter
cinst -y checksum
cinst -y cyberduck
cinst -y filezilla
cinst -y putty
cinst -y royalts
cinst -y spotify
cinst -y sumatrapdf
cinst -y vlc
cinst -y windirstat
cinst -y winrar

$codeDirectory = 'C:\code'
$scriptsDirectory = $codeDirectory + '\powershell-scripts'

if(!(test-path $codeDirectory))
{
  New-Item -ItemType directory -Path $codeDirectory
}

if(test-path $scriptsDirectory\.git)
{
  write-output 'Scripts repo exists resetting to origin'
  $cwd = $pwd
  cd $scriptsDirectory
  git clean -xdf
  git fetch origin
  git reset --hard origin/master
  cd $cwd
}
else
{
  if(test-path $scriptsDirectory)
  {
    write-output 'Removing non git profile'
    remove-item -recurse -force $scriptsDirectory
  }

  write-output 'Cloning powershell-scripts'
  git clone $env:PowerShellScriptsRepo $scriptsDirectory
}

if(!(test-path $profile)) {
    new-item $profile -Force -Type File -ErrorAction Stop > $null
}

$profileLine = @"
#powershell-scipts
`$env:PowerShellModules = 'C:\code\powershell-scripts\'
Get-ChildItem (`$env:PowerShellModules + "*.psm1") | ForEach-Object {Import-Module `$_.FullName -DisableNameChecking }
"@

if(select-string -Path $profile -Pattern 'powershell-scripts' -Quiet -SimpleMatch) {
    return
}

@"

$profileLine
"@ | out-file $profile -Append -Encoding (Get-FileEncoding $profile)
