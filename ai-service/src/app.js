const express = require('express');
const cors = require('cors');
const fs = require('fs');

const app = express();
app.use(cors());
app.use(express.json());

// 智能端口查找
const findAvailablePort = async (startPort = 3001, maxAttempts = 5) => {
  const net = require('net');
  
  for (let i = 0; i < maxAttempts; i++) {
    const port = startPort + i;
    const available = await new Promise((resolve) => {
      const server = net.createServer();
      server.once('error', () => resolve(false));
      server.once('listening', () => {
        server.close();
        resolve(true);
      });
      server.listen(port);
    });
    
    if (available) {
      console.log(`✅ AI服务使用端口 ${port}`);
      return port;
    }
  }
  
  throw new Error('找不到可用端口');
};

// AI服务路由
app.get('/', (req, res) => {
  res.json({ 
    message: 'AI服务运行正常',
    service: 'smart-marketing-ai',
    port: process.env.PORT || 3001
  });
});

app.post('/recommendations', (req, res) => {
  res.json({
    code: 200,
    data: {
      optimalChannels: ['social_media', 'email', 'influencer'],
      predictedROI: 2.5 + Math.random(),
      confidence: 0.85,
      timestamp: new Date().toISOString()
    }
  });
});

// 启动服务
const startServer = async () => {
  try {
    const port = await findAvailablePort(3001, 5);
    
    app.listen(port, '0.0.0.0', () => {
      console.log(`🤖 AI服务运行在端口 ${port}`);
      
      // 保存端口信息
      fs.writeFileSync('./.port.info', JSON.stringify({ port }, null, 2));
    });
    
    return port;
  } catch (error) {
    console.error('❌ AI服务启动失败:', error.message);
    process.exit(1);
  }
};

if (require.main === module) {
  startServer();
}

module.exports = { app, startServer };