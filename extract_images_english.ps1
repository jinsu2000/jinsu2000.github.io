$blogNewDir = "D:\github log\blog new"
$postsDir = "D:\github log\source\_posts"
$tempDir = "$env:TEMP\hexo_image_extract"

# Create temp directory
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# Get all docx files
$docxFiles = Get-ChildItem $blogNewDir -Filter "*.docx"

foreach ($docxFile in $docxFiles) {
    Write-Host "Processing: $($docxFile.Name)"
    
    $baseName = $docxFile.BaseName
    $assetFolderName = $baseName -replace "\s+", "-"
    $assetFolder = Join-Path $postsDir $assetFolderName
    
    # Check if asset folder exists
    if (-not (Test-Path $assetFolder)) {
        Write-Host "  Warning: Asset folder not found: $assetFolder"
        continue
    }
    
    # Create unique temp paths
    $tempDocx = Join-Path $tempDir "$baseName.docx"
    $tempZip = Join-Path $tempDir "$baseName.zip"
    $extractPath = Join-Path $tempDir "extract_$baseName"
    
    # Copy docx to temp
    Copy-Item -Path $docxFile.FullName -Destination $tempDocx -Force
    
    # Rename to zip
    Rename-Item -Path $tempDocx -NewName $tempZip
    
    # Extract
    Expand-Archive -Path $tempZip -DestinationPath $extractPath -Force
    
    # Check for media
    $mediaPath = Join-Path $extractPath "word\media"
    if (Test-Path $mediaPath) {
        $images = Get-ChildItem -Path $mediaPath -File | Where-Object {
            $_.Extension -match "\.(png|jpg|jpeg|gif)$"
        }
        
        if ($images) {
            Write-Host "  Found $($images.Count) images"
            
            # Copy images to asset folder
            foreach ($img in $images) {
                $destImg = Join-Path $assetFolder $img.Name
                Copy-Item -Path $img.FullName -Destination $destImg -Force
                Write-Host "    Copied: $($img.Name)"
            }
        } else {
            Write-Host "  No images found"
        }
    } else {
        Write-Host "  No media folder found"
    }
    
    # Cleanup
    Remove-Item -Path $tempZip -Force
    Remove-Item -Path $extractPath -Recurse -Force
}

# Cleanup temp directory
Remove-Item -Path $tempDir -Recurse -Force

Write-Host "Image extraction completed successfully!"
