function Find-NBASNsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$asn
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $ASNsAPIPath -name $asn

}