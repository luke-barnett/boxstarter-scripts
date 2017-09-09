
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
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtension -EnableShowFullPathInTitleBar
Disable-InternetExplorerESC #servers be dammed
Disable-BingSearch
Disable-UAC
Install-WindowsUpdate -AcceptEula -SuppressReboots -GetUpdatesFromMS

#reboot if needed
if (Test-PendingReboot) { Invoke-Reboot }

#.NET  3.5 reboot if we need to
cinst -y DotNet3.5
if (Test-PendingReboot) { Invoke-Reboot }

#HyperV reboot if we need to
cinst -y Microsoft-Hyper-V-All -source windowsFeatures
if (Test-PendingReboot) { Invoke-Reboot }

#Browsers
cinst -y googlechrome firefox

#Text editors
cinst -y sublimetext3 visualstudiocode

#Development tools
cinst -y fiddler4 ilspy linqpad nuget.commandline nugetpackageexplorer windowsazurepowershell sql-server-management-studio

#git
cinst -y git git-credential-manager-for-windows poshgit
cinst -y gitversion.portable
cinst -y sourcetree tortoisegit

#visual studio 2017
cinst -y visualstudio2017professional
cinst -y visualstudio2017-workload-azure visualstudio2017-workload-data visualstudio2017-workload-manageddesktop visualstudio2017-workload-netcoretools
cinst -y visualstudio2017-workload-netcrossplat visualstudio2017-workload-netweb visualstudio2017-workload-node visualstudio2017-workload-office visualstudio2017-workload-universal
cinst -y visualstudio2017-workload-webcrossplat visualstudio2017-workload-visualstudioextension

#Runtimes
cinst -y nodejs yarn

#Utilities
cinst -y boxstarter checksum bind-toolsonly azcopy filezilla putty
cinst -y royalts spotify vlc windirstat 7zip

Write-Output 'Install common npm global packages'
npm install -g eslint grunt-cli gulp-cli http-server iisexpress-proxy jshint rimraf npm-windows-upgrade

Write-Output 'Pinning chocolatey packages'
choco pin add -n=googlechrome
choco pin add -n=visualstudiocode

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
