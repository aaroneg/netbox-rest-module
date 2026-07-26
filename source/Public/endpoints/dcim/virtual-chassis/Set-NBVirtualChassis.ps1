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
function Set-NBVirtualChassis {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBVirtualChassisAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}