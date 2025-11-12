const express = require('express');
const cors = require('cors');

// 创建 Express 应用
const app = express();
const PORT = process.env.PORT || 8080;

// 中间件
app.use(cors());
app.use(express.json());

// 请求日志中间件
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// ==================== 基础路由 ====================

// 根路由 - 服务状态检查
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: '智能营销平台后端服务运行正常！',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
    endpoints: {
      'GET /': '服务状态检查',
      'GET /health': '健康检查',
      'GET /api/projects': '获取所有项目',
      'POST /api/projects': '创建新项目',
      'GET /api/projects/:id': '获取项目详情',
      'POST /api/projects/:id/generate-plan': '生成营销方案'
    }
  });
});

// 健康检查路由
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'Smart Marketing Platform API',
    timestamp: new Date().toISOString()
  });
});

// ==================== 数据存储（内存） ====================

let projects = [];
let projectIdCounter = 1;

// ==================== 项目管理 API ====================

// 获取所有项目
app.get('/api/projects', (req, res) => {
  res.json({
    success: true,
    data: projects,
    count: projects.length
  });
});

// 创建新项目
app.post('/api/projects', (req, res) => {
  try {
    const { name, industry, budget, targetAudience, goal } = req.body;
    
    // 验证必填字段
    if (!name || !industry || !targetAudience || !goal) {
      return res.status(400).json({
        success: false,
        error: '缺少必要字段',
        required: ['name', 'industry', 'targetAudience', 'goal']
      });
    }

    // 创建新项目
    const newProject = {
      id: projectIdCounter++,
      name,
      industry,
      budget: budget || '未设置',
      targetAudience,
      goal,
      status: 'created',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    projects.push(newProject);

    res.status(201).json({
      success: true,
      data: newProject,
      message: '项目创建成功'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: '创建项目时发生错误',
      message: error.message
    });
  }
});

// 获取单个项目详情
app.get('/api/projects/:id', (req, res) => {
  const projectId = parseInt(req.params.id);
  const project = projects.find(p => p.id === projectId);
  
  if (!project) {
    return res.status(404).json({
      success: false,
      error: '项目不存在'
    });
  }

  res.json({
    success: true,
    data: project
  });
});

// ==================== AI 营销方案生成 ====================

// 为项目生成营销方案
app.post('/api/projects/:id/generate-plan', (req, res) => {
  try {
    const projectId = parseInt(req.params.id);
    const project = projects.find(p => p.id === projectId);
    
    if (!project) {
      return res.status(404).json({
        success: false,
        error: '项目不存在'
      });
    }

    // 模拟AI生成营销方案（实际项目中这里会调用真实的AI API）
    const marketingPlan = {
      targetAnalysis: `针对 ${project.targetAudience} 的用户群体分析完成`,
      recommendedChannels: ['小红书', '抖音', '微博'],
      contentStrategy: [
        `为 ${project.name} 创建开箱测评内容`,
        `制作使用教程和技巧分享`,
        `发起用户互动挑战活动`
      ],
      timeline: [
        '第1周：内容准备和KOL联系',
        '第2周：启动社交媒体 campaign',
        '第3周：数据分析和优化调整',
        '第4周：效果评估和总结'
      ],
      budgetAllocation: {
        content: '40%',
        advertising: '35%',
        KOL: '25%'
      },
      expectedKPIs: [
        '社交媒体曝光量：50万+',
        '用户互动率：5%+',
        '转化率：2%+'
      ]
    };

    // 更新项目状态
    project.marketingPlan = marketingPlan;
    project.status = 'plan_generated';
    project.updatedAt = new Date().toISOString();

    // 模拟处理时间
    setTimeout(() => {
      res.json({
        success: true,
        data: {
          project: project,
          plan: marketingPlan
        },
        message: '营销方案生成成功'
      });
    }, 1500);

  } catch (error) {
    res.status(500).json({
      success: false,
      error: '生成营销方案时发生错误',
      message: error.message
    });
  }
});

// ==================== 错误处理 ====================

// 404 处理 - 接口不存在
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    error: '接口不存在',
    path: req.originalUrl,
    availableEndpoints: [
      'GET    /',
      'GET    /health',
      'GET    /api/projects',
      'POST   /api/projects',
      'GET    /api/projects/:id',
      'POST   /api/projects/:id/generate-plan'
    ]
  });
});

// 全局错误处理中间件
app.use((error, req, res, next) => {
  console.error('服务器错误:', error);
  res.status(500).json({
    success: false,
    error: '服务器内部错误',
    message: process.env.NODE_ENV === 'development' ? error.message : '请联系管理员'
  });
});

// ==================== 启动服务器 ====================

app.listen(PORT, () => {
  console.log(`
✨ ============================================== ✨
  智能营销平台后端服务器启动成功！
  
  本地访问: http://localhost:${PORT}
  网络访问: http://0.0.0.0:${PORT}
  
  环境: ${process.env.NODE_ENV || 'development'}
  时间: ${new Date().toISOString()}
✨ ============================================== ✨
  `);
});