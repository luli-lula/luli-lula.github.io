# Project-Specific Configuration Rules

**Essential rules for this Hugo + PaperMod blog to ensure consistency when adding new content or custom pages.**

## 🔧 Project-Specific Settings

### Image Management [[memory:3906200]]
- **Storage Location**: All images MUST be stored in `assets/images/` directory
- **Reference Format**: 
  - In content: `![Alt text](/images/filename.jpg)`
  - For covers: `image: "images/filename.jpg"`
- **Supported**: JPG, PNG, JPEG formats

### Front Matter Standards
**Blog Posts** must include:
```yaml
---
title: "Post Title"
date: 2024-01-01T12:00:00+00:00
tags: ["Category"]
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

**Custom Pages** (like books, movies):
```yaml
---
title: "Page Title"
url: "/page-url"
---
```

### Tag System
- Existing tags: "Life", "Reading", "Movies", "Product", "Data-Analyst"
- Pattern: English for technical, Chinese for personal content
- Support for emojis in titles (📖, 🎬, etc.)

## 🎨 Theme Customizations

### Profile Mode (Homepage)
```yaml
# In hugo.yaml under languages.en.params
profileMode:
  enabled: true
  title: lula
  imageUrl: "https://raw.githubusercontent.com/googlefonts/noto-emoji/master/svg/emoji_u1f469_1f3fb_200d_1f4bb.svg"
  subtitle: "🦌Indie Maker | 📱 ex-Product Manager | 👩🏻‍💻 Learning to code| 🌲 Loving Nature"
  buttons:
    - name: Blog
      url: posts
    - name: Movies
      url: movies/
    - name: Books
      url: books/
```

### Navigation Menu
```yaml
menu:
  main:
    - name: Archive
      url: archives
      weight: 5
    - name: Search
      url: search/
      weight: 10
    - name: Tags
      url: tags/
      weight: 20
    - name: About
      url: about/
      weight: 30
```

### Enabled Features
- `ShowToc: true` (Table of Contents)
- `ShowBreadCrumbs: true`
- `ShowCodeCopyButtons: true`
- `ShowPostNavLinks: true`
- `enableEmoji: true`
- JSON output for search functionality

## 🔍 Search Configuration
Special page setup in `content/search.md`:
```yaml
---
title: "Search"
placeholder: "Search by keywords ..."
layout: "search"
---
```

## 📊 Analytics & Social
- **Google Analytics**: `G-WMC06JHFDG`
- **Busuanzi counter**: enabled
- **Social links**: GitHub (`luli-lula`) and X (`lulaNewJourney`)

## ⚠️ Critical Rules for Custom Pages

1. **New pages outside PaperMod**: Place in `content/` directory with proper front matter
2. **Custom layouts**: Override in `layouts/` directory if needed
3. **Static assets**: Use `static/` for files that don't need processing
4. **Images**: Always use `assets/images/` - never `static/images/` [[memory:3906200]]
5. **URL structure**: Set explicit `url:` in front matter for custom pages

## 🚫 Common Mistakes to Avoid

- Don't put images in `static/images/` - use `assets/images/` [[memory:3906200]]
- Don't forget `UseHugoToc: true` for proper TOC rendering
- Don't mix archetype formats (stick to YAML front matter)
- Don't forget to set `draft: false` for published content

---

*Update this file when adding new custom configurations or pages.*