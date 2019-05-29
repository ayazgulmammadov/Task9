$firstResourceGroup = Get-AzureRmResourceGroup -Name 'task09-01-rg'
$secondResourceGroup = Get-AzureRmResourceGroup -Name 'task09-02-rg'

$VNet1 = Get-AzureRmVirtualNetwork -ResourceGroupName $firstResourceGroup.ResourceGroupName -Name 'firstVNet'
$VNet2 = Get-AzureRmVirtualNetwork -ResourceGroupName $secondResourceGroup.ResourceGroupName -Name 'secondVNet'

$publicIP1 = Get-AzureRmPublicIpAddress -ResourceGroupName $firstResourceGroup.ResourceGroupName
$publicIP2 = Get-AzureRmPublicIpAddress -ResourceGroupName $secondResourceGroup.ResourceGroupName


Add-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $VNet1 -AddressPrefix '10.0.1.0/24'
$VNet1 | Set-AzureRmVirtualNetwork

Add-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $VNet2 -AddressPrefix '192.168.1.0/24'
$VNet2 | Set-AzureRmVirtualNetwork

$gwsub1 = Get-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $VNet1
$gwsub2 = Get-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $VNet2

$gwipconfig1 = New-AzureRmVirtualNetworkGatewayIpConfig -Name 'gwipconfig1' -Subnet $gwsub1 -PublicIpAddress $publicIP1
$gwipconfig2 = New-AzureRmVirtualNetworkGatewayIpConfig -Name 'gwipconfig2' -Subnet $gwsub2 -PublicIpAddress $publicIP2

$gw1 = New-AzureRmVirtualNetworkGateway -Name 'VNet1GW' -ResourceGroupName $firstResourceGroup.ResourceGroupName -Location $firstResourceGroup.Location -IpConfigurations $gwipconfig1 -GatewayType Vpn -VpnType RouteBased -GatewaySku VpnGw1
$gw2 = New-AzureRmVirtualNetworkGateway -Name 'VNet2GW' -ResourceGroupName $secondResourceGroup.ResourceGroupName -Location $secondResourceGroup.Location -IpConfigurations $gwipconfig2 -GatewayType Vpn -VpnType RouteBased -GatewaySku VpnGw1

New-AzureRmVirtualNetworkGatewayConnection -Name 'VNet1-VNet2' -ResourceGroupName $firstResourceGroup.ResourceGroupName -Location $firstResourceGroup.Location `
    -VirtualNetworkGateway1 $gw1 -VirtualNetworkGateway2 $gw2 -ConnectionType Vnet2Vnet -SharedKey 'A123456a!'
New-AzureRmVirtualNetworkGatewayConnection -Name 'VNet2-VNet1' -ResourceGroupName $secondResourceGroup.ResourceGroupName -Location $secondResourceGroup.Location `
    -VirtualNetworkGateway1 $gw2 -VirtualNetworkGateway2 $gw1 -ConnectionType Vnet2Vnet -SharedKey 'A123456a!'