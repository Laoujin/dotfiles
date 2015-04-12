function Write-Title($title) {
   $titleHeader = "#" * ($title.length + 6)
   Write-Host $titleHeader -ForegroundColor darkgreen
   Write-Host "## $title ##" -ForegroundColor darkgreen
   Write-Host $titleHeader -ForegroundColor darkgreen
}


function Show-Colors( ) {
  $colors = [Enum]::GetValues( [ConsoleColor] )
  $max = ($colors | foreach { "$_ ".Length } | Measure-Object -Maximum).Maximum
  foreach( $color in $colors ) {
    Write-Host (" {0,2} {1,$max} " -f [int]$color,$color) -NoNewline
    Write-Host "$color" -Foreground $color
  }
}