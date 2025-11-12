#!/bin/bash

echo "🚀 启动智能营销平台"
echo "===================="

# 清理环境
echo "🧹 清理环境..."
pkill -f "node.*app.js" 2>/dev/null || true
pkill -f "vite" 2>/dev/null || true
sleep 2

# 检查依赖
echo "📦 检查依赖..."
cd backend && npm install && cd ..
cd frontend && npm install && cd ..
cd ai-service && npm install && cd ..

# 启动服务
echo "🔧 启动后端服务 (端口 3000)..."
cd backend
node src/app.js &
BACKEND_PID=$!
cd ..

echo "⏳ 等待后端启动..."
sleep 5

echo "🤖 启动AI服务 (端口 3001)..."
cd ai-service
node src/app.js &
AI_PID=$!
cd ..

echo "⏳ 等待AI服务启动..."
sleep 3

echo "🎨 启动前端服务 (端口 5173)..."
cd frontend
npm run dev &
FRONTEND_PID=$!
cd ..

echo "⏳ 等待前端服务启动..."
sleep 5

# 验证服务状态
echo ""
echo "📊 服务状态:"
curl -s http://localhost:3000/health >/dev/null && echo "✅ 后端服务: 运行正常" || echo "❌ 后端服务: 未运行"
curl -s http://localhost:3001/ >/dev/null && echo "✅ AI服务: 运行正常" || echo "❌ AI服务: 未运行"
curl -s http://localhost:5173/ >/dev/null && echo "✅ 前端服务: 运行正常" || echo "❌ 前端服务: 未运行"

echo ""
echo "🌐 访问信息:"
echo "前端应用: http://localhost:5173"
echo "后端API: http://localhost:3000/health"
echo "AI服务: http://localhost:3001/"
echo ""
echo "📝 测试账号: admin / password"
echo ""
echo "按 Ctrl+C 停止所有服务"

# 等待中断信号
trap "echo ''; echo '🛑 停止服务...'; kill $BACKEND_PID $AI_PID $FRONTEND_PID 2>/dev/null; exit 0" INT
wait
