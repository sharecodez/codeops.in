$Auth64Encoded = "AccessToken"
$teamname="YOURTEAM NAME"
$Url = "https://api.bitbucket.org/2.0/repositories/$teamname"
$webData = ConvertFrom-JSON (Invoke-WebRequest  -Uri $Url -Method Get -Headers @{'Authorization'= "Bearer $Auth64Encoded"} )
$res=$webData.values
$next=$webData.page
$size=$webData.size
$pagecount=$webData.pagelen
$pagecount=$webData.size/$webData.pagelen
$IsDecimal = if (($pagecount - ($pagecount -as [int])) -ne 0) {[Math]::Ceiling($pagecount)} Else {$pagecount}

 

for($x=1; $x -lt $IsDecimal; $x=$x+1)   
{   
    $Url = "https://api.bitbucket.org/2.0/repositories/$teamname?page=$x"
    $pageData = ConvertFrom-JSON (Invoke-WebRequest  -Uri $Url -Method Get -Headers @{'Authorization'= "Bearer $Auth64Encoded"} )
    $response = $pageData.values.name
    foreach ($name in $response) {
        $download = "https://x-token-auth:$Auth64Encoded@bitbucket.org/$teamname/$($name).git"
        git clone $download 
    }
} 