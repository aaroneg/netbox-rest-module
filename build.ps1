. .\version.ps1
try {Import-Module ModuleBuilder -ErrorAction Stop} catch {Install-Module ModuleBuilder -Scope CurrentUser}
del -Recurse .\build\
Build-Module -SourcePath .\source -OutputDirectory ..\Build\ -VersionedOutputDirectory -SemVer $moduleVersionTarget -Target CleanBuild -Verbose
