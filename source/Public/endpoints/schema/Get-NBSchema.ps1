function Get-NBSchema {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$restParams=@{
		Method = 'Get'
		Uri = "$($Connection.ApiBaseUrl)/schema/"
	}	
	(Get-ApiItemByQuery -apiConnection $Connection -RelativePath 'schema' -field format -value 'json')

}