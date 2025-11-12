import axios from 'axios'

const API_BASE = import.meta.env.VITE_API_BASE || '/api'
const AI_BASE = import.meta.env.VITE_AI_BASE || '/ai'

// 创建 axios 实例
const api = axios.create({
  baseURL: API_BASE,
  timeout: 15000,
  headers: {
    'Content-Type': 'application/json'
  }
})

const aiApi = axios.create({
  baseURL: AI_BASE,
  timeout: 20000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器 - 自动添加 token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

aiApi.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// 响应拦截器 - 统一处理错误
const handleResponseError = (error) => {
  if (error.response?.status === 401) {
    // Token过期或无效
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    window.location.href = '/login'
  }
  
  const errorMessage = error.response?.data?.message || 
                      error.message || 
                      '网络错误，请稍后重试'
  
  return Promise.reject(new Error(errorMessage))
}

api.interceptors.response.use(
  (response) => {
    return response.data
  },
  handleResponseError
)

aiApi.interceptors.response.use(
  (response) => {
    return response.data
  },
  handleResponseError
)

// 认证接口
export const authAPI = {
  login: (credentials) => api.post('/auth/login', credentials),
  register: (userData) => api.post('/auth/register', userData),
  logout: () => {
    localStorage.removeItem('token')
    localStorage.removeItem('user')
  },
}

// 用户接口
export const userAPI = {
  getUsers: (params) => api.get('/users', { params }),
  getUserById: (id) => api.get(`/users/${id}`),
  updateUser: (id, data) => api.put(`/users/${id}`, data),
}

// 营销活动接口
export const campaignAPI = {
  getCampaigns: () => api.get('/campaigns'),
  getCampaign: (id) => api.get(`/campaigns/${id}`),
  createCampaign: (data) => api.post('/campaigns', data),
  updateCampaign: (id, data) => api.put(`/campaigns/${id}`, data),
  deleteCampaign: (id) => api.delete(`/campaigns/${id}`),
  getCampaignAnalytics: () => api.get('/campaigns/analytics'),
}

// 分析接口
export const analyticsAPI = {
  getOverview: () => api.get('/analytics/overview'),
  getCampaignPerformance: (campaignId) => api.get(`/analytics/campaigns/${campaignId}`),
  getChannelAnalytics: () => api.get('/analytics/channels'),
}

// AI服务接口
export const aiAPI = {
  getRecommendations: (data) => aiApi.post('/recommendations', data),
  analyzeSentiment: (text) => aiApi.post('/sentiment', { text }),
  predictROI: (campaignData) => aiApi.post('/predict-roi', campaignData),
  getInsights: () => aiApi.get('/insights'),
}

// 健康检查
export const healthAPI = {
  checkBackend: () => api.get('/health'),
  checkAI: () => aiApi.get('/health'),
}

export default api