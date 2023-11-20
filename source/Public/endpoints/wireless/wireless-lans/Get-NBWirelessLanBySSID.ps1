function Get-NBWirelessLanBySSID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$SSID
	)
	Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBWirelessLanAPIPath -field ssid -value $SSID

}