function New-NBSite {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('planned','staging','active','decommissioning','retired')]
			$status,
		[Parameter(Mandatory=$false)][int]$region,
		[Parameter(Mandatory=$false)][int]$group,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][string]$facility,
		[Parameter(Mandatory=$false)][string]$time_zone,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$physical_address,
		[Parameter(Mandatory=$false)][string]$shipping_address,
		[Parameter(Mandatory=$false)][double]$latitude,
		[Parameter(Mandatory=$false)][double]$longitude,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][int[]]$asns,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$SitesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}