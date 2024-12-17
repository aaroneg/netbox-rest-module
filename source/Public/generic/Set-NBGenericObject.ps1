function Set-NBGenericObject {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$Path,
		[Parameter(Mandatory=$true,Position=1)][Object]$InputObject,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$InputObject.PSObject.Properties.Remove('url')
	$InputObject.PSObject.Properties.Remove('display_url')
	$InputObject.PSObject.Properties.Remove('primary_ip')
	
	if ($InputObject.name){
		if(!($InputObject.slug)){$InputObject|Add-Member -MemberType NoteProperty -Name 'slug' -Value (makeSlug $InputObject.name)}
		else{$InputObject.slug =(makeSlug $InputObject.name)}
	}
	if($InputObject.status){
		[string]$stat=$InputObject.status.value.ToString()
		$InputObject.PSObject.Properties.Remove('status')
		$InputObject|Add-Member -MemberType NoteProperty -Name 'status' -Value $stat
	}
	$InputObject|Get-Member -Type NoteProperty|Select-Object -ExpandProperty Name|ForEach-Object { 
		if($deviceObj.$_.id){
			$InputObject.$_ = $InputObject.$_.id
		}

	}
	[PSCustomObject]$PatchObj=@{}
	[array]$keys=$InputObject|Get-Member -MemberType NoteProperty|select -ExpandProperty Name
	$keys|%{ $PatchObj|Add-Member -MemberType NoteProperty -Name $_ -Value $InputObject.$_}
	$PostJson = createJson($PatchObj)
	Write-Debug "[$($PostJson.ToString())]"

	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$Path/$($InputObject.id)/"
		body = "$PostJson"
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}