# 设置工作目录和临时文件夹
$workDir = "D:\github log"
$blogNewDir = "$workDir\blog new"
$tempDir = "$workDir\temp_extract"
$postsDir = "$workDir\source\_posts"

# 创建临时文件夹
if (-not (Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

# 获取所有docx文件
$docxFiles = Get-ChildItem -Path $blogNewDir -Filter "*.docx"

foreach ($docxFile in $docxFiles) {
    Write-Host "处理文件: $($docxFile.Name)"
    
    # 获取文件名（不含扩展名）
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($docxFile.Name)
    
    # 找到对应的txt文件
    $txtFile = Get-ChildItem -Path $blogNewDir -Filter "$baseName.txt"
    if (-not $txtFile) {
        Write-Host "警告: 没有找到对应的txt文件: $baseName.txt"
        continue
    }
    
    # 获取对应的文章资产文件夹名（将空格替换为连字符）
    $hexoFolderName = $baseName -replace "\s+", "-"
    $assetFolder = "$postsDir\$hexoFolderName"
    
    # 检查资产文件夹是否存在
    if (-not (Test-Path $assetFolder)) {
        Write-Host "警告: 资产文件夹不存在: $assetFolder"
        continue
    }
    
    # 创建zip文件名和路径
    $zipFileName = "$baseName.zip"
    $zipFilePath = "$tempDir\$zipFileName"
    
    # 复制docx文件到临时文件夹并重命名为zip
    Copy-Item -Path $docxFile.FullName -Destination $zipFilePath
    
    # 解压zip文件
    $extractPath = "$tempDir\$baseName"
    if (-not (Test-Path $extractPath)) {
        New-Item -ItemType Directory -Path $extractPath | Out-Null
    }
    
    try {
        Expand-Archive -Path $zipFilePath -DestinationPath $extractPath -Force
        
        # 检查是否有图片文件
        $mediaDir = "$extractPath\word\media"
        if (Test-Path $mediaDir) {
            $images = Get-ChildItem -Path $mediaDir -Filter "*.*" | Where-Object { $_.Extension -match "\.(png|jpg|jpeg|gif)$" }
            
            if ($images.Count -gt 0) {
                Write-Host "  找到 $($images.Count) 张图片"
                
                # 复制图片到资产文件夹
                foreach ($image in $images) {
                    $destImagePath = "$assetFolder\$($image.Name)"
                    Copy-Item -Path $image.FullName -Destination $destImagePath -Force
                    Write-Host "    复制图片: $($image.Name) -> $($assetFolder)"
                }
            } else {
                Write-Host "  没有找到图片文件"
            }
        } else {
            Write-Host "  没有找到media文件夹"
        }
    } catch {
        Write-Host "  解压文件失败: $_"
    }
    
    # 清理临时文件
    Remove-Item -Path $zipFilePath -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue
}

# 清理临时文件夹
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "图片提取完成！"