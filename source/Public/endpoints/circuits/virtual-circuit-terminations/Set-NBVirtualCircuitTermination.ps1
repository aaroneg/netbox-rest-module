<#
.SYNOPSIS
Modify termination object

.DESCRIPTION
Modify termination object

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
object ID

.PARAMETER key
The property name you'd like to modify

.PARAMETER value
The new value you'd like to set
#>
function Set-NBVirtualCircuitTermination {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('virtual_circuit','role','interface','description','custom_fields','tags')]
			$key,
		[Parameter(Mandatory=$true,Position=2,
			HelpMessage="A valid value for the attribute you want to change. If the expected value is an array, like for tags, pass it as '1,2' or whatever the ids of the tags you wish to set are."
		)][string]$value
	)
	$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBVirtualCircuitTerminationsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}