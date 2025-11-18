-- =============================================
-- 00_init.sql - 数据库初始化
-- =============================================
-- 这个文件用于创建数据库和基本配置

-- 创建数据库（如果需要）
-- CREATE DATABASE lms_database;

-- 连接到数据库
-- \c lms_database;

-- 设置时区
SET timezone = 'UTC';

-- 创建扩展（如果需要）
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 显示版本信息
SELECT version();

-- 完成初始化
SELECT 'Database initialization completed!' AS status;