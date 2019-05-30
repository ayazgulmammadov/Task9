$firstResourceGroup = Get-AzureRmResourceGroup -Name 'task09-01-rg'
$secondResourceGroup = Get-AzureRmResourceGroup -Name 'task09-02-rg'

$gw1 = Get-AzureRmVirtualNetworkGateway `
    -ResourceGroupName $firstResourceGroup.ResourceGroupName

$gw2 = Get-AzureRmVirtualNetworkGateway `
    -ResourceGroupName $secondResourceGroup.ResourceGroupName

New-AzureRmVirtualNetworkGatewayConnection `
    -Name 'VNet1-VNet2' `
    -ResourceGroupName $firstResourceGroup.ResourceGroupName `
    -Location $firstResourceGroup.Location `
    -VirtualNetworkGateway1 $gw1 `
    -VirtualNetworkGateway2 $gw2 `
    -ConnectionType Vnet2Vnet `
    -SharedKey 'A123456a!'

New-AzureRmVirtualNetworkGatewayConnection `
    -Name 'VNet2-VNet1' `
    -ResourceGroupName $secondResourceGroup.ResourceGroupName `
    -Location $secondResourceGroup.Location `
    -VirtualNetworkGateway1 $gw2 `
    -VirtualNetworkGateway2 $gw1 `
    -ConnectionType Vnet2Vnet `
    -SharedKey 'A123456a!'