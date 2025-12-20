---
title: 如何用30块diy一个meshtastic太阳能节点
date: 2025-12-19 21:48:46
tags:
categories: meshtastic
---

如何用30块diy一个meshtastic太阳能节点
引言
Meshtastic受困于自身物理限制，想要组建一个信号较好的通信网络就需要在高处放置节点。然而将节点放置在高处，例如山顶或者是楼顶通常意味着有一定的丢失风险。因此如何将太阳能节点的价格尽量降低便成了增加户外节点的一个重要问题。本文将讲述如何组建一个低价但可用的太阳能节点。

选材
太阳能节点可以简易的分为三部分，470mhz天线、太阳能储能装置以及meshtastic设备。
太阳能储能装置
 在拼多多搜索太阳能路灯，选取带按钮的款式。大概价格在8元左右。如遇到清仓价格大概在4元范围内。选取时注意建议选择太阳能板功率在0.5w及以上，电池容量在1000mah以上的款式。

{% asset_img image1.jpeg "太阳能路灯选择示意图" %}

注：经过测试和计算，0.5w太阳能板配合“标称”1500mah的三无电池至少能撑过连续五天的阴雨天，这个数据不尽正确，欢迎各位大佬测试指正。
例：    

{% asset_img image2.jpeg "太阳能路灯示例" %}

Meshtastic设备
 为了尽量节省设备价格，我们需要灵活的通过一些“白嫖”的手段，并且减少不必要的元器件，主打一个能用就行。
 Faketec https://github.com/gargomoma/fakeTec_pcb
名称	价格	来源
电路板	0	嘉立创白嫖
Ht-ra62/ra-01s	21/15.3	淘宝
Promicro nrf52840	12.4	淘宝

 或faketecyuri https://github.com/Yurisu/meshtastic-faketecyuri（推荐）
名称	价格	来源
电路板	0	嘉立创
Ht-ra62	21	淘宝
或Ra-01s	15.3	淘宝
或E22-400M22S	25.8	淘宝
或E22-400MM22S	6.24	淘宝拿样价（两个店铺共能拿4块）
或SX1268ZTR4(433MHz)	12.8	淘宝拿样价（共两块）
Promicro nrf52840	12.4	淘宝
注：感谢群内大佬广州-yuri_su开源的pcb。
天线
名称	价格	来源
Ipex外螺内孔转sma一代	1.6	淘宝
天线	2	lora 433mhz天线470m无线数传315M 510mhz全向高增益外置胶棒SMA-淘宝网 i款

如果选用 faketecyuri+E22-400MM22S（拿样价）+nrf52840+拼多多8元太阳能灯（更便宜的清仓货如果太阳能板功率及电池达标也可以选择），那么一台设备的价格可以低至31.24元甚至更低！
组装
faktec方案或者faketeccyuri方案二选一，把固件刷入到开发板上，具体参考https://meshcn.net/meshtastic-diy-nrf52840-lora-sx1262-setup/#%E4%B8%89%E3%80%81%E5%88%B7%E5%9B%BA%E4%BB%B6-%E7%83%A7%E5%BD%95%E8%BF%87%E7%A8%8B
将lora模块与nrf开发板焊接到电路板上，将太阳能灯的按钮从太阳能电路板拆下，焊接到reset焊点上。 （此处以faktec为例）

{% asset_img image3.jpeg "模块焊接示意图" %}

在太阳能灯外壳上打孔，固定ipex转sma一代转接线，并拧上天线。

{% asset_img image4.jpeg "外壳打孔示意图" %}

拆掉太阳能灯的灯板，接上天线，并将meshtastic设备连接到电池正负极。做好绝缘，将所有东西塞进灯壳里。

{% asset_img image5.jpeg "内部连接示意图" %}

用胶水密封。

{% asset_img image6.jpeg "密封示意图" %}

通常情况下meshtastic设备此时已经开机，如未开机，按一下太阳能灯上的按钮。
至此，一个低廉的meshtastic太阳能节点已经组装完毕，建议在放置到楼顶或山上前先在阳台测试是否正常工作。此外，据广州-yuri_su 大佬测试，不同品牌的节点在远距离通信没有相同节点稳定，因此推荐使用尽量使用同一品牌的模块组网。

如果想要直接购买开箱即用的成品meshtastic太阳能节点的话，目前市面上功能完善而且最便宜的是加特物联的GAT562 Mesh Solar Relay，其使用的0.5w太阳能板与800mah电池足以满足非极端情况下的电量需求，而且预先内置最新的稳定版meshtastic。GAT562 Mesh Solar Relay包含地钉与多向支架，方便在户外或楼顶的安装使用。

{% asset_img image7.jpeg "成品太阳能节点示例" %}


{% asset_img image8.jpeg "完整节点展示" %}

参考：https://meshtastic.org/docs/community/enclosures/rak/harbor-breeze-solar-hack/

