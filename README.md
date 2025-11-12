# 智能营销平台 - 后端API

## 项目简介
基于 Node.js + Express 的智能营销平台后端API服务，提供营销项目管理、AI方案生成等功能。

## 快速开始

1. 安装依赖：
   \`\`\`bash
   npm install
   \`\`\`

2. 启动开发服务器：
   \`\`\`bash
   npm run dev
   \`\`\`

3. 访问API：
   - 服务状态: http://localhost:8080/
   - 健康检查: http://localhost:8080/health

## API接口

### 项目管理
- GET /api/projects - 获取所有项目
- POST /api/projects - 创建新项目
- GET /api/projects/:id - 获取项目详情

### AI功能
- POST /api/projects/:id/generate-plan - 生成营销方案
## 前端开发
前端代码位于 `frontend/` 目录
```bash
cd frontend && npm install && npm run dev
```
```markdown
## 🎨 前端开发

前端代码位于 `frontend/` 目录，使用 React + Vite 构建。

### 快速开始
```bash
cd frontend
npm install
npm run dev