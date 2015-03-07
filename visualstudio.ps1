write-output 'Visual Studio 2013 Premium'
#cinst visualstudio2013premium

if($env:BoxStarterScriptsRoot -eq $null)
{
  [Environment]::SetEnvironmentVariable('BoxStarterScriptsRoot', 'https://gist.githubusercontent.com/luke-barnett/ea9057cfcad3a36be7a4/raw/', 'User')
}

iex ((new-object net.webclient).DownloadString($env:BoxStarterScriptsRoot + 'visualstudio-extensions.ps1'))
