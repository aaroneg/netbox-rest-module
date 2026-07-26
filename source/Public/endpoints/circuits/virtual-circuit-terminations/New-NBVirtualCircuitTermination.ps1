<#
.SYNOPSIS
New Netbox object

.DESCRIPTION
New Netbox object

.PARAMETER virtual_circuit
virtual circuit ID

.PARAMETER role
The termination role

.PARAMETER interface
interface object ID

.PARAMETER description
object description

.PARAMETER tags
list of tag ID[s]

.PARAMETER custom_fields
hashtable of custom fields

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBVirtualCircuitTermination {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$virtual_circuit,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('peer','hub','spoke')]
			$role,		
		[Parameter(Mandatory=$false)][int]$interface,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBVirtualCircuitTerminationsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}