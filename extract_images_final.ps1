$blogNewDir = "D:\github log\blog new"
$postsDir = "D:\github log\source\_posts"

# 获取所有docx文件
$docxFiles = Get-ChildItem $blogNewDir -Filter "*.docx"

foreach ($docxFile in $docxFiles) {
    Write-Host "正在处理: $($docxFile.Name)"
    
    $baseName = $docxFile.BaseName
    $tempFolder = "$env:TEMP\hexo_$baseName"
    $mediaPath = "$tempFolder\word\media"
    
    # 创建临时文件夹
    New-Item -ItemType Directory -Path $tempFolder -Force | Out-Null
    
    try {
        # 复制docx文件到临时位置
        $tempDocx = "$tempFolder\temp.docx"
        Copy-Item $docxFile.FullName -Destination $tempDocx
        
        # 重命名为zip
        $tempZip = "$tempFolder\temp.zip"
        Rename-Item $tempDocx -NewName $tempZip
        
        # 解压
        Expand-Archive -Path $tempZip -DestinationPath $tempFolder -Force
        
        # 检查是否有图片
        if (Test-Path $mediaPath) {
            $images = Get-ChildItem $mediaPath -File | Where-Object {
                $_.Extension -match "\.(png|jpg|jpeg|gif|bmp)$"
            }
            
            if ($images.Count -gt 0) {
                Write-Host "  找到 $($images.Count) 张图片"
                
                # 确定目标资产文件夹
                $hexoFolder = $baseName -replace "\s+", "-"
                $destFolder = "$postsDir\$hexoFolder"
                
                if (Test-Path $destFolder) {
                    # 复制图片
                    foreach ($img in $images) {
                        $destImg = "$destFolder\$($img.Name)"
                        Copy-Item $img.FullName -Destination $destImg -Force
                        Write-Host "    已复制: $($img.Name) -> $destFolder"
                    }
                } else {
                    Write-Host "  警告: 资产文件夹不存在: $destFolder"
                }
            }
        }
    } catch {
        Write-Host "  处理时出错: $($_.Exception.Message)"
    } finally {
        # 清理临时文件夹
        Remove-Item $tempFolder -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "
图片提取任务完成！"
