# A symlink doesn't for .gitconfig work:
# whenever gitconfig is updated through git, the file gets overwritten and the symlink broken
# This script could be a solution...

function git-config-update
{
  $localPath = "$env:USERPROFILE\.gitconfig".replace('\', "\\")
  $globalPath = "C:\src\github\Global\Git\gitconfig".replace('\', "\\")

  $redirectAutoText = "# Generated file. Do not edit!`n[include]`n  path = $globalPath`n`n"
  $localText = get-content $localPath

  $diffs = (compare-object -ref $redirectAutoText.split("`n") -diff ($localText) | 
    measure-object).count

  if ($diffs -eq 0)
  {
    write-output ".gitconfig unchanged."
    return
  }

  $skipLines = 0
  $diffs = (compare-object -ref ($redirectAutoText.split("`n") | 
     select -f 3) -diff ($localText | select -f 3) | measure-object).count
  if ($diffs -eq 0)
  {
    $skipLines = 4
    write-warning "New settings appended to $localPath...`n "
  }
  else
  {
    write-warning "New settings found in $localPath...`n "
  }
  $localLines = (get-content $localPath | select -Skip $skipLines) -join "`n"
  $newSettings = $localLines.Split(@("["), [StringSplitOptions]::RemoveEmptyEntries) | 
    where { ![String]::IsNullOrWhiteSpace($_) } | %{ "[$_".TrimEnd() }

  $globalLines = (get-content  $globalPath) -join "`n"
  $globalSettings =  $globalLines.Split(@("["), [StringSplitOptions]::RemoveEmptyEntries)| 
    where { ![String]::IsNullOrWhiteSpace($_) } | %{ "[$_".TrimEnd() }

  $appendSettings = ($newSettings | %{ $_.Trim() } | 
    where { !($globalSettings -contains $_.Trim()) })
  if ([string]::IsNullOrWhitespace($appendSettings))
  {
    write-output "No new settings found."
  }
  else
  {
    echo $appendSettings
    add-content $globalPath ("`n# Additional settings added from $env:COMPUTERNAME on " + (Get-Date -displayhint date) + "`n" + $appendSettings)
  }
  set-content $localPath $redirectAutoText -force
}