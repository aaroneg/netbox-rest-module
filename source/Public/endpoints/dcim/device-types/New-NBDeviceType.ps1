function New-NBDeviceType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$manufacturer,
		[Parameter(Mandatory=$false)][int]$default_platform,
		[Parameter(Mandatory=$true,Position=1)][string]$model,
		[Parameter(Mandatory=$false)][string]$part_number,
		[Parameter(Mandatory=$false)][int]$u_height,
		[Parameter(Mandatory=$false)][bool]$is_full_depth,
		[Parameter(Mandatory=$false)][string]$subdevice_role,
		[Parameter(Mandatory=$false)]
			[ValidateSet('front-to-rear','rear-to-front','left-to-right','right-to-left','side-to-rear','passive','mixed')]
			[string]$airflow,
		[Parameter(Mandatory=$false)][int]$weight,
		[Parameter(Mandatory=$false)]
			[ValidateSet('kg','g','lb','oz')]
			[string]$weight_unit,
		[Parameter(Mandatory=$false)][string]$front_image,
		[Parameter(Mandatory=$false)][string]$rear_image,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $model
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Running"
	Write-Verbose $PostJson
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$deviceTypesPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}