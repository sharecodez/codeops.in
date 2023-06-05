$Auth64Encoded = "ATCTT3xFfGN0wSFF7JY5fZ1eDbtWdDhEogIxE-8XH0GtoWTV96xmTlU-PAtsTQL4-AYwvkaXRtb8S2KRfMkEgvIdpEDtWaya8tzNY3MnmYedD8MNySL2rRm0IgRjYJaepK9Ih3CLFPE9FlkjRXz6gj7018q-LM7RZbdmgJ9SYoVdM-Iph3Un-88=CC6E6D99"
$teamname="goeasyteam"
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