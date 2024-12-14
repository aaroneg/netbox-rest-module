function Get-NBPrefixAvailablePrefixes {
	<#
		.SYNOPSIS
			A convenience method for returning available prefixes within a prefix
	
		.DESCRIPTION
			Will return any available prefixes within a prefix.
	
		.PARAMETER PrefixId
			Parent Netbox IP Prefix ID
	
		.EXAMPLE
			Get-NBPrefixAvailablePrefixes -PrefixId (Get-NBPrefixByCIDR -CIDR '10.0.0.0/14').id
	
		.NOTES
			Additional information about the function.
	#>
	
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$PrefixId
	)
	Get-ApiItemByPath -apiConnection $Connection -Path $PrefixesAPIPath/$PrefixId/available-prefixes/
	}