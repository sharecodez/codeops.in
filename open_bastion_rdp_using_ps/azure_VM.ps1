$BastionName = 'bb-nonprd-bastion-host'
$BastionRG = 'bb-nonprd-rg'
$VMResourceID= '/subscriptions/aa668178-f7ef-4db1-98b4-e516297ed54e/resourceGroups/bb-nonprd-rg/providers/Microsoft.Compute/virtualMachines/bb-nonprd-vm-01'
az network bastion rdp --name $BastionName --resource-group $BastionRG --target-resource-id $VMResourceID