# npm i -g db-migrate
Set-Alias dbm db-migrate

# npm i -g google-translate-cli
function Translate-EnglishToDutch {
	translate -t nl $args
}
function Translate-DutchToEnglish {
	translate -s nl -t en $args
}

# Translate English to Dutch
Set-Alias transed Translate-EnglishToDutch
Set-Alias transde Translate-DutchToEnglish
