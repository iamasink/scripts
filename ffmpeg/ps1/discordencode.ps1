# ps1\BatchConvert.ps1

$VideoExts = '.mp4', '.mkv', '.avi', '.mov', '.wmv', '.flv'
$OutputDir = [Environment]::GetFolderPath('UserProfile') + '\Downloads'
$ParentFolder = Split-Path -Parent $PSScriptRoot

Write-Host "Processing videos in folder: $ParentFolder"
Write-Host "Output folder: $OutputDir"
Write-Host ""

function Upload-Catbox($filePath) {
    $url = 'https://catbox.moe/user/api.php'
    $form = @{
        reqtype      = 'fileupload'
        userhash     = ''  # Optional: add your userhash if you have one
        fileToUpload = Get-Item $filePath
    }

    $response = Invoke-RestMethod -Uri $url -Method Post -Form $form
    return $response
}

Get-ChildItem -Path $ParentFolder -File | Where-Object {
    $VideoExts -contains $_.Extension.ToLower()
} | ForEach-Object {
    $inputFile = $_.FullName
    $baseName = $_.BaseName
    $outputFile = Join-Path $OutputDir "${baseName}_remux.mp4"

    Write-Host "Remuxing: $($_.Name)"
    & ffmpeg -y -i $inputFile -c copy -movflags faststart $outputFile

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Remux successful, deleting original: $($_.Name)"
        Remove-Item $inputFile -Force

        Write-Host "Uploading $outputFile to catbox.moe ..."
        $uploadUrl = Upload-Catbox $outputFile

        if ($uploadUrl) {
            Write-Host "Upload successful! URL:`n$uploadUrl"
            Set-Clipboard -Value $uploadUrl
            Write-Host "URL copied to clipboard."
        }
        else {
            Write-Warning "Upload failed."
        }
    }
    else {
        Write-Warning "Remux failed: $($_.Name)"
        Read-Host "Press Enter to exit"
    }

    Write-Host ""
}

Write-Host "All done!"
