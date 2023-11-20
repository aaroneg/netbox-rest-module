function split-file-by-function {
	$content = gci *.ps1
	(($content| Select-String -pattern "function").Line) | % {$_.Split(' ')[1]}|% {
		#New-Item "$($_).ps1"
		"function $_ {" | Out-File -FilePath ".\$($_).ps1" -NoNewline
		(Get-Command $_).Definition | Out-File -FilePath ".\$($_).ps1" -Append
		"}"| Out-File -FilePath ".\$($_).ps1" -Append -NoNewline
	} 
}