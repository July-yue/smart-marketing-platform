import React, { useState } from 'react'
import { Link, useLocation } from 'react-router-dom'
import './Navigation.css'

const Navigation = ({ user, onLogout }) => {
  const [showDropdown, setShowDropdown] = useState(false)
  const location = useLocation()

  const menuItems = [
    { path: '/dashboard', label: '仪表盘', icon: '📊' },
    { path: '/campaigns', label: '营销活动', icon: '🎯' },
    { path: '/analytics', label: '数据分析', icon: '📈' }
  ]

  const isActive = (path) => {
    return location.pathname === path
  }

  return (
    <nav className="navigation">
      <div className="nav-brand">
        <Link to="/dashboard" className="brand-link">
          <span className="brand-icon">🚀</span>
          <span className="brand-text">智能营销平台</span>
        </Link>
      </div>

      <div className="nav-menu">
        {menuItems.map(item => (
          <Link
            key={item.path}
            to={item.path}
            className={`nav-item ${isActive(item.path) ? 'active' : ''}`}
          >
            <span className="nav-icon">{item.icon}</span>
            <span className="nav-label">{item.label}</span>
          </Link>
        ))}
      </div>

      <div className="nav-user">
        <div 
          className="user-info"
          onClick={() => setShowDropdown(!showDropdown)}
        >
          <span className="user-avatar">👤</span>
          <span className="user-name">{user?.username}</span>
          <span className="dropdown-arrow">▼</span>
        </div>

        {showDropdown && (
          <div className="user-dropdown">
            <div className="dropdown-item">
              <span className="dropdown-icon">👤</span>
              个人资料
            </div>
            <div className="dropdown-item">
              <span className="dropdown-icon">⚙️</span>
              设置
            </div>
            <div className="dropdown-divider"></div>
            <div 
              className="dropdown-item logout"
              onClick={onLogout}
            >
              <span className="dropdown-icon">🚪</span>
              退出登录
            </div>
          </div>
        )}
      </div>

      {/* 点击其他地方关闭下拉菜单 */}
      {showDropdown && (
        <div 
          className="dropdown-overlay"
          onClick={() => setShowDropdown(false)}
        ></div>
      )}
    </nav>
  )
}

export default Navigation