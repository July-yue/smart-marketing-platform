#!/bin/bash

echo "🔧 修复 Vite 主机限制问题"

# 获取当前工作空间的主机名（如果可用）
if [ ! -z "$CODESPACE_NAME" ]; then
    HOST="$CODESPACE_NAME-5173.app.github.dev"
elif [ ! -z "$CLOUDSTUDIO_HOST" ]; then
    HOST="$CLOUDSTUDIO_HOST"
else
    # 从错误信息中提取主机名，或者使用通配符
    HOST="*.cloudstudio.club"
fi

echo "允许的主机: $HOST"

# 更新 Vite 配置
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
      '$HOST',
      'localhost',
      '.cloudstudio.club',
      '.app.github.dev',
      '127.0.0.1',
      '0.0.0.0'
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

echo "✅ Vite 配置已更新"
echo "🔄 重启前端服务..."

pkill -f "vite" 2>/dev/null || true
sleep 2

cd frontend
npm run dev &

echo ""
echo "⏳ 等待前端服务重启..."
sleep 5

echo "🎉 修复完成！现在应该可以正常访问了"
echo "🌐 访问地址: https://127683a5690b400f90c0e119492ee52b—5173.ap-shanghai2.cloudstudio.club"
