function Get-NBIPAddressByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	Get-ApiItemByID -apiConnection $Connection -RelativePath $IPAddressAPIPath -id $id

}