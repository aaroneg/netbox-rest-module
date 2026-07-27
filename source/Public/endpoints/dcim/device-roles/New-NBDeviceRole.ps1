<#
.SYNOPSIS
Create new device role

.DESCRIPTION
Create new device role

.PARAMETER name
Role Name

.PARAMETER color
Color in hex, do not prefix with '#' ex: FFFFFF

.PARAMETER vm_role
Set to $true if the role can apply to virtual machines

.PARAMETER config_template
Config template object ID

.PARAMETER parent
Parent device role ID, if applicable

.PARAMETER description
Role description

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & values

.PARAMETER owner
Owner object ID

.PARAMETER comments
Comments

.PARAMETER Connection
The connection object to use, if not using default.

.EXAMPLE
An example

.NOTES
General notes
#>
function New-NBDeviceRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][string]$color,
		[Parameter(Mandatory=$false)][bool]$vm_role,
		[Parameter(Mandatory=$false)][int]$config_template,
		[Parameter(Mandatory=$false)][int]$parent,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$DeviceRolesAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}