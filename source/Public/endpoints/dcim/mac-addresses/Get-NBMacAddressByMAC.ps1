<#
.SYNOPSIS
Get MAC address object by MAC address string, Name, etc.

.DESCRIPTION
Get MAC address object by MAC address string, Name, etc.

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER MAC
Parameter description

.EXAMPLE
Get-NBMacAddressByMAC 00:00:DE:AD:BE:EF

.EXAMPLE
Get-NBMacAddressByMAC 00-00-DE-AD-BE-EF

.EXAMPLE
Get-NBMacAddressByMAC 0000DEADBEEF

.EXAMPLE
Get-NBMacAddressByMAC 0000.DEAD.BEEF

.NOTES
It doesn't seem to matter what form of mac address you search by, Netbox appears capable of finding it.
#>
function Get-NBMacAddressByMAC {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][Alias('Name','MACAddress')][string]$MAC
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $MACAddressAPIPath -value $name

}