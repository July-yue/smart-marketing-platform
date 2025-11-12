const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const { findAvailablePort, getPortInfo } = require('./utils/portScanner');

const app = express();

// 安全中间件
app.use(helmet());
app.use(cors());
app.use(express.json());

// 限流配置
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100
});
app.use(limiter);

// 健康检查
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    service: 'smart-marketing-backend',
    port: process.env.PORT || 3000
  });
});

// 端口信息接口
app.get('/api/ports', (req, res) => {
  res.json({
    code: 200,
    data: getPortInfo()
  });
});

// 登录接口
app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;
  
  if (username === 'admin' && password === 'password') {
    res.json({
      code: 200,
      message: '登录成功',
      data: {
        token: 'demo-token-' + Date.now(),
        user: {
          id: 1,
          username: 'admin',
          email: 'admin@smartmarketing.com'
        }
      }
    });
  } else {
    res.status(401).json({
      code: 401,
      message: '用户名或密码错误'
    });
  }
});

// 智能启动服务器
const startServer = async () => {
  try {
    // 尝试从环境变量获取端口，否则自动寻找可用端口
    const defaultPort = process.env.PORT || 3000;
    const port = await findAvailablePort(defaultPort, 5);
    
    app.listen(port, '0.0.0.0', () => {
      console.log(`🚀 后端服务运行在端口 ${port}`);
      console.log(`🔗 本地访问: http://localhost:${port}`);
      console.log(`📊 健康检查: http://localhost:${port}/health`);
      
      // 保存端口信息到文件，供其他服务使用
      require('fs').writeFileSync(
        './.port.info', 
        JSON.stringify({ backend: port }, null, 2)
      );
    });
    
    return port;
  } catch (error) {
    console.error('❌ 启动服务器失败:', error.message);
    process.exit(1);
  }
};

// 如果是直接运行这个文件，则启动服务器
if (require.main === module) {
  startServer();
}

module.exports = { app, startServer };