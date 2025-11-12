import React, { useState, useEffect } from 'react'
import { campaignAPI, analyticsAPI } from '../services/api'
import './Dashboard.css'

const Dashboard = () => {
  const [campaigns, setCampaigns] = useState([])
  const [analytics, setAnalytics] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchDashboardData()
  }, [])

  const fetchDashboardData = async () => {
    try {
      setLoading(true)
      const [campaignsRes, analyticsRes] = await Promise.all([
        campaignAPI.getCampaigns(),
        analyticsAPI.getOverview()
      ])
      
      setCampaigns(campaignsRes.data.campaigns.slice(0, 5)) // 只显示最近5个活动
      setAnalytics(analyticsRes.data)
    } catch (error) {
      console.error('获取仪表盘数据失败:', error)
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return <div className="dashboard-loading">加载数据中...</div>
  }

  return (
    <div className="dashboard">
      <div className="dashboard-header">
        <h1>智能营销平台仪表盘</h1>
        <p>实时监控营销活动效果</p>
      </div>

      {analytics && (
        <div className="metrics-grid">
          <div className="metric-card">
            <h3>总活动数</h3>
            <div className="metric-value">{analytics.totalCampaigns}</div>
          </div>
          <div className="metric-card">
            <h3>进行中活动</h3>
            <div className="metric-value">{analytics.activeCampaigns}</div>
          </div>
          <div className="metric-card">
            <h3>总预算</h3>
            <div className="metric-value">¥{analytics.totalBudget.toLocaleString()}</div>
          </div>
          <div className="metric-card">
            <h3>投资回报率</h3>
            <div className="metric-value">{analytics.performanceMetrics.roi}x</div>
          </div>
        </div>
      )}

      <div className="recent-campaigns">
        <h2>最近营销活动</h2>
        <div className="campaigns-list">
          {campaigns.map(campaign => (
            <div key={campaign.id} className="campaign-card">
              <h4>{campaign.name}</h4>
              <p>{campaign.description}</p>
              <div className="campaign-meta">
                <span className={`status ${campaign.status}`}>{campaign.status}</span>
                <span className="budget">预算: ¥{campaign.budget.toLocaleString()}</span>
              </div>
            </div>
          ))}
        </div>
      </div>

      {analytics && (
        <div className="channel-distribution">
          <h2>渠道分布</h2>
          <div className="channel-chart">
            {Object.entries(analytics.channelDistribution).map(([channel, percentage]) => (
              <div key={channel} className="channel-item">
                <span className="channel-name">{channel}</span>
                <div className="channel-bar">
                  <div 
                    className="channel-fill" 
                    style={{ width: `${percentage}%` }}
                  ></div>
                </div>
                <span className="channel-percentage">{percentage}%</span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}

export default Dashboard