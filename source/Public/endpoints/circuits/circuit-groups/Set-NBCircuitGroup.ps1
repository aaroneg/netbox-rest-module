<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
Parameter description

.PARAMETER key
Parameter description

.PARAMETER value
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Set-NBCircuitGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		# ValidateSets updated as of Netbox v4.1.8
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','description','tenant','tags','custom_fields')]
			$key,
		[Parameter(Mandatory=$true,Position=2,
			HelpMessage="A valid value for the attribute you want to change. If the expected value is an array, like for tags, pass it as '1,2' or whatever the ids of the tags you wish to set are."
		)][string]$value
	)
	$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitGroupsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}