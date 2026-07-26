<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Connection
Parameter description

.PARAMETER id
Parameter description

.PARAMETER key
Parameter description

.PARAMETER value
Parameter description
#>
function Set-NBCircuitTermination {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('circuit','term_side','site','provider_network','port_speed','upstream_speed','xconnect_id','pp_info','description','mark_connected','custom_fields','tags')]
			$key,
		[Parameter(Mandatory=$true,Position=2,
			HelpMessage="A valid value for the attribute you want to change. If the expected value is an array, like for tags, pass it as '1,2' or whatever the ids of the tags you wish to set are."
		)][string]$value
	)
	$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitTerminationsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}