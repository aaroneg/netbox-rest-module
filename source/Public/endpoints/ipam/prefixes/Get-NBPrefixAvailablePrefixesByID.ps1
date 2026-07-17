function Get-NBPrefixAvailablePrefixesByID {
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$id
	)
	Get-ApiItemByPath -apiConnection $Connection -Path $PrefixesAPIPath/$id/available-prefixes/
}