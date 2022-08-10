function Invoke-CustomRequest {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][System.Object]$restParams,
		[Parameter(Mandatory = $True, Position = 1)][System.Object]$Connection
	)
	$Headers = @{
		"Authorization" = $Connection.ApiKey
		ContentType    = 'application/json'
	}
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Making API call."
	try {
		$result = Invoke-RestMethod @restParams -Headers $headers
	}
	catch {
		if ($_.ErrorDetails.Message) {
			$_.ErrorDetails
			#Write-Error "Response from $($Connection.Address): $(($_.ErrorDetails.Message).message)."
		}
		else {
			$_.ErrorDetails.Message
		}
	}
	$result
}
