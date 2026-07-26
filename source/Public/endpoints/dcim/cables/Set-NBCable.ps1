<#
.SYNOPSIS
Change properties of a cable

.DESCRIPTION
Change properties of a cable

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
Object ID to change

.PARAMETER key
What field should be changed?

.PARAMETER value
What is the new value?
#>
function Set-NBCable {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('type','status','profile','tenant','bundle','label','color','length','length_unit','description','comments','tags','custom_fields')]
			$key,
		[Parameter(Mandatory=$true,Position=2,
			HelpMessage="A valid value for the attribute you want to change. If the expected value is an array, like for tags, pass it as '1,2' or whatever the ids of the tags you wish to set are."
		)][string]$value
	)
	$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBCablesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}