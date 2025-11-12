#!/bin/bash

echo "🧠 智能营销平台 - 智能端口管理启动"
echo "===================================="

# 清理环境
echo "🧹 清理环境..."
pkill -f "node.*app.js" 2>/dev/null || true
pkill -f "vite" 2>/dev/null || true
rm -f backend/.port.info ai-service/.port.info 2>/dev/null || true
sleep 2

# 检查依赖
echo "📦 检查依赖..."
[ ! -d "backend/node_modules" ] && echo "安装后端依赖..." && cd backend && npm install && cd ..
[ ! -d "frontend/node_modules" ] && echo "安装前端依赖..." && cd frontend && npm install && cd ..
[ ! -d "ai-service/node_modules" ] && echo "安装AI服务依赖..." && cd ai-service && npm install && cd ..

# 使用智能启动器
echo "🚀 启动智能服务管理器..."
node scripts/smart-start.js

echo ""
echo "💡 提示: 如果自动启动失败，可以手动启动:"
echo "  终端1: cd backend && node src/app.js"
echo "  终端2: cd ai-service && node src/app.js" 
echo "  终端3: cd frontend && npm run dev"