if($env:AtomProfileRepo -eq $null)
{
  [Environment]::SetEnvironmentVariable('AtomProfileRepo', 'https://Technicolour@bitbucket.org/Technicolour/atom-profile.git', 'User')
}

write-output 'Getting atom profile'

$atomProfileDirectory = $env:homepath + '\.atom'

$cwd = $pwd

if(test-path $atomProfileDirectory\.git)
{
  write-output 'Atom repo exists resetting to origin'
  cd $atomProfileDirectory
  git clean -xdf
  git fetch origin
  git reset --hard origin/master
  cd $cwd
}
else
{
  if(test-path $atomProfileDirectory)
  {
    write-output 'Removing non git profile'
    remove-item -recurse -force $atomProfileDirectory
  }

  write-output 'Cloning atom profile'
  git clone $env:AtomProfileRepo $atomProfileDirectory
}
