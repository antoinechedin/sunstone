param(
    [string]$Template = "$PSScriptRoot\themes\sunstone-color-template.json",
    [string]$Palette = "$PSScriptRoot\themes\palette.json",
    [string]$BuildDir = "$PSScriptRoot\build"
)

$Colors = Get-Content $Palette | Out-String | ConvertFrom-Json
$Theme = Get-Content $Template | Out-String

$Results = $Theme | Select-String ": *\""(.*?)(?:@([0-9]+[.]?[0-9]*))?\""" -AllMatches 

# Replace named color found in the palette
for ($i = $Results.Matches.Count - 1; $i -ge 0; $i--) {
    $Match = $Results.Matches[$i].Groups[1]
    
    if ($Match.Value -in $Colors.PSobject.Properties.Name) {
        $Color = $Colors.$($Match.Value)
        $MatchLength = $Match.Length
        
        if ($Results.Matches[$i].Groups[2].Success) {
            $MatchLength += $Results.Matches[$i].Groups[2].Length + 1
            $Alpha = [double] $Results.Matches[$i].Groups[2].Value
            $Color += "{0:x2}" -f  $([int][math]::Round($Alpha * 255))
        }
    
        $Theme = $Theme.Remove($Match.Index, $MatchLength).Insert($Match.Index, $Color)
    }
}

$OutFilePath = Join-Path $BuildDir sunstone-color-theme.json
if (!(Test-Path $OutFilePath)) {
    New-Item -Path $OutFilePath -ItemType File -Force
}

$Theme | Out-File -FilePath $OutFilePath -Encoding utf8 -Force
