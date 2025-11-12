const express = require('express');
const router = express.Router();

// 模拟营销活动数据
let campaigns = [
  {
    id: 1,
    name: '双十一大促活动',
    description: '年度最大促销活动',
    budget: 50000,
    status: 'active',
    targetAudience: ['young', 'middle-aged'],
    channels: ['social_media', 'email'],
    startDate: '2024-11-01',
    endDate: '2024-11-11',
    createdAt: '2024-10-25T08:00:00Z',
    createdBy: 1
  }
];

// 获取所有营销活动
router.get('/', (req, res) => {
  res.json({
    code: 200,
    data: {
      campaigns,
      total: campaigns.length
    }
  });
});

// 创建营销活动
router.post('/', (req, res) => {
  try {
    const { name, description, budget, targetAudience, channels, startDate, endDate } = req.body;
    
    if (!name || !budget) {
      return res.status(400).json({
        code: 400,
        message: '活动名称和预算不能为空'
      });
    }

    const newCampaign = {
      id: campaigns.length + 1,
      name,
      description,
      budget,
      status: 'planning',
      targetAudience: targetAudience || [],
      channels: channels || [],
      startDate,
      endDate,
      createdAt: new Date().toISOString(),
      createdBy: 1 // 从token中获取实际用户ID
    };

    campaigns.push(newCampaign);

    res.status(201).json({
      code: 201,
      message: '营销活动创建成功',
      data: newCampaign
    });
  } catch (error) {
    console.error('创建营销活动错误:', error);
    res.status(500).json({
      code: 500,
      message: '服务器内部错误'
    });
  }
});

// 获取活动分析数据
router.get('/analytics', (req, res) => {
  const analyticsData = {
    totalCampaigns: campaigns.length,
    activeCampaigns: campaigns.filter(c => c.status === 'active').length,
    totalBudget: campaigns.reduce((sum, c) => sum + c.budget, 0),
    channelDistribution: {
      social_media: 45,
      email: 30,
      search_engine: 15,
      direct: 10
    },
    performanceMetrics: {
      roi: 3.2,
      conversionRate: 4.5,
      engagementRate: 12.3
    }
  };

  res.json({
    code: 200,
    data: analyticsData
  });
});

module.exports = router;