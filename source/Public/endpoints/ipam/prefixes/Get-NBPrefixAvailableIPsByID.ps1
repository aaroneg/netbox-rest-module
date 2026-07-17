function Get-NBPrefixAvailableIPsByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id

	)
	Get-ApiItemByPath -apiConnection $Connection -Path $PrefixesAPIPath/$id/available-ips/

}