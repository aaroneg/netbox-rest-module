function New-NBGenericObject {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$Path,
		[Parameter(Mandatory=$true,Position=1)][Object]$NewItem,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	#$NewItem|Get-Member|Out-Host
	$NewItem.PSObject.Properties.Remove('id')
	$NewItem.PSObject.Properties.Remove('url')
	$NewItem.PSObject.Properties.Remove('display_url')
	#$NewItem.PSObject.Properties.Remove('custom_fields')
	$NewItem.PSObject.Properties.Remove('primary_ip')
	$NewItem.PSObject.Properties.Remove('primary_ip4')
	$NewItem.PSObject.Properties.Remove('primary_ip6')
	$NewItem.PSObject.Properties.Remove('oob_ip')
	if ($NewItem.name){
		if(!($NewItem.slug)){$NewItem|Add-Member -MemberType NoteProperty -Name 'slug' -Value (makeSlug $NewItem.name)}
		else{$NewItem.slug =(makeSlug $NewItem.name)}
	}
	$NewItem.status.gettype()
	if($NewItem.status){
		[string]$stat=$NewItem.status.value.ToString()
		$NewItem.PSObject.Properties.Remove('status')
		$NewItem|Add-Member -MemberType NoteProperty -Name 'status' -Value $stat
	}
	$NewItem|Get-Member -Type NoteProperty|Select-Object -ExpandProperty Name|ForEach-Object { 
		if($deviceObj.$_.id){
			$NewItem.$_ = $NewItem.$_.id
		}

	}
	$PostJson = createJson($NewItem)
	Write-Debug $PostJson.ToString()
	#Read-Host -Prompt 'press enter'
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$Path/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}