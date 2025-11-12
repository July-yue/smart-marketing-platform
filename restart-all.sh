#!/bin/bash

echo "🔄 完整重启所有服务"

# 停止所有服务
echo "🛑 停止服务..."
pkill -f "node.*app.js" 2>/dev/null || true
pkill -f "vite" 2>/dev/null || true
sleep 3

# 启动后端
echo "🔧 启动后端服务..."
cd backend
node src/app.js &
BACKEND_PID=$!
cd ..

echo "⏳ 等待后端启动..."
sleep 5

# 启动AI服务
echo "🤖 启动AI服务..."
cd ai-service
node src/app.js &
AI_PID=$!
cd ..

echo "⏳ 等待AI服务启动..."
sleep 3

# 启动前端（使用修复后的配置）
echo "🎨 启动前端服务..."
cd frontend
npm run dev &
FRONTEND_PID=$!
cd ..

echo "⏳ 等待前端服务启动..."
sleep 8

echo ""
echo "✅ 所有服务已重启！"
echo "🌐 现在请访问: https://127683a5690b400f90c0e119492ee52b—5173.ap-shanghai2.cloudstudio.club"
echo "📝 使用账号: admin / password"

# 保持运行
wait
