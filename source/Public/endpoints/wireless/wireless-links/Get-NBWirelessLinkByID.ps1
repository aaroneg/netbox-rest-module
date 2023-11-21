function Get-NBWirelessLinkByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBWirelessLinkAPIPath -id $id
}