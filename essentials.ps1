if($env:BoxStarterScriptsRoot -eq $null)
{
  [Environment]::SetEnvironmentVariable('BoxStarterScriptsRoot', 'https://raw.githubusercontent.com/luke-barnett/boxstarter-scripts/master/', 'User')
}

write-output 'Installing essentials'
cinst -y putty
[Environment]::SetEnvironmentVariable('GIT_SSH', 'plink.exe', 'Machine')
cinst -y git
cinst -y git-credential-winstore
cinst -y atom
iex ((new-object net.webclient).DownloadString($env:BoxStarterScriptsRoot + 'atom-profile.ps1'))
iex ((new-object net.webclient).DownloadString($env:BoxStarterScriptsRoot + 'powershell-scripts.ps1'))
cinst -y googlechrome
cinst -y vlc
cinst -y spotify
