$blogNewDir = "D:\github log\blog new"
$postsDir = "D:\github log\source\_posts"
$tempDir = "D:\github log\temp"

# 创建临时目录
mkdir -Force $tempDir | Out-Null

# 获取所有docx文件
$docxFiles = Get-ChildItem $blogNewDir -Filter "*.docx"

foreach ($docxFile in $docxFiles) {
    Write-Host "Processing: $($docxFile.Name)"
    
    $baseName = $docxFile.BaseName
    $zipPath = "$tempDir\$baseName.zip"
    $extractPath = "$tempDir\$baseName"
    
    # 复制并解压
    Copy-Item $docxFile.FullName $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
    
    # 检查media文件夹
    $mediaPath = "$extractPath\word\media"
    if (Test-Path $mediaPath) {
        # 获取图片
        $images = Get-ChildItem $mediaPath -File
        
        if ($images.Count -gt 0) {
            Write-Host "Found $($images.Count) images"
            
            # 确定目标资产文件夹
            $hexoFolder = $baseName -replace "\s+", "-"
            $destFolder = "$postsDir\$hexoFolder"
            
            if (Test-Path $destFolder) {
                # 复制图片
                foreach ($img in $images) {
                    $destImg = "$destFolder\$($img.Name)"
                    Copy-Item $img.FullName $destImg -Force
                    Write-Host "  Copied: $($img.Name) -> $destFolder"
                }
            } else {
                Write-Host "  Warning: Asset folder not found: $destFolder"
            }
        }
    }
    
    # 清理
    Remove-Item $zipPath -Force
    Remove-Item $extractPath -Recurse -Force
}

# 清理临时目录
Remove-Item $tempDir -Recurse -Force

Write-Host "Image extraction completed!"