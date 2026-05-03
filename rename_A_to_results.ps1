Param(
    [switch]$UseGit
)

if (-not (Test-Path -LiteralPath "A" -PathType Container)) {
    Write-Output "Directory 'A' not found; nothing to do."
    exit 0
}

if ($UseGit -and (Test-Path .git)) {
    git mv A results
    if ($LASTEXITCODE -ne 0) { Write-Error "git mv failed with exit code $LASTEXITCODE"; exit $LASTEXITCODE }
    Write-Output "Renamed 'A' -> 'results' using git mv."
} else {
    if (Test-Path -LiteralPath "results") {
        Write-Error "Target 'results' already exists. Aborting to avoid overwrite."
        exit 1
    }
    Move-Item -LiteralPath "A" -Destination "results" -Verbose
    Write-Output "Moved 'A' -> 'results' (filesystem move)."
}

# Also move/merge csv_supporting_files into results if present
if (Test-Path -LiteralPath "csv_supporting_files" -PathType Container) {
    if ($UseGit -and (Test-Path .git)) {
        git mv csv_supporting_files results
        if ($LASTEXITCODE -ne 0) { Write-Error "git mv csv_supporting_files failed with exit code $LASTEXITCODE"; exit $LASTEXITCODE }
        Write-Output "Renamed 'csv_supporting_files' -> 'results' using git mv."
    } else {
        $destPath = Join-Path -Path "results" -ChildPath "csv_supporting_files"
        if (Test-Path -LiteralPath $destPath) {
            Write-Output "'results/csv_supporting_files' already exists; merging contents."
            $sourceFull = (Resolve-Path -LiteralPath "csv_supporting_files").Path
            Get-ChildItem -LiteralPath $sourceFull -Recurse | ForEach-Object {
                $rel = $_.FullName.Substring($sourceFull.Length).TrimStart('\')
                $target = Join-Path -Path $destPath -ChildPath $rel
                if ($_.PSIsContainer) { New-Item -ItemType Directory -Path $target -Force | Out-Null } else { Copy-Item -LiteralPath $_.FullName -Destination $target -Force }
            }
            Remove-Item -LiteralPath "csv_supporting_files" -Recurse -Force
            Write-Output "Merged and removed original 'csv_supporting_files'."
        } else {
            Move-Item -LiteralPath "csv_supporting_files" -Destination "results" -Verbose
            Write-Output "Moved 'csv_supporting_files' -> 'results' (filesystem move)."
        }
    }
} else {
    Write-Output "No csv_supporting_files directory found; skipping."
}
