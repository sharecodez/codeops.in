$resourceGroup = "YOUR RESOURCEGROUP"

$AccountName = "STORAGE ACC NAME"

$Key = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroup -Name $AccountName)[0].Value

Write-Host "storage account key 1 = " $Key

$item = Get-Item 'D:\bitbucketrepobackup'

foreach ($items in $item) {
az storage blob upload-batch -d backup --account-name $AccountName --account-key $Key -s  'D:\bitbucketrepobackup'
}