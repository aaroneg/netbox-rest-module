$files=Get-ChildItem $PSScriptRoot -Filter "*.ps1" -Recurse
foreach ($file in $files) {
    . $file.FullName
}
$files
