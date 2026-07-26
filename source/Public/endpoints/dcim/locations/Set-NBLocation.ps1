<#
.SYNOPSIS
Modify object properties

.DESCRIPTION
Modify object properties

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
ID of object to modify

.PARAMETER key
Property to modify

.PARAMETER value
New value for property
#>
function Set-NBLocation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','site','parent','status','tenant','facility','description','tags','custom_fields','owner','comments')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$LocationsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}