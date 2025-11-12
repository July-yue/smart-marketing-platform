#!/bin/bash

echo "🔧 修复 Cloud Studio 访问问题..."

# 更新 Vite 配置
echo "更新前端配置..."
cat > frontend/vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    port: 5173,
    strictPort: true,
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
EOF

# 更新后端配置
echo "更新后端配置..."
sed -i "s/app.listen(PORT, () => {/app.listen(PORT, '0.0.0.0', () => {/" backend/src/app.js

# 更新AI服务配置
echo "更新AI服务配置..."
sed -i "s/app.listen(PORT, () => {/app.listen(PORT, '0.0.0.0', () => {/" ai-service/src/app.js

echo "✅ 配置更新完成！"
echo ""
echo "📋 下一步操作："
echo "1. 在 Cloud Studio 左侧点击「端口」"
echo "2. 确保端口 5173、3000、3001 已添加并设置为 Public"
echo "3. 重新启动服务: ./scripts/dev.sh"
echo "4. 点击端口 5173 的「在浏览器中打开」链接"