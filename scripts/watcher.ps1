Push-Location "$PSScriptRoot\.."

$OnChangedEvent = $null
try {
    $Watcher = New-Object IO.FileSystemWatcher ".\themes", "*.*" -Property @{ 
        IncludeSubdirectories = $false
        EnableRaisingEvents   = $true
    }

    $OnChangedEvent = Register-ObjectEvent $Watcher Changed -Action {
        .\build.ps1
    }

    while ($true) {
        Start-Sleep -Seconds 1
    }
}
finally {
    if ($null -ne $OnChangedEvent) {
        Unregister-Event $OnChangedEvent.name
    }
}
