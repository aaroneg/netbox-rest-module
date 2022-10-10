function createObjectWithAddedFields {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][System.Object]$CurrentObject,
		[Parameter(Mandatory = $True, Position = 1)][hashtable]$AddedFields
	)
	$AddedFields | ForEach-Object {
		$CurrentObject | Add-Member -MemberType NoteProperty -Name $_.key -Value $_.value
	}
	$CurrentObject
}
function createJson ($Object) { $Object | ConvertTo-Json -Depth 50 }