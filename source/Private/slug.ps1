function makeSlug ([string]$name) {
	$name.ToLower() -Replace("[^\w ]+","") -replace " +","-" -replace "^-",'' -replace "-$",''
}