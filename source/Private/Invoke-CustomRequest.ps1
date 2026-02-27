function Invoke-CustomRequest {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][System.Object]$restParams,
		[Parameter(Mandatory = $True, Position = 1)][System.Object]$Connection
	)
	$Headers = @{
		Authorization = "Bearer $($Connection.ApiKeyID).$($Connection.ApiKey)"
		"Content-Type"    = 'application/json'
		"Accept"          = 'application/json'
	}
	$callstack=Get-PSCallStack
	Write-Debug ("[$($Callstack[1].command) ⇒ $($MyInvocation.MyCommand.Name)] REST params:`n" + ($restParams|Out-String))
	Write-Debug ("[$($Callstack[1].command) ⇒ $($MyInvocation.MyCommand.Name)] Headers:`n" + ($Headers|Out-String))
	Write-Verbose "[$($Callstack[1].command) ⇒ $($MyInvocation.MyCommand.Name)] Making API $($restParams.Method) call to $($restParams.Uri)"
	try {
		$result = Invoke-RestMethod @restParams -Headers $headers -SkipCertificateCheck:$Connection.SkipCertificateCheck  -ResponseHeadersVariable $ResponseHeaders -StatusCodeVariable $StatusCode
	}
	catch {
		Write-Error ("Response from API: $($_.ErrorDetails)")
		Write-Error ("[$($Callstack[1].command) ⇒ $($MyInvocation.MyCommand.Name)] Exception:`n" + ($_.Exception.Message|Out-String))
		#$Global:foo = $_
	}
	$result
	Write-Debug "[$($Callstack[1].command) ⇒ $($MyInvocation.MyCommand.Name)] Exiting function"
}
