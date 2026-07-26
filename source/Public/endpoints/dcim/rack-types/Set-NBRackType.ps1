<#
.SYNOPSIS
Change properties of an object

.DESCRIPTION
Change properties of an object

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
Object ID to change

.PARAMETER key
What field should be changed?

.PARAMETER value
What is the new value?
#>
function Set-NBRackType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('manufacturer','model','slug','description','form_factor','width','u_height','starting_unit','desc_units','outer_width',
			'outer_depth','outer_unit','weight','max_weight','weight_unit','mounting_depth','comments','tags','custom_fields')]
			$key,
		[Parameter(Mandatory=$true,Position=2,
			HelpMessage="A valid value for the attribute you want to change. If the expected value is an array, like for tags, pass it as '1,2' or whatever the ids of the tags you wish to set are."
		)][string]$value
	)
	$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBRackTypesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}