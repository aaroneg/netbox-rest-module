function Get-NBAuthenticationCheck {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$restParams=@{
		Method = 'Get'
		Uri = "$($Connection.ApiBaseUrl)/authentication-check/"
	}	
	Invoke-CustomRequest -restParams $restParams -Connection $Connection

}