#!/bin/bash

echo "📦 安装项目依赖..."

# 后端依赖
echo "🔧 安装后端依赖..."
cd backend
if [ ! -d "node_modules" ]; then
    npm install
else
    echo "后端依赖已存在"
fi
cd ..

# AI服务依赖
echo "🤖 安装AI服务依赖..."
cd ai-service
if [ ! -d "node_modules" ]; then
    npm install
else
    echo "AI服务依赖已存在"
fi
cd ..

# 前端依赖
echo "🎨 安装前端依赖..."
cd frontend
if [ ! -d "node_modules" ]; then
    npm install
else
    echo "前端依赖已存在"
fi
cd ..

echo "✅ 所有依赖安装完成！"