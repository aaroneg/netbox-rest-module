function New-NBRackType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$manufacturer,
		[Parameter(Mandatory=$true,Position=1)][string]$model,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$true,Position=2)]
			[ValidateSet('2-post-frame','4-post-frame','4-post-cabinet','wall-frame','wall-frame-vertical','wall-cabinet','wall-cabinet-vertical')]
			[string]$form_factor,
		[Parameter(Mandatory=$false)]
			[ValidateSet(10,19,21,23)]
			[int]$width,
		[Parameter(Mandatory=$false)][int]$u_height,
		[Parameter(Mandatory=$false)][int]$starting_unit,
		[Parameter(Mandatory=$false)][switch]$desc_units,
		[Parameter(Mandatory=$false)][int]$outer_width,
		[Parameter(Mandatory=$false)][int]$outer_depth,
		[Parameter(Mandatory=$false)]
			[ValidateSet('mm','in')]
			[string]$outer_unit,
		[Parameter(Mandatory=$false)][double]$weight,
		[Parameter(Mandatory=$false)][double]$max_weight,
		[Parameter(Mandatory=$false)]
			[ValidateSet('kg','g','lb','oz')]
			[string]$weight_unit,
		[Parameter(Mandatory=$false)][int]$mounting_depth,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $model
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBRackTypesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}