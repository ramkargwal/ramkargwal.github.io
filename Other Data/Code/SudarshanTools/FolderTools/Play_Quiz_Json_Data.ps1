param([string]$Path)

$result = Get-ChildItem -LiteralPath $Path -File | ForEach-Object {

    $name = [IO.Path]::GetFileNameWithoutExtension($_.Name)

    [PSCustomObject]@{
        link = "file:///" + ($_.FullName -replace '\\','/')
        name = ($name -replace '_',' ')
    }
}

# 1. डेटा को JSON में बदलकर क्लिपबोर्ड (Clipboard) में कॉपी करना
($result | ConvertTo-Json -Compress) | Set-Clipboard

# 2. डेटा कॉपी होने के ठीक बाद HTML फाइल को डिफ़ॉल्ट ब्राउज़र में ओपन करना
Start-Process "C:\SudarshanTools\html\Raman_Photo_quiz.html"