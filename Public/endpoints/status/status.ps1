$StatusAPIPath="status"

function Get-NBStatus {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$restParams=@{
		Method = 'Get'
		Uri = "$($Connection.ApiBaseUrl)/$StatusAPIPath/"
	}	
	Invoke-CustomRequest -restParams $restParams -Connection $Connection
}


Export-ModuleMember -Function "*-*"
