import React, { useState } from 'react'
import { authAPI } from '../services/api'
import './Login.css'

const Login = ({ onLogin }) => {
  const [isLogin, setIsLogin] = useState(true)
  const [formData, setFormData] = useState({
    username: '',
    email: '',
    password: '',
    confirmPassword: ''
  })
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
    setError('')
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setLoading(true)
    setError('')

    try {
      if (isLogin) {
        // 登录逻辑
        const response = await authAPI.login({
          username: formData.username,
          password: formData.password
        })
        
        if (response.code === 200) {
          onLogin(response.data.user, response.data.token)
        } else {
          setError(response.message || '登录失败')
        }
      } else {
        // 注册逻辑
        if (formData.password !== formData.confirmPassword) {
          setError('密码确认不一致')
          setLoading(false)
          return
        }

        const response = await authAPI.register({
          username: formData.username,
          email: formData.email,
          password: formData.password
        })

        if (response.code === 201) {
          // 注册成功后自动登录
          const loginResponse = await authAPI.login({
            username: formData.username,
            password: formData.password
          })
          
          if (loginResponse.code === 200) {
            onLogin(loginResponse.data.user, loginResponse.data.token)
          }
        } else {
          setError(response.message || '注册失败')
        }
      }
    } catch (error) {
      console.error('认证错误:', error)
      setError(error.response?.data?.message || '网络错误，请稍后重试')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="login-container">
      <div className="login-card">
        <div className="login-header">
          <h1>智能营销平台</h1>
          <p>{isLogin ? '欢迎回来' : '创建新账户'}</p>
        </div>

        {error && (
          <div className="error-message">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="login-form">
          <div className="form-group">
            <label htmlFor="username">用户名</label>
            <input
              type="text"
              id="username"
              name="username"
              value={formData.username}
              onChange={handleChange}
              required
              disabled={loading}
              placeholder="请输入用户名"
            />
          </div>

          {!isLogin && (
            <div className="form-group">
              <label htmlFor="email">邮箱</label>
              <input
                type="email"
                id="email"
                name="email"
                value={formData.email}
                onChange={handleChange}
                required
                disabled={loading}
                placeholder="请输入邮箱地址"
              />
            </div>
          )}

          <div className="form-group">
            <label htmlFor="password">密码</label>
            <input
              type="password"
              id="password"
              name="password"
              value={formData.password}
              onChange={handleChange}
              required
              disabled={loading}
              placeholder="请输入密码"
            />
          </div>

          {!isLogin && (
            <div className="form-group">
              <label htmlFor="confirmPassword">确认密码</label>
              <input
                type="password"
                id="confirmPassword"
                name="confirmPassword"
                value={formData.confirmPassword}
                onChange={handleChange}
                required
                disabled={loading}
                placeholder="请再次输入密码"
              />
            </div>
          )}

          <button 
            type="submit" 
            className="login-button"
            disabled={loading}
          >
            {loading ? '处理中...' : (isLogin ? '登录' : '注册')}
          </button>
        </form>

        <div className="login-footer">
          <button 
            type="button" 
            className="switch-mode"
            onClick={() => setIsLogin(!isLogin)}
            disabled={loading}
          >
            {isLogin ? '没有账户？点击注册' : '已有账户？点击登录'}
          </button>
        </div>

        {/* 测试账号提示 */}
        <div className="test-account">
          <p>测试账号: admin / password</p>
        </div>
      </div>
    </div>
  )
}

export default Login