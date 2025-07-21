---
title: "ADHD专注力训练器"
date: 2024-03-01
description: "帮助ADHD患者提高专注力的计时器应用，配有舒缓森林背景和专注音乐"
tags: ["Next.js 14", "React", "TypeScript", "Tailwind CSS", "健康应用", "无障碍设计"]
type: "web"
status: "已发布"
demo: "https://www.adhd-focus.ailula.top/"
github: "https://github.com/luli-lula/ADHDFocus"
cover:
    image: "/images/adhd-focus-preview.png"
    alt: "ADHD专注力训练器界面截图"
---

## 项目简介

ADHD Focus是一个专门为ADHD（注意力缺陷多动障碍）患者设计的专注力训练器。通过简洁直观的圆形计时器界面和舒缓的森林背景，帮助用户建立更好的专注习惯，提高工作和学习效率。

## 设计理念

### 🧠 为ADHD用户而设计
ADHD患者往往面临注意力分散、时间感知困难等挑战。这个应用从用户实际需求出发：
- **视觉简洁**：避免过多的干扰元素
- **操作直观**：鼠标移动即可设置时间
- **反馈清晰**：优雅的视觉和听觉提示
- **环境舒缓**：森林背景视频营造专注氛围

### 🎯 专注力科学
基于番茄工作法和专注力训练的科学原理：
- 帮助用户建立专注时间块
- 培养时间感知能力
- 通过重复训练强化专注习惯

## 技术栈

- **前端框架**: Next.js 14
- **UI库**: React 18
- **编程语言**: TypeScript
- **样式框架**: Tailwind CSS
- **部署平台**: Vercel
- **版本控制**: Git

## 核心功能

### ⭕ 圆形计时器
- **直观设置**：移动鼠标到外环设置时长（最长60分钟）
- **一键开始**：点击外环即可开始计时
- **实时显示**：清晰的时间显示和进度指示
- **优雅动画**：流畅的倒计时动画效果

### 🎮 简化操作
- **鼠标控制**：移动到外环设置时间，内圈控制暂停/恢复
- **无复杂菜单**：专注核心功能，避免干扰
- **即开即用**：无需注册或复杂设置

### 🌲 沉浸式环境
- **森林背景视频**：循环播放的舒缓森林场景
- **专注音效**：可选的白噪音和自然音
- **视觉反馈**：计时状态的色彩变化

### 📱 响应式设计
- **跨设备支持**：桌面、平板、手机完美适配
- **触控友好**：移动端优化的交互体验
- **性能优化**：快速加载，流畅运行

## 技术实现

### 架构设计
```
src/
├── components/          # React组件
│   ├── Timer/          # 计时器组件
│   ├── Background/     # 背景视频组件
│   └── Controls/       # 控制组件
├── hooks/              # 自定义Hook
├── utils/              # 工具函数
├── styles/             # 样式文件
└── types/              # TypeScript类型
```

### 核心技术挑战

#### 1. 精确的计时器实现
```typescript
// 使用requestAnimationFrame确保精确计时
const useTimer = (duration: number) => {
  const [timeLeft, setTimeLeft] = useState(duration);
  
  useEffect(() => {
    let animationId: number;
    const startTime = Date.now();
    
    const tick = () => {
      const elapsed = Date.now() - startTime;
      const remaining = Math.max(0, duration - elapsed);
      setTimeLeft(remaining);
      
      if (remaining > 0) {
        animationId = requestAnimationFrame(tick);
      }
    };
    
    tick();
    return () => cancelAnimationFrame(animationId);
  }, [duration]);
  
  return timeLeft;
};
```

#### 2. 鼠标位置检测
实现鼠标在圆环上的精确位置检测，用于时间设置：
```typescript
const getAngleFromMouse = (event: MouseEvent, center: Point) => {
  const rect = element.getBoundingClientRect();
  const x = event.clientX - rect.left - center.x;
  const y = event.clientY - rect.top - center.y;
  return Math.atan2(y, x);
};
```

#### 3. 性能优化
- 使用`React.memo`避免不必要的重渲染
- 背景视频懒加载和压缩
- CSS动画替代JavaScript动画提升性能

## 用户体验设计

### 🎨 视觉设计
- **配色方案**：采用绿色系，象征自然和专注
- **字体选择**：使用易读性强的字体
- **动画设计**：微动效增强交互反馈

### 🔊 音效设计
- **开始音效**：轻柔的提示音
- **结束提醒**：温和的完成音
- **背景音**：可选的森林白噪音

### ♿ 无障碍设计
- **键盘导航**：支持键盘控制
- **屏幕阅读器**：ARIA标签支持
- **高对比度**：确保视觉可达性

## 开发过程

### 需求分析
通过研究ADHD用户的实际需求：
- 访谈ADHD患者了解痛点
- 分析现有专注力应用的不足
- 确定核心功能优先级

### 原型设计
- 使用Figma设计交互原型
- 多轮用户测试和反馈收集
- 迭代优化用户界面

### 技术选型
选择Next.js的原因：
- 出色的性能表现
- SEO友好
- 部署便捷
- 活跃的社区支持

## 项目亮点

### 🎯 用户导向
- 专门针对ADHD用户群体
- 基于真实用户需求设计
- 简化操作降低认知负担

### 💻 技术先进
- 使用最新的Next.js 14特性
- TypeScript提供类型安全
- 响应式设计适配所有设备

### 🌿 社会价值
- 关注特殊群体需求
- 推广专注力训练理念
- 开源项目回馈社区

## 用户反馈

> "终于找到一个真正适合ADHD的专注应用了，界面很简洁，不会让我分心。" - Sarah, ADHD患者

> "森林背景很棒，帮助我更好地进入专注状态。" - 李同学

> "操作简单，不需要复杂的设置，很适合我们这种容易分心的人。" - Michael

## 当前进度

- [x] 基础计时器功能
- [x] 圆形UI设计
- [x] 鼠标交互控制
- [x] 森林背景视频
- [x] 响应式适配
- [x] 基础音效
- [ ] 用户数据统计
- [ ] 专注历史记录
- [ ] 多种背景主题
- [ ] 番茄工作法集成

## 下一步计划

### 功能增强
- [ ] 添加专注数据统计和可视化
- [ ] 支持自定义专注时长预设
- [ ] 集成多种背景环境（海洋、雨天等）
- [ ] 添加专注成就系统

### 用户体验
- [ ] 增加渐进式网页应用（PWA）支持
- [ ] 优化移动端体验
- [ ] 添加多语言支持
- [ ] 集成系统通知

### 社区建设
- [ ] 建立用户反馈渠道
- [ ] 开源贡献指南
- [ ] 与ADHD社区合作
- [ ] 医学专业人士背书

## 技术收获

通过这个项目，我在以下方面有了显著提升：
- **用户体验设计**：学会从特殊用户群体角度思考产品
- **Next.js进阶**：掌握了最新的App Router特性
- **TypeScript实践**：在复杂交互中应用类型系统
- **性能优化**：实现流畅的动画和计时器
- **无障碍设计**：关注产品的包容性设计

## 社会意义

这个项目不仅是技术实践，更是对特殊群体的关注：
- 提高ADHD群体的生活质量
- 推广对神经多样性的理解
- 展示技术如何服务社会需求

## 相关链接

- 🔗 [在线体验](https://www.adhd-focus.ailula.top/)
- 📖 [GitHub源码](https://github.com/luli-lula/ADHDFocus)
- 📚 [ADHD相关资料](https://www.additudemag.com/)
- 🧠 [专注力科学研究](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6214273/) 