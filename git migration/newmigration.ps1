$repos= Get-Content D:\bitrepo\reponame\repodetails.txt
ForEach ($repo in $repos){
Write-Output "Migrating  $($repo)..................................."
git clone https://gautham30@bitbucket.org/learning-bitbucket01/$repo.git
cd $repo
git remote add github https://github.com/gautham30/$repo.git
git push --mirror github

}