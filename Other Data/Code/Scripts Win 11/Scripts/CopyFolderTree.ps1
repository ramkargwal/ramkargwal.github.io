param(
    [string]$Path
)

$script:Result = ""

function Show-Tree {
    param(
        [string]$Folder,
        [string]$Indent = ""
    )

    Get-ChildItem -LiteralPath $Folder | ForEach-Object {

        $script:Result += "$Indent+-- $($_.Name)`r`n"

        if ($_.PSIsContainer) {
            Show-Tree -Folder $_.FullName -Indent ($Indent + "|   ")
        }
    }
}

$script:Result += (Split-Path $Path -Leaf) + "`r`n"
Show-Tree -Folder $Path

Set-Clipboard -Value $script:Result
Write-Host "Folder tree copied to clipboard."