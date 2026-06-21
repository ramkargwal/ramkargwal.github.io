param([string]$Path)

$result = Get-ChildItem -LiteralPath $Path -File | ForEach-Object {

    $name = [IO.Path]::GetFileNameWithoutExtension($_.Name)

    [PSCustomObject]@{
        name = ($name -replace '_',' ')
        link = "file:///" + ($_.FullName -replace '\\','/')
    }
}

# Pretty JSON clipboard में copy करें
$result | ConvertTo-Json -Depth 3 | Set-Clipboard

# HTML file open करें
Start-Process "C:\SudarshanTools\html\Raman_Photo_quiz.html"