if($env:AtomProfileRepo -eq $null)
{
  [Environment]::SetEnvironmentVariable('AtomProfileRepo', 'https://luke-barnett@bitbucket.org/luke-barnett/atom-profile.git', 'User')
}

write-output 'Ensuring atom is installed'
cinst atom

write-output 'Ensuring node is installed'
cinst nodejs

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

write-output 'loading node modules for packages'

get-childitem ($atomProfileDirectory + '\packages') | where {$_.Attributes -eq 'Directory'} | foreach-object {
  cd $_.FullName
  npm install
}

cd $cwd
