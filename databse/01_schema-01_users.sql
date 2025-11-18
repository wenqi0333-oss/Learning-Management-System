-- =============================================
-- 01_schema/01_users.sql - 用户相关表
-- =============================================

-- 1. 用户表 (Users)
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    profile_picture VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- 2. 角色表 (Roles)
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(20) UNIQUE NOT NULL CHECK (role_name IN ('Administrator', 'Trainer', 'Student')),
    description TEXT
);

-- 3. 用户角色关联表 (User_Roles)
CREATE TABLE user_roles (
    user_role_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    role_id INTEGER NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, role_id)
);

-- 添加注释
COMMENT ON TABLE users IS '用户基本信息表';
COMMENT ON TABLE roles IS '系统角色表：管理员、教师、学生';
COMMENT ON TABLE user_roles IS '用户与角色的多对多关联表';

COMMENT ON COLUMN users.password_hash IS '密码哈希值,使用bcrypt或类似算法加密';
COMMENT ON COLUMN users.is_active IS '账户是否激活，用于软删除';
COMMENT ON COLUMN roles.role_name IS '角色名称:Administrator, Trainer, Student';