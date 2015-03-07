write-output 'Visual Studio 2013 Premium'
#cinst visualstudio2013premium

if($env:BoxStarterScriptsRoot -eq $null)
{
  [Environment]::SetEnvironmentVariable('BoxStarterScriptsRoot', 'https://raw.githubusercontent.com/luke-barnett/boxstarter-scripts/master/', 'User')
}

iex ((new-object net.webclient).DownloadString($env:BoxStarterScriptsRoot + 'visualstudio-extensions.ps1'))
