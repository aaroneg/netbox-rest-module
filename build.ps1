. $PSScriptRoot\version.ps1
try {Import-Module ModuleBuilder -ErrorAction Stop} catch {Install-Module ModuleBuilder -Scope CurrentUser}
#del -Recurse $PSScriptRoot\Build\
Build-Module -SourcePath .\source -OutputDirectory ..\Build\ -VersionedOutputDirectory -SemVer "$moduleVersionTarget-alpha" -Target CleanBuild -Verbose 
#Build-Module -SourcePath .\source -OutputDirectory ..\Build\ -VersionedOutputDirectory -SemVer "$moduleVersionTarget-beta" -Target CleanBuild -Verbose 
#Build-Module -SourcePath .\source -OutputDirectory ..\Build\ -VersionedOutputDirectory -SemVer "$moduleVersionTarget" -Target CleanBuild -Verbose 
