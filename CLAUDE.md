# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个纯前端库存管理系统，所有功能封装在单个 `index.html` 文件中。系统使用 LocalStorage 进行数据持久化，没有后端服务器支持。

## 核心架构

**应用结构：** 单文件应用（SPA），所有 HTML、CSS、JavaScript 都在 `index.html` 中

**数据流：**
- 用户输入 → JavaScript 处理 → LocalStorage 存储读取 → UI 更新
- 数据格式：`{productCode: {size: quantity}}`
- 日志格式：数组包含操作时间、操作人、货号、尺码、变更量等

**核心类：**
- `InventoryStorage` - 数据存储层，处理 LocalStorage 读写
- `InventoryApp` - 应用控制器，处理用户交互和页面渲染

**主要功能模块：**
1. 查询页面 - 货号模糊搜索，实时显示搜索结果
2. 管理页面 - 库存上传、数据同步、库存管理、操作日志
3. 日志弹窗 - 独立查看操作历史

## 开发命令

```bash
# 本地开发（Python 简单 HTTP 服务器）
python -m http http.server 8080

# Docker 构建
docker build -t inventory-management .

# Docker 运行
docker run -d -p 80:80 --name inventory-app inventory-management
```

## 文件格式

**CSV 导入格式：**
- 必须包含"商品"、"色号"列
- 尺码列：00, XS, S, M, L, XL, XXL 等
- 货号组合：商品_色号

**JSON 导出格式：**
```json
{
  "inventory": { "productCode": { "size": quantity } },
  "logs": [/* 日志数组 */],
  "exportTime": "ISO 时间字符串"
}
```

## 关键实现细节

- 货号搜索不区分大小写，支持模糊匹配
- 日志最多保留 1000 条（新日志插入数组头部）
- 操作员通过 prompt() 弹窗输入，非用户认证
- WeChat 浏览器检测显示提示信息
- 支持数据导入时合并日志（按去重 timestamp）

## 限制和注意事项

- 所有数据存储在浏览器 LocalStorage 中，容量约 5MB
- 不同浏览器/设备之间数据隔离，需要手动导入导出
- 无权限控制系统，任何用户都可以进行所有操作
- 无实时同步，需要手动刷新或重新搜索查看最新数据
