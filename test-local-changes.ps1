
. .\version.ps1

if ($IsLinux) {
	Copy-Item $PSScriptRoot\Build\netbox-rest-module\$moduleVersionTarget\* ~/.local/share/powershell/Modules/netbox-rest-module/$moduleVersionTarget/
	Import-Module netbox-rest-module -Force
}
