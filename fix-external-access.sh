#!/bin/bash
echo "🔧 修复外部访问问题..."

# 停止可能冲突的服务
pkill -f "vite" 2>/dev/null || true
sleep 2

# 获取正确的工作空间ID（从环境变量）
WORKSPACE_ID=$(echo $HOSTNAME | cut -d'-' -f1)
if [ -z "$WORKSPACE_ID" ]; then
    WORKSPACE_ID="12683a5690b40b790c0c119492ee52b"
fi

echo "工作空间ID: $WORKSPACE_ID"

# 更新Vite配置确保外部访问
cat > frontend/vite.config.js << CONFIG
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    port: 5173,
    strictPort: true,
    allowedHosts: [
      '$WORKSPACE_ID-5173.ap-shanghai2.cloudstudio.club',
      'ap-shanghai2.cloudstudio.club',
      '.cloudstudio.club'
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

echo "✅ Vite配置更新完成"

# 重启前端服务
cd frontend
npm run dev &
FRONTEND_PID=$!
cd ..

echo "🔄 前端服务重启中..."
sleep 5

# 验证服务
echo "📡 服务状态检查:"
curl -s http://localhost:5173 >/dev/null && echo "✅ 前端服务运行正常" || echo "❌ 前端服务异常"
curl -s http://localhost:3000/health >/dev/null && echo "✅ 后端服务运行正常" || echo "❌ 后端服务异常"

echo ""
echo "🌐 正确访问地址:"
echo "https://${WORKSPACE_ID}-5173.ap-shanghai2.cloudstudio.club"
echo ""
echo "📝 如果还是404，请在Cloud Studio中:"
echo "1. 点击左侧「端口」图标"
echo "2. 找到5173端口行"
echo "3. 点击「公开」或「仅自己可见」"
echo "4. 复制新生成的URL"
