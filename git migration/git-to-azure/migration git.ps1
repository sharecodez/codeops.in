
$repos = Get-Content G:\git\repo\repodetails.txt //inside text data "sample"
ForEach ($repo in $repos) {
    Write-Output "Migrating  $repo..................................."
    $sourceRepoBase = "your git repo";
    $destRepoBase = "your azure repo";
    git clone --bare "$($sourceRepoBase)$($repo)"
    
    Set-Location -Path ./"$($repo).git"
    $dest = $repo;
    if(![string]::IsNullOrEmpty($repo.dest)){
        $dest = $repo.dest;
    }
    git remote add dest "$($destRepoBase)$($dest)"
    git push --all dest
   # git push --tags dest

    cd..


    #Remove-Item -Force -Recurse -Path "D:\apple.git\"
    Remove-Item -Force -Recurse -Path G:\sample.git 
    
    
    
  Write-Output "Done  $($repo)........................................"

}