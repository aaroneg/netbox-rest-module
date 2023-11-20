function Get-NBASNByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$asn
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $ASNsAPIPath -value $asn

}