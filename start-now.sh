#!/bin/bash

echo "🚀 立即启动智能营销平台"

# 清理可能冲突的进程
echo "🧹 清理环境..."
pkill -f "node.*3000" 2>/dev/null || true
pkill -f "node.*3001" 2>/dev/null || true
pkill -f "vite" 2>/dev/null || true
sleep 2

# 启动后端服务
echo "🔧 启动后端服务 (端口 3000)..."
cd backend
node src/app.js &
BACKEND_PID=$!
cd ..

echo "⏳ 等待后端服务启动..."
sleep 3

# 启动AI服务
echo "🤖 启动AI服务 (端口 3001)..."
cd ai-service
node src/app.js &
AI_PID=$!
cd ..

echo "⏳ 等待AI服务启动..."
sleep 2

# 启动前端服务
echo "🎨 启动前端服务 (端口 5173)..."
cd frontend
npm run dev &
FRONTEND_PID=$!
cd ..

echo "⏳ 等待所有服务完全启动..."
sleep 5

# 验证服务状态
echo ""
echo "📊 服务状态检查:"
echo -n "后端服务 (3000): "
if curl -s http://localhost:3000/health >/dev/null; then
    echo "✅ 运行正常"
else
    echo "❌ 未运行"
fi

echo -n "AI服务 (3001): "
if curl -s http://localhost:3001/ >/dev/null; then
    echo "✅ 运行正常"
else
    echo "❌ 未运行"
fi

echo -n "前端服务 (5173): "
if curl -s http://localhost:5173/ >/dev/null; then
    echo "✅ 运行正常"
else
    echo "❌ 未运行"
fi

echo ""
echo "🌐 访问信息:"
echo "前端应用: http://localhost:5173"
echo "后端健康检查: http://localhost:3000/health"
echo "AI服务状态: http://localhost:3001/"
echo ""
echo "📝 测试账号:"
echo "用户名: admin"
echo "密码: password"
echo ""
echo "💡 重要: 在Cloud Studio中需要配置端口转发才能从外部访问"
echo "按 Ctrl+C 停止所有服务"

# 等待用户中断
wait
