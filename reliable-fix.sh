#!/bin/bash

echo "🔧 可靠修复脚本 - 解决端口占用和主机限制"

# 清理环境
echo "🧹 步骤1: 清理环境..."
pkill -f "node.*app.js" 2>/dev/null || echo "无Node进程"
pkill -f "vite" 2>/dev/null || echo "无Vite进程"

# 强制释放端口
echo "🔫 步骤2: 释放端口..."
for port in 3000 3001 5173; do
    echo "清理端口 $port..."
    lsof -ti:$port | xargs kill -9 2>/dev/null || true
    fuser -k $port/tcp 2>/dev/null || true
done

sleep 3

# 验证端口已释放
echo "🔍 步骤3: 验证端口状态..."
for port in 3000 3001 5173; do
    if ss -tulpn | grep ":$port " >/dev/null; then
        echo "❌ 端口 $port 仍被占用"
    else
        echo "✅ 端口 $port 可用"
    fi
done

# 更新 Vite 配置
echo "⚙️  步骤4: 更新 Vite 配置..."
cat > frontend/vite.config.js << 'CONFIG'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    port: 5173,
    strictPort: false,  // 改为 false，如果端口被占用会自动找其他端口
    allowedHosts: [
      '127683a5690b400f90c0e119492ee52b—5173.ap-shanghai2.cloudstudio.club',
      '.cloudstudio.club',
      '.ap-shanghai2.cloudstudio.club',
      'localhost',
      '127.0.0.1'
    ],
    proxy: {
      '/api': {
        target: 'http://localhost:3000',
        changeOrigin: true,
        secure: false,
      },
      '/ai': {
        target: 'http://localhost:3001',
        changeOrigin: true,
        secure: false,
      }
    }
  }
})
CONFIG

echo "✅ 配置更新完成"

# 按顺序启动服务
echo "🚀 步骤5: 启动服务..."

echo "启动后端服务..."
cd backend
node src/app.js &
BACKEND_PID=$!
cd ..

echo "等待后端启动..."
sleep 5

echo "启动AI服务..."
cd ai-service
node src/app.js &
AI_PID=$!
cd ..

echo "等待AI服务启动..."
sleep 3

echo "启动前端服务..."
cd frontend
npm run dev &
FRONTEND_PID=$!
cd ..

echo "等待前端服务启动..."
sleep 8

# 检查服务状态
echo ""
echo "📊 服务状态检查:"
curl -s http://localhost:3000/health >/dev/null && echo "✅ 后端服务: 运行正常" || echo "❌ 后端服务: 未运行"
curl -s http://localhost:3001/ >/dev/null && echo "✅ AI服务: 运行正常" || echo "❌ AI服务: 未运行"
curl -s http://localhost:5173/ >/dev/null && echo "✅ 前端服务: 运行正常" || echo "❌ 前端服务: 未运行"

echo ""
echo "🎉 修复完成!"
echo "🌐 访问地址: https://127683a5690b400f90c0e119492ee52b—5173.ap-shanghai2.cloudstudio.club"
echo "📝 账号: admin / password"

# 保持脚本运行
echo ""
echo "按 Ctrl+C 停止所有服务"
wait
