<#
.SYNOPSIS
This command pulls information on the user attached to the key you're using.

.DESCRIPTION
This command pulls information on the user attached to the key you're using.

.PARAMETER Connection
The connection object to use, if not using default.

.EXAMPLE
Get-NBAuthenticationCheck

.NOTES
No notes
#>
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