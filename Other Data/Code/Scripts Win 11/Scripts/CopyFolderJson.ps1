param([string]$Path)

$result = Get-ChildItem -LiteralPath $Path -File | ForEach-Object {

    $name = [IO.Path]::GetFileNameWithoutExtension($_.Name)

    [PSCustomObject]@{
        link = "file:///" + ($_.FullName -replace '\\','/')
        name = ($name -replace '_',' ')
    }
}

($result | ConvertTo-Json -Compress) | Set-Clipboard