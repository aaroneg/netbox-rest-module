function Get-NBSchema {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	(Get-ApiItemByQuery -apiConnection $Connection -RelativePath 'schema' -field format -value 'json')

}