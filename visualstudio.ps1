write-output 'Visual Studio 2013 Premium'
#cinst visualstudio2013premium

iex ((new-object net.webclient).DownloadString('https://gist.githubusercontent.com/luke-barnett/ea9057cfcad3a36be7a4/raw/visualstudio-extensions.ps1'))
