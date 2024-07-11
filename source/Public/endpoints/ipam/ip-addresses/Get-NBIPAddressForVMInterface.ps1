function Get-NBIPAddressForVMInterface {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$vmintid
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	$intType=(Get-NBObjectTypes|Where-Object {$_.model -eq "vminterface"}).id
	$RelativePath = $IPAddressAPIPath
	$QueryArguments=@{
		assigned_object_type = $intType
		assigned_object_id = $vmintid
	}
	$ArgumentString = New-ArgumentString $QueryArguments
	$restParams = @{
        Method               = 'get'
        URI                  = "$($Connection.ApiBaseURL)/$RelativePath/?$ArgumentString"
        SkipCertificateCheck = $apiConnection.SkipCertificateCheck
	}
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Making API search call using '$field' looking for '$value'."
	(Invoke-CustomRequest $restParams -Connection $Connection).results

}