<#
.SYNOPSIS
Create new Cable object

.DESCRIPTION
Create new Cable object

.PARAMETER type
The cable type, ex: cat3 - there are a lot of options for this, the API value is usually the lowercase version of the values displayed on the web page.

.PARAMETER status
Lifecycle status of the cable - connected, planned, or decommissioning

.PARAMETER profile
Cable type, like breakout, trunk, etc - the API values are not obvious from the web page, see the "Rest API documentation" link in your Netbox instance, search on the page for 'api/dcim/cables', click the "post" entry and expand the WritableCableRequest object down to the field level. All valid values for your version of Netbox are listed there.

.PARAMETER tenant
Tenant object ID

.PARAMETER bundle
Bundle object ID

.PARAMETER label
Label on cable

.PARAMETER color
Color code in Hex without "#" prefix, ex: FFFFFF

.PARAMETER length
Number of units this cable is in length, like "1". You'll set the measurement type in length_unit

.PARAMETER length_unit
How is the length measured? km,m,cm,mi,ft,in

.PARAMETER description
A description of the object

.PARAMETER owner
Owner object ID

.PARAMETER comments
Comments

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & values

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBCable {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][string]$type,	
		#[Parameter(Mandatory=$true,Position=0)][hashtable[]]$a_terminations,
		#[Parameter(Mandatory=$true,Position=1)][hashtable[]]$b_terminations,
		[Parameter(Mandatory=$false)]
			[ValidateSet('connected','planned','decommissioning')]
			[string]$status,
		[Parameter(Mandatory=$false)][string]$profile,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$bundle,
		[Parameter(Mandatory=$false)][string]$label,
		[Parameter(Mandatory=$false)][string]$color,
		[Parameter(Mandatory=$false)][int]$length,
		[Parameter(Mandatory=$false)]
			[ValidateSet('km','m','cm','mi','ft','in')]
			[string]$length_unit,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBCablesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}