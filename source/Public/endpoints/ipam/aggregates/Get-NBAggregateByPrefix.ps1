function Get-NBAggregateByPrefix {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$prefix
	)
	Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBAggregateAPIPath -field prefix -value $prefix

}