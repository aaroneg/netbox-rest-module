function Get-NBSchemaDefinitionForObjectType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory,Position=0)][object]$SchemaObject,
		[Parameter(Mandatory,Position=1)][string]$ObjectType
	)
	$SchemaObject.components.schemas.$ObjectType.properties|get-member -MemberType NoteProperty|select name,@{name='definition'; expression={$_.definition -replace 'System.Management.Automation.PSCustomObject ',''}}
}