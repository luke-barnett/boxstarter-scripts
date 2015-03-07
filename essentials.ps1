if($env:AtomProfileRepo -eq $null)
{
  write-output 'Setting atom profile to bitbuckit.org/Technicolour/atom-profile'
  [Environment]::SetEnvironmentVariable('AtomProfileRepo', 'https://Technicolour@bitbucket.org/Technicolour/atom-profile.git', 'User')
}

if($env:BoxStarterScriptsRoot -eq $null)
{
  [Environment]::SetEnvironmentVariable('BoxStarterScriptsRoot', 'https://raw.githubusercontent.com/luke-barnett/boxstarter-scripts/master/', 'User')
}

write-output 'Installing essentials'
cinst git
cinst git-credential-winstore
cinst atom
iex ((new-object net.webclient).DownloadString($env:BoxStarterScriptsRoot + 'atom-profile.ps1'))
cinst googlechrome
cinst putty
cinst vlc
cinst spotify
