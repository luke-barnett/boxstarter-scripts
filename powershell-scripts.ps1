if($env:PowerShellScriptsRepo -eq $null)
{
  [Environment]::SetEnvironmentVariable('PowerShellScriptsRepo', 'https://github.com/luke-barnett/powershell-scripts', 'User')
}

write-output 'Getting powershell scripts'

$codeDirectory = 'C:\code'
$scriptsDirectory = $codeDirectory + '\powershell-scripts'

if(-not test-path $codeDirectory)
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
