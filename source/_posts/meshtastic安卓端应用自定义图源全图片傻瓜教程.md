---
title: meshtastic安卓端应用自定义图源全图片傻瓜教程
date: 2025-12-19
tags:
categories: meshtastic
---
meshtastic安卓端应用自定义图源全图片傻瓜教程

第一步：确定版本合适，目前（2925.10.13）仅图示版本可自定义图源，注意选取谷歌商店版。

第二步：点击下方地图选项
第三步：点击上方地图选项
第四步：点击管理自定义瓦片源

{% asset_img image1.png "点击管理自定义瓦片源" %}

第五步：点击添加自定义瓦片源

{% asset_img image2.png "添加自定义瓦片源" %}

第六步：名称随意，url需要复合模版规范，同时目前仅支持wgs84坐标系的瓦片图源，例如：ArcGIS图源（84坐标）

{% asset_img image3.png "配置自定义瓦片源" %}

ArcGIS卫星影像
https://server.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}.png

ArcGIS街道
https://server.arcgisonline.com/arcgis/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}.png

保存后在第四步的选项列表中可以自行切换。

{% asset_img image4.png "切换瓦片源" %}

重点：1 目前仅版本号为 2.7.2（29319153）Google支持自定义图源
      2 软件内没有内置坐标系转换，请选取wgs84坐标系的瓦片图源