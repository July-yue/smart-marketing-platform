#!/bin/bash

echo "🔍 全面问题诊断"
echo "================"

echo "1. 🌐 网络层检查:"
echo "   前端服务内部访问: $(curl -s http://localhost:5173/ >/dev/null && echo '✅' || echo '❌')"
echo "   后端服务内部访问: $(curl -s http://localhost:3000/health >/dev/null && echo '✅' || echo '❌')"
echo "   AI服务内部访问: $(curl -s http://localhost:3001/ >/dev/null && echo '✅' || echo '❌')"

echo ""
echo "2. 🔧 服务进程检查:"
echo "   前端Vite进程: $(ps aux | grep vite | grep -v grep | wc -l) 个"
echo "   后端Node进程: $(ps aux | grep 'node.*app.js' | grep -v grep | wc -l) 个"
echo "   AI服务进程: $(ps aux | grep 'node.*ai-service' | grep -v grep | wc -l) 个"

echo ""
echo "3. 📡 端口监听检查:"
for port in 5173 3000 3001; do
    status=$(netstat -tulpn 2>/dev/null | grep ":$port " | wc -l)
    if [ $status -gt 0 ]; then
        echo "   端口 $port: ✅ 监听中"
    else
        echo "   端口 $port: ❌ 未监听"
    fi
done

echo ""
echo "4. 🖥️ 前端资源检查:"
if [ -f "frontend/src/App.jsx" ]; then
    echo "   App.jsx: ✅ 存在"
else
    echo "   App.jsx: ❌ 缺失"
fi

if [ -f "frontend/vite.config.js" ]; then
    echo "   vite.config.js: ✅ 存在"
    # 检查配置
    grep -q "allowedHosts" frontend/vite.config.js && echo "   allowedHosts配置: ✅" || echo "   allowedHosts配置: ❌"
else
    echo "   vite.config.js: ❌ 缺失"
fi

echo ""
echo "5. 🔄 服务依赖检查:"
[ -d "frontend/node_modules" ] && echo "   前端node_modules: ✅" || echo "   前端node_modules: ❌"
[ -d "backend/node_modules" ] && echo "   后端node_modules: ✅" || echo "   后端node_modules: ❌"

echo ""
echo "📋 诊断结果:"
echo "如果第1步全部✅，但浏览器无法访问 → Cloud Studio配置问题"
echo "如果第1步有❌ → 对应服务启动问题"
echo "如果第3步有❌ → 端口监听问题"
