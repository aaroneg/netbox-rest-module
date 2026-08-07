#! /usr/bin/pwsh
$startDir = get-item .
cd $PSScriptRoot
. $PSScriptRoot\version.ps1
. $PSScriptRoot\build.ps1
if ($IsLinux) {
	if(!(test-path $env:HOME/.local/share/powershell/Modules/netbox-rest-module/$moduleVersionTarget)) {New-Item -ItemType Directory -Path ~/.local/share/powershell/Modules/netbox-rest-module/$moduleVersionTarget}
	Copy-Item $PSScriptRoot\Build\netbox-rest-module\$moduleVersionTarget\* ~/.local/share/powershell/Modules/netbox-rest-module/$moduleVersionTarget/
	Import-Module netbox-rest-module -Force
}
if ($IsWindows){
	$UserModulePath=$env:PSModulePath.Split(';')[0]
	if(!(Test-Path $UserModulePath\netbox-rest-module\$moduleVersionTarget)) {New-Item -ItemType Directory -Path $UserModulePath/netbox-rest-module/$moduleVersionTarget -Force}
	Copy-Item $PSScriptRoot\Build\netbox-rest-module\$moduleVersionTarget\* $UserModulePath/netbox-rest-module/$moduleVersionTarget
	Import-Module netbox-rest-module -Force
}
remove-module netbox-rest-module
import-module netbox-rest-module -force
Get-Module netbox-rest-module
cd $startDir
if("$startDir.FullName" -ne "$PSScriptRoot.FullName"){. .\init.ps1}
