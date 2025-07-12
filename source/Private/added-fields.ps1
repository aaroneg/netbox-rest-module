function createPostJson {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][object]$Fields
	)
	$CurrentObject=New-Object -TypeName System.Object
	$Fields | ForEach-Object {
		Write-Debug $_.key
		Write-Debug $_.value
		$CurrentObject | Add-Member -MemberType NoteProperty -Name $_.key -Value $_.value
	}
	createJson($CurrentObject)
}
function createJson ($Object) { $Object | ConvertTo-Json -Depth 50 }