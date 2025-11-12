#!/bin/bash

echo "🚀 智能营销平台 - 开发环境启动"
echo "=================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查必要命令
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}错误: 未找到 $1 命令${NC}"
        exit 1
    fi
}

echo -e "${YELLOW}📋 检查环境...${NC}"
check_command node
check_command npm

echo -e "Node.js版本: $(node --version)"
echo -e "npm版本: $(npm --version)"

# 检查依赖是否安装
check_dependencies() {
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}正在安装 $1 依赖...${NC}"
        npm install
    fi
}

# 启动后端服务
echo -e "\n${GREEN}🔧 启动后端服务...${NC}"
cd backend
check_dependencies "后端"
npm start &
BACKEND_PID=$!
cd ..

# 等待后端启动
echo -e "${YELLOW}等待后端服务启动...${NC}"
sleep 5

# 启动AI服务
echo -e "\n${GREEN}🤖 启动AI服务...${NC}"
cd ai-service
check_dependencies "AI服务"
npm start &
AI_PID=$!
cd ..

# 等待AI服务启动
sleep 3

# 启动前端服务
echo -e "\n${GREEN}🎨 启动前端服务...${NC}"
cd frontend
check_dependencies "前端"
npm run dev &
FRONTEND_PID=$!
cd ..

# 显示启动信息
echo -e "\n${GREEN}✅ 所有服务启动完成！${NC}"
echo "=================================="
echo -e "${YELLOW}🌐 前端应用: ${GREEN}http://localhost:5173${NC}"
echo -e "${YELLOW}🔧 后端API: ${GREEN}http://localhost:3000${NC}"
echo -e "${YELLOW}🤖 AI服务: ${GREEN}http://localhost:3001${NC}"
echo -e "${YELLOW}📊 健康检查: ${GREEN}http://localhost:3000/health${NC}"
echo "=================================="
echo -e "${YELLOW}测试账号:${NC}"
echo -e "用户名: ${GREEN}admin${NC}"
echo -e "密码: ${GREEN}password${NC}"
echo "=================================="
echo -e "${YELLOW}按 Ctrl+C 停止所有服务${NC}"

# 优雅退出处理
cleanup() {
    echo -e "\n${YELLOW}正在停止服务...${NC}"
    kill $BACKEND_PID $AI_PID $FRONTEND_PID 2>/dev/null
    echo -e "${GREEN}服务已停止${NC}"
    exit 0
}

trap cleanup INT TERM

# 等待所有进程
wait