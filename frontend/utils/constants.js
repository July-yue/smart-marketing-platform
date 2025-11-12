// API 基础URL
export const API_CONFIG = {
  BASE_URL: import.meta.env.VITE_API_BASE || '/api',
  AI_BASE_URL: import.meta.env.VITE_AI_BASE || '/ai',
  TIMEOUT: 15000
}

// 营销活动状态
export const CAMPAIGN_STATUS = {
  PLANNING: { value: 'planning', label: '规划中', color: '#f39c12' },
  ACTIVE: { value: 'active', label: '进行中', color: '#27ae60' },
  COMPLETED: { value: 'completed', label: '已完成', color: '#3498db' },
  CANCELLED: { value: 'cancelled', label: '已取消', color: '#e74c3c' }
}

// 营销渠道
export const MARKETING_CHANNELS = {
  SOCIAL_MEDIA: { value: 'social_media', label: '社交媒体' },
  EMAIL: { value: 'email', label: '邮件营销' },
  SEARCH_ENGINE: { value: 'search_engine', label: '搜索引擎' },
  DIRECT: { value: 'direct', label: '直接访问' },
  INFLUENCER: { value: 'influencer_marketing', label: '网红营销' }
}

// 目标受众
export const TARGET_AUDIENCE = {
  YOUNG: { value: 'young', label: '年轻人(18-25)' },
  MIDDLE_AGED: { value: 'middle_aged', label: '中年人(26-45)' },
  SENIOR: { value: 'senior', label: '年长者(45+)' },
  URBAN: { value: 'urban_residents', label: '城市居民' },
  RURAL: { value: 'rural_residents', label: '农村居民' }
}

// 本地存储键名
export const STORAGE_KEYS = {
  TOKEN: 'token',
  USER: 'user',
  THEME: 'theme'
}

// 错误消息
export const ERROR_MESSAGES = {
  NETWORK_ERROR: '网络连接失败，请检查网络设置',
  SERVER_ERROR: '服务器错误，请稍后重试',
  UNAUTHORIZED: '登录已过期，请重新登录',
  FORBIDDEN: '没有权限执行此操作'
}