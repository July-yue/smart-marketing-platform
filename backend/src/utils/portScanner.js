const net = require('net');

/**
 * 检查端口是否可用
 */
const isPortAvailable = (port) => {
  return new Promise((resolve) => {
    const server = net.createServer();
    
    server.once('error', (err) => {
      if (err.code === 'EADDRINUSE') {
        resolve(false); // 端口被占用
      } else {
        resolve(false); // 其他错误
      }
    });
    
    server.once('listening', () => {
      server.close();
      resolve(true); // 端口可用
    });
    
    server.listen(port);
  });
};

/**
 * 查找可用的端口
 */
const findAvailablePort = async (startPort = 3000, maxAttempts = 10) => {
  for (let i = 0; i < maxAttempts; i++) {
    const port = startPort + i;
    const available = await isPortAvailable(port);
    
    if (available) {
      console.log(`✅ 端口 ${port} 可用`);
      return port;
    } else {
      console.log(`⚠️  端口 ${port} 被占用，尝试下一个端口...`);
    }
  }
  
  throw new Error(`在范围 ${startPort}-${startPort + maxAttempts - 1} 内找不到可用端口`);
};

/**
 * 获取当前运行的端口信息
 */
const getPortInfo = () => {
  const usedPorts = [];
  
  // 检查常见端口的占用情况
  const commonPorts = [3000, 3001, 3002, 3003, 5173, 8080, 8081];
  
  return {
    usedPorts,
    commonPorts
  };
};

module.exports = {
  isPortAvailable,
  findAvailablePort,
  getPortInfo
};