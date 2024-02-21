
. $PSScriptRoot\version.ps1

if ($IsLinux) {
	if(!(test-path $env:HOME/.local/share/powershell/Modules/netbox-rest-module/$moduleVersionTarget)) {New-Item -ItemType Directory -Path ~/.local/share/powershell/Modules/netbox-rest-module/$moduleVersionTarget}
	Copy-Item $PSScriptRoot\Build\netbox-rest-module\$moduleVersionTarget\* ~/.local/share/powershell/Modules/netbox-rest-module/$moduleVersionTarget/
	Import-Module netbox-rest-module -Force
}
remove-module netbox-rest-module
import-module netbox-rest-module -force
Get-Module netbox-rest-module
