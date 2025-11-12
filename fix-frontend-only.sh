#!/bin/bash
echo "🔧 仅修复前端配置..."

# 获取工作空间ID（从现有URL中提取）
WORKSPACE_ID="12683a5690b40b790c0c119492ee52b"

# 备份原配置
cp frontend/vite.config.js frontend/vite.config.js.backup

# 创建修复后的Vite配置
cat > frontend/vite.config.js << CONFIG
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    port: 5173,
    strictPort: false,
    allowedHosts: [
      '${WORKSPACE_ID}-5173.ap-shanghai2.cloudstudio.club',
      'ap-shanghai2.cloudstudio.club',
      '.cloudstudio.club',
      'localhost'
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

echo "✅ 前端配置更新完成"
echo "🔄 请手动重启前端服务："
echo "cd frontend && npm run dev"
