$files=Get-ChildItem $PSScriptRoot\Public -Filter "*.ps1" -Recurse
foreach ($file in $files) {
    . $file.FullName
    #$file.FullName
}
$files.FullName