$BastionName = 'bb-nonprd-bastion-host'
$BastionRG = 'bb-nonprd-rg'
$VMResourceID= '/subscriptions/*****/resourceGroups/bb-nonprd-rg/providers/Microsoft.Compute/virtualMachines/****'
az network bastion rdp --name $BastionName --resource-group $BastionRG --target-resource-id $VMResourceID
