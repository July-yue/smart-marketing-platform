const fs = require('fs');
const { exec } = require('child_process');

async function checkPortStatus() {
  console.log('🔍 端口状态检查');
  console.log('================\n');

  // 检查端口占用
  const ports = [3000, 3001, 3002, 3003, 5173];
  
  for (const port of ports) {
    const status = await new Promise((resolve) => {
      exec(`netstat -tulpn 2>/dev/null | grep :${port} || ss -tulpn 2>/dev/null | grep :${port} || echo "未占用"`, 
        (error, stdout) => {
          if (stdout.includes('未占用')) {
            resolve('✅ 可用');
          } else {
            resolve('❌ 被占用');
          }
        });
    });
    
    console.log(`端口 ${port}: ${status}`);
  }

  // 检查服务端口文件
  console.log('\n📁 服务端口信息:');
  try {
    if (fs.existsSync('./backend/.port.info')) {
      const backendInfo = JSON.parse(fs.readFileSync('./backend/.port.info', 'utf8'));
      console.log(`后端服务: 端口 ${backendInfo.backend}`);
    } else {
      console.log('后端服务: 未运行');
    }
    
    if (fs.existsSync('./ai-service/.port.info')) {
      const aiInfo = JSON.parse(fs.readFileSync('./ai-service/.port.info', 'utf8'));
      console.log(`AI服务: 端口 ${aiInfo.port}`);
    } else {
      console.log('AI服务: 未运行');
    }
  } catch (error) {
    console.log('读取端口信息失败');
  }
}

checkPortStatus();