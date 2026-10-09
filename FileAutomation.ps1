[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [string]$SourcePath = (Join-Path $PSScriptRoot 'Samples\Inbox'),
    [string]$DestinationPath = (Join-Path $PSScriptRoot 'Samples\Organized')
)

if (-not (Test-Path -LiteralPath $SourcePath -PathType Container)) {
    throw "Source directory does not exist: $SourcePath"
}

$files = @(Get-ChildItem -LiteralPath $SourcePath -File)
$eligibleFiles = @($files | Where-Object { $_.Extension -ne '.tmp' })

foreach ($temporaryFile in $files | Where-Object { $_.Extension -eq '.tmp' }) {
    Write-Output "Skipped temporary file: $($temporaryFile.Name)"
}

if ($eligibleFiles.Count -eq 0) {
    Write-Output 'No files to organize.'
    return
}

if (-not (Test-Path -LiteralPath $DestinationPath -PathType Container)) {
    if ($PSCmdlet.ShouldProcess($DestinationPath, 'Create destination directory')) {
        New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
    }
}

foreach ($file in $eligibleFiles) {
    $category = if ($file.Extension) {
        $file.Extension.TrimStart('.').ToLowerInvariant()
    }
    else {
        'no-extension'
    }

    $categoryPath = Join-Path $DestinationPath $category
    if (-not (Test-Path -LiteralPath $categoryPath -PathType Container)) {
        if ($PSCmdlet.ShouldProcess($categoryPath, 'Create category directory')) {
            New-Item -ItemType Directory -Path $categoryPath -Force | Out-Null
        }
    }

    $targetPath = Join-Path $categoryPath $file.Name
    if ($PSCmdlet.ShouldProcess($targetPath, "Move '$($file.Name)'")) {
        Move-Item -LiteralPath $file.FullName -Destination $targetPath
        Write-Output "Moved $($file.Name) to $category/"
    }
}