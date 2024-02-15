try {Import-Module ModuleBuilder -ErrorAction Stop} catch {Install-Module ModuleBuilder -Scope CurrentUser}
del -Recurse .\build\
Build-Module -SourcePath .\source -OutputDirectory ..\Build\ -VersionedOutputDirectory -SemVer 0.0.1 -Target CleanBuild -Verbose
cd .\Build
