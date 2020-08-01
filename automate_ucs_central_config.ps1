# UCS Central Configuration Script, written and generated via ConvertTo-UcsCentralCmdlet by Ugo Emekauwa (uemekauw@cisco.com) 

# Import Modules
Import-Module Cisco.UCS.Core
Import-Module Cisco.UCSCentral

# Login to UCS Central
$user = "admin"
$password = "C1sco12345" | ConvertTo-SecureString -AsPlainText -Force
$ucsmcred = New-Object System.Management.Automation.PSCredential($user,$password)
Connect-UcsCentral 198.18.133.90 -Credential $ucsmcred

# Create BIOS Policy
$org_production = Get-UcsCentralOrg -Name PRODUCTION
Add-UcsCentralBiosPolicy -Name G-PROD-BIOS -Org $org_production -RebootOnUpdate false

# Create VSANs for Domain Groups
Get-UcsCentralOrgDomainGroup -Name "root" | Get-UcsCentralOrgDomainGroup -Name "DG-Americas" -LimitScope | Get-UcsCentralOrgDomainGroup -Name "DG-CHI" -LimitScope | Get-UcsCentralFabricEp -LimitScope | Get-UcsCentralSanCloud | Get-UcsCentralFiSanCloud -Id "A" | Add-UcsCentralVsan -FcoeVlan 3010 -Id 10 -Name "PROD-A"
Get-UcsCentralOrgDomainGroup -Name "root" | Get-UcsCentralOrgDomainGroup -Name "DG-Americas" -LimitScope | Get-UcsCentralOrgDomainGroup -Name "DG-CHI" -LimitScope | Get-UcsCentralFabricEp -LimitScope | Get-UcsCentralSanCloud | Get-UcsCentralFiSanCloud -Id "B" | Add-UcsCentralVsan -FcoeVlan 3011 -Id 11 -Name "PROD-B"

Get-UcsCentralOrgDomainGroup -Name "root" | Get-UcsCentralOrgDomainGroup -Name "DG-Americas" -LimitScope | Get-UcsCentralOrgDomainGroup -Name "DG-LV" -LimitScope | Get-UcsCentralFabricEp -LimitScope | Get-UcsCentralSanCloud | Get-UcsCentralFiSanCloud -Id "A" | Add-UcsCentralVsan -FcoeVlan 3012 -Id 12 -Name "PROD-A"
Get-UcsCentralOrgDomainGroup -Name "root" | Get-UcsCentralOrgDomainGroup -Name "DG-Americas" -LimitScope | Get-UcsCentralOrgDomainGroup -Name "DG-LV" -LimitScope | Get-UcsCentralFabricEp -LimitScope | Get-UcsCentralSanCloud | Get-UcsCentralFiSanCloud -Id "B" | Add-UcsCentralVsan -FcoeVlan 3013 -Id 13 -Name "PROD-B"

Get-UcsCentralOrgDomainGroup -Name "root" | Get-UcsCentralOrgDomainGroup -Name "DG-Americas" -LimitScope | Get-UcsCentralOrgDomainGroup -Name "DG-SJC" -LimitScope | Get-UcsCentralFabricEp -LimitScope | Get-UcsCentralSanCloud | Get-UcsCentralFiSanCloud -Id "A" | Add-UcsCentralVsan -FcoeVlan 3014 -Id 14 -Name "PROD-A"
Get-UcsCentralOrgDomainGroup -Name "root" | Get-UcsCentralOrgDomainGroup -Name "DG-Americas" -LimitScope | Get-UcsCentralOrgDomainGroup -Name "DG-SJC" -LimitScope | Get-UcsCentralFabricEp -LimitScope | Get-UcsCentralSanCloud | Get-UcsCentralFiSanCloud -Id "B" | Add-UcsCentralVsan -FcoeVlan 3015 -Id 15 -Name "PROD-B"

# Create vNIC Templates
Start-UcsCentralTransaction
$mo = Get-UcsCentralOrg -Level root | Get-UcsCentralOrg -Name "PRODUCTION" -LimitScope | Add-UcsCentralVnicTemplate -ModifyPresent  -IdentPoolName "G-MAC-PROD" -Name "Mgmt-A" -NwCtrlPolicyName "G-PROD-CDP" -TemplType "updating-template"
$mo_1 = $mo | Add-UcsCentralVnicInterface -ModifyPresent -Name "G-PROD-MGMT"
Complete-UcsCentralTransaction

Start-UcsCentralTransaction
$mo = Get-UcsCentralOrg -Level root | Get-UcsCentralOrg -Name "PRODUCTION" -LimitScope | Add-UcsCentralVnicTemplate -ModifyPresent  -IdentPoolName "G-MAC-PROD" -Name "Mgmt-B" -NwCtrlPolicyName "G-PROD-CDP" -TemplType "updating-template"
$mo_1 = $mo | Add-UcsCentralVnicInterface -ModifyPresent -Name "G-PROD-MGMT"
Complete-UcsCentralTransaction

Start-UcsCentralTransaction
$mo = Get-UcsCentralOrg -Level root | Get-UcsCentralOrg -Name "PRODUCTION" -LimitScope | Add-UcsCentralVnicTemplate -ModifyPresent  -IdentPoolName "G-MAC-PROD" -Name "Data-A" -NwCtrlPolicyName "G-PROD-CDP" -TemplType "updating-template"
$mo_1 = $mo | Add-UcsCentralVnicInterface -ModifyPresent -Name "G-PROD-DATA"
Complete-UcsCentralTransaction

Start-UcsCentralTransaction
$mo = Get-UcsCentralOrg -Level root | Get-UcsCentralOrg -Name "PRODUCTION" -LimitScope | Add-UcsCentralVnicTemplate -ModifyPresent  -IdentPoolName "G-MAC-PROD" -Name "Data-B" -NwCtrlPolicyName "G-PROD-CDP" -TemplType "updating-template"
$mo_1 = $mo | Add-UcsCentralVnicInterface -ModifyPresent -Name "G-PROD-DATA"
Complete-UcsCentralTransaction

# Create LAN Connectivity Policy
Start-UcsCentralTransaction
$mo = Get-UcsCentralOrg -Level root | Get-UcsCentralOrg -Name "PRODUCTION" -LimitScope | Add-UcsCentralVnicLanConnPolicy -Name "PROD-LAN"
$mo_1 = $mo | Add-UcsCentralVnic -ModifyPresent -AdminCdnName "" -CdnSource "vnic-name" -IdentPoolName "G-MAC-PROD" -Mtu 1500 -Name "vnic0" -NwCtrlPolicyName "G-PROD-CDP" -NwTemplName "Mgmt-A" -PinToGroupName "" -QosPolicyName "" -SwitchId "A"
$mo_1_1 = $mo_1 | Add-UcsCentralVnicInterface -ModifyPresent -Name "G-PROD-MGMT"
$mo_2 = $mo | Add-UcsCentralVnic -ModifyPresent -AdminCdnName "" -CdnSource "vnic-name" -IdentPoolName "G-MAC-PROD" -Mtu 1500 -Name "vnic1" -NwCtrlPolicyName "G-PROD-CDP" -NwTemplName "Mgmt-B" -PinToGroupName "" -QosPolicyName "" -SwitchId "A"
$mo_2_1 = $mo_2 | Add-UcsCentralVnicInterface -ModifyPresent -Name "G-PROD-MGMT"
$mo_3 = $mo | Add-UcsCentralVnic -ModifyPresent -AdminCdnName "" -CdnSource "vnic-name" -IdentPoolName "G-MAC-PROD" -Mtu 1500 -Name "vnic2" -NwCtrlPolicyName "G-PROD-CDP" -NwTemplName "Data-A" -PinToGroupName "" -QosPolicyName "" -SwitchId "A"
$mo_3_1 = $mo_3 | Add-UcsCentralVnicInterface -ModifyPresent -Name "G-PROD-DATA"
$mo_4 = $mo | Add-UcsCentralVnic -ModifyPresent -AdminCdnName "" -CdnSource "vnic-name" -IdentPoolName "G-MAC-PROD" -Mtu 1500 -Name "vnic3" -NwCtrlPolicyName "G-PROD-CDP" -NwTemplName "Data-B" -PinToGroupName "" -QosPolicyName "" -SwitchId "A"
$mo_4_1 = $mo_4 | Add-UcsCentralVnicInterface -ModifyPresent -Name "G-PROD-DATA"
Complete-UcsCentralTransaction

# Create vHBA Templates
Start-UcsCentralTransaction
$mo = Get-UcsCentralOrg -Level root | Get-UcsCentralOrg -Name "PRODUCTION" -LimitScope | Add-UcsCentralVhbaTemplate -ModifyPresent  -IdentPoolName "G-WWPN-PROD-A" -Name "PROD-A" -TemplType "updating-template"
$mo_1 = $mo | Add-UcsCentralVhbaInterface -ModifyPresent -Name "PROD-A"
Complete-UcsCentralTransaction

Start-UcsCentralTransaction
$mo = Get-UcsCentralOrg -Level root | Get-UcsCentralOrg -Name "PRODUCTION" -LimitScope | Add-UcsCentralVhbaTemplate -ModifyPresent  -IdentPoolName "G-WWPN-PROD-B" -Name "PROD-B" -SwitchId "B" -TemplType "updating-template"
$mo_1 = $mo | Add-UcsCentralVhbaInterface -ModifyPresent -Name "PROD-B"
Complete-UcsCentralTransaction

# Create SAN Connectivity Policy
Start-UcsCentralTransaction
$mo = Get-UcsCentralOrg -Level root | Get-UcsCentralOrg -Name "PRODUCTION" -LimitScope | Add-UcsCentralVnicSanConnPolicy -Name "PROD-SAN"
$mo_1 = $mo | Add-UcsCentralVnicFcNode -ModifyPresent -IdentPoolName "G-WWNN-PROD"
$mo_2 = $mo | Add-UcsCentralVhba -ModifyPresent -IdentPoolName "G-WWPN-PROD-A" -MaxDataFieldSize 2048 -Name "vhba0" -NwTemplName "PROD-A" -PinToGroupName "" -QosPolicyName "" -SwitchId "A"
$mo_2_1 = $mo_2 | Add-UcsCentralVhbaInterface -ModifyPresent -Name "PROD-A"
$mo_3 = $mo | Add-UcsCentralVhba -ModifyPresent -IdentPoolName "G-WWPN-PROD-B" -MaxDataFieldSize 2048 -Name "vhba1" -NwTemplName "PROD-B" -PinToGroupName "" -QosPolicyName "" -SwitchId "B"
$mo_3_1 = $mo_3 | Add-UcsCentralVhbaInterface -ModifyPresent -Name "PROD-B"
Complete-UcsCentralTransaction

Get-UcsCentralOrg -Level root | Get-UcsCentralOrg -Name "PRODUCTION" -LimitScope | Add-UcsCentralVnicSanConnPolicy -ModifyPresent  -Name "PROD-SAN"

# Create Global Service Profile Template
Start-UcsCentralTransaction
$mo = Get-UcsCentralOrg -Level root | Get-UcsCentralOrg -Name "PRODUCTION" -LimitScope | Add-UcsCentralServiceProfile -BiosProfileName "G-PROD-BIOS" -BootPolicyName "G-Local-Boot" -IdentPoolName "G-UUID-PROD" -LocalDiskPolicyName "G-PROD-RAID-1" -MaintPolicyName "G-USER-ACK" -Name "GSP-Template-DEMO" -Type "updating-template"
$mo_1 = $mo | Set-UcsCentralServerPower -State "down"
$mo_2 = $mo | Add-UcsCentralVnicConnDef -ModifyPresent -LanConnPolicyName "PROD-LAN" -SanConnPolicyName "PROD-SAN"
Complete-UcsCentralTransaction -Force

# Create Service Profile from Template
Get-UcsCentralOrg -Level root | Get-UcsCentralOrg -Name "PRODUCTION" -LimitScope | Get-UcsCentralServiceProfile -Name GSP-Template-DEMO | Add-UcsCentralServiceProfileFromTemplate -NamePrefix GSP-DEMO- -Count 1 -DestinationOrg org-root/org-PRODUCTION

# Logout of UCS Central
Disconnect-UcsCentral

Exit
