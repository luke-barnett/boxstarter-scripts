write-output 'installing more browsers for testing'
cinst -y googlechrome
cinst -y firefox
cinst -y opera
cinst -y ie11
cinst -y phantomjs

write-output 'installing dev-tools'
cinst -y sublimetext3
cinst -y vagrant
cinst -y nuget.commandline
cinst -y winmerge
cinst -y windowsazurepowershell
cinst -y nugetpackageexplorer
cinst -y linqpad

write-output 'debugging tools'
cinst -y fiddler
cinst -y ilspy

write-output 'installing runtimes'
cinst -y nodejs
cinst -y ruby
cinst -y ruby2.devkit
cinst -y golang
