if($env:AtomProfileRepo -eq $null)
{
  write-output 'Setting atom profile to bitbuckit.org/Technicolour/atom-profile'
  $env:AtomProfileRepo = 'https://Technicolour@bitbucket.org/Technicolour/atom-profile.git'
}

write-output 'Installing essentials'
cinst git
cinst git-credential-winstore
cinst atom
iex ((new-object net.webclient).DownloadString('https://gist.githubusercontent.com/luke-barnett/ea9057cfcad3a36be7a4/raw/atom-profile.ps1'))
cinst googlechrome
cinst putty
cinst vlc
cinst spotify
