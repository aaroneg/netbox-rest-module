function New-ArgumentString {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][hashtable]$QueryArguments
	)
	$OutputString = [System.Web.HttpUtility]::ParseQueryString('')
	$QueryArguments.GetEnumerator() | ForEach-Object { $OutputString.Add($_.Key, $_.Value) }
	$OutputString.ToString()
}
