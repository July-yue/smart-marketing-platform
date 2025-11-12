#!/bin/bash
echo "🎯 终极诊断脚本"

echo "=== 1. 工作空间信息 ==="
echo "主机名: $HOSTNAME"
echo "工作空间: $(pwd)"
echo "用户: $(whoami)"

echo "=== 2. 服务状态 ==="
ps aux | grep -E "(python|node|vite)" | grep -v grep

echo "=== 3. 网络状态 ==="
ip addr show
echo "---"
netstat -tulpn | grep -E "(8000|8080|5173)"

echo "=== 4. 端口测试 ==="
echo "测试 8000 端口:"
curl -s http://localhost:5173 >/dev/null && echo "✅ 本地5173可访问" || echo "❌ 本地5173不可访问"

echo "=== 5. 外部访问测试 ==="
echo "请手动测试: https://${HOSTNAME}-8000.ap-shanghai2.cloudstudio.club"

echo "=== 6. 建议 ==="
echo "如果外部访问失败，可能是:"
echo "1. Cloud Studio 平台限制"
echo "2. 工作空间网络配置问题"
echo "3. 需要联系技术支持"
