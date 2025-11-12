#!/bin/bash

echo "🔍 获取正确的访问地址"
echo "===================="

# 方法1: 从环境变量获取
echo "方法1 - 环境变量:"
echo "工作空间名称: ${CODESPACE_NAME:-未设置}"
echo "用户: $USER"

# 方法2: 从网络配置获取
echo ""
echo "方法2 - 网络信息:"
hostname -I 2>/dev/null || ip addr show 2>/dev/null | grep "inet " | grep -v "127.0.0.1" | head -1

# 方法3: 检查Cloud Studio端口转发
echo ""
echo "方法3 - Cloud Studio 端口转发:"
echo "请在 Cloud Studio 界面中:"
echo "1. 点击左侧「端口」图标"
echo "2. 找到端口 5173"
echo "3. 复制显示的完整URL（应该以 https:// 开头）"
echo "4. 确保URL格式为: https://[工作空间ID]-5173.ap-shanghai2.cloudstudio.club"

echo ""
echo "💡 重要提示:"
echo "- 工作空间ID应该是一致的"
echo "- URL中只能有一个横线连接端口号"
echo "- 确保使用HTTPS协议"
