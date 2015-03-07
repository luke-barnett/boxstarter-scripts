if($env:BoxStarterScriptsRoot -eq $null)
{
  [Environment]::SetEnvironmentVariable('BoxStarterScriptsRoot', 'https://raw.githubusercontent.com/luke-barnett/boxstarter-scripts/master/', 'User')
}

write-output 'Installing essentials'
cinst git
cinst git-credential-winstore
cinst atom
iex ((new-object net.webclient).DownloadString($env:BoxStarterScriptsRoot + 'atom-profile.ps1'))
iex ((new-object net.webclient).DownloadString($env:BoxStarterScriptsRoot + 'powershell-scripts.ps1'))
cinst googlechrome
cinst putty
cinst vlc
cinst spotify
