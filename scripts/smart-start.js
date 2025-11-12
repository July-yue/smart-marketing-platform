const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

class ServiceManager {
  constructor() {
    this.services = {};
    this.portInfo = {};
  }

  // 启动服务
  startService(name, command, cwd, env = {}) {
    return new Promise((resolve, reject) => {
      console.log(`🚀 启动 ${name}...`);
      
      const serviceEnv = { ...process.env, ...env };
      const serviceProcess = spawn(command, {
        shell: true,
        cwd,
        env: serviceEnv
      });

      this.services[name] = serviceProcess;

      serviceProcess.stdout.on('data', (data) => {
        console.log(`[${name}] ${data.toString().trim()}`);
      });

      serviceProcess.stderr.on('data', (data) => {
        console.error(`[${name} ERROR] ${data.toString().trim()}`);
      });

      serviceProcess.on('close', (code) => {
        if (code !== 0) {
          console.error(`❌ ${name} 异常退出，代码: ${code}`);
          reject(new Error(`${name} 启动失败`));
        }
      });

      // 等待服务就绪信号
      const readyCheck = setInterval(() => {
        if (this.isServiceReady(name)) {
          clearInterval(readyCheck);
          console.log(`✅ ${name} 启动完成`);
          resolve();
        }
      }, 1000);

      // 超时处理
      setTimeout(() => {
        clearInterval(readyCheck);
        reject(new Error(`${name} 启动超时`));
      }, 30000);
    });
  }

  // 检查服务是否就绪
  isServiceReady(name) {
    // 根据服务名称检查不同的就绪条件
    switch (name) {
      case 'backend':
        return fs.existsSync('./backend/.port.info');
      case 'ai-service':
        return this.portInfo.backend && fs.existsSync('./ai-service/.port.info');
      case 'frontend':
        return this.portInfo.backend && this.portInfo.ai;
      default:
        return false;
    }
  }

  // 读取端口信息
  loadPortInfo() {
    try {
      if (fs.existsSync('./backend/.port.info')) {
        const backendInfo = JSON.parse(fs.readFileSync('./backend/.port.info', 'utf8'));
        this.portInfo.backend = backendInfo.backend;
      }
      if (fs.existsSync('./ai-service/.port.info')) {
        const aiInfo = JSON.parse(fs.readFileSync('./ai-service/.port.info', 'utf8'));
        this.portInfo.ai = aiInfo.port;
      }
    } catch (error) {
      console.warn('读取端口信息失败:', error.message);
    }
  }

  // 停止所有服务
  stopAll() {
    console.log('🛑 停止所有服务...');
    Object.values(this.services).forEach(process => {
      process.kill();
    });
  }
}

// 主启动函数
async function startAllServices() {
  const manager = new ServiceManager();

  try {
    // 启动后端服务
    await manager.startService('backend', 'node src/app.js', './backend');
    manager.loadPortInfo();

    // 启动AI服务
    const backendPort = manager.portInfo.backend;
    await manager.startService('ai-service', 'node src/app.js', './ai-service', {
      BACKEND_URL: `http://localhost:${backendPort}`
    });
    manager.loadPortInfo();

    // 启动前端服务
    const aiPort = manager.portInfo.ai;
    await manager.startService('frontend', 'npm run dev', './frontend', {
      VITE_BACKEND_URL: `http://localhost:${backendPort}`,
      VITE_AI_URL: `http://localhost:${aiPort}`
    });

    console.log('\n🎉 所有服务启动完成！');
    console.log('📊 服务信息:');
    console.log(`  后端服务: http://localhost:${manager.portInfo.backend}`);
    console.log(`  AI服务: http://localhost:${manager.portInfo.ai}`);
    console.log(`  前端服务: http://localhost:5173`);
    console.log('\n按 Ctrl+C 停止所有服务');

    // 处理退出信号
    process.on('SIGINT', () => {
      manager.stopAll();
      process.exit(0);
    });

  } catch (error) {
    console.error('❌ 启动失败:', error.message);
    manager.stopAll();
    process.exit(1);
  }
}

// 运行启动器
if (require.main === module) {
  startAllServices();
}

module.exports = { ServiceManager, startAllServices };