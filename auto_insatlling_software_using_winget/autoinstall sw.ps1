Write-Output "Installing Apps"
$apps = @(
    @{name = "Google.Chrome" },
    @{name = "Microsoft.VisualStudioCode"},
    @{name = "Git.Git" },
    @{name = "Notepad++.Notepad++"},
    @{name = "3T.Robo3T"},
    @{name = "CoreyButler.NVMforWindows"},
    @{name = "Atlassian.Sourcetree"}, 
    @{name = "Memurai.MemuraiDeveloper"} 


    );
Foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing: " $app.name
        winget install -e -h --accept-source-agreements --accept-package-agreements --id $app.name 
    }
    else {
        Write-host "Skipping: " $app.name " (already installed)"
    }
}