param(
    [string]$Template = "$PSScriptRoot\themes\sunstone-color-template.json",
    [string]$Palette = "$PSScriptRoot\themes\palette.json",
    [string]$BuildDir = "$PSScriptRoot\build"
)

$Colors = Get-Content $Palette | Out-String | ConvertFrom-Json
$Theme = Get-Content $Template | Out-String

$Results = $Theme | Select-String ": *\""(.*?)\""" -AllMatches 

# Replace named color found in the palette
for ($i = $Results.Matches.Count - 1; $i -ge 0; $i--) {
    $Match = $Results.Matches[$i].Groups[1]
    if ($Match.Value -in $Colors.PSobject.Properties.Name) {
        $Theme = $Theme.Remove($Match.Index, $Match.Length).Insert($Match.Index, $Colors.$($Match.Value))
    }
}

$OutFilePath = Join-Path $BuildDir sunstone-color-theme.json
if (!(Test-Path $OutFilePath)) {
    New-Item -Path $OutFilePath -ItemType File -Force
}

$Theme | Out-File -FilePath $OutFilePath -Encoding utf8 -Force
