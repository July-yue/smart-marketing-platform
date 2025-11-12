#!/bin/bash
echo "🔧 完整修复前端..."

cd frontend

echo "1. 创建必要的文件..."
# 创建 index.html
cat > index.html << 'HTML'
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>智能营销平台</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
HTML

# 创建 main.jsx
mkdir -p src
cat > src/main.jsx << 'JSX'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
JSX

# 创建 App.jsx
cat > src/App.jsx << 'JSX'
import React from 'react'

function App() {
  return (
    <div style={{ padding: '20px', textAlign: 'center' }}>
      <h1>🚀 智能营销平台</h1>
      <p>前端服务正在运行...</p>
      <p>请检查控制台获取更多信息</p>
    </div>
  )
}

export default App
JSX

# 创建 CSS
cat > src/index.css << 'CSS'
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

#root {
  width: 100%;
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}
CSS

echo "2. 更新 package.json..."
cat > package.json << 'JSON'
{
  "name": "smart-marketing-frontend",
  "private": true,
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.0.0",
    "vite": "^4.5.0"
  }
}
JSON

echo "3. 重新安装依赖..."
rm -rf node_modules package-lock.json
npm install

echo "4. 构建前端..."
npm run build

echo "5. 启动服务器..."
cd dist
echo "🚀 服务器运行在 http://0.0.0.0:8000"
echo "🌐 请在 Cloud Studio 中配置 8000 端口转发"
python3 -m http.server 8000
