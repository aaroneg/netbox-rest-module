function Get-NBPrefixByCIDR {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$CIDR
	)
	#(Get-ApiItemByQuery -apiConnection $Connection -RelativePath $deviceTypesPath -field 'model__ie' -value $model).results
	(Get-ApiItemByQuery -apiConnection $Connection -RelativePath $PrefixesAPIPath -field 'prefix' -value $CIDR).results

}