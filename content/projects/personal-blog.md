---
title: "个人博客网站"
date: 2024-01-01T12:00:00+00:00
tags: ["Web Development", "Hugo", "GitHub Pages"]
author: "lula"
description: "基于Hugo和PaperMod主题构建的个人博客网站，托管在GitHub Pages上"
showToc: true
TocOpen: false
draft: false
UseHugoToc: true
# cover:
#     image: "images/test.jpg"
#     relative: false
#     caption: "个人博客项目截图"
projectUrl: "https://github.com/luli-lula/luli-lula.github.io"
demoUrl: "https://ailula.top/"
techStack: ["Hugo", "PaperMod", "GitHub Actions", "GitHub Pages"]
status: "Active"
---

## 项目概述

这是我的个人博客网站项目，使用Hugo静态网站生成器和PaperMod主题构建。网站主要用于分享我的学习笔记、读书心得、电影观后感以及技术文章。

## 技术栈

- **静态网站生成器**: Hugo
- **主题**: PaperMod
- **部署方式**: GitHub Pages
- **自动化**: GitHub Actions
- **域名**: 自定义域名 ailula.top

## 主要功能

### 📝 博客系统
- 支持Markdown写作
- 代码高亮显示
- 目录自动生成
- 标签分类系统

### 🎬 多媒体展示
- 电影观影记录（集成豆瓣API）
- 读书笔记展示
- 图片优化处理

### 🔍 搜索功能
- 全站内容搜索
- 基于Fuse.js的模糊搜索
- JSON索引生成

### 📱 响应式设计
- 移动端友好
- 暗黑模式支持
- 优雅的排版布局

## 项目结构

```
luli-lula.github.io/
├── content/          # 内容文件
│   ├── posts/        # 博客文章
│   ├── projects/     # 项目展示
│   └── about.md      # 关于页面
├── assets/           # 静态资源
│   └── images/       # 图片文件
├── themes/PaperMod/  # 主题文件
└── hugo.yaml         # 配置文件
```

## 开发历程

### 初期搭建
- 选择Hugo作为静态网站生成器
- 采用PaperMod主题进行定制
- 配置GitHub Actions自动部署

### 功能扩展
- 添加豆瓣读书/电影展示
- 集成全站搜索功能
- 优化SEO和性能

### 持续优化
- 图片压缩和优化
- 加载速度提升
- 用户体验改进

## 部署方式

项目使用GitHub Actions实现自动化部署：

1. 推送代码到main分支
2. GitHub Actions自动构建Hugo网站
3. 部署到GitHub Pages
4. 自定义域名解析

## 遇到的挑战

### 图片管理
**问题**: 最初将图片放在 `static/images/` 目录，导致Hugo无法正确处理图片资源。

**解决方案**: 将所有图片迁移到 `assets/images/` 目录，并更新引用路径，确保Hugo能够正确处理和优化图片。

### 本地与线上不一致
**问题**: 本地测试正常，但推送到GitHub后线上页面显示异常。

**解决方案**: 
- 检查baseURL配置
- 确保相对路径正确
- 验证GitHub Actions构建日志

## 未来规划

- [ ] 添加评论系统
- [ ] 集成更多第三方服务
- [ ] 优化移动端体验
- [ ] 添加RSS订阅功能
- [ ] 实现文章阅读统计

## 项目链接

- **源码**: [GitHub Repository](https://github.com/luli-lula/luli-lula.github.io)
- **在线预览**: [ailula.top](https://ailula.top/)
- **主题文档**: [PaperMod Theme](https://github.com/adityatelange/hugo-PaperMod)

---

这个项目不仅是我的个人博客，也是我学习前端技术和静态网站开发的实践项目。通过不断的优化和完善，我对Hugo、GitHub Actions、Web性能优化等技术有了更深入的理解。