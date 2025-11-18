-- =============================================
-- 01_schema/03_resources.sql - 学习资源表
-- =============================================

-- 6. 视频资源表 (Videos)
CREATE TABLE videos (
    video_id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    file_path VARCHAR(500) NOT NULL,
    file_size BIGINT,
    duration INTEGER, -- 视频时长（秒）
    thumbnail_path VARCHAR(500),
    uploaded_by INTEGER NOT NULL REFERENCES users(user_id),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    view_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    sequence_order INTEGER DEFAULT 0
);

-- 7. 学习材料表 (Learning_Materials)
CREATE TABLE learning_materials (
    material_id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    material_type VARCHAR(50) NOT NULL CHECK (material_type IN ('PDF', 'Document', 'Presentation', 'Spreadsheet', 'Other')),
    file_path VARCHAR(500) NOT NULL,
    file_size BIGINT,
    uploaded_by INTEGER NOT NULL REFERENCES users(user_id),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    download_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    sequence_order INTEGER DEFAULT 0
);

-- 14. 视频观看记录表 (Video_Views)
CREATE TABLE video_views (
    view_id SERIAL PRIMARY KEY,
    video_id INTEGER NOT NULL REFERENCES videos(video_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    watch_duration INTEGER DEFAULT 0, -- 观看时长（秒）
    completion_percentage DECIMAL(5,2) DEFAULT 0,
    last_position INTEGER DEFAULT 0, -- 上次观看位置（秒）
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed BOOLEAN DEFAULT FALSE
);

-- 15. 材料下载记录表 (Material_Downloads)
CREATE TABLE material_downloads (
    download_id SERIAL PRIMARY KEY,
    material_id INTEGER NOT NULL REFERENCES learning_materials(material_id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    downloaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 添加注释
COMMENT ON TABLE videos IS '课程视频资源表';
COMMENT ON TABLE learning_materials IS '学习材料表(PDF、文档等)';
COMMENT ON TABLE video_views IS '学生视频观看记录和进度追踪';
COMMENT ON TABLE material_downloads IS '学习材料下载记录';

COMMENT ON COLUMN videos.duration IS '视频总时长（秒）';
COMMENT ON COLUMN videos.sequence_order IS '视频在课程中的顺序';
COMMENT ON COLUMN learning_materials.material_type IS '材料类型:PDF, Document, Presentation, Spreadsheet, Other';
COMMENT ON COLUMN video_views.last_position IS '用户上次观看到的位置（秒），用于恢复播放';
COMMENT ON COLUMN video_views.completion_percentage IS '观看完成百分比';