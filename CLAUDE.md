# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Hugo static site blog using the PaperMod theme with **bilingual support (English/Chinese)**. The blog serves as a personal space for lula, featuring posts about life, technology, product management, and personal projects.

**Key Technologies:**
- Hugo v0.139.4+ (static site generator) 
- PaperMod theme (customized fork in `/themes/PaperMod/`)
- YAML configuration (`hugo.yaml`)
- Bilingual content using language suffixes (`.en.md`, `.zh.md`)
- Deployed to GitHub Pages at `https://ailula.top/`

**Multilingual Setup:**
- Default language: English (`defaultContentLanguage: en`)
- Supported languages: English (`en`) and Chinese (`zh`)
- Content organization: Language suffixes (e.g., `post.en.md`, `post.zh.md`)
- Language-specific navigation and profile modes configured

**Main Sections:**
- `content/posts/` - Blog posts (bilingual support)
- `content/projects/` - Personal projects showcase with custom metadata (bilingual)
- `content/` - Static pages (about, books, movies, search) (bilingual)

## Development Commands

```bash
# Start development server
hugo server -D

# Build for production
hugo --minify

# Build with drafts
hugo server -D --buildDrafts

# Clean generated resources
rm -rf public/ resources/
```

## Content Structure

### Blog Posts (`content/posts/`)
Standard Hugo posts with YAML frontmatter:
```yaml
---
title: "Post Title"
date: 2024-01-01T12:00:00+00:00
tags: ["Life", "Reading", "Movies", "Product", "Data-Analyst"]
author: "Me"
showToc: true
TocOpen: false
draft: false
UseHugoToc: true
cover:
    image: "images/filename.jpg"
    relative: false
---
```

### Projects (`content/projects/`)
Custom project showcase with specialized metadata:
```yaml
---
title: "Project Name"
projectUrl: "https://github.com/username/repo"
demoUrl: "https://live-demo.com"
techStack: ["Next.js 14", "React", "TypeScript"]
status: "Active"
description: "Project description"
cover:
    image: "images/project_preview.png"
---
```

Projects use custom partial `layouts/partials/project_meta.html` for rendering metadata with icons and links.

## Theme Customization

**PaperMod Theme Features Enabled:**
- Profile mode homepage with custom buttons
- Table of contents (TOC) 
- Breadcrumbs
- Code copy buttons
- Search functionality (JSON output)
- Busuanzi visitor counter
- Social icons (GitHub, X/Twitter)

**Custom Layouts:**
- `layouts/partials/project_meta.html` - Project metadata display
- Profile mode configuration in `hugo.yaml` under `languages.en.params.profileMode`

## Image Management

**Critical:** All images MUST be stored in `assets/images/` directory, NOT `static/images/`.

Reference format:
- In content: `![Alt text](images/filename.jpg)`
- In frontmatter: `image: "images/filename.jpg"`

Hugo processes images from `assets/` for optimization and generates responsive versions.

## Configuration Files

- `hugo.yaml` - Main Hugo configuration
- `PROJECT_CONFIG_GUIDE.md` - Detailed configuration rules and standards
- `archetypes/default.md` - Post template

**Important Settings:**
- Base URL: `https://ailula.top/`
- Language: Chinese (`zh-cn`) with English sections
- Google Analytics: `G-WMC06JHFDG`
- Search enabled via JSON output format

## Deployment

Site deploys to GitHub Pages. The `public/` directory contains generated static files and should not be manually edited.

## Multilingual Content Management

**File Naming Convention:**
- Use language suffixes: `.en.md` for English, `.zh.md` for Chinese
- Example: `my-post.en.md` and `my-post.zh.md`
- Both versions will be linked automatically by Hugo

**Language Configuration:**
- English: Default language, cleaner URLs (no `/en/` prefix)
- Chinese: Uses `/zh/` URL prefix
- Language switcher appears in site header
- Each language has its own navigation menu and profile mode

## Content Guidelines

- Use emoji in titles for categorization (📖 for books, 🎬 for movies)
- Tags are mixed English/Chinese: English for technical content, Chinese for personal
- Create both language versions for important content
- All external links should include `target="_blank" rel="noopener"`

## Common Tasks

- **New bilingual blog post:** Create both `post-name.en.md` and `post-name.zh.md` in `content/posts/`
- **New bilingual project:** Create both versions in `content/projects/` with project-specific metadata
- **Single language post:** Use appropriate suffix (`.en.md` or `.zh.md`)
- **Add images:** Place in `assets/images/` and reference with `images/filename.jpg`
- **Update theme:** Modify files in `themes/PaperMod/` (custom fork)
- **Search index:** Generated automatically for both languages with JSON output format