<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Connection
Parameter description

.PARAMETER id
Parameter description

.PARAMETER termination_type
Parameter description

.PARAMETER termination_id
Parameter description
#>
function Set-NBCircuitTermination {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('circuits.providernetwork','dcim.location','dcim.region','dcim.site','dcim.sitegroup')]
			$termination_type,
		[Parameter(Mandatory=$true,Position=2)][int]$termination_id
	)
	$update=@{
		termination_type = "$member_type"
		termination_id = $member_id
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitTerminationsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}