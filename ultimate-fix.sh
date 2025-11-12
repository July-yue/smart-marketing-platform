#!/bin/bash
echo "🎯 终极修复方案..."

# 彻底清理
echo "1. 清理环境..."
pkill -f "node" 2>/dev/null || true
pkill -f "vite" 2>/dev/null || true
pkill -f "npm" 2>/dev/null || true
sleep 5

# 启动后端
echo "2. 启动后端服务..."
cd backend
npm start &
BACKEND_PID=$!
cd ..
sleep 5

# 启动AI服务
echo "3. 启动AI服务..."
cd ai-service
npm start &
AI_PID=$!
cd ..
sleep 3

# 启动前端
echo "4. 启动前端服务..."
cd frontend
# 清理并重新安装
rm -rf node_modules package-lock.json
npm install
npm run dev &
FRONTEND_PID=$!
cd ..

echo "等待服务启动..."
sleep 10

echo ""
echo "=== 最终状态检查 ==="
curl -s http://localhost:3000/health >/dev/null && echo "✅ 后端: http://localhost:3000" || echo "❌ 后端异常"
curl -s http://localhost:3001/ >/dev/null && echo "✅ AI服务: http://localhost:3001" || echo "❌ AI服务异常"
curl -s http://localhost:5173/ >/dev/null && echo "✅ 前端: http://localhost:5173" || echo "❌ 前端异常"

echo ""
echo "🌐 请在Cloud Studio中:"
echo "1. 点击左侧「端口」图标"
echo "2. 找到5173端口"
echo "3. 设置为「公开」或「仅自己可见」"
echo "4. 复制URL并确保格式正确"
echo ""
echo "📧 测试账号: admin / password"
