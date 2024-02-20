function Get-NBIPAddressByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	#Get-ApiItemByName -apiConnection $Connection -RelativePath $IPAddressAPIPath -value $name
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $IPAddressAPIPath -field 'address' -value $name).results

}