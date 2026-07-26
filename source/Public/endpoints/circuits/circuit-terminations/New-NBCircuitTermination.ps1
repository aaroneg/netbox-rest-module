<#
.SYNOPSIS
Create a circuit termination

.DESCRIPTION
Create a circuit termination

.PARAMETER circuit
The id of the circuit

.PARAMETER term_side
The side of the connection

.PARAMETER site
Site object ID

.PARAMETER provider_network
Provider ID number

.PARAMETER port_speed
Port speed in kbps

.PARAMETER upstream_speed
Port speed in kbps

.PARAMETER xconnect_id
Cross-connect identifier

.PARAMETER pp_info
patch panel / port information

.PARAMETER description
description

.PARAMETER mark_connected
Treat the termination as connected

.PARAMETER tags
A list of tag IDs

.PARAMETER custom_fields
A hash table of custom fields

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBCircuitTermination {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$circuit,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('A','Z')]
			$term_side,		
		[Parameter(Mandatory=$false)][int]$site,
		[Parameter(Mandatory=$false)][int]$provider_network,
		[Parameter(Mandatory=$false)][int]$port_speed,
		[Parameter(Mandatory=$false)][int]$upstream_speed,
		[Parameter(Mandatory=$false)][string]$xconnect_id,
		[Parameter(Mandatory=$false)][string]$pp_info,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][bool]$mark_connected,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitTerminationsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}